From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] mptspi : min_period,
	max_offset,max_width,incorrectlyset, resulting domain validation failing
Date: Wed, 20 Sep 2006 12:00:18 -0400
Message-ID: <1158768018.9633.61.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7032CEFC@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23957 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751643AbWITQAX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 12:00:23 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7032CEFC@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-09-20 at 09:24 -0600, Moore, Eric wrote:
> Yes I have a U160 drive that does that.  Meaning sending a ppr
> with factor=0x8, the device returns factor=0xA.  Instead
> if you send a factor=0x9, the device returns factor=0x9.  In 
> other words, spi transport is short changing nego on U160 devices.
> See my proof at the end of this email.

Heh, Quantum Atlas ... I should have known ...

OK, try the attached (it's a rollup of all the heuristics changes we've
been discussing).

> My suggestion is:
> the spi transport layer should only negotiate at factor=0x8
> when both QAS and IUS are enabled in byte 56 of the inquiry 
> data.  When you see both these bits zero, you should start 
> your max speed inquiry test at factor=0x9 instead of factor=0x8. 
> Yeah, I know that this came out in SPI-3, but there really
> are no U160 devices out there that can actually do QAS. 

Actually, there are: there are some fujitsu devices that do QAS at u160.

> Also, another problem is you should only enable QAS when all 
> the devices on a single bus are U320(excluding safte proc).  
> Meaning, if you have mixed mode case, such as U160 mixed with 
> U320, you should disable QAS for all the U320 devices.
> The problem you will face is the U320 devices with QAS enabled
> are going to starve the bus, and the other devices never win 
> arbitration.  I've seen in my test bed using current
> spi transport.  In my environment, I have two U160 devices,
> and one U320 device. Spi transport will enable
> QAS for the U320 device.

This is a user policy thing.  Usually you want QAS set where possible to
speed up the transport ... if you're getting starvation problems, you
can disable it using the parameters.

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 29a9a53..9f070f0 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -47,6 +47,7 @@ #define DV_RETRIES	3	/* should only need
 
 /* Private data accessors (keep these out of the header file) */
 #define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
+#define spi_dv_in_progress(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_in_progress)
 #define spi_dv_mutex(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_mutex)
 
 struct spi_internal {
@@ -240,6 +241,7 @@ static int spi_setup_transport_attrs(str
 	spi_pcomp_en(starget) = 0;
 	spi_hold_mcs(starget) = 0;
 	spi_dv_pending(starget) = 0;
+	spi_dv_in_progress(starget) = 0;
 	spi_initial_dv(starget) = 0;
 	mutex_init(&spi_dv_mutex(starget));
 
@@ -830,28 +832,37 @@ spi_dv_device_internal(struct scsi_devic
 	DV_SET(period, spi_min_period(starget));
 	/* try QAS requests; this should be harmless to set if the
 	 * target supports it */
-	if (scsi_device_qas(sdev))
+	if (scsi_device_qas(sdev)) {
 		DV_SET(qas, 1);
-	/* Also try IU transfers */
-	if (scsi_device_ius(sdev))
+	} else {
+		DV_SET(qas, 0);
+	}
+
+	if (scsi_device_ius(sdev) && spi_min_period(starget) < 9) {
+		/* This u320 (or u640). Set IU transfers */
 		DV_SET(iu, 1);
-	if (spi_min_period(starget) < 9) {
-		/* This u320 (or u640). Ignore the coupled parameters
-		 * like DT and IU, but set the optional ones */
+		/* Then set the optional parameters */
 		DV_SET(rd_strm, 1);
 		DV_SET(wr_flow, 1);
 		DV_SET(rti, 1);
 		if (spi_min_period(starget) == 8)
 			DV_SET(pcomp_en, 1);
+	} else {
+		DV_SET(iu, 0);
 	}
+
 	/* now that we've done all this, actually check the bus
 	 * signal type (if known).  Some devices are stupid on
 	 * a SE bus and still claim they can try LVD only settings */
 	if (i->f->get_signalling)
 		i->f->get_signalling(shost);
 	if (spi_signalling(shost) == SPI_SIGNAL_SE ||
-	    spi_signalling(shost) == SPI_SIGNAL_HVD)
+	    spi_signalling(shost) == SPI_SIGNAL_HVD ||
+	    !scsi_device_dt(sdev)) {
 		DV_SET(dt, 0);
+	} else {
+		DV_SET(dt, 1);
+	}
 	/* Do the read only INQUIRY tests */
 	spi_dv_retrain(sdev, buffer, buffer + sdev->inquiry_len,
 		       spi_dv_device_compare_inquiry);
@@ -907,6 +918,10 @@ spi_dv_device(struct scsi_device *sdev)
 	if (unlikely(scsi_device_get(sdev)))
 		return;
 
+	if (unlikely(spi_dv_in_progress(starget)))
+		return;
+	spi_dv_in_progress(starget) = 1;
+
 	buffer = kzalloc(len, GFP_KERNEL);
 
 	if (unlikely(!buffer))
@@ -938,6 +953,7 @@ spi_dv_device(struct scsi_device *sdev)
  out_free:
 	kfree(buffer);
  out_put:
+	spi_dv_in_progress(starget) = 0;
 	scsi_device_put(sdev);
 }
 EXPORT_SYMBOL(spi_dv_device);
diff --git a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
index 302680c..da180f7 100644
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -53,7 +53,8 @@ struct spi_transport_attrs {
 	unsigned int support_ius; /* support Information Units */
 	unsigned int support_qas; /* supports quick arbitration and selection */
 	/* Private Fields */
-	unsigned int dv_pending:1; /* Internal flag */
+	unsigned int dv_pending:1; /* Internal flag: DV Requested */
+	unsigned int dv_in_progress:1;	/* Internal: DV started */
 	struct mutex dv_mutex; /* semaphore to serialise dv */
 };
 


