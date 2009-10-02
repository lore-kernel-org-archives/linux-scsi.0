From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [RFC][PATCH v2]Add pm8001 SAS/SATA HBA driver
Date: Fri, 02 Oct 2009 21:15:56 +0000
Message-ID: <1254518156.3874.139.camel@mulgrave.site>
References: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn>
	 <200909150807.36222.eike-kernel@sf-tec.de>
	 <4E716EE5A6E14CBEB7C6A982E2347934@usish.com.cn>
	 <1253826242.5183.178.camel@mulgrave.site>
	 <08BF47025E834582AAA7FE0AE45FE2D3@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbZJBVQC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2009 17:16:02 -0400
In-Reply-To: <08BF47025E834582AAA7FE0AE45FE2D3@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lindar_liu <lindar_liu@usish.com>
Cc: 'jack wang' <jack_wang@usish.com>, 'Rolf Eike Beer' <eike-kernel@sf-tec.de>, matthew@wil.cx, linux-scsi@vger.kernel.org, tom_peng@usish.com, 'aoqingy' <aoqingyun@usish.com>, roy_wang@usish.com

On Mon, 2009-09-28 at 09:41 +0800, lindar_liu wrote:
> On Wed, 2009-09-16 at 11:27 +0800, jack wang wrote:
> > Here is an update of our driver patch that incorporates the latest review
> > inputs from Eike.
> 
> I'm afraid this driver has a slightly more serious issue:  it uses
> virt_to_bus() and therefore won't compile on a lot of non-x86 systems:
> 
> pm8001_hwi.c:           phys_addr = cpu_to_le64(virt_to_bus((void
> *)(ccb->buf_pr
> pm8001_hwi.c:           phys_addr = cpu_to_le64(virt_to_bus((void
> *)(ccb->buf_pr
> 
> It' looks like MEM_CCB already has the physical address of this region,
> so you don't need to use virt_to_bus, you can just compute the offset
> from the MEM_CCB virt address and add the phys address.
> 
> James
> [lindar] Thanks James, we have fixed it as your suggestion. Attachment is an
> update of our driver patch.
> Thanks.

It's heading in the right direction, but it doesn't actually compile:

drivers/scsi/pm8001/pm8001_hwi.c: In function 'pm8001_chip_ssp_io_req':
drivers/scsi/pm8001/pm8001_hwi.c:3647: error: 'struct pm8001_ccb_info' has no member named 'ccb_dma_handle'
drivers/scsi/pm8001/pm8001_hwi.c: In function 'pm8001_chip_sata_req':
drivers/scsi/pm8001/pm8001_hwi.c:3716: error: 'struct pm8001_ccb_info' has no member named 'ccb_dma_handle'

It looks like some of the files in the diff are from the old version and
some from the new one.

Plus you've now picked up this conflict from the addition of the new
SCSI commands READ_32 and WRITE_32 which went in with the DIF/DIX type 2
work:

drivers/scsi/pm8001/pm8001_chips.h:44:1: warning: "READ_32" redefined
In file included from include/scsi/scsi_host.h:9,
                 from include/linux/libata.h:37,
                 from include/scsi/libsas.h:33,
                 from drivers/scsi/pm8001/pm8001_sas.h:54,
                 from drivers/scsi/pm8001/pm8001_hwi.c:40:
include/scsi/scsi.h:133:1: warning: this is the location of the previous definition
In file included from drivers/scsi/pm8001/pm8001_hwi.c:42:
drivers/scsi/pm8001/pm8001_chips.h:47:1: warning: "WRITE_32" redefined
In file included from include/scsi/scsi_host.h:9,
                 from include/linux/libata.h:37,
                 from include/scsi/libsas.h:33,
                 from drivers/scsi/pm8001/pm8001_sas.h:54,
                 from drivers/scsi/pm8001/pm8001_hwi.c:40:
include/scsi/scsi.h:134:1: warning: this is the location of the previous definition

James


