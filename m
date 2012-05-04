From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Fri, 04 May 2012 09:11:33 -0400
Message-ID: <4FA3D585.6000503@teksavvy.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com> <4FA18D33.3060607@teksavvy.com> <4FA23809.2090905@redhat.com> <4FA27CDB.2080103@teksavvy.com> <4FA27E7C.6070802@redhat.com> <4FA2C205.3030801@teksavvy.com> <4FA3799A.6010908@redhat.com> <4FA3D442.9050801@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ironport-out.teksavvy.com ([206.248.143.162]:19818 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab2EDNLe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 09:11:34 -0400
In-Reply-To: <4FA3D442.9050801@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-05-04 09:06 AM, Mark Lord wrote:
> On 12-05-04 02:39 AM, Paolo Bonzini wrote:
>> Il 03/05/2012 19:36, Mark Lord ha scritto:
>>
>>>>>>> Dunno which flags, I'm just ignoring them and waiting
>>>>>>> for the noise message to get reverted.
>>
>> I said which ioctls, not which options.  I.e. cut-and-paste from dmesg.
> 
> Here are some:
> 
> 
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

Looks like it got removed about 10 years ago,
either in 2.5.xx or early 2.6.xx, so that's all fine now.
hdparm still issues it for backward compatibility with
kernels that lack more modern methods.  Currently we don't
try to inspect the kernel version at run-time, because
version numbers are not as reliable as simply issuing
the ioctl().

> hdparm issues it first as a backward-compatibility thing,
> before falling back to the even-more obsolete HDIO_GETGEO,
> which curiously enough is still in modern kernels.
> 
> Cheers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

