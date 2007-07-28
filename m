From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + scsi-blacklist-the-easyraid-f8-ide2scsi-adaptor.patch added
 to -mm tree
Date: Sat, 28 Jul 2007 10:04:49 -0700
Message-ID: <20070728100449.ab567007.akpm@linux-foundation.org>
References: <200707272030.l6RKU2Vw008612@imap1.linux-foundation.org>
	<1185630975.11492.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbXG1RFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jul 2007 13:05:32 -0400
In-Reply-To: <1185630975.11492.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: andmike@us.ibm.com, mog.johnny@gmx.net, protasnb@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 28 Jul 2007 09:56:15 -0400 James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Fri, 2007-07-27 at 13:30 -0700, akpm@linux-foundation.org wrote:
> > The patch titled
> >      scsi: blacklist the easyRAID F8 IDE2SCSI adaptor
> > has been added to the -mm tree.  Its filename is
> >      scsi-blacklist-the-easyraid-f8-ide2scsi-adaptor.patch
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > ------------------------------------------------------
> > Subject: scsi: blacklist the easyRAID F8 IDE2SCSI adaptor
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > According to http://bugzilla.kernel.org/show_bug.cgi?id=5953, this patch fixes
> > easyRAID domain validation.
> 
> I don't think this can be true ... the patch definitely fixes the
> condition on the easyraid where it goes haywire and responds with
> complete rubbish to the REPORT LUNS command (which is all too common for
> these IDE raid things), but DV will occur long before the REPORT LUNS is
> tried.
> 
> I'll take it through the SCSI tree because it's clearly a bug, but it's
> probably only half the fix.
> 

I may have mangled the changelog.


From: Andrew Morton <akpm@linux-foundation.org>

According to http://bugzilla.kernel.org/show_bug.cgi?id=5953, this patch fixes
easyRAID domain validation.

Cc: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Hans-Christian Armingeon <mog.johnny@gmx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_devinfo.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/scsi/scsi_devinfo.c~scsi-blacklist-the-easyraid-f8-ide2scsi-adaptor drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c~scsi-blacklist-the-easyraid-f8-ide2scsi-adaptor
+++ a/drivers/scsi/scsi_devinfo.c
@@ -154,6 +154,9 @@ static struct {
 	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
+	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
+	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
+	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
_

