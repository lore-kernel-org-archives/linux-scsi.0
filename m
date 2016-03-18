From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 00/22] ncr5380: Eliminate macros, reduce code duplication,
 fix bugs etc
Date: Fri, 18 Mar 2016 20:03:00 +1300
Message-ID: <56EBA824.2040205@gmail.com>
References: <20160314042700.596192247@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042700.596192247@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

Finn,

tested successfully on Atari Falcon, so:

Tested-by: Michael Schmitz <schmitzmic@gmail.com>

Am 14.03.2016 um 17:27 schrieb Finn Thain:
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
> on suitable hardware. Help with driver testing on ISA and Atari hardware
> is sought as I don't have any (likewise RiscPC ecards and Sun 3 hardware).
> 
> ---
>  Documentation/scsi/g_NCR5380.txt       |   17 
>  Documentation/scsi/scsi-parameters.txt |   11 
>  drivers/scsi/Kconfig                   |   11 
>  drivers/scsi/NCR5380.c                 |  661 ++++----
>  drivers/scsi/NCR5380.h                 |  145 -
>  drivers/scsi/arm/cumana_1.c            |   25 
>  drivers/scsi/arm/oak.c                 |   22 
>  drivers/scsi/atari_NCR5380.c           | 2676 ---------------------------------
>  drivers/scsi/atari_scsi.c              |  142 -
>  drivers/scsi/dmx3191d.c                |   10 
>  drivers/scsi/dtc.c                     |   27 
>  drivers/scsi/dtc.h                     |    7 
>  drivers/scsi/g_NCR5380.c               |  143 -
>  drivers/scsi/g_NCR5380.h               |   26 
>  drivers/scsi/mac_scsi.c                |  239 +-
>  drivers/scsi/pas16.c                   |   27 
>  drivers/scsi/pas16.h                   |    5 
>  drivers/scsi/sun3_scsi.c               |   48 
>  drivers/scsi/t128.c                    |   19 
>  drivers/scsi/t128.h                    |    7 
>  20 files changed, 636 insertions(+), 3632 deletions(-)
> 
> 
> 
> 
