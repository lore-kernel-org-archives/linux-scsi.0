From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: libcxgbi: use ndev->ifindex to find route
Date: Sat,  5 Aug 2017 19:36:11 +0530
Message-ID: <1501941971-10274-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:3564 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbdHEOGV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Aug 2017 10:06:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

If cxgbi_ep_connect() is called with valid shost
then find associated ndev and use ndev->ifindex
to find route.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 1a4cfa5..512c8f1 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -585,19 +585,21 @@ static struct cxgbi_sock *cxgbi_sock_create(struct cxgbi_device *cdev)
 
 static struct rtable *find_route_ipv4(struct flowi4 *fl4,
 				      __be32 saddr, __be32 daddr,
-				      __be16 sport, __be16 dport, u8 tos)
+				      __be16 sport, __be16 dport, u8 tos,
+				      int ifindex)
 {
 	struct rtable *rt;
 
 	rt = ip_route_output_ports(&init_net, fl4, NULL, daddr, saddr,
-				   dport, sport, IPPROTO_TCP, tos, 0);
+				   dport, sport, IPPROTO_TCP, tos, ifindex);
 	if (IS_ERR(rt))
 		return NULL;
 
 	return rt;
 }
 
-static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
+static struct cxgbi_sock *
+cxgbi_check_route(struct sockaddr *dst_addr, int ifindex)
 {
 	struct sockaddr_in *daddr = (struct sockaddr_in *)dst_addr;
 	struct dst_entry *dst;
@@ -611,7 +613,8 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 	int port = 0xFFFF;
 	int err = 0;
 
-	rt = find_route_ipv4(&fl4, 0, daddr->sin_addr.s_addr, 0, daddr->sin_port, 0);
+	rt = find_route_ipv4(&fl4, 0, daddr->sin_addr.s_addr, 0,
+			     daddr->sin_port, 0, ifindex);
 	if (!rt) {
 		pr_info("no route to ipv4 0x%x, port %u.\n",
 			be32_to_cpu(daddr->sin_addr.s_addr),
@@ -693,11 +696,13 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct rt6_info *find_route_ipv6(const struct in6_addr *saddr,
-					const struct in6_addr *daddr)
+					const struct in6_addr *daddr,
+					int ifindex)
 {
 	struct flowi6 fl;
 
 	memset(&fl, 0, sizeof(fl));
+	fl.flowi6_oif = ifindex;
 	if (saddr)
 		memcpy(&fl.saddr, saddr, sizeof(struct in6_addr));
 	if (daddr)
@@ -705,7 +710,8 @@ static struct rt6_info *find_route_ipv6(const struct in6_addr *saddr,
 	return (struct rt6_info *)ip6_route_output(&init_net, NULL, &fl);
 }
 
-static struct cxgbi_sock *cxgbi_check_route6(struct sockaddr *dst_addr)
+static struct cxgbi_sock *
+cxgbi_check_route6(struct sockaddr *dst_addr, int ifindex)
 {
 	struct sockaddr_in6 *daddr6 = (struct sockaddr_in6 *)dst_addr;
 	struct dst_entry *dst;
@@ -719,7 +725,7 @@ static struct cxgbi_sock *cxgbi_check_route6(struct sockaddr *dst_addr)
 	int port = 0xFFFF;
 	int err = 0;
 
-	rt = find_route_ipv6(NULL, &daddr6->sin6_addr);
+	rt = find_route_ipv6(NULL, &daddr6->sin6_addr, ifindex);
 
 	if (!rt) {
 		pr_info("no route to ipv6 %pI6 port %u\n",
@@ -2536,6 +2542,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 	struct cxgbi_endpoint *cep;
 	struct cxgbi_hba *hba = NULL;
 	struct cxgbi_sock *csk;
+	int ifindex = 0;
 	int err = -EINVAL;
 
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_SOCK,
@@ -2548,13 +2555,15 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 			pr_info("shost 0x%p, priv NULL.\n", shost);
 			goto err_out;
 		}
+
+		ifindex = hba->ndev->ifindex;
 	}
 
 	if (dst_addr->sa_family == AF_INET) {
-		csk = cxgbi_check_route(dst_addr);
+		csk = cxgbi_check_route(dst_addr, ifindex);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (dst_addr->sa_family == AF_INET6) {
-		csk = cxgbi_check_route6(dst_addr);
+		csk = cxgbi_check_route6(dst_addr, ifindex);
 #endif
 	} else {
 		pr_info("address family 0x%x NOT supported.\n",
-- 
2.0.2
