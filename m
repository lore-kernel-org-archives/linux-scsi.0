From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] IBM Power RAID driver (ipr) 2.0.6
Date: Mon, 10 May 2004 22:39:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040510213901.GH16118@parcelfarce.linux.theplanet.co.uk>
References: <4097D863.8040505@us.ibm.com> <1084221540.2659.353.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14794 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261904AbUEJVjE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 17:39:04 -0400
Content-Disposition: inline
In-Reply-To: <1084221540.2659.353.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Brian King <brking@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, May 10, 2004 at 03:38:57PM -0500, James Bottomley wrote:
> On Tue, 2004-05-04 at 12:52, Brian King wrote:
> > Here is the latest version of the LLD for the IBM Power RAID family of
> > adapters. This includes several IBM iSeries and pSeries SCSI adapters.
> > Please apply.
> 
> The problem is your use of list_head pointers in packed structures.  You
> can't simply pass a pointer to a misaligned structure to a common kernel
> function and expect it to work: the packed attribute is lost doing this
> and what you end up with is a misaligned pointer reference.

It also causes gcc to pessimise references to this structure; often
doing byte-loads instead of larger quantities.  Why does this struct
need to be packed?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
