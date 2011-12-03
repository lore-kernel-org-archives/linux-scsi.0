From: Haogang Chen <haogangchen@gmail.com>
Subject: Re: [PATCH] SCSI: aacraid: potential integer overflow in aac_get_containers()
Date: Sat, 3 Dec 2011 14:30:57 -0500
Message-ID: <CAHrvArRoY5E+TX4Ciy2itiSX-Xq5Z+VvE9TYw+kSRR9wZE6rAA@mail.gmail.com>
References: <1322706601-26181-1-git-send-email-haogangchen@gmail.com>
	<FC1F9E38C0703341A1A750524E2525A9019791E6@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59928 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253Ab1LCTbA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Dec 2011 14:31:00 -0500
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9019791E6@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: aacraid@adaptec.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

No, maximum_num_containers is not bounded to MAXIMUM_NUM_CONTAINERS,
it coud be very large. If you look at the code carefully:

if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
        maximum_num_containers =3D MAXIMUM_NUM_CONTAINERS;

MAXIMUM_NUM_CONTAINERS (32) is actually the *minimal* value of
maximum_num_containers, though I'm not sure what's the underlying
logic of this check.


- Haogang



On Fri, Dec 2, 2011 at 11:03 AM, Mark Salyzyn
<mark_salyzyn@us.xyratex.com> wrote:
> NAK
>
> I dispute that it is necessary or worth the additional abstraction,
> since MAXIMUM_NUM_CONTAINERS is in the order of 32, and
> sizeof(*fsa_dev_ptr) is in the range of 80 bytes ... There is a LONG
> road to hoe to get to the point of overload!
>
> kcalloc -> __kmalloc(size_t, flags | __GFP_ZERO);
> kzalloc -> kmalloc(size_t, flags | __GFP_ZERO);
> kmalloc -> __kmalloc(size_t, flags);
>
> kcalloc can not allocate a larger entity than kzalloc. But alas it ca=
n
> report that the size has exceeded ULONG_MAX so that part of the patch=
 is
> VERY sound.
>
> Sincerely -- Mark Salyzyn
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Haogang Chen
> Sent: Wednesday, November 30, 2011 9:30 PM
> To: aacraid@adaptec.com
> Cc: JBottomley@parallels.com; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; haogangchen@gmail.com
> Subject: [PATCH] SCSI: aacraid: potential integer overflow in
> aac_get_containers()
>
> There is a potential integer overflow in aac_get_containers(). When
> maximum_num_containers is large, the subsequent call to kzalloc() wil=
l
> allocate a buffer smaller than expected, which leads to memory
> corruption in the for loop.
>
> The patch replaces kzalloc with kcalloc.
>
> Signed-off-by: Haogang Chen <haogangchen@gmail.com>
> ---
> =C2=A0drivers/scsi/aacraid/aachba.c | =C2=A0 =C2=A02 +-
> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/aachba.c
> b/drivers/scsi/aacraid/aachba.c
> index 409f580..440b84d 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -381,7 +381,7 @@ int aac_get_containers(struct aac_dev *dev)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (maximum_num_containers < MAXIMUM_NUM_C=
ONTAINERS)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0maximum_num_co=
ntainers =3D MAXIMUM_NUM_CONTAINERS;
> - =C2=A0 =C2=A0 =C2=A0 fsa_dev_ptr =3D kzalloc(sizeof(*fsa_dev_ptr) *
> maximum_num_containers,
> + =C2=A0 =C2=A0 =C2=A0 fsa_dev_ptr =3D kcalloc(maximum_num_containers=
,
> sizeof(*fsa_dev_ptr),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0GFP_KERNEL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!fsa_dev_ptr)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM=
;
> --
> 1.7.5.4
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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
