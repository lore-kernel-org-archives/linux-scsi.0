Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD6EC77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 18:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346312AbjD1Sge (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 14:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjD1Sgd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 14:36:33 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDDA19B1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 11:36:32 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-517bb11ca34so93230a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 11:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682706991; x=1685298991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0cQ4rgeh1stkUgGDeN5Qu4TIdHGYlAgmmsEtFVLgIHk=;
        b=jRWgWJr4f4BO5EhrLPRBEFiD7HJb1qJa3ntKsn5Kh5/MX8tQsHtizEijcnwBJ9XJXo
         o2cthI0LNhBSipEtXcfVe0foyXPULPmZrXQiMVCsk88oyhbgVw/a2OICt3FXgqhRDFF2
         e78tgF4zzFGVbUyM04I4kzgrvtM2eFBcOmcXgctZa2q6b0oMLmRynjIoEsS91nHVg1CF
         CGY/3hA9uAQopb4g1tnEvY3MMUDhX32ED0uPYXVAD0uF8WCWvJgUe2FZAvFDvKhVKxol
         ptF++Z+VoCsxXsqP5ypRg1wqh3FmUZ5UKMHW4bymlsKdbhWDcj1VKCD4tsD3O3SzI8oU
         c7Fw==
X-Gm-Message-State: AC+VfDwQO3urf9yA1RAMzly66r73j/Q9uPug3KDexVGDd3Z7NVIkv3Mt
        Q9Fzys+U/DyFkwI7zhpicnBAdSK7W2Q=
X-Google-Smtp-Source: ACHHUZ4cUHOThxEpQAicEI4nkKvtfUfliiNCA8JLI1xu/Rd9q19Gp0iLzrZPPmWn8Vxpzv+B4ifWqA==
X-Received: by 2002:a17:902:7484:b0:1a9:72d7:771 with SMTP id h4-20020a170902748400b001a972d70771mr5110281pll.67.1682706991391;
        Fri, 28 Apr 2023 11:36:31 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id q15-20020a170902dacf00b001a9becbd9c3sm1960910plx.134.2023.04.28.11.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 11:36:30 -0700 (PDT)
Message-ID: <e859baeb-f7e7-9d58-bcfd-9b11115bdf0d@acm.org>
Date:   Fri, 28 Apr 2023 11:36:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 4/4] scsi: Trace SCSI sense data
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>,
        Changyuan Lyu <changyuanl@google.com>
References: <20230425233446.1231000-1-bvanassche@acm.org>
 <20230425233446.1231000-5-bvanassche@acm.org> <ZEt/SD/GiqIo5aIm@x1-carbon>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZEt/SD/GiqIo5aIm@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/23 01:09, Niklas Cassel wrote:
> Do we really need to dump the whole sense buffer?
> 
> Shouldn't simply printing the SK, ASC, ASCQ be sufficient?
Hi Niklas,

How about replacing patch 4/4 of this series with the patch below?

Thanks,

Bart.



diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 370ade0d4093..d4a27cd4040b 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -258,9 +258,14 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
  		__field( unsigned int,	prot_sglen )
  		__field( unsigned char,	prot_op )
  		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
+		__field( u8, sense_key )
+		__field( u8, asc )
+		__field( u8, ascq )
  	),

  	TP_fast_assign(
+		struct scsi_sense_hdr sshdr;
+
  		__entry->host_no	= cmd->device->host->host_no;
  		__entry->channel	= cmd->device->channel;
  		__entry->id		= cmd->device->id;
@@ -272,11 +277,21 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
  		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
  		__entry->prot_op	= scsi_get_prot_op(cmd);
  		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
+		if (cmd->result & 0xff &&
+		    scsi_command_normalize_sense(cmd, &sshdr)) {
+			__entry->sense_key = sshdr.sense_key;
+			__entry->asc = sshdr.asc;
+			__entry->ascq = sshdr.ascq;
+		} else {
+			__entry->sense_key = 0;
+			__entry->asc = 0;
+			__entry->ascq = 0;
+		}
  	),

  	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
  		  "prot_sgl=%u prot_op=%s cmnd=(%s %s raw=%s) result=(driver=" \
-		  "%s host=%s message=%s status=%s)",
+		  "%s host=%s message=%s status=%s sense_key=%u asc=%#x ascq=%#x)",
  		  __entry->host_no, __entry->channel, __entry->id,
  		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
  		  show_prot_op_name(__entry->prot_op),
@@ -286,7 +301,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
  		  "DRIVER_OK",
  		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
  		  "COMMAND_COMPLETE",
-		  show_statusbyte_name(__entry->result & 0xff))
+		  show_statusbyte_name(__entry->result & 0xff),
+		  __entry->sense_key, __entry->asc, __entry->ascq)
  );

  DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,

