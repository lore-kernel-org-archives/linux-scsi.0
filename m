Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,URI_NOVOWEL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67F8C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 20:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C7F20791
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 20:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GiXpxjaR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgHUUjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 16:39:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHUUjM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2020 16:39:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LKcPrU073306;
        Fri, 21 Aug 2020 20:38:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=AFHfhbzrbB3NYV80oBb0oXYAbnfEpQENih4j/CWrRMA=;
 b=GiXpxjaRkKIfhPgKQWF+GeYgnVqv38EBJx0QhpIslddHgdVxaHiE9mcju+uBIL3lZ50a
 T+w+02uEPznTH9o2+UopSHiyoM9dWyRzDlmIkzvjsOEPlewvI1JfGhUl1537vpgaX8gV
 0S1Hoj6hFzeAVKhqXtuZ+ZmsgoKLXJa/mwUxdbKyyr4mVnUz6HwzaqaEOTi8C4irHO6B
 TJ3qozgDkz66o1z73TQSralI7JD7rQr1AkBwet8zv4ZQXorkIVq3oqCmGZKO/jRRHKLD
 K+e3ixfbv0Nstm05pDvqviu/cP6JA5Bdh8Z1j7xYXTFfNaqQlmqWsN2Vn+1DVBdEnEyI QA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74rqy0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 20:38:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LKYRO5069490;
        Fri, 21 Aug 2020 20:36:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 332537442d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 20:36:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07LKaorw025872;
        Fri, 21 Aug 2020 20:36:55 GMT
Received: from dhcp-10-154-102-214.vpn.oracle.com (/10.154.102.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Aug 2020 20:36:49 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] fix qla2xxx regression on sparc64
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <CB119AD6-7E23-4D21-981C-192CB4B711B8@exactcode.de>
Date:   Fri, 21 Aug 2020 15:36:48 -0500
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <39338712-769A-4E6D-AE45-5F2F4FBB0919@oracle.com>
References: <20200821.142814.268140009249624430.rene@exactcode.com>
 <153E6E8E-1C07-42C5-B847-010DA7B12206@oracle.com>
 <EC166A40-AA26-47F7-974B-E81C213C9861@exactcode.de>
 <288DF841-CA64-4EDE-B24C-90F1BD4D930D@oracle.com>
 <353B5EF7-D23C-4D57-8612-42292197F650@exactcode.de>
 <44E2ECAE-17D3-4EC4-B0CC-25AA1128BB56@oracle.com>
 <CB119AD6-7E23-4D21-981C-192CB4B711B8@exactcode.de>
