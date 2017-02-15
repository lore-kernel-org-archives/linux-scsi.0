From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 10/16] aacraid: Terminate kthread on controller fw assert
Date: Wed, 15 Feb 2017 22:22:46 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8C1F6F@avsrvexchmbx2.microsemi.net>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-11-RaghavaAditya.Renukunta@microsemi.com>
 <9d502c4a-a3ad-352e-c3d0-2d08042c5f1b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0074.outbound.protection.outlook.com ([104.47.41.74]:10190
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752061AbdBOWWt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 17:22:49 -0500
In-Reply-To: <9d502c4a-a3ad-352e-c3d0-2d08042c5f1b@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Wednesday, February 15, 2017 12:44 AM
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
> On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> > When the command thread performs a periodic time sync and the
> firmware is
> > going through an assert during that time, the command thread waits for
> the
> > response that would never arrive. The SCSI Mid layer's error handler wo=
uld
> > eventually reset the controller, but the eh_handler just issues a
> > "thread stop" to the command thread which is stuck on a semaphore and
> the
> > eh_thread would in turn goes to sleep waiting for the command_thread to
> > respond to the stop which never happens.
> >
> > Fixed by allowing SIGTERM for the command thread, and during the
> eh_reset
> > call, sends termination signal to the command thread. As a follow-up, t=
he
> > eh_reset handler would take care of the controller reset.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> > ---
>=20
> This look a bit scary. Can't the kthread be converted to a workqueue so
> we could call cancel_work_sync()?

Could you please elaborate on the reasons why this fix is scary?
I understand that killing a thread is not standard (for any reason),=20
and if there are other nuanced issues I would like to understand them.

Thank you,
Raghava Aditya=20

>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
