From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] scsi_transport_fc: LUN masking
Date: Fri, 29 Jan 2016 15:59:02 +0100
Message-ID: <56AB7E36.2060608@suse.de>
References: <1447238080-109942-1-git-send-email-hare@suse.de>
 <56AB7DE1.5070107@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbcA2O7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 09:59:04 -0500
In-Reply-To: <56AB7DE1.5070107@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@avagotech.com>

On 01/29/2016 03:57 PM, Hannes Reinecke wrote:
> On 11/11/2015 11:34 AM, Hannes Reinecke wrote:
>> Hi all,
>>
>> having been subjected to the pain of trying to bootstrap a really
>> large machine with systemd I decided to implement LUN masking in
>> scsi_transport_fc.
>> The principle is simple: disallow the automated LUN scanning when
>> discovering a rport, and create udev rules which selectively
>> enable individual LUNs by echoing the relevant values in the 'scan'
>> attribute of the SCSI host.
>> With that I'm able to boot an arbitrary large machine without
>> running into any udev or systemd imposed timeout.
>> To _disable_ LUN masking and restoring the original behaviour
>> I've noticed that the 'scan' sysfs attribute is actually synchronous=
,
>> ie the calling process will be blocked until the entire LUN scan
>> is completed.
>> So I've added another module parameter 'async_user_scan' to
>> move the scanning onto the existing scan workqueue, and unblock
>> the calling process.
>>
>> As usual, comments and reviews are welcome.
>>
>> Hannes Reinecke (2):
>>   scsi_transport_fc: implement 'disable_target_scan' module paramete=
r
>>   scsi_transport_fc: Implement 'async_user_scan' module parameter
>>
>>  drivers/scsi/scsi_transport_fc.c | 47 +++++++++++++++++++++++++++++=
++++++++---
>>  1 file changed, 44 insertions(+), 3 deletions(-)
>>
> Hmm. this seemed to have fallen through
>=20
Bah. Hit send too early.

Any chance of a review for this one?
Shall I resend the patches?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
