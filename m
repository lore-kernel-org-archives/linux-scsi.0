From: John Utz <John.Utz@wdc.com>
Subject: RE: [PATCH 4/4] sd: Handle ZBC drives correctly
Date: Tue, 22 Jul 2014 18:25:04 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C4768C@wdscexmb02>
References: <1405931241-92015-1-git-send-email-hare@suse.de>
 <1405931241-92015-5-git-send-email-hare@suse.de>
 <20140721112904.GB15455@infradead.org> <53CCFEBE.8080400@suse.de>
 <8A51900D08212F40B3DE22453052F69839C47278@wdscexmb02>,<20140722161917.GA763@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140722161917.GA763@infradead.org>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomely <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

(hand citing in outlook web access, sorry! i also took the liberty of reformatting your response a teeny bit.)
> ________________________________________
> From: Christoph Hellwig [hch@infradead.org]
> Sent: Tuesday, July 22, 2014 9:19 AM
> To: John Utz
> Cc: Hannes Reinecke; linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org; James Bottomely
> Subject: Re: [PATCH 4/4] sd: Handle ZBC drives correctly
>
> Hi John,

Hi Christoph!

> I can't really comment much on the ATA side as I'm not overly uptodate
> on the ZAC spec.

It's OK, I have to chew on it because it's my day job, it's not reasonable to expect other folks to pay too much attention to it yet. :-)

I will say that it's helpful to consider it to be largely the same as the exiting ATA and SCSI DISK specs with a few extra new commands to make it adaptable to newer storage media designs.

>But a device with the 0x14 device type must have sequential required zones, 

Yes. 

> which will generate new sense codes when writes outside the write pointer happens.

Yes. and reads that will start or finish past the write pointer will also do something similar too.

> I'm very concerned about
>
>  a) how the SCSI midlayer handles those sense codes
>
> and
>
>  b) how we can communicate them to the user of the device, e.g. the filesystem or user application
>
> Just attaching the device by default without a good solution for these seems dangerous to me.

Your concerns are eminently practical and reasonable and you are not alone in possessing them.

But we gotta start somewhere. :-)

Actually, a couple of 'somewheres' and those 2 somewheres  map directly to your a and b concerns.

i am working on addressing 'b'.  i am using device-mapper to create a simulated ZAC target and this simulator will be used by hardworking file system vict.....um hardy pioneers.... to adapt their favorite file systems to do the right thing with respect to ZAC and ZBC.

This will not be a small job, and it will probably be easier for some file systems than others. 

Ultimately, i dont think that there will be much user space impact unless your userspace app is a database that manages its own disk access.

So let's talk about your concern 'a'. 

We are all blessed to be working at the cutting edge of linux.

IMHO, things like this are *supposed* to go into the tree here at the leading edge, because folks know not to be sticking bleeding edge kernels on to boxes that they run their lives and businesses on.

There have been many discussions/personal ruminations/guesses about how ZAC/ZBC is going to work and these things have progressed to the point where folks now have to check their hypotheticals into the tree so that we can all see what will happen.

So I would argue that this is actually a good thing because it's inspiring smart folks such as yourself to point out the snakepits that have jumped out at *you* when you saw Hannes's proposed checkin. :-)

Perhaps those of us who will be in Chicago in August who are interested in the topic should go find a hallway to hog up for a while and talk about this? :-)

just my us$0.02!

tnx!

johnu

Really,  alot of progress has been made since 
