From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 22:11:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:37099 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267985AbUIUVLJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 17:11:09 -0400
Content-Disposition: inline
In-Reply-To: <20040921210341.GC146363@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 02:03:42PM -0700, Jeremy Higdon wrote:
> On Altix, we do have the sn_mmiob() option.  I don't think that
> we want to Linux API to require that
> 
> CPUA:	writel(value_X, common_register)
> 	spin_unlock(common_lock)
> 
> CPUB:	spin_lock(common_lock)
> 	writel(value_Y, common_register)
> 
> be strongly ordered, because it places a performance penalty
> on all writes.

I disagree with you.  If this were memory, then you would expect
common_register to be set to value_Y after this sequence.  Why should
IO be different?

> On Altix, we have the "sn_mmiob()" function to do
> that.  I.e.
> 
> CPUA:	writel(value_X, common_register)
> 	sn_mmiob()
> 	spin_unlock(common_lock)
> 
> CPUB:	spin_lock(common_lock)
> 	writel(value_Y, common_register)
> 
> would strongly order the writes.

I think your _raw_spin_unlock() should include an sn_mmiob().

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
