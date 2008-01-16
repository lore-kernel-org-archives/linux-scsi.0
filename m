From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: INITIO scsi driver fails to work properly
Date: Wed, 16 Jan 2008 14:59:16 +0900
Message-ID: <20080116145916A.fujita.tomonori@lab.ntt.co.jp>
References: <1200070903.3286.28.camel@localhost.localdomain>
	<9f00bd9d0801130428s5e4c034apf21052b918470f99@mail.gmail.com>
	<1200410166.9273.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:57659 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYAPGAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jan 2008 01:00:16 -0500
In-Reply-To: <1200410166.9273.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: psybases@gmail.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, cebbert@redhat.com, bharrosh@panasas.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 09:16:06 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Sun, 2008-01-13 at 14:28 +0200, Filippos Papadopoulos wrote:
> > On 1/11/08, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> > >
> > > On Fri, 2008-01-11 at 18:44 +0200, Filippos Papadopoulos wrote:
> > > > On Jan 11, 2008 5:44 PM, James Bottomley
> > > > <James.Bottomley@hansenpartnership.com> wrote:
> > > > > >
> > > > > > I havent reported "initio: I/O port range 0x0 is busy."
> > > > >
> > > > > Sorry ... we appear to have several reporters of different bugs in this
> > > > > thread.  That message was copied by Chuck Ebbert from a Red Hat
> > > > > bugzilla ... I was assuming it was the same problem.
> > > > >
> > > > > > I applied the patch on 2.6.24-rc6-git9 but unfortunatelly same thing happens.
> > > > >
> > > > > First off, has this driver ever worked for you in 2.6?  Just booting
> > > > > SLES9 (2.6.5) or RHEL4 (2.6.9) ... or one of their open equivalents to
> > > > > check a really old kernel would be helpful.  If you can get it to work,
> > > > > then we can proceed with a patch reversion regime based on the
> > > > > assumption that the problem is a recent commit.
> > > >
> > > > Yes it works under 2.6.16.13.  See the beginning of this thread, i
> > > > mention there some things about newer versions.
> > >
> > > Thanks, actually, I see this:
> > >
> > > > I tried to install OpenSUSE 10.3 (kernel 2.6.22.5) and the latest
> > > > OpenSUSE 11.0 Alpha 0  (kernel 2.6.24-rc4) but although the initio
> > > > drivergets loaded during the installation process, yast reports that no hard
> > > > disk is found.
> > >
> > > Could you try with a vanilla 2.6.22 kernel?  The reason for all of this
> > > is that 2.6.22 predates Alan's conversion of this driver (which was my
> > > 95% candidate for the source of the bug).  I want you to try the vanilla
> > > kernel just in case the opensuse one contains a backport.
> > 
> > 
> > Yes you are right. I compiled the vanilla 2.6.22 and initio driver works.
> > Tell me if you want to apply any patch to it.
> 
> 
> That's good news ... at least we know where the issue lies; now the
> problem comes: there are two candidate patches for this issue: Alan's
> driver update patch and Tomo's accessors patch.  Unfortunately, due to
> merge conflicts the two are pretty hopelessly intertwined.  I think I
> already spotted one bug in the accessor conversion, so I'll look at that
> again.  Alan's also going to acquire an inito board and retest his
> conversions.
> 
> I'm afraid it might be a while before we have anything for you to test.

Can you try this patch?

Thanks,

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 01bf018..6891d2b 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2609,6 +2609,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 		cblk->bufptr = cpu_to_le32((u32)dma_addr);
 		cmnd->SCp.dma_handle = dma_addr;
 
+		cblk->sglen = nseg;
 
 		cblk->flags |= SCF_SG;	/* Turn on SG list flag       */
 		total_len = 0;
