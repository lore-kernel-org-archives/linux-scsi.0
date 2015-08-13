From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] pm80xx: Added pm8006 controller support
Date: Thu, 13 Aug 2015 14:51:55 +0200
Message-ID: <CAMGffEkH7xz+zmdNvBR3WxOB=-VX4vd+sD_gx_C_6TCGLGNM=A@mail.gmail.com>
References: <1423722877-17436-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
 <CAD+HZHWRk06bJxEm8zsLPudGeJi96LMJxNd6STVKBF0k1=rphg@mail.gmail.com> <CE2C58F938F4C44EA74FFF880BAA7E5EC62EA719@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34033 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbbHMMwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 08:52:15 -0400
Received: by wicne3 with SMTP id ne3so258020674wic.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 05:52:14 -0700 (PDT)
In-Reply-To: <CE2C58F938F4C44EA74FFF880BAA7E5EC62EA719@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jej B <James.Bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Viswas G <Viswas.G@pmcs.com>, Jack Wang <xjtuwjp@gmail.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

Hi James,

Ping?

On Wed, Jul 29, 2015 at 11:33 AM, Suresh Thiagarajan
<Suresh.Thiagarajan@pmcs.com> wrote:
> Hi James,
>
> This patch is not pulled in yet.
>
> Regards,
> Suresh
>
> -----Original Message-----
> From: Jack Wang [mailto:xjtuwjp@gmail.com]
> Sent: Tuesday, February 24, 2015 2:07 PM
> To: Suresh Thiagarajan
> Cc: linux-scsi@vger.kernel.org; James Bottomley; Viswas G; pmchba@pmc=
s.com
> Subject: Re: [PATCH] pm80xx: Added pm8006 controller support
>
> Sorry for delay, I missed this patch.
>
> Acked-by: Jack Wang <xjtuwjp@gmail.com>
>
> 2015-02-12 7:34 GMT+01:00 Suresh Thiagarajan <Suresh.Thiagarajan@pmcs=
=2Ecom>:
>> Added the pm8006 controller id in pci table
>>
>> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
>> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
>> ---
>>  drivers/scsi/pm8001/pm8001_defs.h |    3 ++-
>>  drivers/scsi/pm8001/pm8001_init.c |    5 ++++-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_defs.h
>> b/drivers/scsi/pm8001/pm8001_defs.h
>> index 74a4bb9..dc4233b 100644
>> --- a/drivers/scsi/pm8001/pm8001_defs.h
>> +++ b/drivers/scsi/pm8001/pm8001_defs.h
>> @@ -49,7 +49,8 @@ enum chip_flavors {
>>         chip_8019,
>>         chip_8074,
>>         chip_8076,
>> -       chip_8077
>> +       chip_8077,
>> +       chip_8006,
>>  };
>>
>>  enum phy_speed {
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c
>> b/drivers/scsi/pm8001/pm8001_init.c
>> index 6555591..e1aee58 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -57,6 +57,7 @@ static const struct pm8001_chip_info pm8001_chips[=
] =3D {
>>         [chip_8074] =3D {0,  8, &pm8001_80xx_dispatch,},
>>         [chip_8076] =3D {0,  16, &pm8001_80xx_dispatch,},
>>         [chip_8077] =3D {0,  16, &pm8001_80xx_dispatch,},
>> +       [chip_8006] =3D {0,  16, &pm8001_80xx_dispatch,},
>>  };
>>  static int pm8001_id;
>>
>> @@ -1108,6 +1109,8 @@ err_out_enable:
>>   */
>>  static struct pci_device_id pm8001_pci_table[] =3D {
>>         { PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001 },
>> +       { PCI_VDEVICE(PMC_Sierra, 0x8006), chip_8006 },
>> +       { PCI_VDEVICE(ADAPTEC2, 0x8006), chip_8006 },
>>         { PCI_VDEVICE(ATTO, 0x0042), chip_8001 },
>>         /* Support for SPC/SPCv/SPCve controllers */
>>         { PCI_VDEVICE(ADAPTEC2, 0x8001), chip_8001 }, @@ -1218,7
>> +1221,7 @@ MODULE_AUTHOR("Anand Kumar Santhanam
>> <AnandKumar.Santhanam@pmcs.com>");
>>  MODULE_AUTHOR("Sangeetha Gnanasekaran
>> <Sangeetha.Gnanasekaran@pmcs.com>");
>>  MODULE_AUTHOR("Nikith Ganigarakoppal
>> <Nikith.Ganigarakoppal@pmcs.com>");
>>  MODULE_DESCRIPTION(
>> -               "PMC-Sierra PM8001/8081/8088/8089/8074/8076/8077 "
>> +               "PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/807=
7 "
>>                 "SAS/SATA controller driver");
>> MODULE_VERSION(DRV_VERSION);  MODULE_LICENSE("GPL");
>> --
>> 1.7.1
>>



--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang@profitbricks.com
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
