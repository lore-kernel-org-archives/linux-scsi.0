From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 16/22] advansys: Eliminate prototypes
Date: Mon, 17 Sep 2007 07:41:06 +0900
Message-ID: <20070915224331U.tomof@acm.org>
References: <11893498072821-git-send-email-matthew@wil.cx>
	<1189867145.3339.3.camel@localhost.localdomain>
	<20070916153134.GA28350@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55540 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbXIPWlR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Sep 2007 18:41:17 -0400
In-Reply-To: <20070916153134.GA28350@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, 16 Sep 2007 09:31:34 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, Sep 15, 2007 at 09:39:05AM -0500, James Bottomley wrote:
> > I get a compile failure at this point in your patch sequence:
> 
> Thanks.  I'd been compiling with CONFIG_ISA=n, so hadn't spotted these
> two problems.  I've set it back to Y now.

If I compile your latest patchset with CONFIG_ISA=n, I got:

drivers/built-in.o: In function `advansys_init':
advansys.c:(.init.text+0x3edc): undefined reference to `isa_register_driver'
advansys.c:(.init.text+0x3efb): undefined reference to `isa_register_driver'
advansys.c:(.init.text+0x3f22): undefined reference to `isa_unregister_driver'
advansys.c:(.init.text+0x3f36): undefined reference to `isa_unregister_driver'
drivers/built-in.o: In function `advansys_exit':
advansys.c:(.exit.text+0x210): undefined reference to `isa_unregister_driver'
advansys.c:(.exit.text+0x21a): undefined reference to `isa_unregister_driver'
make[1]: *** [.tmp_vmlinux1] Error 1
make[1]: Leaving directory `/home/fujita/git/linux-2.6'
make: *** [debian/stamp-build-kernel] Error 2


Is this already fixed like this?

-
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] isa: add fake isa_register_driver and isa_unregister_driver

add fake isa_register_driver and isa_unregister_driver for !CONFIG_ISA
case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/isa.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/isa.h b/include/linux/isa.h
index 1b85533..6d3aaaf 100644
--- a/include/linux/isa.h
+++ b/include/linux/isa.h
@@ -22,7 +22,17 @@ struct isa_driver {
 
 #define to_isa_driver(x) container_of((x), struct isa_driver, driver)
 
+#ifdef CONFIG_ISA
 int isa_register_driver(struct isa_driver *, unsigned int);
 void isa_unregister_driver(struct isa_driver *);
+#else
+static inline int isa_register_driver(struct isa_driver *idrv, unsigned int n)
+{
+	return 0;
+}
+static inline void isa_unregister_driver(struct isa_driver *idrv)
+{
+}
+#endif
 
 #endif /* __LINUX_ISA_H */
-- 
1.5.2.4


