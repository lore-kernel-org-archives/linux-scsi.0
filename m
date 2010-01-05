From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] compat_ioct: fix bsg SG_IO
Date: Tue, 5 Jan 2010 19:41:44 +0900
Message-ID: <20100105194104F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59555 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0AEKl5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jan 2010 05:41:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com

bsg's SG_IO doesn't work on 32-bit userspace and 64-bit kernelspace.

The problem is that both sg and bsg drivers use SG_IO
ioctl. sg_ioctl_trans() does 32/64-bit conversion even against bsg
header. It messes up bsg header. bsg driver gets garbage.

This patch fixes sg_ioctl_trans to handle only sg header (struct
sg_io_hdr).

Reported-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 fs/compat_ioctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 332dd00..86690cf 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -301,6 +301,12 @@ static int sg_ioctl_trans(unsigned int fd, unsigned int cmd,
 	u32 data;
 	void __user *dxferp;
 	int err;
+	int interface_id;
+
+	if (get_user(interface_id, &sgio32->interface_id))
+		return -EFAULT;
+	if (interface_id != 'S')
+		return sys_ioctl(fd, cmd, (unsigned long)sgio32);
 
 	if (get_user(iovec_count, &sgio32->iovec_count))
 		return -EFAULT;
-- 
1.5.6.5

