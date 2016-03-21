From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Mon, 21 Mar 2016 16:40:57 -0400 (EDT)
Message-ID: <1709049972.24310562.1458592857261.JavaMail.zimbra@redhat.com>
References: <1458200385-32088-1-git-send-email-hare@suse.de> <56EC797A.8000104@sandisk.com> <56ED6DB1.1050202@suse.de> <56EF4D4A.6050000@sandisk.com> <56EF9F7E.2010300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:53472 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbcCUUlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2016 16:41:07 -0400
In-Reply-To: <56EF9F7E.2010300@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Hello Hannes

Please share latest scripts and an example of how you are using them.
I have some scripts from last November, that you posted but I am sure t=
hey have changed.
If not then I will modify them as appropriate, just let me know.

I have added the patches and booted the system set to async, so before =
I boot with scsi_mod.scan=3Dmanual want to prepare my test system.
This feature may be a very useful feature we would want to include in R=
HEL as we struggle with large LUN boot configurations all the time.
When you have time and thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Hannes Reinecke" <hare@suse.de>
To: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Martin K. Petersen=
" <martin.petersen@oracle.com>
Cc: "Christoph Hellwig" <hch@lst.de>, "James Bottomley" <james.bottomle=
y@hansenpartnership.com>, linux-scsi@vger.kernel.org
Sent: Monday, March 21, 2016 3:15:10 AM
Subject: Re: [PATCHv3] scsi: disable automatic target scan

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
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
