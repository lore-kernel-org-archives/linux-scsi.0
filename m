From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: ISCSI-SCST performance (with also IET and STGT data)
Date: Wed, 1 Apr 2009 22:14:24 +0200
Message-ID: <e2e108260904011314h1e0cf5c5wcdf210eee24d40d8@mail.gmail.com>
References: <49D10256.8030307@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57012 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbZDAUO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 16:14:28 -0400
In-Reply-To: <49D10256.8030307@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org

On Mon, Mar 30, 2009 at 7:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> w=
rote:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> I. SEQUENTIAL ACCESS OVER SINGLE LINE
>
> 1. # dd if=3D/dev/sdX of=3D/dev/null bs=3D512K count=3D2000
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ISCSI-SCST =A0 =A0 =A0=
IET =A0 =A0 =A0 =A0 =A0 =A0 STGT
> NULLIO: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 106 =A0 =A0 =A0 =A0 =A0 =A0 1=
05 =A0 =A0 =A0 =A0 =A0 =A0 103
> FILEIO/CFQ: =A0 =A0 =A0 =A0 =A0 =A0 82 =A0 =A0 =A0 =A0 =A0 =A0 =A057 =
=A0 =A0 =A0 =A0 =A0 =A0 =A055
> FILEIO/deadline =A0 =A0 =A0 =A0 69 =A0 =A0 =A0 =A0 =A0 =A0 =A069 =A0 =
=A0 =A0 =A0 =A0 =A0 =A067
> BLOCKIO/CFQ =A0 =A0 =A0 =A0 =A0 =A0 81 =A0 =A0 =A0 =A0 =A0 =A0 =A028 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0-
> BLOCKIO/deadline =A0 =A0 =A0 =A080 =A0 =A0 =A0 =A0 =A0 =A0 =A066 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0-

I have repeated some of these performance tests for iSCSI over IPoIB
(two DDR PCIe 1.0 ConnectX HCA's connected back to back). The results
for the buffered I/O test with a block size of 512K (initiator)
against a file of 1GB residing on a tmpfs filesystem on the target are
as follows:

write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.

And for a block size of 4 KB:

write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.

Or: depending on the test scenario, SCST transfers data between 2% and
30% faster via the iSCSI protocol over this network.

Something that is not relevant for this comparison, but interesting to
know: with the SRP implementation in SCST the maximal read throughput
is 1290 MB/s on the same setup.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
