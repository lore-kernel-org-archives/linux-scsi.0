From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] [PATCH] qla4xxx driver resubmission
Date: Thu, 21 Sep 2006 13:35:35 -0500
Message-ID: <4512DB77.7090908@cs.wisc.edu>
References: <0BB3E5E7462EEA4295BC02D49691DC074144B0@AVEXCH1.qlogic.org> <4512D5D0.2040209@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:63627 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750984AbWIUSfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 14:35:53 -0400
In-Reply-To: <4512D5D0.2040209@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: David Somayajulu <david.somayajulu@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>

James Smart wrote:
> 
> 
> David Somayajulu wrote:
>>> Why does your LLD need to reach up into the block layer to find an i/o
>> ?
>> Block layer tagging was the gating item in the previous submission.
>> Going over the conversation on the linux-scsi reflector on STEX driver
>> in this aspect, led us to believe that there should not be any driver
>> level book-keeping of outstanding commands to the HBA. This was the
>> reason for creating scsi_host_find_tag() in scsi_tcq.h (in the patch
>> titled [RFC] [PATCH] helper function for retrieving scsi_cmd given
>> hostbased block layer tag)
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=115871027627964&w=2
>>
>> James, would you mind letting us know if block-layer tagging in your
>> opinion simply meant using the scsi_cmd->request->tag and let the driver
>> do the book-keeping of out-standing commands to HBA (like stex driver)
>> or is it along the lines we have implemented.
> 
> Well, in general, I've been working on stuff that has little use for the
> tags, so they aren't that meaningful. I can certainly see some
> implementations
> that can benefit.
> 
> But, on a newish transport like iSCSI, I'm surprised. There's lots of
> house-keeping that has to be done with resets and task management that
> makes
> me believe it's better/easier with local structures. I also know that I
> like


The tag and its mapping to the request and scsi command have to exist
for the life of the scsi command. Are you thinking we may have cases
where the LLD releases the scsi command (and then scsi-ml releases the
command and request) but the LLD still needs the local command structure
(some driver specific struct) and some mapping to a tag? If so then the
block layer tagging in general will not work. Once we release the
request then the tag number can be reallocated.


> to double-check my hardware (based on local structure) rather than blindly
> trusting job handles. I also believe there will be locking issues or data
> structures in flight issues between the block layer and LLDD that will
> be ugly.
> 
> I wanted some justification. The new block layer function hasn't been
> needed
> in the past and I thought it a rather odd thing to add.
> 

It was not needed because stex just preallocated a local array of its
command structs and uses the tag to access that struct. qla4xxx uses a
mempool and so it could allocate a array for the mapping but then we
have something very similar to what the block layer and scsi provide in
its tag_map.

If you do queue based tagging and use the tag number and do not
preallocate your commands then there is a lookup function for you do use.



