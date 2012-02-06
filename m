From: Christian Hoff <christian.hoff@de.ibm.com>
Subject: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Mon, 6 Feb 2012 10:51:26 +0100
Message-ID: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:33371 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab2BFJvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2012 04:51:46 -0500
Received: from /spool/local
	by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <christian.hoff@de.ibm.com>;
	Mon, 6 Feb 2012 09:51:44 -0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pbonzini@redhat.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com, kvm@vger.kernel.org

Hello Paolo,

first let me say that your patch is working fine on my local clone of t=
he=20
qemu repository.

Let me ask just one question about the format of the data being=20
transmitted over the virtqueue.

Paolo Bonzini wrote:
+                cmd->req.cmd =3D (struct virtio_scsi_cmd_req){
+                                .lun[0] =3D 1,
+                                .lun[1] =3D sc->device->id,
+                                .lun[2] =3D (sc->device->lun >> 8) | 0=
x40,
+                                .lun[3] =3D sc->device->lun & 0xff,
+                               [...]
+                };

Can't we have seperate fields for the SCSI target ID and the LUN number=
=20
here? Putting all this into a single field seems confusing. The followi=
ng=20
line of code (sc->device->lun >> 8) | 0x40 essentially means that LUN=20
numbers will be limited to 8+6 Bits=3D14 Bits for no obvious reason tha=
t I=20
can see. Maybe we could just split the LUN field up into two uint32 fie=
lds=20
for target ID and LUN number?

Also, lun[1] =3D sc->device->id means that only 255 SCSI target IDs wil=
l be=20
supported. Think about bigger usage scenarios, such as FCP networks wit=
h=20
several hundred HBAs in the net. If you want to have the target ID<->HB=
A=20
mapping the same as on the guest as on the host, then 255 virtual targe=
t=20
IDs could be a limit.

Sorry for coming up so late with these suggestions. I hope there is sti=
ll=20
enough time left to discuss and address these problems.

Mit freundlichen Gr=FC=DFen / Kind regards

Christian Hoff

Student - Applied Computer Science


Phone:
49-16098976-950
 IBM Deutschland

E-Mail:
christian.hoff@de.ibm.com
 Am Fichtenberg 1


 71083 Herrenberg


 Germany


IBM Deutschland GmbH / Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Martina Koederitz (Vorsitzende), Reinhard Reschke=
,=20
Dieter Scholz, Gregor Pillen, Joachim Heel, Christian Noll
Sitz der Gesellschaft: Ehningen / Registergericht: Amtsgericht Stuttgar=
t,=20
HRB 14562 / WEEE-Reg.-Nr. DE 99369940=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
