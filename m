From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SG_FLAG_LUN_INHIBIT broken?
Date: Mon, 19 Sep 2005 17:33:53 +1000
Message-ID: <432E69E1.6030705@torque.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BE0F@WDSCEXBECL03.sc.wdc.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:23965 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932357AbVISHd2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 03:33:28 -0400
In-Reply-To: <CA45571DE57E1C45BF3552118BA92C9D69BE0F@WDSCEXBECL03.sc.wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Timothy Thelin <Timothy.Thelin@wdc.com>
Cc: linux-scsi@vger.kernel.org

Timothy Thelin wrote:
> Can anyone confirm that this flag actually works when doing SG_IO? (I'm
> testing on a 2.6.13-rc6 kernel)

Timothy,
No it doesn't work. It hasn't worked since the lk 2.2
series. It has been renamed to:
SG_FLAG_UNUSED_LUN_INHIBIT

Notice that addition of the _UNUSED_ . It is pretty old
stuff, SCSI-2 commands reserved the 3 top bits in byte
one for the lun. Nowadays luns are 64 bit quantities that
are sent to the target outside the cdb which carries the
SCSI command.

I thought it had been removed from the mid level, but ...

> I'm attempting to do an ata-pt command on a cypress board:
> http://www.cypress.com/portal/server.pt?space=CommunityPage&control=SetCommu
> nity&CommunityID=209&PageID=259&fid=14&rpn=CY7C68320
> 
> It involves a 16-byte cdb with cdb[ 1 ] = 0x24 as a signature byte (Page 13
> of the datasheet).  So when the scsi stack adds lun info, it kills the
> signature byte.
> 
> I've tried adding SG_FLAG_LUN_INHIBIT to the SG_IO header, but neither sd or
> sg seem to obey it. After looking at the source neither driver seems to make
> any reference to SG_FLAG_LUN_INHIBIT.
> 
> Eventually all the commands seemed to be funneled to
> scsi.c:532:scsi_dispatch_cmd which does this:
> 	if (cmd->device->scsi_level <= SCSI_2) {
> 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
> 			       (cmd->device->lun << 5 & 0xe0);
> 	}
> So basically this is an unconditional "add lun info" if the scsi spec is
> <=2, which is what usb-storage devices end up being.
> 
> Is SG_FLAG_LUN_INHIBIT supposed to be supported still or is it deprecated or
> something?

The above code is a worry because a lot of devices
just place 0 in the version (byte 2 of an INQUIRY
response). Perhaps scsi_level in sysfs
(/sys/class/scsi_device/<h:c:i:l>/device/scsi_level)
should be writable.

Doug Gilbert
