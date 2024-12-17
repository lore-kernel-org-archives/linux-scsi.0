Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106EC1F8EE4;
	Tue, 17 Dec 2024 20:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734467696; cv=none; b=B91V96T7sRdzWE8TW+FAi3TCt1nKgd8SF5Ky8qqT/NXajGu5NU0uREAin7YfnfJZy+2yMsYMLxT1RnYgdnsGUmj4Q7I5gJ5GNoS9gi+Ab0wIPiEU4YOfIP7wN/Pvg/bp42YacD3XB3omZjdwGLHjOoEQq2uUgd4eYd2bNMZnouc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734467696; c=relaxed/simple;
	bh=nvnPPN7j/2p/JFEejejW+Qg34E36N01t9rBWoj3OZgM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=flzgx+Gp7iDoEYQIpfCY8FwJA0+/4kNnXGC6CFO0nCLMwqDOIxGuY5vOJ1Bb4Fall/Oza+u9TDuSpUKsyCLLNaYfMRJ6keGnGHSgTCvZG5XEDnYcFsYJ91T5tSV/zIQD1YEFJR7I1QIOo1PXgyS7ffuw7SnjI8JsTY1EErNx8zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsVQxRIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsVQxRIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B71EC4CED3;
	Tue, 17 Dec 2024 20:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734467695;
	bh=nvnPPN7j/2p/JFEejejW+Qg34E36N01t9rBWoj3OZgM=;
	h=From:To:Cc:Subject:Date:From;
	b=LsVQxRIVnTWmK+4yYhndt3mInuvU6Ulb1pJ+dF2ABRL/mwqpll9QvwFYN/kVaDAVj
	 nmml2P7yeZ4cs7yKcMTNpo1oHhZVy/v6otDSGOSxYUbO8OVOBwn5SwOcGEwLH+/rZh
	 COAP0iABpRqOHQIa4GC52DMLTOU/IguAK8DCrbCxPO13jyWqF5phrMQebu/wkemc5F
	 5Em6BzMo73YoxS1/y0Q0qTJ49zUi7Y8THuemgc7BkfYNCWBFd61SGJbbZ0UGlW8ZGJ
	 xzKDOoLJBFpx5Tqhk+5eJdPW57RilOoZJxAUQ9iAla6gKIcEEtOaJ76s/xVlM0sSbh
	 PHl8XF22RXb4w==
From: Kees Cook <kees@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kees Cook <kees@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2] net: core: Convert inet_addr_is_any() to sockaddr_storage
Date: Tue, 17 Dec 2024 12:34:51 -0800
Message-Id: <20241217203447.it.588-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4896; i=kees@kernel.org; h=from:subject:message-id; bh=nvnPPN7j/2p/JFEejejW+Qg34E36N01t9rBWoj3OZgM=; b=owGbwMvMwCVmps19z/KJym7G02pJDOmJD7IXGD1bHnYlpCN4y6Tg3H9XYj89Nfrz4+kPLX+O4 85567JEOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACZS6sHwP3hN4eMGY3eGE5Jq dVe+buJK2Zey8KEWkxbn7C/6h39eM2RkmLRCIm6RyO4Hq9Z7xwQ8alw1TW5+5nTH7UclY4/eXLZ 3CycA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

All the callers of inet_addr_is_any() have a sockaddr_storage-backed
sockaddr. Avoid casts and switch prototype to the actual object being
used.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 v2: drop "extern" in header (hch)
 v1: https://lore.kernel.org/all/20241217012618.work.323-kees@kernel.org/
---
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Simon Horman <horms@kernel.org>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/nvme/target/rdma.c          | 2 +-
 drivers/nvme/target/tcp.c           | 2 +-
 drivers/target/iscsi/iscsi_target.c | 2 +-
 include/linux/inet.h                | 2 +-
 net/core/utils.c                    | 8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 1afd93026f9b..18ea11342af1 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1986,7 +1986,7 @@ static void nvmet_rdma_disc_port_addr(struct nvmet_req *req,
 	struct nvmet_rdma_port *port = nport->priv;
 	struct rdma_cm_id *cm_id = port->cm_id;
 
-	if (inet_addr_is_any((struct sockaddr *)&cm_id->route.addr.src_addr)) {
+	if (inet_addr_is_any(&cm_id->route.addr.src_addr)) {
 		struct nvmet_rdma_rsp *rsp =
 			container_of(req, struct nvmet_rdma_rsp, req);
 		struct rdma_cm_id *req_cm_id = rsp->queue->cm_id;
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 7c51c2a8c109..df24244fb820 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2158,7 +2158,7 @@ static void nvmet_tcp_disc_port_addr(struct nvmet_req *req,
 {
 	struct nvmet_tcp_port *port = nport->priv;
 
-	if (inet_addr_is_any((struct sockaddr *)&port->addr)) {
+	if (inet_addr_is_any(&port->addr)) {
 		struct nvmet_tcp_cmd *cmd =
 			container_of(req, struct nvmet_tcp_cmd, req);
 		struct nvmet_tcp_queue *queue = cmd->queue;
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6002283cbeba..1ce68eda0090 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3471,7 +3471,7 @@ iscsit_build_sendtargets_response(struct iscsit_cmd *cmd,
 					}
 				}
 
-				if (inet_addr_is_any((struct sockaddr *)&np->np_sockaddr))
+				if (inet_addr_is_any(&np->np_sockaddr))
 					sockaddr = &conn->local_sockaddr;
 				else
 					sockaddr = &np->np_sockaddr;
diff --git a/include/linux/inet.h b/include/linux/inet.h
index bd8276e96e60..9158772f3559 100644
--- a/include/linux/inet.h
+++ b/include/linux/inet.h
@@ -55,6 +55,6 @@ extern int in6_pton(const char *src, int srclen, u8 *dst, int delim, const char
 
 extern int inet_pton_with_scope(struct net *net, unsigned short af,
 		const char *src, const char *port, struct sockaddr_storage *addr);
-extern bool inet_addr_is_any(struct sockaddr *addr);
+bool inet_addr_is_any(struct sockaddr_storage *addr);
 
 #endif	/* _LINUX_INET_H */
diff --git a/net/core/utils.c b/net/core/utils.c
index 27f4cffaae05..e47feeaa5a49 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -399,9 +399,9 @@ int inet_pton_with_scope(struct net *net, __kernel_sa_family_t af,
 }
 EXPORT_SYMBOL(inet_pton_with_scope);
 
-bool inet_addr_is_any(struct sockaddr *addr)
+bool inet_addr_is_any(struct sockaddr_storage *addr)
 {
-	if (addr->sa_family == AF_INET6) {
+	if (addr->ss_family == AF_INET6) {
 		struct sockaddr_in6 *in6 = (struct sockaddr_in6 *)addr;
 		const struct sockaddr_in6 in6_any =
 			{ .sin6_addr = IN6ADDR_ANY_INIT };
@@ -409,13 +409,13 @@ bool inet_addr_is_any(struct sockaddr *addr)
 		if (!memcmp(in6->sin6_addr.s6_addr,
 			    in6_any.sin6_addr.s6_addr, 16))
 			return true;
-	} else if (addr->sa_family == AF_INET) {
+	} else if (addr->ss_family == AF_INET) {
 		struct sockaddr_in *in = (struct sockaddr_in *)addr;
 
 		if (in->sin_addr.s_addr == htonl(INADDR_ANY))
 			return true;
 	} else {
-		pr_warn("unexpected address family %u\n", addr->sa_family);
+		pr_warn("unexpected address family %u\n", addr->ss_family);
 	}
 
 	return false;
-- 
2.34.1

