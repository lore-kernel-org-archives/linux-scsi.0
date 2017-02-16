From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 10/16] aacraid: Terminate kthread on controller fw assert
Date: Thu, 16 Feb 2017 19:53:40 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8C30EB@avsrvexchmbx2.microsemi.net>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-11-RaghavaAditya.Renukunta@microsemi.com>
 <9d502c4a-a3ad-352e-c3d0-2d08042c5f1b@suse.de>
 <4D8E82A446BF54499747901DBDEB737A7B8C1F6F@avsrvexchmbx2.microsemi.net>
 <2b400849-db1a-4109-37f2-cd00fc1ccc85@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0042.outbound.protection.outlook.com ([104.47.38.42]:61893
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932344AbdBPTyR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 14:54:17 -0500
In-Reply-To: <2b400849-db1a-4109-37f2-cd00fc1ccc85@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Thursday, February 16, 2017 1:31 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Dave Carroll <david.carroll@microsemi.com>; Gana Sridaran
> <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>; dan.carpenter@oracle.com
> Subject: Re: [PATCH 10/16] aacraid: Terminate kthread on controller fw
> assert
>=20
> EXTERNAL EMAIL
>=20
>=20
> On 02/15/2017 11:22 PM, Raghava Aditya Renukunta wrote:
> >>
> >> This look a bit scary. Can't the kthread be converted to a workqueue s=
o
> >> we could call cancel_work_sync()?
> >
> > Could you please elaborate on the reasons why this fix is scary?
> > I understand that killing a thread is not standard (for any reason),
> > and if there are other nuanced issues I would like to understand them.
>=20
> I'm actually concerned that this could have all kinds of side effects.
> But this is just a gut feeling. I see some drm drivers are doing the
> same, so it might be possible, but IMHO this is not a good design.
>=20
> And IIRC kthreads do have more downsides (i.e. CPU hotplugging and
> issues with kernel live patching).
>=20
> I think most kthreads (haven't looked too close to the aacraid kthread I
> must admit, but I'll be doing so) can be converted to either workqueues
> or timers (or a combination of both).
>=20
> Thanks,
>         Johannes

Makes sense,  and I agree. With that being said I will withdraw this patch
and resend it out in different patch series once we  rework aac_command_thr=
ead
into a work queue/timers.

Regards,
Raghava Aditya


> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
