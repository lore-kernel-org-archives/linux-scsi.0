Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F090C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E728D214DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDBjqc3W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKKXEN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:04:13 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39637 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfKKXEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 18:04:13 -0500
Received: by mail-wm1-f66.google.com with SMTP id t26so974340wmi.4
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 15:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sbcBd5EPiWiF3zKhyA3dMOPjHlu5UM2nz3691MREhLM=;
        b=EDBjqc3Wr0YnfkLqrTsPQDgBswdjkqOJkmlCPSa+iAa6DoZ971Y8K3oN6A04mm548X
         ZkeDdmXHjrgX/1L+fE582VgAhRTTJ+R+E0YWsQeKazYu+kvbF3ZSwjPTHHWoVrJc2uXu
         Zn/DdkTGh1VW0sek1btv4mL4ojdvee7eXKJziBDY5vQqqcB3TkZS5VCcDXombmcgcIsb
         0DJNN/frqyBE2+9I7FeRccyBuBW/b0/uMHlaXF1ZPLQ6Rlpb0jxk3uktXPOy5Qmpbwmp
         RKzf+5GRQVDDnMaNyxp+yh/RK8dP0rCrQ2Uv/ET0PEboK5eOTkiwRkpfgp1iIWnUYdL9
         fx2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sbcBd5EPiWiF3zKhyA3dMOPjHlu5UM2nz3691MREhLM=;
        b=llwcCgeKsCxvvS4ToZKIdexKNidehFA5m1Kad/Lo6eo3GZl3qc10wtFtC2wAuUrj5D
         wx4ncZWEYPNgBZ/Vcu3LSw7e4Jf74XWD8h3uOSBb1k+YXCWqCPuUJK2ewwZ0viKhjj2w
         n6tvhifYZuF0Oa9sKyfAuTusOhXU4SfQF0SFr0ueDQgpnlArMoHEaBffS7kHq0pqVFPy
         c52epBF3aCphJ5KnnpMfxaFiobJGuK9YwmQkXI1PRMnraj0tnxCAPYGdHkBP6BxHfzM/
         P7WKh5JCxm+WYuFqPY/QnMlaAWMwapJxZcwodgfE+2yCO0EZ6xkWScdSdkpvierhQMIn
         hesg==
X-Gm-Message-State: APjAAAVERbxmFs5YhNc6dkVsaccK1iBe+gddrUdySRHRcqBqml/3aLhb
        0xPUbyJqWt9LQRPGDCKrF176z6vl
X-Google-Smtp-Source: APXvYqxyWr6A6U9m6JF0BXulg2GyN38ZVhibzb9RXuNtZv2fS62ayCAxU6BO6NNhlIxVvx/UsvvJBQ==
X-Received: by 2002:a1c:7905:: with SMTP id l5mr1244484wme.76.1573513451073;
        Mon, 11 Nov 2019 15:04:11 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m25sm655146wmi.46.2019.11.11.15.04.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 15:04:10 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/6] lpfc: Update lpfc to revision 12.6.0.1
Date:   Mon, 11 Nov 2019 15:03:55 -0800
Message-Id: <20191111230401.12958-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.6.0.2

This patch set contains:
two fixes for coverity reports
one fix for a compilation error
a driver fix to address hot-cpu add conditions
and a oneliner that is cleanup

The patches were cut against Martin's 5.5/scsi-queue tree


James Smart (6):
  lpfc: fix: Coverity: lpfc_get_scsi_buf_s3(): Null pointer dereferences
  lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences
  lpfc: fix inlining of lpfc_sli4_cleanup_poll_list()
  lpfc: Initialize cpu_map for not present cpus
  lpfc: revise nvme max queues to be hdwq count
  lpfc: Update lpfc version to 12.6.0.2

 drivers/scsi/lpfc/lpfc_crtn.h    |  2 +-
 drivers/scsi/lpfc/lpfc_els.c     |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 19 ++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_nvme.c    | 10 ++++------
 drivers/scsi/lpfc/lpfc_scsi.c    |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c     |  2 +-
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 7 files changed, 27 insertions(+), 12 deletions(-)

-- 
2.13.7

