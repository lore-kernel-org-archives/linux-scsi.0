From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: I want scsi_target_block() in interrupt context
Date: Wed, 29 Jun 2005 15:20:28 -0500
Message-ID: <42C3028C.2020606@cs.wisc.edu>
References: <52fyv1dqer.fsf@topspin.com>	<20050629173629.GA32197@infradead.org> <5264vxdp9p.fsf@topspin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:64663 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262597AbVF2UVy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2005 16:21:54 -0400
In-Reply-To: <5264vxdp9p.fsf@topspin.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rolandd@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Roland Dreier wrote:
>     Christoph> Just allocate one scsi_host per connection.
> 
> OK, that solves the queuing problem nicely.
> 
> Right now, I create a scsi_host for each local IB port.  For each
> scsi_host, I have a writable sysfs attribute that userspace can put
> the addresses of remote ports to connect to.  Any preference for how
> to implement the mechanism for userspace to pass in a remote address
> to connect to?
> 

for iscsi and tcp connections, open-iscsi did the socket connection 
stuff in userspace then passed the fd down to the driver which used 
sockfd_lookup().
