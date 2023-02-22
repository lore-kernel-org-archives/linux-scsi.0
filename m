Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A232C64EC4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 14:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjBVOh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 09:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjBVOh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 09:37:57 -0500
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2237687;
        Wed, 22 Feb 2023 06:37:55 -0800 (PST)
Received: by mail-wm1-f53.google.com with SMTP id m14-20020a7bce0e000000b003e00c739ce4so5500250wmc.5;
        Wed, 22 Feb 2023 06:37:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YPaNPqJ7NTdhLdoefSDD/2tnPkQZdBqEzt2HHI6VRiE=;
        b=K1HwMddrHIfP653juFQT2YkKui0ZuyaB3i525FEj0xHZFlbAdHINvxBxHNQBWAgftw
         3quD6vrYXZ/ThhHfadEDNe02GwId0tiLJN3usr6OH3AFhl3vFg1poPD08fsytB7ZC6kh
         5mdj4CgYYBznuwTLhe7jhRInuzk4jFWFJSsRMsTTCrP9pgFjt1r6HTEpODaQuf5CYQWq
         rROW2hgaLGnWJzveKgLhIjg5jFSuws9mmnYEVvSRS4akNuz7N5njGfN3M4nwWPZ3F+Z0
         H7FzF+zZFPqQGgWP7+8Fz3iVcGNOFdhjF1Rb+JW1WRzZQ5O99XNX+NNY6ei/Jr98VU0T
         d8cA==
X-Gm-Message-State: AO0yUKUmS722TFphHpEHcbtk2HWlqgGMu6f04jSQ818qbNNB+FQ8vKzm
        SE7vaWjCsxPBUpVbOLh97rM=
X-Google-Smtp-Source: AK7set9Iyo2XZf9njsohvl6jQWWjwtumo6cSyVfz6pzF1NPaxBFBsjV55INndXP/cVZZKt9qxow0FQ==
X-Received: by 2002:a05:600c:1d1a:b0:3e0:b1:c12d with SMTP id l26-20020a05600c1d1a00b003e000b1c12dmr8064390wms.1.1677076674118;
        Wed, 22 Feb 2023 06:37:54 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c1d8d00b003e1f6e18c95sm7914118wms.21.2023.02.22.06.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 06:37:53 -0800 (PST)
Message-ID: <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
Date:   Wed, 22 Feb 2023 16:37:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
To:     dgilbert@interlog.com, Keith Busch <kbusch@kernel.org>,
        Hannes Reinecke <hare@suse.de>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        lsf-pc@lists.linuxfoundation.org
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
Content-Language: en-US
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> I did not understand what is the relationship between aborts and CDL.
>> Sounds to me that this would tie in to something like Time Limited Error
>> Recovery (TLER) and LR bit set based on ioprio?
>>
>> I am unclear where do aborts come into play here.
> 
> CDL: Command Duration Limits
> 
> One use case is reading from storage for audio visual output.
> An application only wants to wait so long (e.g. one or two frames
> on the video output) before it wants to forget about the current
> read (i.e. "abort" it) and move onto the next read. An alert viewer
> might notice a momentary freeze frame.
> 
> The SCSI CDL mechanism uses the DL0, DL1 and DL2 bits in the READ(16,32)
> commands. CDL also depends on the CDLP and RWCDLP fields in the
> REPORT SUPPORTED OPERATION CODES command and one of the CDL
> mode pages. So there may be some additional "wiring" needed in the
> SCSI subsystem.

I still don't understand where issuing aborts from userspace come into
play here...
