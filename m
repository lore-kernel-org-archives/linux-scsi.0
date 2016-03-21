From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Mon, 21 Mar 2016 08:15:10 +0100
Message-ID: <56EF9F7E.2010300@suse.de>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
 <56EC797A.8000104@sandisk.com> <56ED6DB1.1050202@suse.de>
 <56EF4D4A.6050000@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbcCUHPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2016 03:15:12 -0400
In-Reply-To: <56EF4D4A.6050000@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/21/2016 02:24 AM, Bart Van Assche wrote:
> On 03/19/16 08:18, Hannes Reinecke wrote:
>> On 03/18/2016 10:56 PM, Bart Van Assche wrote:
>>> On 03/17/2016 12:39 AM, Hannes Reinecke wrote:
>>>> On larger installations it is useful to disable automatic LUN
>>>> scanning, and only add the required LUNs via udev rules.
>>>> This can speed up bootup dramatically.
>>>>
>>>> This patch introduces a new scan module parameter value 'manual',
>>>> which works like 'none', but can be overriden by setting the
>>>> 'rescan'
>>>> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
>>>> And it updates all relevant callers to set the 'rescan' value
>>>> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>>>
>>> Hello Hannes,
>>>
>>> Will setting scsi_scan_type to 'manual' allow a system to boot
>>> from a
>>> SCSI disk? If not, are there alternatives to this approach? Would
>>> it be
>>> a valid alternative to e.g. introduce a new threshold parameter suc=
h
>>> that only LUN numbers below this threshold are scanned during boot?
>>>
>> I have a patch for dracut, which will generate udev rules for all
>> devices required for mounting the root fs.
>> Once the system is booted properly I've got another patch for system=
d
>> which switches back to 'normal' scanning (ie by writing 'sync' into
>> /sys/modules/scsi_mod/parameters/scan) and rescan all scsi hosts.
>>
>> With that there's no need to have any arbitrary limits; only the
>> necessary devices are enabled during boot.
>=20
> Hello Hannes,
>=20
> That sounds like a really interesting approach. Will this approach
> also work if the SCSI host and/or LUN numbers change during a reboot?
>=20
It's independent on the SCSI host as it just looks for the rport ID
(FC WWPN, SAS ID, or iSCSI target name). The LUN number, however, is
fixed; the whole point of this exercise is that you want to blank
out individual LUNs behind a given target.
Hence you need to able to address the LUNs in the first place.

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
