From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 20:17:06 +1000
Message-ID: <4292FF22.5040201@torque.net>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de> <4292D37C.5020700@pobox.com> <4292D44C.2040102@suse.de> <4292D55B.3050801@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4292D55B.3050801@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Hannes Reinecke wrote:
> 
>> We've finally succeeded in convincing everyone that having '/dev/sdX'
>> instead of '/dev/hdX' was a neccessary step forward.
>> I think we're getting shot if we now tell them to reverse this _again_.
>> Can we at least have it optional?
> 
> 
> I will not break compatibility with /dev/sdX, don't worry :)
> 
> It will always be there as an optional piece, as I described in my other 
> reply to you.

Jeff,
At the risk of boring you but informing others, Serial
Attached SCSI (SAS) is going to muddy things.

The SCSI ATA Translation (SAT
http://www.t10.org/ftp/t10/drafts/sat/sat-r04.pdf )
draft hopefully will find application any many areas
other than libata (e.g. USB mass storage and 1394's
SBP-2 drivers). The Scope section (section 1) of that
draft makes interesting reading: in point a) the author
sees SAT as presenting a unified command interface for
block type devices across PATA, SATA and ATAPI!

However the primary reason that SAT started is the
fact that SAS infrastructure can include SATA disks.
SAS defines the Serial ATA Tunneled Protocol (STP)
which in linux will first appear in a SAS LLD (i.e.
a scsi subsystem Low Level Driver, something like
aic7xxx). Connecting a SATA disk (transported via SAS)
to the IDE subsystem and a /dev/hd? device node seems
like an unnatural act (a bit like ide-scsi in reverse).
A solution involving libata seems appropriate in this case.

Even more likely is that a SAT layer will be implemented
in SAS enclosures just inches away from lots of SATA
disks. From the point of view of a linux machine
such SATA disks talk the SCSI command set and are
connected via a SAS transport (Serial SCSI Protocol (SSP)).
The only things that will probably care about the
difference between such SATA disks and SAS disks are
utilities like smartmontools (and that gap is being
partially closed as well).

Even without SAS we already have many fibre channel
enclosures that bridge to SATA disks. Hopefully a
SAT layer will be retro-fitted into some of those.

Perhaps libata could be renamed libsat.

Doug Gilbert

