From: "adam radford" <aradford@gmail.com>
Subject: Re: 3Ware delayed device mounting errors with newer 9500 series adapters
Date: Sun, 22 Oct 2006 10:19:16 -0700
Message-ID: <b1bc6a000610221019i47283722g3b8f4a79918c4825@mail.gmail.com>
References: <453A52CE.80605@wolfmountaingroup.com>
	 <20061021233904.c2f40a5f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:22490 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751319AbWJVRTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Oct 2006 13:19:18 -0400
Received: by nf-out-0910.google.com with SMTP id c2so2096594nfe
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2006 10:19:17 -0700 (PDT)
In-Reply-To: <20061021233904.c2f40a5f.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>, linux-kernel <linux-kernel@vger.kernel.org>, linuxraid@amcc.com, linux-scsi@vger.kernel.org

Jeff,

Can you reproduce with 2.6.18.1?  ES4 contains a custom 3ware driver.

Also, you have included no error output with this email whatsoever.  Can
you go to a virtual console during your ES4 install, run 'dmesg', and see if
the errors are in there, or if they are a part of the ES4 anaconda installer?

/dev/sdb, etc. having delayed appearances sounds like it is udev related.

Are you running the latest firmware?  Do your controllers older than 60 days
have different firmware?

I will try to reproduce this.

-Adam

On 10/21/06, Andrew Morton <akpm@osdl.org> wrote:
> On Sat, 21 Oct 2006 11:03:10 -0600
> "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com> wrote:
>
> >
> > Adam,
> >
> > We have been getting 3Ware 9500 series adapters in the past 60 days
> > which exhibit a delayed behavior during mounting of FS from
> > /etc/fstab.   The adapters older than this do not exhibit this behavior.
> >
> > During bootup, if the driver is compiled as a module rather than in
> > kernel, mount points such as /var in fstab fail to detect the devices
> > until the system fully boots, at which point the /dev/sdb etc. devices
> > showup.  It happens on both ATA cabled drives and drives
> > cabled with multi-lane controller backplanes.
> >
> > The problem is easy to reproduce.  Install ES4, point the /var directory
> > during install to one of the array devices in disk druid, and after
> > the install completes, /var/ will not mount during bootup and all sorts
> > of errors stream off the screen.  I can reproduce the problem
> > with several systems in our labs and upon investigating the adapter
> > revisions, I find that adapters ordered in the past 60 days exhibit
> > the problem.   Compiling the driver in kernel gets around the problem,
> > indicating its timing related.
> >
>
> cc's added.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
