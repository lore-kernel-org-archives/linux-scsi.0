Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D9FC2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D87F20737
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WJ8cXXQn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636098AbgDONZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 09:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636090AbgDONZm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 09:25:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE2EC061A0C
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:41 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id c138so1513655pfc.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Fv2jdBZNTOygmpTWVimM/E9NVBc4uGHE1tqcVO9Llvg=;
        b=WJ8cXXQnT//5JHu+ZYa6mNNdZC635xwY5eMeJ0upV8QjJSGQFwXjd5Uor1S2axNW0O
         kobYVoqv9ZvPs0qwhTgjaXXeyDAHh2COjLLiHG14bXVkS0+wAlqa86iGhl/v0YfznKN1
         F8x8TG3k8eTYYH7p8JoPImGW9xIHupsIiByxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Fv2jdBZNTOygmpTWVimM/E9NVBc4uGHE1tqcVO9Llvg=;
        b=mX5jvScNHRCHhqpL4xLWIySMpErGHD9MtKgdBgyFJH9E45WYxB5j3C6H8ZR8894K3K
         PBQqIfwm2ZIucr91l5C8mxOUS/yd2E4bGdrhu4xmvODHSZlKvdfVZt4rpeIPM8PQ5qnL
         cpEh9ZnO6yWgWAj6kGc6j7llUmQDZeGNITPRRZ4n+6Pm7CTd6PvgxyJ29CjJQYZId6n6
         0rplVMmBQcai9UdK3pks2yzUPLR2UKLtMdKdMqW1Sq6u6LJDnKy98zB2Vuan7/9/KPSh
         iR5RuBK3Xsk0L+9tQ6PuvQv+dxIQhTJcwsmQRwmEygz9oUp7r7IQm7UZlenvYZ4XouCc
         9FSQ==
X-Gm-Message-State: AGi0PuaotZw9kO/iUz25UNlWELQKQ91qDhUG9RlK35QYiw3d0Hn6MU5Y
        D2m6o+crbIXRPNam+Hvng4KnvkiFclXk8WjZ8ELtT1HQLwfDoe17hsNTnEwpWLMWPgBN053uaoi
        mdv1bxLUI+gXlPXFqwDJgXDymkagW9aPYv3E1hM/YT/VcwJGP7H5+GzhXkyyqPvCjsgne7Wrvkb
        1LutB0/snVeLFjFA8CewaT
X-Google-Smtp-Source: APiQypLUeiE2BHzGycozwuqGp5U5iHJo947Mb5bNgiqB+jUqwIg+2DXrTK6MSFgQuOj1X75A0AXXwQ==
X-Received: by 2002:aa7:931a:: with SMTP id 26mr26889969pfj.11.1586957140593;
        Wed, 15 Apr 2020 06:25:40 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x186sm13715556pfb.151.2020.04.15.06.25.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 06:25:39 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v1 0/5] mpt3sas: Fix changing coherent mask after allocation 
Date:   Wed, 15 Apr 2020 09:25:20 -0400
Message-Id: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

* Set the coherent dma mask to 64 bit and then allocate RDPQ pools,
make sure that each of the RDPQ pools satisfies the 4gb boundary
restriction. if any of the RDPQ pool doesn't satisfies this
restriction then deallocate the pools and reallocate them after
changing the coherent dma mask to 32 bit.
* With this there is no need to change DMA coherent
mask when there are outstanding allocations in mpt3sas.
* Code-Refactoring

Suganath Prabu S (5):
  mpt3sas: Don't change the dma coherent mask after      allocations
  mpt3sas: Rename function name is_MSB_are_same
  mpt3sas: Separate out RDPQ allocation to new function.
  mpt3sas: Handle RDPQ DMA allocation in same 4G region
  mpt3sas: Update mpt3sas version to 33.101.00.00

 drivers/scsi/mpt3sas/mpt3sas_base.c | 279 +++++++++++++++++++++---------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |   9 +-
 2 files changed, 171 insertions(+), 117 deletions(-)

-- 
1.8.3.1

