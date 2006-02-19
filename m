From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] ncr53c8xx: implement full slave_alloc and slave_destroy methods
Date: Sat, 18 Feb 2006 17:58:57 -0700
Message-ID: <20060219005857.GV12822@parisc-linux.org>
References: <20060208161841.GA19199@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:14053 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S964796AbWBSA66
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 19:58:58 -0500
Content-Disposition: inline
In-Reply-To: <20060208161841.GA19199@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 08, 2006 at 05:18:41PM +0100, Christoph Hellwig wrote:
>  - allocate all per-lun data in slave alloc and free it in slave_destroy.
>  - move the bios first boot lun scanning disable flag to slave_alloc.
>  - remove lots now superflous checks

Sorry for taking so long to get to this.  Unfortunately it blows up
during boot:

zalon_probe: Zalon version 1, IRQ 67
ncr53c720-0: rev 0xf irq 67
ncr53c720-0: ID 7, Fast-10, Parity Checking, Differential
scsi0 : ncr53c8xx-3.4.3g
 0:0:0:0: scsi: Device offlined - not ready after error recovery
BUG: soft lockup detected on CPU#0!
[skipped register dump, not interesting] 
 IAOQ[0]: del_timer+0x60/0x74
 IAOQ[1]: del_timer+0x64/0x74
 RP(r2): scsi_delete_timer+0x14/0x28

FWIW, there is no target 0 on this bus; the only device is ID 6.
