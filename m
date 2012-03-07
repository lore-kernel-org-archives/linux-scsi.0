From: santosh prasad nayak <santoshprasadnayak@gmail.com>
Subject: Re: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
Date: Wed, 7 Mar 2012 20:52:02 +0530
Message-ID: <CAOD=uF78_x80rtnT5weceoHcTMvhRGEJB6iL-GVQKJ70Mw6=EQ@mail.gmail.com>
References: <4f4a4580.aa3a440a.34c7.2776@mx.google.com>
	<4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn>
	<D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com>
	<00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Jack Wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

Thanks for your response.
I will send a patch with the required changes as per your suggestion.


regards
Santosh

On Wed, Mar 7, 2012 at 8:41 PM, Mark Salyzyn <mark_salyzyn@xyratex.com>=
 wrote:
> One more NAK:
>
>> @@ -3497,7 +3499,7 @@ static int mpi_hw_event(struct pm8001_hba_info=
 *pm8001_ha, void* piomb)
>> static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void=
 *piomb)
>> {
>> =A0 =A0 =A0 u32 pHeader =3D (u32)*(u32 *)piomb;
>> - =A0 =A0 u8 opc =3D (u8)((le32_to_cpu(pHeader)) & 0xFFF);
>> + =A0 =A0 u8 opc =3D (u8)(pHeader & 0xFFF);
>>
>> =A0 =A0 =A0 PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iom=
b:"));
>
> The swap is necessary. Should be:
>
> =A0 =A0 =A0 =A0__le32 pHeader =3D (__le32)*(__le32 *)piomb;
>
> instead ...
>
> Sincerely -- Mark Salyzyn
>
> On Mar 7, 2012, at 9:58 AM, Mark Salyzyn wrote:
>
>> NAK on one point.
>>
>> The fw_flash_Update_resp structure erroneously defines tag as a dma_=
addr_t, when in fact it should be an __le32, as the response hTag is re=
ported in this field. The removal of the le32_to_cpu(ppayload->tag) was=
 done to remove a warning, but is incorrect. The warning should have be=
en solved by correctly defining the tag element in the structure.
>>
>> Sincerely -- Mark Salyzyn
>>
>> On Feb 26, 2012, at 11:51 PM, Jack Wang wrote:
>>
>>> Thanks for fix.
>>> Acked-by: Jack Wang <jack_wang@usish.com>
>>>>
>>>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>>>
>>>> 1. Fix endian issue.
>>>> 2. Fix the following warning :
>>>> =A0 " drivers/scsi/pm8001/pm8001_hwi.c:2932:32: warning: compariso=
n
>>>> =A0 =A0 between 'enum sas_device_type' and 'enum sas_dev_type'".
>>>> 3. Few code optimization.
>>>>
>>>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>>>> ---
>>>> . . .
>>>> @@ -3149,7 +3152,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_i=
nfo
>>>> *pm8001_ha, void *piomb)
>>>> =A0 =A0 struct fw_control_ex =A0 =A0fw_control_context;
>>>> =A0 =A0 struct fw_flash_Update_resp *ppayload
>>>> =A0 =A0 =A0 =A0 =A0 =A0 (struct fw_flash_Update_resp *)(piomb + 4)=
;
>>>> - =A0 u32 tag =3D le32_to_cpu(ppayload->tag);
>>>> + =A0 u32 tag =3D ppayload->tag;
>>>> =A0 =A0 struct pm8001_ccb_info *ccb =3D &pm8001_ha->ccb_info[tag];
>>>> =A0 =A0 status =3D le32_to_cpu(ppayload->status);
>>>> =A0 =A0 memcpy(&fw_control_context,
>>
>
> _____________________________________________________________________=
_
> This email may contain privileged or confidential information, which =
should only be used for the purpose for which it was sent by Xyratex. N=
o further rights or licenses are granted to use such information. If yo=
u are not the intended recipient of this message, please notify the sen=
der by return and delete it. You may not use, copy, disclose or rely on=
 the information contained in it.
>
> Internet email is susceptible to data corruption, interception and un=
authorised amendment for which Xyratex does not accept liability. While=
 we have taken reasonable precautions to ensure that this email is free=
 of viruses, Xyratex does not accept liability for the presence of any =
computer viruses in this email, nor for any losses caused as a result o=
f viruses.
>
> Xyratex Technology Limited (03134912), Registered in England & Wales,=
 Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>
> The Xyratex group of companies also includes, Xyratex Ltd, registered=
 in Bermuda, Xyratex International Inc, registered in California, Xyrat=
ex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi)=
 Co Ltd registered in The People's Republic of China and Xyratex Japan =
Limited registered in Japan.
> _____________________________________________________________________=
_
>
>
