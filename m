From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mptfusion: mark expected switch fall-through
Date: Mon, 11 Feb 2019 16:45:30 -0600
Message-ID: <20190211224530.GA12844@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warning:

drivers/message/fusion/mptbase.c: In function ‘mptbase_reply’:
drivers/message/fusion/mptbase.c:643:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (event != MPI_EVENT_EVENT_CHANGE)
      ^
drivers/message/fusion/mptbase.c:646:2: note: here
  case MPI_FUNCTION_CONFIG:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

Notice that, in this particular case, the code comment is modified
in accordance with what GCC is expecting to find.

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/message/fusion/mptbase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index ba551d8dfba4..d8882b0a1338 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -642,7 +642,7 @@ mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 			freereq = 0;
 		if (event != MPI_EVENT_EVENT_CHANGE)
 			break;
-		/* else: fall through */
+		/* fall through */
 	case MPI_FUNCTION_CONFIG:
 	case MPI_FUNCTION_SAS_IO_UNIT_CONTROL:
 		ioc->mptbase_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
-- 
2.20.1
