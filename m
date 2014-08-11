From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Date: Tue, 12 Aug 2014 06:53:32 +0800
Message-ID: <20140811225332.GA10721@kroah.com>
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140811082811.GC1422@kroah.com>
 <FDC088D3B5555644AE135ED28A7ABDE94DF2B2AE@EU-MBX-02.mgc.mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FDC088D3B5555644AE135ED28A7ABDE94DF2B2AE@EU-MBX-02.mgc.mentorg.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>, "kraxel@redhat.com" <kraxel@redhat.com>, "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 11, 2014 at 11:56:17AM +0000, Sharma, Sanjeev wrote:
> Hi Greg,
> 
> Please find my comment in line.

As it should, but where is it, your quoting is all messed up...

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org] 
> Sent: Monday, August 11, 2014 1:58 PM
> To: Sharma, Sanjeev
> Cc: hdegoede@redhat.com; kraxel@redhat.com; mdharm-usb@one-eyed-alien.net; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
> 
> On Mon, Aug 11, 2014 at 01:29:26PM +0530, Sanjeev Sharma wrote:
> > spin_is_locked() always return false in uniprocessor configuration
> 
> Really?  On what processor type?  I don't see that being the case on a few processors, but I didn't check them all, or I might be totally confused with all of the arch_spin_is_locked() definitions in the tree.
> 
> specially in case of mips and powerpc but we can configure our kernel to uniprocessor configuration for specific processor and in that case we should be extra cautious. Please check spinlock_up.h

Shouldn't you just fix your .h file to not do this?  x86 is not this
way, nor is ARM, right?

> > and therefore it
> > would be advise to repalce with assert_spin_locked().
> 
> This implies that all uses of this function is wrong and should be replaced and removed, right?
> 
> Yes and there are only few places in driver for which I am submitting patches which need to be change and at other places it has been already taken care. Please have an look into the
> Old discussion for more details.
> 
> http://linux-kernel.2935.n7.nabble.com/Is-spin-is-locked-safe-to-use-with-BUG-ON-WARN-ON-td654800.html#a921802

Ok, just remove all the tests, it doesn't help anyone :)

thanks,

greg k-h
