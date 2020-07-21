Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555DBC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 14:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A50820714
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 14:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rv7teYKT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgGUObj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbgGUObi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 10:31:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0641C061794;
        Tue, 21 Jul 2020 07:31:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o22so1768240pjw.2;
        Tue, 21 Jul 2020 07:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eoQ/LwxD/ih1GkSzZAuNDCG4MFgTBugN1T3/2DGPiZs=;
        b=rv7teYKT4HHE+hRheeUMz7kFEVy/2FYAFPFyJ6DTsr8qA90Sqj/xBO5qcgaUtnUDvi
         Rv86a654zaXEffQPbUFs1rZrshA+3BvCOkRCRN6YaF79kELJMnzI9mUXYbM5lgmnIM08
         ZyWJt7Ifd1VkkXyHhuAuwnJLoLekleV3w0m/Utq2eDVXteX3AV3usu5pIldXV44peA4v
         VaOuEuwXpmVMYve1kLJP4NHz7dzIShIqiqtgke+77R9j3jxIZREMsqM6IP4PHhtMTBe5
         JQajMLneYsAzcaPCAB1ZE9Yp7dgj/n2hn88z3PP4KOIzR1ISSADxFb090PuzQjyk6wdb
         kSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eoQ/LwxD/ih1GkSzZAuNDCG4MFgTBugN1T3/2DGPiZs=;
        b=I9SVn1esEhvjDQ5DOsG2TIx1amxbdUi454RvSUjZXVl2Unliu8CvmoZqbfcL8UdQvg
         g11tkKMoTtTXXx5ofjnlKG5fhwJ9ks/Zyutg+obm82gN1EwptDtXMXLZfnWr1VSUWPl3
         mWzTphitIMvAp23GFNrPwXHUkNlKJ6NWLd3ujbNI3nO5B2oSjp3AhPAtFkjLlvivOsmL
         1hiN1PGHGW3M7KLIA6FE4i6/pDxJnImLXbDgjkYVERC+5GQzXtBvTReGpaQxVFsfQ+Iu
         Bu+Bk9wS2FrM0Uvg/gs0TIa1IxUivsDL1IKaJuTUyUAft3Jyeay8MJ1QxcK9tVZRXUDV
         9K6A==
X-Gm-Message-State: AOAM530GjO/014dRkn22tp7CzUPv+J9oI+BTzwdNRtZpf1KnngLN5ko4
        DC34Ul6OCKa5/Fv6Hi/+TKem9pIquVZ1cw==
X-Google-Smtp-Source: ABdhPJyyVBc9dQXHdc+5lLNWNkeC/7Y3foGXFsBMmQ+uwmlFrHQSa2Q6C+IdC0ODHYc721agO4tx5g==
X-Received: by 2002:a17:90b:1a8d:: with SMTP id ng13mr4045580pjb.24.1595341898367;
        Tue, 21 Jul 2020 07:31:38 -0700 (PDT)
Received: from gmail.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id u26sm18940457pgo.71.2020.07.21.07.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 07:31:37 -0700 (PDT)
Date:   Tue, 21 Jul 2020 20:00:16 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] mptfusion: use generic power management
Message-ID: <20200721143016.GA304517@gmail.com>
References: <20200721142423.304231-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200721142423.304231-1-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is compile-tested only.

--Vaibhav Gupta
