Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F39C33CA2
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 12:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD35D2072E
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 12:45:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSGy+ABE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgAJMpW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:45:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46642 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbgAJMpW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 07:45:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so1081001pff.13;
        Fri, 10 Jan 2020 04:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kIXyMxyHb52Dqb3xzKBUlHwhFwf+AsnzOx4pqWqWlWY=;
        b=MSGy+ABEyjJHqfkpma0mmsRX+Uc9gPbqiEVJYZR0c24iUoUTjVte/QICQT5sU9I4w+
         DGzNNWyxHTi2QSD86mJ2nW26ainZZG+8VCaCx4ZiHMaESa44V7ievBtxPfIwbfG25vbd
         j9hUsK65W/rw4T3+4CmHr5BgpkmftWP91D/6S3Ce/cbwBO87Aq2oalpuPrPO8xw82aTw
         5XzmUEf1IZfc8Rv3qgg1YsgfPCRPrUtLC4zB3zSvx2y55MgRKTE99hNgVGvkfejHi1JP
         pCGJv5MFK2eN14Gh7he9aieLiX78y2uCsJSzbyeDHIA1GYGUj/ZqRSj1K9Ex5zbz+/f/
         d9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kIXyMxyHb52Dqb3xzKBUlHwhFwf+AsnzOx4pqWqWlWY=;
        b=Uxv9TxX41udFQi2WDmsACq4nR1xNiO0XLP+3wYSykuj2FbktIkxClYiaPoWV/tsSaC
         65nu4HCRb8uNhN4RtQwQbTVV3IZuJwVNX3IK3aM5+tobn3yct3foZAqgknzzZfU8cQCZ
         Xs7b7+IgDGyEnHfwfVpeDfD+iSwGrasj4P7MJG1JdLir0X/mFA4e+xlZ3aFfKyJDBOHp
         OlyTKCs/nmnxIQJY3YXNnfHZM2EMpuYyaKrqylgl9fnm0kbGgmVMwE1JTCktNE121lO1
         lzOdIIViaiE5ObrrpWbDthfDShdp+cwhSaZAlWiABKJp0jxmWkG90hLDYBspK6jbHNs8
         9m+w==
X-Gm-Message-State: APjAAAXUW89kDUDKEfttUvsIT3WOGK3SWd947O47hTOCoOS1gtzGpmEz
        b2ZsTARdU8YqVIByClS575A=
X-Google-Smtp-Source: APXvYqxsIaCvT7AXhc5HwdvbwnGjpRwaKBcXZvcvLZoaWm6p426Edsi9yrJobhbKmJFqnsUmEQ66aw==
X-Received: by 2002:a63:4d1b:: with SMTP id a27mr4092403pgb.352.1578660320827;
        Fri, 10 Jan 2020 04:45:20 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.220])
        by smtp.googlemail.com with ESMTPSA id d3sm2764724pfn.113.2020.01.10.04.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 04:45:20 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH 3/3] drivers: target: tcm_fc: tfc_sess: Pass lockdep expression to RCU lists
Date:   Fri, 10 Jan 2020 18:14:06 +0530
Message-Id: <20200110124403.27882-3-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110124403.27882-1-frextrite@gmail.com>
References: <20200110124403.27882-1-frextrite@gmail.com>
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

Add macro for the corresponding lockdep expression to make the code
clean and concise.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4fd6a1de947c..8e9598010fb9 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -32,6 +32,9 @@
 		 (lport)->host->host_no,	   \
 		 (lport)->port_id, ##args )
 
+#define ft_lport_lock_held() \
+	lockdep_is_held(&ft_lport_lock)
+
 static void ft_sess_delete_all(struct ft_tport *);
 
 /*
@@ -45,7 +48,7 @@ static struct ft_tport *ft_tport_get(struct fc_lport *lport)
 	int i;
 
 	tport = rcu_dereference_protected(lport->prov[FC_TYPE_FCP],
-					  lockdep_is_held(&ft_lport_lock));
+							ft_lport_lock_held());
 	if (tport && tport->tpg)
 		return tport;
 
@@ -170,7 +173,7 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 	}
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash, ft_lport_lock_held()) {
 		if (sess->port_id == port_id) {
 			kref_get(&sess->kref);
 			rcu_read_unlock();
@@ -215,7 +218,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	ft_format_wwn(&initiatorname[0], TRANSPORT_IQN_LEN, rdata->ids.port_name);
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash)
+	hlist_for_each_entry_rcu(sess, head, hash, ft_lport_lock_held())
 		if (sess->port_id == port_id)
 			return sess;
 
@@ -264,7 +267,7 @@ static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
 	struct ft_sess *sess;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash, ft_lport_lock_held()) {
 		if (sess->port_id == port_id) {
 			ft_sess_unhash(sess);
 			return sess;
@@ -291,7 +294,7 @@ static void ft_sess_delete_all(struct ft_tport *tport)
 
 	for (head = tport->hash;
 	     head < &tport->hash[FT_SESS_HASH_SIZE]; head++) {
-		hlist_for_each_entry_rcu(sess, head, hash) {
+		hlist_for_each_entry_rcu(sess, head, hash, ft_lport_lock_held()) {
 			ft_sess_unhash(sess);
 			ft_close_sess(sess);	/* release from table */
 		}
@@ -454,7 +457,7 @@ static void ft_prlo(struct fc_rport_priv *rdata)
 
 	mutex_lock(&ft_lport_lock);
 	tport = rcu_dereference_protected(rdata->local_port->prov[FC_TYPE_FCP],
-					  lockdep_is_held(&ft_lport_lock));
+							ft_lport_lock_held());
 
 	if (!tport) {
 		mutex_unlock(&ft_lport_lock);
-- 
2.24.1

