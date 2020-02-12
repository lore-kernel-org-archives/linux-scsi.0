Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD0CC352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 07:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6AAA2073C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 07:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYj9kQWz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgBLHZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 02:25:52 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44876 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgBLHZw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2020 02:25:52 -0500
Received: by mail-pf1-f195.google.com with SMTP id y5so776166pfb.11;
        Tue, 11 Feb 2020 23:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=vsblHe4BrZXvpcTixylwUCR+Uct1lSaVWajbm+319XI=;
        b=HYj9kQWzQZ3fTJMk/bGjgfSATXE1MFXHn2Bh1bfBiqZL5oU1T/C6I4MSTVU5O4AX91
         BM/yA4DXtx9BpAXYND1akj0Z4GZ4pxCjV3+d0y+4jG7rgIhT4EQJCz7TgimW6coMuaW0
         nxKmXGPboS5FSnkZd878rI4rXkrUevqhM3XOsh2oFB+r+hHzwWbiuR9qEeWYJhznIqYp
         Gv17x96BCWlZVUWNYjXZsrE40l1Oug8Qc7+wI0MncYS/I+BxtZvxKNTrU5xbbgxqo55S
         knHy4QuAGo0sHzdH+zkLtT6p8CiEzXMNAUTwoE8I6oyIIzQV8GAHjgSbLFCImIaVYTMD
         iZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=vsblHe4BrZXvpcTixylwUCR+Uct1lSaVWajbm+319XI=;
        b=Pl1l5+fiUqxf4cHv7D8c9z/Xx5JBJYJ2nrA/Ht08DnXqoIui3IqJO2BG5eRzWU3NqK
         pvO6Ss7/IBpFT6Sl/Ks5bCYRLsQTKxFERvyp4WrKQ10Rzd+eSLYyL4vvXEOHilniBY26
         Jmc+MMscX8NY6CwZSTH/yQbZTYJa2oOUwYgp+zGq0f5YyIFS5/j+4VVOm1rUjYl4DDTZ
         te5CbRBglq5x7sTPpAAlrEdDwe4aiJQ5XiIrTmbJYlmW1ndqHYG/cyygwxybsgfMmybT
         swuIAOmQv9zOs5lNSkMHu3Byrj8P4Y08EeFuzfE3DrszaN+VG6WAuwBn4R/1BXNGdzk2
         q8eg==
X-Gm-Message-State: APjAAAUD7qeK3CQgs+1FO+4ewPzSKbxG81D1mHsDbhaF+SVAwSoin+Un
        rccWhMEgU3+OiCVBkq38P8I=
X-Google-Smtp-Source: APXvYqxc/lSW35juqj9FltNn78TjgtbMbrka6XgwjPBR0EJH2QpY1Uqq7tJ3PWBdgH3NEhMLHLi9Jg==
X-Received: by 2002:aa7:8804:: with SMTP id c4mr7328335pfo.214.1581492349926;
        Tue, 11 Feb 2020 23:25:49 -0800 (PST)
Received: from workstation-portable ([103.211.17.79])
        by smtp.gmail.com with ESMTPSA id e2sm5510979pjs.25.2020.02.11.23.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 23:25:49 -0800 (PST)
Date:   Wed, 12 Feb 2020 12:55:43 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH 2/2 RESEND] scsi: qedf: qedf_main: Pass lockdep expression to
 RCU lists
Message-ID: <20200212072543.GI14453@workstation-portable>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212072339.GH14453@workstation-portable>
X-Mailer: git-send-email 2.24.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lport->disc.rports is traversed using list_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of lport->disc.disc_mutex.

Hence, add corresponding lockdep expression to silence false-positive
lockdep warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/scsi/qedf/qedf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 604856e72cfb..17eab7f8cf05 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -420,7 +420,8 @@ static void qedf_link_recovery(struct work_struct *work)
 	 * ADISC since the rport is in state ready.
 	 */
 	mutex_lock(&lport->disc.disc_mutex);
-	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
+	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers,
+				lockdep_is_held(&lport->disc.disc_mutex)) {
 		if (kref_get_unless_zero(&rdata->kref)) {
 			fc_rport_login(rdata);
 			kref_put(&rdata->kref, fc_rport_destroy);
-- 
2.24.1

