From: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Subject: Re: [RFC PATCH] scsi: Add failfast mode to avoid infinite retry loop
Date: Mon, 26 Aug 2013 18:34:46 +0900
Message-ID: <521B2136.3020409@hitachi.com>
References: <20130819093925.7867.19221.stgit@ltc223.sdl.hitachi.co.jp>  <1376922616.2069.9.camel@dabdike.int.hansenpartnership.com>  <5213172E.1060905@hitachi.com>  <1377022167.3872.13.camel@localhost.localdomain>  <52172721.1040203@hitachi.com>  <1377263977.2095.1.camel@dabdike> <1377286615.3872.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377286615.3872.25.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(2013/08/24 4:36), Ewan Milne wrote:
> On Fri, 2013-08-23 at 06:19 -0700, James Bottomley wrote:
>> On Fri, 2013-08-23 at 18:10 +0900, Eiichi Tsukata wrote:
>>> Yes, basically the device should be offlined on error detection.
>>> Just offlining the disk is enough when an error occurs on "not" os-installed
>>> system disk. Panic is going too far on such case.
>>>
>>> However, in a clustered environment where computers use each its own
>>> disk and
>>> do not share the same disk, calling panic() will be suitable when an
>>> error
>>> occurs in system disk.
>>
>> However, when not in a clustered environment, it won't be.  Decisions
>> about whether to panic the system or not are user space policy, and
>> should not be embedded into subsystems.  What we need to do is to come
>> up with a way of detecting the condition, reporting it and possibly
>> taking some action.
>>
>>>   Because even on such disk error, cluster monitoring
>>> tool may not be able to detect the system failure while heartbeat can
>>> continue
>>> working.
>>> So, I think basically offlining is enough and also, panic is necessary
>>> on some cases.
>
> The way I have seen this done in such a clustered environment is to have
> the heartbeat agent on each system periodically attempt to access the
> disk.  If that I/O hangs, other systems will see loss of heartbeat.
> You really don't want to panic the kernel.  Among other things, it may
> make it difficult to get the system up again later for long enough to
> figure out what is wrong.
>

Sounds good.
Disk access on each hreartbeat is reasonable to detect I/O error.

But by such a way, can you distinguish indefinite command retry?
I'd like to tell indefinite retry from other disk errors.

I'm now considering printk error message on retry count excess.
There should be some reporting mechanism in kernel.

Eiichi
