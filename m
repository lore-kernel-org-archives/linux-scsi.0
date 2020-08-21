Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URI_NOVOWEL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF3BC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 17:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A27220702
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 17:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=exactco.de header.i=@exactco.de header.b="iKVFFHak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgHURtq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 13:49:46 -0400
Received: from mx.exactcode.de ([144.76.154.42]:58984 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgHURtq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 13:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=exactco.de; s=x;
        h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Subject:Mime-Version:Content-Type; bh=C7Tgy0JzAaT7XJRp9kZCXNhC1iklmbjBWILonN0oEjs=;
        b=iKVFFHakgAFD1u0gEkTXP0Ha7Atz5s+H7e7fvwd4QakzdGHmJM/DEfRZsDeGWdXi5Mqwfmd3g1c07pbq2ArPkbiNwjdNYGSMKu57ZaMXCYDRqJhwp48/LclAiJxnnfdxuxC/Dub6XVTQTNTVF7x2OexUFEmZUx7mRigfDApT04U=;
Received: from exactco.de ([90.187.5.221])
        by mx.exactcode.de with esmtp (Exim 4.82)
        (envelope-from <rene@exactcode.de>)
        id 1k9BB4-0002tf-Hs; Fri, 21 Aug 2020 17:50:10 +0000
Received: from ip5f5af2bb.dynamic.kabel-deutschland.de ([95.90.242.187] helo=[192.168.0.15])
        by exactco.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.86_2)
        (envelope-from <rene@exactcode.de>)
        id 1k9AsO-0000iy-Ss; Fri, 21 Aug 2020 17:30:56 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] fix qla2xxx regression on sparc64
From:   =?utf-8?Q?Ren=C3=A9_Rebe?= <rene@exactcode.de>
In-Reply-To: <288DF841-CA64-4EDE-B24C-90F1BD4D930D@oracle.com>
Date:   Fri, 21 Aug 2020 19:49:35 +0200
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <353B5EF7-D23C-4D57-8612-42292197F650@exactcode.de>
References: <20200821.142814.268140009249624430.rene@exactcode.com>
 <153E6E8E-1C07-42C5-B847-010DA7B12206@oracle.com>
 <EC166A40-AA26-47F7-974B-E81C213C9861@exactcode.de>
 <288DF841-CA64-4EDE-B24C-90F1BD4D930D@oracle.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

> On 21. Aug 2020, at 17:17, Himanshu Madhani =
<himanshu.madhani@oracle.com> wrote:
>=20
> Hi Rene,=20
>=20
>> On Aug 21, 2020, at 9:47 AM, Ren=C3=A9 Rebe <rene@exactcode.de> =
wrote:
>>=20
>> Hey,
>>=20
>>> On 21. Aug 2020, at 15:49, Himanshu Madhani =
<himanshu.madhani@oracle.com> wrote:
>>>=20
>>> Hi Rene,
>>>=20
>>>=20
>>>> On Aug 21, 2020, at 7:28 AM, Rene Rebe <rene@exactcode.com> wrote:
>>>>=20
>>>>=20
>>>> Commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97 in 2014 broke
>>>> qla2xxx on sparc64, e.g. as in the Sun Blade 1000 / 2000.
>>>> Unbreak by fixing endianess in nvram firmware defaults
>>>> initialization.
>>>>=20
>>>=20
>>> I could not find this commit =
9a50aaefc1b896e734bf7faf3d085f71a360ce97 in Linus or SCSI tree.=20
>>=20
>> Did I copy this wrong?
>> 	=
https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/gi=
t/torvalds/linux.git/commit/drivers/scsi/qla2xxx?id=3D9a50aaefc1b896e734bf=
7faf3d085f71a360ce97__;!!GqivPVa7Brio!L6-irbVsNXqZh_TSb_WyaBZ1S3Evo18GqWr8=
hX2Z-tNl3rZbWv0orEt7Igy_n_89mkIf$=20
>>=20
>=20
> Yes. The actual commit that change those lines is following=20
>=20
> =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D98aee70d19a7e3203649fa2078464e4f402a0ad8
>=20
> So your fixes tag should be=20
>=20
> Fixes: 98aee70d19a7e ("qla2xxx: Add endianizer to max_payload_size =
modifier.=E2=80=9D)
>=20
> And looking at the changes, I see that the frame_payload_size was =
changed to __le16 so this should not cause regression in your env.=20
>=20
> Interestingly this patch had fixed the regression and was originally =
tested on SunBlade-1000
>=20
> =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D4e08df3f91837656c36712f559d5ce8d80852760
>=20
> Can you try reverting 98aee70d19a7e and retest to confirm that this =
patch indeed introduced regression for you.=20

