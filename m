From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Mon, 17 Jan 2005 22:22:37 +0000
Message-ID: <20050117222237.GA15932@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C12E98D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:8417 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262947AbVAQWWm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2005 17:22:42 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12E98D@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 11, 2005 at 01:34:37PM -0500, James.Smart@Emulex.Com wrote:
> Christoph and Community,
> 
> The 8.0.20 release of the Emulex driver has been recently posted
> to SourceForge:
> http://prdownloads.sourceforge.net/lpfcxxxx/lpfcdriver-2.6-8.0.20.tar.gz?download
> 
> 
> Emulex has been working hard to complete the outstanding items for upstream
> acceptance:
> 
> - Streamline I/O submission path.
> - Removal of GFP_ATOMIC allocations in I/O path. Consider locations
>   as well.
> - Movement of Consistent Bindings to the FC Transport.
> - Discovery changes:
>    Target discovery via scsi_scan_single_target. Reduce bookkeeping
>      in lpfc_find_target().
>    Cleanse target removal. Ensure no more __devices references.
> - Removal of ifdefs for older kernel support and different patches
> 
> And from our point of view :
> - Add management interfaces in support of HBAAPI.


I started to look through it, here's some thing I found so far:

 o there's still a ->proc_info method which we don't want for new drivers
 o the host removal is still quite hackish and probably racy:
    - everything what's you're ding with FC_UNLOADING should be done in
      the midlayer where we already have a state machine for the
      Scsi_Host
    - target removal shouldn't happen from your remove method but via
      scsi_remove_host
 o the driver would benefit a _lot_ from driver private data in
   scsi_target, I think we should do that and basically get rid of
   phba->device_queue_hash
 o what about lpfc_target->rport?  This should probably better be in
   the fc_target structure, no?
 o lpfc_target vs lpfc_nodelist.  I'd see these merged into a single
   structure.  In fact large parts of lpfc_nodelist should probably
   move into the transport class.
 o the memory allocation for non-I/O path stilled looked total overkill
   to me, but it seems you're doing an awfull lot from the interrupt handler
   still.  Wouldn't it be easier to do much of it from process context
   via the kernel thread?
