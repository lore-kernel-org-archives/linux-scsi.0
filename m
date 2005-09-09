From: viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2.6.13 1/20] aic94xx: Makefile
Date: Fri, 9 Sep 2005 21:14:35 +0100
Message-ID: <20050909201435.GB9623@ZenIV.linux.org.uk>
References: <4321E335.5010805@adaptec.com> <20050909201834.GA24521@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:39109 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1030448AbVIIUOk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 16:14:40 -0400
Content-Disposition: inline
In-Reply-To: <20050909201834.GA24521@mipter.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: sam@ravnborg.org, Luben Tuikov <luben_tuikov@adaptec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

On Sat, Sep 10, 2005 at 12:18:34AM +0400, Alexey Dobriyan wrote:
> On Fri, Sep 09, 2005 at 03:32:05PM -0400, Luben Tuikov wrote:
> > --- linux-2.6.13-orig/drivers/scsi/aic94xx/Makefile
> > +++ linux-2.6.13/drivers/scsi/aic94xx/Makefile
> 
> > +CHECK = sparse -Wbitwise
> 
> 	make C=1 CHECK="sparse -Wbitwise"
> or
> 	make C=1
Or patch below and use make C=1 CF=-Wbitwise...

Allows to add to sparse arguments without mutilating makefiles - just
pass CF=<arguments> and they will be added to CHECKFLAGS.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
----
diff -urN RC13-git7-kconfig/Makefile RC13-git7-CHECKFLAGS/Makefile
--- RC13-git7-kconfig/Makefile	2005-09-07 13:54:44.000000000 -0400
+++ RC13-git7-CHECKFLAGS/Makefile	2005-09-07 13:54:46.000000000 -0400
@@ -333,7 +333,7 @@
 PERL		= perl
 CHECK		= sparse
 
-CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__
+CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ $(CF)
 MODFLAGS	= -DMODULE
 CFLAGS_MODULE   = $(MODFLAGS)
 AFLAGS_MODULE   = $(MODFLAGS)
