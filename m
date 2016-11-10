From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: use pci_alloc_irq_vectors and automatic irq
 affinity
Date: Thu, 10 Nov 2016 07:38:58 +0100
Message-ID: <e8c52263-8261-d94d-e67c-78393efcf7e2@suse.de>
References: <1478716942-6335-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbcKJGjA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 01:39:00 -0500
In-Reply-To: <1478716942-6335-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, don.brace@microsemi.com
Cc: linux-scsi@vger.kernel.org

On 11/09/2016 07:42 PM, Christoph Hellwig wrote:
> This patch converts over hpsa to use the pci_alloc_irq_vectors including
> the PCI_IRQ_AFFINITY flag that automatically assigns spread out
> irq affinity to the I/O queues.
> 
> It also cleans up the per-ctrl interrupt state due to the use of the
> pci_irq_vector and pci_free_irq_vectors helpers that don't need to know
> the exact irq type.  Additionally it changes a little oddity in the
> existing code that was using different array indixes into the per-vector
> arrays depending on wether a controller is using a single INTx or single
> MSI irq.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/hpsa.c | 143 ++++++++++++++++++----------------------------------
>  drivers/scsi/hpsa.h |   6 +--
>  2 files changed, 52 insertions(+), 97 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