Well, linux kernels since 3.17 did not work on this adapter on sparc64:

and I reverted the whole 9a50aaefc1b896e734bf7faf3d085f71a360ce97 and =
factored the changes out and tested what I sent with 5..8.1.

This was also reported back in the say, but somehow never applied, ..?

	=
https://lore.kernel.org/lkml/86A17A977688E04689F40F6B1EC20EC601940E06A9@AV=
MB1.qlogic.org/

Regards,
	Ren=C3=A9

>>> Can you please provide details of the commit which introduced this =
regression.
>>=20
>> See above, there was plenty of more reworks and code shuffling, and =
the quoted commit is also a condensed changes of other /14 series and =
other scsi work, =E2=80=A6
>>=20
>> Have a nice weekend,
>> 	Ren=C3=A9
>>=20
>>> Also when you
>>> resubmit this patch please use Fixes tag. See documentation here for =
the correct format.
>>>=20
>>> =
https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/gi=
t/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst__;!=
!GqivPVa7Brio!L6-irbVsNXqZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_=
n620C3iF$=20
>>>=20
>>>> Signed-off-by: Ren=C3=A9 Rebe <rene@exactcode.de>
>>>>=20
>>>> --- linux-5.8/drivers/scsi/qla2xxx/qla_init.c.vanilla	=
2020-08-21 09:55:18.600926737 +0200
>>>> +++ linux-5.8/drivers/scsi/qla2xxx/qla_init.c	2020-08-21 =
09:57:35.992926885 +0200
>>>> @@ -4603,18 +4603,18 @@
>>>> 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
>>>> 			nv->add_firmware_options[0] =3D BIT_5;
>>>> 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
>>>> -			nv->frame_payload_size =3D 2048;
>>>> +			nv->frame_payload_size =3D cpu_to_le16(2048);
>>>> 			nv->special_options[1] =3D BIT_7;
>>>> 		} else if (IS_QLA2200(ha)) {
>>>> 			nv->firmware_options[0] =3D BIT_2 | BIT_1;
>>>> 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
>>>> 			nv->add_firmware_options[0] =3D BIT_5;
>>>> 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
>>>> -			nv->frame_payload_size =3D 1024;
>>>> +			nv->frame_payload_size =3D cpu_to_le16(1024);
>>>> 		} else if (IS_QLA2100(ha)) {
>>>> 			nv->firmware_options[0] =3D BIT_3 | BIT_1;
>>>> 			nv->firmware_options[1] =3D BIT_5;
>>>> -			nv->frame_payload_size =3D 1024;
>>>> +			nv->frame_payload_size =3D cpu_to_le16(1024);
>>>> 		}
>>>>=20
>>>> 		nv->max_iocb_allocation =3D cpu_to_le16(256);
>>>>=20
>>>> --=20
>>>> Ren=C3=A9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 =
Berlin
>>>> =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!KU2euUg=
VJIRXqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxI-1EV4u$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!KU2euUgVJIR=
XqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxAAjd8CY$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!KU2euUgV=
JIRXqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxDUjMdad$=20
>>>=20
>>> --
>>> Himanshu Madhani	 Oracle Linux Engineering
>>>=20
>>=20
>> --=20
>> ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin, =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!L6-irbV=
sNXqZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_n-uIVWXr$=20
>> =
https://urldefense.com/v3/__https://exactscan.com__;!!GqivPVa7Brio!L6-irbV=
sNXqZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_n2dniKkK$  | =
https://urldefense.com/v3/__https://ocrkit.com__;!!GqivPVa7Brio!L6-irbVsNX=
qZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_n-v2wVJD$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!L6-irbVsNXq=
Zh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_n9g--eFu$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!L6-irbVs=
NXqZh_TSb_WyaBZ1S3Evo18GqWr8hX2Z-tNl3rZbWv0orEt7Igy_nxllUxx0$
>=20
> --
> Himanshu Madhani	 Oracle Linux Engineering
>=20

--=20
 ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin, =
https://exactcode.com
 https://exactscan.com | https://ocrkit.com | https://t2sde.org | =
https://rene.rebe.de

