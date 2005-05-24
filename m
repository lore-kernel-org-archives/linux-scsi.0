From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 10:51:35 +0200
Message-ID: <20050524085133.GZ9855@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524075953.GY9855@suse.de> <4292E3EE.10006@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4292E3EE.10006@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 24 2005, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Tue, May 24 2005, Jeff Garzik wrote:
> >
> >>The SCSI layer needs to issue the START STOP UNIT command in response to 
> >>a suspend event, and libata-scsi will (per SAT spec) translate that into 
> >>the ATA standby command.  Merely following the relevant SCSI+SAT+ATA 
> >>standards gets us there.
> >
> >
> >BTW, you also need to set host/device modes on resume. Where do you
> >propose to do that currently, without the LLD hook?
> 
> In the START STOP UNIT emulation.  SSU is basically a high level "do PM 
> command".

Ok, works for me.

> As a tangent, I would like to try and convince you to stop thinking so 
> much about hooks, and start thinking about adding new commands at the 
> struct request level.  Sending things down the request_queue is much 
> nicer because commands can be sent using the normal rq mechanisms. 
> Often, commands can be translated directly into ATA or SCSI commands in 
> the prep function.
> 
> Two commands I have been thinking about, to add alongside READ, WRITE, 
> READA, READ_SYNC, etc. are:  SYNC_CACHE and PM_EVENT.
> 
> This would be quite useful for DM and md RAID, especially.  It becomes 
> trivial to clone a SYNC_CACHE command, and send it to 5 underlying ATA 
> and SCSI devices in a RAID array.  If the PM_EVENT or SYNC_CACHE command 
> needs special processing, one can easily add code for that without 
> needing any hooks -- just call your new code from the request_queue 
> function that handles READ/WRITE/READA/...
> 
> This applies to the current thread (PM_EVENT), and also fits right into 
> your barrier work, too (SYNC_CACHE).

I agree, it's a cleaner approach, with the rq being a container for
generel messages as well not just SCSI commands. The one missing piece
for that was the rq->end_io() callback so everything doesn't have to go
down sync, but that is in now as well.

I'll try and cook something up.

-- 
Jens Axboe

