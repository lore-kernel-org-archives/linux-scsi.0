From: Christian Hoff <christian.hoff@de.ibm.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 7 Feb 2012 14:59:53 +0100
Message-ID: <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:54278 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab2BGOAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2012 09:00:06 -0500
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <christian.hoff@de.ibm.com>;
	Tue, 7 Feb 2012 14:00:04 -0000
In-Reply-To: <4F312492.1040002@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: BORNTRAE@linux.vnet.ibm.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, rusty@rustcorp.com.au

Hello Paolo,

On 07/02/12 13:31, Paolo Bonzini wrote:
> The structure of the LUN is defined by SAM, not by me.=20

Just had a look at the SAM LUN structure. It appears that you are using=
=20
the SCSI format for hierarchical LUNs(SAM 5 chapter 4.7.6) in order to=20
indicate that the LUN is actually attached to the host system and not t=
o=20
the Qemu guest operating system itself.

What I am wondering is why you are doing this? The hierarchical SCSI=20
format is only retained while the LUN number is being transmitted over =
the=20
virtqueue, so there does not seem to be a technical necessity for using=
=20
this format in order to transmit SCSI target ID and LUN number informat=
ion=20
to the host.

Instead the format has some disadvantages:
- It uses up 8 bytes where 3 bytes would be sufficient in order to stor=
e=20
both the target ID and LUN number information
- The format limits us to 255 target IDs. I agree that the LUN limit is=
=20
probably more a theoretical and not a practical one, but 255 target IDs=
=20
could become a limitation in the future.

Nonetheless I think that virtio-scsi is a useful project and addresses=20
many of the limitations imposed by virtio-block. The fact that I am sti=
ll=20
persisting has more to do with interest in the project rather than want=
ing=20
to keep the code from going upstream. Thank you for your work on this=20
topic.

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




=46rom:
BORNTRAE@linux.vnet.ibm.com
To:
Paolo Bonzini <pbonzini@redhat.com>
Cc:
Christian Hoff/Germany/IBM@IBMDE, linux-kernel@vger.kernel.org,=20
linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,=20
kvm@vger.kernel.org
Date:
07/02/2012 14:18
Subject:
Re: Pe: [PATCH v5 1/3] virtio-scsi: first version



On 07/02/12 13:31, Paolo Bonzini wrote:
> The structure of the LUN is defined by SAM, not by me.=20

Ok, got it.



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
