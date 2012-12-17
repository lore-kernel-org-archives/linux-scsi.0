From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/5]  arcmsr: Support Hibernation
Date: Mon, 17 Dec 2012 10:48:49 +0000
Message-ID: <1355741329.2352.7.camel@dabdike.int.hansenpartnership.com>
References: <15E8252D644043B8A365C6FF2E94A993@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51269 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab2LQKsy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2012 05:48:54 -0500
In-Reply-To: <15E8252D644043B8A365C6FF2E94A993@arecaaebe11fae>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@kernel.org

On Tue, 2012-12-04 at 19:59 +0800, NickCheng wrote:
> From: Nick Cheng <nick.cheng@areca.com.tw>
>=20
> Support hibernation for whole series of RAID controllers

This doesn't compile:

  CC [M]  drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_hba.c: In function =E2=80=98arcmsr_iop_messa=
ge_xfer=E2=80=99:
drivers/scsi/arcmsr/arcmsr_hba.c:1871:36: error: =E2=80=98KM_IRQ0=E2=80=
=99 undeclared (first use in this function)
drivers/scsi/arcmsr/arcmsr_hba.c:1871:36: note: each undeclared identif=
ier is reported only once for each function it appears in
drivers/scsi/arcmsr/arcmsr_hba.c:1871:2: error: too many arguments to f=
unction =E2=80=98kmap_atomic=E2=80=99
In file included from include/linux/pagemap.h:10:0,
                 from include/linux/blkdev.h:13,
                 from include/scsi/scsi_cmnd.h:5,
                 from drivers/scsi/arcmsr/arcmsr_hba.c:67:
include/linux/highmem.h:66:21: note: declared here
drivers/scsi/arcmsr/arcmsr_hba.c:2127:44: error: macro "kunmap_atomic" =
passed 2 arguments, but takes just 1
drivers/scsi/arcmsr/arcmsr_hba.c:2127:2: error: =E2=80=98kunmap_atomic=E2=
=80=99 undeclared (first use in this function)
drivers/scsi/arcmsr/arcmsr_hba.c: In function =E2=80=98arcmsr_handle_vi=
rtual_command=E2=80=99:
drivers/scsi/arcmsr/arcmsr_hba.c:2180:37: error: =E2=80=98KM_IRQ0=E2=80=
=99 undeclared (first use in this function)
drivers/scsi/arcmsr/arcmsr_hba.c:2180:3: error: too many arguments to f=
unction =E2=80=98kmap_atomic=E2=80=99
In file included from include/linux/pagemap.h:10:0,
                 from include/linux/blkdev.h:13,
                 from include/scsi/scsi_cmnd.h:5,
                 from drivers/scsi/arcmsr/arcmsr_hba.c:67:
include/linux/highmem.h:66:21: note: declared here
drivers/scsi/arcmsr/arcmsr_hba.c:2184:45: error: macro "kunmap_atomic" =
passed 2 arguments, but takes just 1
drivers/scsi/arcmsr/arcmsr_hba.c:2184:3: error: =E2=80=98kunmap_atomic=E2=
=80=99 undeclared (first use in this function)
make[3]: *** [drivers/scsi/arcmsr/arcmsr_hba.o] Error 1

And that's because you're using an ancient form of kmap_atomic() which
was deprecated by

commit 3e4d3af501cccdc8a8cca41bdbe57d54ad7e7e73
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue Oct 26 14:21:51 2010 -0700

    mm: stack based kmap_atomic()

And actually made unsupported a year ago.  What are you compile testing
this against?

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
