From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 16:22:44 -0500
Message-ID: <487E66A4.9030601@cs.wisc.edu>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>	<487E4443.7090601@cs.wisc.edu>	<D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com> <487E4DC6.4030108@cs.wisc.edu> <487E4FE3.8040904@cs.wisc.edu> <487E5157.7050709@cs.wisc.edu> <D1D4C3FF75F9354393DB8314DF43DEF2E7F02E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56746 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbYGPVXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 17:23:00 -0400
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7F02E@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
> Yeah, I realize the scenario. What's confusing is, it's has been a
> while since I've seen any cache failure message get spit out. But your
> logic is pretty solid.
> 
> Anyway, your idea of converting fc_remove_host() to call
> scsi_remove_target()
> for all the targets prior to deleting the rports is a good one.  And the
> terminate_rport_io call is already in fc_rport_final_delete().
> 
> This doesn't make sense to me though:
>> then in the fcoe termniate_rport_io function we could stop the port?
> If "port" means the fcoe port, and if this was the last rport, then I
> guess
> it kinda makes sense. But I would have assumed that the outer thread
> that is
> calling fc_remove_host() and scsi_remove_host() would have actually have
> been the one to stop/terminate the fcoe port after making these calls.
> 

The problem I was thinking about was if we had a rport that we were 
logged into and needed to cleanup some resources for it before it got 
freed. If we do the cleanup after calling 
fc_remove_host()/scsi_remove_host(), the LLD would need to get a ref to 
it, so that when fc_remove_host() deletes it, the rport and the dd_data 
would not get freed.

So I thought it if we could do the cleanup in some callout after the 
target is removed but before the rport is freed. I think I meant to do 
this in the dev_loss_tmo_callbk(). qla2xxx was allocating its own rport 
struct and is freeing it in dev_loss_tmo_callbk(). For fcoe we are just 
using the scsi_transport_fc rport it the dd_data, but I was thinking if 
we needed to cleanup some other rport resrouces we could do it from the 
dev_loss_tmo_callbk().
