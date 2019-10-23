Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B8ECA9EAE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 04:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA9E3207FA
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 04:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DPK+MyMo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lIaD3gGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfJWENn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 00:13:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41610 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfJWENn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 00:13:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3520060614; Wed, 23 Oct 2019 04:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571804022;
        bh=f7yvCj/N0D9sUx7x0RhAXxq6ZtvGZALLbjWsCmW3vks=;
        h=From:To:Subject:Date:From;
        b=DPK+MyMod2gh6uqd1ZhoLKM6SYOw3Ir4PNZzG+7iAai/tsCkECIcGnitnDEeg1zqv
         LhxYw+bcBWTZZwvVgIsxIty1KQzTbY21aoI18tjCuGt3xjmSCNjickXio88kiEsDL/
         rNSEa0iFBxrnRJdv8qf6NAwqFEQsTXwVvE62+x8E=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 54EB0607B5;
        Wed, 23 Oct 2019 04:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571804021;
        bh=f7yvCj/N0D9sUx7x0RhAXxq6ZtvGZALLbjWsCmW3vks=;
        h=From:To:Subject:Date:From;
        b=lIaD3gGVPs9RFN38o7X2v6LmiNZcDFhcyadzY1H3FQRo9C/jDQnovWQpJz5TJvos8
         V4qm1m0wn2SFZB58zYFnf3Le3HPoGINfSpsnFtpcUJ7oaGBKrhZMVV9L6oAptN8g+C
         BE+gkV/cXGDxzwceajK8P0vP1g8pI8CHEPlaKzhM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 54EB0607B5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: [PATCH v1 0/2] Introduce a vops for resetting host controller
Date:   Tue, 22 Oct 2019 21:13:26 -0700
Message-Id: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some UFS host controllers need their specific implementations of resetting
to get them into a good state. Provide a new vops to allow the platform
driver to implement this own reset operation.

Can Guo (2):
  scsi: ufs: Introduce a vops for resetting host controller
  scsi: ufs-qcom: Add reset control support for host controller

 drivers/scsi/ufs/ufs-qcom.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h |  3 +++
 drivers/scsi/ufs/ufshcd.c   | 16 ++++++++++++++++
 drivers/scsi/ufs/ufshcd.h   | 10 ++++++++++
 4 files changed, 72 insertions(+)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

