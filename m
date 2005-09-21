From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH scsi-misc-2.6] allow REPORT LUN scanning even for LUN 0 PQ of 3
Date: Wed, 21 Sep 2005 15:15:00 -0700
Message-ID: <20050921221500.GA24993@us.ibm.com>
References: <20050830224316.GA11210@us.ibm.com> <1127272270.5589.57.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:64676 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965105AbVIUWPr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 18:15:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j8LMFYU8032519
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 18:15:34 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8LMFY8D081628
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 18:15:34 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j8LMFYPu002137
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 18:15:34 -0400
Content-Disposition: inline
In-Reply-To: <1127272270.5589.57.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: hare@suse.de, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James -

On Tue, Sep 20, 2005 at 10:11:10PM -0500, James Bottomley wrote:
> Sorry, I didn't really like either patch.

OK :-/

> The problem, essentially is this rather evil return refcounted sdev
> under certain circumstances.  What I didn't like about your patch was
> that you actually extended it to be under more circumstances.

I don't follow the "certain circumstances", but OK.

> The correct fix, I think, is to make scsi_report_lun_scan() actually
> work on the target device; this will also set us up nicely for WLUN
> scans if they prove necessary.  This being well into -rc for linux, I'll

Yes, I agree. I was forward porting the patch from some time ago, and
didn't think the starget was far enough along.

> resist the strong urge to take the hatchet to the sdev returning code
> and stomach the duplication of scsi_level and resist the urge to
> investigate dumping the rescan parameter ... they can all be fixed
> properly after 2.6.14.

Yes for scsi_level. 

With your patch, rescan could go away, but I do not like the lookup for
each LU when we first scan a target (I think O(n^2)? i.e. for many LUs,
1000 + 999 + ... + 1 and except for LUN 0, none will match). Long term we
could avoid this, maybe still special case LUN 0 in scsi_report_lun_scan();
we could also auto-set the rescan setting (and not externalize it) when
there no LU's on a target (or host) at the start

> How does the attached look (and more importantly, does it work)?

I tried it on top of scsi-rc-fixes, it oopsed (non-scsi) on ppc/JS20, so I
patched on a 2.6.14-rc2 git tree from sept 21, that boots up OK on IDE.

But the module refcount stays non-zero for scsi-debug, probably
scsi_device_put/get. I am still debugging ...

Did your try it with the scsi_debug patch? And multiple insmod/rmmod of
it?

This chunk (and "insmod scsi_debug.ko max_luns=5" or such):

--- scsi-misc-2.6/drivers/scsi/scsi_debug.c	2005-07-26 11:08:51.000000000 -0700
+++ lun0-replun-scsi-misc-2.6/drivers/scsi/scsi_debug.c	2005-07-27 18:24:05.000000000 -0700
@@ -619,7 +619,10 @@ static int resp_inquiry(struct scsi_cmnd
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
 	memset(arr, 0, SDEBUG_MAX_INQ_ARR_SZ);
-	pq_pdt = (scsi_debug_ptype & 0x1f);
+	if (devip->lun == 0)
+		pq_pdt = 0x7f;
+	else
+		pq_pdt = (scsi_debug_ptype & 0x1f);
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,

-- Patrick Mansfield
