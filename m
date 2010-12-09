From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] add stats info for FC rports
Date: Thu, 9 Dec 2010 22:18:20 +0800
Message-ID: <AANLkTikWJ-M53Qvd+bM9_xZ11it=gz3p5qVQN037fGT_@mail.gmail.com>
References: <AANLkTi=mwHmJwNwCqJXxGXsfyULpnTX0t7rOq3eV9YOF@mail.gmail.com>
	<4D000183.9050804@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44996 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab0LIOSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 09:18:21 -0500
Received: by wwa36 with SMTP id 36so2510071wwa.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Dec 2010 06:18:20 -0800 (PST)
In-Reply-To: <4D000183.9050804@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Thu, Dec 9, 2010 at 6:06 AM, Joe Eykholt <jeykholt@cisco.com> wrote:
>
>
> On 12/8/10 5:27 AM, Hillf Danton wrote:
>> Stats info is added, in the define of local port, to monitor the usa=
ge
>> of remote ports.
>>
>> Then it is simple to answer how many rport data leaked in the life
>> cycle of lport.
>>
>> This work is motivated to capture mm leak of rports of
>> FC_FID_DIR_SERV, and thanks for dropping a reply to this message if
>> captured.
>
> This sounds like code that could be done locally and then
> tossed out once the leak is found. =C2=A0Also, there is already a lis=
t
> of remote ports, I think, so the count is redundant info.

It is fine to read your comments, Joe, in winter evening.

Though the list is defined, rport of FC_FID_DIR_SERV is not added
onto it, at least when created, which is hard to trace then.

And FC_FID_DIR_SERV is the major concern of this work.
If captured, fix should have been delivered.

>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/include/scsi/libfc.h =C2=A0 =C2=A02010-11-01 19:54:12.00000000=
0 +0800
>> +++ b/include/scsi/libfc.h =C2=A0 =C2=A02010-12-08 21:05:46.00000000=
0 +0800
>> @@ -803,6 +803,9 @@ struct fc_lport {
>> =C2=A0 =C2=A0 =C2=A0 void =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *scsi_priv;
>> =C2=A0 =C2=A0 =C2=A0 struct fc_disc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 disc;
>>
>> + =C2=A0 =C2=A0 /* stats info of the usage of rports */
>> + =C2=A0 =C2=A0 unsigned long =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 nr_rdata;
>> +
>> =C2=A0 =C2=A0 =C2=A0 /* Virtual port information */
>> =C2=A0 =C2=A0 =C2=A0 struct list_head =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 vports;
>> =C2=A0 =C2=A0 =C2=A0 struct fc_vport =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0*vport;
>> --- a/drivers/scsi/libfc/fc_rport.c =C2=A0 2010-11-01 19:54:12.00000=
0000 +0800
>> +++ b/drivers/scsi/libfc/fc_rport.c =C2=A0 2010-12-08 21:16:40.00000=
0000 +0800
>> @@ -128,7 +128,7 @@ static struct fc_rport_priv *fc_rport_cr
>> =C2=A0 =C2=A0 =C2=A0 rdata =3D kzalloc(sizeof(*rdata) + lport->rport=
_priv_size, GFP_KERNEL);
>> =C2=A0 =C2=A0 =C2=A0 if (!rdata)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
>> -
>> + =C2=A0 =C2=A0 lport->nr_rdata++;
>> =C2=A0 =C2=A0 =C2=A0 rdata->ids.node_name =3D -1;
>> =C2=A0 =C2=A0 =C2=A0 rdata->ids.port_name =3D -1;
>> =C2=A0 =C2=A0 =C2=A0 rdata->ids.port_id =3D port_id;
>> @@ -159,6 +159,7 @@ static void fc_rport_free_rcu(struct rcu
>> =C2=A0 =C2=A0 =C2=A0 struct fc_rport_priv *rdata;
>>
>> =C2=A0 =C2=A0 =C2=A0 rdata =3D container_of(rcu, struct fc_rport_pri=
v, rcu);
>> + =C2=A0 =C2=A0 rdata->local_port->nr_rdata--;
>
> What about locking? =C2=A0I don't think you should do this in the rcu

Locking here looks unnecessary, since lport could not goto Mars.
If could, lot of orphans have to stay on Earth with no more care.

> callback because the local port may no longer exist. Instead, I
> would do it in fc_rport_destroy.
>
>> =C2=A0 =C2=A0 =C2=A0 kfree(rdata);
>> =C2=A0}
>>
>> @@ -1880,7 +1881,7 @@ int fc_rport_init(struct fc_lport *lport
>>
>> =C2=A0 =C2=A0 =C2=A0 if (!lport->tt.rport_destroy)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lport->tt.rport_des=
troy =3D fc_rport_destroy;
>> -
>> + =C2=A0 =C2=A0 lport->nr_rdata =3D 0;
>
> Everything in the lport starts as zero, so no need to insert this exp=
licitly.

When initing lport, clarity could be redundant.

>
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>> =C2=A0}
>> =C2=A0EXPORT_SYMBOL(fc_rport_init);
>> --- a/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 2010-11-01 19:54:12.=
000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 2010-12-08 21:19:20.=
000000000 +0800
>> @@ -2184,6 +2184,11 @@ void fc_fcp_destroy(struct fc_lport *lpo
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 struct fc_fcp_internal *si =3D fc_get_scsi_inte=
rnal(lport);
>>
>> + =C2=A0 =C2=A0 if (lport->nr_rdata !=3D 0)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_WARNING "lib=
fc: %lu Leaked rports when "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "destroying local port (%6.6x)\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 lport->nr_rdata, lport->port_id);
>> +
>
> The equivalent of this check should go into fc_rport.c, not here.

When destroying lport, it is the right place to report leakage.

Cheers
Hillf

>
>> =C2=A0 =C2=A0 =C2=A0 if (!list_empty(&si->scsi_pkt_queue))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_ERR "li=
bfc: Leaked SCSI packets when destroying "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0"port (%6.6x)\n", lport->port_id);
>> _______________________________________________
>> devel mailing list
>> devel@open-fcoe.org
>> http://www.open-fcoe.org/mailman/listinfo/devel
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
