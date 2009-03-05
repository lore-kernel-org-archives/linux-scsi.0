From: Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH v2 09/15] NULL noise: drivers/scsi/FlashPoint.c
Date: Thu, 5 Mar 2009 21:15:18 +0100
Message-ID: <154e089b0903051215q1216aa53icd41556e2af8b234@mail.gmail.com>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
	 <20090305191602.30062.71301.stgit@f10box.hanneseder.net>
	 <1236283546.5626.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:43381 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZCEUPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 15:15:22 -0500
In-Reply-To: <1236283546.5626.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Mar 5, 2009 at 9:05 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2009-03-05 at 20:16 +0100, Hannes Eder wrote:
>> Fix this sparse warnings:
>> =A0 drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as=
 NULL pointer
>> =A0 drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer a=
s NULL pointer
>> =A0 drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as=
 NULL pointer
>>
>> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>> ---
>> v2: fix checkpatch.pl issue.
>> v2.1: other subject, as suggested by Al Viro
>>
>> =A0drivers/scsi/FlashPoint.c | =A0 =A07 +++----
>> =A01 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
>> index b898d38..9eb2e86 100644
>> --- a/drivers/scsi/FlashPoint.c
>> +++ b/drivers/scsi/FlashPoint.c
>> @@ -903,8 +903,8 @@ static void FPT_autoCmdCmplt(unsigned long p_por=
t, unsigned char p_card);
>> =A0static void FPT_autoLoadDefaultMap(unsigned long p_port);
>>
>> =A0static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCS=
I_TAR] =3D
>> L- =A0 =A0{ {{0}} };
>> -static struct sccb_card FPT_BL_Card[MAX_CARDS] =3D { {0} };
>> + =A0 =A0{ { {NULL} } };
>> +static struct sccb_card FPT_BL_Card[MAX_CARDS] =3D { {NULL} };
>> =A0static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] =3D { {{0}} };
>> =A0static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] =3D { {0} };
>
> This doesn't look right: =A0{0} as a structure initialiser is a C
> convention for zero fill this structure; sparse should recognise this=
=2E
> Of course, since these structures are static, they should be in BSS
> anyway ...

So a proper fix is just not to initialize the variables.

=2E.. and report this issue to the sparse mailing list.

>
>> @@ -918,8 +918,7 @@ static unsigned char FPT_scamHAString[] =3D
>>
>> =A0static unsigned short FPT_default_intena =3D 0;
>>
>> -static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) =3D=
 {
>> -0};
>> +static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) =3D=
 {NULL};
>>
>> =A0/*---------------------------------------------------------------=
------
>> =A0 *

Same her, right?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
