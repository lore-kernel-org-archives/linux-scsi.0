From: "James Stevenson" <mistral@stev.org>
Subject: Re: ide-scsi opps
Date: Thu, 11 Jul 2002 20:19:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000501c2290f$d5ea1010$0501a8c0@Stev.org>
References: <E17Sg2H-00011H-00@the-village.bc.nu>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Scsi <linux-scsi@vger.kernel.org>

Hi

this is what appeared in the logs just before the opps.

Jul 11 14:21:22 beast kernel:  I/O error: dev 0b:01, sector 729600
Jul 11 14:22:04 beast kernel: scsi : aborting command due to timeout : pid
27195, scsi0, channel 0, id 1, lun 0 0x28 00 00 02 c8 c0 00 00 3f 00
Jul 11 14:22:04 beast kernel: scsi : aborting command due to timeout : pid
27196, scsi0, channel 0, id 1, lun 0 0x28 00 00 02 c8 ff 00 00 01 00
Jul 11 14:22:04 beast kernel: hdd: timeout waiting for DMA
Jul 11 14:22:19 beast kernel: ide_dmaproc: chipset supported ide_dma_timeout
func only: 14
Jul 11 14:22:20 beast kernel: hdd: status timeout: status=0xd0 { Busy }
Jul 11 14:22:21 beast kernel: hdd: drive not ready for command
Jul 11 14:22:22 beast kernel: scsi : aborting command due to timeout : pid
27197, scsi0, channel 0, id 1, lun 0 0x28 00 00 02 c8 84 00 00 02 00

i just dont know anything about ide / scsi yet from a kernel point of view
i seem to be learning pritty quickly though at the minute
kind of taking a guess at what is happening but i dont understand the code
enough yet.

what happens in a normall request is. (is this how a request works ??)

send request to drive
go do something else
get an irq back and handle the response

but what happens in the opps is something like.

send request to drive
go do something
get and irq back with an error set somewhere
try todo the request again.
request gets freed (this part should not happen)
the irq handle gets a response and then rq is NULL so it
all goes BOOM !

would that sort of problem cause this ?

> > if (status & ERR_STAT)
> >     rq->errors++;            OPPS!!
> >     idescsi_end_request (1, HWGROUP(drive));
> >     return ide_stopped;
> > }
> >
>
> Before the rq->errors++ add
>
> if(rq == NULL)
> printk(KERN_ERR "Arghh rq==NULL\n");
> else

except the next function to be called from here is
idescsi_end_request

and the first line looks like
if(rq->cmd

would it be safe to put and extra check in here and just
check the values and disable what idescsi_end_request does ?

> that will log errors instead of crashing. The next task then is to figure
out
> how rq got to be NULL if that proves it to be the problem.
>


