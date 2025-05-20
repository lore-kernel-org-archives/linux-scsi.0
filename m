Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ED2182BC;
	Tue, 20 May 2025 17:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747762484; cv=none; b=o6X6oHQSGQrCJiGkS0TOkhPARVif1gYANsybglsVqI9LsDQgK8RvMk5s6yWwLvp/rcaSUZa8GrNIQHVlEQyx0Gdy1t88LsOJwHlKiQ+AS7/2GO70Fhg82Ep8/qf9jzWe7qwXrqoCfdcgGaXKVXRwnpt3HX94sbGqPlkEjc0gdm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747762484; c=relaxed/simple;
	bh=4Oa/oAs7QoUno9lRk6Vmd+pQV2yim2hp+jaTVoota5M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V/S/RPDo8k11XgdcJOP+H/2fCrlfXtNBFUear8qTle/3gFSrx0BrY3eNMeuvT3Z26PBXTQZmYK4Ov1aj7wq95G2bCIgXLYsYOluV8P5HiRJc1gAT7TMoi9kja5hxbpRYtCx3nYp/DhTHDim+xxRR+PuNI14odj/kYQ+ogW11RsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfZwfM+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfZwfM+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EA6C4CEE9;
	Tue, 20 May 2025 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747762482;
	bh=4Oa/oAs7QoUno9lRk6Vmd+pQV2yim2hp+jaTVoota5M=;
	h=From:To:Cc:Subject:Date:From;
	b=jfZwfM+EtFOzz6o1W4wA7JkhydcX5QsZE1LXPTdGom5UBgQnzBSdDzZTcCARDp8f5
	 Vq26/sS3c4HPDrJW6+6kkbZDzFZhuOmlInC6lqq8/bYBQcWViH5yWm4poeTKpbDicy
	 rUvfEea0TRcffAQe6CJoYFMPCAv0/lCPTcNjzKGciGGowwesF9XUYAYgglPMhbzx60
	 J2HO8WoHVeHV0WKwMzXrEJBc02I6yOcuVyWuVQoOC0L7LDXP7MQTSSi4JTUDReJdXH
	 QH9WVJlsX/2KBGUX20C5U/3opbDlh1VbVFfLsN07z9XjnJ5BcU3nti2XyrTONnvi39
	 Lvpjl7IOfAQfA==
From: Kees Cook <kees@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Simon Horman <horms@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Eric Biggers <ebiggers@google.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH net-next v3] net: core: Convert inet_addr_is_any() to sockaddr_storage
Date: Tue, 20 May 2025 10:34:38 -0700
Message-Id: <20250520173437.make.907-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3953; i=kees@kernel.org; h=from:subject:message-id; bh=4Oa/oAs7QoUno9lRk6Vmd+pQV2yim2hp+jaTVoota5M=; b=owGbwMvMwCVmps19z/KJym7G02pJDBk6e/UWxP4+wt+4oHy5kvm27bypzpd7FIJW7GG36yz5E vBVNOFTRykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwER4PzH8d/R79zXsVMzHwoNr 3S37XUPk1lmqbEzrdW2ICU1iWZ62g+GviKK1l+2mkz+NPMzufv0UoFPKn/pPtmjqu1vVTzf83nq QBQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

All the callers of inet_addr_is_any() have a sockaddr_storage-backed
sockaddr. Avoid casts and switch prototype to the actual object being
used.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/inet.h                | 2 +-
 drivers/nvme/target/rdma.c          | 2 +-
 drivers/nvme/target/tcp.c           | 2 +-
 drivers/target/iscsi/iscsi_target.c | 2 +-
 net/core/utils.c                    | 8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

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
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 2a4536ef6184..79a5aad2e9d0 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1999,7 +1999,7 @@ static void nvmet_rdma_disc_port_addr(struct nvmet_req *req,
 	struct nvmet_rdma_port *port = nport->priv;
 	struct rdma_cm_id *cm_id = port->cm_id;
 
-	if (inet_addr_is_any((struct sockaddr *)&cm_id->route.addr.src_addr)) {
+	if (inet_addr_is_any(&cm_id->route.addr.src_addr)) {
 		struct nvmet_rdma_rsp *rsp =
 			container_of(req, struct nvmet_rdma_rsp, req);
 		struct rdma_cm_id *req_cm_id = rsp->queue->cm_id;
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 12a5cb8641ca..5cd1cf74f8ff 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2194,7 +2194,7 @@ static void nvmet_tcp_disc_port_addr(struct nvmet_req *req,
 {
 	struct nvmet_tcp_port *port = nport->priv;
 
-	if (inet_addr_is_any((struct sockaddr *)&port->addr)) {
+	if (inet_addr_is_any(&port->addr)) {
 		struct nvmet_tcp_cmd *cmd =
 			container_of(req, struct nvmet_tcp_cmd, req);
 		struct nvmet_tcp_queue *queue = cmd->queue;
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 620ba6e0ab07..a2dde08c8a62 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3419,7 +3419,7 @@ iscsit_build_sendtargets_response(struct iscsit_cmd *cmd,
 					}
 				}
 
-				if (inet_addr_is_any((struct sockaddr *)&np->np_sockaddr))
+				if (inet_addr_is_any(&np->np_sockaddr))
 					sockaddr = &conn->local_sockaddr;
 				else
 					sockaddr = &np->np_sockaddr;
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

