From: Olaf Hering <olh@suse.de>
Subject: incorrect printk in sym_attach error path
Date: Sun, 11 Sep 2005 19:40:29 +0200
Message-ID: <20050911174029.GA23300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53720 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S964951AbVIKRka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Sep 2005 13:40:30 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 5B6AE1AC5A
	for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2005 19:40:29 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I get this with 2.6.13, due to some ppc64 specific errors:


PCI: Enabling device: (0002:30:0c.0), cmd 143
sym0: <896> rev 0x7 at pci 0002:30:0c.0 irq 65
__sym_calloc2: failed to allocate HCB[2200]
<NULL>: giving up ...
RTAS: event: 71, Type: Internal Device Failure, Severity: 2
PCI: Enabling device: (0002:30:0c.1), cmd 143
sym0: <896> rev 0x7 at pci 0002:30:0c.1 irq 66
__sym_calloc2: failed to allocate HCB[2200]
<NULL>: giving up ...


attach_failed is used for more than one error.
np->s.inst_name should be assigned earlier.
