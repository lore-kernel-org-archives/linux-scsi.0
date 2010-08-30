From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 31 Aug 2010 00:47:10 +0400
Message-ID: <4C7C18CE.5020103@vlnb.net>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>	 <1282144271.3035.31.camel@mulgrave.site>	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>	 <4C73DA15.2010207@vlnb.net> <1282661876.2993.20.camel@mulgrave.site>	 <4C7421FB.2060007@vlnb.net>	 <1282685014.32007.51.camel@haakon2.linux-iscsi.org>	 <4C76CA57.3050405@vlnb.net>	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>	 <4C79484B.3090607@vlnb.net> <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

Nicholas A. Bellinger, on 08/29/2010 12:47 AM wrote:
>>>>> As mentioned explictly earlier in this thread, my WIP code for the
>>>>> kernel level subsystem backstore using STGT kernel<->    user CDB
>>>>> passthrough logic in drivers/target/target_core_stgt.c is a item on
>>>>> my TODO list, but I will repeat, is NOT being tagged as a mainline
>>>>> .37 item.
>>>>
>>>> Hmm, I can't understand, if target_core_stgt.c is "NOT being tagged as a
>>>> mainline .37 item", then the STGT ABI compatibility for being a drop in
>>>> replacement for STGT isn't a requirement? Or am I missing something?
>>>
>>> Sorry, but I have no idea what you are trying to conjour up here.
>>>
>>> To spell out (again) the TCM/LIO<->STGT compatibility stages that have
>>> been persued pubically over the last months:
>>>
>>> I) Create proper userspace tgt.git SG_IO and BSG passthrough into
>>>      TCM_Loop v4 using high-level multi-fabric WWPN emulation so that TCM
>>>      Core SPC-4 kernel emulation is exposed to STGT user fabrics, eg:
>>>      userspace fabric module ->   kernel backstore passthrough.  (DONE
>>>      for .37, and STGT passthrough + BSG backstore support merged into
>>>      tgt.git by Tomo-san)
>>>
>>> II) Complete target_core_stgt.c TCM subsystem plugin for kernel ->   user
>>>       CDB ->   LUN passthrough building upon existing
>>>       drivers/scsi/scsi_tgt_*.c code.  (WIP for .38, made available
>>>       initially as a seperate standalone .ko module in lio-core-2.6.git)
>>
>> That would mean that if LIO merged in .37:
>>
>> 1. It would be merged _without_ STGT ABI compatibility, i.e. one of the
>> requirements for a new SCSI target infrastructure merge is violated.
>>
>
> Sorry, but you are completely wrong here.  This has nothing to do with a
> question of STGT kernel 'ABI compatibility' (because there is only one
> mainline user!), but has everything to do with being able to expose TCM
> kernel level SPC-4 emulation, and make this logic available to existing
> userspace fabrics in tgt.git.  Again, we are talking about userspace
> STGT fabric module<->  TCM kernel backstore support for .37, which has
> already been merged by into tgt.git, and being used by other STGT users
> for SG_IO and BSG passthrough.

You are proving that I'm actually right ;). In the beginning of this 
thread I offered a transition path from STGT to SCST and James rejected 
it, because it didn't confirm a requirement that a new SCSI target 
infrastructure must be STGT ABI compatible. But latter James left this 
decision up to the STGT developers and now you are confirming that they 
don't see any ABI compatibility issues, so my transition path fully 
confirms all the requirements.

>> 2. It would _not_ be a drop in replacement for STGT, because STGT's
>> drivers/scsi/scsi_tgt_*.c code would stay in the kernel. Those would
>> effectively mean that another requirement for a new SCSI target
>> infrastructure merge would be violated: there would be 2 SCSI target
>> infrastructures in the kernel and any STGT in-kernel driver (for
>> instance, built as an outside module) would continue working. My
>> understanding of "drop in replacement" is "one out, another in at once".
>
> Sorry, but this is just more generic handwaving on your part.  What
> constitutes a 'drop in replacement' for STGT is a decision that was to
> be made by the STGT developers, not by you.  target_core_stgt.c is an
> extraordinarly transparent method of bringing drivers/scsi/scsi_tgt_*
> logic into the TCM Core HBA/DEV design, and allows us to build upon and
> improve the existing mainline kernel code.

I'm not deciding anything, I'm only analyzing and seeing a contradiction:

1. James wants only one SCSI target infrastructure in the kernel.

2. If drivers/scsi/scsi_tgt_*.c left after the merge of the new SCSI 
target infrastructure, it would mean that STGT left as well => 2 SCSI 
target infrastructure in the kernel.

For me it doesn't matter. I just want clear rules, hence asking for 
clarification.

> It is obvious to even an casual observer from watching the TCM/LIO patch
> series that have been flying across the linux-scsi wire the last 24
> months that the major features (including PR and ALUA, and new fabric
> module drivers) have been developed individual feature bit by feature
> bit using a distributed git workflow in a bisectable manner.  Each
> series was produced in such a manner that each patch could be reviewed
> individually by those interested parties.

That's a nice, but quite meaningless LIO advertisement. SCST is using 
the same bisectable, distributed and reviewable workflow. If we had a 
kernel.org git account, we would use it as well, but so far we are happy 
with SF.net hosting. BTW, how was you able to get the git account 
without a single patch merged in the kernel? You must have good 
connections in the kernel community.

> This is the big difference between our respective development processes.
> This is the case not only for SCSI feature bits that TCM/LIO and SCST
> share, but for features in TCM/LIO v4 that are unique and not available
> in any other target implemention, anywhere.  And yes, I am most
> certainly talking about code beyond just the SCSI level fabric emulation
> bits you are mentioning above.

Can you list us benefits for an average user of that work?

>> But all my attempts to explain my view are just blindly
>> ignored without any considerations, so I have no idea how more I can
>> explain it.
>>
>
> Then I suggest you learn a better way of communicating your ideas if you
> really want to work with members of the LIO/STGT development
> communities.
>
> First, I suggest you start explaining your ideas with actual kernel code
> that is 1) human readable and 2) presented in such a manner that makes
> it accessable for others with skills possibly different (and greater)
> than your own to review and give feedback.

I have sent patches twice, the second time few months ago. Weren't they 
human readable and accessible for kernel developers who are experts in 
dealing with sent by e-mail patches?

Thanks,
Vlad
