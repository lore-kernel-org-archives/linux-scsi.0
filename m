Received: from outbound.st.icloud.com (st-2005a-snip4-11.eps.apple.com [57.103.79.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1973D3C10B3
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 03:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.79.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787109838; cv=none; b=sYGo3P/CpaItdo6/Xchro2CmRuQktH5NSJbqkV7ZPrl7OjO/QuT/SjOPE0oILNRqq94q4/a1uWDkvObLfK2tADR2ztiZXp24jzlS6fXYiNhtrEFd28vJpgwrb0qvNRu1HBMmOkZn/ZUGL08yNcB1pdMdAa9kYWDjjPh46eJo+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787109838; c=relaxed/simple;
	bh=BHNyEvWPJ0Ey7j5CpoNSJamzGBuA10cplBY2o6z+Njo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqZFMrcMZ7S8Ij7Z29x1OvNr7Oxzjrw5pifC72TWDoECaE0uMvAo1GZVjncA3R6dGytiWMZskSbdszxup/0E+zezkMSUKG7h3Wh7LOhkl+txxICK4GEnaQxIjCdpcAgNEqN8gsA6IGkbkrDBnpViE0QVXntGsWGmFJwjSvdS7mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=fXv1nIxH; arc=none smtp.client-ip=57.103.79.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="fXv1nIxH"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id 899B7180013F;
	Wed, 19 Aug 2026 03:23:53 +0000 (UTC)
X-ICL-RepId: 01a0180b-fb10-788f-a299-be360f6a6a03
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKC0MFWgNeC00HQwZdBlBcHA4IRANTEVdKA14GK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUETV8OXh8EF0YZVQRHHl1WQBkZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRAAUkKXQRZAUIIVgdUBFwGRhRMHghEA1MRV0oDXgYrWxNVF0YJGQhdHQdYRxRHDg8ZWhRcGFM=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1787109836; x=1789701836; bh=0csZxPtpdL06F6YoeqB2WGBY3JiZ/fSYugpxG0y+uQI=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=fXv1nIxHw5ij2TzTgqEd8qMs9x2wszCI1nJhiJxM5f8O25SGWKjUtK3nh94r0Tl9WZh58dx/WdT9u+Bs9gRVjqptL31aznHL9LgMFgQtW5xIHp/DbmzxWJSePnuY593QgBzxKqM9a44UpDeWwDVR4pIDab9hl1AHUrWLVh5tQQuptASS4cuTBPtHZGyz2FKvoj5PSSKXnSmva7ntb77kqDEcM9DV0TSSQ4yo0jLPweXeBWbr7x/27BcaEAb/R4dOakbxJqvlAW65kCKSu0C0aukBqy0LUQCtZYvJda8ZUzeAWhpE8iCT8FoIfgshmxS6mm2GW9TWDORTnNAkafuwTQ==
Received: from machine.resnet.purdue.edu (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id AC9D7180013D;
	Wed, 19 Aug 2026 03:23:52 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v4 3/3] scsi: libsas: Handle errors in  sas_ex_discover_expander()
Date: Tue, 18 Aug 2026 23:23:21 -0400
Message-ID: <20260819032321.493746-4-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819032321.493746-1-eshaan2031@icloud.com>
References: <20260819032321.493746-1-eshaan2031@icloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=a/Y9NESF c=1 sm=1 tr=0 ts=6a8521ca
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=mmTTPH3KzcaUb-IWQLwA:9
X-Proofpoint-GUID: iUwd_iPlbRRR_0N9coyoRd6y5vln6nQq
X-Proofpoint-ORIG-GUID: iUwd_iPlbRRR_0N9coyoRd6y5vln6nQq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAyMiBTYWx0ZWRfX5E6M14pgcQC6
 fUUY3UqorPyc/XaOSyPrKoA5Ud6lVN8qJ0hSHGOK/ZaxQngnY2DUbkuyWsEr16rwWHwuI4xFYHW
 oOgptpbMAFyDipo4uWiEiC+4Lls5nA0HMFi3hFYwxfFNpZVx5EasIgKD+pQp31PSqKSRWmCArpg
 eSYKVyYbFsfAYfI59uBMZolJo1jb7Bdzg0rnIMWGoi/Xk/PI24DaBshuuXJAcJ5tTNIZQihb3ko
 MPIfdTgxIciAdanAC8PBaelbEwKq3XBOEgUo03MxCJp71ZCMXu1YXcPmAHtpIzF31e9bPu8MAiN
 0k980z6/wljA4qKNMQDE8xT+HczlkafJWZZz+fZIe+5Gx3bY7NrED2gavouypE=
X-JNJ: AAAAAAABRpP5xoWQzfLR+nGojbpFGytqCqPXpWE6UPyNV5YffQpFNZLjsl1Osvg9edSDRFekWYZ0tj3umh6LocdxQK60gj27iM2q2xylvuZPm8benJI7updPbSFLgITCV3jqjs+amON4bSLjrpR7m6yVnT6QNq2w6Zvm54a9Xw9NNyc4EcT3fikxSWWto7h8Zmen1ZAXe6dZOCGS4RcpTocIbKtoa8Vlx/yGfya3U8k3VQ/U2XHV3kK2CLXgMXiV1h3xOe9rH7J4kicYKuyvnY9TKoqEpgzR5vYprhEms806gdsMrXr+jU0vohQXnuCsDO+9Hf/2VRy/VpqNQnYxhTNR6/WXi4sQYAR2dn+zV5kq5NuKGDiGjByRt2FkBdys8PfFZTHAqWJfcm3uK3qbtygvDUzMuKQRCtz12LkfqSXQrQYtdy9FIsN0mj2ekW5GP/X9KcyMs0v/gElHeLX5DSXanDZTAzk3Z2EwyHi9SMCTa7IaYASAfbOUlEFQgmr8PPLY2fYf8Oci2lfyD2GLPtl0JGIw9tCOhrVREYZKFtTqmRfOo50yZC4MIe/crW8sXYJtiX0878ZdOxe2bV2p6c7DSnd7BQVHqaC9DFC23MkLLZ1ROiRWAb+6NbVD1X6hxhbXkjMLikNIbYFGSY8ggWH/gy5GRo3qXRNie+6LL0cnt0OzL0pltwj5qtOySbBonp/UO7qvl4/n+hjS08QhVkZfodEGHV9/e1rHDtlQX1XFvmE7NhFOaKEMBRJIf0WQ+0irDwcsLXTS9fofO38uN+ufMvad1bG4Pjs0D83djpUflvhUGA==

The function sas_ex_discover_expander() does not account for the
potential failure of sas_port_alloc() for phy->port. It also calls
BUG_ON in case sas_port_add fails for phy->port. Add a check for
phy->port after sas_port_alloc() where if it is NULL, it cleans up the
child allocated device and returns NULL. Add another check for
sas_port_add() where if it returns an error code it frees phy->port,
sets it to NULL, cleans up the child allocated device, and returns NULL.

Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
---
Changes in v4:
- Removed goto labels from v3 and moved the code back to their original
  spots

 drivers/scsi/libsas/sas_expander.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index ab6afbad3..429ea2bdc 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -911,7 +911,6 @@ static struct domain_device *sas_ex_discover_expander(
 	struct sas_rphy *rphy;
 	struct sas_expander_device *edev;
 	struct asd_sas_port *port;
-	int res;
 
 	if (phy->routing_attr == DIRECT_ROUTING) {
 		pr_warn("ex %016llx:%02d:D <--> ex %016llx:0x%x is not allowed\n",
@@ -925,9 +924,17 @@ static struct domain_device *sas_ex_discover_expander(
 		return NULL;
 
 	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
-	/* FIXME: better error handling */
-	BUG_ON(sas_port_add(phy->port) != 0);
+	if (!phy->port) {
+		sas_put_device(child);
+		return NULL;
+	}
 
+	if (sas_port_add(phy->port)) {
+		sas_port_free(phy->port);
+		phy->port = NULL;
+		sas_put_device(child);
+		return NULL;
+	}
 
 	switch (phy->attached_dev_type) {
 	case SAS_EDGE_EXPANDER_DEVICE:
@@ -966,8 +973,7 @@ static struct domain_device *sas_ex_discover_expander(
 	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
 	spin_unlock_irq(&parent->port->dev_list_lock);
 
-	res = sas_discover_expander(child);
-	if (res) {
+	if (sas_discover_expander(child)) {
 		sas_rphy_delete(rphy);
 		spin_lock_irq(&parent->port->dev_list_lock);
 		list_del(&child->dev_list_node);
@@ -977,6 +983,7 @@ static struct domain_device *sas_ex_discover_expander(
 		phy->port = NULL;
 		return NULL;
 	}
+
 	list_add_tail(&child->siblings, &parent->ex_dev.children);
 	return child;
 }
-- 
2.55.0

