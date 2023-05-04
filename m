Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F44C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 08:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjEDIKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 04:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjEDIJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 04:09:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA53313D
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 01:07:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DA0702096E;
        Thu,  4 May 2023 08:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683187657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NnL8NZPBMolSdjUelmdcqcn0w/R6DEshhHG7Tcq6D+k=;
        b=PWglZTEbk7U5/Q2166GobPL8p0/oyIl9v5OO858deo6olagKjpc7h7L0iebspw7cEWcauD
        DkB6cauVzQMNUIwhX4TA/Z2BvtmjUMg5TYsXKW8hL+slJqSfjZEOj9LL1mspiYO2bYAnqM
        A2xMoMU+j4X6G5RYt/aRycyVhJ6rSO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683187657;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NnL8NZPBMolSdjUelmdcqcn0w/R6DEshhHG7Tcq6D+k=;
        b=ItMhegL+bwcj11My59kHYXjkWd+QStlnIDjImj2Kcxzse5xBBxCgsg1g0HsXxddoOFkAyu
        bpt4oDJaMCp7TkDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF1E8133F7;
        Thu,  4 May 2023 08:07:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6hdQLslnU2TSKgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 04 May 2023 08:07:37 +0000
Message-ID: <18ee41a2-b314-6040-4790-6239d8838068@suse.de>
Date:   Thu, 4 May 2023 10:07:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Changyuan Lyu <changyuanl@google.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-4-bvanassche@acm.org>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230503230654.2441121-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/23 01:06, Bart Van Assche wrote:
> If a command fails, SCSI sense data is essential to determine why it
> failed. Hence make the sense key, ASC and ASCQ codes available in the
> ftrace output.
> 
> Cc: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   include/trace/events/scsi.h | 21 +++++++++++++++++++--
>   1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index a2c7befd451a..6c4be1ebe268 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -269,9 +269,14 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>   		__field( unsigned int,	prot_sglen )
>   		__field( unsigned char,	prot_op )
>   		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
> +		__field( u8, sense_key )
> +		__field( u8, asc )
> +		__field( u8, ascq )
>   	),
>   
>   	TP_fast_assign(
> +		struct scsi_sense_hdr sshdr;
> +
>   		__entry->host_no	= cmd->device->host->host_no;
>   		__entry->channel	= cmd->device->channel;
>   		__entry->id		= cmd->device->id;
> @@ -285,11 +290,22 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>   		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
>   		__entry->prot_op	= scsi_get_prot_op(cmd);
>   		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> +		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> +		    scsi_command_normalize_sense(cmd, &sshdr)) {
> +			__entry->sense_key = sshdr.sense_key;
> +			__entry->asc = sshdr.asc;
> +			__entry->ascq = sshdr.ascq;
> +		} else {
> +			__entry->sense_key = 0;
> +			__entry->asc = 0;
> +			__entry->ascq = 0;
> +		}
>   	),
>   
Hmm. All this business with scsi_normalize_sense(); there are 15 
instances calling scsi_normalize_sense(), and half of it are calling it
with scmd->sense-buffer.
Makes one wonder if we shouldn't add fields in the scmd structure, and
do the decoding always...

But for another time, I guess.

>   	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
>   		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
> -		  "result=(driver=%s host=%s message=%s status=%s)",
> +		  "result=(driver=%s host=%s message=%s status=%s "
> +		  "sense_key=%u asc=%#x ascq=%#x))",

Why two closing braces?

>   		  __entry->host_no, __entry->channel, __entry->id,
>   		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>   		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
> @@ -299,7 +315,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>   		  "DRIVER_OK",
>   		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
>   		  "COMMAND_COMPLETE",
> -		  show_statusbyte_name(__entry->result & 0xff))
> +		  show_statusbyte_name(__entry->result & 0xff),
> +		  __entry->sense_key, __entry->asc, __entry->ascq)
>   );
>   
>   DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
Cheers,

Hannes

