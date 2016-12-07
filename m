From: Zhouyi Zhou <zhouzhouyi@gmail.com>
Subject: Re: [PATCH 1/1] scsi: fcoe: return value of skb_linearize should be handled
Date: Wed, 7 Dec 2016 16:33:29 +0800
Message-ID: <CAABZP2wJAmN-cpX4x0__284=3-Yos=DHpsD7=hR+crEK8gXOSQ@mail.gmail.com>
References: <1481097600-25604-1-git-send-email-zhouzhouyi@gmail.com> <20161207082801.GA3688@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161207082801.GA3688@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>, Chad Dupuis <chad.dupuis@cavium.com>
List-Id: linux-scsi@vger.kernel.org

Thanks Johannes for reviewing, your code is indeeded more elegant

On Wed, Dec 7, 2016 at 4:28 PM, Johannes Thumshirn <jthumshirn@suse.de> wro=
te:
> Hi Zhouyi,
> On Wed, Dec 07, 2016 at 04:00:00PM +0800, Zhouyi Zhou wrote:
>> Return value of skb_linearize should be handled.
>>
>> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
>> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
>> ---
>>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 6 ++++--
>>  drivers/scsi/fcoe/fcoe.c          | 5 ++++-
>>  2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx=
2fc_fcoe.c
>> index f9ddb61..142f7e2 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> @@ -542,8 +542,10 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
>>               return;
>>       }
>>
>> -     if (skb_is_nonlinear(skb))
>> -             skb_linearize(skb);
>> +     if (skb_linearize(skb)) {
>> +             kfree_skb(skb);
>> +             return;
>> +     }
>>       mac =3D eth_hdr(skb)->h_source;
>>       dest_mac =3D eth_hdr(skb)->h_dest;
>>
>> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
>> index 9bd41a3..4e3499c 100644
>> --- a/drivers/scsi/fcoe/fcoe.c
>> +++ b/drivers/scsi/fcoe/fcoe.c
>> @@ -1685,7 +1685,10 @@ static void fcoe_recv_frame(struct sk_buff *skb)
>>                       skb->dev ? skb->dev->name : "<NULL>");
>>
>>       port =3D lport_priv(lport);
>> -     skb_linearize(skb); /* check for skb_is_nonlinear is within skb_li=
nearize */
>> +     if (skb_linearize(skb)) {
>> +             kfree_skb(skb);
>> +             return;
>> +     }
>>
>>       /*
>>        * Frame length checks and setting up the header pointers
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> I'd personally prefer something like:
>
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 9bd41a3..bc6fa6c 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1673,8 +1673,7 @@ static void fcoe_recv_frame(struct sk_buff *skb)
>         lport =3D fr->fr_dev;
>         if (unlikely(!lport)) {
>                 FCOE_NETDEV_DBG(skb->dev, "NULL lport in skb\n");
> -               kfree_skb(skb);
> -               return;
> +               goto free_skb;
>         }
>
>         FCOE_NETDEV_DBG(skb->dev,
> @@ -1685,8 +1684,8 @@ static void fcoe_recv_frame(struct sk_buff *skb)
>                         skb->dev ? skb->dev->name : "<NULL>");
>
>         port =3D lport_priv(lport);
> -       skb_linearize(skb); /* check for skb_is_nonlinear is within skb_l=
inearize */
> -
> +       if (skb_linearize(skb))
> +               goto free_skb;
>         /*
>          * Frame length checks and setting up the header pointers
>          * was done in fcoe_rcv already.
> @@ -1732,6 +1731,7 @@ static void fcoe_recv_frame(struct sk_buff *skb)
>  drop:
>         stats->ErrorFrames++;
>         put_cpu();
> +free_skb:
>         kfree_skb(skb);
>  }
>
>
> For bnx2fc as well if Chad agrees.
>
> Thanks,
>         Johannes
>
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
Thanks
Zhouyi
