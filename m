From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: Re: Atto UL5D: negotiates only up to FAST-40 SCSI
Date: Mon, 20 Nov 2006 15:31:03 +0100
Message-ID: <xfkr6vymbq0.fsf@uxrs53.drewag.de>
References: <xfku00y8gjn.fsf@uxrs53.drewag.de>
	<20061117223506.4ec56d04.vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.drewag.de ([212.111.238.29]:10156 "EHLO
	miranda.drewag.de") by vger.kernel.org with ESMTP id S934201AbWKTOfp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 09:35:45 -0500
In-Reply-To: <20061117223506.4ec56d04.vsu@altlinux.ru> (Sergey Vlasov's
 message of "Fri, 17 Nov 2006 22:35:06 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: linux-scsi@vger.kernel.org

Sergey Vlasov <vsu@altlinux.ru> writes:

> On Fri, 17 Nov 2006 12:21:32 +0100 Sven Rudolph wrote:
>
>> I try to use an Atto Dual-Channel Low-Profile PCIExpress SCSI HBA
>> (<http://www.attotech.com/ultra5Dlowpro.html>) with Linux (2.6.18.1,
>> 2.6.19rc6).
>>
>> (Atto provides a Linux driver on CD, but I prefer to use drivers
>> included in the vanilla Linux kernel. It looks like their driver does
>> not include all source code; but I might be wrong on this.)
>
> They also provide a patch for the mptspi driver (apparently made for
> 2.6.14):
>
> http://www.attotech.com/software/secure/lnx_drv_epciu320_2.6.14-15.patch

Thank you for finding this. This patch seems to work fine.

So we should teach Atto to submit this patch to the Linux kernel
instead of trying to roll their on driver? Or can this be implemented
without asking Atto?

Atto seems to prefer their own driver, they say on their web site:

  Linux Support for ExpressPCI. ATTO strongly recommends using the
  RedHat/SUSE driver for all installations. Linux support was
  previously provided for the 2.4 and 2.6 kernels via patches to the
  LSI Logic Fusion MPT driver. However, these patches are no longer
  supported. Release notes and installation instructions are included
  in the download packages.

      Red Hat/SUSE Linux driver v1.00 (File Size393KB) This driver is
      recommended for use with the Red Hat Linux Enterprise 3.x/4 and
      SUSE Linux Enterprise Server for x86, x64(AMD64, EM64T), and
      IA-64 (Itanium) systems.

      The following patches are available for those who prefer the older driver:

      Linux 2.4 Driver Patch for LSI Logic Fusion-MPT Driver v2.05.00
      (File Size 2.2KB) The LSI Logic Fusion-MPT Driver v2.05.00 can
      be downloaded here (File Size 23.4MB).

      Linux 2.6 Driver Patch for LSI Logic Fusion-MPT Driver (File
      Size 2.1KB)The LSI Logic Fusion-MPT Driver v3.01.xx is included
      with the Linux kernel.

> Apparently ATTO devices have a completely different NVRAM format -
> maybe this causes the problem when a driver with just a PCI ID added
> tries to interpret NVRAM data using the LSI format?

This explains the problem. It is even surprising that it worked at
all...

	Sven

