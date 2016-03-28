From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: Patch: Make the iscsi lld create a WQ_HIGHPRI workqueue itself
Date: Mon, 28 Mar 2016 16:58:54 -0700
Message-ID: <CACyXjPxtMAHJ_XpVVpbD6R5fP+B5E+BT1VSu+Dq3tCCaWdfpsA@mail.gmail.com>
References: <CACyXjPxwz4znmt7g9ptYdpzkfF1Ok7KKJa2ceyKxg00buSfmcA@mail.gmail.com>
	<56F9C3ED.8080704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:33263 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbcC1X6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2016 19:58:55 -0400
Received: by mail-yw0-f176.google.com with SMTP id h65so102355258ywe.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2016 16:58:55 -0700 (PDT)
In-Reply-To: <56F9C3ED.8080704@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Mar 28, 2016 at 4:53 PM, Mike Christie <mchristi@redhat.com> wr=
ote:
> On 03/28/2016 03:46 PM, Richard Sharpe wrote:
>> Hi folks,
>>
>> We noticed recently while testing with large numbers of iSCSI
>> connections that iscsid was going to heroic lengths to change the ni=
ce
>> value of the iSCSI work queue to -20. It becomes very expensive with
>> hundreds of connections.
>>
>> This small patch has the LLD do the work,
>>
>> Feedback welcome.
>>
>> A small patch will be needed for the user-space tools as well. I wil=
l
>> send one in if someone else does not do so.
>>
>> -- Regards, Richard Sharpe (=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=
=9F=E5=94=AF=E6=9C=89=E6=9D=9C=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
>>
>>
>> 0001-Make-the-iscsi-lld-create-a-WQ_HIGHPRI-workqueue.patch
>>
>>
>> From c0f04a66b29a9190109740c03ee9e65bb62afe28 Mon Sep 17 00:00:00 20=
01
>> From: Richard Sharpe <rsharpe@nutanix.com>
>> Date: Mon, 28 Mar 2016 13:36:18 -0700
>> Subject: [PATCH] Make the iscsi lld create a WQ_HIGHPRI workqueue.
>>
>> The open-iscsi tools go to heroic efforts to change the nice value o=
f
>> the iscsi workqueue to -20. It scans all processes in /proc and
>> when it finds the one it is interested in calls setpriority.
>>
>> When you are connecting to a reasonable number of iSCSI targets this
>> can be costly.
>>
>> This small patch has the iscsi LLD do the work itself. It seems like
>> the least intrusive way to acheive the result.
>>
>> A small patch will be needed in the open-iscsi userspace tools
>> as well.
>>
>> Signed-off-by: Richard Sharpe <realrichardsharpe@gmail.com>
>> ---
>>  drivers/scsi/libiscsi.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 6bffd91..abaefe1 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -2615,9 +2615,11 @@ struct Scsi_Host *iscsi_host_alloc(struct scs=
i_host_template *sht,
>>       ihost =3D shost_priv(shost);
>>
>>       if (xmit_can_sleep) {
>> +             int wq_flags =3D __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_HIG=
HPRI;
>
>
> I do not think we need to or are supposed to be setting __WQ_LEGACY. =
It
> looks like it was only to catch the case here

OK, I will fix that and resubmit.

> https://lkml.org/lkml/2016/1/29/179
>
>
>
>>               snprintf(ihost->workq_name, sizeof(ihost->workq_name),
>>                       "iscsi_q_%d", shost->host_no);
>> -             ihost->workq =3D create_singlethread_workqueue(ihost->=
workq_name);
>> +             ihost->workq =3D alloc_ordered_workqueue("%s", wq_flag=
s,
>> +                                             ihost->workq_name);
>>               if (!ihost->workq)
>>                       goto free_host;
>>       }
>> --
>



--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
