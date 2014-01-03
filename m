From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Fri, 03 Jan 2014 09:56:45 +0100
Message-ID: <52C67B4D.9060101@redhat.com>
References: <20131220231810.GA2835@xanatos> <Pine.LNX.4.44L0.1312211547490.12252-100000@netrider.rowland.org> <20140103004551.GA2970@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140103004551.GA2970@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 01/03/2014 01:45 AM, Sarah Sharp wrote:
> On Sat, Dec 21, 2013 at 03:51:25PM -0500, Alan Stern wrote:
>> On Fri, 20 Dec 2013, Sarah Sharp wrote:
>>
>>> On Thu, Dec 19, 2013 at 11:48:47AM -0800, James Bottomley wrote:
>>>> It should apply incrementally on top of the previous two.  If it
>>>> actually works, I'll fold it into the first patch.
>>>
>>> Well, it doesn't oops anymore, but it does generate a pile of warnings:
>>
>> This was a simple oversight.  scsi_target_reap() was called at the
>> start of __scsi_remove_device(), but it should be called at the end.
>> The patch below, applied on top of James's three patches, will fix the
>> warnings.
>>
>> Alan Stern
>>
>> P.S.: The comment isn't entirely correct any more...
>
> Ok, Alan's additional patch fixed the warnings I was seeing on UAS
> device unplug.  James, can you Cc me on the finished patch when you send
> it in?
>
> Hans, I don't want to send the UAS patches off to Greg until James'
> patches get into mainline.  I believe Greg's usb-next tree is frozen at
> this point, so they'll have to wait until 3.15.

Ugh, I must say I'm rather unhappy about this, waiting till 3.14 to give
time to shake things out was fine. But since the start of the 3.13 cycle,
there have been no issues found in the xhci / uas code.

Yes it triggered an existing problem in another subsys, but the code itself
has been issue free all this time. If Greg's tree is indeed already frozen I
would rather have us asking an exception for this.

Alternatively we could add all of it to 3.14 except for the patch removing
the BROKEN marking from uas. Or at least all the non uas bits, which are
useful to have by themselves.

James, what is the status of getting the fix for the refcount issue into
mainline ?

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
