Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B51BC388F3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 00:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A1952168B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 00:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfJAAmx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 20:42:53 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:58866 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfJAAmw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 20:42:52 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 8D90B27E62;
        Mon, 30 Sep 2019 20:42:48 -0400 (EDT)
Date:   Tue, 1 Oct 2019 10:42:48 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Damien Le Moal <damien.lemoal@wdc.com>
cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH V2] scsi: save/restore command resid for error handling
In-Reply-To: <20190927221602.27080-1-damien.lemoal@wdc.com>
Message-ID: <alpine.LNX.2.21.1910011011410.13@nippy.intranet>
References: <20190927221602.27080-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 28 Sep 2019, Damien Le Moal wrote:

> When a non-passthrough command is terminated with CHECK CONDITION,
> request sense is executed by hijacking the command descriptor. Since
> scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() do not save/restore the
> original command resid, the value returned on failure of the original
> command is lost and replaced with the value set by the execution of the
> request sense command. This value may in many instances be unaligned to
> the device sector size, causing sd_done() to print a warning message
> about the incorrect unaligned resid before the command is retried or
> aborted.
> 
> Fix this problem by saving the original command resid in struct
> scsi_eh_save using scsi_eh_prep_cmnd() and restoring it in
> scsi_eh_restore_cmnd(). In addition, to make sure that the request sense
> command is executed with a correctly initialized command structure, also
> reset resid to 0 in scsi_eh_prep_cmnd() after saving the original
> command resid value in struct scsi_eh_save.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> 
> Changes from V1:
> * Dropped patch 2
> * Add resid reset in scsi_eh_prep_cmnd()
> 
>  drivers/scsi/scsi_error.c | 3 +++
>  include/scsi/scsi_eh.h    | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1c470e31ae81..f53828bf7ad7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -967,6 +967,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
>  	ses->data_direction = scmd->sc_data_direction;
>  	ses->sdb = scmd->sdb;
>  	ses->result = scmd->result;
> +	ses->resid = scsi_get_resid(scmd);
>  	ses->underflow = scmd->underflow;
>  	ses->prot_op = scmd->prot_op;
>  	ses->eh_eflags = scmd->eh_eflags;
> @@ -977,6 +978,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
>  	memset(scmd->cmnd, 0, BLK_MAX_CDB);
>  	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
>  	scmd->result = 0;
> +	scsi_set_resid(scmd, 0);
>  
>  	if (sense_bytes) {
>  		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
> @@ -1029,6 +1031,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
>  	scmd->sc_data_direction = ses->data_direction;
>  	scmd->sdb = ses->sdb;
>  	scmd->result = ses->result;
> +	scsi_set_resid(scmd, ses->resid);

When saving and restoring state, perhaps it makes more sense to bypass the 
higher level getter/setter API? Open-coded assignment statements are 
already prevalent here, rather than calls to e.g. scsi_set_prot_op(), 
set_msg_byte() etc. (There may be no code elsewhere that could tell the 
difference, but we can't use "private" members to prove it, unlike C++.)

>  	scmd->underflow = ses->underflow;
>  	scmd->prot_op = ses->prot_op;
>  	scmd->eh_eflags = ses->eh_eflags;
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index 3810b340551c..9caa9b262a32 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -32,6 +32,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
>  struct scsi_eh_save {
>  	/* saved state */
>  	int result;
> +	unsigned int resid;

There seems to be an inconsistency here. A signed int would be consistent 
with the getter and setter helpers. Whereas, if you open-coded the 
assignments instead, your unsigned int would make sense because 
scsi_request.resid_len really is an unsigned int.

-- 

>  	int eh_eflags;
>  	enum dma_data_direction data_direction;
>  	unsigned underflow;
> 
