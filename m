From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym53c8xx module parameter passing not working (2.5.6)
Date: Fri, 8 Oct 2004 02:30:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041008013029.GM16153@parcelfarce.linux.theplanet.co.uk>
References: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de> <20041001162939.A4215@infradead.org> <20041001165555.GF16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3025 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269847AbUJHBab
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 21:30:31 -0400
Content-Disposition: inline
In-Reply-To: <20041001165555.GF16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, "Heinzmann, Robert" <Heinzmann@cc-dresden.de>, linux-scsi@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>

On Fri, Oct 01, 2004 at 05:55:55PM +0100, Matthew Wilcox wrote:
> On Fri, Oct 01, 2004 at 04:29:39PM +0100, Christoph Hellwig wrote:
> > Given that no one except you noticed the lack of options so far what
> > about moving it to normal parameters instead, aka one option per setting
> > like all non-scsi and resent scsi drivers do?
> 
> I think it's definitely time to make this change.  I'll look at it later
> today.

I have it working ... but there's no way to do a graceful transition.
I had in mind something like:

+       printk(NAME53C8XX "Using old-style setup code.  Please switch to new "
+                       "module param code.\n"
+                       "See Documentation/scsi/sym53c8xx_2.txt for "
+                       "details.\n");
+

to allow people to switch over.  But when I try this, I get:

sym53c8xx: Unknown parameter `hostid'
sym53c8xx: Ignoring new-style parameters in presence of obsolete ones

It'd be nice to be able to use either for a while.  Rusty, is there any
chance of allowing this?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
