From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 07/29] ncr5380: Cleanup TAG_NEXT and TAG_NONE macros
Date: Mon, 6 Oct 2014 23:26:15 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1410062235510.27616@nippy.intranet>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065629.926686164@telegraphics.com.au> <54325E9B.3050906@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <54325E9B.3050906@suse.de>
Sender: linux-m68k-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 6 Oct 2014, Hannes Reinecke wrote:

> On 10/02/2014 08:56 AM, Finn Thain wrote:
> > Both atari_NCR5380.c and sun3_NCR5380.c core drivers #undef TAG_NONE 
> > and then redefine it. But the original definition is unused because 
> > NCR5380.c lacks support for tagged queueing. So just define it once.
> > 
> > The TAG_NEXT macro only appears in the arguments to NCR5380_select() 
> > calls. But that routine doesn't use its tag argument as the tag was 
> > already assigned in NCR5380_main(). So remove the unused argument and 
> > the macro.
> > 
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > 
> Why not use 'SCSI_NO_TAG' from include/scsi/scsi_tcq.h ?

I didn't use SCSI_NO_TAG because it seemed to relate to the int tag member 
in struct request and not the unsigned char tag member in struct 
scsi_cmnd.

In light of the plan to remove the tag member from struct scsi_cmnd, I 
don't know what to do with this patch. It doesn't really help with that 
plan so I figured it would be NAK'd.

I haven't given any thought to the problem of converting drivers to block 
layer tags (which might involve SCSI_NO_TAG, I guess). I have too much 
other work in progress. That's why I suggested commenting out #define 
SUPPORT_TAGS until they could be converted.

-- 
