Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FB2C433E7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 11:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C942076D
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 11:20:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="QIt/mP8D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgJOLUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Oct 2020 07:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJOLUz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2020 07:20:55 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412DCC0613D2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 04:20:55 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y14so1696060pgf.12
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 04:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=h3tRYVbrXJtU2QrbFsBU9Spd181m5OYM6XKvEjWUj7o=;
        b=QIt/mP8DYXc3aZ9StyaAf2nXjupmpSXJxoytuCIbUXNsgENvncCxtqnJ4375DhrhXx
         EvL/5yz9peW8cIZdmOHclXRu7fLxJsjlN8cGjG1jPde7jP8CFUQk9eovln5n8Nj9VGrr
         rh2CIZQxIh/ecTcr5BFF5Rrw8+QNZvjClVcYhGHf2cW1JObwlI/XExq6jAlRsCN0B7r9
         c5X9bQAIwy0lOPAHZ0sMtnVpXr8acL1jKEtLCDmup52Z9pmxAXd3R12PYi/r9QgzcDzm
         JTQQnPyaTMlDOiBFEPiOTg7G9dzyk3MXoAnvZqqfT274OcFfZPnLX4m/0f97rb1Uyg/r
         itnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=h3tRYVbrXJtU2QrbFsBU9Spd181m5OYM6XKvEjWUj7o=;
        b=l+X3uxCtk1WNeaUVzUDLMEk3TIjEiNQhIMG1aruxwAgjkefKZIsLcfH3D23UJ7hoId
         ZH25F4ecgtbPXVtc9lr1tdnG8Yn8y2+QGvYlIMRYtFOeAUw9pK/ovg/EaFqIZ/957xiD
         a03zsq85YkbMKfkRar8EFBwhaZBUxDjpoNtlWhS4YiaqAupqcrDm+ezcHNNw7GeIpfXD
         YaNL97xUezYH2Ynsi+rv7zZZGXZof/hrmmNGHoVpSWqc8JwB7dpltvPgAPTVBnaR2sP4
         8nI3EbAhBYQencgpKYrrUvtgPybHMHlbS4zHsseKCEuun9dF8qZ4NmnPB0YW5ZZmF1nk
         QjDA==
X-Gm-Message-State: AOAM5323Np6ivfAhlfkFdSbuSo90h2u3pws3q0bTwPqWE9lQjL9wUF0E
        5/w/3LLYUPPMjOXGKKYSTsFopw==
X-Google-Smtp-Source: ABdhPJycSiqzIkOBMmcrMer+prhnFXkBkWVnnTG1jX+nH7iysz4LJoobpMqgfGJiu0O57TDIZE4ACQ==
X-Received: by 2002:a63:1d15:: with SMTP id d21mr2958265pgd.433.1602760854749;
        Thu, 15 Oct 2020 04:20:54 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id k127sm2828221pgk.10.2020.10.15.04.20.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 04:20:54 -0700 (PDT)
Message-ID: <f746bda4c51d6553f2094b0a3dfbafa3e39d4c28.camel@areca.com.tw>
Subject: [PATCH 0/1] scsi: arcmsr: configure the default SCSI device command
 timeout value
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 16 Oct 2020 03:20:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is against to mkp's 5.10/scsi-queue.

1. Configure the default SCSI device command timeout value.
---


