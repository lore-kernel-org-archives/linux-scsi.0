From: Anoob Soman <anoob.soman-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 1/1] libiscsi: Fix race between iscsi_xmit_task and
 iscsi_complete_task
Date: Tue, 17 Jul 2018 16:56:47 +0100
Message-ID: <41949f23-794e-60c8-ce0f-fcb170b1db39@citrix.com>
References: <1530543624-130587-1-git-send-email-anoob.soman@citrix.com>
 <5cc14ea6-2586-ce2b-f8c4-c46222280df7@citrix.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCLIFEWU6YHBBQ5DXDNAKGQETPLJGBY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <5cc14ea6-2586-ce2b-f8c4-c46222280df7-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: lduncan-IBi9RG/b67k@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 09/07/18 11:43, Anoob Soman wrote:
> On 02/07/18 16:00, Anoob Soman wrote:
>> ---
>> =C2=A0 drivers/scsi/libiscsi.c | 6 ++++++
>> =C2=A0 1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index d609383..aa3be6f 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -1449,7 +1449,13 @@ static int iscsi_xmit_task(struct iscsi_conn=20
>> *conn)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(ISCSI_SUSPEND_BIT, &conn->su=
spend_tx))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENODATA;
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 spin_lock_bh(&conn->session->back_lock);
>> +=C2=A0=C2=A0=C2=A0 if (conn->task =3D=3D NULL) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_bh(&conn->sessio=
n->back_lock);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENODATA;
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __iscsi_get_task(task);
>> +=C2=A0=C2=A0=C2=A0 spin_unlock_bh(&conn->session->back_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_bh(&conn->session->frwd_lock)=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D conn->session->tt->xmit_task(task)=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_bh(&conn->session->frwd_lock);
>
>
> Hi Chris, Lee.
>
> Could one of you look at this change and provide some comments ?
>
> Thanks,
>
> -Anoob.
>

Hi,

Can someone look at this change ?

Thanks,

Anoob.

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
