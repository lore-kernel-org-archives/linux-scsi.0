From: Olaf Hering <olh@suse.de>
Subject: [PATCH] do not export /usr/include/scsi in make headers_install
Date: Mon, 6 Aug 2007 15:02:10 +0200
Message-ID: <20070806130210.GA2239@suse.de>
References: <20070806124546.GA2117@suse.de> <20070806125212.GB12896@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbXHFNCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Aug 2007 09:02:13 -0400
Content-Disposition: inline
In-Reply-To: <20070806125212.GB12896@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 06, Christoph Hellwig wrote:

> On Mon, Aug 06, 2007 at 02:45:46PM +0200, Olaf Hering wrote:
> > 
> > glibc and make headers_install_all provide /usr/include/scsi
> > One of them has to go.
> > 
> > A quick diff shows no differences, expect:
> 
> ..
> 
> > Which copy should be provided by a distributor?
> 
> The glibc one of course.  The kernel scsi.h should never have been
> added to the list of exportable headers.  

/usr/include/scsi is provided by glibc.
Remove the scsi export from make headers_install target.


Signed-off-by: Olaf Hering <olh@suse.de>

---
 include/Kbuild      |    1 -
 include/scsi/Kbuild |    4 ----
 2 files changed, 5 deletions(-)

--- a/include/Kbuild
+++ b/include/Kbuild
@@ -1,6 +1,5 @@
 header-y += asm-generic/
 header-y += linux/
-header-y += scsi/
 header-y += sound/
 header-y += mtd/
 header-y += rdma/
--- a/include/scsi/Kbuild
+++ /dev/null
@@ -1,4 +0,0 @@
-header-y += scsi.h
-
-unifdef-y += scsi_ioctl.h
-unifdef-y += sg.h
