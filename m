From: David Nedved <dnedved@nuvox.net>
Subject: Re: how to change sector size on fibrechannel drives
Date: Fri, 14 Jun 2002 10:48:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020614104848.D1261@nuvox.net>
References: <20020613093514.B25071@nuvox.net> <3D093147.3C64CB43@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D093147.3C64CB43@torque.net>; from dougg@torque.net on Thu, Jun 13, 2002 at 07:56:55PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

This looks like a very promising program.  Having trouble getting it to
talk to the devices though... the first drive gets assigned sdc by the
kernel, but since it has the wrong sector size, sdc doesn't really get
properly bound to the drive - any attempt to use /dev/sdc results in:

# ./scu -f /dev/sdc
scu: Unable to open device '/dev/sdc', errno = 6 - Device not configured

Okay, so I'll try the nexus command in scu to identify it by bus,target,lun.

Here's a snippet of what I get while inserting the scsi module:

Attached scsi disk sdc at scsi3, channel 0, id 114, lun 0
sdc : unsupported sector size 528.
SCSI device sdc: 0 528-byte hdwr sectors (0 MB)

Here's a snippet of what I get when I cat /proc/scsi/scsi after inserting
the scsi module:

Host: scsi3 Channel: 00 Id: 114 Lun: 00
   Vendor: SEAGATE Model: ST136403FC   Rev: 0004
   Type: Direct-Access                 ANSI SCSI revision: 02

So it looks like the drve has been assigned target 114.  I try scu:

# ./scu
scu> set nexus bus 3 target 114 lun 0
scu: Keywork 'target' requires range between (0 - 15).

And since scu is binary-only I can't modify the source...

I don't have that much experience with SCSI over FC, but it looks like
the scu utility itself that has a problem with targets over 15, not just
the kernel or driver or something.  I'll work on trying to get them
re-assigned to low targets, but without any sort of documentation on
the drive frame, I have low probability of success here...

Anyone have any ideas about how to get past this point?  Thanks for the
pointer Douglas... so close yet so far...

David

On Thu, Jun 13, 2002 at 07:56:55PM -0400, Douglas Gilbert wrote:
> David Nedved wrote:
> > 
> > Hi All,
> > 
> > I've salvaged some drives from a MTI fibre channel RAID device, and I'm
> > trying to use them in linux 2.4.18.  When the scsi module loads, it sees
> > the drives, but reports them all as having the dreaded
> > "unsupported sector size 528" message.  All the searches I've done seem
> > to indicate a low-level format of the drives.   The FC card I'm using,
> > however (Emulex LP8000), doesn't seem to have an option for low-level
> > formatting in the BIOS.  I've also tried the lputil command that comes with
> > the driver, but it seems to have trouble finding the adapter, and it doesn't
> > seem to have any utilities that would help me anyway.
> > 
> > My fibre channel toys are rather limited, in other words, I don't have
> > any other controllers with which to low-level these drives.  In a pinch
> > I could probably find a wintel machine to throw the card into if I had to
> > in order to low-level format the drives, but this would be rather hard
> > since I don't have any windows machines.
> > 
> > Am I out of luck?  I wouldn't mind the inefficiency of only using 512
> > of the 528 bytes in each block if there's some way to override the
> > default setting... although I would much rather reformat them...
> > 
> > Oh, the drives are all ST136403FC drives if that matters.
> 
> David,
> Have a look at the scu utility at this url:
> http://www.bit-net.com/~rmiller/scu.html
> 
> You should be able to use the format to resize your sectors.
> 
> Doug Gilbert
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
   __   __   __ _ __ __      __  __ ____ __   __ _ ____ __
  /  | /, | / / // //  |    /  |/ // __//  | / / // __//  |
 / / //   // / // // / /   / , ' // _/ / / // / // _/ / / /
/___//_/_/ |__//_//___/   /_/|__//___//___/ |__//___//___/

Unix Systems Engineer              VOICE: +1 864 331 8181
NuVox Communications, Inc.         FAX:   +1 864 331 7234
301 North Main Street, Ste 5000    EMAIL: dnedved@nuvox.net
Greenville, SC  29601   USA        PAGER: pagenedved@nuvox.net
