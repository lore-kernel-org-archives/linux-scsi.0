From: Jeff Garzik <jgarzik@pobox.com>
Subject: ahc1542 fun
Date: Tue, 25 May 2004 22:32:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B401AE.9060707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:26291 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265291AbUEZCc2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2004 22:32:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>


The old 1542 scsi driver is both ISA and MCA.  The MCA portions are 
disabled when !CONFIG_MCA through the typical wrapper scheme (a la pci.h 
and !CONFIG_PCI).  However...  the driver unconditionally includes 
linux/mca.h which in turn unconditionally includes asm/mca.h.

This breaks drivers on platforms with ISA but not MCA, like alpha.

(and I suppose any PCI platform, since you could have one on an ISA bridge)

	Jeff



