From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] SCSI: fix unsafe operations related to sshdr in scsi_test_unit_ready()
Date: Sat, 18 Sep 2010 09:19:45 +0800
Message-ID: <AANLkTi=w5jHBy7-xKsa=HkSEaVDLJ6XWZrV9g9TgtvE_@mail.gmail.com>
References: <AANLkTinDmT5aVZ0PdozfGHE9tsqomaNfP0CGAcg6j=98@mail.gmail.com>
	<1284475625.20409.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48527 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab0IRBTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2010 21:19:46 -0400
Received: by wwb39 with SMTP id 39so1539114wwb.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2010 18:19:45 -0700 (PDT)
In-Reply-To: <1284475625.20409.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This is the recommended version in plain text, and thanks to FUJITA
for comment on issues related to DMA.
---

--- o/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c	2010-08-16
08:41:38.000000000 +0800
+++ m/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c	2010-09-18
09:17:36.000000000 +0800
@@ -1984,12 +1984,13 @@ scsi_test_unit_ready(struct scsi_device
 	char cmd[] =3D {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
-	struct scsi_sense_hdr *sshdr;
+	struct scsi_sense_hdr *sshdr, hdr;
 	int result;

-	if (!sshdr_external)
-		sshdr =3D kzalloc(sizeof(*sshdr), GFP_KERNEL);
-	else
+	if (!sshdr_external) {
+		sshdr =3D &hdr;
+		memset(sshdr, 0, sizeof(*sshdr));
+	} else
 		sshdr =3D sshdr_external;

 	/* try to eat the UNIT_ATTENTION if there are enough retries */
@@ -2002,18 +2003,12 @@ scsi_test_unit_ready(struct scsi_device
 	} while (scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key =3D=3D UNIT_ATTENTION && --retries);

-	if (!sshdr)
-		/* could not allocate sense buffer, so can't process it */
-		return result;
-
 	if (sdev->removable && scsi_sense_valid(sshdr) &&
 	    (sshdr->sense_key =3D=3D UNIT_ATTENTION ||
 	     sshdr->sense_key =3D=3D NOT_READY)) {
 		sdev->changed =3D 1;
 		result =3D 0;
 	}
-	if (!sshdr_external)
-		kfree(sshdr);
 	return result;
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);



On Tue, Sep 14, 2010 at 10:47 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Tue, 2010-09-14 at 21:26 +0800, Hillf Danton wrote:
>> The kzalloc for sshdr is replaced with sshdr struct on stack, then i=
t
>> looks safer.
>
> This premise is completely wrong. =C2=A0There are lots of times stack=
 can be
> wrong for driver code especially: DMA or aligment but for general cod=
e,
> since we went to 4k stacks we have very little space; a lot of arrays
> and structures got moved to kmalloc to reduce stack consumption.
>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>>
>> --- o/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c 2010-08-16
>> 08:41:38.000000000 +0800
>> +++ m/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c 2010-09-14
>> 21:03:34.000000000 +0800
>> @@ -1984,12 +1984,13 @@ scsi_test_unit_ready(struct scsi_device
>> =C2=A0 char cmd[] =3D {
>> =C2=A0 TEST_UNIT_READY, 0, 0, 0, 0, 0,
>> =C2=A0 };
>> - struct scsi_sense_hdr *sshdr;
>> + struct scsi_sense_hdr *sshdr, hdr;
>> =C2=A0 int result;
>>
>> - if (!sshdr_external)
>> - sshdr =3D kzalloc(sizeof(*sshdr), GFP_KERNEL);
>> - else
>> + if (!sshdr_external) {
>> + sshdr =3D &hdr;
>> + memset(sshdr,0,sizeof(*sshdr));
>> + } else
>
> And the patch is unapplyable: it looks like your mailer has elided al=
l
> the tabs and broken some of the lines. =C2=A0Please see
> Documentation/email-clients.txt for suggestions how to fix this.
>
> Finally, this didn't make it to linux-scsi because you sent it as an
> html message, which the list drops without comment ... you have to se=
nd
> text/plain only.
>
> James
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
