From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: g_NCR5380 PDMA, was Re: [PATCH 0/6] ncr5380: Miscellaneous minor patches
Date: Thu, 16 Feb 2017 23:18:51 +0100
Message-ID: <201702162318.52483.linux@rainbow-software.org>
References: <cover.1484523085.git.fthain@telegraphics.com.au> <201701302252.13124.linux@rainbow-software.org> <alpine.LNX.2.00.1701311203001.16154@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1701311203001.16154@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 31 January 2017 02:31:45 Finn Thain wrote:
[...]
> Are you trying to figure out which commands are going to disconnect during
> a transfer? This is really a function of the firmware in the target; there
> are no good heuristics AFAICT, so the PDMA algorithm has to be robust.
> mac_scsi has to cope with this too.
>
> Does the problem go away when you assign no IRQ? When instance->irq ==
> NO_IRQ, the core driver will inhibit disconnect privileges.

Yes, it seems to run fine with IRQ/disconnect disabled.
With IRQ enabled, "dd if=/dev/sr0 of=anything" stops after a while. I get 
gated 53C80 IRQ, BASR=0x10, MODE=0x0e, STATUS=0x7c.

When I enable interrupts during PDMA (like the removed UNSAFE macro did), the 
problems go away. I see an IRQ after each pread call.
(had to disable "no 53C80 gated irq after transfer" and "no end dma signal" 
messages to reduce log spam)

-- 
Ondrej Zary
