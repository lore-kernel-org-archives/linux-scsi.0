From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] xen-scsiback: mark expected switch fall-through
Date: Tue, 12 Feb 2019 14:40:35 -0600
Message-ID: <20190212204035.GA8037@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warning:

drivers/xen/xen-scsiback.c: In function ‘scsiback_frontend_changed’:
drivers/xen/xen-scsiback.c:1185:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (xenbus_dev_is_online(dev))
      ^
drivers/xen/xen-scsiback.c:1188:2: note: here
  case XenbusStateUnknown:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

Notice that, in this particular case, the code comment is modified
in accordance with what GCC is expecting to find.

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/xen/xen-scsiback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index e59937293a32..ba0942e481bc 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1184,7 +1184,7 @@ static void scsiback_frontend_changed(struct xenbus_device *dev,
 		xenbus_switch_state(dev, XenbusStateClosed);
 		if (xenbus_dev_is_online(dev))
 			break;
-		/* fall through if not online */
+		/* fall through - if not online */
 	case XenbusStateUnknown:
 		device_unregister(&dev->dev);
 		break;
-- 
2.20.1
