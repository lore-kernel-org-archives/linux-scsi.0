From: Tejun Heo <tj@kernel.org>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Thu, 17 Aug 2017 07:46:57 -0700
Message-ID: <20170817144657.GF3238792@devbig577.frc2.facebook.com>
References: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
 <13561110-4e59-303a-8e3d-dd60c1bafba8@fastmail.fm>
 <20170817124821.GA3238792@devbig577.frc2.facebook.com>
 <4debd4d8dea1d534ef555ceae4429435@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4debd4d8dea1d534ef555ceae4429435@assyoma.it>
Sender: linux-ide-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Aug 17, 2017 at 04:15:35PM +0200, Gionatan Danti wrote:
> Ok, so *this* is the root cause of the problem: libata not
> identifying spurious link renegotiations vs brief powerloss/powerup
> events. Out of curiosity: is this a SATA-specific problem (ie: in
> the SATA specification), or even SAS disks are affected?

No idea about SAS.  They're identical at the link layer tho.

> >Because we don't wanna be ditching disks on temporary link glitches,
> >which do happen once in a while.
> 
> Any chances to report I/O errors to the upper layers *without*
> offlining the device? In this manner, upper layers (ie: MDRAID) can
> act in a more informate way. For example: single disk device will
> simple retry the failed operation, while MDRAID can take the
> "badblocks" code path to deal with the error.

Upper layer can request to avoid retrying on errors but it won't help
too much.  It doesn't have much to do with specific commands.  A power
event can take place without any command in flight and lose the
buffered data.  Unless upper layer is tracking all that's being
written, there isn't much it can do outside doing full scan.  This is
a condition which should be handled from the driver side.

> >So, the right way to deal with the problem probably is making use of
> >the SMART counter which indicates power loss events and verify that
> >the counter hasn't increased over link issues.  If it changed, the
> >device should be detached and re-probed, which will make it come back
> >as a different block device.  Unfortunately, I haven't had the chance
> >to actually implement that.
> 
> This is a very good idea, maybe I can implement it in userspace with
> a simple, fast polling scheme (for example, each 60 seconds). Such a
> polling would not prevent all corruption scenarios, but will at
> least timely inform the user.

Yeah, looking into getting it implemented on the kernel side.

Thanks.

-- 
tejun
