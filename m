From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] link scsi_debug later
Date: Fri, 17 Mar 2006 22:27:38 -0800
Message-ID: <20060317222738.16b94f2d.akpm@osdl.org>
References: <20060317124407.5f19cc09.rdunlap@xenotime.net>
	<20060317212924.11a86800.akpm@osdl.org>
	<20060317221920.3c84fc65.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:1246 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752039AbWCRGa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 01:30:29 -0500
In-Reply-To: <20060317221920.3c84fc65.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

"Randy.Dunlap" <rdunlap@xenotime.net> wrote:
>
> On Fri, 17 Mar 2006 21:29:24 -0800 Andrew Morton wrote:
> 
>  > "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
>  > >
>  > > From: Randy Dunlap <rdunlap@xenotime.net>
>  > > 
>  > > Link scsi-debug driver after SATA so that scsi-debug does not
>  > > interfere with real SCSI device ordering.
>  > > Yes, I was bitten by this.
>  > > 
>  > 
>  > What does "bitten" mean?
> 
>  It means that I got the usual "VFS: could not find root filesystem on
>  device (8,8)"  (or however it is spelled).
>  Oh, and that I had to add netconsole to see what was causing it,
>  but that is easy enough to do.
> 
>  > Is this a regression?
> 
>  It's probably been like this ever since SATA was added (libata)
>  and only happens if SCSI_DEBUG=y (so I changed it to =m).
>  I can't say that it's a regression since this occurred on a new
>  machine.

OK, thanks.  For the recond, I altered the changelog to read

  Changing CONFIG_SCSI_DEBUG from =n or =m to =y can cause the
  enumeration of the SATA devices to change.

  Fix that by linking the scsi-debug driver after the SATA drivers.

>  > Is this 2.6.16 material?
> 
>  Well... I would say yes, I don't think it's too risky for that.

Pretty much any change is risky in this kernel :(

James, your call please.
