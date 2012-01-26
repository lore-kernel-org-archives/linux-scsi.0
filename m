From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [v2] Re: [091/129] block: fail SCSI passthrough ioctls on partition
 devices
Date: Thu, 26 Jan 2012 09:02:29 +0100
Message-ID: <4F210895.8090100@redhat.com>
References: <20120124023932.023409422@clark.kroah.org> <1327423431-13965-1-git-send-email-pbonzini@redhat.com> <20120125223937.GA12516@kroah.com> <alpine.DEB.2.02.1201252348520.22090@aurora.sdinet.de> <CA+5PVA601fTyuTc66nvY_9pZPE5i5DkBkKpyL3-i=q9OxkoT+g@mail.gmail.com> <20120126000749.GC14281@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120126000749.GC14281@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2012 01:07 AM, Greg KH wrote:
> On Wed, Jan 25, 2012 at 06:10:47PM -0500, Josh Boyer wrote:
>> On Wed, Jan 25, 2012 at 5:51 PM, Sven-Haegar Koch<haegar@sdinet.de>  wrote:
>>> On Wed, 25 Jan 2012, Greg KH wrote:
>>>
>>>> On Tue, Jan 24, 2012 at 05:43:50PM +0100, Paolo Bonzini wrote:
>>>>>> You need to return -ENOTTY from scsi_verify_blk_ioctl and -ENOIOCTLCMD from
>>>>>> sd_compat_ioctl, because -ENOIOCTLCMD will not be handled correctly by
>>>>>> block/ioctl.c.  This would break BLKROSET and BLKFLSBUF done by non-root
>>>>>> but with the appropriate capabilities.
>>>>>>
>>>>>> Fixed patch follows.  If you prefer that I send an interdiff, let me know.
>>>>
>>>> Wait, why do you want the stable trees to diverge from what is in
>>>> Linus's tree with regards to the error codes being returned?
>>>>
>>>> That doesn't seem safe, or sane.
>>>>
>>>> So for now, I'm going to follow what is in Linus's tree.  If you
>>>> need/want the error codes to be different, then shouldn't it also be
>>>> done there as well?
>>>
>>> May be because the stable trees do not have
>>> 07d106d0a33d6063d2061305903deb02489eba20? "vfs: fix up ENOIOCTLCMD error
>>> handling"?
>>
>> I believe that is the case, yes.  Linus was unhappy about ENOIOCTLCMD vs.
>> ENOTTY overall when the patch was first submitted, which lead to that commit.
>> The patches Paolo submitted for stable are the original versions that apply
>> directly to 3.2 and older.
>>
>> 07d106d0a isn't really stable material as it was put into 3.3 to catch any odd
>> fallout from the change.
>
> Ok, thanks both of you, that makes more sense now.  I'll take Paolo's
> updated patches and do a release now.

Yes, that's correct.  Thanks Sven and Josh, I was already sleeping. :)

FWIW, there are a couple more ioctls that need to be in the whitelist. 
I'll submit the patch today or tomorrow, but it doesn't need to hold the 
stable release.

Paolo
