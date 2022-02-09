Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8C9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 00:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbiBIAK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 19:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiBIAKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 19:10:55 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6143C061576
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 16:10:54 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so3489944pjl.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 16:10:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SNcD5QyXejo7gz17+60HCxF6D6iBEEVyaQ2QiU5RB3Q=;
        b=OKKaQ+soq8YzawNN3LNFJufTiqhsw/rwrvHvGlYIC7HZwqPCanPAYPJgCGTku9RfwL
         0C3II/HihNyWDF41HynpTyRBDsA0ZKwPL7MKIEJgMhfn79DII06W6PjIDF90VZDwAOMs
         CXNEA7UBfrrVfsKF1MvemcmjjM1/19pX6IKvE2zoaQtFrTwinEM+iTGEGys7yNhp6KB2
         E5cpqomPaVFJieBjIiD0NZQE2yef27Wn3+Y4zj0lK+iEUx87x6sKP/bKfixoTTTt0b4Q
         VCNvGzO9n7JEyVCfmIgui2bhkJezj+R+L5jIbmFL3nW/N2ODJQPRo2xXutaiPMa1TSiv
         tB5g==
X-Gm-Message-State: AOAM531kB1M8NWh/HZV0ZU5pJVeGBJE/f8UTcTX9PsNVyn1/d/+BBenP
        /VYEMyoG9N+tV4aHw2h8mvc=
X-Google-Smtp-Source: ABdhPJyaAKhdEaXp1jp2xKsbfN6o+jV9Y6FTWla5jeQrMFpdyP/RvzIn4Aw7YBKaEni9HHJR+6hnVg==
X-Received: by 2002:a17:90a:c7d2:: with SMTP id gf18mr493062pjb.189.1644365454095;
        Tue, 08 Feb 2022 16:10:54 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 16sm3904298pje.34.2022.02.08.16.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 16:10:53 -0800 (PST)
Message-ID: <8a36af71-07ff-0495-2cf8-4331fa54e917@acm.org>
Date:   Tue, 8 Feb 2022 16:10:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 05/44] NCR5380: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-6-bvanassche@acm.org>
 <a94b9ac6-85c5-d267-21e8-10b22c9b43c9@linux-m68k.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a94b9ac6-85c5-d267-21e8-10b22c9b43c9@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 14:22, Finn Thain wrote:
> I see that v2 is the same as v1. Is the "v2" wrong, or the patch content
> wrong, or something else?

Hi Finn,

Does that question perhaps mean that you expected to see changes in this 
patch? The changes in v2 compared to v1 have been mentioned in the cover 
letter of this patch series 
(https://lore.kernel.org/linux-scsi/20220208172514.3481-1-bvanassche@acm.org/T/#m8f85b6b941ff84968a29f83585bac7fe8791f8a8).

Thanks,

Bart.
