From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: MPT fusion SAS target numbering...
Date: Sat, 2 May 2009 22:20:28 -0600
Message-ID: <660360F4F2570145BD872F298951B17A80F01F54@cosmail03.lsi.com>
References: <660360F4F2570145BD872F298951B17A80F01F53@cosmail03.lsi.com>
	<20090502.155155.30314776.davem@davemloft.net>
	<1241307038.3639.73.camel@mulgrave.int.hansenpartnership.com>,<20090502.170912.263716496.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og60.obsmtp.com ([64.18.14.185]:37467 "EHLO
	chip3og60.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZECEUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 00:20:39 -0400
In-Reply-To: <20090502.170912.263716496.davem@davemloft.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tayfun.kocaoglu@sun.com" <tayfun.kocaoglu@sun.com>, "Greg.Onufer@sun.com" <Greg.Onufer@sun.com>

James

The SAS1.0 mpt fusion controllers have device mapping in the firmware.   Meaning there is persistent target ids maintained by fusion firmware.  Our device driver finds out the target ids at driver load time when it scans the sas device page 0 config pages.  Also the target ids are provided in the hotplug events.   When scsi commands are sent to firmware, devices are are addressed using firmware target ids via the SCSI_IO message frame.  Our driver has to convert the target ids passed in by scmd->device->id, to the target ids needed by our firmware.  The mapping is stored in the sdev hostdata.   Obviously what this means is our persistent ids mapping set by our controller firmware is thrown out when we call sas_rphy_add().    I debated this problem with you and Christoph back when we design
 ed the sas transport layer several years back.  You guys said that persistency will be handled by udev (device ids or path), and the debate ended with that.      If you want to change this now, that would be great (making many customers much happier).

However, the SAS2.0 mpt2sas fusion controller doesn't have device mapping, that was pushed up to the drivers.   Addressing of devices are using device handles.

The windows device driver guys have implemented device mapping in the sas2.0 drivers,  I didn't.

Eric

________________________________________
From: David Miller [davem@davemloft.net]
Sent: Saturday, May 02, 2009 6:09 PM
To: James.Bottomley@HansenPartnership.com
Cc: Moore, Eric; linux-scsi@vger.kernel.org; tayfun.kocaoglu@sun.com; Greg.Onufer@sun.com
Subject: Re: MPT fusion SAS target numbering...

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 02 May 2009 18:30:38 -0500

> On Sat, 2009-05-02 at 15:51 -0700, David Miller wrote:
>> From: "Moore, Eric" <Eric.Moore@lsi.com>
>> Date: Sat, 2 May 2009 16:44:54 -0600
>>
>> > the sas transport layer is assigning the target id's
>>
>> Can you show me where that happens and how the MPT fusion
>> SAS driver exports the SAS topology target IDs to that
>> layer?
>
> It happens in scsi_transport_sas.c:sas_rphy_add() which uses the
> sas_host_attr's next_target_id to track a monotonically increasing
> number for the SCSI target id (it gets incremented every time a remote
> port is added to the system).
>
> What the SAS spec defines as the target id is really a 64 bit WWPN,
> which was difficult at the time to place in the SCSI mid layer SPI based
> concept of a target.   If the fusion is also defining some number as a
> target id that isn't the WWPN, then we could export that as well
> somewhere ... that's essentially what we did for the qlogic and emulex
> persistent bindings.

It's not a WWPN, the SAS topology scan on the MPT Fusion SAS card
provides a SCSI target ID to use.

This way when disks are popped in and out of slots, the SCSI target
remains the same.  The microcode on the card keeps a WWPN to SCSI
target ID mapping.  Once it sees a WWPN for the first time, it creates
a new mapping in it's table.

The system firmware, and the Solaris MPT Fusion driver, both use this
value in this way.

Without using this mapping, Linus makes it insanely difficult for me
to install boot loaders correctly.  Because I have to be able to map
from Linux device to firmware device and the only way I can sanely do
that is if the Linux device driver respects the SAS topology provided
target ID given the the MPT SAS card.
