Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BDDC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 15:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF8F8214AF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 15:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GioBOV/K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAQPcG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 10:32:06 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36555 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgAQPcG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 10:32:06 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so12126783pfb.3;
        Fri, 17 Jan 2020 07:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sSs36sQnxGTfCuz7UN6u9y3waBifKuK+zZ5r4rWQl60=;
        b=GioBOV/KlZBgBSV1q0vQurfbNol7EjftOdrGxJkmUfI5btZ9mmT2P/voLGPlsW0wzL
         /nU+vc4Y/pw03lRVA/59moxmZyf1/0Nu96uR1Mt17jKEOxDx+CVkgzVrItAMa+2ewdMh
         A2VFTLHgXu/a0NA1QIs/acmlS3QNxJ7mGZr6xcFsZkCv9CbEShW1hWOr3vaPk6i7egKH
         0LE5E/3FJT3t679mb4lIQaBqzqpKbio7Tvxh2fIbrwlLaFId386YkISWSfkNKsSGh/Fr
         mNabJ1YSUT9U1RVyOyIh9uCY/NZzQ0nFHzqdPTzX9YIj6AxjjDIVjfWXxCxQ1Y21SxHu
         fC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sSs36sQnxGTfCuz7UN6u9y3waBifKuK+zZ5r4rWQl60=;
        b=Htx4YTn7g1jXl1+1TeyK2T9FgPPCVLamELP1aZLS4Am4RBGJgiLLNMsEioljDKKNn4
         v14RV4Um1uYqG0AWUKtP6S8f81qjN88UvE5oXLz2gBqvnT6NSbB8PwnnGJiborNMt4dd
         WwxS0LL9B3SXxM6uUPiSRvlc4h/W3t6/2m4DrQw8OaOiow28IFOEFNzS7lHYC3CCg8H/
         gY1zoBSwDHOhSb7p5gpS6B0aySkTbYjggFOb+/WAN5aIvnTq6UJYIId0Rr1RI7uGYpki
         mc2W5UIBe4qXQrqv0INJl3k74x0qRjHGq2+6ep0dsz8a19KDPeNc/ctBS1dgBY6swu26
         dosQ==
X-Gm-Message-State: APjAAAXbEDLWas8CLMkZ2Zpee5NdfIWTcNf4X5swgQwwfhBWQNNdYD8T
        uzQW2uDgXJaJBANnaDqalNg=
X-Google-Smtp-Source: APXvYqxVVIklnjbZNKYIXkcvzWmglcKInwSSBwjMhbmrS1I+ZzuA3zSryE1Y17hbhg4HKjHYVGFVzw==
X-Received: by 2002:a62:e215:: with SMTP id a21mr3523890pfi.3.1579275125736;
        Fri, 17 Jan 2020 07:32:05 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.168])
        by smtp.googlemail.com with ESMTPSA id d20sm7851020pjs.2.2020.01.17.07.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 07:32:05 -0800 (PST)
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
Subject: [PATCH 1/2] drivers: scsi: fcoe: fcoe_ctlr: Pass lockdep expression to RCU lists
Date:   Fri, 17 Jan 2020 21:01:23 +0530
Message-Id: <20200117153123.2648-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lport->disc.rports and disc->rports are traversed using
list_for_each_entry_rcu outside an RCU read-side critical section but
under the protection of lport->disc.disc_mutex and disc->disc_mutex
respectively.

Hence, add corresponding lockdep expression to silence false-positive
lockdep warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 1791a393795d..0f59992c9cd9 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2167,7 +2167,8 @@ static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
 	struct fc_rport_priv *rdata;
 
 	mutex_lock(&lport->disc.disc_mutex);
-	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
+	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers,
+				lockdep_is_held(&lport->disc.disc_mutex)) {
 		if (kref_get_unless_zero(&rdata->kref)) {
 			fc_rport_logoff(rdata);
 			kref_put(&rdata->kref, fc_rport_destroy);
@@ -2703,7 +2704,8 @@ static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
 
 	next_time = jiffies + msecs_to_jiffies(FIP_VN_BEACON_INT * 10);
 	mutex_lock(&lport->disc.disc_mutex);
-	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
+	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers,
+				lockdep_is_held(&lport->disc.disc_mutex)) {
 		if (!kref_get_unless_zero(&rdata->kref))
 			continue;
 		frport = fcoe_ctlr_rport(rdata);
@@ -3061,7 +3063,8 @@ static void fcoe_ctlr_vn_disc(struct fcoe_ctlr *fip)
 	mutex_lock(&disc->disc_mutex);
 	callback = disc->pending ? disc->disc_callback : NULL;
 	disc->pending = 0;
-	list_for_each_entry_rcu(rdata, &disc->rports, peers) {
+	list_for_each_entry_rcu(rdata, &disc->rports, peers,
+				lockdep_is_held(&disc->disc_mutex)) {
 		if (!kref_get_unless_zero(&rdata->kref))
 			continue;
 		frport = fcoe_ctlr_rport(rdata);
-- 
2.24.1

