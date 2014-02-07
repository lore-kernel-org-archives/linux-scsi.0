From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/16] scsi_dh_alua: Make stpg synchronous
Date: Thu, 06 Feb 2014 19:24:03 -0600
Message-ID: <52F435B3.3090600@cs.wisc.edu>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39740 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbaBGBYl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 20:24:41 -0500
In-Reply-To: <1391160600-19652-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/2014 03:29 AM, Hannes Reinecke wrote:
> We should be issuing STPG synchronously as we need to
> evaluate the return code on failure.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

I think we need to also make dm-mpath.c use a non-ordered workqueue for
kmpath_handlerd. With this patch and the current ordered workqueue in
dm-mpath I think we will only be able to do one STPG at a time. I think
if we use a normal old non-ordered workqueue then we would be limited to
have max_active STPGs executing.
