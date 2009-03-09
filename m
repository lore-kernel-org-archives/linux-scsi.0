From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] cpumask: use modern cpumask functions in drivers/scsi/fcoe/libfcoe.c
Date: Mon, 9 Mar 2009 14:36:11 +1030
Message-ID: <200903091436.11983.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:48022 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbZCIEGR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Mar 2009 00:06:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Impact: use new API

first_cpu(cpu_online_map) => cpumask_first(cpu_online_mask)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: devel@open-fcoe.org
---
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -237,7 +237,7 @@ int fcoe_rcv(struct sk_buff *skb, struct
 	 */
 	cpu_idx = oxid & (num_online_cpus() - 1);
 	if (!fcoe_percpu[cpu_idx] || !cpu_online(cpu_idx))
-		cpu_idx = first_cpu(cpu_online_map);
+		cpu_idx = cpumask_first(cpu_online_mask);
 #endif
 	fps = fcoe_percpu[cpu_idx];
 
