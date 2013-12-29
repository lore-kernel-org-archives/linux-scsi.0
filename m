From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 19/25]  fix error return code
Date: Sun, 29 Dec 2013 23:47:34 +0100
Message-ID: <1388357260-4843-20-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Geoff Levand <geoff@infradead.org>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/scsi/ps3rom.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index e6e2a30..04d77ce 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -387,6 +387,7 @@ static int ps3rom_probe(struct ps3_system_bus_device *_dev)
 	if (!host) {
 		dev_err(&dev->sbd.core, "%s:%u: scsi_host_alloc failed\n",
 			__func__, __LINE__);
+		error = -ENOMEM;
 		goto fail_teardown;
 	}
 
