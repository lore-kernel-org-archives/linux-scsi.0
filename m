From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 11/9] firewire: fw-sbp2: enforce a retry of __scsi_add_device
 if bus generation changed
Date: Fri, 08 Feb 2008 20:58:01 +0100
Message-ID: <47ACB449.3060200@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <47A9FBFD.50100@s5r6.in-berlin.de> <tkrat.b66856ee2df66cd4@s5r6.in-berlin.de> <200802081354.23299.jwilson@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37680 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040AbYBHT6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 14:58:03 -0500
In-Reply-To: <200802081354.23299.jwilson@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

(Adding Cc: LSML)

Jarod Wilson wrote:
> On Wednesday 06 February 2008 04:09:47 pm Stefan Richter wrote:
>> take care that __scsi_add_device does not return success
>> even though the SCSI high-level driver probing failed (sd READ_CAPACITY
>> and friends) due to bus reset.  The trick to do so is to use a different
>> error indicator in the command completion as long as __scsi_add_device
>> did not return.

Or so did I guess, and...

>> An actual failure of __scsi_add_device is easy to handle, but an
>> incomplete execution of __scsi_add_device with an sdev returned would
>> remain undetected and leave the SBP-2 target unusable.
>>
>> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>> ---
>>
>> Jarod, does this work like I assume and fixes your setup of two OXFW911
>> based disks?
> 
> Well, it results in the dmesg spew saying "sd 6:0:0:0: [sdc] Result: 
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK" -- i.e., 
> DID_NO_CONNECT instead of DID_BUS_BUSY, but other than that, no change in 
> behavior, sdc remains unusable just as before.

...my guess was wrong then.

Either I misunderstood the semantics of the various hostbyte codes in
the command completion return (and then these semantics are
insufficient) --- or SCSI mid layer or high-level implements them wrong.

But before we dive into the SCSI stack or implement parellelism of SBP-2
reconnect and SCSI probing in fw-sbp2, there is another simple and in
hindsight obvious trick we can try.  Stay tuned.

Background for LSML:

In case of unrecoverable transport failures during the execution of
__scsi_add_device, I would like to send appropriate error indicators
from the LLD up to SCSI midlayer so that __scsi_add_device ends in
failure (i.e. returns an error pointer rather than a scsi_device pointer).

Sometimes SCSI core decides to let __scsi_add_device fail, sometimes it
takes the scsi_device offline, sometimes it doesn't do either but
pretends to the LLD that __scsi_add_device was an utter success.  Except
that userspace can't do anything with the scsi_device because e.g. READ
CAPACITY couldn't be executed.
-- 
Stefan Richter
-=====-==--- --=- -=---
http://arcgraph.de/sr/
