From: Douglas Gilbert <dougg@torque.net>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 21:55:41 +1000
Message-ID: <42FB3CBD.6040006@torque.net>
References: <OFBC81092C.89B6F4D5-ONC125705A.00365E9F-C125705A.0037CB40@de.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:42408 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932351AbVHKLzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 07:55:45 -0400
In-Reply-To: <OFBC81092C.89B6F4D5-ONC125705A.00365E9F-C125705A.0037CB40@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Seipp <SEIPP@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Harald Seipp wrote:
> [ Please CC any replies; I am not on this list]
> 
> I have two systems, each with at least two SCSI HDDs attached&mounted:
> SLES 9 (2.6.5-7.151-smp)
> Knoppix 3.9 (2.6.11.10)
> If I execute echo "scsi remove-single-device h b t l" > /proc/scsi/scsi on
> a mounted HDD target, the device will be _removed_. A subsequent echo "scsi
> add-single-device h b t l" > /proc/scsi/scsi on the same target will cause
> the device to be re-added, but it will appear at a different (next free)
> device file (e.g. /dev/sda will become /dev/sdc when two HDDs are
> attached).
> This behavior does not appear when running kernel 2.4-based systems on the
> same machines, the mounted HDDs will not be touched.
> 
> I assume this is a bug? How can I prevent that behavior? 

Harald,
I just tried remove-single-device followed by
add-single-device and I got /dev/sda back again.
I also placed the two commands in a script file
so they were executed with a very short delay between
the two commands.

The test was with lk 2.6.13-rc6 and a multicard
reader (4 luns) via the usb-storage driver.

BTW in lk 2.6 a SCSI device can be removed with:
echo "anything" >
    /sys/class/scsi_device/<h>:<b>:<t>:<l>/device/delete

and re-added with:
echo "<b> <t> <l>" > /sys/class/scsi_host/host<h>/scan


> Can I easily query
> if a device on "h b t l" is mounted to work-around?

ls /sys/class/scsi_device/<h>:<b>:<t>:<l>

will indicate (in the lk 2.6 series) that SCSI device
"h b t l" is present or not. As for mounted file systems
on (partitions of) a disk when its is removed and re-added,
I'm not so sure: seems like a questionable procedure IMO.

Doug Gilbert
