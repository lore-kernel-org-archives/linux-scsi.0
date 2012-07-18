From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [Bug 44771] [REGRESSION] a7a20d103994fd760766e6c9d494daa569cbfe06
 makes kernel 3.5 unbootable on an Intel chipset based motherboard
Date: Wed, 18 Jul 2012 15:41:38 -0700
Message-ID: <CAA9_cmf4uGuf_nuc6542MddkgWqUhvDXqBMpeGS--QU84+j2xA@mail.gmail.com>
References: <1342562588.3039.104.camel@dabdike.int.hansenpartnership.com>
	<Pine.LNX.4.44L0.1207181608410.1429-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45716 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2GRWlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2012 18:41:39 -0400
Received: by obbuo13 with SMTP id uo13so2770396obb.19
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2012 15:41:39 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1207181608410.1429-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <jbottomley@parallels.com>, "Artem S. Tashkinov" <t.artem@mailcity.com>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@amd64.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jul 18, 2012 at 1:25 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 17 Jul 2012, James Bottomley wrote:
>
>> On Tue, 2012-07-17 at 12:51 -0700, Linus Torvalds wrote:
>> > Wrong people cc'd, it looks like.
>> >
>> > Guys, commit a7a20d103994 ("sd: limit the scope of the async probe
>> > domain") is causing boot problems. It's timing-dependent and
>> > apparently sometimes works, which makes sense with that commit.
>> >
>> > However, it *should* have been fixed by commit 43a8d39d0137 ("fix
>> > async probe regression"), but Artem seems to report the problem even
>> > in -rc7.
>> >
>> > Comments?
>>
>> As far as I can tell, the fix should have worked.  However, there are a
>> lot of assumptions in the async stuff that end up not being true in the
>> presence of separate async domains.   We should be fixing it all here:
>>
>> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=shortlog;h=refs/heads/async
>
> Those commits haven't been merged into 3.5-rc7, right?  So Artem isn't
> using them.
>
>> I've got to say, I don't understand the bug report.  all of those
>> commits were about probing for devices.  However, the screen shot
>>
>> https://bugzilla.kernel.org/attachment.cgi?id=75351
>>
>> shows the devices were found, it's the partition tables that weren't.
>> For us to see the message about sda's capacity, we're already in the
>> async code the commits were trying to synchronise with.
>
> That's understandable, given that those commits aren't present in
> Artem's kernel.  Are they queued for -stable?

I did not flag them as such given the wider entanglements.

>
>> However, there are some missing messages: there's no partition table
>> print and no final
>>
>>       sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>>                 sdp->removable ? "removable " : "");
>>
>> So sd_probe_async() got stuck somewhere after the first
>> sd_revalidata_disk().
>
> No, it didn't get stuck.  The problem is that the scsi_wait_scan module
> didn't wait for the async scanning to finish.
>
> And the reason for that is one you're already familiar with:
> CONFIG_SCSI_MOD=y.

I had forgotten that additional aspect. but I don't think that is the
root cause.  scsi_wait_scan() is a nop in Artem's config given
CONFIG_SCSI_WAIT_SCAN=m.  From what I have seen ahci typically ensures
that wait_for_device_probe() is all that is needed to guarantee
scanning is complete which commit a7a20d103994 ("sd: limit the scope
of the async probe domain") breaks, and which commit 43a8d39d0137
("[SCSI] fix async probe regression"), does not resolve because that
requires a call to scsi_complete_async_scans() to close the loop.

> Artem, if you change all your SCSI drivers to be modular rather than
> built-in, that ought to fix the problem.  Alternatively, you can simply
> continue to use the "rootwait" option.

I think setting CONFIG_SCSI_WAIT_SCAN=y would also be a workaround, or
going forward with the pending async rework to make sd probe work once
again visible to async_synchronize_domain_full().

--
Dan
