From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] scsi_dh: Remove the workqueue used
	foractivate
Date: Thu, 07 May 2009 22:09:44 -0500
Message-ID: <4A03A278.2080105@cs.wisc.edu>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>	
	<20090428025242.11108.43024.sendpatchset@chandra-ubuntu>	
	<4A02565B.9060105@cs.wisc.edu>
	<1241742949.27327.1.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1241742949.27327.1.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> On Wed, 2009-05-06 at 22:32 -0500, Mike Christie wrote:
>> Chandra Seetharaman wrote:
>>> Since scsi_dh_activate() has become an asynchronous function,
>>> we do not need a workqueue for submitting scsi_dh_activate().
>>>
>>> This patch just removes the workqueue that submits scsi_dh_activate().
>>>
>> Before this is merged, we need to convert the other device handlers to 
>> use blk_execute_rq_nowait or use their own workqueue_struct right?
> 
> If we want those modules also behave async, then yes.
> 
> But, this set of 3 patches would work fine as I made the relevant
> changes to those modules so that they work properly.
>  

What was the point of the workqueue?

I think if you merged the patch and left the other modules as is you 
would hit a problem where the multipathd work queue struct thread is 
busy waiting on activate commands when it should be routing IO to paths 
that do not need a activate.
