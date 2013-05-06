From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: Tree for May 6 (lpfc)
Date: Mon, 06 May 2013 09:49:25 -0700
Message-ID: <1367858965.1868.24.camel@dabdike>
References: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au>
	 <5187D6F1.9070103@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <5187D6F1.9070103@infradead.org>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, James Smart <james.smart@emulex.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-05-06 at 09:14 -0700, Randy Dunlap wrote:
> On 05/05/13 21:42, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do not add any v3.11 destined work to your linux-next included
> > branches until after v3.10-rc1 is released.
> > 
> > I am receiving a (un)reasonable number of conflicts from there being
> > multiple copies of some commits in various trees.   Please clean this up
> > and resist the temptataion to rebase your trees on the way to your
> > upstream ...
> > 
> > Changes since 20130506:
> > 
> 
> on i386:
> # CONFIG_CRC_T10DIF is not set
> 
> 
> drivers/built-in.o: In function `lpfc_bg_crc':
> (.text+0x3cb3c9): undefined reference to `crc_t10dif'

That's the usual minor config cockup, isn't it?  lpfc apparently also
needs the generic checksum, so the fix would seem to be this.

James

---
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index db95c54..86af29f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1353,6 +1353,8 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	select SCSI_FC_ATTRS
+	select GENERIC_CSUM
+	select CRC_T10DIF
 	help
           This lpfc driver supports the Emulex LightPulse
           Family of Fibre Channel PCI host adapters.
