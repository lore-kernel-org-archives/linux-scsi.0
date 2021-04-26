Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC280C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 07:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9CCB61131
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 07:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhDZHGJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 03:06:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:38384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhDZHGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 03:06:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B25FCABC7;
        Mon, 26 Apr 2021 07:05:27 +0000 (UTC)
Subject: Re: [PATCH 15/39] scsi: add get_{status,host}_byte() accessor
 function
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-16-hare@suse.de>
 <4711fd13-a8a7-0cc3-c56f-53d65c47d45f@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <d95957cd-624e-84c0-0826-7f109323f697@suse.de>
Date:   Mon, 26 Apr 2021 09:05:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <4711fd13-a8a7-0cc3-c56f-53d65c47d45f@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 5:47 AM, Bart Van Assche wrote:
> On 4/23/21 4:39 AM, Hannes Reinecke wrote:
>> +static inline unsigned char get_status_byte(struct scsi_cmnd *cmd)
>> +{
>> +	return cmd->result & 0xff;
>> +}
>> +
>>  static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
>>  {
>>  	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
>> @@ -326,6 +331,11 @@ static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
>>  	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
>>  }
>>  
>> +static inline unsigned char get_host_byte(struct scsi_cmnd *cmd)
>> +{
>> +	return (cmd->result >> 16) & 0xff;
>> +}
> 
> How about using 'u8' instead of 'unsigned char' to make it more clear
> that the returned value is an integer instead of a character? Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 
I like it; 'unsigned char' is more in-line with the overall coding
style, but is quite lengthy and cumbersome.

Will be changing it for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
