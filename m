From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Thu, 21 Aug 2014 14:41:10 +0000
Message-ID: <bug-80711-11613-Ic5Vh9f0Bz@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37192 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaHUOlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2014 10:41:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B9BB5201BF
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2014 14:41:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 84521201BA
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2014 14:41:11 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #11 from d gilbert <dgilbert@interlog.com> ---
On 14-08-20 03:15 PM, Alan Stern wrote:
> On Tue, 19 Aug 2014, Christoph Hellwig wrote:
>
>> On Thu, Aug 07, 2014 at 11:58:37AM -0400, Alan Stern wrote:
>>>> On Wed, Aug 06, 2014 at 04:02:22PM -0400, Alan Stern wrote:
>>>>>> I doubt either of them forces users to hack up flags for these cases.
>>>>>
>>>>> Why was this change needed in the first place?  There's no explanation
>>>>> in the patch itself.
>>>>
>>>> Which chance?  The one to not support SG_FLAG_LUN_INHIBIT?
>>>
>>> No, the patch that started this Bugzilla entry.  Tiziano says it is
>>> needed in order to send vendor-specific commands that use the LUN bits
>>> in CDB[1].
>>
>> Yes, I'd really like to know the exact scenario.  What kind of command
>> is this and who sends it?
>
> I don't know what the command is, but Tiziano is sending it via the
> SCSI-generic (sg) interface.
>
> In the meantime, I have made a little progress with Windows.  It turns
> out there are two reasons my earlier test didn't work:
>
> 	I didn't bother to set up a valid serial number for the test
> 	device, and Windows wants to see the serial number.
>
> 	Windows wants at least one of the logical units to be
> 	removable.
>
> After those issues were fixed, the host did recognize both logical
> units.  I tested with two devices, one reporting an ANSI SCSI level of
> 0 and the other 2.  In both cases, Windows 7 does _not_ stick the LUN
> value into the high bits of CDB[1].
>
> This suggests that we shouldn't be doing that either, for USB
> mass-storage devices.  But I'm reluctant to change it because of the
> possibility of regressions, not to mention the fact that it would
> violate the SCSI spec.
>
> Suggestions?

Perhaps we could add another bit flag in struct
scsi_host_template such as:
     unsigned int transport_says_dont_scsi2_lun_cmd:1;

then drivers/usb/storage/scsiglue.c could set that
bit in its usb_stor_host_template and
drivers/scsi/scsi.c could take heed (and not mask
cmd->cmnd[1] with the LUN).

Doug Gilbert

-- 
You are receiving this mail because:
You are the assignee for the bug.