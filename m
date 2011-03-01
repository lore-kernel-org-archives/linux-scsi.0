From: Tejun Heo <tj@kernel.org>
Subject: Re: NEC ND-4550A problems reading DVD-R
Date: Tue, 1 Mar 2011 09:01:53 +0100
Message-ID: <20110301080153.GA26074@htj.dyndns.org>
References: <m339n7g7tw.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m339n7g7tw.fsf@intrepid.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(cc'ing linux-scsi and quoting whole body)

Hello,

On Mon, Feb 28, 2011 at 10:36:27PM +0100, Krzysztof Halasa wrote:
> ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> sr 6:0:0:0: CDB: Start/Stop Unit: 1b 00 00 00 03 00
> ata7.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> ata7.00: status: { DRDY }
> ata7: link is slow to respond, please be patient (ready=0)
> ata7: device not ready (errno=-16), forcing hardreset
> ata7: soft resetting link
> ata7.00: FORCE: xfer_mask set to udma33
> ata7.00: configured for UDMA/33
> ata7: EH complete
> sr0: CDROM (ioctl) error, command: Start/Stop Unit 1b 00 00 00 03 00
> sr: Sense Key : Aborted Command [current] [descriptor]
> sr: Add. Sense: No additional sense information
> 
> I'm using the "FORCE" to prevent Linux from downgrading to PIO modes,
> they are a performance disaster.
> 
> Is there any other way to have a longer command timeout (perhaps while
> loading the disc only)?

I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
hardcoded to be 30 seconds.  Maybe it's better to move it to use the
block parameter.  Anyways, the drive actually takes longer than 30secs
to recognize the media?

> Second thing: the drive frequently responds to READ_CAPACITY with a zero
> (one sector).
> 
> sr_cd_check() - for both working and non-working cases:
> ...
>         case VENDOR_SCSI3:
>                 cgc.cmd[0] = READ_TOC;
>                 cgc.cmd[8] = 12;
>                 cgc.cmd[9] = 0x40;
>                 cgc.buffer = buffer;
>                 cgc.buflen = 12;
>                 cgc.quiet = 1;
>                 cgc.data_direction = DMA_FROM_DEVICE;
>                 cgc.timeout = VENDOR_TIMEOUT;
>                 rc = sr_do_ioctl(cd, &cgc);
> 
> At this point rc = 0, buffer = 00 0A 01 01 00 14 01 00 00 00 00 00.
> 
> Then get_sectorsize() does READ_CAPACITY which completes without errors.
> Sometimes the scsi_execute_req() returns e.g.:
> 
> 	buffer = 00 23 01 6F 00 00 08 00
> 
> which results in set_capacity(9176512)
> and sometimes the return value is:
> 
> 	buffer = 00 00 00 00 00 00 08 00
> 
> which sets the media size to 2048 bytes (cat /sys/block/sr0/size returns
> 4, the kernel "attempts to access beyond end of device" etc).
> 
> I'm aware of http://bugzilla.kernel.org/show_bug.cgi?id=9668 and that
> the fix for it is in the tree, but it doesn't really fix this issue for
> me.
> 
> The following work-around makes the disc readable:
> 
> 	if (!cdrom_get_last_written(&cd->cdi, &last_written))
> 		cd->capacity = max_t(long, cd->capacity, last_written);
> 
> +	if (cd->capacity == 1)
> +		cd->capacity = 50 /* GiB */ * 1024 * 1024 / 2;
> +
> 	sector_size = (buffer[4] << 24) |
> 		(buffer[5] << 16) | (buffer[6] << 8) | buffer[7];
> 
> Though I'm sure there is much better way to fix it.

Eeek, ugly.  Isn't there firmware update available for the drive?

> When the drive can't read the medium size, dvd+rw-mediainfo prints:
> 
> INQUIRY:                [_NEC    ][DVD_RW ND-4550A ][1.09]
> GET [CURRENT] CONFIGURATION:
>  Mounted Media:         14h, DVD-RW Sequential
>  Media ID:              MCC 03RG20
>  Current Write Speed:   6.1x1385=8467KB/s
>  Write Speed #0:        6.1x1385=8467KB/s
>  Write Speed #1:        5.1x1385=7056KB/s
>  Write Speed #2:        4.1x1385=5645KB/s
>  Write Speed #3:        3.1x1385=4234KB/s
>  Write Speed #4:        2.0x1385=2822KB/s
>  Write Speed #5:        1.0x1385=1411KB/s
> GET [CURRENT] PERFORMANCE:
>  Write Performance:     1.0x1385=1385KB/s@[0 -> 2297888]
> :-( empty GET PERFORMACE descriptor
> READ DVD STRUCTURE[#10h]:
>  Media Book Type:       00h, DVD-ROM book [revision 0]
>  Legacy lead-out at:    2298496*2KB=4707319808
> READ DVD STRUCTURE[#0h]:
>  Media Book Type:       25h, DVD-R book [revision 5]
>  Last border-out at:    2045*2KB=4188160
> READ DISC INFORMATION:
>  Disc status:           complete
>  Number of Sessions:    1
>  State of Last Session: complete
>  Number of Tracks:      1
> READ FORMAT CAPACITIES:
>  formatted:             0*2048=0
>  00h(800):              2297888*2048=4706074624
>  10h(10):               2297888*2048=4706074624
>  15h(10):               2297888*2048=4706074624
> READ TRACK INFORMATION[#1]:
>  Track State:           complete,damaged
>  Track Start Address:   0*2KB
>  Free Blocks:           0*2KB
>  Track Size:            1*2KB
> FABRICATED TOC:
>  Track#1  :             14@0
>  Track#AA :             14@2297888
>  Multi-session Info:    #1@0
> READ CAPACITY:          0*2048=0
> 
> When the medium size is detected the output differs (the same disc, it
> works and doesn't work randomly):
> - Mounted Media:         14h, DVD-RW Sequential
> + Mounted Media:         11h, DVD-R Sequential
> - Write Performance:     1.0x1385=1385KB/s@[0 -> 2297888]
> -:-( empty GET PERFORMACE descriptor
> + Write Performance:     6.6x1385=9141KB/s@0 -> 16.0x1385=22160KB/s@2294128
> + Speed Descriptor#0:    03/2294128 R@16.0x1385=22160KB/s W@16.0x1385=22160KB/s
> + Speed Descriptor#1:    03/2294128 R@12.0x1385=16620KB/s W@12.0x1385=16620KB/s
> + Speed Descriptor#2:    00/2294128 R@8.0x1385=11080KB/s W@8.0x1385=11080KB/s
> + Speed Descriptor#3:    00/2294128 R@8.0x1385=11080KB/s W@6.0x1385=8310KB/s
> + Speed Descriptor#4:    00/2294128 R@5.0x1385=6925KB/s W@4.0x1385=5540KB/s
> + Speed Descriptor#5:    00/2294128 R@5.0x1385=6925KB/s W@2.0x1385=2770KB/s
> -READ FORMAT CAPACITIES:
> - formatted:             0*2048=0
> - 00h(800):              2297888*2048=4706074624
> - 10h(10):               2297888*2048=4706074624
> - 15h(10):               2297888*2048=4706074624
>  READ TRACK INFORMATION[#1]:
> - Track State:           complete,damaged
> + Track State:           complete incremental
>   Track Start Address:   0*2KB
>   Free Blocks:           0*2KB
> - Track Size:            1*2KB
> + Track Size:            2294128*2KB
> + Last Recorded Address: 2294127*2KB
>  FABRICATED TOC:
>   Track#1  :             14@0
> - Track#AA :             14@2297888
> + Track#AA :             14@2294128
>   Multi-session Info:    #1@0
> -READ CAPACITY:          0*2048=0
> +READ CAPACITY:          2294128*2048=4698374144
> 
> 
> Any ideas?
> 
> Linux v2.6.37.2, x86-64 SMP, the discs are Verbatim DVD-R single layer.
> With the "50 GiB" patch applied and without triggering the SCSI timeout
> (after the disc is inserted - i.e. inserting by hand and waiting for the
> drive to recognize the disc before trying to mount it) the discs are
> perfectly readable. Also, a different drive (such as old DVD-ROM/CD-RW
> Toshiba "combo") reads them without problems.
> 
> This is a PATA drive connected to JMicron JMB363 PATA port.
> -- 
> Krzysztof Halasa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
tejun
