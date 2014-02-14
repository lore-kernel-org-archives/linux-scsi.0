From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 07/16] scsi_dh_alua: Use separate alua_port_group structure
Date: Fri, 14 Feb 2014 18:42:06 +0100
Message-ID: <52FE556E.2040400@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-8-git-send-email-hare@suse.de> <52FE045F.8050603@acm.org> <52FE4062.4040902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:59807 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751972AbaBNRmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 12:42:11 -0500
In-Reply-To: <52FE4062.4040902@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/14/14 17:12, Hannes Reinecke wrote:
> The reason I did this was that I don't have to allocate memory
> unnecesarily.
> If I move the allocation out of the spinlock I'll have to recheck
> the list upon insertion to ensure no duplicates are present.
> Upon hitting a duplicate I would have to release the memory again.
> 
> I do agree that GFP_KERNEL is probably not the correct thing here;
> so either I move it to GFP_ATOMIC or we may run into a chance of
> having to release the memory again afterwards.
> 
> Personally I'm inclined to use GFP_ATOMIC, but I'm not sure what'd
> be best.
> 
> What would you suggest here?

I have not yet had a chance to audit all code where list_lock is used.
Is sleeping allowed in each function where list_lock is used ? If so,
how about using a mutex instead of a spinlock ?

Bart.

