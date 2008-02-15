From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Fri, 15 Feb 2008 09:13:16 +0900
Message-ID: <20080215091316H.fujita.tomonori@lab.ntt.co.jp>
References: <20080213214324.GB18227@tpepper-t42p.dolavim.us>
	<20080214204838F.fujita.tomonori@lab.ntt.co.jp>
	<20080214235549.GA19591@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:61850 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167AbYBOAVB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 19:21:01 -0500
In-Reply-To: <20080214235549.GA19591@tpepper-t42p.dolavim.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, tomof@acm.org

On Thu, 14 Feb 2008 15:55:49 -0800
Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:

> On Thu 14 Feb at 20:48:38 +0900 fujita.tomonori@lab.ntt.co.jp said:
> > 
> > I have a slight doubt on the breakup code though I'm not sure you hit
> > the code. Reverting only the breakup part works? The patch is against
> > 2.6.24.
> 
> I've tested this revert you posted.  Essentially the same trace is logged
> (see below).  The machine doesn't die though.  But /proc/scsi/scsi doesn't
> show the hardware and I am getting an additional trace dumped now (see
> futher below).

Thanks. So we surely have a bug in the non-breakup part.

I've just found one bug. Can you try this patch against 2.6.24?

Thanks,

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 5c5a9b2..d8f5eb5 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1575,12 +1575,12 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 	ips_passthru_t *pt;
 	int length = 0;
 	int i, ret;
-        struct scatterlist *sg = scsi_sglist(SC);
+        struct scatterlist *sg;
 
 	METHOD_TRACE("ips_make_passthru", 1);
 
         scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
-                length += sg[i].length;
+                length += sg->length;
 
 	if (length < sizeof (ips_passthru_t)) {
 		/* wrong size */
