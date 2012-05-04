From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Fri, 04 May 2012 15:08:01 +0200
Message-ID: <4FA3D4B1.9040308@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com> <4FA18D33.3060607@teksavvy.com> <4FA23809.2090905@redhat.com> <4FA27CDB.2080103@teksavvy.com> <4FA27E7C.6070802@redhat.com> <4FA2C205.3030801@teksavvy.com> <4FA3799A.6010908@redhat.com> <4FA3D442.9050801@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab2EDNIk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 09:08:40 -0400
In-Reply-To: <4FA3D442.9050801@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Il 04/05/2012 15:06, Mark Lord ha scritto:
>> > I said which ioctls, not which options.  I.e. cut-and-paste from dmesg.
> Here are some:

Thanks!

> messages.1:Apr 28 14:08:09 zbox5 kernel: [  268.800536] hdparm: sending ioctl 330 to a partition!
> messages.1:Apr 28 14:08:09 zbox5 kernel: [  268.800547] hdparm: sending ioctl 330 to a partition!
> messages.1:Apr 28 14:08:57 zbox5 kernel: [  316.413944] hdparm: sending ioctl 330 to a partition!
> messages.1:Apr 28 14:08:57 zbox5 kernel: [  316.413951] hdparm: sending ioctl 330 to a partition!
> messages.1:Apr 28 14:20:10 zbox5 kernel: [  989.525085] hdparm: sending ioctl 330 to a partition!
> messages.1:Apr 28 14:20:10 zbox5 kernel: [  989.525093] hdparm: sending ioctl 330 to a partition!
> 
> The in <linux/hdreg.h> say this about 330:
> 
> ...
> /* 0x330 is reserved - used to be HDIO_GETGEO_BIG */
> ...
> 
> So it's HDIO_GETGEO_BIG, which doesn't exist in newer kernels.
> I wonder when that got removed?  Minor userspace breakage there.
> 
> hdparm issues it first as a backward-compatibility thing,
> before falling back to the even-more obsolete HDIO_GETGEO,
> which curiously enough is still in modern kernels.

Ok, so hdparm is not broken.  My patch (which left the warning only for
SG_IO, and failed all other ioctls) would have worked, too.

Paolo
