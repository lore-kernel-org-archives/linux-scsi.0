From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Patch] scsi_error: should not get sense for timeout IO in scsi
 error handler
Date: Wed, 26 Aug 2015 17:31:29 -0700
Message-ID: <1440635489.2196.98.camel@HansenPartnership.com>
References: <OFAF74C95C.6058723F-ON48257E93.00322982-48257E93.00363C6C@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50148 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbbH0Abb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 20:31:31 -0400
In-Reply-To: <OFAF74C95C.6058723F-ON48257E93.00322982-48257E93.00363C6C@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jiang.biao2@zte.com.cn
Cc: linux-scsi@vger.kernel.org

On Fri, 2015-07-31 at 17:52 +0800, jiang.biao2@zte.com.cn wrote:
> scsi_error: should not get sense for timeout IO in scsi error handler
> 
> When an IO timeout occurs, the IO will be aborted in
> scsi_abort_command() and SCSI_EH_ABORT_SCHEDULED will be set. Because
> of that, the SCSI_EH_CANCEL_CMD will be clear in scsi_eh_scmd_add().
> So when scsi error handler starts, it will get sense for this
> timeout IO and the scmd of the IO request will be reused. In that
> case, the scmd may be double released when racing with io_done(),
> which will result in crash.
> SO SCSI_EH_ABORT_SCHEDULED should also be checked when getting sense.
> The bug maybe reproduced when the link between host and disk is
> unstable.
> 
> Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
> Signed-off-by: Long Chun <long.chun@zte.com.cn>
> Reviewed-by: Tan Hu <tan.hu@zte.com.cn>
> Reviewed-by: Chen Donghai <chen.donghai@zte.com.cn>
> Reviewed-by: Cai Qu <cai.qu@zte.com.cn>
> 
> diff -uprN drivers/scsi/scsi_error.c drivers_new/scsi/scsi_error.c

to apply easily, diffs need to start at the top of the tree, please.

> --- scsi/scsi_error.c   2015-07-31 16:03:18.000000000 +0800
> +++ scsi_new/scsi_error.c       2015-07-31 16:29:25.000000000 +0800
> @@ -1156,9 +1156,14 @@ int scsi_eh_get_sense(struct list_head *
>         struct Scsi_Host *shost;
>         int rtn;
> 
> +       /*
> +        * If SCSI_EH_ABORT_SCHEDULED has been set, it is timeout IO,
> +        * should not get sense.
> +        */
>         list_for_each_entry_safe(scmd, next, work_q, eh_entry) {

and here all the tabs have been converted to spaces; you need to read
Documentation/email-clients.txt for details on how to avoid this.

I managed to fix it up this time, but won't again.

James


