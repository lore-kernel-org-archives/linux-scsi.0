From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: scsi-mq performance check
Date: Fri, 18 Dec 2015 16:19:31 +0100
Message-ID: <56742403.7000108@sandisk.com>
References: <56741F04.3070506@huawei.com> <56742168.6030200@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0070.outbound.protection.outlook.com ([157.56.110.70]:10045
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753285AbbLRPTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 10:19:38 -0500
In-Reply-To: <56742168.6030200@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>, bart.vanassche@sandisk.com, hch@infradead.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/18/2015 04:08 PM, Hannes Reinecke wrote:
> On 12/18/2015 03:58 PM, John Garry wrote:
>> Hi,
>>
>> I have started to enable scsi-mq on the HiSilicon SAS driver.
>>
>> Are there hints/checks I should use to make sure it is configured
>> correctly/optimally? In my initial testing I have seen some
>> performance improvements, but none like what I have seen in
>> presentations.
>>
> The whole thing is build around having symmetric submit and receive
> queues, so that we can tack a send/receive queue pair to the same CPU.
> With that we can ensure that we don't have any cache invalidation, as
> the request is already in the cache for that CPU when the completion is
> recieved. _And_ we can get rid of most spinlocks as other CPUs cannot
> access our request.
>
> So make sure to have the submit and receive queues properly done, and
> ensure you don't have any global resources within your driver which
> needs to be locked. Or move access to those resources out of the fast path.

Hello John,

It's great news that you started looking into scsi-mq support :-) As 
Hannes wrote, if the performance improvement is not as big as you 
expected this could be caused e.g. by lock contention. Are you familiar 
with the perf tool ? The perf tool can be a great help to verify whether 
lock contention occurs and also which lock(s) cause it.

Bart.

