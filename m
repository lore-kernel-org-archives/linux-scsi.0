From: "S, Venkatraman" <svenkatr@ti.com>
Subject: Re: [PATCH RESEND 2/2] scsi/ufs: Fix evaluation of task_failed status
Date: Thu, 19 Apr 2012 11:39:45 +0530
Message-ID: <CANfBPZ_dvYxDMiV=c5RH7TSe8P6TUNKv5T7sEJvPGa4hdEXtHA@mail.gmail.com>
References: <1334734733-13640-1-git-send-email-svenkatr@ti.com> <20120418155643.5b6eff01.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:59462 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242Ab2DSGKH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Apr 2012 02:10:07 -0400
Received: by vbbfq11 with SMTP id fq11so6428272vbb.30
        for <linux-scsi@vger.kernel.org>; Wed, 18 Apr 2012 23:10:05 -0700 (PDT)
In-Reply-To: <20120418155643.5b6eff01.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, santoshsy@gmail.com, linkinjeon@gmail.com, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Thu, Apr 19, 2012 at 4:26 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Please cc James and linux-scsi on drivers/scsi patches?
>
> On Wed, 18 Apr 2012 13:08:53 +0530
> Venkatraman S <svenkatr@ti.com> wrote:
>
>> Else FAILED would be set even if task_result was
>> originally equal to UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED.
>
> This changelog is inadequate. =A0It failed to describe the end-user
> impact of the bug. =A0Without this information we cannot decide which
> kernel version(s) should be patched. =A0Please always fully describe =
a
> bug when fixing it.
>
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1160,7 +1160,7 @@ static int ufshcd_task_req_compl(struct ufs_hb=
a *hba, u32 index)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_result =3D be32_to_cpu(task_rsp_upi=
up->header.dword_1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_result =3D ((task_result & MASK_TAS=
K_RESPONSE) >> 8);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (task_result !=3D UPIU_TASK_MANAGEMENT_=
=46UNC_COMPL ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (task_result !=3D UPIU_TASK_MANAGEMENT_=
=46UNC_COMPL &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_result !=3D UPIU_TASK_MANAG=
EMENT_FUNC_SUCCEEDED)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_result =3D FAILED;
>> =A0 =A0 =A0 } else {
>
> And the title of the patch is poor. =A0There is no "task_failed" here=
=2E
> Something like "fix evaluation of task completion code" would be
> better?

Ok. I will send an updated version of the patch.
Regards,
Venkat.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
