Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C36C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 18:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A536611BF
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 18:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhIKS5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 14:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhIKS5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Sep 2021 14:57:36 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7C6C061574
        for <linux-scsi@vger.kernel.org>; Sat, 11 Sep 2021 11:56:23 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q11so7768720wrr.9
        for <linux-scsi@vger.kernel.org>; Sat, 11 Sep 2021 11:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g+zIxgfpPibCBsj7QoVGO97rOlTT59CN4lyb+inr3Hk=;
        b=lzMxI9iJbiIwrWZBV7cPjtyT+skgcCRDrW73c9bgw2zOK43O8HqtqjQR9vTSxKIvER
         j4A8RPFV9umnFJs1ylIGzR2TKW+G24J7HbTqLQnVjwSJkqyM47fKzO7+ketszz/lhLQf
         IWx8AG0TJDUgAtnW1M3I2tNSw8hhM5O7/gNK5C7Gbzyhz5L75rJathP1FKbcilDKQoda
         1kRfYneE4iqB5xJ69qa5wE0Jf5aj/krk74xwLTEJujrzDEAuMTjoOLsCEZcrUWJwK0Xh
         RyDxDtkTd4vGXEVgo5xMxpCRR0v8u8z5kyHGPMNNHqPK+4+i+uEn2iSBb0KQ09tCgHCY
         V8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=g+zIxgfpPibCBsj7QoVGO97rOlTT59CN4lyb+inr3Hk=;
        b=12iZTCa70v3sRH0tUYZEnIld7Ww+tN9jEaH6OIUs6uGpfFvhKeZH1rb13nw4SaZGXC
         QHT+AB+7XIyyuW+lITRL1famuWjGWD9FaInLlkMvUr/zZtVXN0l79boJ/drN+tbZmVmQ
         t8QB263yLlxs/3JCgCdAlOm3D4o0mwmA8H15eWiSwI6uZ2TvSerJyIt1m94H9p8q9XIq
         HVfrdCo9WA6gL4qofNrAGJPJ1FDHpY35Val6mR15PqNQT4m9hvk8ZO1UYXFJgICXVIKf
         TWavyRmUphAInc0xkpechxHp3RFAnF1NhpE5XMGSnYf08eBmiI9+i9DkGUQ7had/LQfn
         Aafg==
X-Gm-Message-State: AOAM5314g1jUCaq7Rl84kbUGZr2hzyQ5DHx1cprDcRLhcbUSXaDbgoza
        nXhoH+zZbj3jqffg29w1XXA=
X-Google-Smtp-Source: ABdhPJxzAhHRpbQJqm3R565c/qgP9m8RsCRfMZH2uBOalb9oInGSvX86CVTAEOPOlP5HOrJ72ca7Qg==
X-Received: by 2002:a05:6000:1627:: with SMTP id v7mr4203636wrb.195.1631386582237;
        Sat, 11 Sep 2021 11:56:22 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id j14sm2415769wrp.21.2021.09.11.11.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 11:56:21 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 11 Sep 2021 20:56:20 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [Bug 214311] New: megaraid_sas - no disks detected
Message-ID: <YTz71EKv/+970GSC@eldamar.lan>
References: <bug-214311-11613@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-214311-11613@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Sat, Sep 04, 2021 at 11:23:59AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=214311
> 
>             Bug ID: 214311
>            Summary: megaraid_sas - no disks detected
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 5.10.0
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: SCSI
>           Assignee: linux-scsi@vger.kernel.org
>           Reporter: jarek@poczta.srv.pl
>         Regression: No
> 
> Dell R340 with PERC H330 - disks not detected.
> 
> lspci:
> 
> 02:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3008
> [Fury] (rev 02)
> 
> dmesg:
> 
> megaraid_sas 0000:02:00.0: Performance mode :Latency
> megaraid_sas 0000:02:00.0: FW supports sync cache: No
> megaraid_sas 0000:02:00.0: megasas_disable_intr_fusion is called
> outband_intr_mask:0x40000009
> megaraid_sas 0000:02:00.0: Ignore DCMD timeout: megasas_get_ctrl_info 5274
> megaraid_sas 0000:02:00.0: Could not get controller info. Fail from
> megasas_init_adapter_fusion 1865
> megaraid_sas 0000:02:00.0: Failed from megasas_init_fw 6406
> 
> This machine works OK with kernel 4.19.0. Debian 11, Clonezilla 2.7.3-19 does
> not detect disks.

This sounds very similar to one bug report which was reported
downstream in Debian at https://bugs.debian.org/992304

Followup to the bugzilla bug 214311
(https://bugzilla.kernel.org/show_bug.cgi?id=214311) suggests that it
works when booting with BIOS, not with UEFI boot.

Regards,
Salvatore
