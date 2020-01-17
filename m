Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1256DC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD93C20728
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QyKqaoH+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgAQNlH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:41:07 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51660 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgAQNlH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 08:41:07 -0500
Received: by mail-pj1-f66.google.com with SMTP id d15so3197767pjw.1;
        Fri, 17 Jan 2020 05:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vE1QPJ0SsgxgZYx5CvnPncdHxn/8vBh0HdyoKU9Gboc=;
        b=QyKqaoH+S7cm0Jz+wqB3aUsuCAEVsyOkfTyoJu/lD2StQmcz4wXD9K4G6QCJGCqJyM
         d2GaoGlBDsQTgTAbsBMghbdHZGNTkKoNN/DoCzG3LXNr01LjT/0frdFgMrklukbG6UkS
         uMbn1hNP7RqshM6Im9nt0ybplspZwD9uvUKqaYpiTNAQv0cW1yC7kmj0cxSw1ZLl+bp4
         bP/OAeQWtk2y8K2aPR2ZzcbNaI18TycgH+uPEzHEgYl1y3xUhvqQ+avg3+LJ51WLuDQ2
         8mtSSe0hsaUh5/yfj9bYt9zDuU+3MKYHfDvD1cpMG1toB8N7sLZdjUGMuOCjICoh7QDC
         Nxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vE1QPJ0SsgxgZYx5CvnPncdHxn/8vBh0HdyoKU9Gboc=;
        b=tEvIZYXTclDCBdBYhpAjNhxzK0WnNBAxGb0uNMjLzaYiySi1vAKUxFb2YZpDgELNmn
         iY5XFvw1ly7+RV7MJcqsb0OrheBTeQJ4IQTSfIp2YN3KTznrzsp/WyGYHcH7r2M3wsVM
         aEpIg+16s0Ox3tnBfZgo+l/35Ca84XYGw3s/ZrYltTCufHwVKJNsmWB4Ssv819uf/XTl
         ncGpYfEh3d4TMNzOkIbkoHq1utkjAhulhtaHcYUEIUinaffWd442oAZTvhSuJl3eCUyq
         5koqS0mqRbiiN6Di8YjUch7C8Fy2gCZBdzaxo6w+yKSw6T5sVkBbYOcQ6JSL9HpOFyGl
         UQpg==
X-Gm-Message-State: APjAAAWHd7GCGuWj18jdYg17sE8394+rZ4f1TUnpXAYnGckjWNbwGYYO
        AK6M/ocJaEd7XNELpFzij4A=
X-Google-Smtp-Source: APXvYqyQiDEahs+oIzffeKILq7/OIWWVxIE6YttQb0yHyVlEqqUNkaiw4IM+bhlTOdmqc4t/23TRKA==
X-Received: by 2002:a17:90a:fe8:: with SMTP id 95mr5663027pjz.98.1579268466421;
        Fri, 17 Jan 2020 05:41:06 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.168])
        by smtp.googlemail.com with ESMTPSA id s18sm29522422pfh.179.2020.01.17.05.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:41:05 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH v3 3/3] drivers: target: tcm_fc: tfc_sess: Pass lockdep expression to RCU lists
Date:   Fri, 17 Jan 2020 19:08:57 +0530
Message-Id: <20200117133854.32550-3-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117133854.32550-1-frextrite@gmail.com>
References: <20200117133854.32550-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

head is traversed with hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the
protection of ft_lport_lock.

Hence, add the corresponding lockdep expression to the list traversal
primitive to silence false-positive lockdep warnings, and
harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4fd6a1de947c..bb70f61237a6 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -170,7 +170,8 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 	}
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash,
+				 lockdep_is_held(&ft_lport_lock)) {
 		if (sess->port_id == port_id) {
 			kref_get(&sess->kref);
 			rcu_read_unlock();
@@ -215,7 +216,8 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	ft_format_wwn(&initiatorname[0], TRANSPORT_IQN_LEN, rdata->ids.port_name);
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash)
+	hlist_for_each_entry_rcu(sess, head, hash,
+				 lockdep_is_held(&ft_lport_lock))
 		if (sess->port_id == port_id)
 			return sess;
 
@@ -264,7 +266,8 @@ static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
 	struct ft_sess *sess;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash,
+				 lockdep_is_held(&ft_lport_lock)) {
 		if (sess->port_id == port_id) {
 			ft_sess_unhash(sess);
 			return sess;
@@ -291,7 +294,8 @@ static void ft_sess_delete_all(struct ft_tport *tport)
 
 	for (head = tport->hash;
 	     head < &tport->hash[FT_SESS_HASH_SIZE]; head++) {
-		hlist_for_each_entry_rcu(sess, head, hash) {
+		hlist_for_each_entry_rcu(sess, head, hash,
+					 lockdep_is_held(&ft_lport_lock)) {
 			ft_sess_unhash(sess);
 			ft_close_sess(sess);	/* release from table */
 		}
-- 
2.24.1

