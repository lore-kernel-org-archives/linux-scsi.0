From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] zfcp: Invalid locking order
Date: Thu, 8 Feb 2007 17:18:22 +0100
Message-ID: <20070208161822.GA1768@alberich.amd.com>
References: <200702071317.58026.swen.schillig@freenet.de>
 <20070207160643.GE30311@alberich.amd.com>
 <20070208144003.GC8345@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:58172 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423121AbXBHQTu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 11:19:50 -0500
In-Reply-To: <20070208144003.GC8345@osiris.boeblingen.de.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Swen Schillig <swen.schillig@freenet.de>, linux-scsi@vger.kernel.org

On Thu, Feb 08, 2007 at 03:40:03PM +0100, Heiko Carstens wrote:
> On Wed, Feb 07, 2007 at 05:06:43PM +0100, Andreas Herrmann wrote:
> > On Wed, Feb 07, 2007 at 01:17:57PM +0100, Swen Schillig wrote:
> > > From: Swen Schillig <swen@vnet.ibm.com>
> > > 
> > > Invalid locking order. Kernel hangs after trying to take two locks
> > > which are dependend on each other. Introducing temporary variable
> > > to free requests. Free lock after requests are copied.
> > >     
> > 
> > I am just curious. You didn't mention which locks are causing the dead
> > lock.
> > 
> > I've glanced through the code and it seems that locking order
> > of abort_lock and req_list_lock for adapters is inconsistent.
> > Is that the bug you try to fix?
> 
> It's a possible A-B-B-A deadlock on the erp_lock and req_list_lock
> (see output below).  The bug was introduced with
> fea9d6c7bcd8ff1d60ff74f27ba483b3820b18a3 and this patch reverts
> parts of it.
> 

Pretty good catch.

I might be wrong but the patch seems to fix another potential deadlock:


CPU#0
0: zfcp_fsf_req_dimiss_all()
	spin_lock_irqsave(&adapter->req_list_lock, flags);
1: zfcp_fsf_req_dismiss()
2: zfcp_fsf_protstatus_eval()
3: zfcp_fsf_fsfstatus_eval()
4: zfcp_fsf_req_dispatch()
5: zfcp_fsf_send_fcp_command_handler()
6: zfcp_fsf_send_fcp_command_task_handler()
	read_lock_irqsave(&fsf_req->adapter->abort_lock, flags);

CPU#1
0: zfcp_scsi_eh_abort_handler()
	write_lock_irqsave(&adapter->abort_lock, flags);
	spin_lock(&adapter->req_list_lock);

But I currently do not overlook whether zfcp_fsf_req_dimiss_all()
and zfcp_scsi_eh_abort_handler() can run simultaneously for the
same adapter.

However that may be, with Swen's patch this case won't happen.


Regards,

Andreas

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center



