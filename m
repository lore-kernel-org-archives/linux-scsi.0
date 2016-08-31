From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Should queue_max_hw_sectors() always be <= max_dev_sectors?
Date: Tue, 30 Aug 2016 20:36:02 -0600
Message-ID: <74ef47ec-4aee-bdba-b000-cc0b46cf815a@kernel.dk>
References: <202d350b-0e59-1a10-4b65-3563f0afa084@redhat.com>
 <yq1y43d7kgm.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq1y43d7kgm.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Grover <agrover@redhat.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/30/2016 08:15 PM, Martin K. Petersen wrote:
>>>>>> "Andy" == Andy Grover <agrover@redhat.com> writes:
>
> Hey Andy,
>
> Andy> ...because limits.max_hw_sectors internally seems to be just the
> Andy> controller limit, but what users of queue_max_hw_sectors
> Andy> (including sysfs) really want is the lesser of
> Andy> limits.max_hw_sectors and limits.max_dev_sectors.
>
> max_dev_sectors is a limit reported by the target device for
> READ/WRITE/VERIFY requests. Whereas max_hw_sectors describes the DMA
> constraints of the controller.
>
> It is a requirement for SG_IO, firmware updates, tape drives, etc. that
> the controller limits are reported correctly since they do I/Os that are
> much bigger than typical filesystem requests. When we tried to conflate
> the two things broke in interesting ways.

That's crazy. If max_hw_sectors_kb is expected to be the DMA constraint,
then it makes no sense to name it 'sectors'. We currently have the one
exported constraints, and making it anything but the 'this is the
maximum IO size we can support' would be nonsensical.

> I can't remember why the max_dev_sectors sysfs export patch didn't go
> in. But instead (or in addition) we could entertain having a
> max_rw_sectors_kb file that reflects the biggest READ/WRITE/VERIFY
> request the device can consume if that's the information you're after?

Which, coincidentally, is what that file already is for most other
devices. It'd make more sense to bring SCSI into this realm, instead of
imposing this weird world view on others. We export max_segments and
max_segments_size, which are basically a window into what the DMA engine
can do.

-- 
Jens Axboe
