From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Thu, 30 Apr 2015 12:58:50 +0200
Message-ID: <55420AEA.10108@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE4A.30803@sandisk.com>
 <20150430093719.GA23486@infradead.org> <5542034D.5010300@sandisk.com>
 <554204D7.9050204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0095.outbound.protection.outlook.com ([157.56.110.95]:48768
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752243AbbD3K66 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 06:58:58 -0400
In-Reply-To: <554204D7.9050204@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/30/15 12:33, Sagi Grimberg wrote:
> On 4/30/2015 1:26 PM, Bart Van Assche wrote:
>> On 04/30/15 11:37, Christoph Hellwig wrote:
>>> On Thu, Apr 30, 2015 at 10:56:42AM +0200, Bart Van Assche wrote:
>>>> Introduce the helper function srp_wait_for_queuecommand().
>>>> Move the definition of scsi_request_fn_active(). This patch
>>>> does not change any functionality. A second call to
>>>> scsi_wait_for_queuecommand() will be introduced in the next
>>>> patch.
>>>
>>> Can we take a step back here?
>>>
>>> This isn;t something driver should be doing, so we really should take
>>> care of this in the SCSI midlayer.
>>>
>>> Especially given that we don't maintain request_fn_active for blk-mq.
>>
>> Hello Christoph,
>>
>> How about the following:
>> * Modify scsi_target_block() and scsi_target_unblock(...,
>>     SDEV_TRANSPORT_OFFLINE) such that these functions wait until
>>     active queuecommand() calls have finished.
>
> Won't this make scsi_target_unblock a sleeping function? It might
> not fit all the contexts scsi_target_unblock is called.

The only callers in upstream code of scsi_target_block() and 
scsi_target_unblock() I am aware of are the FC, iSCSI and SRP transport 
layers and the drivers that use these transport layers. As far as I can 
see both functions are always called from thread context and without 
holding any spinlocks. A possible alternative to what I proposed in my 
previous e-mail could be to provide a new function that waits for active 
queuecommand() calls and that has to be called explicitly.

Bart.


