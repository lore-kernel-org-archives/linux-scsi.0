Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1192C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 19:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8559F61074
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 19:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhJKT4X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 15:56:23 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:34401 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbhJKT4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 15:56:23 -0400
Received: by mail-pf1-f172.google.com with SMTP id g14so15705966pfm.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2021 12:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QfWnyL0/DMJStOG7nakA3DJPEzt2sPLcrnEVhLM68gI=;
        b=FPLQ14khQZor119xY/k5WrIrPCTUzJnGDNxTc2LjmYXTtKdsvxvo+nyzLEAMY+7xFJ
         e+l389uPXiHWyPkHMaZZHATGRxVdPmIw659IJzzbrHvxQs71EJuWcYDn8/ZY++D9iucX
         9WHmDziqil0lWQZXCzklBBWUp8/pdIVKPi5V37xAGbHKl5wcjttwg53U3j/uZl/+HQNa
         ChZpSFmcgf0kE1ZbkaZh2LIxno69k88FNoWB6GQK/t5cY56ZasStJKkpddj6p27eFg1F
         PDs6arsyqfzFxlTI3kXjCMx7xyiPvDMIb27jn8XIC0fD4lowacxSFAsfc6VsP1TqRell
         iJyg==
X-Gm-Message-State: AOAM532ZPWQbunRCCDjWQUmyz5RSdYC8z9By/9MSTdPiDQ56m3Pwk8Yv
        vyZ0u6rY/UBOBmlotEAgZ24=
X-Google-Smtp-Source: ABdhPJyFfceutf+/K8r4/q16yVgMda/6AkD0k8rOBQOKel79l3qPle0bXl5s+RtKdWWov+eUjmXfSw==
X-Received: by 2002:a63:d14:: with SMTP id c20mr19958493pgl.118.1633982062397;
        Mon, 11 Oct 2021 12:54:22 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:5253:6091:3f47:989d? ([2601:647:4000:d7:5253:6091:3f47:989d])
        by smtp.gmail.com with ESMTPSA id a27sm2703950pfl.20.2021.10.11.12.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 12:54:21 -0700 (PDT)
Message-ID: <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
Date:   Mon, 11 Oct 2021 12:54:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Content-Language: en-US
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210930034752.248781-1-songyl@ramaxel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/21 20:47, Yanling Song wrote:
> +#define SPRAID_IOCTL_RESET_CMD _IOWR('N', 0x80, struct spraid_passthru_common_cmd)
> +#define SPRAID_IOCTL_ADMIN_CMD _IOWR('N', 0x41, struct spraid_passthru_common_cmd)

Do these new ioctls provide any functionality that is not yet provided 
by SG_IO + SG_SCSI_RESET_BUS?

Additionally, mixing driver-internal and user space definitions in a 
single header file is not OK. Definitions of data structures and ioctls 
that are needed by user space software should occur in a header file in 
the directory include/uapi/scsi/.

> +#define SPRAID_IOCTL_IOQ_CMD _IOWR('N', 0x42, struct spraid_ioq_passthru_cmd)

What functionality does this ioctl provide that is not yet provided by 
SG_IO?

> +#define SPRAID_DRV_VERSION	"1.0.0.0"

Although many Linux kernel drivers include a version number, a version 
number is only useful in an out-of-tree driver and not in an upstream 
driver. The Linux kernel itself already has a version number.

> +MODULE_AUTHOR("Ramaxel Memory Technology");

My understanding is that the MODULE_AUTHOR argument should mention the 
name of a person. From include/linux/module.h:

/*
  * Author(s), use "Name <email>" or just "Name", for multiple
  * authors use multiple MODULE_AUTHOR() statements/lines.
  */
#define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)

Thanks,

Bart.
