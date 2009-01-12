From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] iscsi: Kconfig option for debug prints.
Date: Mon, 12 Jan 2009 19:10:59 +0200
Message-ID: <496B79A3.3070700@panasas.com>
References: <496B62B8.3030402@panasas.com> <496B63DF.6010602@panasas.com> <496B68F8.3070103@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <496B68F8.3070103-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Mike Christie wrote:
> Boaz Harrosh wrote:
>> Boaz Harrosh wrote:
>>> Remove the dark ages /* define debug_print */ in code, to use
>>> a Kconfig option. With a system like Kconfig, in code, commented out,
>>> configuration options are slavery and hard work.
>>> (version control, manual edit ... need I say more)
>>>
>>> I've used an "int" config bit-mask so more areas of code can be
>>> selected with one Koption, but mainly so that allmodconfig will
>>> not turn it on.
>>>
>>> bit-1 - will turn on prints for libiscsi.
>>> bit-2 - will turn on prints for libiscsi_tcp & iscsi_tcp.
>>>
>>> More iscsi drivers should use more bits.
>>>
>>> Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
>>> ---
>>>  drivers/scsi/Kconfig        |   15 +++++++++++++++
>>>  drivers/scsi/iscsi_tcp.c    |    7 -------
>>>  drivers/scsi/iscsi_tcp.h    |    6 ++++++
>>>  drivers/scsi/libiscsi_tcp.c |    7 -------
>>>  include/scsi/libiscsi.h     |    3 +--
>>>  5 files changed, 22 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> Mike hi.
>>
>> These are over latest Linus. Sorry I mixed up the branches.
>> If they don't apply to your tree any more, I'll rebase.
>>
> 
> It applies ok.
> 
>> I'm sending these because for too many times I submit some code
>> with iscsi sources edits, because I forget to remove the edits
>> for enabling prints. Please consider for inclusion.
>>
> 
> What about compile time vs load time? Olaf had the attached patch which 
> does it at module load time. It is nicer for users, but I was just 
> worried about maybe there being a perf change with all the new ifs? I 
> was waiting to do some testing to see if there was and change, but did 
> not get around to it. Is that too paranoid (probably other factors like 
> our crappy locking will slow us down more than some ifs for printks right)?
> 

I don't think the performance matters because in his patch it is
still commented out by a config SCSI_ISCSI_DEBUG set to n. So people
can run as today. Though maybe make it an "int" option and not
"bool" because this way allmodconfig will not turn it on. Note
that all distros use allmodeconfig.

And if it is already an "int" it can be a bit-mask which is the default
for a single iscsi module-param which also acts as a bit-mask for all iscsi
drivers. Each driver has a bit.

Sure a module-param could be nice, but if we decide on the final API
we can do a config only now, and add run-time later.

[And for me personally a config option is just good enough. Though I admit
 that for a sysadmin run-time can be very nice]

But please let's do something. Current situation just keeps biting me on
the a.. At just the times when I don't pay attention.

Tell me what you decide and I'll freshen up which ever patch
you want. (Olaf patch has problems, mainly with code placements and
that we added libiscsi_tcp.c, and my above proposition)

Thanks Mike
Boaz
