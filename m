From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] mptspi : Bug fix to prevent infinite nested domain
	validation
Date: Mon, 18 Sep 2006 22:56:00 -0400
Message-ID: <1158634560.6390.69.camel@mulgrave.il.steeleye.com>
References: <20060918234453.GA7576@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54997 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752021AbWISDxU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 23:53:20 -0400
In-Reply-To: <20060918234453.GA7576@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-09-18 at 17:44 -0600, Eric Moore wrote:
> This event occurs when dv sends an inquiry to a device,
> and the device never returns, thus timing out.
> This results in a task_abort, followed by host_reset.
> >From host_reset, domain validation is invoked again, and this
> loop repeats itself forever.
> 
> Invoking domain validation from host_reset is required, as
> device go to slowest speed, asyn narrow.
> 
> The fix I propose is to keep a bitwise flag `hd->spi_pending`
> that keeps track of the devices that are in progress of domain
> validation.  Then when host_reset occurs, we see if the
> flag is non-zero, then take a different path which
> program devices to old nego parameters, instead of calling dv
> again.  We do nothing for the device that currently in
> the middle of dv. When `hd->spi_pending` is zero, then
> dv is performed on all devices.
> 
> Please note, we tried using the starget_data->dv_pending flag
> from host_reset, by calling dv for devices not pending,
> and this doesn't work.  The reason is if there is a faulty device
> with a high id, such as 10, by the time we loop back to that id,
> the dv_pending flag was always was zero, thus dv looped again.
> Using the `hd->spi_pending` prevents nested dv, and at
> the same time programs the devices back to previous nego.

Erm, but surely, since reset->dv is fairly standard, this must need a
generic fix.

Can you check this out.  I think it does the right thing gating
spi_dv_device() with a new flag.  The pending flag is more used to
manage scheduled domain validations.   The original idea was that resets
would trigger scheduled dv that would use this flag correctly (and not
be in the direct path of DV).  For some reason the mptspi seems to
manage to entangle DV with the reset inline.

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 29a9a53..92e2bfc 100644
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
 
@@ -907,6 +909,10 @@ spi_dv_device(struct scsi_device *sdev)
 	if (unlikely(scsi_device_get(sdev)))
 		return;
 
+	if (unlikely(spi_dv_in_progress(starget)))
+		return;
+	spi_dv_in_progress(starget) = 1;
+
 	buffer = kzalloc(len, GFP_KERNEL);
 
 	if (unlikely(!buffer))
@@ -938,6 +944,7 @@ spi_dv_device(struct scsi_device *sdev)
  out_free:
 	kfree(buffer);
  out_put:
+	spi_dv_in_progress(starget) = 0;
 	scsi_device_put(sdev);
 }
 EXPORT_SYMBOL(spi_dv_device);


