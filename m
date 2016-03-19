From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Sat, 19 Mar 2016 11:29:39 -0400 (EDT)
Message-ID: <1540990467.23211617.1458401379690.JavaMail.zimbra@redhat.com>
References: <1458200385-32088-1-git-send-email-hare@suse.de> <56EC797A.8000104@sandisk.com> <56ED6DB1.1050202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49097 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbcCSP3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2016 11:29:52 -0400
In-Reply-To: <56ED6DB1.1050202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Hi Hannes,

Please share those dracut patches because I want to test this patch ser=
ies.
Which kernel is the diff against for the scan patches.

Thanks=20

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Hannes Reinecke" <hare@suse.de>
To: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Martin K. Petersen=
" <martin.petersen@oracle.com>
Cc: "Christoph Hellwig" <hch@lst.de>, "James Bottomley" <james.bottomle=
y@hansenpartnership.com>, linux-scsi@vger.kernel.org
Sent: Saturday, March 19, 2016 11:18:09 AM
Subject: Re: [PATCHv3] scsi: disable automatic target scan

On 03/18/2016 10:56 PM, Bart Van Assche wrote:
> On 03/17/2016 12:39 AM, Hannes Reinecke wrote:
>> On larger installations it is useful to disable automatic LUN
>> scanning, and only add the required LUNs via udev rules.
>> This can speed up bootup dramatically.
>>
>> This patch introduces a new scan module parameter value 'manual',
>> which works like 'none', but can be overriden by setting the 'rescan=
'
>> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
>> And it updates all relevant callers to set the 'rescan' value
>> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>=20
> Hello Hannes,
>=20
> Will setting scsi_scan_type to 'manual' allow a system to boot from a
> SCSI disk? If not, are there alternatives to this approach? Would it =
be
> a valid alternative to e.g. introduce a new threshold parameter such
> that only LUN numbers below this threshold are scanned during boot?
>=20
I have a patch for dracut, which will generate udev rules for all
devices required for mounting the root fs.
Once the system is booted properly I've got another patch for systemd
which switches back to 'normal' scanning (ie by writing 'sync' into
/sys/modules/scsi_mod/parameters/scan) and rescan all scsi hosts.

With that there's no need to have any arbitrary limits; only the
necessary devices are enabled during boot.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
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
