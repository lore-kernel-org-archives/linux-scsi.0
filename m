From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH scsi-misc-2.6] allow REPORT LUN scanning even for LUN 0 PQ of 3
Date: Fri, 23 Sep 2005 15:52:08 -0700
Message-ID: <20050923225208.GA21452@us.ibm.com>
References: <20050830224316.GA11210@us.ibm.com> <1127272270.5589.57.camel@mulgrave> <20050921221500.GA24993@us.ibm.com> <20050922001035.GA27643@us.ibm.com> <1127439208.4818.94.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:30664 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751333AbVIWWw1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2005 18:52:27 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id j8NMq3JL017516
	for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2005 18:52:03 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8NMr0XO544800
	for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2005 16:53:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j8NMqQMf020072
	for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2005 16:52:26 -0600
Content-Disposition: inline
In-Reply-To: <1127439208.4818.94.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: hare@suse.de, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Sep 22, 2005 at 08:33:28PM -0500, James Bottomley wrote:
> On Wed, 2005-09-21 at 17:10 -0700, Patrick Mansfield wrote:
> > I removed the bad "!" on !scsi_device_get(), and the "insmod ./scsi_debug.ko
> > max_luns=3' found 2 sd's as expected.
> 
> Fixed it.
> 
> > But, scsi_debug module count is still at 1. Removing (via delete attr) the
> > 2 scsi_debug devices, and module count is still at 1. So probably still a
> > missing scsi_device_put(). I'm trying to debug a bit more.
> 
> Found it and fixed that too ... missing a put after the find_device.

OK, works fine now ...

> +static inline void scsi_destroy_sdev(struct scsi_device *sdev)
> +{
> +	if (sdev->host->hostt->slave_destroy)
> +		sdev->host->hostt->slave_destroy(sdev);
> +	transport_destroy_device(&sdev->sdev_gendev);
> +	put_device(&sdev->sdev_gendev);

One nit ... get rid of the inline, as the code path is not performance
critical.

Also, note that most devices won't behave as scsi_debug configured as
previosly patched: it had PQ !=0 for LUN 0, but then put LUN 0 in REPORT
LUN output.

So, we hit the already existing sdev case in James' patch. 

But it was a good test case :)

For the record, here's a scsi_debug patch to not have LUN 0 show up, and
not have it in REPORT LUNS output.

--- linux-2.6.14-rc2-git1/drivers/scsi/scsi_debug.c	2005-08-28 17:51:48.000000000 -0700
+++ jamesb-lun0-replun/drivers/scsi/scsi_debug.c	2005-09-23 15:33:51.000000000 -0700
@@ -619,7 +619,10 @@ static int resp_inquiry(struct scsi_cmnd
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
 	memset(arr, 0, SDEBUG_MAX_INQ_ARR_SZ);
-	pq_pdt = (scsi_debug_ptype & 0x1f);
+	if (devip->lun == 0)
+		pq_pdt = 0x7f; /* XXX hack no LUN 0 */
+	else
+		pq_pdt = (scsi_debug_ptype & 0x1f);
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
@@ -946,7 +949,7 @@ static int resp_report_luns(struct scsi_
 			    struct sdebug_dev_info * devip)
 {
 	unsigned int alloc_len;
-	int lun_cnt, i, upper;
+	int lun_cnt, i, upper, lun;
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
 	int select_report = (int)cmd[2];
 	struct scsi_lun *one_lun;
@@ -960,18 +963,18 @@ static int resp_report_luns(struct scsi_
 	}
 	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
 	memset(arr, 0, SDEBUG_RLUN_ARR_SZ);
-	lun_cnt = scsi_debug_max_luns;
+	lun_cnt = scsi_debug_max_luns - 1;
 	arr[2] = ((sizeof(struct scsi_lun) * lun_cnt) >> 8) & 0xff;
 	arr[3] = (sizeof(struct scsi_lun) * lun_cnt) & 0xff;
 	lun_cnt = min((int)((SDEBUG_RLUN_ARR_SZ - 8) /
 			    sizeof(struct scsi_lun)), lun_cnt);
 	one_lun = (struct scsi_lun *) &arr[8];
-	for (i = 0; i < lun_cnt; i++) {
-		upper = (i >> 8) & 0x3f;
+	for (i = 0, lun = 1; i < lun_cnt; i++, lun++) {
+		upper = (lun >> 8) & 0x3f;
 		if (upper)
 			one_lun[i].scsi_lun[0] =
 			    (upper | (SAM2_LUN_ADDRESS_METHOD << 6));
-		one_lun[i].scsi_lun[1] = i & 0xff;
+		one_lun[i].scsi_lun[1] = lun & 0xff;
 	}
 	return fill_from_dev_buffer(scp, arr,
 				    min((int)alloc_len, SDEBUG_RLUN_ARR_SZ));

-- Patrick Mansfield
