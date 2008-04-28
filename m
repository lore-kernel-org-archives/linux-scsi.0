From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Mon, 28 Apr 2008 23:00:34 +0200
Message-ID: <20080428210034.GE18248@uranus.ravnborg.org>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org> <20080419204511.GP20637@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:49571 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934255AbYD1VAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 17:00:01 -0400
Content-Disposition: inline
In-Reply-To: <20080419204511.GP20637@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sat, Apr 19, 2008 at 02:45:11PM -0600, Matthew Wilcox wrote:
> On Sat, Apr 19, 2008 at 01:14:23PM -0700, Linus Torvalds wrote:
> > So people: stop this total *idiocy* with "select is bad". It's not. The 
> > lack of select is *much* worse.
> 
> Could we consider applying this patch then?

I applied the following.

	Sam

commit dfecbec8b54038ef02835d2f8181e1f44bd080d2
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Sat Apr 19 14:45:11 2008 -0600

    kconifg: 'select' considered less evil
    
    While select should be used with care, it is not actually evil.
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 649cb87..00b950d 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -104,14 +104,15 @@ applicable everywhere (see syntax).
   Reverse dependencies can only be used with boolean or tristate
   symbols.
   Note:
-	select is evil.... select will by brute force set a symbol
-	equal to 'y' without visiting the dependencies. So abusing
-	select you are able to select a symbol FOO even if FOO depends
-	on BAR that is not set. In general use select only for
-	non-visible symbols (no prompts anywhere) and for symbols with
-	no dependencies. That will limit the usefulness but on the
-	other hand avoid the illegal configurations all over. kconfig
-	should one day warn about such things.
+	select should be used with care. select will force
+	a symbol to a value without visiting the dependencies.
+	By abusing select you are able to select a symbol FOO even
+	if FOO depends on BAR that is not set.
+	In general use select only for non-visible symbols
+	(no prompts anywhere) and for symbols with no dependencies.
+	That will limit the usefulness but on the other hand avoid
+	the illegal configurations all over.
+	kconfig should one day warn about such things.
 
 - numerical ranges: "range" <symbol> <symbol> ["if" <expr>]
   This allows to limit the range of possible input values for int
