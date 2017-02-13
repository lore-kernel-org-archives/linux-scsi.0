From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 06/16] lpfc: NVME Initiator: Base modifications
Date: Mon, 13 Feb 2017 09:54:01 +0100
Message-ID: <6abb2864-0127-4d12-fafd-6d82f75aba7a@suse.de>
References: <58a0d91e.dhVNcGxwBsHs5tB5%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751553AbdBMIyD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 03:54:03 -0500
In-Reply-To: <58a0d91e.dhVNcGxwBsHs5tB5%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This patch adds base modifications for NVME initiator support.
> 
> The base modifications consist of:
> - Formal split of SLI3 rings from SLI-4 WQs (sometimes referred to as
>   rings as well) as implementation now widely varies between the two.
> - Addition of configuration modes:
>    SCSI initiator only; NVME initiator only; NVME target only; and
>    SCSI and NVME initiator.
>    The configuration mode drives overall adapter configuration,
>    offloads enabled, and resource splits.
>    NVME support is only available on SLI-4 devices and newer fw.
> - Implements the following based on configuration mode:
>   - Exchange resources are split by protocol; Obviously, if only
>      1 mode, then no split occurs. Default is 50/50. module attribute
>      allows tuning.
>   - Pools and config parameters are separated per-protocol
>   - Each protocol has it's own set of queues, but share interrupt
>     vectors.
>      SCSI:
>        SLI3 devices have few queues and the original style of queue
>          allocation remains.
>        SLI4 devices piggy back on an "io-channel" concept that
>          eventually needs to merge with scsi-mq/blk-mq support (it is
> 	 underway).  For now, the paradigm continues as it existed
> 	 prior. io channel allocates N msix and N WQs (N=4 default)
> 	 and either round robins or uses cpu # modulo N for scheduling.
> 	 A bunch of module parameters allow the configuration to be
> 	 tuned.
>      NVME (initiator):
>        Allocates an msix per cpu (or whatever pci_alloc_irq_vectors
>          gets)
>        Allocates a WQ per cpu, and maps the WQs to msix on a WQ #
>          modulo msix vector count basis.
>        Module parameters exist to cap/control the config if desired.
>   - Each protocol has its own buffer and dma pools.
> 
> I apologize for the size of the patch.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
Apologies accepted :-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
