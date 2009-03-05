From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Thu, 5 Mar 2009 14:55:57 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77885CA68EC7EC@GVW0547EXC.americas.hpqcorp.net>
References: <20090302145650.GW15340@beardog.cca.cpqcorp.net>
	<20090303153402A.fujita.tomonori@lab.ntt.co.jp>
	<20090303162821.GB15340@beardog.cca.cpqcorp.net>
 <20090305144843N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755156AbZCEO5K@vger.kernel.org>
In-Reply-To: <20090305144843N.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "coldwell@redhat.com" <coldwell@redhat.com>, "hare@novell.com" <hare@novell.com>, ISS StorageDev <iss_storagedev@hp.com>
List-Id: linux-scsi@vger.kernel.org

> 
> We have /sys/class/scsi_host/host*/sg_tablesize:
> 
> How about modifying this value on the fly?
> 
> fujita@clover:/sys/class/scsi_host/host3$ echo 1000 > sg_tablesize
> 
> 
> Well, this needs more changes (to both the block layer and 
> the scsi mid layer) but is it nice to change this value dynamically?
> 
> Anyway, I think that it's better to address this fancy 
> feature later on (after the mainline inclusion). Let's put 
> hpsa driver into mainline first.
> 
> 
> > > > Hmm, this doesn't seem all that complicated to me, and 
> this code 
> > > > snippet has been pretty stable for about 10 years. it's nearly 
> > > > identical to what's in cpqarray in the 2.2.13 kernel from 1999:
> > > > 
> > > >                 do {
> > > >                         i = 
> find_first_zero_bit(h->cmd_pool_bits, NR_CMDS);
> > > >                         if (i == NR_CMDS)
> > > >                                 return NULL;
> > > >                 } while(test_and_set_bit(i%32, 
> > > > h->cmd_pool_bits+(i/32)) != 0)
> > > > 
> > > > It's fast, works well, and has needed very little 
> maintenance over 
> > > > the years.  Without knowing what you have in mind 
> specifically, I 
> > > > don't see a big need to change this.
> > > 
> > > I see. Seems that some drivers want something similar. I 
> might come 
> > > back later on with a patch to replace this with library functions.
> > 
> > There was some other discussion about pushing this sort of thing to 
> > upper layers, using a tag generated in the scsi layer as a means of 
> > allocating driver command buffers, since, presumably 
> there's a one to 
> > one mapping.  (I didn't completely grok it all though.)
> 
> Oops, I meant that I might come back with a patch to convert 
> hpsa to use the the block layer tagging, which you and Mike 
> Christie are talking about (yeah, my first suggestion to use 
> lists was wrong. using the block layer tagging looks much better).
> 
> 
> By the way, have you guys started to work on the review 
> comments for the next submission? The driver has some minor 
> style issues that have not been mentioned yet. For example, 
> the comment style in the driver is not preferred:
> 
> /* If this device a non-zero lun of a multi-lun device */
> /* byte 4 of the 8-byte LUN addr will contain the logical */
> /* unit no, zero otherise. */
> 
> The preferred style is:
> 
> /*
>  * If this device a non-zero lun of a multi-lun device
>  * byte 4 of the 8-byte LUN addr will contain the logical
>  * unit no, zero otherise.
>  */
> 
> Another example, I think that the SCSI-ml preferred style is 
> (not documented in CodingStyle though):
> 
> 'if (!ptr)' rather than 'if (ptr == NULL)'
> 'if (!value)' rather than 'if (value == 0)'
> 'if (ptr)' rather than 'if (ptr != NULL)'
> 'if (value)' rather than 'if (value != 0)'
> 
> 
> If you are already addressing the review comments, I just 
> wait for the next submission, then I'll send such minor 
> patches. If you are not, I'll send patches to address the 
> review comments (including such minor patches).
> 

We're working on the review comments. Right we're trying to get caught up with our "day jobs."

-- mikem