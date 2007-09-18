From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem
Date: Mon, 17 Sep 2007 22:31:56 -0500
Message-ID: <1190086316.3386.72.camel@localhost.localdomain>
References: <BC382691D59EC94C8E57543C47EF8ED55B20E3@aime2k302.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41902 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751485AbXIRDcI (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 23:32:08 -0400
In-Reply-To: <BC382691D59EC94C8E57543C47EF8ED55B20E3@aime2k302.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Cc: dougg@torque.net, Linux-scsi@vger.kernel.org

On Mon, 2007-09-17 at 18:43 -0700, Wu, Gilbert wrote:
>  ata_task_return code=0   ====> ****** cmd success then the no ATA
> output register return.
> scsi 2:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.02 PQ: 0
> ANSI: 5
> scsi 2:0:0:0: Attached scsi generic sg2 type 5
> ata command=a0
>  ata_task_return code=c  ======> ***** cmd failed then return ATA output
> register
> return reg= 34 40 51 54 0 0 0 a0 0
> ata command=a0
>  ata_task_return code=1

That just says a packet command returned an illegal request ... I think
the CD layer expects this, but without seeing the SCSI command it's hard
to tell.

> sas: sas_ata_phy_reset: Found ATAPI device.
> ata command=a0
>  ata_task_return code=c
> return reg= 34 40 51 24 0 0 20 a0 0
> ata command=a0
>  ata_task_return code=1

This again is a packet command returning not ready (probably no media
present).

> ata command=a0
>  ata_task_return code=c
> return reg= 34 40 51 24 0 0 20 a0 0
> ata command=a0
>  ata_task_return code=1
> ata command=a0
>  ata_task_return code=c
> return reg= 34 40 51 24 0 0 20 a0 0
> ata command=a0
>  ata_task_return code=1
> ata command=a0
>  ata_task_return code=c
> return reg= 34 40 51 24 0 0 20 a0 0
> ata command=a0
>  ata_task_return code=1

These again look like normal CD probes returning not ready.

> ata command=a0
> ------------[ cut here ]------------
> kernel BUG at drivers/ata/libata-core.c:1380!
> invalid opcode: 0000 [#1]

OK, this is the fascinating one ... I think it's a bug in libata itself.
It seems to mean that the tag its trying to use (which is fixed by
convention) is already outstanding.  Since the current probe sequence is
single threaded, I can't really see how this has happened.

James


