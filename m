From: Sancho Dauskardt <sancho@dauskardt.de>
Subject: Re: /proc/scsi/map
Date: Sat, 15 Jun 2002 21:49:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.0.2.1.2.20020615213722.038c4940@pop.puretec.de>
References: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net


>Life would be easier if the scsi subsystem would just report which SCSI
>device (uniquely identified by the controller,bus,target,unit tuple) belongs
>to which high-level device. The information is available in the kernel.
>
>Attached patch does this:
>garloff@pckurt:/raid5/Kernel/src $ cat /proc/scsi/map
># C,B,T,U       Type    onl     sg_nm   sg_dev  nm      dev(hex)
>0,0,00,00       0x05    1       sg0     c:15:00 sr0     b:0b:00
[...]

Great, this was really missing badly.

But how about adding another column: GUID.
Most usb-storage and (all?) FireWire devices have such a unique identitiy.
In contrast to native SCSI devices, these emulated SCSI devices on 
hot-plugging busses will change their LUNs/IDs. Therefor the GUID is really 
a must to be able to create stable names (laptop suspend, etc.).

Both usb-storage and iee1394-sbp2 know the GUID. It only needs to be 
communicated..

I'd guess that FibreChannel has similar problems ?

- sda

