From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch/rfc/rft] sd: allocate request_queue on device's local
 numa node
Date: Tue, 23 Oct 2012 19:42:03 +0200
Message-ID: <5086D6EB.7020701@acm.org>
References: <x49pq4axre1.fsf@segfault.boston.devel.redhat.com> <50863D0A.6040800@acm.org> <x49fw556sgu.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:40578 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab2JWRmI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2012 13:42:08 -0400
In-Reply-To: <x49fw556sgu.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 10/23/12 18:52, Jeff Moyer wrote:
> Bart Van Assche <bvanassche@acm.org> writes:
>> Please keep in mind that a
>> single PCIe bus may have a minimal distance to more than one NUMA
>> node. See e.g. the diagram at the top of page 8 in
>> http://bizsupport1.austin.hp.com/bc/docs/support/SupportManual/c03261871/c03261871.pdf
>> for a system diagram of a NUMA system where each PCIe bus has a
>> minimal distance to two different NUMA nodes.
>
> That's an interesting configuration.  I wonder what the numa_node sysfs
> file contains for such systems--do you know?  I'm not sure how we could
> allow this to be user-controlled at probe time.  Did you have a specific
> mechanism in mind?  Module parameters?  Something else?

As far as I can see in drivers/pci/pci-sysfs.c the numa_node sysfs 
attribute contains a single number, even for a topology like the one 
described above.

With regard to user control of the numa node: I'm not sure how to solve 
this in general. But for the ib_srp driver this should be easy to do: 
SCSI host creation is triggered by sending a login string to a sysfs 
attribute ("add_target"). It wouldn't take much time to add a parameter 
to that login string that specifies the NUMA node.

Bart.

