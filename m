Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF95C388F2
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 19:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06C7322453
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 19:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603223587;
	bh=Ck4Ar+IyWT03Cj7lyMjl0iXTGTkUzUYlY02LiptowzQ=;
	h=From:To:Subject:Date:List-ID:From;
	b=bf3MIlLLsV7Ye0qC/App9bHSO5hGejJAQzsNPUo7WfuQG2MEvhEdtHhg74XJcXpX1
	 MI+AxPLJAg84dM/OxXRV+xpxiLEnbglgxFy9GbRT2TADWCu2aykuKdW80NhqqOqgPK
	 dEyKcs283MYdVQmHhtnuVW0ivusyBkrSS2EIwwCo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438288AbgJTTxE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 15:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391578AbgJTTxE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 15:53:04 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668AA21D7F;
        Tue, 20 Oct 2020 19:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603223583;
        bh=Ck4Ar+IyWT03Cj7lyMjl0iXTGTkUzUYlY02LiptowzQ=;
        h=From:To:Subject:Date:From;
        b=ysfAk9DE909UUlKHzCGxSiz7woVN+4DFf0jbs/qrZtzihXGPK6CBp8jt2/gTDstIC
         C4Mrlj3Wv5/N/G+YESqvZN7wgRt4Jo2CfCEE1OG27md0qIBmF0PlKv7awtxowJBHel
         mq6LubidF//aXyz7crdkEnNad824TWEyu90I7Mzo=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com
Subject: propose some UFS fixes
Date:   Tue, 20 Oct 2020 12:52:53 -0700
Message-Id: <20201020195258.2005605-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change log from v1:
 - remove clkgating_enable check in __ufshcd_release
 - use __uhfshcd_release instead of active_req.


