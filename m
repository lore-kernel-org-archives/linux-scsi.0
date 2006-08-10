From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH ver3 3/4] qla4xxx: use dev_xxx on some pci/dma resource
 alloc warning and error printks
Date: Thu, 10 Aug 2006 05:52:50 -0400
Message-ID: <44DB01F2.9000101@cs.wisc.edu>
References: <20060805225156.9557.99072.stgit@bebe.enoyolf.org> <20060805225227.9557.30796.stgit@bebe.enoyolf.org> <20060809230550.480743@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:20647 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161159AbWHJKxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 06:53:05 -0400
In-Reply-To: <20060809230550.480743@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Doug Maxey wrote:
> On Wed, 09 Aug 2006 13:52:07 EDT, Mike Christie wrote:
> ...
>>> @@ -836,9 +825,8 @@ static int qla4xxx_mem_alloc(struct scsi
>>>  	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
>>>  					 mempool_free_slab, srb_cachep);
>>>  	if (ha->srb_mempool == NULL) {
>>> -		ql4_printk(KERN_WARNING, ha,
>>> -			   "Memory Allocation failed - SRB Pool.\n");
>>> -
>>> +		dev_warn(&ha->pdev->dev,
>>> +			 "Memory Allocation failed - SRB Pool.\n");
>>>  		goto mem_alloc_error_exit;
>> Sorry for the late response on this one. As you know I was out for a
>> while and I was waiting to get internet access yesterday.
>>
>> For these host messages, do we want something like the sdev_printk and
>> starget_printk or does it really make more sense to use the pci bus id
>> for the message prefix? What about other scsi host messages, will they
>> always go with the pci bus id or some scsi-ml id? And even if we want to
>> print out the pci bus id as the prefix instead of some scsi info, should
>> we still have some scsi wrapper?
>>
>  
> I do agree that iscsi_transport sessions could use a new macro.
> 
> My intention in this instance was to go with the widely used idiom, and 
> to not have a driver specific one.  Was trying to replace
>  #define ql4_printk(level, ha, format, arg...)			\
>      dev_printk(level, &((ha)->pdev->dev), format, ## arg)
> 
> But to follow on from irc, one more pass at this to help me clarify and
> understand what is need here.
> 
> dev_xxx is a wrapper around dev_print(xxx ...).  
> 
> In the specific instance above, this should print
> scsiN arg...

I think the ones in qla4xxx_mem_alloc print

%pci_id: arg...

> 
> Since qla4xxx_mem_alloc() is for the host, would an sdev_printk be
> the right thing?  I don't believe we have any context of a target.

I do not think so. To answer the sdev_printk question for future
reference and maybe to clear things up, I think sdev_printk is for
struct scsi_devices so it should be used for messages about a scsi
device. I think where we may be missing each other on this is that sdev
is a common abbreviation for the scsi_device (as in scsi SPEC logic
unit). It is not a abbreviation for scsi device as in any old scsi
object that has a struct device in it or is a device that scsi messes
with. So maybe in functions like the device reset eh callback we could
use sdev_printk. For functions just interacting with the scsi host that
want to print something about the host you would not.

But to really answer what we should have been taking about, I think just
using dev_printk is probably ok for now. When you said in some other
mail, that you thought we needed to use dev_printk, I thought you meant
that we needed to covert all the messages to dev_printk or one of the
scsi wrappers around it. After reading the mail above that you are just
removing the needless ql4_printk wrapper, I think just replacing
ql4_printk usage with dev_printk is ok for now.

> Of course that may be a misunderstanding on my part.
> 
> For this driver, I don't see any instances of a scsi_target.  
> 

The driver does not really deal with struct scsi_targets. The driver
interacts with structs like iscsi_sessions or iscsi_connections. The
iscsi_session hides most of the struct scsi_target details from the
driver. My mention of the scsi target was just because there is a
starget_printk and I was wondering if we need a shost_printk that the
LLD could use and that would complete the API.

For the iscsi conversion comment on irc, in scsi_transport_iscsi.c, we
do dev_printk(&session->dev and dev_printk(&connection->dev, and we
could maybe use some wrapper around them (like a iscsi_conn_printk() and
iscsi_sess_printk() that take a session and connection) like is done for
scsi_target and scsi_device structs and we could then use that in
libiscsi and iscsi_tcp and iscsi_iser. Right now in some of the iscsi
code we have some silly error messages that just spit out a error but do
not tell you what session, connection or host or device it is for.
