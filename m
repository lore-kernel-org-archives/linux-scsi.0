From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][-mm] reclassify sg_sysfs_class for lockdep
Date: Wed, 28 May 2008 09:40:00 -0500
Message-ID: <1211985600.3445.14.camel@localhost.localdomain>
References: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751772AbYE1OkX@vger.kernel.org>
In-Reply-To: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-05-27 at 18:10 +0800, Dave Young wrote:
> As register sg_interface, the sg_add will be called, which then will
> add device to sg_sysfs_class. This will cause lockdep warning,
> please see following email
> 
> In this case the locks are from diffrent classi, one is sdev_class,
> another is sg_sysfs_class 
> 
> Here reclassify the sg_sysfs_class for lockdep

This isn't really a generic solution, is it?  It only works because we
currently only have two users of the interface functions, so if we
reclassify one they look separate to lockdep.  It will fall over again
if we ever get another one.

Surely the correct fix is to initialise lockdep for the mutex the same
way we did for the semaphore in class_register() (which does exactly the
same locking without triggering lockdep)?  That way we'll also fix the
problem for other conversions of semaphore->mutex.

James
