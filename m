From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fix oops when removing scsi_host while IO is outstanding
 (and when using scsi_target patches)
Date: Sun, 10 Oct 2004 11:55:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416985B0.4020505@cs.wisc.edu>
References: <416803A4.5000202@cs.wisc.edu> <20041010101406.GB28456@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43207 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S268438AbUJJS4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Oct 2004 14:56:18 -0400
In-Reply-To: <20041010101406.GB28456@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Oct 09, 2004 at 08:28:36AM -0700, Mike Christie wrote:
> 
>>When trying to remove a host while IO is running I will get the folling 
>>warning,
>>and after these messages my log fills up with various oops.
>>
>>Oct  9 04:54:44 mina kernel:  target0:0:0: Illegal state transition 
>><NULL>->cancel
>>Oct  9 04:54:44 mina kernel: Badness in scsi_device_set_state at 
>>drivers/scsi/scsi_lib.c:1713
>>Oct  9 04:54:44 mina kernel:  [<c010585e>] dump_stack+0x1e/0x30
>>Oct  9 04:54:44 mina kernel:  [<f8831316>] scsi_device_set_state+0xc6/0x130 
>>[scsi_mod]
>>Oct  9 04:54:44 mina kernel:  [<f88290fc>] scsi_device_cancel+0x3c/0x263 
>>[scsi_mod]
>>Oct  9 04:54:44 mina kernel:  [<c02c280d>] device_for_each_child+0x4d/0x80
>>Oct  9 04:54:44 mina kernel:  [<f88293c2>] scsi_host_cancel+0x32/0xc0 
>>[scsi_mod]
>>Oct  9 04:54:44 mina kernel:  [<f8829472>] scsi_remove_host+0x22/0x70 
>>[scsi_mod]
>>
>>Note the target dev name and NULL state.
>>
>>Basically, scsi_host_cancel is doing a device_for_each_child thinking it's
>>children are scsi_devices, but in the scsi-target-2.6 tree they are now
>>targets. The attached patch fixes this by just adding the extra
>>device_for_each_child loop to get to the scsi device. It was built against
>>the current scsi-target-2.6 tree.
> 
> 
> What about using shost_for_each_device instead, so you don't have to care
> about the extact implementation details?
> 

Ok, actually did the previous code even do anything?
scsi_remove_host calls scsi_forget_host which calls scsi_remove_device
which does a device_del which in turn does a list_del_init(&dev->node).
Then when we used the driver model iterators in scsi_host_cancel
it did a list_for_each_entry(child, &dev->children, node)
but in scsi_forget_host we had just removed all the devices. I guess
a fix for both scsi-misc-2.6 is needed too. I will write something up.



