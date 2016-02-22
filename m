From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Sun, 21 Feb 2016 20:45:06 -0800
Message-ID: <56CA9252.8030007@sandisk.com>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
 <1455869840-122786-21-git-send-email-hare@suse.de>
 <56C7688A.2050608@sandisk.com> <56C81DB5.7070102@suse.de>
 <56C8834F.50304@sandisk.com> <56C9750B.9010200@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0072.outbound.protection.outlook.com ([157.56.111.72]:29077
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753376AbcBVEpS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Feb 2016 23:45:18 -0500
In-Reply-To: <56C9750B.9010200@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/21/16 00:27, Hannes Reinecke wrote:
> On 02/20/2016 04:16 PM, Bart Van Assche wrote:
>> On 02/20/16 00:03, Hannes Reinecke wrote:
>>> Also when using your suggestion the 'access_state' attribute will only
>>> be created _after_ the 'ADD' uevent, making it impossible to use it from
>>> udev events.
>>
>> Can you give an example in which it would be useful to read the ALUA
>> state from a udev handler ? I'm not sure such an example exists.
>>
> When evaluating the 'access_state' from an uevent we can avoid sending
> I/O if the path is unavailable; eg if the path is in 'transitioning' I/O
> will be queued until that path becomes available again.
> Which means that the uevent will be delayed during udev processing, so
> that the event will never be read by multipathing (as it's being invoked
> only after udev event processing has finished).
> And in extreme cases (like OnTap takeover/giveback) it will even drop
> the event completely due to a timeout.

Hello Hannes,

Thanks for the feedback.

Please split the access_state attribute in two sysfs attributes - one 
for the ALUA state and one for the "preferred" state. This will make it 
easier for shell scripts to process these sysfs attributes.

I agree with using the 'is_visible' callback. But since using that 
callback will cause the ALUA sysfs attributes to become only visible 
after the ALUA handler has been attached I don't see why not to move the 
implementation of the ALUA sysfs attributes into the ALUA device handler 
source file.

BTW, since the ALUA state can change at any time after the access_state 
sysfs attribute has been read and before I/O is submitted my preference 
is to avoid triggering any SCSI commands from a udev rule that depend on 
the ALUA state.

Bart.
