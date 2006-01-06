From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] drivers/scsi/qla2xxx/Kconfig: two fixes
Date: Sat, 7 Jan 2006 00:09:35 +0100
Message-ID: <20060106230935.GC3774@stusta.de>
References: <20060106163401.GP12131@stusta.de> <20060106211241.GG13844@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39439 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S965345AbWAFXJh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2006 18:09:37 -0500
Content-Disposition: inline
In-Reply-To: <20060106211241.GG13844@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 06, 2006 at 01:12:41PM -0800, Andrew Vasquez wrote:
> On Fri, 06 Jan 2006, Adrian Bunk wrote:
> 
> > This patch contains the following fixes for 
> > drivers/scsi/qla2xxx/Kconfig:
> > - add a help text for SCSI_QLA2XXX_EMBEDDED_FIRMWARE
> > - the firmware modules must depend on SCSI_QLA2XXX to prevent
> >   illegal configurations like SCSI_QLA2XXX=m, SCSI_QLA21XX=y
> > 
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Ack.

There's another bug that must be fixed:

SCSI_QLA2XXX must be renamed.

The problem is that up to 2.6.15, it was a not user visible variable 
that was set for _everyone_ with SCSI && PCI and that didn't have any 
influence on what was built.

E.g. it is set in the .config for my computer since my computer has PCI 
cards and I'm using USB mass storage.

Due to the change of SCSI_QLA2XXX to a user-visible option that builds 
the driver, this means that suddenly after upgrading the kernel and 
running "make oldconfig" a SCSI driver gets built the user never 
selected.

Do you have any suggestions for a new name?
We could e.g. name it SCSI_QLAXXXX since the driver also supports 
6312/6322, or name it simply SCSI_QLA.

> Andrew Vasquez

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

