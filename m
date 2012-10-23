From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch/rfc/rft] sd: allocate request_queue on device's local numa node
Date: Tue, 23 Oct 2012 12:52:49 -0400
Message-ID: <x49fw556sgu.fsf@segfault.boston.devel.redhat.com>
References: <x49pq4axre1.fsf@segfault.boston.devel.redhat.com>
	<50863D0A.6040800@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50863D0A.6040800@acm.org> (Bart Van Assche's message of "Tue, 23
	Oct 2012 08:45:30 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 10/22/12 21:01, Jeff Moyer wrote:
>> All of the infrastructure is available to allocate a request_queue on a
>> particular numa node, but it isn't being utilized at all.  Wire up the
>> sd driver to allocate the request_queue on the HBA's local numa node.
>>
>> This is a request for comments and testing (I've built and booted it,
>> nothing more).  I believe that this should be a performance win, but I
>> have no numbers to back it up as yet.  Suggestions for workloads to test
>> are welcome.
>>
>> Cheers,
>> Jeff
>>
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index da36a3a..7986483 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1664,7 +1664,8 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>>   	struct request_queue *q;
>>   	struct device *dev = shost->dma_dev;
>>
>> -	q = blk_init_queue(request_fn, NULL);
>> +	q = blk_init_queue_node(request_fn, NULL,
>> +				dev_to_node(&shost->shost_dev));
>>   	if (!q)
>>   		return NULL;
>
> Are you sure this approach will always result in the queue being
> allocated on the same NUMA node as the HCA ? If e.g. a user triggers
> LUN scanning via sysfs the above code may be invoked on another NUMA
> node than the node to which the HCA is connected.

shost->shost_dev should inherit the numa node from the pci bus to which
it is attached.  So long as that works, there should be no concern over
which numa node the probe code is running on.

> Also, if you have a look at e.g. scsi_request_fn() or
> scsi_device_unbusy() you will see that in order to avoid inter-node
> traffic it's important to allocate the sdev and shost data structures
> on the same NUMA node.

Yes, good point.

> How about the following approach ?
> - Add a variant of scsi_host_alloc() that allows to specify on which
>   NUMA node to allocate the shost structure and also that stores the
>   identity of that node in the shost structure.
> - Modify __scsi_alloc_queue() such that it allocates the sdev structure
>   on the same NUMA node as the shost structure.
> - Modify the SCSI LLD of your choice such that it uses the new
>   scsi_host_alloc() call. According to what is appropriate the NUMA node
>   on which to allocate the shost could be specified by the user or could
>   be identical to the NUMA node of the HCA controlled by the SCSI LLD
>   (see e.g. /sys/devices/pci*/*/numa_node). Please keep in mind that a
>   single PCIe bus may have a minimal distance to more than one NUMA
>   node. See e.g. the diagram at the top of page 8 in
>
> http://bizsupport1.austin.hp.com/bc/docs/support/SupportManual/c03261871/c03261871.pdf
>   for a system diagram of a NUMA system where each PCIe bus has a
>   minimal distance to two different NUMA nodes.

That's an interesting configuration.  I wonder what the numa_node sysfs
file contains for such systems--do you know?  I'm not sure how we could
allow this to be user-controlled at probe time.  Did you have a specific
mechanism in mind?  Module parameters?  Something else?

Thanks for your input, Bart.

Cheers,
Jeff
