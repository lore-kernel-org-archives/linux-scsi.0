From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 5/7] lpfc 8.3.13: BSG management fixes
Date: Wed, 12 May 2010 15:00:16 -0400
Message-ID: <4BEAFAC0.2040209@emulex.com>
References: <1273671164.24670.21.camel@wookie> <4BEAE799.9010502@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:24933 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364Ab0ELTAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 15:00:38 -0400
In-Reply-To: <4BEAE799.9010502@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Mike Christie wrote:
> What is the host_lock use for?
> 
> With this patch is is still possible for the module to unload right 
> before lpfc_bsg_request is called? Should this use a try_module_get and 
> if that fails fail the request?
> 
> Why not just add the module get() and put() calls to the fc class (would 
> it just push the problem up?)?
> 
> Or what about in bsg.c, have bsg_open do a module_get? Could we add a 
> module pointer to the bsg's devices request_queue and have bsg do the 
> get when the device is opened?
> 

The correct thing to do would be to have bsg_open do a class-object get and 
bsg_close a class-object put - whatever object the bsg queue is bound to. 
I'll look into what this means (how to get to the object).

-- james s
