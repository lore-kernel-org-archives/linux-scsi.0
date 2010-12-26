From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] SCSI, LSI Fusion MPT: Fix memory leak in
 mptctl_getiocinfo()
Date: Sun, 26 Dec 2010 22:14:01 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1012262207380.20797@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: DL-MPTFusionLinux@lsi.com
Cc: Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, support@lsi.com
List-Id: linux-scsi@vger.kernel.org

Hi,

A 'kfree(karg)' is missing in a failure path in 
drivers/message/fusion/mptctl.c::mptctl_getiocinfo() which can cause a 
memory leak. This patch should take care of that.

Hope I didn't miss something obvious, but to me it looks like adding this 
kfree() is the right thing to do. If you disagree feel free to correct me 
:-)


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mptctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

  compile tested only since I don't have proper hardware to test for real.

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index a3856ed..1dcc13a 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1307,8 +1307,10 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 	else
 		karg->adapterType = MPT_IOCTL_INTERFACE_SCSI;
 
-	if (karg->hdr.port > 1)
+	if (karg->hdr.port > 1) {
+		kfree(karg);
 		return -EINVAL;
+	}
 	port = karg->hdr.port;
 
 	karg->port = port;


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
