Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CBFC433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 20:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50587619B4
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 20:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbhCXU4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 16:56:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238268AbhCXUz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 16:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616619357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8FoJOdrh52kDgMFiDwrah9lL74QTRbaANdUh/hXcmEQ=;
        b=Z3/UAI5nDkx858Acc5UoFO0u1wGcYLxBFPtm2j/Ba1ZrELNVsnnez+AC/a6qfILXLxhvbn
        nIzd/8uK11U3l7NB7+924khewtKJnWCs0wcTb2BxNcwHuUjBelGPtqKoZQAGX0L5S8vB3E
        s980zai/UcVxkFXnWYhSlsnu1uV5TjA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-mHZuwaBTPcuDXNpR4cs4AQ-1; Wed, 24 Mar 2021 16:55:56 -0400
X-MC-Unique: mHZuwaBTPcuDXNpR4cs4AQ-1
Received: by mail-qt1-f199.google.com with SMTP id r32so2034096qtd.16
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 13:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8FoJOdrh52kDgMFiDwrah9lL74QTRbaANdUh/hXcmEQ=;
        b=ME8NqWsI7lvkjM/YkGFfHlwhenE2MwwW3p6CX2GMpBnskkp7iU/52E8RxXz9Kyw+c6
         bgMmB9EOPN+ZigBAPkS08EyiqUD0nVJK4QXGzPiriDFSvob/wc43PVnDfa3fM7k6t83c
         u4nvYPkBhxmt6ItHQTqjoODvULBvwlrAvFI+TbxA5AUkG8JWCds1pPYLppf62G6qUpVg
         ZcDW5gAY2dpIXT3RrbCEPBZKyqDgibgEZHLFrxOMPtmQvCYv7ZZ2TPXM4GlBZuGA4PBu
         VXI/96pm1raiN3kXt9D1HGC8sQpdxbIpKsDfPGamfwr0y/hA4mCrU0czeAChIoBb9cDg
         vN3A==
X-Gm-Message-State: AOAM532nHK0RDWbXtY69CnyKIGox3h9kHieGmFhX5fJl+X1wV3/FsXCI
        eQWnzajiI0Ej+sajviWxd3lovtKUCHA4UoCWoY0Am9tCxNACkwq3YRaA+bLM+DTJwhBUQKlqJDq
        5lMsOQ77jcrogfpGRiXV+Og==
X-Received: by 2002:a05:6214:1424:: with SMTP id o4mr4874663qvx.34.1616619355178;
        Wed, 24 Mar 2021 13:55:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVeliR2dQ7IHu9NHkIT0+3S3s4snliQHe2viJbvfsWMITyqFzxV8lkVn6WsqSvHCiTgFu85Q==
X-Received: by 2002:a05:6214:1424:: with SMTP id o4mr4874643qvx.34.1616619354980;
        Wed, 24 Mar 2021 13:55:54 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id d68sm2626502qkf.93.2021.03.24.13.55.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Mar 2021 13:55:54 -0700 (PDT)
Message-ID: <00b0eda147dff3c6724197a35e65a6d7709be070.camel@redhat.com>
Subject: Re: [PATCH 00/11] qla2xxx driver bug fixes
From:   Laurence Oberman <loberman@redhat.com>
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Date:   Wed, 24 Mar 2021 16:55:53 -0400
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-03-22 at 21:42 -0700, Nilesh Javali wrote:
> Martin,
> 
> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.
> 
> Thanks,
> Nilesh
> 
> Arun Easi (3):
>   qla2xxx: Fix IOPS drop seen in some adapters
>   qla2xxx: Add H:C:T info in the log message for fc ports
>   qla2xxx: Fix crash in qla2xxx_mqueuecommand
> 
> Nilesh Javali (1):
>   qla2xxx: Update version to 10.02.00.106-k
> 
> Quinn Tran (7):
>   qla2xxx: fix stuck session
>   qla2xxx: consolidate zio threshold setting for both fcp & nvme
>   qla2xxx: Fix use after free in bsg
>   qla2xxx: fix RISC RESET completion polling
>   qla2xxx: fix crash in PCIe error handling
>   qla2xxx: fix mailbox recovery during PCIe error
>   qla2xxx: include AER debug mask to default
> 
>  drivers/scsi/qla2xxx/qla_bsg.c     |   3 +-
>  drivers/scsi/qla2xxx/qla_dbg.c     |  32 +++++
>  drivers/scsi/qla2xxx/qla_dbg.h     |   2 +-
>  drivers/scsi/qla2xxx/qla_def.h     |  12 +-
>  drivers/scsi/qla2xxx/qla_gbl.h     |   3 +
>  drivers/scsi/qla2xxx/qla_init.c    | 115 ++++++++++++----
>  drivers/scsi/qla2xxx/qla_inline.h  |  29 ++++
>  drivers/scsi/qla2xxx/qla_iocb.c    |  79 +++++++++--
>  drivers/scsi/qla2xxx/qla_isr.c     |   9 +-
>  drivers/scsi/qla2xxx/qla_mbx.c     |  37 +++--
>  drivers/scsi/qla2xxx/qla_nvme.c    |  10 +-
>  drivers/scsi/qla2xxx/qla_os.c      | 212 ++++++++++++++++-----------
> --
>  drivers/scsi/qla2xxx/qla_target.c  |   2 +-
>  drivers/scsi/qla2xxx/qla_version.h |   4 +-
>  14 files changed, 395 insertions(+), 154 deletions(-)
> 
> 
> base-commit: f749d8b7a9896bc6e5ffe104cc64345037e0b152

These were tested in the Red Hat Lab using aer error injection for a
very specific customer issue and passed our testing too.

qla2xxx: fix stuck session
qla2xxx: fix RISC RESET completion polling
qla2xxx: fix crash in PCIe error handling
qla2xxx: fix mailbox recovery during PCIe error
qla2xxx: include AER debug mask to default

Tested-by: Laurence Oberman <loberman@redhat.com>

