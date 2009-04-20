From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] LSF: Multipathing and path checking question
Date: Mon, 20 Apr 2009 14:28:23 -0500
Message-ID: <49ECCCD7.3070200@cs.wisc.edu>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de> <49E89866.50205@cs.wisc.edu> <49EC2B65.1050508@suse.de> <49ECC8BB.9020906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46955 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbZDTT2r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 15:28:47 -0400
In-Reply-To: <49ECC8BB.9020906@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Hannes Reinecke wrote:
>>> Today, instead of #2, the Red Hat multipath tools guy and I were talking
>>> about doing a probe with SG_IO. For example we would send down a path
>>> tester IO and then wait for it to be failed with DID_TRANSPORT_FAILFAST.
>>>
>> No. this is exactly what you cannot do. SG_IO will be stalled when the
>> sdev is BLOCKED and will only return a result _after_ the sdev 
>> transitions
>> _out_ of the BLOCKED state.
>> Translated to FC this means that whenever dev_loss_tmo is _active_ (!)
>> no I/O will be send out neither any I/O result will be returned to 
>> userland.
>>
> 
> That is not true anymore. When fast io fail fires, the sdev and rport 
> will be blocked, but the the fc class will call into the LLD to have it 

I miswrote that. The rport will be show blocked state, but when fast io 
fail tmo fires, fc_terminate_rport_io will unblock the sdev, and the fc 
class chkready will fail any IO sent to it and of course 
terminate_rport_io will fail IO in the driver like I said below. And 
then you do not need a terminate_rport_io callback to have the fast io 
fail tmo now. If you set that timer at least IO in the block queue and 
new IO will be failed.


> fail any IO still running in the driver. The FC class will then fail any 
> IO in the block queues, and then it will also fail any new IO sent to it.
> 
> With your patch to have multipath-tools set fast io fail for multipath, 
> then we should always get the IO failed before dev_loss_tmo fires.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

