From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Sat, 19 Mar 2016 16:18:09 +0100
Message-ID: <56ED6DB1.1050202@suse.de>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
 <56EC797A.8000104@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbcCSPSP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2016 11:18:15 -0400
In-Reply-To: <56EC797A.8000104@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

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
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
