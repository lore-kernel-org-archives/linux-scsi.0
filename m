From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/21] advansys: Convert to pci_register_driver interface
Date: Thu, 26 Jul 2007 15:05:48 -0400
Message-ID: <46A8F08C.8060204@garzik.org>
References: 20070726171141.GE19275@parisc-linux.org <11854705774041-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50687 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761481AbXGZTFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 15:05:50 -0400
In-Reply-To: <11854705774041-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Reading this more, this commit breaks everything AFAICS.

You still use scsi_register, which populates ->legacy_hosts list, but no 
longer include scsi_module.c.  Thus you alloc a bunch of scsi hosts, 
and...  that's it.

They are never added, nor scanned.

Take a look at my gdth conversion, 'gdth' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

You want to do the SCSI host model conversion before PCI/EISA/ISA 
conversions.  Otherwise you run into the breakage seen here.

	Jeff