To:     =?utf-8?Q?Ren=C3=A9_Rebe?= <rene@exactcode.de>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9720 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9720 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210192
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 21, 2020, at 3:21 PM, Ren=C3=A9 Rebe <rene@exactcode.de> wrote:
>=20
> Hey,
>=20
>> On 21. Aug 2020, at 20:00, Himanshu Madhani =
<himanshu.madhani@oracle.com> wrote:
>>=20
>>=20
>>=20
>>> On Aug 21, 2020, at 12:49 PM, Ren=C3=A9 Rebe <rene@exactcode.de> =
wrote:
>>>=20
>>> Hi,
>>>=20
>>>> On 21. Aug 2020, at 17:17, Himanshu Madhani =
<himanshu.madhani@oracle.com> wrote:
>>>>=20
>>>> Hi Rene,=20
>>>>=20
>>>>> On Aug 21, 2020, at 9:47 AM, Ren=C3=A9 Rebe <rene@exactcode.de> =
wrote:
>>>>>=20
>>>>> Hey,
>>>>>=20
>>>>>> On 21. Aug 2020, at 15:49, Himanshu Madhani =
<himanshu.madhani@oracle.com> wrote:
>>>>>>=20
>>>>>> Hi Rene,
>>>>>>=20
>>>>>>=20
>>>>>>> On Aug 21, 2020, at 7:28 AM, Rene Rebe <rene@exactcode.com> =
wrote:
>>>>>>>=20
>>>>>>>=20
>>>>>>> Commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97 in 2014 broke
>>>>>>> qla2xxx on sparc64, e.g. as in the Sun Blade 1000 / 2000.
>>>>>>> Unbreak by fixing endianess in nvram firmware defaults
>>>>>>> initialization.
>>>>>>>=20
>>>>>>=20
>>>>>> I could not find this commit =
9a50aaefc1b896e734bf7faf3d085f71a360ce97 in Linus or SCSI tree.=20
>>>>>=20
>>>>> Did I copy this wrong?
>>>>> 	=
https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/gi=
t/torvalds/linux.git/commit/drivers/scsi/qla2xxx?id=3D9a50aaefc1b896e734bf=
7faf3d085f71a360ce97__;!!GqivPVa7Brio!L6-irbVsNXqZh_TSb_WyaBZ1S3Evo18GqWr8=
hX2Z-tNl3rZbWv0orEt7Igy_n_89mkIf$=20
>>>>>=20
>>>>=20
>>>> Yes. The actual commit that change those lines is following=20
>>>>=20
>>>> =
https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/gi=
t/torvalds/linux.git/commit/?id=3D98aee70d19a7e3203649fa2078464e4f402a0ad8=
__;!!GqivPVa7Brio!Jsf7iuXhoEimJ56ynA6RrwNm3nkfk3ATaMfNVTUhnU9-NfIZT3eVBiXt=
sQHXXzu7NMDs$=20
>>>>=20
>>>> So your fixes tag should be=20
>>>>=20
>>>> Fixes: 98aee70d19a7e ("qla2xxx: Add endianizer to max_payload_size =
modifier.=E2=80=9D)
>>>>=20
>>>> And looking at the changes, I see that the frame_payload_size was =
changed to __le16 so this should not cause regression in your env.=20
>>>>=20
>>>> Interestingly this patch had fixed the regression and was =
originally tested on SunBlade-1000
>>>>=20
>>>> =
https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/gi=
t/torvalds/linux.git/commit/?id=3D4e08df3f91837656c36712f559d5ce8d80852760=
__;!!GqivPVa7Brio!Jsf7iuXhoEimJ56ynA6RrwNm3nkfk3ATaMfNVTUhnU9-NfIZT3eVBiXt=
sQHXX5pZx4bu$=20
>>>>=20
>>>> Can you try reverting 98aee70d19a7e and retest to confirm that this =
patch indeed introduced regression for you.=20
>>>=20
>>> Well, linux kernels since 3.17 did not work on this adapter on =
sparc64:
>>>=20
>>> and I reverted the whole 9a50aaefc1b896e734bf7faf3d085f71a360ce97 =
and factored the changes out and tested what I sent with 5..8.1.
>>>=20
>>> This was also reported back in the say, but somehow never applied, =
..?
>>>=20
>>> 	=
https://urldefense.com/v3/__https://lore.kernel.org/lkml/86A17A977688E0468=
9F40F6B1EC20EC601940E06A9@AVMB1.qlogic.org/__;!!GqivPVa7Brio!Jsf7iuXhoEimJ=
56ynA6RrwNm3nkfk3ATaMfNVTUhnU9-NfIZT3eVBiXtsQHXX9w-_N_o$=20
>>>=20
>>=20
>> Wow. This should have been done the moment Author acknowledged the =
revert. I am stumped that we are still talking about this revert after =
5+ yrs and its not done. Would you please send just plain revert request =
for commit 98aee70d19a7e rather than reverting whole merge window patch.
>=20
> Well, how many people care about vintage Sun sparc64 hardware, ..? ;-)
>=20
> IMHO it makes no sense to revert this in full today. It does not =
revert cleanly and all the other __le16 conversions did not cause =
regressions that I know of.
> So instead having one not __le16 member, I suggest the partial revert =
I posted initially. I can resend it with the updated Fixes: reference as =
requested
>=20

Okay. I am fine with the patch you send earlier with Fixes tag and also =
add Cc to Stable as well so that it get ported in stable release.=20
I would also like you to add link for the past discussion in the commit =
message so that we remember why this patch was added.=20

