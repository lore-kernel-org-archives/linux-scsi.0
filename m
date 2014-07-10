From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: scsi-mq V2
Date: Thu, 10 Jul 2014 14:36:40 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B96CF0@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
 <53BD9A24.7010203@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
 <20140710062040.GB20146@infradead.org> <20140710133609.GO12478@kvack.org>
 <20140710135051.GA28227@infradead.org> <53BE9AB1.6090603@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53BE9AB1.6090603@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Thursday, 10 July, 2014 8:53 AM
> To: Christoph Hellwig; Benjamin LaHaise
> Cc: Elliott, Robert (Server Storage); dgilbert@interlog.com; James Bottomley;
> Bart Van Assche; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: scsi-mq V2
> 
> On 2014-07-10 15:50, Christoph Hellwig wrote:
> > On Thu, Jul 10, 2014 at 09:36:09AM -0400, Benjamin LaHaise wrote:
> >> There is one possible concern that could be exacerbated by other changes
> in
> >> the system: if the application is running close to the bare minimum number
> >> of requests allocated in io_setup(), the per cpu reference counters will
> >> have a hard time batching things.  It might be worth testing with an
> >> increased number of requests being allocated if this is the case.
> >
> > Well, Robert said reverting the two aio commits didn't help.  Either he
> > didn't manage to boot into the right kernel, or we need to look
> > elsewhere for the culprit.
> 
> Rob, let me know what scsi_debug setup you use, and I can try and
> reproduce it here as well.
> 
> --
> Jens Axboe

This system has 6 online CPUs and 64 possible CPUs.

Printing avail and req_batch in that loop results in many of these:
** 3813 printk messages dropped ** [10643.503772] ctx ffff88042d8d4cc0 avail=0 req_batch=2

Adding CFLAGS_aio.o := -DDEBUG to the Makefile to enable
those pr_debug prints results in nothing extra printing,
so it's not hitting an error.

Printing nr_events and aio_max_nr at the top of ioctx_alloc results in
these as fio starts:

[  186.339064] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.339065] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.339067] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.339068] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.339069] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.339070] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.339071] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.339071] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.339074] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.339076] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.339076] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.359772] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.359971] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.359972] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.359985] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.359986] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.359987] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.359995] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.359995] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.359998] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.359998] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.362529] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.362529] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.363510] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.363513] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.363520] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.363521] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.398113] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.398115] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.398121] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.398122] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.398124] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.398124] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.398130] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.398131] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.398164] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.398165] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.398499] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.400489] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.401478] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.401491] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.434522] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.434523] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.434526] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.434533] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.435370] hrtimer: interrupt took 6868 ns
[  186.435491] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.435492] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.447864] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.449896] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.449900] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.449901] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.449909] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.449932] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.449933] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.461147] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.461176] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.461177] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.461181] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.461181] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.461184] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.461185] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.461185] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.461191] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.461192] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.474426] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.481353] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.483706] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.483707] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.483709] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.483710] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.483712] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.483717] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.495441] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.495444] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.495445] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.490] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.495451] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.495457] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.495457] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.495460] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.495461] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.495463] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.495464] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.499429] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.499437] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.619785] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.627371] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.627374] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.627383] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.627384] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.627385] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.628371] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.628372] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.630361] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.665329] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.666360] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.666361] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.666366] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.666367] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.666367] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.666369] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[  186.666370] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  186.670369] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.670372] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.670373] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  186.767323] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[  187.211053] ioctx_alloc: nr_events=512 aio_max_nr=65536
[  187.213053] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]

Subsequent added prints showed nr_events coming in with
an initial value of 0x7FFFFFFF in those cases where it showed
as -2 above.  Since the last call had a reasonable value
of 512, it doesn't seem like a problem.


script to create the scsi_debug devices:
#!/bin/bash
devices=6
delay=0         # -2 = jiffy, -1 = hi jiffy, 0 = none, 1..n = longer
ndelay=20000    # 20 us
opts=0x4801     #
every_nth=3
capacity_mib=0
capacity_gib=$((2 * 1024))
lbpu=1
lbpws=1

modprobe -r scsi_debug
modprobe -v scsi_debug fake_rw=1 delay=$delay ndelay=$ndelay num_tgts=$devices opts=$opts every_nth=$every_nth physblk_exp=3 lbpu=$lbpu lbpws=$lbpws dev_size_mb=$capacity_mib virtual_gb=$capacity_gib
lsscsi -s
lsblk
# the assigned /dev names will vary...
for device in /sys/block/sda[h-m]
do
        echo none > $device/device/queue_type
