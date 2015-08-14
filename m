From: Konstantin Krotov <kkv@clodo.ru>
Subject: Re: threads scsi_eh_ and scsi_tmf_ don't die when ib_srp reconnect
Date: Fri, 14 Aug 2015 12:06:05 +0300
Message-ID: <55CDAF7D.3050301@clodo.ru>
References: <55C8C0DC.7070505@clodo.ru> <55C8C39B.1010000@sandisk.com> <55C9FB62.1030004@clodo.ru> <55CA5AD4.8080109@sandisk.com> <55CAD674.4040104@clodo.ru> <55CB796D.3030709@sandisk.com>
Reply-To: kkv@clodo.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33042 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbbHNJGL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2015 05:06:11 -0400
Received: by lalv9 with SMTP id v9so40265083lal.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2015 02:06:09 -0700 (PDT)
In-Reply-To: <55CB796D.3030709@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



12.08.2015 19:50, Bart Van Assche =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 08/11/2015 10:15 PM, Konstantin Krotov wrote:
>> 11.08.2015 23:28, Bart Van Assche =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>> Are you using a kernel from Greg KH's stable repository or another =
kernel ? And to which values were the
>> yes, sources from upstream, 3.19.1
>
> Hello Konstantin,
>
> Can you test the patch below ? That patch not only applies to the v4.=
2-rc6
> kernel but also to the ib_srp-backport driver.
>
> Thanks,
>
> Bart.
>
> Subject: [PATCH] IB/srp: Stop the scsi_eh_<n> and scsi_tmf_<n> thread=
s if login fails
>
> scsi_host_alloc() not only allocates memory for a SCSI host but also
> creates the scsi_eh_<n> kernel thread and the scsi_tmf_<n> workqueue.
> Stop these threads if login fails by calling scsi_host_put().
>
> Reported-by: Konstantin Krotov <kkv@clodo.ru>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: stable <stable@vger.kernel.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index f962267..b5f9456 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2765,6 +2765,13 @@ static int srp_sdev_count(struct Scsi_Host *ho=
st)
>   	return c;
>   }
>
> +/*
> + * Return values:
> + * < 0 upon failure. Caller is responsible for SRP target port clean=
up.
> + * 0 and target->state =3D=3D SRP_TARGET_REMOVED if the target port =
will be removed
> + *    asynchronously.
> + * 0 and target->state !=3D SRP_TARGET_REMOVED upon success.
> + */
>   static int srp_add_target(struct srp_host *host, struct srp_target_=
port *target)
>   {
>   	struct srp_rport_identifiers ids;
> @@ -3316,6 +3323,7 @@ err_disconnect:
>   	}
>
>   	kfree(target->ch);
> +	scsi_host_put(target->scsi_host);
>   	goto out;
>   }
>
>
Hello Bart

I tested the patch, the problem is not reproduced.

Thanks.

--=20
WBR
Konstantin V. Krotov

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
