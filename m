From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [RFC][RFT] scsi_scan.c cleanup/rewrite
Date: Thu, 20 Jun 2002 10:49:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8DE8DA9F.FE61DF6F-ONC1256BDE.002EB207@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12relay01.de.ibm.com (d12relay01.de.ibm.com [9.165.215.22])
	by d06lmsgate.uk.ibm.COM (1.0.0) with ESMTP id JAA50228
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2002 09:25:46 +0100
List-Id: linux-scsi@vger.kernel.org
To: patman@beaverton.ibm.com
Cc: linux-scsi@vger.kernel.org

Hi,

without having read the patch in detail, I think it's the a right idea
to make a rewrite. The old functions are too long, have too much
indentations,
are too complex, have too much parameters (remember scan_scsi_single),
and have not been designed to fit such requirements as support for repo=
rt
luns.

A suggestion:
In my opinion, such a patch would avail from a cleanup of the SCSI stac=
k
data structures which should be done in the first place. I would like t=
o
see
all those lists rethought and rewritten using list_heads and introducin=
g
some locks which are required to protect changes to these lists.


Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


patman@beaverton.ibm.com@vger.kernel.org on 06/20/2002 01:42:35 AM

Please respond to patman@beaverton.ibm.com

Sent by:    linux-scsi-owner@vger.kernel.org


To:    linux-scsi@vger.kernel.org
cc:
Subject:    [RFC][RFT] scsi_scan.c cleanup/rewrite



Hi -

I cleaned up scsi_scan.c, pretty much a rewrite of the code.

Any comments or flames?

Do you think the style changes moves us to far away from current
linux scsi style?

Should we keep the naming styles, such as SDpnt, SRpnt, SHpnt, etc?

The diffs are larger than the file itself, but let me know if I should
post the diffs. Changes were tested with 2.5.22 (the changes are also
compatible with 2.5.23, but I haven't tried running 2.5.23).

The only functional change (should be) adding support for BFLAGS_LARGEL=
UN,
it was defined before, but not used, otherwise it should be the complet=
e
functional equivalent of the current 2.5.x code.

I also removed the unused BFLAGS_NODISK.

I did not fully cleanup the device_list[] table initialization (not sur=
e
how to make that table ever look clean), plus James Bottomley was talki=
ng
about moving it into user space.

Tested with IBM 3542 (multi-LUN FC disk array) and SEAGATE ST118273 FC
drives on qla2200 and qla2300 with qla v6 beta drivers (modified for
2.5.x), both with and without REPORT LUN built into the kernel.

Plus, the boot disk is a IBM-PSG ST318203LC on an AIC Adaptec 7896.

If you have any of the odd-ball devices in device_list or any SCSI devi=
ces
currently working under 2.5.x, I would appreciate further testing of th=
e
code.

Thanks.

-- Patrick Mansfield





-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
