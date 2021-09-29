Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69D4C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 20:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B89B261503
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 20:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345980AbhI2UIe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 16:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343734AbhI2UIe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 16:08:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EF3C06161C;
        Wed, 29 Sep 2021 13:06:52 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id q127-20020a1ca785000000b0030cb71ea4d1so2606183wme.1;
        Wed, 29 Sep 2021 13:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCuan8PqVfqnGUWPOPdSZ5NGLLTFPShD2dEKb+KnvBc=;
        b=XOWTJwHbNqgmDV8ZBqlTrT30QzWzT4GGbv0gMbOksvByFBZkqmgyz5DNa5LZpwX3eD
         bXKZzUEJEa05j/02zcXAcaA06dTkiM/biSZLBwPCIGwQQgVxMaPz7WpLkkDWUSfxr+PC
         rOwOAVbqWt90NwH9iwgBLvLXgKELkR1C3unCKhRoNNCOXs+XCvZI8vyWTk6k8aoXTTeb
         Halmm8sTb3Fu+7+q0kn2Hr7G5ieksogim6gji4mFPw0rRP5faxcqxkmex/lZHN50igzw
         bLejknhMyZH3H5nIHUMzBaGqdTXGgGNMswBYlEoUWpsh3JriUaY3Qnpdc0BCHs830Ib5
         wHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCuan8PqVfqnGUWPOPdSZ5NGLLTFPShD2dEKb+KnvBc=;
        b=4lMx3sDoZTjmS+9CxDOFWsO998PAowP7JOLrQhSnCHig0WPkvsmP7a7WN6j3VUW4HZ
         1GTRllfwdv+wjulaN+a8iA+eGDDuLtzxXd+IYaYMl6Y33Wnp+XQMGDUhmx5C4lxu0i7K
         3HFmIFQ8lJHGH74OORMzV6eU2tg49c2Fngn00Hhc6pB1rsrp5qjmSeySyVK9QXx2WyDD
         PHUljozt2xFh7CTcvgCbmZ37U5Bv+qpCAHE9UdgGTQG6jr+FZ8ZdVL7iKP3sxP4rO26g
         cKazRl2kLSAF/Z0N2BUUB5HLuL8hydLE+SxFJlFjb3YfXeZszl1fxRFbBGPoiROqoncM
         DZ3g==
X-Gm-Message-State: AOAM533YIu7iJOoZgyboCybijQSqVU70/JwYnKBvt3tcAsCIy5vMq9sw
        7geEf/puiak08GkXgjPTNKA=
X-Google-Smtp-Source: ABdhPJwaqWPyD6uAc20fXCPaayjqc9oFajmTWeiu0CDZtD3IwBgz8T/nu0hxVpj/AwxsD0Ta55XCKQ==
X-Received: by 2002:a1c:2785:: with SMTP id n127mr1813886wmn.155.1632946011149;
        Wed, 29 Sep 2021 13:06:51 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cf3fe089f40c55d147be.dip0.t-ipconnect.de. [2003:e9:4717:cf3f:e089:f40c:55d1:47be])
        by smtp.gmail.com with ESMTPSA id l17sm910405wrx.24.2021.09.29.13.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 13:06:50 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] Two fixes for UFS
Date:   Wed, 29 Sep 2021 22:06:37 +0200
Message-Id: <20210929200640.828611-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

V1--V2:
    Fix a typo in the commit message
V2--V3:
    1. Change patch [2/3] subject
    2. Add new patch [3/3]

Bean Huo (3):
  scsi: ufs: ufshpb: Fix NULL pointer dereference
  scsi: ufs: core: fix ufshcd_probe_hba() prototype to match the
    definition
  scsi: ufs: core: Remove return statement in void function

 drivers/scsi/ufs/ufshcd.c | 3 +--
 drivers/scsi/ufs/ufshpb.c | 3 ---
 2 files changed, 1 insertion(+), 5 deletions(-)

-- 
2.25.1

