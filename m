From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym53c8xx_2 ppr problems
Date: Tue, 11 Jan 2005 18:21:36 +0000
Message-ID: <20050111182136.GV27371@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.58.0501111228530.30502@miranda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:4794 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261276AbVAKSVh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 13:21:37 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0501111228530.30502@miranda.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uns Lider <unslider@miranda.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 11, 2005 at 12:37:53PM -0500, Uns Lider wrote:
> FWIW... I just upgraded from 2.4.9 to 2.6.10. 2.6.10 kept printing phase
> change 6-7 messages. I patched to sym53c8xx_2 2.1.18n, but that didn't
> help. So I modified scsi_scan.c and sym_hipd.c sym_prepare_nego to never
> try PPR. That made the messages go away.
> 
> 00:0a.0 SCSI storage controller: Symbios Logic Inc. (formerly NCR) 53c1010 Ultra3 SCSI Adapter (rev 01)
> (on a tekram dc390u3w)
>   Vendor: SEAGATE   Model: SX150176LC        Rev: BA08
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> (=st150176lc, fast-40, lvd)
> 
> It sounds like PPR only does anything for fast-80 and above drives so I
> guess I'm OK now.

Let me get this straight.  This drive is on an LVD bus, capable of FAST-40,
reports being capable of PPR in its mode page and *still* fucks up when
asked to do PPR?

Googling for SX150176LC shows me several people with later revision
firmware (BA09, BA0F, BA11, BA12), so maybe you can get a firmware
upgrade out of Seagate.

I'm a little disappointed that 2.1.18n didn't fix it though.  Could you
revert your local changes, boot with "sym53c8xx.debug=0x200" and send
me the results?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
