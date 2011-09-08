From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Thu, 08 Sep 2011 09:00:58 +0900
Message-ID: <4E6805BA.9040402@ce.jp.nec.com>
References: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org> <4E4A53F0.9040104@ce.jp.nec.com> <4E4CD737.4020402@ce.jp.nec.com> <20110831195022.GE4004@oc1711230544.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37278 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab1IHAEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2011 20:04:04 -0400
In-Reply-To: <20110831195022.GE4004@oc1711230544.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, jaxboe@fusionio.com, roland@purestorage.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.ne>

Hello,

On 09/01/11 04:50, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Aug 18, 2011 at 06:11:19PM +0900, Jun'ichi Nomura wrote:
>> Actually, Tejun has posted a patch to replace
>> execute_in_process_context() with queue_work()
>> and asking your review:
>>
>>   [PATCH RESEND] scsi: don't use execute_in_process_context()
>>   https://lkml.org/lkml/2011/4/30/87
>>
>> Do you think you can take the patch and revert the move
>> of scsi_free_queue()?
> 
> I've tested with your suggestion (reverting the move of scsi_free_queue)
> and it works like a charm. I did not get any oops after that. I tested
> with a multipath setup on top of two iscsi targets. Using dd after
> logging out of some of one of the iscsi targets would trigger the oops.
> With this patch, it could not be triggered anymore.

Thank you for testing and the report.

Since scsi_free_queue() frees elevator, calling it while there
still is a user of the elevator has no way to work.
Either we should call it later (like the above suggestion)
or change scsi_free_queue not to free the elevator
(James posted a patch early in this thread).

I think the latter approach could be nice if it worked.
But if not, the former approach should be taken.
Without fix, a path failure can cause a panic. This is bad...

Best regards,
-- 
Jun'ichi Nomura, NEC Corporation
