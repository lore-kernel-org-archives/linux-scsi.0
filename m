Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D11C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 08:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19E9923A31
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 08:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="BDlK19t7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgFTIWC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 04:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgFTIWC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 04:22:02 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABADC06174E
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 01:22:00 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i3so14053572ljg.3
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 01:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c/y32/xmjS/dZ8Lr7ipeYZOIjniqsMezUi4gC5eLVRo=;
        b=BDlK19t7jg+V/ha+/QAXVxZc3ydnHHYPY9GAQPZJGRizRatdOZ79z4BZ8PeCIRqNk/
         bFJj6vISllTC1CuJj51AaN7gd91J7TBKYzix06G/wviDvs5dwMZHlnsUsvFeRknLdlVx
         jswGNmPpNbCeuvhmwXDeG/UWhcjOs8hi9eO1PPBY7CQLEG2qN1M6uwthXVCqzNxQOjuw
         AKFFMG7LJ7IXaPPuxezpV8MZWH/9hidRYDst28apbVtuHdthY9nBkcP+MnhFb1cjfH7q
         IGczZCnqkr2uV7XtUsoC9baJPSkxB1aZgUWwdGjoW+ctJP6SVvpJlcmkvL/vMK1Nb2eH
         SCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c/y32/xmjS/dZ8Lr7ipeYZOIjniqsMezUi4gC5eLVRo=;
        b=BBUo6+ZF8lttXMOFaXwwVM46Aq2+FQWiw8Hxzo8XSYFxEw0EKc1QaIjg5QGoGW3Kii
         eIS+yuXUmSI7W4etpaHeO3DNLd35cS3xxqbggEsw5CetKpQjyVMn755SR+k1W87o4PGi
         95Rft1zwpe2UW1BN9JZ+RaQbCCx+N7ZIxtJ1xsHQudApCCwbk6UPKUqeT/LZGqGixsIA
         A2biKGv+oSwwiN77g2G24aHnkozZw5sFZIO3kLEzR5mURr7XPtklOBIFLs4AUiKeBeEg
         P121BH86bWlPcVt8NEoaSQ2uHOEVtcKnMhZEpICz/Xy6HtwjBIGoyA5xmkiGJL8O0UTM
         nEkw==
X-Gm-Message-State: AOAM533qZ3nN/kKdKGSILcuMRBUvy9Az8JTv4DCTbt/DpG1LRuyq+iyz
        nVt/iNqzHwWVZmEDqDoru0GkAA==
X-Google-Smtp-Source: ABdhPJzGszEfHPHtuah+MwhskgNx1h5qBNcVuyKWUU8C2TMGazLJVqq0dkOJm0p6+P90J15YIOJICA==
X-Received: by 2002:a2e:858c:: with SMTP id b12mr3517769lji.275.1592641318569;
        Sat, 20 Jun 2020 01:21:58 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:851:68cb:a8e4:b8:8a04:e903? ([2a00:1fa0:851:68cb:a8e4:b8:8a04:e903])
        by smtp.gmail.com with ESMTPSA id s25sm1581428ljj.119.2020.06.20.01.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 01:21:57 -0700 (PDT)
Subject: Re: [PATCH] libata: fix the ata_scsi_dma_need_drain stub
To:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20200620071302.462974-1-hch@lst.de>
 <20200620071302.462974-2-hch@lst.de>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <3148ace5-2733-5d66-7c2f-6a967666ea79@cogentembedded.com>
Date:   Sat, 20 Jun 2020 11:21:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200620071302.462974-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20.06.2020 10:13, Christoph Hellwig wrote:

> We don't only need the stub when libata is disable, but also if it

    Disabled. :-)

> is modular and there are built-in SAS drivers (which can happen when
> SCSI_SAS_ATA is disabled).
> 
> Fixes: b8f1d1e05817 ("scsi: Wire up ata_scsi_dma_need_drain for SAS HBA drivers")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
[...]

MBR, Sergei
