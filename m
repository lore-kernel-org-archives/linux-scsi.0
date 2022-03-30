Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F57C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 12:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244675AbiC3Mdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Mar 2022 08:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244849AbiC3Mdb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2022 08:33:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C7269CF3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 05:19:27 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso761135wma.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 05:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scaleway.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i9zd2dQv1b+dckkVQAoNyvrn6u4l+WWjTrRCJY9avb4=;
        b=hm2gTGfvcr+gKHiFWNgl3McvCuKkbSidcjmSikGE2WHDK+S0PjSW4IWKACCTBzvQvl
         mtNaLfAEXQj7mk59tyC2kYM/rP5Znd1SgN/qObmd1qORnRqZr8TBox0WAI+ESpmWnJ49
         1QfNehA+F+CmyIM4g3UDWW4n060nYFlgIZxV7A3x/EeX+9h9WHnSClYYONVv/FrU/Pv2
         wMjXw86GZdVoYCxIjrMI1rf4bZNEkJn+1LNtA+1xADNOyvT18i2/tW3o7wNCrc0oUENQ
         cEsjGG1RppIB4hb/D9/bFVjYn3PDapT7Mfi2cGO+gSHXBG/OXqKXwjAoWrAzHYmWI5lE
         IFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i9zd2dQv1b+dckkVQAoNyvrn6u4l+WWjTrRCJY9avb4=;
        b=Lahdbvo7Hxn3+TmCk57OuoUhax0XSaXPIQNcjeEL5VgDAs+up5AQ0WluEnKdx5yVFx
         iVgvSg15ntlzFgpnKwSaQ8xVGnBySbZDfgfK4YLdEESMx6Zvkc4W+8GN2ej8TRGz2zqk
         PJ0h93iKBjsqzLm6OfeF3ZLx1EHLA5hYQKNQfc03ar7ZT0v1uBaACXU5BTaLWTyvPvy+
         SEC8smJsgBZP7pH+FB3JU2UByhGX2DzOwk3wq9+Ly3uz1l38HE8gry+MCQIUBJnrnGkn
         xplN6XG3XDMXXleFPZmbLGwdW0QDziiYczKJbf0qjAcnkBcA82GRBbGh3Ivl7kUNEazy
         enhQ==
X-Gm-Message-State: AOAM533nhkoy99xJr+PKp9gKIrQYPeQ3Mwp095V3vZZe2AaqYqPkupRP
        8rb4e4vDmZIKma+LcBtelLLfkQ==
X-Google-Smtp-Source: ABdhPJwqa48G6FUZMvw596kPBeWdzdlRXoF5+1rlJ2VbjQpp0ogHX98JpzYe6sffQ2qLU28R24ivfQ==
X-Received: by 2002:a1c:4303:0:b0:38d:43a:82a4 with SMTP id q3-20020a1c4303000000b0038d043a82a4mr4201038wma.37.1648642752995;
        Wed, 30 Mar 2022 05:19:12 -0700 (PDT)
Received: from localhost.localdomain ([195.154.228.158])
        by smtp.googlemail.com with ESMTPSA id 100-20020adf806d000000b00205ba671b25sm9943703wrk.56.2022.03.30.05.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 05:19:12 -0700 (PDT)
From:   Florian Florensa <fflorensa@scaleway.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Florian Florensa <fflorensa@scaleway.com>
Subject: [PATCH] target: iscsi: add vrf support
Date:   Wed, 30 Mar 2022 14:18:01 +0200
Message-Id: <20220330121801.967366-1-fflorensa@scaleway.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows to bind an interface. This brings in VRF support,
among other things.
Such support is useful for highly multi-tenant deployments, where
isolation between tenants is a must.
If an np is bound to an interface, the response to a `sendtargets` will
only contains the targets that are attached to this np.
It has also the added benefit of allowing IP reuse in order to give
clients the freedom of choosing their subnets.
---
 drivers/target/iscsi/iscsi_target.c          | 102 +++++++++++++++++--
 drivers/target/iscsi/iscsi_target.h          |   6 +-
 drivers/target/iscsi/iscsi_target_configfs.c |  17 +++-
 drivers/target/iscsi/iscsi_target_login.c    |  21 ++++
 drivers/target/iscsi/iscsi_target_tpg.c      |  12 ++-
 drivers/target/iscsi/iscsi_target_tpg.h      |   2 +-
 include/target/iscsi/iscsi_target_core.h     |   2 +
 7 files changed, 140 insertions(+), 22 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6fe6a6bab3f4..7bf6c9a23fa2 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -20,6 +20,7 @@
 #include <asm/unaligned.h>
 #include <linux/inet.h>
 #include <net/ipv6.h>
+#include <net/inet_hashtables.h>
 #include <scsi/scsi_proto.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/scsi_tcq.h>
