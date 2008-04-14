From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3 ver3] block layer extended-cdb support
Date: Mon, 14 Apr 2008 15:22:21 +0300
Message-ID: <48034C7D.8050506@panasas.com>
References: <480328BD.7050206@panasas.com>	<20080414200431M.tomof@acm.org>	<48033FED.5060307@panasas.com> <20080414210821S.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:47899 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYDNMYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2008 08:24:04 -0400
In-Reply-To: <20080414210821S.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, pw@osc.edu

On Mon, Apr 14 2008 at 15:08 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 14 Apr 2008 14:28:45 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On Mon, Apr 14 2008 at 14:04 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> On Mon, 14 Apr 2008 12:49:49 +0300
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>> On Sun, Apr 13 2008 at 19:50 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>>> On Sun, Apr 13 2008 at 19:17 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>>>>> On Sun, 13 Apr 2008 12:13:18 +0300
>>>>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>>>>
>>>>>> That's a ugly hack for me.
>>>>>>
>>>>>> Why do we have two separate systems to represent the command length?
>>>>>> If the command length is smaller than 16 bytes, we use cmd_len. If the
>>>>>> length is larger than 16 bytes, we use varlen_cdb_len?
>>>>>>
>>>>>> For me, as Jens proposed, having only cmd_len is the right way.
>>>>>>
>>>>>> And 'cdb' name is not appropriate for the block layer, I think.
>>>>>>
>>>>>> I agreed that changing the block layer and the scsi midlayer gradually
>>>>>> is a safe option. Shortly, I'll send patches to clean up the hack on
>>>>>> the top of your patchset.
>>>>>> --
>>>>> Sorry TOMO, I was sending the ver2 patchset and only saw your mail in
>>>>> the middle, so anyway you have the latest I have now.
>>>>>
>>>>> If it's ok with you I will squash your patches onto mine and add your
>>>>> sign-off-by. There is no use putting code in the tree that will be changed
>>>>> immediately after.
>>>>>
>>>>> Please note that I'm a bit afraid to put code that has both length as one
>>>>> if you are more confident then me, I will take your word for it.
>>>>>
>>>>> Thanks for helping out, as you can see I did it very safe, but with your
>>>>> help maybe it can finally go in. Thanks++
>>>>>
>>>>> Boaz
>>>>> --
>>>> Maybe you mean something like below. I changed cdb => cmd and I use one
>>>> cmd_len. I think that "cdb" was a good name. Note that we have BLK_MAX_CDB
>>>> right there next to it. But if you don't like it then I don't mind to
>>>> change the name, I think it was James idea.
>>> I don't. I've been talking mainly about how to represent the length of
>>> command.
>>>
>>> About 'cdb' name, I thought that there is a better name than
>>> BLK_MAX_CDB. But it's up to Jens.
>>>
>>>
>>>> But please note!!!
>>>> I think having one cmd_len is DANGEROUS. And it forces a full code audit
>>>> to be sure, has with my approach we are much more safe. There, I said it.
>>> Could you be more specific? So far, you have not explained how it can
>>> be dangerous.
>> There is a pending patch by Pete, and our main goal, is to push OSD commands 
>> through bsg. All over the kernel there are cooked up char-devices, like in 
>> gdth, that do vendor specific management commands. All these, and future, 
>> special-command can go from user-mode through bsg in a common way. Via support 
>> of vendor specific and extended commands. All the new scsi defined commands 
>> that are bigger then 16 are not going to be sent through sg, but through 
>> bsg right? So we do want to use this facility from kernel and from user-land
>> but we need some protection. In scsi LLDs we have .max_cmnd but block devices
>> don't have that. So either you need to restrict what can be done, or play it safe
>> like I did.
> 
> If we creates bsg devices for block devices, of course, we need to a
> mechanism to govern the length of commands.
> 
> But why do you want to create bsg devices for block devices? If block
> devices want large commands for some reasons, their bsg hook functions
> need to handle the length of commands anyway. There is no reason that
> the block layer has two values to represent one item, the length of
> command.
> 
> If we want to govern the command length in a common place, then I
> think that it would be better to add the limit to request queue.
> 
> And again, what are your block devices? What do they want bsg for?
> --

I don't have any block devices personally. I just thought that the diff
between sg a bsg is that bsg will support any block device, so I guess
I was wrong, bsg is a user-to-scsi bridge just like sg is. I thought
bsg registers on every request_queue, how does bsg filter which devices
to export and which not?

What about the union, don't we care about the space saved?

Boaz
