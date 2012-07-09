From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Re: [PATCH] fcoe: Remove redundant 'less than zero' check
Date: Mon, 9 Jul 2012 23:50:07 +0000
Message-ID: <4FFB6E2D.7010506@intel.com>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
 <20120705145225.21808.62255.stgit@fritz>
 <20120709162939.9d0481e7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30156 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab2GIXuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2012 19:50:12 -0400
In-Reply-To: <20120709162939.9d0481e7.akpm@linux-foundation.org>
Content-Language: en-US
Content-ID: <C558A14416E2B245A88D91AD59A1A7CE@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 12-07-09 04:29 PM, Andrew Morton wrote:
> On Thu, 05 Jul 2012 07:52:25 -0700
> Robert Love<robert.w.love@intel.com>  wrote:
>
>> strtoul returns an 'unsigned long' so there is no
>> reason to check if the value is less than zero.
>>
>> strtoul already checks for the '-' character deep
>> in its bowels. It will return an error if the user
>> has provided a negative value and fcoe_str_to_dev_loss
>> will return that error to its caller.
> huh, I never knew that.  So if we feed -1 to kstrtoul() it gets treated
> as an error?  That seems a bit surprising.  You're sure about that?
>
>
I believe so.

kstrtoul->kstrtoull->_kstrtoull->_parse_integer

When the call chain ultimately hits _parse_integer it breaks out of 
parsing if it hits a non-numeric or alphabetic character outside of the 
'a' to 'f' range. _kstrtoull notices that the buffer wasn't completely 
parsed and returns an error. I think the error will be -EINVAL.

//Rob