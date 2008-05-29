From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH][-mm] reclassify sg_sysfs_class for lockdep
Date: Thu, 29 May 2008 08:45:43 +0800
Message-ID: <a8e1da0805281745g31c8217fk860dfe17cc674be5@mail.gmail.com>
References: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
	 <1211985600.3445.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755224AbYE2AqM@vger.kernel.org>
In-Reply-To: <1211985600.3445.14.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 28, 2008 at 10:40 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2008-05-27 at 18:10 +0800, Dave Young wrote:
>> As register sg_interface, the sg_add will be called, which then will
>> add device to sg_sysfs_class. This will cause lockdep warning,
>> please see following email
>>
>> In this case the locks are from diffrent classi, one is sdev_class,
>> another is sg_sysfs_class
>>
>> Here reclassify the sg_sysfs_class for lockdep
>
> This isn't really a generic solution, is it?  It only works because we
> currently only have two users of the interface functions, so if we
> reclassify one they look separate to lockdep.  It will fall over again
> if we ever get another one.
>
> Surely the correct fix is to initialise lockdep for the mutex the same
> way we did for the semaphore in class_register() (which does exactly the
> same locking without triggering lockdep)?  That way we'll also fix the
> problem for other conversions of semaphore->mutex.

Matthew & greg did the work already.

>From my original idea I don't want to do this for all classes, and I
would think it as a rare case.

Regards
dave
