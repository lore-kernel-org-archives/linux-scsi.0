From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 13:10:05 -0400
Message-ID: <42935FED.5010602@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de> <4292D37C.5020700@pobox.com> <4292D44C.2040102@suse.de> <4292D55B.3050801@pobox.com> <4292FF22.5040201@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4292FF22.5040201@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net, Jens Axboe <axboe@suse.de>, luben_tuikov@adaptec.com
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> At the risk of boring you but informing others, Serial
> Attached SCSI (SAS) is going to muddy things.

Not necessarily...  ;-)

But yes, I am keeping track of SAS, don't worry.


> The SCSI ATA Translation (SAT
> http://www.t10.org/ftp/t10/drafts/sat/sat-r04.pdf )
> draft hopefully will find application any many areas
> other than libata (e.g. USB mass storage and 1394's
> SBP-2 drivers). The Scope section (section 1) of that
> draft makes interesting reading: in point a) the author
> sees SAT as presenting a unified command interface for
> block type devices across PATA, SATA and ATAPI!

In Linux's case, libata's SCSI<->ATA translation is merely a convenience 
so that I didn't have to bother writing all that storage infrastructure 
at the block layer.  And SAT was merely a convenient standard I could 
follow during the exercise.


> However the primary reason that SAT started is the
> fact that SAS infrastructure can include SATA disks.
> SAS defines the Serial ATA Tunneled Protocol (STP)
> which in linux will first appear in a SAS LLD (i.e.
> a scsi subsystem Low Level Driver, something like
> aic7xxx). Connecting a SATA disk (transported via SAS)
> to the IDE subsystem and a /dev/hd? device node seems
> like an unnatural act (a bit like ide-scsi in reverse).
> A solution involving libata seems appropriate in this case.

Certainly there will be hardware that attaches to both SATA and SAS. 
I've been planning for this.  I even have an Adaptec card (and docs).

It depends highly on the LLD how this is implemented.  If a SCSI 
interface to SATA is forced upon us (i.e. SAT is implemented in a 
firmware somewhere), then there's not much you can do.

If the LLD provides direct access to either SCSI CDBs or ATA taskfiles 
(FIS's), then the OS should directly work with the device's native 
command set.  Far from adding value, translation actually hinders 
progress, as users must either (a) find a way around the SAT layer to 
access an ATA feature, or (b) wait until the SAT layer is updated to 
support a translation for the desired feature.

One of the biggest requested features for libata is "ATA passthru", the 
ability to directly submit ATA commands to the device.  That should tell 
you something about what -users- want.

SCSI and ATA are competing and evolving command sets, which implies that 
there is -increased- interest in -not- hiding ATA devices behind an 
emulation layer.

A SATA+SAS LLD would ideally register an instance of the SAS transport 
class with the SCSI layer, and an instance of the SATA transport class 
with the block layer.  That's all it needs to do.

Everything else -- /dev/hdX versus /dev/sdX, emulation, sd/sr/st, etc. 
-- are all clients to either a SATA or SCSI transport class.  Remember, 
to many users, the fact that SATA right now uses /dev/sdX is confusing 
and annoying: they would prefer /dev/hdX as IDE has been presenting for 
over a decadce.

With the right design, there is little value OR NEED in hiding ATA 
devices behind emulation.


> Even more likely is that a SAT layer will be implemented
> in SAS enclosures just inches away from lots of SATA
> disks. From the point of view of a linux machine
> such SATA disks talk the SCSI command set and are
> connected via a SAS transport (Serial SCSI Protocol (SSP)).
> The only things that will probably care about the
> difference between such SATA disks and SAS disks are
> utilities like smartmontools (and that gap is being
> partially closed as well).

Linux will always want to talk to a device in its native command set, 
unless a firmware _forces_ us to do otherwise.

If the user considers a SAT layer added value, then they can certainly 
use such at their site.


> Perhaps libata could be renamed libsat.

s/libata/libata-scsi/

libata core is a SCSI-independent ATA transport, approaching the "ATA 
transport class" that I described above.

	Jeff


