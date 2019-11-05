Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3C9CA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7D520848
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfKEAmd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:42:33 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42356 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbfKEAmd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:42:33 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so5567164pfh.9
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:42:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+yPQpAvPT7ibbPAMOoL+P73ft1KcFADur/Qo4siPU/E=;
        b=QKI7pwzqkfgZxHIVnzGUNcOqecRelXsI4ipLLEsxTtlLUxQ+uyCCqrJF+v3+WdOS1F
         GljXztNkQeLoFs40T7Ra11WFJ4ssnyD0f1ah+OkW/teAG86TVDMns23ryjojDDnaiKAa
         7iw0g7N5D+QPNZz7OITmtWAWTFbB5WNjToEfpVQ4k5Isb3yngV3y3nru1zMK7ejM1/ei
         3VK802OR586i8/tCdPpBw4H3vdGpx6COkHKWcaUluFnh2frmLJQfqSC0jaYBSIWlc9IR
         BPQFx22hiMvq7YvT2r085o9HyXr3dwlHRr1Il0KTm4wobpGGq6jw43yhV2LYZocuHTwu
         gaFw==
X-Gm-Message-State: APjAAAVprTck77sgIivdxEDSogE2p8HIhfquTLqJO3RzDLsO2iMI/coK
        6jiRK847SMzjijbRMpM7PD9erp5R
X-Google-Smtp-Source: APXvYqxutFvX8uIo3O0jNnIQ6HfgehlBM8cah02nYBCIHVYfUlMtfVlRa/m+irQ8iTI9vbJfzZ1teg==
X-Received: by 2002:a63:cd47:: with SMTP id a7mr31730029pgj.29.1572914552696;
        Mon, 04 Nov 2019 16:42:32 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a21sm4235449pjv.20.2019.11.04.16.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 16:42:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC v2 0/5] Simplify and optimize the UFS driver
Date:   Mon,  4 Nov 2019 16:42:21 -0800
Message-Id: <20191105004226.232635-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

As promised, this is v2 of the patch series that simplifies and optimizes the
UFS driver. These patches are entirely untested. Any feedback is welcome.

Thanks,

Bart.

Bart Van Assche (5):
  Allow SCSI LLDs to reserve block layer tags
  ufs: Use reserved tags for TMFs
  ufs: Avoid busy-waiting by eliminating tag conflicts
  ufs: Use blk_{get,put}_request() to allocate and free TMFs
  ufs: Simplify the clock scaling mechanism implementation

 drivers/scsi/scsi_lib.c   |   1 +
 drivers/scsi/ufs/ufshcd.c | 349 +++++++++++++++-----------------------
 drivers/scsi/ufs/ufshcd.h |  21 +--
 include/scsi/scsi_host.h  |   2 +
 4 files changed, 142 insertions(+), 231 deletions(-)

-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

