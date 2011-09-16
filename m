From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/4] drivers/scsi/mpt2sas/mpt2sas_transport.c: take size of pointed value, not pointer
Date: Fri, 16 Sep 2011 08:57:34 +0200
Message-ID: <1316156255-19509-3-git-send-email-julia@diku.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-janitors@vger.kernel.org, Kashyap Desai <kashyap.desai@lsi.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Sizeof a pointer-typed expression returns the size of the pointer, not that
of the pointed data.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *e;
type T;
identifier f;
@@

f(...,(T)e,...,
-sizeof(e)
+sizeof(*e)
,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -163,7 +163,7 @@ _transport_set_identify(struct MPT2SAS_A
 		return -EIO;
 	}
 
-	memset(identify, 0, sizeof(identify));
+	memset(identify, 0, sizeof(*identify));
 	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 
 	/* sas_address */
