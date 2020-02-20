Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57445C11D12
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 16:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39256208C4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 16:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgBTQ2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 11:28:19 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37207 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbgBTQ2T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2020 11:28:19 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so2167182pfn.4
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2020 08:28:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oxz6C3dKFO9CzkuaAEMikP5JOe7URCIE/6uFToYyeys=;
        b=rAsoH6yEauq/q6pwKpvnIxYswNtg/fJtzXZAWeKgJOFU3M8wamkukdtZHuyXL94VDN
         47h2akxL/Ih5jGoEJdfv1Cghemuydv/XxYC7SFk8iMjItzHEC8zQXDMWan8fDno69bFc
         xufyFKvobRMg1qKFGKI+2o9ZZi8TqJBB725ThwwJC4YkAMxrsCKIEPg0Iz4Nm+nB7A2y
         Erd84D8hmctcFswMFHzLdi0b7H8zhx6U10cEZ3p/FAOOjTCeAercfsP6zx19eS+/C3rz
         AsCpv6Cta9Vmz+YGuGWIIunTm2nEOwBv+FTRtx1CthFUE/qlmjZhYyLDNoo3+pR4Ce2J
         qzDQ==
X-Gm-Message-State: APjAAAXAnlY3+PsEKBd0owhFspnxHoGqOKTsAWcblKrMMik/bHkAkDJl
        3lfVIrBdGI+kwMIjIzE5c0VhXwAx
X-Google-Smtp-Source: APXvYqyOodspx/iVBOT91SxuS5iMEvmuCSXw3KImkrqPIf+WcLHk2lNrs7bTMHLyRgm4PO63kenNXQ==
X-Received: by 2002:a63:8f59:: with SMTP id r25mr35265464pgn.280.1582216098256;
        Thu, 20 Feb 2020 08:28:18 -0800 (PST)
Received: from ?IPv6:2620:15c:2d1:206:bfe1:be9c:5072:1789? ([2620:15c:2d1:206:bfe1:be9c:5072:1789])
        by smtp.gmail.com with ESMTPSA id w8sm65250pfn.186.2020.02.20.08.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 08:28:17 -0800 (PST)
Subject: Re: [PATCH v3 4/5] qla2xxx: Convert MAKE_HANDLE() from a define into
 an inline function
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200220043441.20504-1-bvanassche@acm.org>
 <20200220043441.20504-5-bvanassche@acm.org>
 <20200220082155.c2dwknz2hcvwhwcg@beryllium.lan>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e91c9277-8a98-6e08-6219-005d03ee97c8@acm.org>
Date:   Thu, 20 Feb 2020 08:28:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220082155.c2dwknz2hcvwhwcg@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/20/20 12:21 AM, Daniel Wagner wrote:
> On Wed, Feb 19, 2020 at 08:34:40PM -0800, Bart Van Assche wrote:
>> -#define MAKE_HANDLE(x, y) ((uint32_t)((((uint32_t)(x)) << 16) | (uint32_t)(y)))
>> +static inline uint32_t make_handle(uint16_t x, uint16_t y)
>> +{
>> +	return ((uint32_t)x << 16) | y;
>> +}
>>   
>>   /*
>>    * I/O register
>> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
>> index 47bf60a9490a..1816660768da 100644
>> --- a/drivers/scsi/qla2xxx/qla_iocb.c
>> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
>> @@ -530,7 +530,7 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct qla_qpair *qpair,
>>   			int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
>>   			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
>>   			mrk24->vp_index = vha->vp_idx;
>> -			mrk24->handle = MAKE_HANDLE(req->id, mrk24->handle);
>> +			mrk24->handle = make_handle(req->id, mrk24->handle);
> 
> The type of mrk24->handle is uint32_t and make_handle() is using type
> uint16_t. Shouldn't the argument type for the y argument be uint32_t
> as well?

Hi Daniel,

As one can see in __qla2x00_marker() a value is assigned to 
mrk24->handle() by __qla2x00_alloc_iocbs(). That function calls 
qla2xxx_get_next_handle() to determine the 'handle' value. The 
implementation of that last function is as follows:

uint32_t qla2xxx_get_next_handle(struct req_que *req)
{
	uint32_t index, handle = req->current_outstanding_cmd;

	for (index = 1; index < req->num_outstanding_cmds; index++) {
		handle++;
		if (handle == req->num_outstanding_cmds)
			handle = 1;
		if (!req->outstanding_cmds[handle])
			return handle;
	}

	return 0;
}

Since 'num_outstanding_cmds' is a 16-bit variable I think that 
guarantees that the code quoted in your e-mail passes a 16-bit value as 
the second argument to make_handle().

Additionally, if the second argument to make_handle() would be larger 
than 0x10000, the following code from qla2x00_status_entry() would map 
sts->handle to another queue and another command than those through wich 
the command was submitted to the firmware:

	handle = (uint32_t) LSW(sts->handle);
	que = MSW(sts->handle);
	req = ha->req_q_map[que];

Bart.
