From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Wed, 28 Jan 2004 14:37:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401839A8.307@us.ibm.com>
References: <401521A7.5030808@thekelleys.org.uk> <1075131446.2290.29.camel@mulgrave> <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave> <20040128130040.E11527@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:51124 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S266074AbUA1WiF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 17:38:05 -0500
In-Reply-To: <20040128130040.E11527@vienna.EGENERA.COM>
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Philip R. Auld wrote:
> Hi James,
> 	Thanks for the reply. 
> 
> Rumor has it that on Wed, Jan 28, 2004 at 10:57:29AM -0600 James Bottomley said:
> 
>>On Wed, 2004-01-28 at 09:02, Philip R. Auld wrote:
>>
>>>	1) load balancing when possible: it's not enough to be just a 
>>>		failover mechanism.
>>
>>For first out, a failover target supplies most of the needs.  Nothing
>>prevents an aggregation target being added later, but failover is
>>essential.
> 
> 
> Yes, failover is necessary, but not sufficient to make a decent multipath driver.
> I'm a little concerned by the "added later" part. Shouldn't it be designed in? 

The DM multipath can do both. Unfortunately, some work still needs to be 
done. For example, when doing load balancing how much IO to send down 
each path is an issue that the DM maintainer had asked for feedback on. 
Suggestions?

> 
>>>        2) requiring a userspace program to execute for failover is 
>>>	problematic when it could be the root disk that needs 
>>>	failing over.
>>
>>Userspace is required for *configuration* not failover.  The path
>>targets failover automatically as they see I/O down particular paths
>>timing out or failing.  That being said, nothing prevents async
>>notifications via hotplug also triggering a failover (rather than having
>>to wait for timeout etc) but it's not required.
>>
> 
> 
> There was some discussion about vendor plugins to do proprietary failover
> when needed. Say to make a passive path active. My concern is that this be
> memory resident and that we not have to go to the disk for such things.
> 
> If there is no need for that or it's done in such a way that it doesn't need
> the disk this won't be a problem then.
>  

This is something both MD and DM multiapth are not yet fully prepared for.


