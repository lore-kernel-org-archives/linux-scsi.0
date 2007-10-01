From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 16/16] gdth: !use_sg cleanup and use of scsi accessors
Date: Mon, 01 Oct 2007 16:06:59 +0200
Message-ID: <4700FF03.2060507@panasas.com>
References: <46FFFC8C.6080804@panasas.com> <47000467.70707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10754 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751400AbXJAOKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2007 10:10:21 -0400
In-Reply-To: <47000467.70707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30 2007 at 22:17 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>   gdth_execute() will issue an internal, none scsi-standard commands
>   onto __gdth_queuecommand(). Since it is not recommended to set
>   struct scsi_cmnd IO members in llds, gdth now uses internal IO
>   members for IO. In the case of gdth_execute() these members will be
>   set properly. In case the command was issued from scsi-ml
>   (by gdth_queuecommand) they will be set from scsi IO accessors.
> 
>   * define gdth IO accessors and use them throughout the driver.
>   * use an sg-of-one in gdth_execute() and fix gdth_special_cmd()
>     accordingly.
>   * Clean the not use_sg code path and company
> 
> Signed-off-by Boaz Harrosh <bharrosh@panasas.com>
OK My usual bug in this one. I woke up in the middle
of the night with this in my head.

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -517,4 +517,5 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     sg_init_one(&one_sg, gdtcmd, sizeof(*gdtcmd));
     gdth_set_sglist(scp, &one_sg);
+    gdth_set_sg_count(scp, 1);
     gdth_set_bufflen(scp, sizeof(*gdtcmd));
     scp->cmd_len = 12;

I will resend the patch as reply to this one

Boaz
