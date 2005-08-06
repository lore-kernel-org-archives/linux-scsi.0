From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: As of 2.6.13-rc1 Fusion-MPT very slow
Date: Sat, 06 Aug 2005 17:07:43 -0500
Message-ID: <1123366064.5102.3.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C035CB64A@nacos172.co.lsil.com>
	 <Pine.LNX.4.61.0508011537250.23481@praktifix.dwd.de>
	 <1123350790.5092.2.camel@mulgrave>
	 <Pine.LNX.4.61.0508062058200.27998@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62682 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261310AbVHFWID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Aug 2005 18:08:03 -0400
In-Reply-To: <Pine.LNX.4.61.0508062058200.27998@praktifix.dwd.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-08-06 at 21:12 +0000, Holger Kiehl wrote:
> I tried from 2.6.13-rc2-mm2 up to 2.6.13-rc4-mm1 and always get the f=
ollowing
> error when applying this patch:
>=20
>       CC      drivers/message/fusion/mptbase.o
>       CC      drivers/message/fusion/mptscsih.o
>       CC      drivers/message/fusion/mptspi.o
>     drivers/message/fusion/mptspi.c: In function =E2..mptspi_target_a=
lloc=E2..:
>     drivers/message/fusion/mptspi.c:113: error: invalid storage class=
 for function =E2..mptspi_write_offset=E2..
>     drivers/message/fusion/mptspi.c:114: error: invalid storage class=
 for function =E2..mptspi_write_width=E2..
>     drivers/message/fusion/mptspi.c:131: warning: implicit declaratio=
n of function =E2..mptspi_write_width=E2..
>     drivers/message/fusion/mptspi.c: At top level:
>     drivers/message/fusion/mptspi.c:453: warning: conflicting types f=
or =E2..mptspi_write_width=E2..
>     drivers/message/fusion/mptspi.c:453: error: static declaration of=
 =E2..mptspi_write_width=E2.. follows non-static declaration
>     drivers/message/fusion/mptspi.c:131: error: previous implicit dec=
laration of =E2..mptspi_write_width=E2.. was here

This lot are all gcc-4 being silly about a declaration, as you noticed.
Still, there's no reason not to make the static functions declared at
the top of the file.

>     drivers/message/fusion/mptspi.c:505: error: unknown field =E2..ge=
t_hold_mcs=E2.. specified in initializer
>     drivers/message/fusion/mptspi.c:505: warning: excess elements in =
struct initializer
>     drivers/message/fusion/mptspi.c:505: warning: (near initializatio=
n for =E2..mptspi_transport_functions=E2..)
>     drivers/message/fusion/mptspi.c:506: error: unknown field =E2..se=
t_hold_mcs=E2.. specified in initializer
>     drivers/message/fusion/mptspi.c:506: warning: excess elements in =
struct initializer
>     drivers/message/fusion/mptspi.c:506: warning: (near initializatio=
n for =E2..mptspi_transport_functions=E2..)
>     drivers/message/fusion/mptspi.c:507: error: unknown field =E2..sh=
ow_hold_mcs=E2.. specified in initializer
>     drivers/message/fusion/mptspi.c:507: warning: excess elements in =
struct initializer
>     drivers/message/fusion/mptspi.c:507: warning: (near initializatio=
n for =E2..mptspi_transport_functions=E2..)

This is actually because -mm is slightly behind the scsi-misc tree.  It
looks like the hold_mcs parameters haven't propagated into the -mm tree
yet.  You should be able to correct this by cutting these three lines:

	.get_hold_mcs	=3D mptspi_read_parameters,
	.set_hold_mcs	=3D mptspi_write_hold_mcs,
	.show_hold_mcs	=3D 1,

Out of the code at lines 505-507.  You'll get a warning about
mptspi_write_hold_mcs() being defined but not used which you can ignore=
=2E

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
