From: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [Security] [PATCH 00/20] world-writable files in sysfs and
 debugfs
Date: Tue, 15 Mar 2011 12:32:31 -0400
Message-ID: <1300206751.11313.3.camel@mulgrave.site>
References: <cover.1296818921.git.segoon@openwall.com>
	 <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
	 <1300155965.5665.15.camel@mulgrave.site> <20110315030956.GA2234@kroah.com>
	 <1300189828.4017.2.camel@mulgrave.site>  <20110315160804.GA3380@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110315160804.GA3380@albatros>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, acpi4asus-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-03-15 at 19:08 +0300, Vasiliy Kulikov wrote:
> On Tue, Mar 15, 2011 at 07:50 -0400, James Bottomley wrote:
> >      1. Did anyone actually check for capabilities before assuming world
> >         writeable files were wrong?
> 
> I didn't check all these files as I haven't got these hardware :-)

You don't need the hardware to check ... the question becomes is a
capabilities test sitting in the implementation or not.

>   But
> as I can "chmod a+w" all sysfs files on my machine and they all become
> sensible to nonroot writes, I suppose there is nothing preventing
> nonroot users from writing to these buggy sysfs files.  As you can see,
> there are no capable() checks in these drivers in open() or write().
> 
> >      2. Even if there aren't any capabilities checks in the implementing
> >         routines, should there be (are we going the separated
> >         capabilities route vs the monolithic root route)?
> 
> IMO, In any case old good DAC security model must not be obsoleted just
> because someone thinks that MAC or anything else is more convenient for
> him.  If sysfs is implemented via filesystem then it must support POSIX
> permissions semantic.  MAC is very good in _some_ cases, but not instead
> of DAC.

Um, I'm not sure that's even an issue.  capabilities have CAP_ADMIN
which is precisely the same check as owner == root.  We use this a lot
because ioctls ignore the standard unix DAC model.

James



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
