From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Ada pter
Date: Fri, 5 Nov 2004 20:36:51 +0000
Message-ID: <20041105203651.GA24690@parcelfarce.linux.theplanet.co.uk>
References: <C18BA5DDB58DD511BD0700C0DF0DD4501EEC6A@NTSERVER4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30620 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261209AbUKEUgw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 15:36:52 -0500
Content-Disposition: inline
In-Reply-To: <C18BA5DDB58DD511BD0700C0DF0DD4501EEC6A@NTSERVER4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SUPPORT <support@4bridgeworks.com>
Cc: 'Matthew Wilcox' <matthew@wil.cx>, Thomas Babut <thomas@babut.net>, linux-kernel@vger.kernel.org, Linux SCSI <linux-scsi@vger.kernel.org>, groudier@free.fr

On Fri, Nov 05, 2004 at 04:25:03PM -0000, SUPPORT wrote:
> I've been seeing problems with various tape drives and PPR. And a SCSI 3 SE
> disk is interesting as well! SE and PPR don't get on too well;)

... yes ...

I think we should *never* attempt PPR on a SE bus, even when the drive
supports it.  We've seen bugs in Seagate drive firmware because of this,
so let's stop doing it.

How does this patch (whitespace damaged, apply by hand) make people feel?

--- linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c       2004-11-02 12:59:53.0000
00000 -0700
+++ sym2-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c        2004-11-05 13:20:18.0000
00000 -0700
@@ -1455,7 +1455,7 @@
                st->options &= ~PPR_OPT_DT;
        }
 
-       if (!(np->features & FE_ULTRA3))
+       if (np->scsi_mode != SMODE_LVD || !(np->features & FE_ULTRA3))
                st->options &= ~PPR_OPT_DT;
 
        if (st->options & PPR_OPT_DT) {


> Matthew - I have attached some bits of SCSI analyser traces which I hope may
> be useful. An IBM SCSI 3 SE disk and a couple of LTO tape drives - IBM and
> HP. The HP causes severe problems as modprobe hangs without the fix. I have
> also seen drives that do unexpected disconnects if they get sent PPR.

Thanks, those are interesting.  It's good to see that we really are
spitting PPR out onto the wire when we shouldn't be.

> I have been toying with the idea of disabling PPR capability if PPR is
> rejected - forcing sdev->ppr=0 in the driver when it determines PPR has been
> rejected - but I'm not sure that's right. There are drives which reject
> negotiation - legacy sync and wide at least - while they are initialising
> but will then accept it later on.

I think disabling PPR on an SE bus should be a better fix than that.

> Question - where does the full source for the sym53c8xx_2 driver live these
> days now that Gerard no long maintains it?

My primary development for this driver lives in the parisc-linux CVS.
I publish patches on an irregular basis.  If this patch fixes a
significant number of problems (and it seems it might), I'll do a
2.1.18n release.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
