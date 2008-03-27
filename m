From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Thu, 27 Mar 2008 12:38:56 -0700
Message-ID: <47EBF7D0.6000901@zytor.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>	 <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>	 <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca>	 <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca>	 <47E99EBE.7010708@gmail.com> <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <htejun@gmail.com>, Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Kay Sievers wrote:
>>
>>  Probably something like /sys/class/block/MAJ:MIN
> 
> "Devices directories" are not supposed to contain duplicate entries.
> It would slow-down, or may even break things.
> 
>> or /sys/class/devnums/bMAJ:MIN?
> 
> These are no devices belonging to the class "devnums", so it may
> confuse things which crawl these directories to get "all devices".
> Current coldplug-like setups will likely add duplicate devices with
> the wrong subsystem. There are also bus-devices with have a dev_t, and
> that will make them show up in /sys/class, which might confuse some
> tools too.
> 
> I guess we will need to find some other solution as a /sys/class/ for
> that. And we must prefix the links with 'c' and 'b' because dev_t is
> not unique across char and block devices.
> 

It doesn't really seem to be to belong under class at all.  I would 
suggest /sys/dev/char/ and /sys/dev/block/, for char and block respectively.

	-hpa

