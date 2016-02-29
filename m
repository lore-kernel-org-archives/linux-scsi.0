From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 3/3] scsi: allow scsi devices to use direct complete
Date: Mon, 29 Feb 2016 12:10:09 +0200
Message-ID: <20160229101009.GE1770@lahna.fi.intel.com>
References: <1456359748-22838-1-git-send-email-dbasehore@chromium.org>
 <1456359748-22838-3-git-send-email-dbasehore@chromium.org>
 <20160227072641.GX1770@lahna.fi.intel.com>
 <CAGAzgsoAiL0Xmqi3gzNyuQ6kf47UiEsO3V6-WMgkd5-Wu2y42Q@mail.gmail.com>
 <20160227083857.GY1770@lahna.fi.intel.com>
 <CAGAzgsrzwO_uCLeJWnqfZXGbv8Ex=i_jfQ=W9AhqEdv0-uuN-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGAzgsrzwO_uCLeJWnqfZXGbv8Ex=i_jfQ=W9AhqEdv0-uuN-w@mail.gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 27, 2016 at 01:07:06AM -0800, dbasehore . wrote:
> That's an interesting question. Part of direct complete is to leave
> the device runtime suspended even after the system resumes if
> possible. The comments in pm_complete_with_resume_check indicate that
> the firmware may resume a device. I could see this happening with some
> kind of SCSI device.
> 
> If this is possible, are we able to put the device back into a
> consistent state (runtime suspended) by calling suspend for the scsi
> device? If not, we might need to use pm_complete_with_resume_check for
> the complete callback.

To me the latter option sounds safer.

I tried this series (as I'm interested in AHCI host controller runtime
PM) and noticed possible issue.

I have following two additional patches from linux-next applied to get
system resume working (otherwise resume is never finished):

  d07ab6d11477 block: Add blk_set_runtime_active()
  356fd2663cff scsi: Set request queue runtime PM status back to active on resume

Then I do this:

  # echo auto > /sys/block/sda/device/power/control
  # echo 5000 > /sys/block/sda/device/power/autosuspend_delay_ms

  # echo auto > /sys/bus/pci/devices/0000\:00\:12.0/ata1/power/control

The last line unblocks runtime PM from the parent device.

After 5 seconds of idle I see that the disk gets runtime suspended:

  [  566.858971] sd 0:0:0:0: [sda] Synchronizing SCSI cache
  [  567.049288] sd 0:0:0:0: [sda] Stopping disk

Now suspend the machine:

  # rtcwake -s10 -mmem

Once the system resumes I get this:

  [  668.879149] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
  [  668.927319] ata1.00: configured for UDMA/133
  [  669.392246] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
  [  669.440427] ata1.00: configured for UDMA/133
  [  669.445352] sd 0:0:0:0: [sda] Starting disk
  [  669.464647] sda: detected capacity change from 0 to 240057409536
  [  669.482596] sda: detected capacity change from 0 to 240057409536

It looks like we get resumed two times. If I have this patch reverted I
can see it happening only once. Also with the patch applied and if the
parent device has runtime PM blocked, it happens only once.
