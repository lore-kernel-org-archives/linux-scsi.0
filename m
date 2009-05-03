From: David Miller <davem@davemloft.net>
Subject: Re: MPT fusion SAS target numbering...
Date: Sat, 02 May 2009 17:09:12 -0700 (PDT)
Message-ID: <20090502.170912.263716496.davem@davemloft.net>
References: <660360F4F2570145BD872F298951B17A80F01F53@cosmail03.lsi.com>
	<20090502.155155.30314776.davem@davemloft.net>
	<1241307038.3639.73.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44075
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504AbZECAJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 20:09:17 -0400
In-Reply-To: <1241307038.3639.73.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, tayfun.kocaoglu@sun.com, Greg.Onufer@sun.com

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