done

fio script:
[global]
direct=1
invalidate=1
ioengine=libaio
norandommap
randrepeat=0
bs=4096
iodepth=96
numjobs=6
runtime=216000
time_based=1
group_reporting
thread
gtod_reduce=1
iodepth_batch=16
iodepth_batch_complete=16
cpus_allowed=0-5
cpus_allowed_policy=split
rw=randread

[4_KiB_RR_drive_ah]
filename=/dev/sdah

[4_KiB_RR_drive_ai]
filename=/dev/sdai

[4_KiB_RR_drive_aj]
filename=/dev/sdaj

[4_KiB_RR_drive_ak]
filename=/dev/sdak

[4_KiB_RR_drive_al]
filename=/dev/sdal

[4_KiB_RR_drive_am]
filename=/dev/sdam

kernel log with some prints in ioctx_alloc:
(2147483647 is 0x7FFFFFFF)

[   94.050877] ioctx_alloc: initial nr_events=2147483647
[   94.053610] ioctx_alloc: num_possible_cpus=64
[   94.055235] ioctx_alloc: after max nr_events=2147483647
[   94.057110] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.059189] ioctx_alloc: initial nr_events=96
[   94.059294] ioctx_alloc: initial nr_events=2147483647
[   94.059295] ioctx_alloc: num_possible_cpus=64
[   94.059295] ioctx_alloc: after max nr_events=2147483647
[   94.059296] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.059296] ioctx_alloc: initial nr_events=96
[   94.059297] ioctx_alloc: num_possible_cpus=64
[   94.059297] ioctx_alloc: after max nr_events=256
[   94.059298] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.075891] ioctx_alloc: num_possible_cpus=64
[   94.077529] ioctx_alloc: after max nr_events=256
[   94.079064] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.087777] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.087810] ioctx_alloc: initial nr_events=2147483647
[   94.087810] ioctx_alloc: num_possible_cpus=64
[   94.087811] ioctx_alloc: after max nr_events=2147483647
[   94.087811] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.087812] ioctx_alloc: initial nr_events=96
[   94.087812] ioctx_alloc: num_possible_cpus=64
[   94.087813] ioctx_alloc: after max nr_events=256
[   94.087813] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.087815] ioctx_alloc: initial nr_events=2147483647
[   94.087816] ioctx_alloc: initial nr_events=2147483647
[   94.087816] ioctx_alloc: num_possible_cpus=64
[   94.087817] ioctx_alloc: initial nr_events=2147483647
[   94.087818] ioctx_alloc: num_possible_cpus=64
[   94.087819] ioctx_alloc: after max nr_events=2147483647
[   94.087819] ioctx_alloc: num_possible_cpus=64
[   94.087820] ioctx_alloc: after max nr_events=2147483647
[   94.087820] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.087821] ioctx_alloc: after max nr_events=2147483647
[   94.087822] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.087822] ioctx_alloc: initial nr_events=96
[   94.087823] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.087824] ioctx_alloc: initial nr_events=96
[   94.087825] ioctx_alloc: initial nr_events=2147483647
[   94.087825] ioctx_alloc: num_possible_cpus=64
[   94.087826] ioctx_alloc: initial nr_events=96
[   94.087826] ioctx_alloc: num_possible_cpus=64
[   94.087827] ioctx_alloc: num_possible_cpus=64
[   94.087827] ioctx_alloc: after max nr_events=256
[   94.087828] ioctx_alloc: num_possible_cpus=64
[   94.087828] ioctx_alloc: after max nr_events=256
[   94.087829] ioctx_alloc: after max nr_events=2147483647
[   94.087829] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.087830] ioctx_alloc: after max nr_events=256
[   94.087831] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.087831] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.087832] ioctx_alloc: nr_events=512 aio_max_nr=65
[   94.087833] ioctx_alloc: initial nr_events=96
[   94.087833] ioctx_alloc: num_possible_cpus=64
[   94.087833] ioctx_alloc: after max nr_events=256
[   94.087834] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.090668] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.259433] ioctx_alloc: initial nr_events=2147483647
[   94.259435] ioctx_alloc: initial nr_events=2147483647
[   94.259436] ioctx_alloc: num_possible_cpus=64
[   94.259437] ioctx_alloc: after max nr_events=2147483647
[   94.259437] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.259438] ioctx_alloc: initial nr_events=96
[   94.259438] ioctx_alloc: num_possible_cpus=64
[   94.259438] ioctx_alloc: after max nr_events=256
[   94.259439] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.259446] ioctx_alloc: initial nr_events=2147483647
[   94.259448] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.259449] ioctx_alloc: initial nr_events=2147483647
[   94.259450] ioctx_alloc: initial nr_events=2147483647
[   94.259450] ioctx_alloc: num_possible_cpus=64
[   94.259451] ioctx_alloc: num_possible_cpus=64
[   94.259452] ioctx_alloc: num_possible_cpus=64
[   94.259452] ioctx_alloc: after max nr_events=2147483647
[   94.259453] ioctx_alloc: after max nr_events=2147483647
[   94.259453] ioctx_alloc: after max nr_events=2147483647
[   94.259454] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.259455] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.259455] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.259456] ioctx_alloc: initial nr_events=96
[   94.259456] ioctx_alloc: initial nr_events=96
[   94.259457] ioctx_alloc: initial nr_events=96
[   94.259457] ioctx_alloc: num_possible_cpus=64
[   94.259458] ioctx_alloc: num_possible_cpus=64
[   94.259458] ioctx_alloc: num_possible_cpus=64
[   94.259459] ioctx_alloc: after max nr_events=256
[   94.259459] ioctx_alloc: after max nr_events=256
[   94.259460] ioctx_alloc: after max nr_events=256
[   94.259460] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   259461] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.259462] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.260539] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.260544] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.262535] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.262550] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.423889] ioctx_alloc: num_possible_cpus=64
[   94.425386] ioctx_alloc: after max nr_events=2147483647
[   94.427327] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.429359] ioctx_alloc: initial nr_events=96
[   94.429448] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.429451] ioctx_alloc: initial nr_events=2147483647
[   94.429452] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.429453] ioctx_alloc: num_possible_cpus=64
[   94.429454] ioctx_alloc: initial nr_events=2147483647
[   94.429454] ioctx_alloc: after max nr_events=2147483647
[   94.429455] ioctx_alloc: num_possible_cpus=64
[   94.429456] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.429456] ioctx_alloc: after max nr_events=2147483647
[   94.429457] ioctx_alloc: initial nr_events=96
[   94.429458] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.429458] ioctx_alloc: num_possible_cpus=64
[   94.429459] ioctx_alloc: initial nr_events=96
[   94.429459] ioctx_alloc: after max nr_events=256
[   94.429460] ioctx_alloc: num_possible_cpus=64
[   94.429461] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.429461] ioctx_alloc: after max nr_events=256
[   94.429462] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.429463] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.430422] hrtimer: interrupt took 6115 ns
[   94.431463] ioctx_alloc: initial nr_events=2147483647
[   94.431464] ioctx_alloc: num_possible_cpus=64
[   94.431464] ioctx_alloc: after max nr_events=2147483647
[   94.431465] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.431465] ioctx_alloc: initial nr_events=96
[   94.431466] ioctx_alloc: num_possible_cpus=64
[   931466] ioctx_alloc: after max nr_events=256
[   94.431466] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.432641] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.580307] ioctx_alloc: num_possible_cpus=64
[   94.581844] ioctx_alloc: after max nr_events=256
[   94.583405] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.585313] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.585319] ioctx_alloc: initial nr_events=2147483647
[   94.585320] ioctx_alloc: num_possible_cpus=64
[   94.585320] ioctx_alloc: after max nr_events=2147483647
[   94.585321] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.585322] ioctx_alloc: initial nr_events=2147483647
[   94.585322] ioctx_alloc: initial nr_events=96
[   94.585323] ioctx_alloc: num_possible_cpus=64
[   94.585324] ioctx_alloc: num_possible_cpus=64
[   94.585324] ioctx_alloc: after max nr_events=2147483647
[   94.585325] ioctx_alloc: after max nr_events=256
[   94.585325] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.585326] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.585327] ioctx_alloc: initial nr_events=2147483647
[   94.585328] ioctx_alloc: initial nr_events=96
[   94.585328] ioctx_alloc: num_possible_cpus=64
[   94.585329] ioctx_alloc: num_possible_cpus=64
[   94.585329] ioctx_alloc: after max nr_events=2147483647
[   94.585330] ioctx_alloc: after max nr_events=256
[   94.585331] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.585331] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.585332] ioctx_alloc: initial nr_events=96
[   94.585332] ioctx_alloc: num_possible_cpus=64
[   94.585333] ioctx_alloc: after max nr_events=256
[   94.585333] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.585372] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.585402] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.588377] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.632221] ioctx_alloc: initial nr_events=2147483647
[   94.632228] ioctx_alloc: initial nr_events=2147483647
[   94.632229] iocalloc: num_possible_cpus=64
[   94.632229] ioctx_alloc: after max nr_events=2147483647
[   94.632230] ioctx_alloc: initial nr_events=2147483647
[   94.632231] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.632232] ioctx_alloc: num_possible_cpus=64
[   94.632232] ioctx_alloc: initial nr_events=96
[   94.632233] ioctx_alloc: after max nr_events=2147483647
[   94.632233] ioctx_alloc: num_possible_cpus=64
[   94.632234] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.632234] ioctx_alloc: after max nr_events=256
[   94.632235] ioctx_alloc: initial nr_events=96
[   94.632236] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.632236] ioctx_alloc: num_possible_cpus=64
[   94.632237] ioctx_alloc: after max nr_events=256
[   94.632237] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.632241] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.633350] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.764384] ioctx_alloc: num_possible_cpus=64
[   94.766038] ioctx_alloc: after max nr_events=2147483647
[   94.767807] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.769568] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.770328] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.773546] ioctx_alloc: initial nr_events=2147483647
[   94.773550] ioctx_alloc: initial nr_events=2147483647
[   94.773551] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.773552] ioctx_alloc: num_possible_cpus=64
[   94.773552] ioctx_alloc: after max nr_events=2147483647
[   94.773553] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.773553] ioctx_alloc: initial nr_events=96
[   94.773554] ioctx_alloc: num_possible_cpus=64
[   94.773554] ioctx_alloc: after max nr_events=256
[   94.773555] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.773569] ioctx_alloc: initial nr_events=2147483647
[   94.773569] ioctx_alloc: num_possible_cpus=64
[   94.773570] ioctx_alloc: after max nr_events=2147483647
[   94.773570] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.773571] ioctx_alloc:itial nr_events=96
[   94.773571] ioctx_alloc: num_possible_cpus=64
[   94.773572] ioctx_alloc: after max nr_events=256
[   94.773572] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.903978] ioctx_alloc: num_possible_cpus=64
[   94.905427] ioctx_alloc: after max nr_events=2147483647
[   94.907320] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.909300] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.909305] ioctx_alloc: initial nr_events=2147483647
[   94.909306] ioctx_alloc: num_possible_cpus=64
[   94.909306] ioctx_alloc: after max nr_events=2147483647
[   94.909307] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.909307] ioctx_alloc: initial nr_events=96
[   94.909308] ioctx_alloc: num_possible_cpus=64
[   94.909308] ioctx_alloc: after max nr_events=256
[   94.909309] ioctx_alloc: initial nr_events=2147483647
[   94.909310] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.909310] ioctx_alloc: num_possible_cpus=64
[   94.909311] ioctx_alloc: after max nr_events=2147483647
[   94.909311] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.909312] ioctx_alloc: initial nr_events=96
[   94.909312] ioctx_alloc: num_possible_cpus=64
[   94.909313] ioctx_alloc: after max nr_events=256
[   94.909313] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.912223] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.940281] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   94.940283] ioctx_alloc: initial nr_events=2147483647
[   94.940284] ioctx_alloc: num_possible_cpus=64
[   94.940285] ioctx_alloc: after max nr_events=2147483647
[   94.940286] ioctx_alloc: initial nr_events=2147483647
[   94.940286] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.940287] ioctx_alloc: num_possible_cpus=64
[   94.940288] ioctx_alloc: initial nr_events=96
[   94.940288] ioctx_alloc: after max nr_events=2147483647
[   94.940289] ioctx_alloc: num_possible_cpus=64
[   94.940290] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   94.940290] ioctx_alloc: after max nr_events=256
[   94.940291] ioctx_alloc: initial nr_events=96
[   94.940291] ioctx_alloc: nr_events=512 amax_nr=65536
[   94.940292] ioctx_alloc: num_possible_cpus=64
[   94.940292] ioctx_alloc: after max nr_events=256
[   94.940293] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   94.942198] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.069096] ioctx_alloc: initial nr_events=96
[   95.069097] ioctx_alloc: num_possible_cpus=64
[   95.069097] ioctx_alloc: after max nr_events=256
[   95.069098] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.087101] ioctx_alloc: initial nr_events=2147483647
[   95.087108] ioctx_alloc: initial nr_events=2147483647
[   95.087108] ioctx_alloc: num_possible_cpus=64
[   95.087109] ioctx_alloc: after max nr_events=2147483647
[   95.087109] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   95.087110] ioctx_alloc: initial nr_events=96
[   95.087110] ioctx_alloc: num_possible_cpus=64
[   95.087111] ioctx_alloc: after max nr_events=256
[   95.087112] ioctx_alloc: initial nr_events=2147483647
[   95.087113] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.087113] ioctx_alloc: num_possible_cpus=64
[   95.087114] ioctx_alloc: after max nr_events=2147483647
[   95.087114] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   95.087115] ioctx_alloc: initial nr_events=96
[   95.087115] ioctx_alloc: num_possible_cpus=64
[   95.087116] ioctx_alloc: after max nr_events=256
[   95.087117] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.087117] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.087120] ioctx_alloc: initial nr_events=2147483647
[   95.087120] ioctx_alloc: num_possible_cpus=64
[   95.087121] ioctx_alloc: after max nr_events=2147483647
[   95.087121] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   95.087122] ioctx_alloc: initial nr_events=96
[   95.087122] ioctx_alloc: num_possible_cpus=64
[   95.087123] ioctx_alloc: after max nr_events=256
[   95.087123] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.087126] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.091100] ioctx_alloc: initial nr_events=2147483647
[   95.091100] ioctx_alloc: num_possible_cpus=64
[   95.091100] ioctx_alloc: after max nr_events=2147483647
[   95.091101] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   95.091101] ioctx_alloc: initial nr_events=96
[   95.091102] ioctx_alloc: num_possible_cpus=64
[   95.091102] ioctx_alloc: after max nr_events=256
[   95.091103] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.145236] ioctx_alloc: num_possible_cpus=64
[   95.146754] ioctx_alloc: after max nr_events=2483647
[   95.248567] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   95.250432] ioctx_alloc: initial nr_events=2147483647
[   95.250438] ioctx_alloc: initial nr_events=2147483647
[   95.250439] ioctx_alloc: num_possible_cpus=64
[   95.250439] ioctx_alloc: after max nr_events=2147483647
[   95.250440] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   95.250440] ioctx_alloc: initial nr_events=96
[   95.250441] ioctx_alloc: num_possible_cpus=64
[   95.250441] ioctx_alloc: after max nr_events=256
[   95.250442] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.250450] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.250457] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.251027] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.251038] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.252029] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.275430] ioctx_alloc: num_possible_cpus=64
[   95.277000] ioctx_alloc: after max nr_events=2147483647
[   95.278747] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   95.280540] ioctx_alloc: initial nr_events=2147483647
[   95.280554] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.284457] ioctx_alloc: num_possible_cpus=64
[   95.285998] ioctx_alloc: after max nr_events=2147483647
[   95.287764] ioctx_alloc: nr_events=-2 aio_max_nr=65536
[   95.289455] ioctx_alloc: initial nr_events=96
[   95.290901] ioctx_alloc: num_possible_cpus=64
[   95.292450] ioctx_alloc: after max nr_events=256
[   95.294013] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.295873] sd 5:0:3:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.381941] ioctx_alloc: initial nr_events=96
[   95.383764] ioctx_alloc: num_possible_cpus=64
[   95.385303] ioctx_alloc: after max nr_events=256
[   95.386959] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.391935] ioctx_alloc: initial nr_events=96
[   95.393493] ioctx_alloc: num_possible_cpus=64
[   95.394994] ioctx_alloc: after max nr_events=256
[   95.396751] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.421964] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.425953] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[   95.611825] ioctx_alloc: initial nr_events=96
[   95.613398] ioctx_alloc: num_possible_cpus=64
[   95.614893] ioctx_alloc: after max nr_events=256
[   95.616615] ioctx_alloc: nr_events=512 aio_max_nr=65536
[   95.645844] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