>        /* Firmware Initialization Control Block. */
> -      uint16_t version;
> +      __le16  version;
>        uint16_t reserved_1;
> ++<<<<<<< HEAD
> +      __le16  frame_payload_size;
> +      __le16  execution_throttle;
> +      __le16  exchange_count;
> +      __le16  hard_address;
> ++=3D=3D=3D=3D=3D=3D=3D
> +       uint16_t frame_payload_size;
> +       uint16_t execution_throttle;
> +       uint16_t exchange_count;
> +       uint16_t hard_address;
> ++>>>>>>> parent of 98aee70d19a7... qla2xxx: Add endianizer to =
max_payload_size modifier.
>=20
> =E2=80=A6
>=20
> @@@ -8411,11 -5903,11 +8437,19 @@@ =
qla81xx_nvram_config(scsi_qla_host_t *v
>                 * Set default initialization control block.
>                 */
>                memset(nv, 0, ha->nvram_size);
> ++<<<<<<< HEAD
> +              nv->nvram_version =3D cpu_to_le16(ICB_VERSION);
> +              nv->version =3D cpu_to_le16(ICB_VERSION);
> +              nv->frame_payload_size =3D cpu_to_le16(2048);
> +              nv->execution_throttle =3D cpu_to_le16(0xFFFF);
> +              nv->exchange_count =3D cpu_to_le16(0);
> ++=3D=3D=3D=3D=3D=3D=3D
> +               nv->nvram_version =3D =
__constant_cpu_to_le16(ICB_VERSION);
> +               nv->version =3D __constant_cpu_to_le16(ICB_VERSION);
> +               nv->frame_payload_size =3D =
__constant_cpu_to_le16(2048);
> +               nv->execution_throttle =3D =
__constant_cpu_to_le16(0xFFFF);
> +               nv->exchange_count =3D __constant_cpu_to_le16(0);
> ++>>>>>>> parent of 98aee70d19a7... qla2xxx: Add endianizer to =
max_payload_size modifier.
>=20
> =E2=80=A6
>=20
>>> Regards,
>>> 	Ren=C3=A9
>>>=20
>>>>>> Can you please provide details of the commit which introduced =
this regression.
>>>>>=20
>>>>> See above, there was plenty of more reworks and code shuffling, =
and the quoted commit is also a condensed changes of other /14 series =
and other scsi work, =E2=80=A6
>>>>>=20
>>>>> Have a nice weekend,
>>>>> 	Ren=C3=A9
>>>>>=20
>>>>>> Also when you
>>>>>> resubmit this patch please use Fixes tag. See documentation here =
for the correct format.
>>>>>>=20
>>>>>> =
https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/gi=
t/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst__;!=
!GqivPVa7Brio!L6-irbVsNXqZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_=
n620C3iF$=20
>>>>>>=20
>>>>>>> Signed-off-by: Ren=C3=A9 Rebe <rene@exactcode.de>
>>>>>>>=20
>>>>>>> --- linux-5.8/drivers/scsi/qla2xxx/qla_init.c.vanilla	=
2020-08-21 09:55:18.600926737 +0200
>>>>>>> +++ linux-5.8/drivers/scsi/qla2xxx/qla_init.c	2020-08-21 =
09:57:35.992926885 +0200
>>>>>>> @@ -4603,18 +4603,18 @@
>>>>>>> 			nv->firmware_options[1] =3D BIT_7 | =
BIT_5;
>>>>>>> 			nv->add_firmware_options[0] =3D BIT_5;
>>>>>>> 			nv->add_firmware_options[1] =3D BIT_5 | =
BIT_4;
>>>>>>> -			nv->frame_payload_size =3D 2048;
>>>>>>> +			nv->frame_payload_size =3D =
cpu_to_le16(2048);
>>>>>>> 			nv->special_options[1] =3D BIT_7;
>>>>>>> 		} else if (IS_QLA2200(ha)) {
>>>>>>> 			nv->firmware_options[0] =3D BIT_2 | =
BIT_1;
>>>>>>> 			nv->firmware_options[1] =3D BIT_7 | =
BIT_5;
>>>>>>> 			nv->add_firmware_options[0] =3D BIT_5;
>>>>>>> 			nv->add_firmware_options[1] =3D BIT_5 | =
BIT_4;
>>>>>>> -			nv->frame_payload_size =3D 1024;
>>>>>>> +			nv->frame_payload_size =3D =
cpu_to_le16(1024);
>>>>>>> 		} else if (IS_QLA2100(ha)) {
>>>>>>> 			nv->firmware_options[0] =3D BIT_3 | =
BIT_1;
>>>>>>> 			nv->firmware_options[1] =3D BIT_5;
>>>>>>> -			nv->frame_payload_size =3D 1024;
>>>>>>> +			nv->frame_payload_size =3D =
cpu_to_le16(1024);
>>>>>>> 		}
>>>>>>>=20
>>>>>>> 		nv->max_iocb_allocation =3D cpu_to_le16(256);
>>>>>>>=20
>>>>>>> --=20
>>>>>>> Ren=C3=A9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 =
Berlin
>>>>>>> =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!KU2euUg=
VJIRXqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxI-1EV4u$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!KU2euUgVJIR=
XqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxAAjd8CY$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!KU2euUgV=
JIRXqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxDUjMdad$=20
>>>>>>=20
>>>>>> --
>>>>>> Himanshu Madhani	 Oracle Linux Engineering
>>>>>>=20
>>>>>=20
>>>>> --=20
>>>>> ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin, =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!L6-irbV=
sNXqZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_n-uIVWXr$=20
>>>>> =
https://urldefense.com/v3/__https://exactscan.com__;!!GqivPVa7Brio!L6-irbV=
sNXqZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_n2dniKkK$  | =
https://urldefense.com/v3/__https://ocrkit.com__;!!GqivPVa7Brio!L6-irbVsNX=
qZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_n-v2wVJD$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!L6-irbVsNXq=
Zh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_n9g--eFu$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!L6-irbVs=
NXqZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_nxllUxx0$
>>>>=20
>>>> --
>>>> Himanshu Madhani	 Oracle Linux Engineering
>>>>=20
>>>=20
>>> --=20
>>> ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin, =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!Jsf7iuX=
hoEimJ56ynA6RrwNm3nkfk3ATaMfNVTUhnU9-NfIZT3eVBiXtsQHXX6haBk6D$=20
>>> =
https://urldefense.com/v3/__https://exactscan.com__;!!GqivPVa7Brio!Jsf7iuX=
hoEimJ56ynA6RrwNm3nkfk3ATaMfNVTUhnU9-NfIZT3eVBiXtsQHXX4W9vLaa$  | =
https://urldefense.com/v3/__https://ocrkit.com__;!!GqivPVa7Brio!Jsf7iuXhoE=
imJ56ynA6RrwNm3nkfk3ATaMfNVTUhnU9-NfIZT3eVBiXtsQHXX04ZQeL4$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!Jsf7iuXhoEi=
mJ56ynA6RrwNm3nkfk3ATaMfNVTUhnU9-NfIZT3eVBiXtsQHXX6DRH0bV$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!Jsf7iuXh=
oEimJ56ynA6RrwNm3nkfk3ATaMfNVTUhnU9-NfIZT3eVBiXtsQHXXz0D-Wul$
>>=20
>> --
>> Himanshu Madhani	 Oracle Linux Engineering
>>=20
>=20
> --=20
> ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin, =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!Pzi_Eey=
o1QdtyP0r5gMlCBHiq2DPWzBnz2dTVcfduR8O8gSkBXIZ3RI4DP0Q74GDxqJE$=20
> =
https://urldefense.com/v3/__https://exactscan.com__;!!GqivPVa7Brio!Pzi_Eey=
o1QdtyP0r5gMlCBHiq2DPWzBnz2dTVcfduR8O8gSkBXIZ3RI4DP0Q76FLfX-m$  | =
https://urldefense.com/v3/__https://ocrkit.com__;!!GqivPVa7Brio!Pzi_Eeyo1Q=
dtyP0r5gMlCBHiq2DPWzBnz2dTVcfduR8O8gSkBXIZ3RI4DP0Q70Zxm72q$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!Pzi_Eeyo1Qd=
tyP0r5gMlCBHiq2DPWzBnz2dTVcfduR8O8gSkBXIZ3RI4DP0Q79_X62BE$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!Pzi_Eeyo=
1QdtyP0r5gMlCBHiq2DPWzBnz2dTVcfduR8O8gSkBXIZ3RI4DP0Q71A3vvWa$=20
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

