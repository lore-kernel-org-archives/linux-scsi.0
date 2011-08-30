From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
Date: Tue, 30 Aug 2011 23:53:44 +0200
Message-ID: <4E5D5BE8.1020002@fastmail.fm>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp> <20110825101602.GI3286@htj.dyndns.org> <4E58C3BD.3000609@hitachi.com> <20110827102655.GJ2632@htj.dyndns.org> <4E58E905.4020704@hitachi.com> <20110827132044.GN2632@htj.dyndns.org> <CAPXgP12Qn2s5ZS5jHCR-Nw_E9FWkX6E3MXhQ5gy6YEq4Zm8S0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39962 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127Ab1H3Vxt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 17:53:49 -0400
In-Reply-To: <CAPXgP12Qn2s5ZS5jHCR-Nw_E9FWkX6E3MXhQ5gy6YEq4Zm8S0g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com

On 08/28/2011 08:07 PM, Kay Sievers wrote:
> On Sat, Aug 27, 2011 at 15:20, Tejun Heo<tj@kernel.org>  wrote:
>> On Sat, Aug 27, 2011 at 09:54:29PM +0900, Nao Nishijima wrote:
>>>> Hmm... I don't follow.  Why wouldn't it be able to?  All the
>>>> informations are in the log.  It is messy but it's there.  If you want
>>>
>>> In many cases, the script is able to convert the name. However there is
>>> the special case that the logs do not exist in memory and disk due to
>>> the crash except console.
>>
>> Sorry but I still don't get it.  If you can extract the log, the
>> information is there and w/ remote logging (be it via serial or
>> network), the information always has to be there.  Are you talking
>> about the case where somehow only the video console somehow succeeds
>> to print out oops?  I don't think that's a common case as serial (also
>> on IPMI) tends to be pretty robust, often more robust than vide
>> output, and even when such case occurs, the only thing you want is
>> mapping kernel device name to more recognizable information, which
>> isn't difficult at all.  If you wanna do it in a really simple manner,
>> just save udisks --dump output after boot and each hotplug event and
>> write a simple script to search it.
>>
>>>> more structured information, u{dev|disks} already maintain device
>>>> libarary - what maps to what, connected how with what attributes and
>>>> so on.  Sending them off to the log machine as device hotplug events
>>>> occur and consulting it when post-processing log message would work
>>>> fine.  All you need is just some python scripting.  I don't really see
>>>> much point in messing with device names directly.  The only thing is
>>>> that the raw log would be prettier.  I don't think that is useful
>>>> enough to justify changing kernel device names.
>>>
>>> A kernel device names (e.g. sda) is not useful information because it
>>> doesn't always point the same disk at each boot-up time.
>>
>> Eh?  What difference does that make?  Just make the target machines
>> send up-to-date disk config info to the log server.
>>
>>> An alias is just an option and provides the ability to give all
>>> kernel devices a "preferred name".
>>>
>>> By default, dev_printk's will show a kernel device name. They show an
>>> alias only when the user assigns a "preferred name" to an alias.
>>> Even if the persistend device name is used, the device names in logs are
>>> different from the name that the users are using. So, an alias helps the
>>> user identify the disk.
>>
>> Yes, I do understand what it's doing and can see there can be cases it
>> can be somewhat useful but I still think it's too adhoc an approach
>> which doesn't really justify itself.  It just does too little to solve
>> the actual problem and even that 'little' part isn't very trivial - it
>> adds whole lot of policy decisions to make and I'm pretty sure it will
>> cause good amount of havoc w/ all the system tools which currently
>> don't expect block device names to change to some admin determined
>> free format string on the fly.
>
> My take on this in short again:
> The very same thing that needs to store the 'pretty name' in the
> kernel here, can instead just log that name along with the kernel name
> to /dev/kmsg. It ends up in the kernel log buffer and is the marker to
> safely match all later log entries.
>
> This can be done today, even on many years old distros, with a single
> udev rule and a tiny program. It needs no kernel or tool changes and
> gives almost all the benefits of the 'pretty name' infrastructure.

Could you please explain exactly how? Simply replace sd{X} by the 
preferred name in /dev/kmsg? How do make make sure you do not replace 
something that is not supposed to be replaced? I think unless you plan 
to modify existing kernel device message you cannot, as sd{X} is too 
general.
And how does /dev/kmsg solve the serial console problem?

However, I think a real technical issue with any udev device name rules 
remains - it often does not work well with multipath devices. Alua 
partly solves that problem, but only if there is a direct connection to 
each of the alua controllers. But if there is a switch in between, there 
are often several devices with the same alua score. And the situation is 
even worse with multipath hardware that does not know alua at all.
So for many multipath devices it probably would not make sense to set 
alias names. But especially on those system you often would like to have 
suitable alias names, as it gets a bit chaotic without (I had to deal 
with 30 or even 60 devices x 8 paths in the past...).

Cheers,
Bernd
