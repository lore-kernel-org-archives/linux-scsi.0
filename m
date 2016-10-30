From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Sun, 30 Oct 2016 19:22:01 +0000
Message-ID: <BLUPR02MB168399B25661CFC9D1DA93F381AF0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
 <1477706936.2850.27.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0051.outbound.protection.outlook.com ([104.47.38.51]:20293
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753069AbcJ3TWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 Oct 2016 15:22:05 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/28/16 19:08, James Bottomley wrote:=0A=
> This is a deadlock caused by an inversion issue in kernfs (suicide vs=0A=
> non-suicide removes); so fixing it in SCSI alone really isn't=0A=
> appropriate.  I count at least five other subsystems all using this=0A=
> mechanism, so they'll all be similarly affected.  It looks to be fairly=
=0A=
> simply fixable inside kernfs, so please fix it that way.=0A=
=0A=
Hello James,=0A=
=0A=
Can you clarify this further? To me this looks like the result of how =0A=
the SCSI core works rather than an issue in the kernfs layer. My =0A=
interpretation of the deadlock report produced by the lockdep code is as =
=0A=
follows:=0A=
* The SCSI scanning code holds scan_mutex while creating sysfs=0A=
   attributes for a SCSI device. In this case scan_mutex is the outer=0A=
   mutex and s_active the inner locking object.=0A=
* scsi_remove_host() holds scan_mutex while removing sysfs attributes.=0A=
   Also in this case scan_mutex is the outer mutex and s_active the=0A=
   inner locking object.=0A=
* During self-removal (sysfs_remove_file_self() being called indirectly=0A=
   by kernfs_fop_write()), kernfs_fop_write() holds s_active while=0A=
   scsi_remove_device() is being called. In this case s_active is the=0A=
   outer locking object and scan_mutex the inner locking object.=0A=
=0A=
I think that it is essential that kernfs_fop_write() holds s_active. So =0A=
to me this looks like a lock inversion issue that cannot be fixed by =0A=
modifying kernfs only. In other words, the SCSI core has to be modified =0A=
to fix this. Do you agree with this?=0A=
=0A=
Thanks,=0A=
=0A=
Bart.=0A=
=0A=
