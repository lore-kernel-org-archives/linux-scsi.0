Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAEAC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 02:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBFE610E6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 02:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhHSCl4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 22:41:56 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:33752 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbhHSCl4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 22:41:56 -0400
Received: by mail-pf1-f174.google.com with SMTP id w68so4103271pfd.0;
        Wed, 18 Aug 2021 19:41:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4A28nU0mCnhnW+EpVTBHYomUkLqAR7mfhHZAM9QYihE=;
        b=EnmnMmmygJWqpu8FXAc4BxvDF4q6ARVI33hnlL6L6tleH4X4Ear8om9yxyD6t4A3jC
         ZFEObvgnzNpN1SYw6AwQV3rzY1hkncTEnMAp/ggyNXe0Xlbakhx6T769EdCgdvPeac4U
         auvH/pLXsV79nN6LlSlVocGsIcpTIXr/Tkob3jAYCmrTY7H6QoxVtHWk6x2FCNh7yT7m
         HADBMFHLzc9v+/vQ/+CDgZpt2Q2C0gzwzqc/wjug1wR3CzX50UKdEQrcv6r8iFuHcAEH
         rv/lQ10PQkQs3M7/CXsSAqJFHXkm7Hm4Dk0tBT5DeRzG3Wek6piWAkQbmfWckb309vWg
         D+GQ==
X-Gm-Message-State: AOAM533ZnEY5ChY/5T7lCRU8Li6mQhxsy2GWHOYkLMc3YqIUlYQ1JpGw
        Jciy+x/a4Dp0N2ZphG5ltXY=
X-Google-Smtp-Source: ABdhPJyERX2dVeTOlTHzORPaDJqMM/u/QQNRm7OvorlKtXDZRiFztmDuhhKs1rQO8qa5fwAWazM5zg==
X-Received: by 2002:a65:6818:: with SMTP id l24mr12116342pgt.150.1629340880267;
        Wed, 18 Aug 2021 19:41:20 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:340d:6f8c:ca7d:a32? ([2601:647:4000:d7:340d:6f8c:ca7d:a32])
        by smtp.gmail.com with ESMTPSA id f23sm1155611pfd.61.2021.08.18.19.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 19:41:19 -0700 (PDT)
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hare@suse.de, hch@lst.de
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <yq14kbppa42.fsf@ca-mkp.ca.oracle.com>
 <176ce4f2-42c9-bba6-c8f9-70a08faa21b8@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e0d7ba32-2999-794e-2ccb-fdba2c847eb1@acm.org>
Date:   Wed, 18 Aug 2021 19:41:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <176ce4f2-42c9-bba6-c8f9-70a08faa21b8@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/18/21 11:08 AM, John Garry wrote:
> Or maybe you or Bart have a better idea?

This is how I test compilation of SCSI drivers on a SUSE system (only
the cross-compilation prefix is distro specific):

    # Acorn RiscPC
    make ARCH=arm xconfig
    # Select the RiscPC architecture (ARCH_RPC)
    make -j9 ARCH=arm CROSS_COMPILE=arm-suse-linux-gnueabi- </dev/null

    # Atari, Amiga
    make ARCH=m68k xconfig<br>
    # Select Amiga + Atari + 68060 + Q40 + SCSI + Zorro +
    # SCSI_FDOMAIN_ISA
    make -j9 ARCH=m68k CROSS_COMPILE=m68k-suse-linux- </dev/null

    # MIPS
    make ARCH=powerpc xconfig<br>
    # Select the SGI IP28 machine type and also the WD93C93 SCSI
    # driver
    make -j9 ARCH=mips CROSS_COMPILE=mips-suse-linux- </dev/null

    # PowerPC
    make ARCH=powerpc xconfig<br>
    # Select the ibmvfc and ibmvscsi drivers<br>
    make -j9 ARCH=powerpc CROSS_COMPILE=powerpc64-suse-linux- \
      </dev/null

    # S/390
    make ARCH=s390 xconfig
    # Select the zfcp driver
    make -j9 ARCH=s390 CROSS_COMPILE=s390x-suse-linux- </dev/null

Bart.
