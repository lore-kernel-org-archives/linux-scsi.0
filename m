From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Thu, 30 Apr 2015 12:26:21 +0200
Message-ID: <5542034D.5010300@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE4A.30803@sandisk.com>
 <20150430093719.GA23486@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0054.outbound.protection.outlook.com ([157.56.110.54]:59993
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750710AbbD3K03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 06:26:29 -0400
In-Reply-To: <20150430093719.GA23486@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/30/15 11:37, Christoph Hellwig wrote:
> On Thu, Apr 30, 2015 at 10:56:42AM +0200, Bart Van Assche wrote:
>> Introduce the helper function srp_wait_for_queuecommand().
>> Move the definition of scsi_request_fn_active(). This patch
>> does not change any functionality. A second call to
>> scsi_wait_for_queuecommand() will be introduced in the next
>> patch.
>
> Can we take a step back here?
>
> This isn;t something driver should be doing, so we really should take
> care of this in the SCSI midlayer.
>
> Especially given that we don't maintain request_fn_active for blk-mq.

Hello Christoph,

How about the following:
* Modify scsi_target_block() and scsi_target_unblock(...,
   SDEV_TRANSPORT_OFFLINE) such that these functions wait until
   active queuecommand() calls have finished.
* Ensure that this approach works not only for the traditional
   block layer but also for blk-mq.

With these changes it won't be necessary anymore to have something like 
srp_wait_for_queuecommand() in the SRP transport layer.

Bart.

