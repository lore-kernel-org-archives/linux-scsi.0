Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF3CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 17:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350445AbiD1RFJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 13:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiD1RFI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 13:05:08 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3462EB820E
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 10:01:53 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y14so4753144pfe.10
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 10:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ju+l3S1iaxXfPaiONN5rj688nU2amR5+PS7DPdJMT1o=;
        b=mI62b/DvHr6Af1JeznLsMmekK8SzD2v6G4na5+RuxGlBvImS/VuTkBk9LdlWUV78mk
         zvhvE90+aee6JS8Yv3hJA4Qw3eo3aiHntxDdlnzcEWoZ/mmmJQoW3gqs+z8DK4dFLMNh
         qSjDiK7LcfyxIRIUy4/kbHEL78g1DnHS9XnZZoffFwlzVZb2aEuj9sdFjaIA+XzM/Xf0
         4rtYVbyDLkZlG8J4W8xdXx9ZXyadj9iWvIkXE3XgycvYz6KAfHutxqGs5/dmsGGuRX3P
         5gTa1gb1qBogP0ry7B5EguN89LREICuGzhJ2RvAkQGq6anmfZCIaQfo0PkhDKcDLM2Dp
         Dxcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ju+l3S1iaxXfPaiONN5rj688nU2amR5+PS7DPdJMT1o=;
        b=HlVhRPnzJGn8pvpV6CgsQE9AW22AoDvhdXpVP6zQvmwOXILAhehJFv1/G0LrREGSXq
         jwLm9tO4r2v/YKlDGr/nAt+gPddOoDOdCZF1Z858NzeUJQJUTZMrrIYQvy+EejMxs19n
         iiWq98sLHhYGzCKqJQJHYQjU2PHMUOg8PBGPuqwbw/pSVEH0AQfcbYfwcQH/DwTT+c5W
         yWDByNY5TyPZTA18/YeC0fZpzzkiRYEHzJw4aClBZXcyoO5XLftH+/GXO3I54horU6jf
         hSDjhDgP5BoVxE/GhOAEZvne4N8V/dSI09hYJrCEYqrE5W0LaLHjTFWuCL2vdwS/Yss8
         /TMA==
X-Gm-Message-State: AOAM533HZN+KZpS9U6Hmm8tFC17rPvJed/dmfjXahlPeCfKTTrP0MFE4
        7sc23pCVxQa+LoS41DYRl2s=
X-Google-Smtp-Source: ABdhPJw6jsNsePuuHpPrkv0vgsRJ02ieG7ew6Y/LTGI6TuAkk0BQUEa8Ym4rjud9v+wLiN1U80xP1A==
X-Received: by 2002:a05:6a00:996:b0:50b:76b8:3bb1 with SMTP id u22-20020a056a00099600b0050b76b83bb1mr35859729pfg.9.1651165312644;
        Thu, 28 Apr 2022 10:01:52 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w23-20020a17090a029700b001d94c194a67sm7538856pja.18.2022.04.28.10.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 10:01:51 -0700 (PDT)
Message-ID: <d3600da9-db62-6278-9ff7-5e324f1df16c@gmail.com>
Date:   Thu, 28 Apr 2022 10:01:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [EXT] Re: [RFC] scsi_transport_fc: Add an additional flag to
 fc_host_fpin_rcv()
Content-Language: en-US
To:     Anil Gurumurthy <agurumurthy@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <20220414064358.21384-1-njavali@marvell.com>
 <9bd6ce27-d984-efc4-c907-babca6897300@gmail.com>
 <CO6PR18MB4500B4DCD9652CF8533EEF41AFEE9@CO6PR18MB4500.namprd18.prod.outlook.com>
 <PH0PR18MB465429EF9237D67E30F38306A3FD9@PH0PR18MB4654.namprd18.prod.outlook.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <PH0PR18MB465429EF9237D67E30F38306A3FD9@PH0PR18MB4654.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/27/2022 8:44 PM, Anil Gurumurthy wrote:
> 
> -----Original Message-----
> From: James Smart <jsmart2021@gmail.com>
...
>> @@ -925,6 +926,9 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
>>    		case ELS_DTAG_CONGESTION:
>>    			fc_fpin_congn_stats_update(shost, tlv);
>>    		}
>> +		/* If the event has not been processed, mark path as marginal */
>> +		if (!hba_process)
>> +			fc_host_port_state(shost) = FC_PORTSTATE_MARGINAL;
> 
>> This doesn't seem right.  I would think the meaning of "processing"
>> varies by FPIN type, thus the flag should be passed to the different xxx_update routines and any decision would be made there - or at least the decision is made within the type case statement above. For example:
>> FC_PORT_STATE_MARGINAL should only be set with Link Integrity events.
> 
> The thought process here was that the driver sets the values according to way it has processed. So if the driver does not process Link Integrity FPIN, the same can be set accordingly.

ok - but that didn't address what I said.  As defined right now, 
"hba_process" means "if set to 0, mark port state MARGINAL. if set 
non-zero, ignore".  There is no validation of what type of FPIN, etc.

Given "hba_process" is ambigous, I think you should change that name to 
"info_only" or "log_only" or something similar - e.g. what we want to 
communicate is the following: normally fpin_rcv is normally called with 
this flag set to false and that the transport or daemon can act on the 
event.  But the new flag, when true, should only log or display the 
event but not act on it.

>> However, we currently leave the decision of marginality to be determined and managed by the external daemon that processes the fpin events. So the patch needs to expand the fpin event to include the driver processed flag in the event data. Please add this to >fc_host_post_fc_event().
>> Given we leave marginality to the daemon, who will now know whether the driver handled the fpin or not, I don't think fpin_rcv should include the changing of portstate to marginal.
> 
> Sure, we could do that, but I thought the daemon was not a permanent solution and eventually the decision on marginality would be taken within the kernel.

Currently the daemon is the only thing in existence and it was only 
recently added.  When the functionality goes into the kernel, we can 
adapt anything then. What does not make sense is immediately changing 
state as of an (any) FPIN receive.

Regardless - to support the deamon and as "log only or not" is 
meaningful, please add it to the event.

-- james

