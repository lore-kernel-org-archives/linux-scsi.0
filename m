From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: SCSI mid layer and high IOPS capable devices
Date: Fri, 14 Dec 2012 08:22:26 +0800
Message-ID: <005c01cdd991$18d59bf0$4a80d3d0$@com>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org> <20121213172513.GH20898@beardog.cce.hp.com> <50CA0692.2010903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:52172 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2LNAih (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2012 19:38:37 -0500
In-Reply-To: <50CA0692.2010903@acm.org>
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Bart Van Assche' <bvanassche@acm.org>, scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/13/12 18:25, scameron@beardog.cce.hp.com wrote:
> On Thu, Dec 13, 2012 at 04:22:33PM +0100, Bart Van Assche wrote:
>> On 12/11/12 01:00, scameron@beardog.cce.hp.com wrote:
>>> The driver, like nvme, has a submit and reply queue per cpu.
>>
>> This is interesting. If my interpretation of the POSIX spec is 
>> correct then aio_write() allows to queue overlapping writes and all 
>> writes submitted by the same thread have to be performed in the order 
>> they were submitted by that thread. What if a thread submits a first 
>> write via aio_write(), gets rescheduled on another CPU and submits a 
>> second overlapping write also via aio_write() ? If a block driver 
>> uses one queue per CPU, does that mean that such writes that were 
>> issued in order can be executed in a different order by the driver 
>> and/or hardware than the order in which the writes were submitted ?
>>
>> See also the aio_write() man page, The Open Group Base Specifications 
>> Issue 7, IEEE Std 1003.1-2008 
>>
(http://pubs.opengroup.org/onlinepubs/9699919799/functions/aio_write.html).
>
> It is my understanding that the low level driver is free to re-order 
> the i/o's any way it wants, as is the hardware.  It is up to the 
> layers above to enforce any ordering requirements.  For a long time 
> there was a bug in the cciss driver that all i/o's submitted to the 
> driver got reversed in order -- adding to head of a list instead of to 
> the tail, or vice versa, I forget which -- and it caused no real 
> problems (apart from some slight performance issues that were mostly
masked by the Smart Array's cache.
> It was caught by firmware guys noticing LBAs coming in in weird orders 
> for supposedly sequential workloads.
>
> So in your scenario, I think the overlapping writes should not be 
> submitted by the block layer to the low level driver concurrently, as 
> the block layer is aware that the lld is free to re-order things.  (I 
> am very certain that this is the case for scsi low level drivers and 
> block drivers using a request_fn interface -- less certain about block 
> drivers using the make_request interface to submit i/o's, as this 
> interface is pretty new to me.

As far as I know there are basically two choices:
1. Allow the LLD to reorder any pair of write requests. The only way
    for higher layers to ensure the order of (overlapping) writes is then
    to separate these in time. Or in other words, limit write request
    queue depth to one.
2. Do not allow the LLD to reorder overlapping write requests. This
    allows higher software layers to queue write requests (queue depth
    > 1).

 From my experience with block and SCSI drivers option (1) doesn't look
attractive from a performance point of view. From what I have seen
performance with QD=1 is several times lower than performance with QD > 1.
But maybe I overlooked something ?



Bart.

I was seen low queue depth improve sequential performance, and high queue
depth improve random performance.

Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

