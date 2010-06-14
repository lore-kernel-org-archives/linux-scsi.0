From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.34 PDC20268 PATA IO error loop makes system unusable
Date: Mon, 14 Jun 2010 09:59:39 +0200
Message-ID: <4C15E16B.5000702@kernel.org>
References: <20100613154808.GA10408@basil.fritz.box> <4C15DDA0.3020409@kernel.org> <20100614075350.GC17092@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100614075350.GC17092@basil.fritz.box>
Sender: linux-ide-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On 06/14/2010 09:53 AM, Andi Kleen wrote:
> On Mon, Jun 14, 2010 at 09:43:28AM +0200, Tejun Heo wrote:
>>> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 f0 08 00 01 00 00
>>> sd 11:0:0:0: [sdd] Unhandled error code
>>> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 f1 08 00 01 00 00
>>> sd 11:0:0:0: [sdd] Unhandled error code
>>> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 f2 08 00 01 00 00
>>>
>>> same messages repeating forever, just with CDB changing occasionally.
>>>
>>> ....
>>>
>>> not stopping until I reset the box.
>>
>> Did you have a lot of dirty pages?  It looks like upper layer is
> 
> Yes, there was a dd running.
> 
>> trying to flush all the dirty buffers and SCSI is a tad bit too
>> verbose about failing each IO w/ DID_BAD_TARGET thus taking a very
> 
> A bit too verbose?  That's really an euphemism ...

Yeap, of course it was. :-)

> During the CDB: Write loop the console was totally unusable!
> 
> And I think the fsyncs in syslogd completely made the performance
> tank.

Console often becomes the bottleneck too when there are a lot of
kernel messages.

> So basically it was a "reset button only" situation.
> 
> When the device is gone what's the point in giving a message 
> more than once? Can't the requests just be silently failed in this
> case?

Yeah, it would be better to somehow summarize those error message
instead of spitting out all of them.

Thanks.

-- 
tejun
