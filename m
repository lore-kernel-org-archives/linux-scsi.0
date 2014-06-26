From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Thu, 26 Jun 2014 12:38:42 -0400
Message-ID: <fbbc6688-5a52-4437-93b1-71e8ff84c36c@email.android.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53AC3402.2080302@acm.org> <1403794551.3572.6.camel@dabdike> <86EE1A5C-8943-4C87-9A79-899DE85971CA@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50455 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250AbaFZQi4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 12:38:56 -0400
In-Reply-To: <86EE1A5C-8943-4C87-9A79-899DE85971CA@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Atchley, Scott" <atchleyes@ornl.gov>
Cc: Bart Van Assche <bvanassche@acm.org>, Sagi Grimberg <sagig@mellanox.com>, "<michaelc@cs.wisc.edu>" <michaelc@cs.wisc.edu>, "<martin.petersen@oracle.com>" <martin.petersen@oracle.com>, "<nab@linux-iscsi.org>" <nab@linux-iscsi.org>, "<roland@kernel.org>" <roland@kernel.org>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, "<target-devel@vger.kernel.org>" <target-devel@vger.kernel.org>, "<linux-rdma@vger.kernel.org>" <linux-rdma@vger.kernel.org>



On June 26, 2014 11:41:48 AM EDT, "Atchley, Scott" <atchleyes@ornl.gov> wrote:
>On Jun 26, 2014, at 10:55 AM, James Bottomley
><James.Bottomley@HansenPartnership.com> wrote:
>
>> On Thu, 2014-06-26 at 16:53 +0200, Bart Van Assche wrote:
>>> On 06/11/14 11:09, Sagi Grimberg wrote:
>>>> +	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
>>> 
>>> Sorry that I just noticed this now, but why is a shift-right and
>ilog2()
>>> used in the above expression instead of just dividing the transfer
>>> length by the sector size ?
>> 
>> It's a performance thing.  Division is really slow on most CPUs.
>> However, we know the divisor is a power of two so we re-express the
>> division as a shift, which the processor can do really fast.
>> 
>> James
>
>I have done this in the past as well, but have you benchmarked it?
>Compilers typically do the right thing in this case (i.e replace
>division with shift).

The compiler can only do that for values which are reducible to constants at compile time. This is a runtime value, the compiler has no way of deducing that it will be a power of 2

James
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
