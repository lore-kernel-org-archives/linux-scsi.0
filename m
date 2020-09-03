Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CC9C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 788992072A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R5pM5qaW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgICP2k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 11:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgICP2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 11:28:39 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE845C061244;
        Thu,  3 Sep 2020 08:28:38 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o21so3339142wmc.0;
        Thu, 03 Sep 2020 08:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d2mumm4P1bVr1Bb3gPlVXQGtP2l5t0EgCIHKREur5m8=;
        b=R5pM5qaWNe3soQIqZ+rN7TqeM5o/3xgg5vLLRW9M6/lk1RGvE1FMF0MNRldyB/eW+d
         9k187yMwzURiwBoJKRbDMnjCo6vMVtyq503jUc6IjGfIMTPhV7wH8UNfr8IVIJnnLIDm
         LPXGZCm1ZJok/gsyySyx45jzZ/zt9lUnui2L75teU1SnAL6+WMqrOuIE+s+fiyXEezoB
         EFkigeb8qpXBjUPoXeMvbOjBGlqxmqjhTrrDUXN/QTjS2/fbC2hVHbX54iP2V70iBPuH
         GnC2L7NLmZkjHlmQnysSMkmBZIsrcyqwt9h8tSHLyRwqUv2oC74XgO5VJl5vEM59GV/J
         4XWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d2mumm4P1bVr1Bb3gPlVXQGtP2l5t0EgCIHKREur5m8=;
        b=Obo2NRtHRlQj+xCcDpHC8pyb95+bKUTKXHVySoBq3x1rBERc7Hr67WnD2TbyP71tZc
         3Z5pbhdlakOtnuQxKxEL6FcJdaTNJ4Xufxdv4JvrH5xq1Yz21/8ODEBn1NwfX/nVTF80
         mybpwS7L4vv4dsvef01QIbVHg8cpPxtir3CmIwUzbfzOBC4N4nmOWd5GE3vKTgLoAaRz
         4VF8gBH850SEoQA4QuMObKZMjxTm6OG1BH5is9Xne3IFQBraPVPpiLh3HEv2XgiqJlk1
         D3a+PhmGHgdlNcl6hCpUf8ulzotJo0KPfPFY2nA2L+KkWV48ng6CL0SKimOjFIddZIUd
         9hDw==
X-Gm-Message-State: AOAM533AV5bR2BazLCzBowY1vnDWkvHF2JBh8EhVwOBsmX9kxuxne+MZ
        HANgmIqqXB3AUfHryy184bU=
X-Google-Smtp-Source: ABdhPJyWmbqx2/TcPd8Ofs/isfnzLUldKJ6X+6gyZinIjuuJ4sIn5sPo144dwpEIZ73RBXcF4LYTFQ==
X-Received: by 2002:a1c:48c2:: with SMTP id v185mr3028633wma.5.1599146917362;
        Thu, 03 Sep 2020 08:28:37 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id 32sm5750210wrh.18.2020.09.03.08.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 08:28:36 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/3] scsi: mpt: Refactor and port to dma_* interface
Date:   Thu,  3 Sep 2020 16:28:29 +0100
Message-Id: <20200903152832.484908-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I started porting over the mpt code from using the old pci_* compat
functions to their dma_* counterparts, but realised that there are many
functions which have a sleepFlags argument, which is actually almost
never actually needed: almost all of the functions are always called
with sleepFlag == CAN_SLEEP anyway. The first patch fixes these cases
and could be applied by itself as a general tidy-up.

The other two patches are functional changes and so I added the RFC tag
just to be extra cautious. Both of these patches involve changing some
allocations from GFP_ATOMIC to GFP_KERNEL so I wanted to make sure that
I wasn't introducing bugs. (Related question: Can you sleep in an ioctl
context....?)

Any feedback would be greatly appreciated!

Best,
Alex


