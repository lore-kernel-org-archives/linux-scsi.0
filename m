From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: scsi_cmnd accessors issues
Date: Tue, 12 Jun 2007 21:46:40 +0300
Message-ID: <466EEA10.60807@panasas.com>
References: <466EDFAC.9020104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:54080 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756898AbXFLSq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2007 14:46:56 -0400
In-Reply-To: <466EDFAC.9020104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ed Lin <ed.lin@promise.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Boaz Harrosh wrote:
> 2 things
> 
> [1]
> There are 2 files (see attached patch) that use scsi_befflen() & scsi_sg_count() as
> L-value. If I try the scsi_sgtable approach and do:
> 
> #define scsi_sg_count(cmd) ((cmd)->sg_table ? (cmd)->sg_table->sg_count : 0)
> #define scsi_sglist(cmd) ((cmd)->sg_table ? (cmd)->sg_table->sglist : NULL)
> #define scsi_bufflen(cmd) ((cmd)->sg_table ? (cmd)->sg_table->length : 0)
> 
> I get compilation errors. Attached solution is to add scsi_set_ accessors to these
> members. But it would be best to STOP these drivers from doing that ugly hack of
> modifying sg_count and bufflen.
> (CC sign-off-by maintainers of the drivers in question. Files are
> drivers/scsi/tmscsim.c & drivers/scsi/stex.c )
> 
> see: http://www.bhalevy.com/open-osd/download/sgtable_bidi_varlen/
>      for the full bidi over scsi_sgtable solution
> 
> [2]
> if I use __deprecated on request_buffer, request_bufflen, and use_sg with
> scsi_sgtable implementation Than I get below list of files complaining:
> drivers/ata/libata-scsi.c
> drivers/firewire/fw-sbp2.c
> drivers/infiniband/ulp/srp/ib_srp.c
> drivers/message/i2o/i2o_scsi.c
> drivers/scsi/aacraid/aachba.c
> drivers/scsi/lpfc/lpfc_scsi.c
> drivers/scsi/aha152x.c
> drivers/scsi/pcmcia/nsp_cs.c
> drivers/scsi/sym53c8xx_2/sym_glue.h
> drivers/scsi/sym53c8xx_2/sym_glue.c
> drivers/scsi/ncr53c8xx.c
> drivers/scsi/sd.c
> drivers/scsi/sr.c
> drivers/scsi/advansys.c
> drivers/scsi/psi240i.c
> drivers/scsi/aha1542.c
> drivers/scsi/ips.c
> drivers/scsi/fd_mcs.c
> drivers/scsi/in2000.c
> drivers/scsi/NCR5380.c
> drivers/scsi/qla1280.c
> drivers/scsi/seagate.c
> drivers/scsi/dc395x.c
> drivers/scsi/atp870u.c
> drivers/scsi/gdth.c
> drivers/scsi/ide-scsi.c
> drivers/scsi/ppa.c
> drivers/scsi/imm.c
> drivers/scsi/hptiop.c
> drivers/usb/image/microtek.c
> drivers/usb/storage/protocol.c
> drivers/usb/storage/transport.c
> drivers/usb/storage/shuttle_usbat.c
> drivers/usb/storage/sddr09.c
> drivers/usb/storage/freecom.c
> drivers/usb/storage/isd200.c
> 
> and also these files from scsi-ml that need changing when implementation changes:
> drivers/scsi/scsi.c
> drivers/scsi/scsi_error.c
> drivers/scsi/scsi_debug.c
> 
> (see: 0004-Convert-scsi-ml-to-use-of-new-scsi_sgtable.patch at scsi_cmnd.h)
> 
> Which of the files do you have pending patches for? Which do you need that I send
> what I have for them?
> 
> Thanks
> Boaz
> 
> 
> 
> 

Attached patch was wrong in regard to sign of set_ parameters. See above URL for a
fixed version. Sorry
Boaz

