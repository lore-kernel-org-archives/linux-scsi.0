From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Fri, 04 May 2012 09:24:54 -0400
Message-ID: <4FA3D8A6.8030206@teksavvy.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com> <4FA18D33.3060607@teksavvy.com> <4FA23809.2090905@redhat.com> <4FA27CDB.2080103@teksavvy.com> <4FA27E7C.6070802@redhat.com> <4FA2C205.3030801@teksavvy.com> <4FA3799A.6010908@redhat.com> <4FA3D442.9050801@teksavvy.com> <4FA3D585.6000503@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FA3D585.6000503@teksavvy.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12-05-04 09:11 AM, Mark Lord wrote:
> On 12-05-04 09:06 AM, Mark Lord wrote:
..
>> kernel: [  989.525093] hdparm: sending ioctl 330 to a partition!
>>
>> The in <linux/hdreg.h> say this about 330:
>> ...
>> /* 0x330 is reserved - used to be HDIO_GETGEO_BIG */
>> ...
>>
>> So it's HDIO_GETGEO_BIG, which doesn't exist in newer kernels.
>> I wonder when that got removed?  Minor userspace breakage there.
> 
> Looks like it got removed about 10 years ago,
> either in 2.5.xx or early 2.6.xx, so that's all fine now.
> hdparm still issues it for backward compatibility with
> kernels that lack more modern methods.  Currently we don't
> try to inspect the kernel version at run-time, because
> version numbers are not as reliable as simply issuing
> the ioctl().


I will update hdparm regardless (version 9.40, not out yet)
to try and avoid HDIO_GETGEO_BIG when possible.  It will still
use it under some circumstances (like when sysfs isn't mounted,
which should catch 2.4.xx kernels and older), but mostly not.

Cheers
