Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6152C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 16:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9EB61507
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 16:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347984AbhI3QGk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 12:06:40 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:41736 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346913AbhI3QGj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 12:06:39 -0400
Received: by mail-pl1-f175.google.com with SMTP id x8so4359991plv.8
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2021 09:04:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bq2PpcAow8a7SrfGFzj9oQWLcv79ybJiifNV5R6879g=;
        b=oVPq/R49wZJjfNgyedoa/am78IO7G3mRHBgCBsuIyIPC9B1wBSe2W2S6cV+LHOsw4W
         lzSWXQZOhu26tEVPEX/hRWyFIsFI67P3oc98ZV6BT94uZBzoxAr5DSbVZuD+AaA1gE3k
         ElYJXRipx2soDnEc4SWoazesYxxvlL7ywH8WFDnNzF4wK1YEXM35B6IiRSx6fHQCY2K5
         ubd8HNg4/JLHo7Ii1huZtfKGh6CkbpGK4K8idbU/+qI7/ogrnlHJN1CMt3R6/+tCmxDS
         Jrm4WSGdLS4YSjcMlVt6zE2VKI7oyo2ufl5b7Rhdp51GvLyVoFr9O8omt5WYjw+DvFpJ
         MZlQ==
X-Gm-Message-State: AOAM533Q3iBZZrw5pPKNR02FMD9W4HDoH+neqyAA1PF1YNnji3qEBpq4
        wKmsZmURvZzbBg+smoVMp0QUQV0Q8U0=
X-Google-Smtp-Source: ABdhPJwBIsrQA1kVUhCzfd1Wgqft4cEG7POY49NNozElpX1je7Rbk8/YupMHW7H7vODiAtMhMCfrQA==
X-Received: by 2002:a17:90a:ba86:: with SMTP id t6mr471612pjr.1.1633017896492;
        Thu, 30 Sep 2021 09:04:56 -0700 (PDT)
Received: from [10.254.204.66] (50-242-106-94-static.hfc.comcastbusiness.net. [50.242.106.94])
        by smtp.gmail.com with ESMTPSA id q2sm5317993pjo.27.2021.09.30.09.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 09:04:55 -0700 (PDT)
Subject: Re: [PATCH v2 28/84] dc395x: Call scsi_done() directly
To:     Oliver Neukum <oneukum@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-29-bvanassche@acm.org>
 <0b774aaf-1981-2934-adfa-c1d50e43386d@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <71cbada9-f98f-316a-9a58-04b4555234fd@acm.org>
Date:   Thu, 30 Sep 2021 09:04:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0b774aaf-1981-2934-adfa-c1d50e43386d@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/21 3:26 AM, Oliver Neukum wrote:
> On 30.09.21 00:05, Bart Van Assche wrote:
>> Conditional statements are faster than indirect calls. Hence call
>> scsi_done() directly.
> 
> as you are doing this to multiple drivers, is there really a need to
> pass the the function pointer at all?


Hi Oliver,

Thanks for having taken a look. I think the 'done' argument of the queue_command_lck()
functions is already superfluous today. The definition of the DEF_SCSI_QCMD() function
is as follows (without this patch series applied):

#define DEF_SCSI_QCMD(func_name) \
	int func_name(struct Scsi_Host *shost, struct scsi_cmnd *cmd)	\
	{								\
		unsigned long irq_flags;				\
		int rc;							\
		spin_lock_irqsave(shost->host_lock, irq_flags);		\
		rc = func_name##_lck (cmd, cmd->scsi_done);			\
		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
		return rc;						\
	}

In other words, the 'done' argument can be derived easily from the SCSI command pointer.
Do you want me to include a patch in this series that removes the 'done' argument from
the queue_command_lck() functions?

Thanks,

Bart.
