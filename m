From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/7] gdth: clean up host private data
Date: Sat, 21 Jul 2007 16:14:40 -0400
Message-ID: <46A26930.1030208@garzik.org>
References: <20070721170209.GG4150@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33996 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972AbXGUUOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 16:14:44 -0400
In-Reply-To: <20070721170209.GG4150@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: leubner@adaptec.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Get rid of all the indirection in the Scsi_Host private data and always
> but the gdth_ha_str directly into it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> @@ -678,7 +676,7 @@ static char *gdth_ioctl_alloc(int hanum,
>      if (size == 0)
>          return NULL;
>  
> -    ha = HADATA(gdth_ctr_tab[hanum]);
> +    ha = shost_priv(gdth_ctr_tab[hanum]);
>      spin_lock_irqsave(&ha->smp_lock, flags);
>  
>      if (!ha->scratch_busy && size <= GDTH_SCRATCH) {
> @@ -703,7 +701,7 @@ static void gdth_ioctl_free(int hanum, i
>      gdth_ha_str *ha;
>      ulong flags;
>  
> -    ha = HADATA(gdth_ctr_tab[hanum]);
> +    ha = shost_priv(gdth_ctr_tab[hanum]);
>      spin_lock_irqsave(&ha->smp_lock, flags);
>  
>      if (buf == ha->pscratch) {

Major problem with this patch:  it still directly references statically 
sized gdth_ctr_tab[].

This patch should be rewritten to apply on top of "gdth: Isolate 
driver-global variables using helpers".  That patch has the clear 
advantage of isolating the direct references to gdth_ctr_tab[], which 
means that it can be trivially replaced with a dynamically-sized 
implementation in a later cleanup, without affecting the code or procfs 
output at all.

IOW, the "ha from hanum" common operation should clearly have a wrapper.

Once that is complete, your patch here shrinks, since you merely have to 
update gdth_find_ha() once rather than each codesite.

	Jeff


P.S.  Are you sure you got achim's email correct?  I was using 
achim_leubner@adaptec.com since that it what is in gdth.c and his most 
recent Acked-by entry in the kernel changelog.
