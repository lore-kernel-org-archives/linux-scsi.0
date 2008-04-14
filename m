From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3 ver3] block layer extended-cdb support
Date: Mon, 14 Apr 2008 14:28:45 +0300
Message-ID: <48033FED.5060307@panasas.com>
References: <20080414010112W.tomof@acm.org>	<480239D2.3040206@panasas.com>	<480328BD.7050206@panasas.com> <20080414200431M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27597 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753024AbYDNL3y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2008 07:29:54 -0400
In-Reply-To: <20080414200431M.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Pete Wyckoff <pw@osc.edu>

On Mon, Apr 14 2008 at 14:04 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 14 Apr 2008 12:49:49 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On Sun, Apr 13 2008 at 19:50 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>> On Sun, Apr 13 2008 at 19:17 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>>> On Sun, 13 Apr 2008 12:13:18 +0300
>>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>>
>>>> That's a ugly hack for me.
>>>>
>>>> Why do we have two separate systems to represent the command length?
>>>> If the command length is smaller than 16 bytes, we use cmd_len. If the
>>>> length is larger than 16 bytes, we use varlen_cdb_len?
>>>>
>>>> For me, as Jens proposed, having only cmd_len is the right way.
>>>>
>>>> And 'cdb' name is not appropriate for the block layer, I think.
>>>>
>>>> I agreed that changing the block layer and the scsi midlayer gradually
>>>> is a safe option. Shortly, I'll send patches to clean up the hack on
>>>> the top of your patchset.
>>>> --
>>> Sorry TOMO, I was sending the ver2 patchset and only saw your mail in
>>> the middle, so anyway you have the latest I have now.
>>>
>>> If it's ok with you I will squash your patches onto mine and add your
>>> sign-off-by. There is no use putting code in the tree that will be changed
>>> immediately after.
>>>
>>> Please note that I'm a bit afraid to put code that has both length as one
>>> if you are more confident then me, I will take your word for it.
>>>
>>> Thanks for helping out, as you can see I did it very safe, but with your
>>> help maybe it can finally go in. Thanks++
>>>
>>> Boaz
>>> --
>> Maybe you mean something like below. I changed cdb => cmd and I use one
>> cmd_len. I think that "cdb" was a good name. Note that we have BLK_MAX_CDB
>> right there next to it. But if you don't like it then I don't mind to
>> change the name, I think it was James idea.
> 
> I don't. I've been talking mainly about how to represent the length of
> command.
> 
> About 'cdb' name, I thought that there is a better name than
> BLK_MAX_CDB. But it's up to Jens.
> 
> 
>> But please note!!!
>> I think having one cmd_len is DANGEROUS. And it forces a full code audit
>> to be sure, has with my approach we are much more safe. There, I said it.
> 
> Could you be more specific? So far, you have not explained how it can
> be dangerous.

There is a pending patch by Pete, and our main goal, is to push OSD commands 
through bsg. All over the kernel there are cooked up char-devices, like in 
gdth, that do vendor specific management commands. All these, and future, 
special-command can go from user-mode through bsg in a common way. Via support 
of vendor specific and extended commands. All the new scsi defined commands 
that are bigger then 16 are not going to be sent through sg, but through 
bsg right? So we do want to use this facility from kernel and from user-land
but we need some protection. In scsi LLDs we have .max_cmnd but block devices
don't have that. So either you need to restrict what can be done, or play it safe
like I did.

Boaz
