From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
Date: Wed, 21 Dec 2011 14:48:09 +0800
Message-ID: <4EF18129.7030407@tao.ma>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6> <4EF17DC4.5010008@tao.ma> <alpine.SOC.1.00.1112210835010.6858@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54348 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752162Ab1LUGsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 01:48:14 -0500
In-Reply-To: <alpine.SOC.1.00.1112210835010.6858@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>

On 12/21/2011 02:36 PM, Meelis Roos wrote:
>>> -	if (unlikely(tag >= bqt->max_depth)) {
>>> +	if (WARN_ONCE(tag >= bqt->real_max_depth,
>>> +		      "%s: tag %d greater than tag map size: %d\n",
>>> +		      __func__, tag, bqt->real_max_depth)) {
>>>  		/*
>>>  		 * This can happen after tag depth has been reduced.
>> Please also change the comments here since it should never happen in the
>> right workload.
> 
> What do you mean by right workload? Normal workload?
yeah, so real_max_depth is the maximum depth we ever have. So in normal
case(shrinking queue depth is also a normal user case), we should never
arrive here. In another word, if tag >= real_max_depth, we should have a
bug in the kernel.

Thanks
Tao
