From: "Sharma, Sanjeev" <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Date: Mon, 11 Aug 2014 11:56:17 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2B2AE@EU-MBX-02.mgc.mentorg.com>
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140811082811.GC1422@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140811082811.GC1422-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org" <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

Please find my comment in line.

-----Original Message-----
From: Greg KH [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org] 
Sent: Monday, August 11, 2014 1:58 PM
To: Sharma, Sanjeev
Cc: hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org; linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().

On Mon, Aug 11, 2014 at 01:29:26PM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration

Really?  On what processor type?  I don't see that being the case on a few processors, but I didn't check them all, or I might be totally confused with all of the arch_spin_is_locked() definitions in the tree.

specially in case of mips and powerpc but we can configure our kernel to uniprocessor configuration for specific processor and in that case we should be extra cautious. Please check spinlock_up.h

> and therefore it
> would be advise to repalce with assert_spin_locked().

This implies that all uses of this function is wrong and should be replaced and removed, right?

Yes and there are only few places in driver for which I am submitting patches which need to be change and at other places it has been already taken care. Please have an look into the
Old discussion for more details.

http://linux-kernel.2935.n7.nabble.com/Is-spin-is-locked-safe-to-use-with-BUG-ON-WARN-ON-td654800.html#a921802

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
