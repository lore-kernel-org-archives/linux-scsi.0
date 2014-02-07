From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/16] scsi_dh_alua: Make stpg synchronous
Date: Thu, 06 Feb 2014 19:54:31 -0600
Message-ID: <52F43CD7.5050900@cs.wisc.edu>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-5-git-send-email-hare@suse.de> <52F435B3.3090600@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39787 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaBGBzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 20:55:06 -0500
In-Reply-To: <52F435B3.3090600@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/06/2014 07:24 PM, Mike Christie wrote:
> On 01/31/2014 03:29 AM, Hannes Reinecke wrote:
>> We should be issuing STPG synchronously as we need to
>> evaluate the return code on failure.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> I think we need to also make dm-mpath.c use a non-ordered workqueue for
> kmpath_handlerd. With this patch and the current ordered workqueue in
> dm-mpath I think we will only be able to do one STPG at a time. I think
> if we use a normal old non-ordered workqueue then we would be limited to
> have max_active STPGs executing.

I goofed and commented in the order I saw the patches :) I take this
comment back for this patch, because I see in 16/16 you added a new
workqueue to scsi_dh_alua to do rtpgs and stpgs.

For 16/16 though, do we want to make kmpath_aluad a non single threaded
workqueue? It looks like max_active for single threaded is only one work
at a time too.

