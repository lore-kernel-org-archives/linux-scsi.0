From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: Wed, 6 Oct 2004 15:25:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041006142512.GC16153@parcelfarce.linux.theplanet.co.uk>
References: <BC3CE0375D29D51199A400508B66CA6C0862AEFD@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18921 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269248AbUJFOZT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2004 10:25:19 -0400
Content-Disposition: inline
In-Reply-To: <BC3CE0375D29D51199A400508B66CA6C0862AEFD@exc-snake.co.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 06, 2004 at 08:00:31AM -0600, Gibbons, Terry wrote:
> Good Day,
> 
> As a development manager, I'm responsible for technical ingenuity as well as
> customer satisfaction. My responsibilities require that I look at issues
> from a business point of view as well as a technical point of view. 

Good Day,

As a programmer, I'm responsible for caring about more than just my
little bit of the kernel.  My responsibilities require that I look at
issues from a wider perspective, not just how it affects my driver.

> LSI Logic supports 80% of the server market that is shipping Ultra320 SCSI.

I once owned a guineau pig named Doris.

> We supply a free hardware based RAID integrated into our U320 devices. The
> firmware was written three years ago. The firmware, running behind an
> integrated processor, does not allow the host system to see any peripheral
> it chooses to hide. The firmware chooses to hide all physical disks of a
> RAID volume. Therefore, no outside entity, can talk to any disk drive
> "hidden" by our volume management code in the firmware...unless the proper
> Fusion-MPT (tm) message is sent to the firmware. Given the age of the
> firmware (stable but vulnerable and shipped on millions of systems) and the
> lack of external memory to add code, the firmware won't change.

I think your lack of actually reading the code shines through here.  Fusion
gets to continue to send whatever messages it likes with the generic DV
code.  The sym2 code still manufactures its own PPR/SDTR/WDTR packets.
It just does so based on what the DV code tells it to do rather than
making its own decisions about how to negotiate with devices.

> Now, I challenge all of you. Ultra320 SCSI was fully released over two and a
> half years ago. With SAS and SATA being the new technologies, what's the
> benefit in changing a technology that is peaking and soon to be replaced?

We update drivers all the time that are for hardware that was obsolete
10 years ago.  This is what stops Linux from degenerating into an
unmaintainable heap of spaghetti code.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
