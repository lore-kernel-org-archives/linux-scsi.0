From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 5 Jun 2008 10:02:34 -0700
Message-ID: <e9c3a7c20806051002u2d26f24eqcffed98de02ffa60@mail.gmail.com>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
	 <20080605062754.GQ2961@webber.adilger.int>
	 <20080605123515.GM3549@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:44411 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbYFERCh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 13:02:37 -0400
Received: by ti-out-0910.google.com with SMTP id b6so222852tic.23
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jun 2008 10:02:35 -0700 (PDT)
In-Reply-To: <20080605123515.GM3549@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andreas Dilger <adilger@sun.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Jun 5, 2008 at 5:35 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Thu, Jun 05, 2008 at 12:27:54AM -0600, Andreas Dilger wrote:
>> To be honest, however, having the information exported only via sysfs
>> is a bit ugly IMHO.  I've had all sorts of grief with settings there
>> because there isn't always a match between the device that is being
>> specified by the user and what appears in sysfs (e.g. /dev/disk/by-id/foo
>> doesn't match /sys/block/sda) and hoops have to be jumped through to
>> find this mapping, before parsing a text value in C.
>
> readlink() is too hard?
>
> $ readlink /dev/disk/by-id/ata-FUJITSU_MHV2080AH_NT61T6325UGM
> ../../hda
>
>> Having an ioctl() that can be called on the block device (getting
>> the right device regardless of its name) seems a lot more useful to
>> applications in my experience, unless you are using a script.
>
> It's certainly easier.
>

We've had this discussion before:

http://marc.info/?t=120641785300005&r=6&w=2

...and it resulted in this patch that is pending is Greg's tree:

http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver-core/sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch;h=ed9a41a564f73db74f7260f24552352ab86bc893;hb=HEAD

Regards,
Dan
