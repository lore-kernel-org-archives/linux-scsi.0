From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: section mismatches (scsi e.g.)
Date: Fri, 14 Apr 2006 23:21:26 +0200
Message-ID: <20060414212126.GA12482@mars.ravnborg.org>
References: <20060414092911.71f25ac1.rdunlap@xenotime.net> <20060414165210.GA4053@mars.ravnborg.org> <20060414122520.d1d1a46e.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtp.tele.dk ([193.162.159.95]:12036 "EHLO pasmtp.tele.dk")
	by vger.kernel.org with ESMTP id S965174AbWDNVVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 17:21:34 -0400
Content-Disposition: inline
In-Reply-To: <20060414122520.d1d1a46e.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 14, 2006 at 12:25:20PM -0700, Randy.Dunlap wrote:
> On Fri, 14 Apr 2006 18:52:10 +0200 Sam Ravnborg wrote:
> 
> > On Fri, Apr 14, 2006 at 09:29:11AM -0700, Randy.Dunlap wrote:
> > > Hi Sam,
> > > 
> > > I was looking at these warnings (on 2.6.17-rc1-git8):
> > > 
> [snip]
> 
> > Darren Jenkins already pointed this pattern out but somehow I lost
> > the patch (not applied).
> > It is here:
> 
> OK, I applied the patch.  Now please consider these (that I doubt):
> 
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x0)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x8)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x10)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x18)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x20)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x28)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x30)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x38)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x40)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x48)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x50)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x58)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x60)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x68)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x70)
> WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x78)
> 
> Any ideas?
For .init.text the following was explained:
* Identify sections from which references to a .init section is OK.
*
* Unfortunately references to read only data that referenced .init
* sections had to be excluded. Almost all of these are false
* positives, they are created by gcc. The downside of excluding
* rodata
* is that there really are some user references from rodata to
* init code, e.g. drivers/video/vgacon.c:

So ignoring .rodata in exit_section_ref_ok() seems to be the solution
here.
So we end up with following patch.

	Sam

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 7e8079a..93a043e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -492,7 +492,7 @@ static int strrcmp(const char *s, const 
  *   These functions may often be marked __init and we do not want to
  *   warn here.
  *   the pattern is identified by:
- *   tosec   = .init.text | .exit.text
+ *   tosec   = .init.text | .exit.text | .init.data
  *   fromsec = .data
  *   atsym = *_driver, *_ops, *_probe, *probe_one
  **/
@@ -522,7 +522,8 @@ static int secref_whitelist(const char *
 
 	/* Check for pattern 2 */
 	if ((strcmp(tosec, ".init.text") != 0) &&
-	    (strcmp(tosec, ".exit.text") != 0))
+	    (strcmp(tosec, ".exit.text") != 0) &&
+	    (strcmp(tosec, ".init.data") != 0))
 		f2 = 0;
 	if (strcmp(fromsec, ".data") != 0)
 		f2 = 0;
@@ -820,6 +821,7 @@ static int exit_section(const char *name
  * For our future {in}sanity, add a comment that this is the ppc .opd
  * section, not the ia64 .opd section.
  * ia64 .opd should not point to discarded sections.
+ * [.rodata] like for .init.text we ignore .rodata references -same reason
  **/
 static int exit_section_ref_ok(const char *name)
 {
@@ -829,6 +831,7 @@ static int exit_section_ref_ok(const cha
 		".exit.text",
 		".exit.data",
 		".init.text",
+		".rodata",
 		".opd", /* See comment [OPD] */
 		".toc1",  /* used by ppc64 */
 		".altinstructions",
