From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: 11 Feb 2003 12:30:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044988215.1774.20.camel@mulgrave>
References: <200302041123.06204@bilbo.math.uni-mannheim.de>
	<200302070826.25941@bilbo.math.uni-mannheim.de>
	<1044676664.3564.107.camel@mulgrave>
	<200302111155.33075@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-8SMeWfGufzqsxDgQ0qEw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA02743
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 10:30:18 -0800
In-Reply-To: <200302111155.33075@bilbo.math.uni-mannheim.de>
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-8SMeWfGufzqsxDgQ0qEw
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2003-02-11 at 04:55, Rolf Eike Beer wrote:
> Am Samstag, 8. Februar 2003 04:57 schrieben Sie:
> > On Fri, 2003-02-07 at 01:26, Rolf Eike Beer wrote:
> > > That would be fine, you know your code better than I ever will.
> >
> > OK, the attached works for me for the 3430 MCA internal SCSI chip and an
> > HP EISA SCSI board.  Let me know how it works for the Compaq.
> 
> This is from my boot.msg:
> 
> <6>EISA bus registered
> <6>EISA: Probing bus...
> <6>EISA: Motherboard CPQ0601 detected
> <6>EISA: slot 2 : CPQ3011 detected.
> <6>EISA: slot 3 : CPQ6100 detected.
> <6>EISA: slot 7 : CPQ4411 detected.
> <6>EISA: slot 8 : CPQ4410 detected.
> <6>EISA: Detected 4 cards.
> 
> [...]
> 
> <5>IRQ_INDEX 249, 5
> <4>sim710: irq nasty
> 
> This is the Compaq NCR 53c710 on an EISA board, address 0x7000, IRQ 14 (and it 
> works fine with the original sim710).

Ah, OK, that's what I get for enabling something that was previously
disabled.  I suspected the disabled probe code had more than just the
IRQ coded into it.  It looks like only the three lower bits should be
used to determine the IRQ. I believe it will work if you apply this
patch.

James


--=-8SMeWfGufzqsxDgQ0qEw
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/sim710.c 1.8 vs edited =3D=3D=3D=3D=3D
--- 1.8/drivers/scsi/sim710.c	Sun Feb  9 10:07:34 2003
+++ edited/drivers/scsi/sim710.c	Tue Feb 11 12:28:55 2003
@@ -307,7 +307,7 @@
 #endif
 	} else {
 		eisa_irqs =3D eisa_cpq_irqs;
-		irq_index =3D inb(io_addr + 0xc88);
+		irq_index =3D inb(io_addr + 0xc88) & 0x07;
 	}
=20
 	if(irq_index >=3D strlen(eisa_irqs)) {

--=-8SMeWfGufzqsxDgQ0qEw--

