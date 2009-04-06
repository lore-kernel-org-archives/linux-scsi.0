From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: SCSI Hardware Handler and slow failover with large
	number of LUNS
Date: Mon, 06 Apr 2009 10:43:45 -0500
Message-ID: <49DA2331.8020609@cs.wisc.edu>
References: <1238880636.11478.8.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1238880636.11478.8.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, "Moger,
	Babu" <Babu.Moger@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> Hello All,
> 
> During testing with the latest SCSI DH Handler on a rdac storage, Babu
> found that the failover time with 100+ luns takes about 15 minutes,
> which is not good.
> 
> We found that the problem is due to the fact that we serialize activate
> in dm on the work queue.
> 

I thought we talked about this during the review?

> We can solve the problem in rdac handler in 2 ways
>  1. batch up the activates (mode_selects) and send few of them.
>  2. Do mode selects in async mode.

I think most of the ugliness in the original async mode was due to 
trying to use the REQ_BLOCK* path. With the scsi_dh_activate path, it 
should now be easier because in the send path we do not have to worry 
about queue locks being held and context.

I think we could just use blk_execute_rq_nowait to send the IO. Then we 
would have a workqueue/thread per something (maybe per dh module I 
thought), that would be queued/notified when the IO completed. The 
thread could then process the IO and handle the next stage if needed.

Why use the thread you might wonder? I think it fixes another issue with 
the original async mode, and makes it easier if the scsi_dh module has 
to send more IO. When using the thread it would not have to worry about 
the queue_lock being held in the IO completion path and does not have to 
worry about being run from more restrictive contexts.


> 
> Just wondering if anybody had seen the same problem in other storages
> (EMC, HP and Alua). 

They should all have the same problem.


> 
> Please share your experiences, so we can come up with a solution that
> works for all hardware handlers.
> 
> regards,
> 
> chandra
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
