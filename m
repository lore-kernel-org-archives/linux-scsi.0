From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Thu, 16 Sep 2004 15:12:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B1AABCE@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13218 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268105AbUIPTMW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 15:12:22 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

I have to recant.

I recommend, because I can not recall the exact situation of the panic
surrounding the lack of pci_dev information in the Scsi_Host. I
recommend dropping the worry for now; let Christoph's comment stand
about removing scsi_set_device() from the initial patch presented by
MarkH.

I get considerable pressure to solve panics and bugs every day,
unrelated to 2.6 issues, and this may be simply be a case of adding in
the scsi_set_device() to CYA when I noticed I needed a
scsi_set_pci_device() in the 2.4 variant of the driver in that same
place. The 2.4 driver in my possession was migrated over to the 2.6 pci
scan code and in the process of shimming it in, this call was added. The
lack of documentation regarding this was glossed over by `switched to
2.6 style adapter scan'.

All I could dredge up about this undocumented addition from my brain
cells is the panic was in code that looks remarkably like the end of
initialize_merge_fn (only in 2.4):

	bounce_limit = SHpnt->pci_dev->dma_mask;

and there are no such code fragments in the 2.6 tree. Thus I feel my
initial fears of removing the scsi_set_device are unfounded. In
addition, the driver in my possession still does things that are
rejected by the community as I try to hold on to or migrate features and
has quirks such as this scsi_set_device to produce stability when they
would be unnecessary in the kernel.org variant.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, September 16, 2004 2:23 PM
To: Mark Haverkamp
Cc: James Bottomley; Salyzyn, Mark; Christoph Hellwig; linux-scsi
Subject: Re: [PATCH] 2.6.9 aacraid: aac_count fix


the earlier scsi_add_host is wrong unfortunately, you must only call
scsi_add_host once the controller is ready to accept I/O.  Where do you
need to derefence the device in there?

Is this the host_lock problem seen in a few other drivers?
