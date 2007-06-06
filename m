From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] scsi: improve areca driver stability and compatibility
Date: Tue, 5 Jun 2007 20:31:25 -0700
Message-ID: <20070605203125.fb9c8f1d.randy.dunlap@oracle.com>
References: <000001c7a7e6$56efeef0$5e00a8c0@51091008491>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:13594 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbXFFDcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2007 23:32:14 -0400
In-Reply-To: <000001c7a7e6$56efeef0$5e00a8c0@51091008491>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Wed, 6 Jun 2007 10:56:52 +0800 nickcheng(=E9=84=AD=E5=AE=88=E8=AC=99=
) wrote:

> Subject: [PATCH] scsi: improve areca driver stability and compatibili=
ty
>    =20
> Description:
>     1. Implement PCI-Express error recovery function and AER capabili=
ty
>     2. Implement the selection of ARCMSR_MAX_XFER_SECTORS_B=3D4096 if=
 firmware version is latter than 1.42
>     3. Add arcmsr_done4_abort_postqueue in arcmsr_iop_reset function =
to improve the stability as hot-unplug/plug
>     4. Modify the ISR, arcmsr_interrupt routine, to prevent the incon=
sistency with sg_mod driver if application directly calls the arcmsr dr=
iver w/o passing through scsi midlayer specially thanks to Yanmin Zhang=
's openhanded help about AER


Hi,

1.  See my sig line (i.e., the file Documentation/SubmitChecklist and
the script scripts/checkpatch.pl, which flags 298 _possible_ problems
with the patch).

2.  Don't add trailing whitespace (spaces or tabs) (91 new patch lines
do this).

3.  In arcmsr_build_ccb(), there is a new BUG_ON().  Is this absolutely
necessary?  Is there any way to return an error at this point instead
of killing the entire system?

4.  Use a space after 'if', 'while', and 'for'.

5.  Use tabs to indent, not (8) spaces.

6.  Some of the switch blocks (especially the default: one in
arcmsr_pci_ers_need_reset_forepart()) have very bad indentation style
and hence are very unreadable.

7.  +	int i=3D0,found=3D0;=09

kernel style is:
	int i =3D 0, found =3D 0;
or:
	int i =3D 0;
	int found =3D 0;

8.  +	uint32_t flag_ccb,outbound_intstatus;

Need space after comma.

9.  +	while(((flag_ccb=3Dreadl(&reg->outbound_queueport)) !=3D 0xFFFFFF=
=46F) &&=20

Need space around =3D sign.

10.  Try to limit source lines to no more than 80 characters.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
