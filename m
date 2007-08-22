From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: drivers/scsi/advansys.c - ld error ( Re: 2.6.23-rc3-mm1 )
Date: Wed, 22 Aug 2007 10:28:02 -0600
Message-ID: <20070822162802.GJ9163@parisc-linux.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6112.9030705@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35243 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896AbXHVQ2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Aug 2007 12:28:04 -0400
Content-Disposition: inline
In-Reply-To: <46CC6112.9030705@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 22, 2007 at 06:15:14PM +0200, Gabriel C wrote:
> advansys.c:(.init.text+0x38ea): undefined reference to `isa_register_driver'
> I guess advansys_{init,exit} is missing some #ifdef's ..

That's one conclusion.  I prefer to think that the ISA support should
behave the same as the PCI and EISA support:

----

When CONFIG_ISA is disabled, the isa_driver support will not be compiled
in.  Define stubs so that we don't get link-time errors.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/include/linux/isa.h b/include/linux/isa.h
index 1b85533..b0270e3 100644
--- a/include/linux/isa.h
+++ b/include/linux/isa.h
@@ -22,7 +22,18 @@ struct isa_driver {
 
 #define to_isa_driver(x) container_of((x), struct isa_driver, driver)
 
+#ifdef CONFIG_ISA
 int isa_register_driver(struct isa_driver *, unsigned int);
 void isa_unregister_driver(struct isa_driver *);
+#else
+static inline int isa_register_driver(struct isa_driver *d, unsigned int i)
+{
+	return 0;
+}
+
+static inline void isa_unregister_driver(struct isa_driver *d)
+{
+}
+#endif
 
 #endif /* __LINUX_ISA_H */

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
