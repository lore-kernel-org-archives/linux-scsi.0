From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] SCSI: Remove redundant GFP_KERNEL type flag in
 kmalloc().
Date: Fri, 4 May 2007 01:15:35 -0700
Message-ID: <20070504011535.ff7181fb.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0704300434460.3703@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767724AbXEDIPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2007 04:15:41 -0400
In-Reply-To: <Pine.LNX.4.64.0704300434460.3703@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>


Please be careful to add the appropriate cc's.

On Mon, 30 Apr 2007 04:37:22 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
> Remove the apparently redundant GFP_KERNEL type flag in the call to
> kmalloc().
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
> index a988d5a..765ded0 100644
> --- a/drivers/scsi/aic7xxx_old.c
> +++ b/drivers/scsi/aic7xxx_old.c
> @@ -6581,7 +6581,7 @@ aic7xxx_slave_alloc(struct scsi_device *SDptr)
>    struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
>    struct aic_dev_data *aic_dev;
> 
> -  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> +  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC);

No, this converts the allocation from a robust one which can sleep into a
flakey one which cannot.

If we want to just clean this code up, we should switch to

	GFP_KERNEL|__GFP_HIGH

and add a comment explaining why we're turning on __GFP_HIGH (pointlessly,
I suspect).

However I suspect what the code really meant to do was to use just
GFP_KERNEL.  It's been that way since

commit 5c9342ceb292ac5c619db6eef4ef427a64bcd436
Author: torvalds <torvalds>
Date:   Thu Nov 7 04:54:32 2002 +0000

    Merge bk://linux-scsi.bkbits.net/scsi-dledford
    into home.transmeta.com:/home/torvalds/v2.5/linux
    
    2002/11/06 16:40:20-05:00 dledford
    aic7xxx_old: multiple updates and fixes, driver ported to scsi
        mid-layer new error handling scheme
