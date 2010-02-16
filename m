From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 7/9] fnic: lport stats need to be initialized in fnic_probe()
Date: Tue, 16 Feb 2010 12:15:50 -0800
Message-ID: <20100216201550.26581.86985.stgit@localhost.localdomain>
References: <20100216201513.26581.83756.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63823 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0BPUPu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 15:15:50 -0500
In-Reply-To: <20100216201513.26581.83756.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>

Incorrect initialization of lport stats in fnic_probe() causes fnic to
crash at bootup and a node hang if fip is enabled and all links are brought
up after fnic is loaded.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5bab7e0..507e26c 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -700,6 +700,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 		goto err_out_remove_scsi_host;
 	}
 
+	fc_lport_init_stats(lp);
+
 	fc_lport_config(lp);
 
 	if (fc_set_mfs(lp, fnic->config.maxdatafieldsize +

