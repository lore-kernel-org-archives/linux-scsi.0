From: "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: Wed, 6 Oct 2004 08:00:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BC3CE0375D29D51199A400508B66CA6C0862AEFD@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55507 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S269213AbUJFOC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 10:02:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Emoore@lsil.com>
Cc: "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Good Day,

As a development manager, I'm responsible for technical ingenuity as well as
customer satisfaction. My responsibilities require that I look at issues
from a business point of view as well as a technical point of view. 

LSI Logic supports 80% of the server market that is shipping Ultra320 SCSI.
We supply a free hardware based RAID integrated into our U320 devices. The
firmware was written three years ago. The firmware, running behind an
integrated processor, does not allow the host system to see any peripheral
it chooses to hide. The firmware chooses to hide all physical disks of a
RAID volume. Therefore, no outside entity, can talk to any disk drive
"hidden" by our volume management code in the firmware...unless the proper
Fusion-MPT (tm) message is sent to the firmware. Given the age of the
firmware (stable but vulnerable and shipped on millions of systems) and the
lack of external memory to add code, the firmware won't change.

Therefore, the technical facts are that if Domain Validation is removed this
will cause our customers field upgrade problems, new system integration test
problems, manufacturing test problems, and perhaps no capability at all to
get drives in an array faster than ASYNC. I know the latter will happen on a
drive swap.

A change in DV code will result in lost time to LSI, Red Hat, SuSE, and all
of LSI's customers as there will be absolutely no choice but to force LSI
driver patches for DV through Red Hat and SuSE (at a minimum).

Now, I challenge all of you. Ultra320 SCSI was fully released over two and a
half years ago. With SAS and SATA being the new technologies, what's the
benefit in changing a technology that is peaking and soon to be replaced?

Regards,

Terry Gibbons
LSI Logic Corp
Software Development Manager

 -----Original Message-----
From: 	James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent:	Tuesday, October 05, 2004 5:11 PM
To:	Eric Dean Moore
Cc:	Stephens, Larry; Shirron, Stephen; Gibbons, Terry; Christoph
Hellwig; Matthew Wilcox; Christoph Hellwig; SCSI Mailing List
Subject:	RE: [PATCH] fusion: streamline ->queuecommand

On Tue, 2004-10-05 at 17:38, Moore, Eric Dean wrote:
> Can we assume that all linux distributions provide at least 57 bytes of
> inquiry data
> during the scsi bus scan?   I don't know if Suse has solved this, but they
> were
> in 2.4 kernel only sending 36 bytes of inquiry data.

2.6 always does a two phase inquiry, the minimum first and then the full
inquiry string.  We pick the negotiation flags you're looking for out of
the inquiry data and save them away in the scsi_device structure, so you
don't even have to parse the saved inquiry data.

> > > (6) DV algorithm works, and well tested, and accepted by 
> > our OEMS. Nothing
> > > is broke. Why break it?    
> > 
> > Because sharing code and thus increasing its usage is good.
> 
> That is not a risk that LSI Logic is willing to take;   
> currently there is not a 2.7 kernel testbed for this. 
> Having someone outside LSI blindly posting a patch removing our
> DV and not having throughly tested could have grave results. 
> The DV currently in place has been thru many test cycles in our own
> test labs, and these drivers are well accepted by our customer base.
> Other LSI employees copied on this email can comment futher on that.

I'm not forcing people to use it ... yet.

However, the attitude that "my driver works and I've tested it, so I'm
not going to change it" is in a large measure what got the SCSI subsytem
into its pariah status in 2.4: too many in-driver work arounds and no
thought to fixing the problems in the generic code.

If the benefits of sharing common code in an open source model aren't
apparent then consider this: the last three critical Adaptec bugs were
all in the domain validation code; and they thought their driver was
"thoroughly tested" too.

James

