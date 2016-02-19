From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv7 20/23] scsi: Add 'access_state' attribute
Date: Fri, 19 Feb 2016 07:49:24 +0100
Message-ID: <56C6BAF4.9000100@suse.de>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-21-git-send-email-hare@suse.de>
 <56C63DB8.6020306@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404AbcBSGt0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 01:49:26 -0500
In-Reply-To: <56C63DB8.6020306@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/18/2016 10:55 PM, Bart Van Assche wrote:
> On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
>> Add an 'access_state' attribute to struct scsi_device to
>> display the asymmetric LUN access state.
>=20
> Do we really need to add this attribute to SCSI devices that do not
> support ALUA, e.g. ATA devices ? From a system on which this patch
> series has been installed:
>=20
> [root ~]# lsscsi | grep 0:0:0:0
> [0:0:0:0] disk ATA ST1000NM0033-9ZM GA67 /dev/sda
> [root ~]# cat /sys/class/scsi_device/0:0:0:0/device/access_state
> active/optimized
>=20
Well.

I've hit the same issue with my patches exposing vpd pages to sysfs.

Thing is, the sysfs entries are created during scsi_alloc_sdev().
But we only know if the have these entries during scsi_add_lun(), ie
way beyond that point. So ATM we don't have a chance of selectively
enabling them.

Any change here would require a modification to the core sysfs
behaviour, which might not that easy.

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
