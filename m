From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v3 00/23] ncr5380: Eliminate macros, reduce code duplication, fix bugs etc
Date: Tue, 22 Mar 2016 23:24:26 +0100
Message-ID: <201603222324.27594.linux@rainbow-software.org>
References: <20160321023149.604138431@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:51979 "EHLO
	smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbcCVWYi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 18:24:38 -0400
In-Reply-To: <20160321023149.604138431@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sam Creasey <sammy@sammy.net>

On Monday 21 March 2016 03:31:49 Finn Thain wrote:
> 
> This patch series has more macro elimination and some tweaks to the
> DMA hooks so that all the wrapper drivers can share the same core
> DMA algorithm. This resolves the major discrepancies between the two
> core drivers, which relate to code conditional on the REAL_DMA and
> PSEUDO_DMA macros.
> 
> After all the wrapper drivers agree on the DMA hook api, the core driver
> fork gets resolved. NCR5380.c is adopted by atari_scsi and sun3_scsi and
> atari_NCR5380.c is then deleted.
> 
> Historically, the 5380 drivers suffered from over-use of conditional
> compilation, which caused the compile-time configuration space to explode,
> leading to core driver code that was practically untestable, unmaintainable
> and difficult to reason about. It also prevented driver modules from
> sharing object code.
> 
> Along with REAL_DMA, REAL_DMA_POLL and PSEUDO_DMA, most of the remaining
> macros are also eradicated, such as CONFIG_SCSI_GENERIC_NCR53C400,
> SUPPORT_TAGS, DONT_USE_INTR, AUTOPROBE_IRQ and BIOSPARAM.
> 
> Also in this patch series, some duplicated documentation is removed and
> the PDMA implementation in mac_scsi finally gets fixed.
> 
> This patch series was tested by exercising the dmx3191d and mac_scsi modules
> on suitable hardware. Michael has tested atari_scsi on an Atari Falcon.
> Help with driver testing on ISA cards is sought as I don't have such
> hardware. Likewise RiscPC ecards and Sun 3.

Tested on HP C2502 (53C400A chip), Canon FG2-5202 (53C400 chip) and DTC-3181L
(DTCT-436P chip) ISA cards - everything works fine!

Thanks.

Tested-by: Ondrej Zary <linux@rainbow-software.org>

HP C2502:
scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x280, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { }, options { }

Canon FG2-5202:
scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { }, options { }

DTC-3181L:
scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x240, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { }, options { }

-- 
Ondrej Zary
