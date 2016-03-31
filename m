From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: Patch: Make the iscsi lld create a WQ_HIGHPRI workqueue itself
Date: Thu, 31 Mar 2016 09:46:51 -0700
Message-ID: <CACyXjPx=0hYnc2NwYi_6xAC2t6qG70EcT3S5QefHV3_iigqQzQ@mail.gmail.com>
References: <CACyXjPxwz4znmt7g9ptYdpzkfF1Ok7KKJa2ceyKxg00buSfmcA@mail.gmail.com>
	<56F9C3ED.8080704@redhat.com>
	<CACyXjPzkQowe3Fu3S63kBrNuf3J5ewX67+uVXY5KRj_RapK5Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:34783 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbcCaQqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 12:46:52 -0400
Received: by mail-yw0-f172.google.com with SMTP id h129so104687336ywb.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 09:46:52 -0700 (PDT)
In-Reply-To: <CACyXjPzkQowe3Fu3S63kBrNuf3J5ewX67+uVXY5KRj_RapK5Kw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Mar 30, 2016 at 9:04 AM, Richard Sharpe
<realrichardsharpe@gmail.com> wrote:
> On Mon, Mar 28, 2016 at 4:53 PM, Mike Christie <mchristi@redhat.com> =
wrote:
>> On 03/28/2016 03:46 PM, Richard Sharpe wrote:
>>> Hi folks,
>>>
>>> We noticed recently while testing with large numbers of iSCSI
>>> connections that iscsid was going to heroic lengths to change the n=
ice
>>> value of the iSCSI work queue to -20. It becomes very expensive wit=
h
>>> hundreds of connections.
>>>
>>> This small patch has the LLD do the work,
>>>
>>> Feedback welcome.
>
> [...]
>
>>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>>> index 6bffd91..abaefe1 100644
>>> --- a/drivers/scsi/libiscsi.c
>>> +++ b/drivers/scsi/libiscsi.c
>>> @@ -2615,9 +2615,11 @@ struct Scsi_Host *iscsi_host_alloc(struct sc=
si_host_template *sht,
>>>       ihost =3D shost_priv(shost);
>>>
>>>       if (xmit_can_sleep) {
>>> +             int wq_flags =3D __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_HI=
GHPRI;
>>
>>
>> I do not think we need to or are supposed to be setting __WQ_LEGACY.=
 It
>> looks like it was only to catch the case here
>
> Attached is a patch the removes that flag and also WQ_MEM_RECLAIM
> because none of the work items placed on the queue do allocations wit=
h
> GPF_KERNEL, as far as I can tell.

It turns out that my second patch is also wrong because we do need
WQ_MEM_RECLAIM on the workqueue.

However, the fact that no one has noticed this problem for a long time
(probably since the workqueue model was changed) suggests that it does
not matter that the iSCSI workqueue is not WG_HIGHPRI.

Internally, we are doing some measurements to see if it makes any diffe=
rence.

I will report back with the results, probably in a few days.

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
