From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] Netlink and user-space buffer pointers
Date: Thu, 20 Apr 2006 16:41:52 -0500
Message-ID: <44480020.3080100@cs.wisc.edu>
References: <1145306661.4151.0.camel@localhost.localdomain> <20060418160121.GA2707@us.ibm.com> <444633B5.5030208@emulex.com> <4446AC80.6040604@cs.wisc.edu> <44479BA8.1000405@emulex.com> <4447C8C2.30909@cs.wisc.edu> <4447E91E.7030603@emulex.com> <4447F09D.9090501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:1941 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751345AbWDTVmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 17:42:03 -0400
In-Reply-To: <4447F09D.9090501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Smart@Emulex.Com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
>> Second: transport level i/o could be done like you suggest, and we've
>>   prototyped some of this as well. However, there's something very wrong
>>   about putting "block device" wrappers and settings around something that
>>   is not a block device.  In general, it's a heck of a lot of overhead and
>>   still doesn't solve the real issue - how to portably pass that user
>> buffer
> 
> 
> I am not talking about putting block device wrappers. This the magic
> part and the message passing comes in. A while back I made the requuest
> queue a class (only sent the patch to Jens and did not follow up). The
> original reason was for the io sched swap and some multipath stuff, but
> since with then the request queue would need a block device to be
> exposed to userspace through sysfs and would not need a block device to
> send messages throgh. You just need a way to commniutate between
> userspace and the kernel but it does not have to be through a block
> device. I think this path has other benefits in that you could do
> userspace level scanning as well since you do not need the block device
> and ULD like we do today.
> 

Again for a bad example look at the target code. The original idea was
to use the request_queue for messages because it did not work so well
for them to take target requests (we do not need the io scheduler for
example) to send request from the target interrupt handler to the netink
code. It was over kill becuase all we really want is a per cpu list, but
we used the request queue becuase it had the queue limits that we
needed. It was mean as temporary and I think tomo is working on
replacing that with a per process list and softirq. But the point is
that you can use the request queue to pass around requests and still use
netlink for the interface between the kernel and userspace.
