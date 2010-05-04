From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: sysfs: cannot create duplicate filename '/class/uas_host'
Date: Tue, 4 May 2010 20:17:27 +0530
Message-ID: <i2g3e7aae31005040747k79c61206r72743aa5dd09eccc@mail.gmail.com>
References: <h2m3e7aae31005030642t1014c3e5ke7edbab2a95775c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f189.google.com ([209.85.221.189]:50705 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab0EDOrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2010 10:47:35 -0400
Received: by qyk27 with SMTP id 27so8247714qyk.23
        for <linux-scsi@vger.kernel.org>; Tue, 04 May 2010 07:47:34 -0700 (PDT)
In-Reply-To: <h2m3e7aae31005030642t1014c3e5ke7edbab2a95775c1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, May 3, 2010 at 7:12 PM, Ramya Desai <ramya.desai@gmail.com> wro=
te:
> Dear Experts,
>
> When I attach two UAS devices to linux box, I got the following syste=
m
> trace when I use my driver. I used the following snippet for
> registering my device to the transport layer.
>
> static DECLARE_TRANSPORT_CLASS(uas_host_class,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"uas_host", NULL, NULL, NULL);
>
> error =3D transport_class_register(&uas_host_class);
>
> The transport_class_register() API fails and shows the following trac=
e
> when I connect the second device
>
> Here, I can declare the transport class with different names by
> changing the second parameter in the DECLARE_TRANSPORT_CLASS. However=
,
> is there any other way to handle this? Is there any way to declare
> unique name for each device?
>
> Any ideas greatly helpful.
>
> Thanks and Regards,
> Ramya.

Dear Experts,

I resolved the issue, after some research. The
transport_class_register() API is moved from PROBE method to INIT
module as it is NOT per device registration, but, it is per driver
registration. That is, for each driver, we need to register one time,
but not for each device insertion.

After moving the registration API call to INIT module, I am able to
work with TWO devices simultaneously.

Thanks and Regards,
Ramya.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
