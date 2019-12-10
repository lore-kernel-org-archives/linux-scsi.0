Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5434EC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 20:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F42F2073B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 20:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfLJUpk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 15:45:40 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38705 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJUpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 15:45:40 -0500
Received: by mail-qt1-f195.google.com with SMTP id z15so4085339qts.5
        for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2019 12:45:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8dX+Jxe331a2FHiFRTnsVyTA4UEUAOek3e2/cuR9icg=;
        b=mW8eUOLAnXMX1cf+PthqTbc1eOQxjPtymdyx1cgK99CEqjnSgsFnQCnVOW/RRgtiP4
         oI7ONv3pk++w2AUf6lESA3MdanSv/s4izsqGfcOLfjx4/Upc/nsrHMhzZrWjL/GWweDd
         ejIeSd1egZ46gX16OWhUsnDdDUa88LCZwgcYC4hJFMGn8suu5kJeUAwg7MXKbi2Da30b
         z6Eanjtw/c0WSkNC+lNP37p+y9W067JQrOKe8R+Ar9oOfTgNzKfXZyGCme/r7fQI191F
         KZwHNLshAINtZyQmQjcKi7aC4uF+Vm+gvRYqgnaZUSTL3rKj64TElJgQO487x0uhEWZx
         sj3w==
X-Gm-Message-State: APjAAAWTgTCem7kCubBZeO+pbaTluvvgFkaZ55kmBq5yZzNbcJsbMyIZ
        nIoasFLLOuktHc7sh0jE1pApJa7q
X-Google-Smtp-Source: APXvYqwZ1yzdmGDapSF/b9cxTTd3a89oeK/l/tJvSqgFaSQ35VbmBuZon7F5E4HTx1g/CFkJLdaLwg==
X-Received: by 2002:ac8:248d:: with SMTP id s13mr11401141qts.240.1576010739884;
        Tue, 10 Dec 2019 12:45:39 -0800 (PST)
Received: from ?IPv6:2620:0:1003:512:62e9:2658:28c:bd76? ([2620:0:1003:512:62e9:2658:28c:bd76])
        by smtp.gmail.com with ESMTPSA id 53sm1519992qtu.40.2019.12.10.12.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:45:38 -0800 (PST)
Subject: Re: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI commands
To:     Martin Wilck <mwilck@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-3-bvanassche@acm.org>
 <f7a05e5696b1942b3303e20fe0e6891bc9a61090.camel@suse.de>
 <658d52fb-c614-9ee5-f95f-81509a9de771@acm.org>
 <1755e03c0aba7c684bdf387780bc526ddcc2647c.camel@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <125b4d82-c579-eab1-ff1f-6df7508dce97@acm.org>
Date:   Tue, 10 Dec 2019 15:45:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1755e03c0aba7c684bdf387780bc526ddcc2647c.camel@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/10/19 3:29 PM, Martin Wilck wrote:
> On Tue, 2019-12-10 at 12:57 -0500, Bart Van Assche wrote:
>> On 12/10/19 6:47 AM, Martin Wilck wrote:
>>> blk_mq_request_started() returns true for requests in
>>> MQ_RQ_COMPLETE
>>> state. Is this really an equivalent condition?
>>>
>>> That said, the condition in the current code is sort of strange, as
>>> it's equivalent to !(sp->completed && sp->aborted). I'm wondering
>>> what
>>> it means if a command is both completed and aborted. Naïvely
>>> thinking
>>> (and inferring from the current code) this condition could never be
>>> met, and thus its negation would hold for every command. Perhaps
>>> Quinn
>>> meant "!(sp->completed || sp->aborted)" ?
>>
>> Hi Martin,
>>
>> The only caller of qla2x00_abort_srb() is qla2x00_abort_all_cmds().
>> That
>> function should only be called after completion interrupts have been
>> disabled. In other words, I don't think that we have to worry about
>> blk_mq_request_started() encountering the MQ_RQ_COMPLETE state. No
>> request should have that state when qla2x00_abort_all_cmds() is
>> called.
> 
> I thought avoiding a race between completion and abort was the whole
> point of f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort
> path"), which introduced the code that you're now changing. But I must
> be overlooking something then, as Himanshu has acked this.

Hi Martin,

My understanding of commit f45bca8c5052 ("scsi: qla2xxx: Fix double
scsi_done for abort path") is as follows:
* A long time ago a scsi_done() call was introduced in
qla2xxx_eh_abort(). Maybe this commit introduced that call: 083a469db4ec
("[SCSI] qla2xxx: Correct use-after-free oops seen during EH-abort.").
* Calling scsi_done() from qla2xxx_eh_abort() is only fine if the
firmware does not report a completion after having processed an abort
request. My conclusion from commit f45bca8c5052 is that the firmware
does report a completion after having processed an abort request. Hence
the removal of that scsi_done call from qla2xxx_eh_abort().

Bart.
