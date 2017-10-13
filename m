From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 1/1] qla2xxx: Fix sparse warnings for N2N
Date: Fri, 13 Oct 2017 14:28:21 +0000
Message-ID: <4F1AD9BA-994D-4CD0-9C9C-6E317A869E56@cavium.com>
References: <20171013060821.28237-1-himanshu.madhani@cavium.com>
 <1507897522.24441.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0081.outbound.protection.outlook.com ([104.47.34.81]:48544
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758184AbdJMO2X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 10:28:23 -0400
In-Reply-To: <1507897522.24441.87.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <4410023737FFD5438862B7191A6FBBFF@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Oct 13, 2017, at 5:25 AM, Ewan D. Milne <emilne@redhat.com> wrote:
>=20
> On Thu, 2017-10-12 at 23:08 -0700, Madhani, Madhani wrote:
>> From: Himanshu Madhani <himanshu.madhani@cavium.com>
>>=20
>> Fixes following warning reported by 0-day kernel test build
>>=20
>> drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla2x00_els_dcmd2_iocb_tim=
eout':
>> drivers/scsi/qla2xxx/qla_iocb.c:2611:50: warning: format '%x' expects a =
matching
>> 'unsigned int' argument [-Wformat=3D]
>>         "%s %d ELS Timeout, %8phC hdl=3D%x, portid=3D%06x\n",
>>=20
>> drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla2x00_els_dcmd2_sp_done'=
:
>> drivers/scsi/qla2xxx/qla_iocb.c:2634:11: warning: format '%s' expects ar=
gument of type 'char *', but argument 6 has type 'uint32_t {aka unsigned in=
t}' [-Wformat=3D]
>>         "%s %s ELS hdl=3D%x, portid=3D%06x done %8pC\n",
>> 	               ^
>> drivers/scsi/qla2xxx/qla_iocb.c:2634:35: warning: format '%x' expects ar=
gument of type 'unsigned int', but argument 8 has type 'uint8_t * {aka unsi=
gned char *}' [-Wformat=3D]
>>         "%s %s ELS hdl=3D%x, portid=3D%06x done %8pC\n",
>>                                     ^
>> drivers/scsi/qla2xxx/qla_iocb.c:2634:44: warning: format '%p' expects a =
matching 'void *' argument [-Wformat=3D]
>>         "%s %s %ELS %hdl=3D%x, %portid=3D%06x %done %8pC\n",
>> 	                                           ^
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
>> ---
>> drivers/scsi/qla2xxx/qla_iocb.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_=
iocb.c
>> index 6e57c48f8d95..0502ed7ee14e 100644
>> --- a/drivers/scsi/qla2xxx/qla_iocb.c
>> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
>> @@ -2608,7 +2608,7 @@ qla2x00_els_dcmd2_iocb_timeout(void *data)
>> 	int res;
>>=20
>> 	ql_dbg(ql_dbg_io + ql_dbg_disc, vha, 0x3069,
>> -	    "%s %d ELS Timeout, %8phC hdl=3D%x, portid=3D%06x\n",
>> +	    "%s hdl=3D%x ELS Timeout, %8phC portid=3D%06x\n",
>> 	    sp->name, sp->handle, fcport->port_name, fcport->d_id.b24);
>>=20
>> 	/* Abort the exchange */
>> @@ -2631,7 +2631,7 @@ qla2x00_els_dcmd2_sp_done(void *ptr, int res)
>> 	struct scsi_qla_host *vha =3D sp->vha;
>>=20
>> 	ql_dbg(ql_dbg_io + ql_dbg_disc, vha, 0x3072,
>> -	    "%s %s ELS hdl=3D%x, portid=3D%06x done %8pC\n",
>> +	    "%s ELS hdl=3D%x, portid=3D%06x done %8pC\n",
>> 	    sp->name, sp->handle, fcport->d_id.b24, fcport->port_name);
>>=20
>> 	complete(&lio->u.els_plogi.comp);
>=20
> Can you please just submit a corrected v2 of your earlier patch instead
> of this one?

Sure.

Martin,=20

let me know if you would refer me to submit v2 of the original patch or thi=
s patch is okay?=20

> -Ewan
>=20

Thanks,
Himanshu=
