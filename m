Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DD7C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbjDYXxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbjDYXw7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA33AB230
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D7362A21
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 23:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CA4C433D2;
        Tue, 25 Apr 2023 23:52:55 +0000 (UTC)
Date:   Tue, 25 Apr 2023 19:52:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>,
        Changyuan Lyu <changyuanl@google.com>
Subject: Re: [PATCH 4/4] scsi: Trace SCSI sense data
Message-ID: <20230425195253.2f3a45a4@gandalf.local.home>
In-Reply-To: <20230425233446.1231000-5-bvanassche@acm.org>
References: <20230425233446.1231000-1-bvanassche@acm.org>
        <20230425233446.1231000-5-bvanassche@acm.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 25 Apr 2023 16:34:46 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> If a command fails, SCSI sense data is essential to determine why it
> failed. Hence make the SCSI sense data available in the ftrace output.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/trace/events/scsi.h | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index a2c7befd451a..bb5f31504fbb 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -269,6 +269,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__field( unsigned int,	prot_sglen )
>  		__field( unsigned char,	prot_op )
>  		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
> +		__array(unsigned char,  sense_data, SCSI_SENSE_BUFFERSIZE)
>  	),
>  
>  	TP_fast_assign(
> @@ -285,11 +286,13 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
>  		__entry->prot_op	= scsi_get_prot_op(cmd);
>  		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> +		memcpy(__entry->sense_data, cmd->sense_buffer,
> +		       SCSI_SENSE_BUFFERSIZE);
>  	),
>  
>  	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
>  		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
> -		  "result=(driver=%s host=%s message=%s status=%s)",
> +		  "result=(driver=%s host=%s message=%s status=%s%s%s)",
>  		  __entry->host_no, __entry->channel, __entry->id,
>  		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>  		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
> @@ -299,7 +302,17 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		  "DRIVER_OK",
>  		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
>  		  "COMMAND_COMPLETE",
> -		  show_statusbyte_name(__entry->result & 0xff))
> +		  show_statusbyte_name(__entry->result & 0xff),
> +		  __entry->result & 0xff ? " sense_data=" : "",
> +		  __entry->result & 0xff ?
> +		  ({
> +			  unsigned int len = SCSI_SENSE_BUFFERSIZE;
> +
> +			  while (len && __entry->sense_data[len - 1] == 0)
> +				  len--;
> +			  __print_hex(__entry->sense_data, len);
> +		  })

The above will absolutely break user space parsing.

The TP_printk() isn't supposed to be too complex, as user space uses it to
figure out how to parse the data.

If you are doing the above, I'm guessing that most of the time the
sense_data doesn't use the 96 bytes (defined by SCSI_SENSE_BUFFERSIZE).

Perhaps instead, you should make result a dynamic array, and save writing
a large amount of zeros into the precious ring buffer?

static int sense_data_size(unsigned char *array)
{
	int len = SCSI_SENSE_BUFFERSIZE;

	for (len && array[len - 1] == 0)
		len--;

	return len;
}

		__dynamic_array(unsigned char, sense_data, result_size(cmd->sense_data)

	[..]


		memcpy(__get_dynamic_array(sense_data), cmd->sense_data, result_size(cmd->sense_data));

// Yes, I need a way to pass the "result_size" from the initialization to
// the allocation.


	[..]


		__print_hex(__get_dynamic_array(sense_data),
			    __get_dynamic_array_len(sense_data))

Or something like that.

-- Steve


> +		  : "")
>  );
>  
>  DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
