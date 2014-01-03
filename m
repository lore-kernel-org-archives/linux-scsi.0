From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Sat, 04 Jan 2014 00:20:08 +0100
Message-ID: <52C745A8.6060608@redhat.com>
References: <20131220231810.GA2835@xanatos> <Pine.LNX.4.44L0.1312211547490.12252-100000@netrider.rowland.org> <20140103004551.GA2970@xanatos> <52C67B4D.9060101@redhat.com> <20140103220041.GC4193@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbaACXUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jan 2014 18:20:16 -0500
In-Reply-To: <20140103220041.GC4193@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

Hi,

On 01/03/2014 11:00 PM, Sarah Sharp wrote:
> On Fri, Jan 03, 2014 at 09:56:45AM +0100, Hans de Goede wrote:
>> Hi,
>>
>> On 01/03/2014 01:45 AM, Sarah Sharp wrote:
>>> Ok, Alan's additional patch fixed the warnings I was seeing on UAS
>>> device unplug.  James, can you Cc me on the finished patch when you send
>>> it in?
>>>
>>> Hans, I don't want to send the UAS patches off to Greg until James'
>>> patches get into mainline.  I believe Greg's usb-next tree is frozen at
>>> this point, so they'll have to wait until 3.15.
>>
>> Ugh, I must say I'm rather unhappy about this, waiting till 3.14 to give
>> time to shake things out was fine. But since the start of the 3.13 cycle,
>> there have been no issues found in the xhci / uas code.
>
> I completely understand why you're unhappy.  I agree that the pull
> request you sent me on Nov 18th is fine (aside from not being a GPG
> signed git tag). [1]  I also agree that the UAS and xHCI driver changes
> have been stable during my testing, other than triggering the SCSI oops
> on UAS disconnect.
>
>> Yes it triggered an existing problem in another subsys, but the code itself
>> has been issue free all this time. If Greg's tree is indeed already frozen I
>> would rather have us asking an exception for this.
>
> Detach yourself emotionally from your code and look at this request from
> a maintainer's perspective.
>
> You're asking me to push 69 patches to Greg after -rc6 is out, for a
> driver that's been marked broken for several kernel releases (uas).  The
> patches enable a feature that's been basically untested across all xHCI
> host controllers (streams), and they add new userspace API for usbfs to>
> expose streams.

Yes 69 patches which have been ready since November 18. Your argument is
that they were not in linux-next before now, my unhappiness comes from
that they could have been in linux-next for some time now already.

> In the meantime, there's a big push to get code into linux-next at least
> a week or two before the merge window opens.  I sent my last pull request
> on Dec 20th, and Felipe closed his USB gadget tree on Dec 26th.  I had
> hoped to get the SCSI issue settled so I could send in the UAS patches
> on the 20th, but that didn't happen.  My tree is closed.
>
> These fixes should get merged (and will!), but I will not ask Greg for
> an exception to get these patches into 3.14.
>
>> Alternatively we could add all of it to 3.14 except for the patch removing
>> the BROKEN marking from uas. Or at least all the non uas bits, which are
>> useful to have by themselves.
>
> I think the best way to proceed with this is for me to queue all the
> xHCI patches in that pull request for usb-next once 3.14-rc1 is out, and
> then you send a separate pull request to Greg.  You're going to need to
> be able to send him pull requests with a signed git tag in the future
> anyway.

Since you have all the patches in your tree now anyways I believe it would
be best if you just send a pull-req for all of them. I see little value
in me sending a separate pull-req for the uas patches. As discussed before
I'm fine with picking up uas maintenance from then on.

Regards,

Hans
