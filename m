From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Export SCSI Inquiry data to sysfs
Date: Fri, 14 Aug 2015 14:53:30 +0200
Message-ID: <55CDE4CA.6060703@suse.de>
References: <1439466608-31577-1-git-send-email-jthumshirn@suse.de> <55CD8B64.1080400@suse.de> <55CDDEBB.1040402@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55CDDEBB.1040402@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/14/2015 02:27 PM, James Smart wrote:
> On 8/14/2015 2:32 AM, Hannes Reinecke wrote:
>> On 08/13/2015 01:50 PM, Johannes Thumshirn wrote:
>>> Export the RAW SCSI Inquiry to sysfs as binfile. This way the
>>> data can be used by userlang without the need to have and ioctl or =
use the
>>> sg_inq tool.
>>>
>> userland!
>>
>=20
> Just be careful. There are conditions where this could be stale
> data....   LUN reconfig on an array that hasn't been rescanned by
> the mid layer yet is such a case.
>=20
> Any reason you didn't have the sysfs call initiate a lun scan or
> send an inquiry so it's always valid data ?
>=20
Currently the SCSI stack doesn't do LUN rescanning; the only way
to recover from stale data is to remove the device and initiate
a host rescan. That's why we have tools like rescan-scsi-bus.sh etc.

We're working on moving the SCSI stack to do a LUN rescanning, but
that's still future stuff.

So this patch just displays the status quo, without any added
functionality.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
