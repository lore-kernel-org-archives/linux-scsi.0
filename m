From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: device/volume info on transport removal
Date: Tue, 18 Aug 2009 21:22:12 -0500
Message-ID: <4A8B61D4.4040706@cs.wisc.edu>
References: <06C3D92ADC647D45918996C82BFB6B996C6325B79C@GVW0433EXB.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54333 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZHSCWS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 22:22:18 -0400
In-Reply-To: <06C3D92ADC647D45918996C82BFB6B996C6325B79C@GVW0433EXB.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Auld, Brian (LeftHand Networks)" <brian.auld@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/18/2009 01:47 PM, Auld, Brian (LeftHand Networks) wrote:
> I have a question about the lifetime of volume/disk info for SAN
> disks.
>
> Say my server has discovered a disk/volume on a SAN (iscsi or fc).  A
> connection is established at the transport layer.  Presumably disk
> information (eg. vpd inquiry data and the like) is saved in a layer
> (SBC disk layer?) above the transport.
>

The scsi layer has info on the disk. Some of it is in /sys/block/sdX/device.

> What happens if the server explicitly logs out of the session for the
> above disk/volume using whatever initiator tools are available to
> them?  Does the disk/volume info remain for some time in the higher
> layer(s) or do all the data structures related to that disk/volume
> get unplugged/removed when the transport connection is taken away?
> Of course, it goes without saying that no other objects in the OS
> (files, devices, mountpoints) are using the disk when the logout
> occurs.


For iscsi, if you logged out of the session with a tool like iscsiadm
then the disks would be removed from the OS.

Same goes for FC I guess. If you were to remove the fc module like lpfc 
or qla2xxx then the hba, ports and disks would go away. I am not sure if 
there is a tool that allows you to remove just one port (for a vport you 
can use the sysfs interface though).
