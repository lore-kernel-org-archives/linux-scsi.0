From: Douglas Gilbert <dougg@torque.net>
Subject: Re: HBA switching devices online status...
Date: Tue, 16 Apr 2002 09:08:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBC225F.D75E55B4@torque.net>
References: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D1F@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Heinz, Michael" <mheinz@infiniconsys.com>
Cc: linux-scsi@vger.kernel.org

"Heinz, Michael" wrote:
> 
> If the SCSI midlayer flags a device as offline due to errors, is there
> any way to restore the device once the errors have been resolved?
> 
> I'm interested in either manual or automatic (i.e., in the driver)
> solutions. Looking through the source for different HBAs I didn't see
> any obvious hints.

Michael,
It has been suggested that the following sequence will work:

  echo "scsi remove-single-device <h> <b> <t> <l>" > /proc/scsi/scsi
  echo "scsi add-single-device <h> <b> <t> <l>" > /proc/scsi/scsi

where the host, bus, target, lun (parameters above respectively)
are obtained from "cat /proc/scsi/scsi". BTW you can see the state
of the online flag with "cat /proc/scsi/sg/devices" (last column).

My scsimon driver has an ioctl to turn it back on.

There is nothing stopping your HBA driver from setting the
online flag in the Scsi_device structure.

Doug Gilbert
