From: Phil Thompson <philt@4bridgeworks.com>
Subject: Support for LSI 53C1010R
Date: Tue, 13 Apr 2004 14:21:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C18BA5DDB58DD511BD0700C0DF0DD45028B295@NTSERVER4>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.digitalinterfacesltd.com ([62.69.87.37]:53776 "EHLO
	ntserver4.diluk.co.uk") by vger.kernel.org with ESMTP
	id S263479AbUDMNVV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 09:21:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

I'm having problems with the Linux sym53c8xx_2 (sym-2.1.17a) driver on an
embedded system with an LSI 53C1010R. Are there any issues with the driver
and that revision of the chip - specifically the R suffix?

The driver tries to do some things with the chip which (according to the
datasheet) aren't supported. For example, the first problem is that it fails
to determine the PCI clock frequency - it times out in sym_hipd.c:getfreq()
waiting for the GEN flag (almost as if there is no SCSI clock). Just prior
to this (in sym_getpciclock()) it tries to set the SCLK bit of STEST1 in
order to use the PCI clock as the SCSI clock - but that bit is reserved
according to the datasheet.

The same hardware seems to work with a much simpler, internally written,
driver.

Any insights very welcome.

Thanks,
Phil
