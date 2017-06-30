From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 1/2] scsi: qla2xxx: remove incorrect byte swap
Date: Fri, 30 Jun 2017 17:00:12 +0000
Message-ID: <F97DB636-CF5B-4612-9127-FD9D38AE5BF4@cavium.com>
References: <20170630161056.30630-1-arnd@arndb.de>
 <1498840917.8086.3.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498840917.8086.3.camel@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <73BDC75D6C4B57439802F6A536091980@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Trapp, Darren" <Darren.Trapp@cavium.com>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "Grigsby, Duane" <Duane.Grigsby@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Jun 30, 2017, at 9:41 AM, James Bottomley <jejb@linux.vnet.ibm.com> wr=
ote:
>=20
> On Fri, 2017-06-30 at 18:10 +0200, Arnd Bergmann wrote:
>> cont_pkt->entry_type is an 8-bit field, so doing a 32-bit byteswap
>> on it will store incorrect data:
>>=20
>> drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2x00_start_nvme_mq':
>> include/uapi/linux/byteorder/big_endian.h:32:26: error: large integer
>> implicitly truncated to unsigned type [-Werror=3Doverflow]
>> drivers/scsi/qla2xxx/qla_nvme.c:444:27: note: in expansion of macro
>> 'cpu_to_le32'
>>     cont_pkt->entry_type =3D cpu_to_le32(CONTINUE_A64_TYPE);
>>=20
>> This removes the erroneous cpu_to_le32().
>>=20
>> Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization
>> and transport registration")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c
>> b/drivers/scsi/qla2xxx/qla_nvme.c
>> index 1da8fa8f641d..14e25e32e622 100644
>> --- a/drivers/scsi/qla2xxx/qla_nvme.c
>> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
>> @@ -441,7 +441,7 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
>>  				req->ring_ptr++;
>>  			}
>>  			cont_pkt =3D (cont_a64_entry_t *)req-
>>> ring_ptr;
>> -			cont_pkt->entry_type =3D
>> cpu_to_le32(CONTINUE_A64_TYPE);
>> +			cont_pkt->entry_type =3D CONTINUE_A64_TYPE;
>> =20
>=20
> We already have a patch proposed for this, but I think it may be wrong
> (it's the same as yours, so yours may be wrong too) see the handling in
> qla_iocb.c
>=20
> James

I will send patch which has correct usage in qla_iocb.c shortly.=20

Thanks,
- Himanshu
