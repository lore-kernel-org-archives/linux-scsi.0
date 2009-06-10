From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: next: CNIC: build fails
Date: Wed, 10 Jun 2009 08:14:37 -0700
Message-ID: <C27F8246C663564A84BB7AB343977242178EE78056@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <1244645749.4109.36.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1244645749.4109.36.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-next-owner@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, 'Mike Christie' <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:

> On Wed, 2009-06-10 at 16:56 +0400, Alexander Beregalov wrote:
> > Hi
> >
> > drivers/net/cnic.c: In function 'cnic_start_hw':
> > drivers/net/cnic.c:2391: error: implicit declaration of
> function 'pci_dev_get'
> >
> > The problem is that kconfig selects CNIC without it dependencies
> >
> > config SCSI_BNX2_ISCSI
> >         tristate "Broadcom NetXtreme II iSCSI support"
> >         select SCSI_ISCSI_ATTRS
> >         select CNIC
> >
> > config BNX2
> >         tristate "Broadcom NetXtremeII support"
> >         depends on PCI
> >         select CRC32
> >         select FW_LOADER
> >
> > config CNIC
> >         tristate "Broadcom CNIC support"
> >         depends on BNX2
> >         depends on UIO
> >
> > $ egrep "CNIC|BNX|_PCI" .config
> > # CONFIG_PCI is not set
> > CONFIG_SCSI_BNX2_ISCSI=y
> > CONFIG_CNIC=y
>
> OK, so one way to fix this is to make BNX2_ISCSI depend on CNIC rather
> than select it.
>
> A better way might be to make CNIC select BNX and UIO and then make
> BNX2_ISCSI depend on PCI as well.
>

We want BNX2_ISCSI to select CNIC, otherwise the user won't even see
the BNX2_ISCSI option under SCSI low-level drivers if CNIC is not
enabled.

So I like your second solution.

Thanks.
