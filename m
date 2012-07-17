From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] ipr: Reduce queuecommand lock time
Date: Tue, 17 Jul 2012 08:09:05 -0500
Message-ID: <500563F1.8030507@linux.vnet.ibm.com>
References: <201207162048.q6GKm8m3018046@d03av01.boulder.ibm.com> <20120717020308.GA18581@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:53591 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab2GQNLM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 09:11:12 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 17 Jul 2012 07:11:09 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 3B9C219D80FC
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 13:09:54 +0000 (WET)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6HD9lal191714
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 07:09:49 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6HD96F3027515
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 07:09:06 -0600
In-Reply-To: <20120717020308.GA18581@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

On 07/16/2012 09:03 PM, Matthew Wilcox wrote:
> On Mon, Jul 16, 2012 at 03:48:08PM -0500, Brian King wrote:
>> +static int ipr_queuecommand(struct Scsi_Host *shost,
>> +			    struct scsi_cmnd *scsi_cmd)
>>  {
>>  	struct ipr_ioa_cfg *ioa_cfg;
>>  	struct ipr_resource_entry *res;
>>  	struct ipr_ioarcb *ioarcb;
>>  	struct ipr_cmnd *ipr_cmd;
>> +	unsigned long lock_flags = 0;
> 
> You don't need to initialise lock_flags.
> 
> Looking at the rest of the code, you drop the lock in the middle,
> then re-acquire it.  That'll help with hold time, but I'm not convinced
> it'll help with performance.  Have you done performance testing with
> these changes?  I seem to remember we used an eight-socket box to show
> host_lock problems in the past.

We've done performance testing of these patches and they provided
roughly a 25% increase in the number of IOPs we are able to push
through an adapter on Power. This was running on an 8 socket box with
4 way SMT, so 32 separate hardware threads.

One of the main things these patches do is to get the dma map/unmap
call from underneath the host lock. On Power, these calls have
more overhead than on some other platforms, since they end up
resulting in a hypervisor call, which can significantly increase
host lock hold times. 

I'll resend with the change to not initialize the lock flags.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center




