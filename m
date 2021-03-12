Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE28C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 02:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E5EF64F90
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 02:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhCLC5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 21:57:22 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:37839 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhCLC5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 21:57:03 -0500
Received: by mail-pj1-f45.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so10067614pjc.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2021 18:57:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HTY+cME6vqS349+Fan8XyRauzQSPaZVLIxXMqZ/6BtI=;
        b=DXJXBuLQyu+pwjYvaak1d4x6mV66xM9jDVN8L01hXuGkOnKcRo0tC3xfxMqs8IhpRM
         7hTxUg+vZPqciCopQ/Jw+ul+FQF+WaIInba59IB8CV5rulp1dM/OkIhGELGGkilFdOr6
         cV93Lx8Wjm5QZ3Ab1nsNXYAntP3MuuSBcSUXU6JBE5apnOx4gFpjCulhUCumjcIh/xxK
         0vdYQbr3BFVMrtqd5rwj2I7rus4L1mHfG20rgs9QQ66dcxNgVfPtjasbfo60lOAuNzo7
         6RfnIY5NrurHFRpKZlCGNadqcAK5RrnCzu0XC5QBGNbjQE9onZpuJvpdAq2iNqFa7hZ/
         aHMA==
X-Gm-Message-State: AOAM532mwzB6hGVlCS9x/opr8WNl3vn32E7cLhj0tADHP3SKxOkCkJKp
        wt5snwxkn2Jbw5YzKjnNx3Ij6w8xkiw=
X-Google-Smtp-Source: ABdhPJzrZ+RcYbpxfxtU6gMMe/G67lDE4AkZiqOCYIb1R3k8gxMnfNich5CkYpXckc7ChZLMNNw6VQ==
X-Received: by 2002:a17:90a:a513:: with SMTP id a19mr12605982pjq.210.1615517822203;
        Thu, 11 Mar 2021 18:57:02 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:2593:3cc1:e514:69aa? ([2601:647:4000:d7:2593:3cc1:e514:69aa])
        by smtp.gmail.com with ESMTPSA id n10sm3501873pgk.91.2021.03.11.18.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 18:57:01 -0800 (PST)
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6cbc1c06-3620-851e-21f8-f77392283245@acm.org>
Date:   Thu, 11 Mar 2021 18:56:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/11/21 7:54 AM, Johannes Thumshirn wrote:
> Yes I've looked at the commits in mpt3sas, but can't really pinpoint the 
> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for shared 
> host tagset for CPU hotplug") is the only one that /looks/ as if it could
> be causing it, but I don't know mpt3sas well enough.
> 
> FWIW added Sreekanth

Hi Johannes,

I'd like to see a full root-cause analysis before proceeding with this
patch because as far as I can see the call chain for
scsi_finish_command() is as follows (entirely in soft-IRQ context):

blk_done_softirq()
  blk_complete_reqs()
    scsi_softirq_done()
      scsi_finish_command()

Thanks,

Bart.