@@ -264,13 +265,21 @@ int iscsit_deaccess_np(struct iscsi_np *np, struct iscsi_portal_group *tpg,
 bool iscsit_check_np_match(
 	struct sockaddr_storage *sockaddr,
 	struct iscsi_np *np,
-	int network_transport)
+	int network_transport,
+	char *iface)
 {
 	struct sockaddr_in *sock_in, *sock_in_e;
 	struct sockaddr_in6 *sock_in6, *sock_in6_e;
-	bool ip_match = false;
+	bool ip_match = false, iface_match = false;
 	u16 port, port_e;
 
+	if (iface && np->iface) {
+		if (!    strcmp(iface, np->iface))
+			iface_match = true;
+	} else if (!iface && !np->iface) {
+		iface_match = true;
+	}
+
 	if (sockaddr->ss_family == AF_INET6) {
 		sock_in6 = (struct sockaddr_in6 *)sockaddr;
 		sock_in6_e = (struct sockaddr_in6 *)&np->np_sockaddr;
@@ -294,6 +303,7 @@ bool iscsit_check_np_match(
 	}
 
 	if (ip_match && (port_e == port) &&
+	    iface_match &&
 	    (np->np_network_transport == network_transport))
 		return true;
 
@@ -302,7 +312,8 @@ bool iscsit_check_np_match(
 
 static struct iscsi_np *iscsit_get_np(
 	struct sockaddr_storage *sockaddr,
-	int network_transport)
+	int network_transport,
+	char *iface)
 {
 	struct iscsi_np *np;
 	bool match;
@@ -316,7 +327,7 @@ static struct iscsi_np *iscsit_get_np(
 			continue;
 		}
 
-		match = iscsit_check_np_match(sockaddr, np, network_transport);
+		match = iscsit_check_np_match(sockaddr, np, network_transport, iface);
 		if (match) {
 			/*
 			 * Increment the np_exports reference count now to
@@ -335,17 +346,18 @@ static struct iscsi_np *iscsit_get_np(
 
 struct iscsi_np *iscsit_add_np(
 	struct sockaddr_storage *sockaddr,
-	int network_transport)
+	int network_transport,
+	char *iface)
 {
-	struct iscsi_np *np;
-	int ret;
+	struct iscsi_np	*np;
+	int		ret;
 
 	mutex_lock(&np_lock);
 
 	/*
 	 * Locate the existing struct iscsi_np if already active..
 	 */
-	np = iscsit_get_np(sockaddr, network_transport);
+	np = iscsit_get_np(sockaddr, network_transport, iface);
 	if (np) {
 		mutex_unlock(&np_lock);
 		return np;
@@ -359,6 +371,9 @@ struct iscsi_np *iscsit_add_np(
 
 	np->np_flags |= NPF_IP_NETWORK;
 	np->np_network_transport = network_transport;
+	if (iface) {
+		np->iface = kstrdup(iface, GFP_KERNEL);
+	}
 	spin_lock_init(&np->np_thread_lock);
 	init_completion(&np->np_restart_comp);
 	INIT_LIST_HEAD(&np->np_list);
@@ -468,6 +483,10 @@ int iscsit_del_np(struct iscsi_np *np)
 		&np->np_sockaddr, np->np_transport->name);
 
 	iscsit_put_transport(np->np_transport);
+	if (np->iface) {
+		kfree(np->iface);
+		np->iface = NULL;
+	}
 	kfree(np);
 	return 0;
 }
@@ -1732,7 +1751,7 @@ int iscsit_setup_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		if (!cmd)
 			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 						 (unsigned char *)hdr);
-		
+
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
 					 (unsigned char *)hdr);
 	}
@@ -3343,6 +3362,68 @@ iscsit_send_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 
 #define SENDTARGETS_BUF_LIMIT 32768U
 
+static inline bool match_port(struct sockaddr *addr, struct sock *sk);
+static inline bool match_port(struct sockaddr *addr, struct sock *sk)
+{
+	struct sockaddr_in *sock_in_e;
+	struct sockaddr_in6 *sock_in6_e;
+	u16 port, port_e;
+	__portpair ports;
+
+	port = sk->sk_dport;
+	if (sk->sk_family == AF_INET6) {
+		sock_in6_e = (struct sockaddr_in6 *)addr;
+		port_e = ntohs(sock_in6_e->sin6_port);
+	} else {
+		sock_in_e = (struct sockaddr_in *)addr;
+		port_e = ntohs(sock_in_e->sin_port);
+	}
+	ports = INET_COMBINED_PORTS(port, port_e);
+	return (sk->sk_portpair == ports);
+}
+
+static inline bool match_addr(struct sockaddr *addr, struct sock *sk);
+static inline bool match_addr(struct sockaddr *addr, struct sock *sk)
+{
+	struct sockaddr_in *sock_in_e;
+	struct sockaddr_in6 *sock_in6_e;
+
+	if (inet_addr_is_any(addr))
+		return true;
+	if (sk->sk_family == AF_INET6) {
+		sock_in6_e = (struct sockaddr_in6 *)addr;
+		return (!memcmp(&sk->sk_v6_rcv_saddr,
+					&sock_in6_e->sin6_addr,
+					sizeof(struct in6_addr)));
+	}
+	sock_in_e = (struct sockaddr_in *)addr;
+	return (sk->sk_rcv_saddr == sock_in_e->sin_addr.s_addr);
+}
+
+static bool match_conn(struct iscsi_np *np, struct iscsi_conn *conn);
+static bool match_conn(struct iscsi_np *np, struct iscsi_conn *conn)
+{
+	/*
+	 * when the target listen on ::0 it also replies for 0.0.0.0
+	 * so avoid discarding the packet if it the ss_family does not
+	 * match if the ip we are bound to is one of those.
+	 */
+	if (conn->sock->sk->sk_family != np->np_sockaddr.ss_family
+			&& !inet_addr_is_any((struct sockaddr *)&np->np_sockaddr)) {
+		return false;
+	}
+	if (np->iface != NULL && np->ifindex != conn->sock->sk->sk_bound_dev_if) {
+		return false;
+	}
+	if (!match_port((struct sockaddr *)&np->np_sockaddr, conn->sock->sk)) {
+		return false;
+	}
+	if (!match_addr((struct sockaddr *)&np->np_sockaddr, conn->sock->sk)) {
+		return false;
+	}
+	return true;
+}
+
 static int
 iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
 				  enum iscsit_transport_type network_transport,
@@ -3421,6 +3502,9 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
 				struct iscsi_np *np = tpg_np->tpg_np;
 				struct sockaddr_storage *sockaddr;
 
+				if (match_conn(np, conn) == false)
+					continue;
+
 				if (np->np_network_transport != network_transport)
 					continue;
 
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index b35a96ded9c1..560887c83a23 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -24,9 +24,11 @@ extern void iscsit_login_kref_put(struct kref *);
 extern int iscsit_deaccess_np(struct iscsi_np *, struct iscsi_portal_group *,
 				struct iscsi_tpg_np *);
 extern bool iscsit_check_np_match(struct sockaddr_storage *,
-				struct iscsi_np *, int);
+				struct iscsi_np *, int network_transport,
+				char *iface);
 extern struct iscsi_np *iscsit_add_np(struct sockaddr_storage *,
-				int);
+				int network_transport,
+				char *iface);
 extern int iscsit_reset_np_thread(struct iscsi_np *, struct iscsi_tpg_np *,
 				struct iscsi_portal_group *, bool);
 extern int iscsit_del_np(struct iscsi_np *);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0cedcfe207b5..a1e9217d3479 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -92,7 +92,7 @@ static ssize_t lio_target_np_driver_store(struct config_item *item,
 		}
 
 		tpg_np_new = iscsit_tpg_add_network_portal(tpg,
-					&np->np_sockaddr, tpg_np, type);
+					&np->np_sockaddr, tpg_np, type, np->iface);
 		if (IS_ERR(tpg_np_new)) {
 			rc = PTR_ERR(tpg_np_new);
 			goto out;
@@ -158,7 +158,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 {
 	struct iscsi_portal_group *tpg;
 	struct iscsi_tpg_np *tpg_np;
-	char *str, *str2, *ip_str, *port_str;
+	char *str, *str2, *ip_str, *port_str, *iface_str;
 	struct sockaddr_storage sockaddr = { };
 	int ret;
 	char buf[MAX_PORTAL_LEN + 1] = { };
@@ -202,11 +202,18 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 		*port_str = '\0'; /* Terminate string for IP */
 		port_str++; /* Skip over ":" */
 	}
-
+	/* now lets look if there is one more ':' with an interface after */
+	iface_str = strstr(port_str, ":");
+	if (iface_str) {
+		/* It is found */
+		*iface_str = '\0'; /* Terminate string for port */
+		iface_str++;
+	}
 	ret = inet_pton_with_scope(&init_net, AF_UNSPEC, ip_str,
 			port_str, &sockaddr);
 	if (ret) {
-		pr_err("malformed ip/port passed: %s\n", name);
+		pr_err("malformed ip/port/interface passed: %s/%s/%s\n",
+			ip_str, port_str, iface_str);
 		return ERR_PTR(ret);
 	}
 
@@ -233,7 +240,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	 *
 	 */
 	tpg_np = iscsit_tpg_add_network_portal(tpg, &sockaddr, NULL,
-				ISCSI_TCP);
+				ISCSI_TCP, iface_str);
 	if (IS_ERR(tpg_np)) {
 		iscsit_put_tpg(tpg);
 		return ERR_CAST(tpg_np);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 9c01fb864585..01038fe9f834 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -17,6 +17,7 @@
 #include <linux/tcp.h>        /* TCP_NODELAY */
 #include <net/ip.h>
 #include <net/ipv6.h>         /* ipv6_addr_v4mapped() */
+#include <net/sock.h>          /* sock_bindtoindex() */
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
@@ -856,6 +857,8 @@ int iscsit_setup_np(
 	struct sockaddr_storage *sockaddr)
 {
 	struct socket *sock = NULL;
+	struct net *net = NULL;
+	struct net_device *dev = NULL;
 	int backlog = ISCSIT_TCP_BACKLOG, ret, len;
 
 	switch (np->np_network_transport) {
@@ -902,6 +905,24 @@ int iscsit_setup_np(
 		tcp_sock_set_nodelay(sock->sk);
 	sock_set_reuseaddr(sock->sk);
 	ip_sock_set_freebind(sock->sk);
+	if (np->iface) {
+		net = sock_net(sock->sk);
+		rcu_read_lock();
+		dev = dev_get_by_name_rcu(net, np->iface);
+		if (dev) {
+			np->ifindex = dev->ifindex;
+			rcu_read_unlock();
+			ret = sock_bindtoindex(sock->sk, np->ifindex, true);
+			if (ret < 0) {
+				pr_err("sock_bindtoindex() failed: %d\n", ret);
+				goto fail;
+			}
+		} else {
+			rcu_read_unlock();
+			pr_err("dev_get_by_name_rcu() failed\n");
+			goto fail;
+		}
+	}
 
 	ret = kernel_bind(sock, (struct sockaddr *)&np->np_sockaddr, len);
 	if (ret < 0) {
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 2d5cf1714ae0..2df14a9ab712 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -423,7 +423,8 @@ struct iscsi_tpg_np *iscsit_tpg_locate_child_np(
 static bool iscsit_tpg_check_network_portal(
 	struct iscsi_tiqn *tiqn,
 	struct sockaddr_storage *sockaddr,
-	int network_transport)
+	int network_transport,
+	char *iface)
 {
 	struct iscsi_portal_group *tpg;
 	struct iscsi_tpg_np *tpg_np;
@@ -438,7 +439,7 @@ static bool iscsit_tpg_check_network_portal(
 			np = tpg_np->tpg_np;
 
 			match = iscsit_check_np_match(sockaddr, np,
-						network_transport);
+						network_transport, iface);
 			if (match)
 				break;
 		}
@@ -456,14 +457,15 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 	struct iscsi_portal_group *tpg,
 	struct sockaddr_storage *sockaddr,
 	struct iscsi_tpg_np *tpg_np_parent,
-	int network_transport)
+	int network_transport,
+	char *iface)
 {
 	struct iscsi_np *np;
 	struct iscsi_tpg_np *tpg_np;
 
 	if (!tpg_np_parent) {
 		if (iscsit_tpg_check_network_portal(tpg->tpg_tiqn, sockaddr,
-				network_transport)) {
+				network_transport, iface)) {
 			pr_err("Network Portal: %pISc already exists on a"
 				" different TPG on %s\n", sockaddr,
 				tpg->tpg_tiqn->tiqn);
@@ -478,7 +480,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	np = iscsit_add_np(sockaddr, network_transport);
+	np = iscsit_add_np(sockaddr, network_transport, iface);
 	if (IS_ERR(np)) {
 		kfree(tpg_np);
 		return ERR_CAST(np);
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index 88576f5d0ca4..bc8b8e81fdb6 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -33,7 +33,7 @@ extern void iscsit_tpg_del_external_nps(struct iscsi_tpg_np *);
 extern struct iscsi_tpg_np *iscsit_tpg_locate_child_np(struct iscsi_tpg_np *, int);
 extern struct iscsi_tpg_np *iscsit_tpg_add_network_portal(struct iscsi_portal_group *,
 			struct sockaddr_storage *, struct iscsi_tpg_np *,
-			int);
+			int network_transport, char *iface);
 extern int iscsit_tpg_del_network_portal(struct iscsi_portal_group *,
 			struct iscsi_tpg_np *);
 extern int iscsit_ta_authentication(struct iscsi_portal_group *, u32);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index adc87de0362b..8e8aeab4916b 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -795,6 +795,8 @@ struct iscsi_np {
 	void			*np_context;
 	struct iscsit_transport *np_transport;
 	struct list_head	np_list;
+	char 			*iface;
+	int			ifindex;
 } ____cacheline_aligned;
 
 struct iscsi_tpg_np {
-- 
2.35.1

