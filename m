From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Sysfs does not recognise tape devices ?
Date: Fri, 07 Nov 2003 09:00:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FAAD28D.4050803@torque.net>
References: <018f01c3a397$e093d600$a0074d0a@apac.cisco.com> <Pine.LNX.4.58.0311052318250.2344@kai.makisara.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:14859 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263959AbTKGJRC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 04:17:02 -0500
In-Reply-To: <Pine.LNX.4.58.0311052318250.2344@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Wed, 5 Nov 2003, Surekha.PC wrote:
> 
> 
>>Hi,
>>
>>I have a iSCSI setup with scsi disk and tape configured as iSCSI
>>targets. The disks are recognised with sysfs, but tape device entries
>>are not getting created.
>>
> 
> The tapes should be visible as SCSI devices in, e.g.,
> /sys/bus/scsi/devices/. You can find disks in /sys/block. The tapes belong
> to /sys/cdev but it is a very new addition to sysfs and the code to show
> the tapes there has not been done yet. It should be very easy based on
> Doug Gilberts code for sg but the feature freeze will prevent adding it
> to the official kernel for some time.

Kai,
It would be interesting to see what model you propose for
/sys/cdev and st. I felt that the cdev mechanism
was "three-quarter baked" when I used it for sg. It is flat
with no obvious support for driver parameters (unless I set
up a dummy "device" like /sys/cdev/major/sg/<driver_params>).

For a tape device the /sys/class/scsi_device/<h:c:t:l>/device
directory should have a symlink called "tape" but what to?
The st driver has a one to many mapping here; multiple
symlinks?

Until the st driver uses the cdev interface, linux in lk 2.6
will be limited to a maximum of 32 tape drives.

Doug Gilbert





