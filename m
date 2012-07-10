From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Tue, 10 Jul 2012 12:54:48 -0400
Message-ID: <20120710165448.GE25664@kernel.stglabs.ibm.com>
References: <4FE454CA.6080007@matthiasprager.de>
 <4FFAED4F.3080100@matthiasprager.de>
 <4FFB32E5.1050109@farcaster.org>
 <20120709204513.GD25664@kernel.stglabs.ibm.com>
 <4FFB5A0F.30400@farcaster.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FFB5A0F.30400@farcaster.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Trace <maillist@farcaster.org>
Cc: Matthias Prager <linux@matthiasprager.de>, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 09, 2012 at 06:24:15PM -0400, Robert Trace wrote:
> On 07/09/2012 04:45 PM, Darrick J. Wong wrote:
> >
> > I suspect that /sys/devices/<bunch of sas topology here>/manage_start_stop = 0
> > for the SATA devices hanging off the SAS controller.
> 
> Yep, looks like you're right.  For my system:
> 
> # cat /sys/block/sd?/device/scsi_disk/*/manage_start_stop
> 1
> 1
> 1
> 1
> 1
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> 0
> 
> Those first 5 disks are SATA disks on SATA controllers.  The last 8
> disks are SATA disks on the SAS controller.
> 
> > Setting that sysfs
> > attribute to 1 is supposed to enable the SCSI layer to send TUR when it sees
> > "LU not ready", as well as spin down the drives at suspend/poweroff time.
> 
> Setting it to 1 doesn't seem to have made any difference, however.
> 
> # cat /sys/block/sdm/device/scsi_disk/14\:0\:7\:0/manage_start_stop
> 0
> # echo 1 > /sys/block/sdm/device/scsi_disk/14\:0\:7\:/manage_start_stop
> # cat /sys/block/sdm/device/scsi_disk/14\:0\:7\:0/manage_start_stop
> 1
> # hdparm -y /dev/sdm
> 
> /dev/sdm:
>  issuing standby command
> # hdparm -C /dev/sdm
> 
> /dev/sdm:
>  drive state is:  standby
> # dd if=/dev/sdm of=/dev/null bs=512 count=1
> dd: reading `/dev/sdm': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.00117802 s, 0.0 kB/s
> 
> ... and on the scsi logging side, I see the read(10) to the disk which
> immediately returns "Not Ready" and the I/O failure bubbles up the
> chain.  And afterwards, the disk is still asleep.
> 
> # hdparm -C /dev/sdm
> 
> /dev/sdm:
>  drive state is:  standby
> 
> Also, TURs don't appear to actually wake the disk up (should they?).
> The only thing I've found that'll wake the disk up is an explicit START
> UNIT command.

Sorry, I misspoke, manage_start_stop=1 sends START UNIT, not TUR.  Also, it
only manages spindown/up at suspend/resume time, hence the behavior you see.
The relevant source code is sd_start_stop_device() in drivers/scsi/sd.c.

--D
> 
> -- Rob
> 

