From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: next: CNIC: build fails
Date: Wed, 10 Jun 2009 14:55:49 +0000
Message-ID: <1244645749.4109.36.camel@mulgrave.site>
References: <a4423d670906100556t6b193f45l1500f8f7c5cfe80b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <a4423d670906100556t6b193f45l1500f8f7c5cfe80b@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>, mchan@broadcom.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-06-10 at 16:56 +0400, Alexander Beregalov wrote:
> Hi
> 
> drivers/net/cnic.c: In function 'cnic_start_hw':
> drivers/net/cnic.c:2391: error: implicit declaration of function 'pci_dev_get'
> 
> The problem is that kconfig selects CNIC without it dependencies
> 
> config SCSI_BNX2_ISCSI
>         tristate "Broadcom NetXtreme II iSCSI support"
>         select SCSI_ISCSI_ATTRS
>         select CNIC
> 
> config BNX2
>         tristate "Broadcom NetXtremeII support"
>         depends on PCI
>         select CRC32
>         select FW_LOADER
> 
> config CNIC
>         tristate "Broadcom CNIC support"
>         depends on BNX2
>         depends on UIO
> 
> $ egrep "CNIC|BNX|_PCI" .config
> # CONFIG_PCI is not set
> CONFIG_SCSI_BNX2_ISCSI=y
> CONFIG_CNIC=y

OK, so one way to fix this is to make BNX2_ISCSI depend on CNIC rather
than select it.

A better way might be to make CNIC select BNX and UIO and then make
BNX2_ISCSI depend on PCI as well.

James
