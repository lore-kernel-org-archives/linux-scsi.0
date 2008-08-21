From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: [Scst-devel] Who do we point to?
Date: Thu, 21 Aug 2008 03:06:39 +0200
Message-ID: <200808210306.39959.stf_xl@wp.pl>
References: <200808201911.m7KJBTik015082@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.wp.pl ([212.77.101.5]:34347 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYHTXTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2008 19:19:50 -0400
In-Reply-To: <200808201911.m7KJBTik015082@wind.enjellic.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel@lists.sourceforge.net, greg@enjellic.com
Cc: vst@vlnb.net, linux-driver@qlogic.com, neilb@suse.de, linux-raid@vger.kernel.org, linuxraid@amcc.com, linux-scsi@vger.kernel.org

On Wednesday 20 August 2008, greg@enjellic.com wrote:
> Good morning hope the day is going well for everyone.
Hi Greg!

> Apologies for the large broadcast domain on this.  I wanted to make
> sure everyone who may have an interest in this is involved.
>
> Some feedback on another issue we encountered with Linux in a
> production initiator/target environment with SCST.  I'm including logs
> below from three separate systems involved in the incident.  I've gone
> through them with my team and we are currently unsure on what
> triggered all this, hence mail to everyone who may be involved.
>
> The system involved is SCST 1.0.0.0 running on a Linux 2.6.24.7 target
> platform using the qla_isp driver module.  The target machine has two
> 9650 eight port 3Ware controller cards driving a total of 16 750
> gigabyte Seagate NearLine drives.  Firmware on the 3ware and Qlogic
> cards should all be current.  There are two identical servers in two
> geographically separated data-centers.
>
> The drives on each platform are broken into four 3+1 RAID5 devices
> with software RAID.  Each RAID5 volume is a physical volume for an LVM
> volume group. There is currently one logical volume exported from each
> of four RAID5 volumes as a target device.  A total of four initiators
> are thus accessing the target server, each accessing different RAID5
> volumes.
>
> The initiators are running a stock 2.6.26.2 kernel with a RHEL5
> userspace.  Access to the SAN is via a 2462 dual-port Qlogic card.
> The initiators see a block device from each of the two target servers
> through separate ports/paths.  The block devices form a software RAID1
> device (with bitmaps) which is the physical volume for an LVM volume
> group.  The production filesystem is supported by a single logical
> volume allocated from that volume group.
>
> A drive failure occured last Sunday afternoon on one of the RAID5
> volumes.  The target kernel recognized the failure, failed the device
> and kept going.
>
> Unfortunately three of the four initiators picked up a device failure
> which caused the SCST exported volume to be faulted out of the RAID1
> device.  One of the initiators noted an incident was occurring, issued
> a target reset and continued forward with no issues.
>
> The initiator which got things 'right' was not accessing the RAID5
> volume on the target which experienced the error.  Two of the three
> initiators which faulted out their volumes were not accessing the
> compromised RAID5 volume.  The initiator accessing the volume faulted
> out its device.
For some reason SCST core need to wait for logical unit driver (aka dev 
handler) for abort comand. It is not possible to abort command instantly i.e.  
mark command as aborted, return task management success to initiator and 
after logical unit driver finish, just free resources for aborted command (I 
don't know way, maybe Vlad could tell more about this). Qlogic initiator 
device just waits for 3ware card to abort commands. As both systems have the 
same SCSI stack, such same commands timeouts. 3ware driver will return error 
to RAID5 roughly at the same time when Qlogic initiator timeouts. So 
sometimes Qlogic send only device reset and sometimes target reset too.

I believe increasing timeouts in sd driver on initiator site (and maybe 
decreasing in on target system) will help. This things are not run time 
configurable, only compile time. On initiator systems I suggest to increase 
SD_TIMEOUT and maybe on target site decrease SD_MAX_RETRIES, both values are 
in drivers/scsi/sd.h. In such configuration, when physical disk fail, 3ware 
will return error during initiator waiting for command complete, RAID5 on 
target will do the right job and from initiator point of view command will 
finish successfully.

Cheers
Stanislaw Gruszka
