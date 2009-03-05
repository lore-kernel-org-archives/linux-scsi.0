From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Q: "- PDU header Digest" fetaure
Date: Thu, 05 Mar 2009 11:42:48 -0600
Message-ID: <49B00F18.5000607@cs.wisc.edu>
References: <49A52E04.4844.B205C8A@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <49A5821B.6070506@cs.wisc.edu> <49AF9897.1070500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36873 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbZCERm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 12:42:57 -0500
In-Reply-To: <49AF9897.1070500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> Hi Mike, list.
> 
> Mike Christie has pointed out of a serious problem for us which we need
> the list help of.
> 
> It started with a question by Ulrich Windl of why data-digests are
> not supported/recommended by open-iscsi installations and distros.
> 
> [iscsi data-digests is when the complete payload of an iscsi transaction
>  initiator-target is signed by an HMAC(SHA1) both read/write]
> 
> Mike Christie wrote:
>> Ulrich Windl wrote:
>> Data digests were working but when upstream did the scatterlist changes 
>> to the kernel it broke data digests. We have not found the cause yet.
>>
>> For Red Hat, they do not support them for different reasons depending on 
>> the version and arch. For example in RHEL5, the big endien crypto digest 
>> code is busted. It needs a fix from upstream, and I think in general 
>> there is still some other bugs in the digest code.
>>
>>> I see the performance impact, but is there another reason against implementing it? 
>>> Can I safely activate it on the target, or will it cause problems?
>>>
>> Another reason a lot of distros do not support it is because a common 
>> problem we always hit is that users will write out some data, then start 
>> modifying it again. But the kernel will normally not do do a sync write 
>> when you do a write. So once the write() returns, the kernel is still 
>> sending it through the caches, block, scsi, and iscsi layers. If you are 
>> writing to the data while the it is working its way through the iscsi 
>> layers, the iscsi layer could have done the digest calculation, then you 
>> could modify it and now when the target checks it the digest check will 
>> fail. And so this happens over and over and you get digest errors all 
>> over the place and the iscsi layers fire their error handling and retry 
>> and retry, and in the end they just say forget it and do not support 
>> data digests.
>>
> 
> Mike if what you said in the last paragraph is true, about FS modifying the data
> while the request is in-flight, then it does not explain your statement above
> about, things getting worse around the scatterlist changes.

They are two separate issues.

Around the time of the scatterlist changes I will get an oops in the 
digest calculation code (when we call into the crypto callouts), or in 
newer kernels the oops went away and now I will get data digest errors. 
I am still trying to narrow down the commit and line and make sure that 
the oops is fixed and did not turn into a digest error or if maybe I am 
hitting a real digest error.

The second issue is that we normally do zero copy for writes. I do not 
think it is FS bug or net bug or a bug in the iscsi layer. Maybe more of 
a bug in what the user expects (who reads the man page for write() to 
check if the data is committed to disk when write() returns). We 
discussed this a couple times. For open-iscsi we tried to close the gap, 
by not doing zero copy writes when data digests are used. And a long 
long time ago this was discussed for linux-iscsi, and I think that is 
one of the reasons we added DID_IMM_RETRY to the scsi layer (we can then 
avoid the 5 retry limit in this case and retry until it is resolved).



> 
> The way I see it there can be two fundamental problems:
> 1. The FS is permitted to (or sinfully) modifies pages of memory while a request to
>    write these pages is already in-flight. fsdevel guys might want to comment on that?
>    Mike have you observed these problems with a particular file system?
>    I can anticipate such a problem arising in a memory-mapped IO, while a page-cache
>    write-back is in progress. Is that so? is Linux not safe in this regard? If so
>    how does DM & MD do there raid parity calculations? do they copy the data?
> 
> 2. iSCSI releases the request too soon, before the all data was actually used up by the
>    network stack, and is allowing the FS to continue modifying these pages.
>    This is a serious problem which means that there can be crashes and data corruption even
>    if data-digest are not used.
>    Actually we did move not long ago from copy of network data to been completely copy-less
>    could that be the point in time things stopped working?
> 
> 3. Plain coding bug, but I could not find any.
> 
> I know in the passed that data-digests are a grate tool for finding bugs that otherwise can
> go undetected, it happened to me several times in the passed. All of these cases reviled a flaw
> in the code, do to rebasing, things changing, plain programmer bugs.
> 
> Mike, I'm running here a plain iscsi initiator-target setup and the regression tests, and it
> runs. What setup and tests did you run to trigger these digest retries, I would like to
> reproduce this here, and investigate.
> 

The open-iscsi/test regression script and dat file. Once the section 
with data digests runs I hit the oops/digest error. I am not sure if I 
ever hit the second zero copy write issues. I might be hitting that now. 
Like I said, I have not had time to check if the oops turned into a 
digest error when it should not or if I am hitting the zero copy issue.
