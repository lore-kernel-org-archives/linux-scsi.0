From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] replace skb_clone with skb_get in fcoe_start_io()
Date: Tue, 19 Oct 2010 23:02:31 +0800
Message-ID: <AANLkTimvE=ZaU_9WeWDyuAucBDw8paGaH0Hy5=G+u0M1@mail.gmail.com>
References: <AANLkTimWO2r=KX522JD6iQxxgjpX9XJ5-0CzeqJXv63b@mail.gmail.com>
	<7C88852EF6F99F4EB538472FCFEBE2220146C68540@orsmsx509.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54909 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0JSPCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 11:02:33 -0400
Received: by wwf26 with SMTP id 26so6613wwf.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Oct 2010 08:02:32 -0700 (PDT)
In-Reply-To: <7C88852EF6F99F4EB538472FCFEBE2220146C68540@orsmsx509.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Oct 19, 2010 at 3:04 AM, Zou, Yi <yi.zou@intel.com> wrote:
>>
>> There seems that skb_get could outlight skb_clone, if
>> retransmitting skb is the major concern.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/fcoe/fcoe.c =C2=A0 =C2=A0 =C2=A0 =C2=A02010-09-13=
 07:07:38.000000000 +0800
>> +++ b/drivers/scsi/fcoe/fcoe.c =C2=A0 =C2=A0 =C2=A0 =C2=A02010-10-17=
 20:03:08.000000000 +0800
>> @@ -1373,15 +1373,14 @@ err2:
>> =C2=A0 */
>> =C2=A0static inline int fcoe_start_io(struct sk_buff *skb)
>> =C2=A0{
>> - =C2=A0 =C2=A0 struct sk_buff *nskb;
>> =C2=A0 =C2=A0 =C2=A0 int rc;
>>
>> - =C2=A0 =C2=A0 nskb =3D skb_clone(skb, GFP_ATOMIC);
>> - =C2=A0 =C2=A0 rc =3D dev_queue_xmit(nskb);
>> - =C2=A0 =C2=A0 if (rc !=3D 0)
>> + =C2=A0 =C2=A0 skb_get(skb); /* bump ref count for retransmitting *=
/
>> + =C2=A0 =C2=A0 rc =3D dev_queue_xmit(skb);
>> + =C2=A0 =C2=A0 if (rc !=3D NET_XMIT_SUCCESS)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
>> =C2=A0 =C2=A0 =C2=A0 kfree_skb(skb);
>> - =C2=A0 =C2=A0 return 0;
>> + =C2=A0 =C2=A0 return NET_XMIT_SUCCESS;
>> =C2=A0}
>>
>> =C2=A0/**
>
> No, this was due to dev_queue_xmit not liking shared skb since
> __skb_linearize() would bug on, so we clone the skb here to be
> passed to dev_queue_xmit(), refer to the original commit id below
> for more details:
>

But the sg_supp related to hardware NIC seems already covered,
here is snippet from fc_fcp_send_data()

		if (!fp) {
			tlen =3D min(t_blen, remaining);

			/*
			 * TODO.  Temporary workaround.	 fc_seq_send() can't
			 * handle odd lengths in non-linear skbs.
			 * This will be the final fragment only.
			 */
			if (tlen % 4)
				using_sg =3D 0;
			fp =3D fc_frame_alloc(lport, using_sg ? 0 : tlen);
			if (!fp)
				return -ENOMEM;

			data =3D fc_frame_header_get(fp) + 1;
			fh_parm_offset =3D frame_offset;
			fr_max_payload(fp) =3D fsp->max_payload;
		}

and it seems little chance for hitting __skb_linearize.


> 18fa11efc279c20af5eefff2bbe814ca067e51ae
>
> Yi
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
