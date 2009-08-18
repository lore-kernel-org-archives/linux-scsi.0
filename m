From: Madhavi Manchala <madhavi.lscsi@gmail.com>
Subject: Re: Bidirectional data transfers from SCSI layer
Date: Tue, 18 Aug 2009 14:33:24 +0530
Message-ID: <97a757510908180203h7c10c63fx19f436e72de25c5@mail.gmail.com>
References: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>
	 <4A8A608D.9000909@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:29149 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZHRJDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 05:03:23 -0400
Received: by wa-out-1112.google.com with SMTP id j5so606756wah.21
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2009 02:03:24 -0700 (PDT)
In-Reply-To: <4A8A608D.9000909@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 18, 2009 at 1:34 PM, Boaz Harrosh<bharrosh@panasas.com> wro=
te:

Dear Boaz,

Thanks for the information.

> drivers/scsi/osd/osd_initiator.c

I did not find this file in my 2.6.28 sources.

> On the scsi-driver side you do:
>
> =A0 =A0 =A0 =A0if (scsi_bidi_cmnd(cmnd)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in_sgl =3D scsi_in(cmnd)->table.sgl;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in_nents =3D scsi_in(cmnd)->table.nent=
s;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in_bytes =3D scsi_in(cmnd)->length;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Same thing for out */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0out_sgl =3D scsi_out(cmnd)->table.sgl;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0...
> =A0 =A0 =A0 =A0}

Do I need to modify the SCSI driver files to handle  the
bi-directional comamnds or Is this already supported?

> What type of scsi-device are you using?

I am working for USB Attached SCSI (UAS) device which supports
bi-directional commands. I'm modifying USB Mass storage driver
according to UAS requirements. Whenever there is command to process,
SCSI layer sends scsi_cmnd structure pointer to UAS class driver (my
driver - modified mass storage driver). But I did not find two data
pointers and two data length variables (one IN and one OUT) in this
structure to handle bi-directional data.

I found only one struct scsi_data_buffer pointer in scsi_cmnd
structure. So, how do SCSI layer sends IN and OUT buffer pointers and
their lengths to my class driver?

> what bidi commands?

I did not understand this. Could you please elaborate it? Are there
any bidi commands like READ_10 or WRITE_10 which are specific to any
device?

Thanks and Regards,
Madhavi M.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
