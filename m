From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14877] MSI/MSI-X support in 2.6.31.xx and 2.6.32.xx seems
 broken
Date: Sat, 23 Jan 2010 14:25:29 GMT
Message-ID: <201001231425.o0NEPTCp031659@demeter.kernel.org>
References: <bug-14877-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52478 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0AWOZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jan 2010 09:25:30 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0NEPTdq031660
	for <linux-scsi@vger.kernel.org>; Sat, 23 Jan 2010 14:25:29 GMT
In-Reply-To: <bug-14877-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14877





--- Comment #7 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-01-23 14:25:26 ---
Reply-To: James.Bottomley@suse.de

On Fri, 2010-01-22 at 15:18 -0800, Andrew Morton wrote:
> On Fri, 15 Jan 2010 09:23:50 +0200
> Oleg Gawriloff <barzog@telecom.by> wrote:
> 
> > 15.01.2010 1:01, Andrew Morton __________:
> > 
> > > Oleg, please send that lpfc patch via emailed reply-to-all to this email.
> > > Include a brief description for the changelog and a Signed-off-by: as
> > > per Documentation/SubmittingPatches, thanks.
> > Signed-off-by version available at
> > http://marc.info/?l=linux-scsi&m=126342842601776&w=2
> > 
> > From: George Kadianakis <desnacked {bomb} gmail {point} com>
> > 
> > A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx 
> > interrupts.
> > This patch restores lpfc's ability to support MSI-X/MSI interrupts that the
> > "Addition of SLI4 Interface - Base Support" patch [2] broke.
> > It reestablishes MSI-X as the default interrupt method and in case MSI-X 
> > is not
> > supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.
> > 
> > [1]: http://bugs.gentoo.org/show_bug.cgi?id=296319
> > [2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d
> > 
> > Signed-off-by:  George Kadianakis <desnacked {cat} gmail {dog} com>
> > ---
> >   drivers/scsi/lpfc/lpfc_attr.c |    6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> > index e1a30a1..936ecaf 100644
> > --- a/drivers/scsi/lpfc/lpfc_attr.c
> > +++ b/drivers/scsi/lpfc/lpfc_attr.c
> > @@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
> >   /*
> >   # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
> >   # 				 support this feature
> > -#       0  = MSI disabled (default)
> > +#       0  = MSI disabled
> >   #       1  = MSI enabled
> > -#       2  = MSI-X enabled
> > +#       2  = MSI-X enabled (default)
> >   # Value range is [0,2]. Default value is 0.
> >   */
> > -LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
> > +LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
> >   					      "MSI-X (2), if possible");
> > 
> 
> This is committed to the scsi tree without a cc:stable, so it won't get
> backported into 2.6.32.x and might not make it into 2.6.33 either.
> 
> Was that all intentional?

Yes.

The commit contains an essay from James Smart as a sidebar explaining
the logic, but the gist is that there were instabilities in the previous
kernel that caused MSI failures with the lpfc cards so disabling MSI was
deliberate.

James

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.