From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] SCSI support for SMR/ZBC commands
Date: Thu, 08 May 2014 10:31:40 +0200
Message-ID: <536B40EC.4070905@suse.de>
References: <CACs+NxSQovDcanMXBbqr+rd=7TCa99DKzxkGQvuM9+_oy3BGBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CACs+NxSQovDcanMXBbqr+rd=7TCa99DKzxkGQvuM9+_oy3BGBA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: HanBin Yoon <hanbinyoon@google.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tytso@mit.edu
List-Id: linux-scsi@vger.kernel.org

On 05/05/2014 11:28 PM, HanBin Yoon wrote:
> SMR (Shingled Magnetic Recording) disk drives are able to achieve hig=
her areal
> density, at the cost of making media write operations to the disk mor=
e
> inflexible (i.e., divides the disk into multiple zones, each of which=
 can be
> written sequentially only).
>
> Following on some discussions in the Linux filesystem community aroun=
d SMR
> [1][2], I'd like to work on adding early support for SMR-related SCSI=
 commands
> (ZBC, or Zoned Block Commands [3]). First, I'd like to ask the Linux =
SCSI/
> filesystem communities for advice and recommendations on how to go ab=
out it.
>
> [1] http://thread.gmane.org/gmane.linux.file-systems/81970/focus=3D82=
309
> [2] http://www.spinics.net/lists/linux-fsdevel/msg72305.html
> [3] http://www.t10.org/cgi-bin/ac.pl?t=3Dd&f=3D14-010r8.pdf
>
> I'm thinking of classifying an SMR disk drive as an sd-type SCSI devi=
ce, as SMR
> is expected to be delivered in the form of an add-on/enhancement to e=
xisting
> traditional disk drives. SMR disk drives will continue to support ran=
dom read
> capability.
>
> As for exposing ZBC to upper layers of the stack, I'm thinking of two=
 potential
> ways:
>    A) As an ioctl handled by sd_ioctl(), in drivers/scsi/sd.c
>    B) As a request command flag type handled by sd_prep_fn(), in
>       drivers/scsi/sd.c
>
The actual idea was that ZMR/ZBC devices will show up as a separate=20
SCSI device type. This should be handled as a separate sub-type of=20
the existing 'sd' driver.

We have discussed the problem with exposing zones to upper layers;=20
as there'll be quite a lot of zones per device (in the order of=20
1000) it's impractical to expose these zones via sysfs individually.
If there were a way to expose the zone information in compact way we=20
might want to revisit this.

I'm not quite convinced that we need an additional ioctl for the two=20
new commands; my initial plan here is to add support for this in=20
sg3_utils and use the stock SG_IO here.

I would start by adding support for the special request (as you=20
already did in your second patch), and to figure out if and how the=20
zone information could be held in the block request_queue structure.

Problem here is that we need to tweak the allocator to not issue=20
requests spanning two zones. So either we'll be setting up a=20
device-mapper target here (like dm-switch or suchlike) which will=20
format the I/O for us, or we're pushing this information into the=20
block layer proper.

I really would like to see the real solution of pushing it into the=20
block layer / request_queue limitations, but for that we'll need=20
some efficient way of storing and looking up the zone configuration.

Ted T'so said he would be having some code for that ... Ted?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
