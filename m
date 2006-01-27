From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/3] SCSI Userspace Target
Date: Fri, 27 Jan 2006 04:46:01 -0600
Message-ID: <43D9F9E9.3060701@cs.wisc.edu>
References: <1138157882.11692.31.camel@max> <20060125174649.GH14225@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35985 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751440AbWA0Kqe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 05:46:34 -0500
In-Reply-To: <20060125174649.GH14225@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> On Tue, Jan 24, 2006 at 08:58:02PM -0600, Mike Christie wrote:
> 
>>The following patches begin to add the infrastructure for the SCSI
>>Userspace target framework. We were not sure about what James meant by
>>some of his comments, so rather than getting to far we want to post a
>>early.
>>
>>As the email subject hints, the goal of the project is to push most of
>>the target code to userspace. The only parts we kept in the kernel were
>>for transferring data between the LLD and userpsace and the netlink
>>interface. We included the relevant parts of a software iscsi target as
>>an example.
> 
> 
> I'm glad this got posted, I've been wanting something like this for a
> while.  My own personal interest is implementing a tSCSI (my answer to
> iSCSI) target.
> 
> One random comment:  Take a look at the mmap'd ring buffer interface
> provided by mmap'ing the packet socket.  That's the ideal async
> interface, since that's fully async, very close to hardware reality.
> 

Thanks will do. I had actually replaced our mapping code with calls to 
block layer functions like bio_map_user() and blk_rq_map_sg(). I am 
still looking into the packet socket interface, but if we have to change 
interaces I would like to somehow hook whatever is decided on into bio.c 
and ll_rw_blk.c so that it could be used by anyone. SG_IO through a 
packet socket for example. Is bsg still being worked on? Is it going to 
use a new interface or is it ioctl based like block/scsi_ioctl.c?
