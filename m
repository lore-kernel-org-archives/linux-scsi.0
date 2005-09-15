From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: SG_FLAG_LUN_INHIBIT broken?
Date: Thu, 15 Sep 2005 16:45:35 -0700
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BE0F@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdscexfe02.sc.wdc.com ([129.253.170.52]:29346 "EHLO
	wdscexfe02.sc.wdc.com") by vger.kernel.org with ESMTP
	id S932590AbVIOXpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2005 19:45:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Can anyone confirm that this flag actually works when doing SG_IO? (I'm
testing on a 2.6.13-rc6 kernel)

I'm attempting to do an ata-pt command on a cypress board:
http://www.cypress.com/portal/server.pt?space=CommunityPage&control=SetCommu
nity&CommunityID=209&PageID=259&fid=14&rpn=CY7C68320

It involves a 16-byte cdb with cdb[ 1 ] = 0x24 as a signature byte (Page 13
of the datasheet).  So when the scsi stack adds lun info, it kills the
signature byte.

I've tried adding SG_FLAG_LUN_INHIBIT to the SG_IO header, but neither sd or
sg seem to obey it. After looking at the source neither driver seems to make
any reference to SG_FLAG_LUN_INHIBIT.

Eventually all the commands seemed to be funneled to
scsi.c:532:scsi_dispatch_cmd which does this:
	if (cmd->device->scsi_level <= SCSI_2) {
		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
			       (cmd->device->lun << 5 & 0xe0);
	}
So basically this is an unconditional "add lun info" if the scsi spec is
<=2, which is what usb-storage devices end up being.

Is SG_FLAG_LUN_INHIBIT supposed to be supported still or is it deprecated or
something?

Thanks,
Tim Thelin

