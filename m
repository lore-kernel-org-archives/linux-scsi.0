Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1ED1C77B7F
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 14:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbjEHOK5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 10:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbjEHOKx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 10:10:53 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EB233871
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 07:10:33 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so30721475ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 08 May 2023 07:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683555033; x=1686147033;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wL/lQ+ebWLBELLtaVgbCAbZaSbMv0kLy78rO4V6luUg=;
        b=bceDzvbbWZdn+I5um2C1CyzF8KAP0y8MFpwtHi8Z0sIFI2iLLHxyvv2AajvWfjYO22
         juxbsEkyfkqBgaXsfM4g9OZF5yv5fjbMhDC5GRxmezDTOrJMZmsJ3HrlcqD4vC0Slfeb
         5Uxm2HW6rGjYadIb8lj9OxPIShy45st0qRBzoHXSToD67xABw3RrjxHST+xcVwD7imw7
         62MYSONVa8w37M9tPUl9RMvG0ZHIISp2h72b5W6rAxxPltSSc3YcVXcWpwNALGvezSRB
         m+a3QtW6gXFqIkz4mwZLQb91BnRAFFfX1/N8J/2M3jAszl2sOHAiSrNOtQvVVUDe9m2W
         Xhfg==
X-Gm-Message-State: AC+VfDzjZb0Mpv7ohztmJ6CZ1rhwK0iskqLIJB/IuRKOm+9f1l0qyoVP
        a+0pIpc3vGkxcZRMtdWCf24=
X-Google-Smtp-Source: ACHHUZ78+dH6IGczQ2Kb6FOeaULcX2gkG0sjndt45DRYy3C4cMYOpmbqhmg1/ZsqMxvh29JGTB9k6A==
X-Received: by 2002:a17:902:e5d2:b0:1ac:7969:cd67 with SMTP id u18-20020a170902e5d200b001ac7969cd67mr3919558plf.21.1683555032882;
        Mon, 08 May 2023 07:10:32 -0700 (PDT)
Received: from [172.20.11.151] ([173.214.130.133])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902dac500b001ac40488620sm5284727plx.92.2023.05.08.07.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 07:10:32 -0700 (PDT)
Message-ID: <51b8899b-473e-5a3b-2c84-f97e7f12943d@acm.org>
Date:   Mon, 8 May 2023 07:10:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Changyuan Lyu <changyuanl@google.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-4-bvanassche@acm.org>
 <20230508140553.GD9720@t480-pf1aa2c2.fritz.box>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230508140553.GD9720@t480-pf1aa2c2.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/8/23 07:05, Benjamin Block wrote:
> On Wed, May 03, 2023 at 04:06:52PM -0700, Bart Van Assche wrote:
>> @@ -285,11 +290,22 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>>   		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
>>   		__entry->prot_op	= scsi_get_prot_op(cmd);
>>   		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
>> +		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> 
> Can't hurt to have these explicitly here, but these checks are also
> done by `scsi_command_normalize_sense()` AFAICT.

Niklas requested these checks as a performance optimization.

> 
>> +		    scsi_command_normalize_sense(cmd, &sshdr)) {
>> +			__entry->sense_key = sshdr.sense_key;
>> +			__entry->asc = sshdr.asc;
>> +			__entry->ascq = sshdr.ascq;
>> +		} else {
>> +			__entry->sense_key = 0;
>> +			__entry->asc = 0;
>> +			__entry->ascq = 0;
>> +		}
>>   	),
>>   
>>   	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
>>   		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
>> -		  "result=(driver=%s host=%s message=%s status=%s)",
>> +		  "result=(driver=%s host=%s message=%s status=%s "
>> +		  "sense_key=%u asc=%#x ascq=%#x))",
> 
> In SPC, these are all in base 16, and some existing functions in
> `scsi_logging.c` format Sense Key as base 16. We probably should keep
> this consistent and also format Sense Key with `%#x`.

I can make this change.

Thanks,

Bart.

