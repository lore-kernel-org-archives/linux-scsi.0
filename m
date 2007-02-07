From: Swen Schillig <swen.schillig@freenet.de>
Subject: Re: [PATCH] zfcp: Invalid locking order
Date: Wed, 7 Feb 2007 17:19:30 +0100
Message-ID: <200702071719.30869.swen.schillig@freenet.de>
References: <200702071317.58026.swen.schillig@freenet.de> <20070207160643.GE30311@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout2.freenet.de ([194.97.50.155]:50219 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161369AbXBGQTR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 11:19:17 -0500
In-Reply-To: <20070207160643.GE30311@alberich.amd.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-scsi@vger.kernel.org

Hi Andreas

No, not those. 
We got a possible recursive locking on the adapter->request_queue.queue_lock

Cheers Swen

On Wednesday 07 February 2007 17:06, Andreas Herrmann wrote:
> On Wed, Feb 07, 2007 at 01:17:57PM +0100, Swen Schillig wrote:
> > From: Swen Schillig <swen@vnet.ibm.com>
> > 
> > Invalid locking order. Kernel hangs after trying to take two locks
> > which are dependend on each other. Introducing temporary variable
> > to free requests. Free lock after requests are copied.
> >     
> 
> I am just curious. You didn't mention which locks are causing the dead
> lock.
> 
> I've glanced through the code and it seems that locking order
> of abort_lock and req_list_lock for adapters is inconsistent.
> Is that the bug you try to fix?
> 
> 
> Regards,
> 
> Andreas
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
