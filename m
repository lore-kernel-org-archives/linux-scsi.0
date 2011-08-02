From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/11] drivers/message/fusion/mptsas.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:34:55 +0200
Message-ID: <1312281304-11847-3-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptsas.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3410,8 +3410,7 @@ mptsas_expander_event_add(MPT_ADAPTER *i
 	__le64 sas_address;
 
 	port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
-	if (!port_info)
-		BUG();
+	BUG_ON(!port_info);
 	port_info->num_phys = (expander_data->NumPhys) ?
 	    expander_data->NumPhys : 1;
 	port_info->phy_info = kcalloc(port_info->num_phys,
