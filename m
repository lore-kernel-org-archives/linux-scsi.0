From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/2] virtio-scsi: first version
Date: Mon, 19 Dec 2011 14:11:42 +0100
Message-ID: <4EEF380E.6040101@redhat.com>
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com> <1324296188-3426-2-git-send-email-pbonzini@redhat.com> <4EEF2C86.6010003@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EEF2C86.6010003@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On 12/19/2011 01:22 PM, Hannes Reinecke wrote:
>> +	case VIRTIO_SCSI_S_UNDERRUN:
>> +		set_host_byte(sc, DID_ERROR);
>> +		break;
> Hmm. Not sure this is correct.
> UNDERRUN could be a valid state, eg it is quite common to send
> an INQUIRY with a length of 255 bytes. And only evaluate the
> bytes which are actually send back.

This happens when you send an INQUIRY with a sglist of 255 bytes and an 
ALLOCATION LENGTH of 300 bytes.  The spec says "VIRTIO_SCSI_S_UNDERRUN 
[is returned] if the content of the CDB requires transferring more data 
than is available in the data buffers".

> And, it's not good style to match the same DID_XXX error code to
> several internal errors. I would prefer having a 1:1 match for
> VIRTIO_SCSI_S_XXX and DID_XXX error codes.

There is no DID_XXX value for underrun, but it's quite useful to have it 
diagnosed separately in traces.

>> +static struct scsi_host_template virtscsi_host_template = {
>> +	.module = THIS_MODULE,
>> +	.name = "Virtio SCSI HBA",
>> +	.proc_name = "virtio_scsi",
>> +	.queuecommand = virtscsi_queuecommand,
>> +	.this_id = -1,
>> +
>> +	.can_queue = 1024,
>> +	.dma_boundary = UINT_MAX,
>> +	.use_clustering = ENABLE_CLUSTERING,
>> +};
>> +
> Hmm. Apparently you support more than one LUN, yet no
> ->slave_alloc() callback is present. So how do you scan the bus here?

What does slave_alloc have to do with scanning?  I don't need hostdata, 
so I don't have slave_alloc.

Scanning is here:

         err = scsi_add_host(shost, &vdev->dev);
         if (err)
                 goto scsi_add_host_failed;

         scsi_scan_host(shost);

> Do you actually have a working backend implementation?

Hmm... yes, of course...

Paolo
