From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH 22/82] remove linux/version.h from drivers/message/fus ion
Date: Wed, 20 Jul 2005 13:22:04 -0500
Message-ID: <20050720182204.GA1134@humbolt.us.dell.com>
References: <91888D455306F94EBD4D168954A9457C03281EB4@nacos172.co.lsil.com> <20050720031249.GA18042@humbolt.us.dell.com> <20050720175409.GB1573@otto>
Reply-To: Matt Domsch <Matt_Domsch@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:37215 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S261430AbVGTSWH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2005 14:22:07 -0400
Content-Disposition: inline
In-Reply-To: <20050720175409.GB1573@otto>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nathan Lynch <ntl@pobox.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Olaf Hering <olh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Wed, Jul 20, 2005 at 12:54:09PM -0500, Nathan Lynch wrote:
> Matt Domsch wrote:
> > On Tue, Jul 19, 2005 at 06:07:41PM -0600, Moore, Eric Dean wrote:
> > > On Tuesday, July 12, 2005 8:17 PM, Matt Domsch wrote:
> > > > In general, this construct:
> > > > 
> > > > > > -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
> > > > > > -static int inline scsi_device_online(struct scsi_device *sdev)
> > > > > > -{
> > > > > > -	return sdev->online;
> > > > > > -}
> > > > > > -#endif
> > > > 
> > > > is better tested as:
> > > > 
> > > > #ifndef scsi_device_inline
> > > > static int inline scsi_device_online(struct scsi_device *sdev)
> > > > {
> > > >     return sdev->online;
> > > > }
> > > > #endif
> > > > 
> > > > when you can.  It cleanly eliminates the version test, and tests for
> > > > exactly what you're looking for - is this function defined.
> > > > 
> > > 
> > > What you illustrated above is not going to work.
> > > If your doing #ifndef around a function, such as scsi_device_online, it's
> > > not going to compile
> > > when scsi_device_online is already implemented in the kernel tree.
> > > The routine scsi_device_online is a function, not a define.  For a define
> > > this would work.
> > 
> > Sure it does, function names are defined symbols.
> > 
> 
> $ cat foo.c
> static int foo(void) { return 0; }
> #ifndef foo
> static int foo(void) { return 0; }
> #endif
> 
> $ gcc -c foo.c
> foo.c:3: error: redefinition of 'foo'
> foo.c:1: error: previous definition of 'foo' was here
> 
> I believe #ifdef/#ifndef can test only preprocessor symbols.


I was mistaken. Christoph explained to me that it worked on 2.4 due to
the way module symbol versions worked, but isn't that way on 2.6
anymore.  My apologies.

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
