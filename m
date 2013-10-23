From: <Menny_Hamburger@Dell.com>
Subject: RE: BLKDISCARD and AIO
Date: Wed, 23 Oct 2013 10:21:55 +0100
Message-ID: <D8C50530D6022F40A817A35C40CC06A70CDEEC2EB2@DUBX7MCDUB01.EMEA.DELL.COM>
References: <201310221413.r9MEDQpK002617@bldi04p.dell-idc.com>
 <yq1r4bcfkeh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:33248 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3JWJWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 05:22:06 -0400
In-Reply-To: <yq1r4bcfkeh.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Dell - Internal Use - Confidential=20

Thanks,

The issue is that we run a single threaded process (we maintain our own=
 threads) and use eventfd to driver both networking and AIO, so blockin=
g on BLKDISCARD will block all IO done by the process.

Menny



-----Original Message-----
=46rom: Martin K. Petersen [mailto:martin.petersen@oracle.com]
Sent: Wednesday, October 23, 2013 11:43 AM
To: Hamburger, Menny
Cc: linux-scsi@vger.kernel.org
Subject: Re: BLKDISCARD and AIO=20
>>>>> "Menny" =3D=3D Menny Hamburger <Menny_Hamburger@Dell.com> writes:=
=20
Menny> I have a question regarding the use of BLKDISCARD ioctl in=20
Menny> userland code: Is there currently a way to hook up with an=20
Menny> asyncronous event that can be polled by userland when the=20
Menny> operation completes?
Not at this time, no.=20
However, you can fork a child process to execute the ioctl and wait for=
 that to complete.=20
--
Martin K. Petersen=A0=A0=A0=A0=A0 Oracle Linux Engineering=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
