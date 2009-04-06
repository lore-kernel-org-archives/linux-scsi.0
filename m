From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] SCSI Hardware Handler and slow failover with large
	number of LUNS
Date: Mon, 06 Apr 2009 11:21:38 -0700
Message-ID: <1239042098.25764.14.camel@chandra-ubuntu>
References: <1238880636.11478.8.camel@chandra-ubuntu>
	 <49DA2331.8020609@cs.wisc.edu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:34022 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZDFSVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 14:21:31 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n36IILnZ001643
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 12:18:21 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n36ILSaT226386
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 12:21:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n36ILRrf032207
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 12:21:28 -0600
In-Reply-To: <49DA2331.8020609@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, "Moger, Babu" <Babu.Moger@lsi.com>

Thanks for the response Mike.

On Mon, 2009-04-06 at 10:43 -0500, Mike Christie wrote:
> Chandra Seetharaman wrote:
> > Hello All,
> > 
> > During testing with the latest SCSI DH Handler on a rdac storage, Babu
> > found that the failover time with 100+ luns takes about 15 minutes,
> > which is not good.
> > 
> > We found that the problem is due to the fact that we serialize activate
> > in dm on the work queue.
> > 
> 
> I thought we talked about this during the review?

Yes, we did and the results were compared to the virgin code (w.r.t rdac
handler) and the results were good (also I used only 49 luns) :
http://marc.info/?l=dm-devel&m=120889858019762&w=2


> 
> > We can solve the problem in rdac handler in 2 ways
> >  1. batch up the activates (mode_selects) and send few of them.
> >  2. Do mode selects in async mode.
> 
> I think most of the ugliness in the original async mode was due to 
> trying to use the REQ_BLOCK* path. With the scsi_dh_activate path, it 
> should now be easier because in the send path we do not have to worry 
> about queue locks being held and context.
> 

little confused... we still are using REQ_TYPE_BLOCK_PC

> I think we could just use blk_execute_rq_nowait to send the IO. Then we 
> would have a workqueue/thread per something (maybe per dh module I 
> thought), that would be queued/notified when the IO completed. The 
> thread could then process the IO and handle the next stage if needed.
> 
> Why use the thread you might wonder? I think it fixes another issue with 
> the original async mode, and makes it easier if the scsi_dh module has 

can you elaborate the issue ?

> to send more IO. When using the thread it would not have to worry about 
> the queue_lock being held in the IO completion path and does not have to 
> worry about being run from more restrictive contexts.

You think queue_lock contention is an issue ?

I agree with the restrictive context issue though.

So, your suggestion is to move everything to async ?

> 
> 
> > 
> > Just wondering if anybody had seen the same problem in other storages
> > (EMC, HP and Alua). 
> 
> They should all have the same problem.
> 
> 
> > 
> > Please share your experiences, so we can come up with a solution that
> > works for all hardware handlers.
> > 
> > regards,
> > 
> > chandra
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 

