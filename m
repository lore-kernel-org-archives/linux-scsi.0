From: James Bottomley <jejb@steeleye.com>
Subject: Re: scsi "target1:0:0"
Date: 16 Nov 2004 10:33:13 -0600
Message-ID: <1100622800.2574.41.camel@mulgrave>
References: <1100622096.8606.104.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45029 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262046AbUKPQdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 11:33:24 -0500
In-Reply-To: <1100622096.8606.104.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-11-16 at 10:21, Kay Sievers wrote:
> We got an additional directory in the /devices directory which
> changed:
>   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host1/1:0:0:0
> 
> to:
>   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host1/target1:0:0/1:0:0:0
> 
> The inserted "target1:0:0" is _not_ backed by any "bus" or "class" device
> and therefore breaks the logic of HAL to bring the devices together by
> its parent. (We also don't get hotplug events for the "target*" device at
> creation time)

Could you explain what specific problem this causes.  You do get a
hotplug for the LUNs; a target is simply an additional node in the tree.

> Is this intentional and we can not expected a straight chain of devices
> anymore like it always was? Shouldn't there be a "class" device to have
> it consistent again.

Essentially yes.  a target is simply a LUN container.  It has no real
existence (it's created when the first lun is encountered and destroyed
when the last LUN is removed).  It's job is really to hold parameters
that apply to all LUNs.

James



