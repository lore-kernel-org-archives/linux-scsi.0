From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem readonly
Date: Thu, 19 Nov 2009 17:07:00 +0100
Message-ID: <20091119160700.GC2943@atrey.karlin.mff.cuni.cz>
References: <20091113050907.GA4965@roll>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091113050907.GA4965@roll>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tmhikaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

  Hi,

> 	Hi. I already tried sending this email to the lkml a couple of days
> ago. (With the subject re: 2.6.31.6) As I've gotten no response, and this
> has been a problem for close to a month for me now, I've tried emailing
> people (and other mailing lists) that may have a better clue of what's going
> on here. I don't know what is going on here, so I've emailed the block
> maintainer, ext4 filesystems list, usb mailing list, and scsi mailing list.
> If I've reached you in error, and I have not actually sent this email to the
> correct party, please inform me whom I should have sent this to. Thank you.
> 
> 	As I've had with the last few kernel releases in the 2.6.31.x
> series, I'm still having a problem where I'm constantly getting seemingly
> random I/O errors in dmesg output for my external usb hard drive. The thing
> that worries me is that although my ext4 filesystem is configured to remount
> readonly when problems occur, it is not in fact doing so. Does this mean the
> error is transient, worked around, and I can ignore it, or ... what?
> 
> Specifically it is these messages I'm recieving whenever I do heavy duty
> work with the drive that worries me:
> 
> sd 0:0:0:0: [sda] Unhandled error code
> sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sda, sector 79713943
  Well, my external hard drive does strange things when my USB port
isn't able to give it enough power (probably flaky USB controller on the
MB - OTOH I don't know why it sucks any power really since the drive has
external power supply anyway). Plugging into a different USB port solved
the problems for me.
  Anyway, for some reason the IO error did not get up to buffer layer
but ended up in the block layer. Probably because bi_end_io function did
not reported it properly.  Maybe you could debug that by adding a debug
printk into several places: e.g. to fs/bio.c:bio_endio(),
fs/buffer.c:end_bio_bh_io_sync(), fs/mpage.c:mpage_end_io_write(),
fs/mpage.c:mpage_end_io_read(), fs/ext4/extents.c:bi_complete() and see
whether 'error' is != 0 there and if yes, what it is.

> Note that the sector number is never the same, and has never been the same
> over a month's worth of I/O errors, but the unhandled error code result
> always stays the same, though that also does not always show up.
> 
> In my attempts to determine if there's some sort of filesystem corruption
> going on I haven't been able to find any problems - files that were changed
> while the I/O errors seemed to be being generated are in fact perfect copies
> according to md5sum.
> 
> I *really* need to know exactly what is going on here. Worst case scenario I
> can think of is that the hard drive is going bad, but the symptoms don't
> seem to bear that out. I need to know what the error messages - combined
> with the the filesystem behavior (NOT remounting readonly) - mean.
> 
> I use the usb drive (a 250gb seagate using a rosewill external usb kit) to
> backup two 120GB internal maxtors using rsync. These are all IDE hard
> drives.
> 
> I would appreciate any tips on how I can determine if linux is working
> around the problem silently on its own, or not.
  From the 

> The rest of this email includes dmesg output and various filesystem settings
> I've set. Note in the dmesg output I plugged in and turned on the drive,
> mounted it and poked around a bit, then unmounted it and ran my backup
> script (Which e2fsck's it, mounts it, runs rsync to do the actual backup,
> then unmounts it when it's done)
...
> EXT4-fs (sda1): barriers enabled
> kjournald2 starting: pid 3390, dev sda1:8, commit interval 5 seconds
> EXT4-fs (sda1): internal journal on sda1:8
> EXT4-fs (sda1): delayed allocation enabled
> EXT4-fs: file extents enabled
> EXT4-fs: mballoc enabled
> EXT4-fs (sda1): mounted filesystem with ordered data mode
> EXT4-fs: mballoc: 5780 blocks 36 reqs (13 success)
> EXT4-fs: mballoc: 28 extents scanned, 2 goal hits, 26 2^N hits, 0 breaks, 0
> lost
> EXT4-fs: mballoc: 113 generated and it took 1911664
> EXT4-fs: mballoc: 3961 preallocated, 3449 discarded
> EXT4-fs (sda1): barriers enabled
> kjournald2 starting: pid 3411, dev sda1:8, commit interval 5 seconds
> EXT4-fs (sda1): internal journal on sda1:8
> EXT4-fs (sda1): delayed allocation enabled
> EXT4-fs: file extents enabled
> EXT4-fs: mballoc enabled
> EXT4-fs (sda1): mounted filesystem with ordered data mode
> sd 0:0:0:0: [sda] Unhandled error code
> sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sda, sector 79713943
> sd 0:0:0:0: [sda] Unhandled error code
> sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sda, sector 79714231
> sd 0:0:0:0: [sda] Unhandled error code
> sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sda, sector 61431
> sd 0:0:0:0: [sda] Unhandled error code
> sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sda, sector 4223935
> sd 0:0:0:0: [sda] Unhandled error code
> sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sda, sector 8417519

									Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SuSE CR Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
