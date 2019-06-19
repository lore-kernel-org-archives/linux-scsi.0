From: Ondrej Zary <linux@zary.sk>
Subject: Re: [PATCH] scsi: fdomain: fix building pcmcia front-end
Date: Wed, 19 Jun 2019 20:36:37 +0200
Message-ID: <201906192036.37384.linux@zary.sk>
References: <20190617111937.2355936-1-arnd@arndb.de> <yq1v9x2uv2a.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1v9x2uv2a.fsf@oracle.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 19 June 2019 05:13:01 Martin K. Petersen wrote:
> 
> Arnd,
> 
> > Move the common support outside of the SCSI_LOWLEVEL section.
> > Alternatively, we could move all of SCSI_LOWLEVEL_PCMCIA into
> > SCSI_LOWLEVEL. This would be more sensible, but might cause surprises
> > for users that have SCSI_LOWLEVEL disabled.
> 
> It seems messy to me that PCMCIA lives outside of the LOWLEVEL section.
> 
> Given that the number of users that rely on PCMCIA for their system disk
> is probably pretty low, I think I'm leaning towards cleaning things up
> instead of introducing a nonsensical top level option.
> 
> Or even better: Get rid of SCSI_FDOMAIN as a user-visible option and
> select it if either of the PCI/ISA/PCMCIA drivers are enabled.

SCSI_FDOMAIN is not an user-visible option. PCI/ISA/PCMCIA drivers select it:

Symbol: PCMCIA_FDOMAIN [=m]
Type  : tristate
Prompt: Future Domain PCMCIA support
  Location:
    -> Device Drivers
      -> SCSI device support
        -> PCMCIA SCSI adapter support (SCSI_LOWLEVEL_PCMCIA [=y])
  Defined at drivers/scsi/pcmcia/Kconfig:22
  Depends on: SCSI_LOWLEVEL_PCMCIA [=y] && SCSI [=y] && PCMCIA [=m] && m && MODULES [=y]
  Selects: SCSI_FDOMAIN [=m]


Symbol: SCSI_FDOMAIN [=m]
Type  : tristate
  Defined at drivers/scsi/Kconfig:666
  Depends on: SCSI_LOWLEVEL [=y] && SCSI [=y]
  Selected by [m]:
  - SCSI_FDOMAIN_PCI [=m] && SCSI_LOWLEVEL [=y] && PCI [=y] && SCSI [=y]
  - SCSI_FDOMAIN_ISA [=m] && SCSI_LOWLEVEL [=y] && ISA [=y] && SCSI [=y]
  - PCMCIA_FDOMAIN [=m] && SCSI_LOWLEVEL_PCMCIA [=y] && SCSI [=y] && PCMCIA [=m] && m && MODULES [=y]


Symbol: SCSI_FDOMAIN_ISA [=m]
Type  : tristate
Prompt: Future Domain 16xx ISA SCSI support
  Location:
    -> Device Drivers
      -> SCSI device support
        -> SCSI low-level drivers (SCSI_LOWLEVEL [=y])
  Defined at drivers/scsi/Kconfig:687
  Depends on: SCSI_LOWLEVEL [=y] && ISA [=y] && SCSI [=y]
  Selects: CHECK_SIGNATURE [=y] && SCSI_FDOMAIN [=m]


Symbol: SCSI_FDOMAIN_PCI [=m]
Type  : tristate
Prompt: Future Domain TMC-3260/AHA-2920A PCI SCSI support
  Location:
    -> Device Drivers
      -> SCSI device support
        -> SCSI low-level drivers (SCSI_LOWLEVEL [=y])
  Defined at drivers/scsi/Kconfig:670
  Depends on: SCSI_LOWLEVEL [=y] && PCI [=y] && SCSI [=y]
  Selects: SCSI_FDOMAIN [=m]



-- 
Ondrej Zary
