From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH 3/7] [SCSI] scst: Add scst_local driver.
Date: Tue, 28 Dec 2010 14:07:16 -0800
Message-ID: <AANLkTi=jhs=7smgVrXL5179-RjrNmpQ0rUjMpOFTnJ29@mail.gmail.com>
References: <201012201849.03930.bvanassche@acm.org>
	<201012281351.20087.konrad@darnok.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61399 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0L1WHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2010 17:07:17 -0500
Received: by iyi12 with SMTP id 12so8441218iyi.19
        for <linux-scsi@vger.kernel.org>; Tue, 28 Dec 2010 14:07:17 -0800 (PST)
In-Reply-To: <201012281351.20087.konrad@darnok.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@suse.de

On Tue, Dec 28, 2010 at 10:51 AM, Konrad Rzeszutek Wilk
<konrad@darnok.org> wrote:
> On Monday 20
>> +#define TRUE 1
>> +#define FALSE 0
>
> can't you use 'true' or 'false'?

When I first wrote that I did not know if those symbols were
available. Probably better to change them now that I know it is.

> .. snip..
>> +static int scst_local_get_sas_transport_id(struct scst_local_sess *=
sess,
>> + =A0 =A0 uint8_t **transport_id, int *len)
>> +{
>> + =A0 =A0 int res =3D 0;
>> + =A0 =A0 int tr_id_size =3D 0;
>> + =A0 =A0 uint8_t *tr_id =3D NULL;
>> +
>> + =A0 =A0 tr_id_size =3D 24; =A0/* A SAS TransportID */
>> +
>> + =A0 =A0 tr_id =3D kzalloc(tr_id_size, GFP_KERNEL);
>> + =A0 =A0 if (tr_id =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 PRINT_ERROR("Allocation of TransportID (si=
ze %d) failed",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tr_id_size);
>
> pr_err? Or is this based on a module parameter?

PRINT_ERROR is an SCST macro ... will have to let Bart or Vlad answer t=
hat one.

>> + =A0 =A0 =A0 =A0 =A0 =A0 res =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 tr_id[0] =3D 0x00 | SCSI_TRANSPORTID_PROTOCOLID_SAS;
>
> Hmm, why the 0x00? Can't you just do an assigment?

Yes, that would be better.

Thanks for your feedback.

--=20
Regards,
Richard Sharpe
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
