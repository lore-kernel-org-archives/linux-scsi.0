From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: [PATCH RFC] move scsi parts of dm hw handlers
	to	scsi layer
Date: Fri, 21 Jul 2006 13:00:56 -0400
Message-ID: <44C10848.3080509@cs.wisc.edu>
References: <1153480817.8030.15.camel@max>
	<581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
	<44C0BF4C.5060102@cs.wisc.edu> <44C0C0BA.90006@cs.wisc.edu>
	<4880914.1153483821524.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
	<44C0C548.4080806@cs.wisc.edu> <20060721151656.GA10239@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060721151656.GA10239@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Anderson <andmike@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, agk@redhat.com, Patrick Mansfield <patmans@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Mike Christie <michaelc@cs.wisc.edu> wrote:
>> Hannes Reinecke wrote:
>>> Am Fr 21.07.2006 13:55 schrieb Mike Christie <michaelc@cs.wisc.edu>:
>>>
>>>> Mike Christie wrote:
>>>>> Hannes Reinecke wrote:
>>>>>>> The patch below begins to push the scsi hw handler code down to
>>>>>>> the
>>>>>>> scsi
>>>>>>> layer. I only began to covert dm-emc.c and it only hooks in at the
>>>>>>> sense
>>>>>>> decoding in scsi_error.c. I wanted to make sure I was going about
>>>>>>> the
>>>>>>> module loading and binding correctly. With a new target bus we
>>>>>>> could
>>>>>>> do
>>>>>>> some driver model stuff instead, but I was not sure if that was
>>>>>>> appropriate for this?
>>>>>>>
>>>>>> Why don't we use scsi_devinfo for this?
>>>>> I was adding my fields when I noticed this comment:
>>>>>
>>>>>
>>>>> * Do not add to this list, use the command line or proc interface to
>>>>>  add
>>>>>  * to the scsi_dev_info_list. This table will eventually go away.
>>>>>
>>>>>
>>>>>> We have to have some sort of device table anyway as these handlers
>>>>>> are
>>>>>> far from being generic, so any sense code which triggers action on
>>>>>> one
>>>>>> device might be perfectly ok for others.
>>>>> When I was looking for the history of that commet, I thought I read
>>>>> that
>>>>> we are supposed to be moving to some userspace approach that pushes
>>>>> that
>>>>> info down via some magic interface.
>>>>>
>>>> I added this comment at the wrong place. I meant to say I thought we
>>>> are
>>>> supposed to be moving away from the kernel devinfo list to some
>>>> userspace one that gets sent down via the module_param or some new
>>>> magic
>>>> interface.
>>> Or so they claim. I seem to remember some discussion about it; the net
>>> result was the scsi_devinfo will stay with us for the time being.
>>>
>>> Otherwise you'll end up having to configure your kernel / module during
>>> startup. With parameters which are static anyway. Can't say I like it.
>>> And the tricky bit is that these information has to be present prior
>>> to any initialisation, so you basically have to feed it during
>>> modprobe time. Not really clever.
>>>
>> He He fun :)
>>
>> Sticking what we need in devinfo is a lot easier. And I think it makes
>> sense since the devices info we want to bind with is in there already.
>> If nobody says anything, I will send the next version of the path with
>> devinfo integration.
> 
> I think Patrick added the comment and the interface so he can add the
> history. One can use the module or proc interface to pass update devinfo
> information in (the sysfs migration never was done). Well it has the
> drawback stated above it can address the issue that certain devices can be
> supported without a kernel recompile.
> 
> Post storage summit I started creating a hardware handler in SCSI, but for
> some reason that I do not recall I started working on SDEV state model
> change integrated into devinfo. The thought being that devices would come
> up in a standby state and then all the varied commands to determine path
> state could be executed from user space.
> 
> Well it did solve the issue I was trying to address (passive paths
> generating errors on startup), it would need user space assistance with all
> the plus / minus issues that brings.
> 

Yeah, I am fine with all that and have no complaints. How can I complain
when I always pop up with the do it in userspace comment :)

My main focus for this was not really the startup. That was a side
benefit to having the sense and that info in the kernel for failover
requests and IO that is executed when the path is passive or active.

So today, we could use your userspace start up for bring up but we still
need something to do failover and process those results and possibly
process the results of other IO (similar to the emc first IO to the path
case in the patch). For the latter, I think the EMC check_sense tests I
am doing in my patch are already handled by other checks in scsi-ml so
the sense stuff in scsi_emc_clariion.c is not exactly needed. So maybe
we do not need hw handlers for that. As I have said before, I keep
running into this problem where vendors say yes we need it but we do not
have many good examples.

But if scsi-ml's sense decoding is ok by default and we do not need to
override it, this just leaves explicit/manual failover. If we throw that
to userspace along with your strart up code then I guess we do not need
kernel hw handlers at all.

Did you guys end up doing a hw handler that runs in userspace for xdr or
something? Has it worked out? Is there some common code that can be
reused today by any chance? Or is this one of those cases where we are
going too far with putting stuff in userspace do you think?
