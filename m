From: "David S. Miller" <davem@redhat.com>
Subject: Re: [BUG] x86_64 pci_map_sg modifies sg list - fails multiple
 map/unmaps
Date: Mon, 5 Jan 2004 11:28:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105112800.7a9f240b.davem@redhat.com>
References: <200401051929.i05JTsM0000014248@mudpuddle.cs.wustl.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pizda.ninka.net ([216.101.162.242]:19341 "EHLO pizda.ninka.net")
	by vger.kernel.org with ESMTP id S265218AbUAETdg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2004 14:33:36 -0500
In-Reply-To: <200401051929.i05JTsM0000014248@mudpuddle.cs.wustl.edu>
List-Id: linux-scsi@vger.kernel.org
Cc: gibbs@scsiguy.com, berkley@cs.wustl.edu, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 5 Jan 2004 13:29:54 -0600 (CST)
Berkley Shands <berkley@cs.wustl.edu> wrote:

> 	The pci layer is modifying the sg list, and then placing a zero
> in the length field. pci-gart.c at line 453 (2.6.0 sources) checks this length field
> after a retry, sees that it is zero, and bughalts.

Oh that's a bug.  It is allowed to modify the dma_length field but not
the physical length field.

I imagine x86_64 is doing this so that there need not be a seperate dma_length
field in the scatter_gather struct defined for that platform, and that's too bad it will
definitely need such a seperate field if it wants to implement coalescing.
