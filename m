Return-Path: <SRS0=Jnta=D7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DA0C5517A
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 15:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDA5E222BA
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603552033;
	bh=IqPOti2AVhOtcpidqC0x2uSNRGu2YHFlUB4t2pvldcc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=eeyigx45IOo0ZIDzPqcQE1yup8ikatthbEn3uFeOzMGiw1x1zx58AAcDL9+uNOE/R
	 /vdt2M+qhdu1sSUQ7MkaWBqRXRphpZJkBIYZckyNT3HXPR7zx05JmSDkMcMLcBYXnP
	 0ctVHqVATukd5GKbPGtyO8pTGfZGOY3L/Icqe0+w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760441AbgJXPGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Oct 2020 11:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760429AbgJXPGu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Oct 2020 11:06:50 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FCC920757;
        Sat, 24 Oct 2020 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603552010;
        bh=IqPOti2AVhOtcpidqC0x2uSNRGu2YHFlUB4t2pvldcc=;
        h=From:To:Cc:Subject:Date:From;
        b=JDwosvsOZagUL79j3cTaUZHZeRYqy4Od2EOaXk8rLEkxChgKEtr+Nf8DiatAxMHNQ
         DERFpj0UQePz/eeXLiAM885ZG59CtL71oxo55c7teLas6e0WSlySNbVBW5t3GbvYJm
         Qd4lWWyP009F+YIrM9Rcd/kkuBLyQ/rujjyeNGtk=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org
Subject: [UFS v3] UFS fixes
Date:   Sat, 24 Oct 2020 08:06:41 -0700
Message-Id: <20201024150646.1790529-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change log from v2:
 - use active_req-- instead of __ufshcd_release to avoid UFS timeout

Change log from v1:
 - remove clkgating_enable check in __ufshcd_release
 - use __uhfshcd_release instead of active_req.


