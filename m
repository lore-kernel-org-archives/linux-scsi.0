From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: Adaptec 39160 / Yamaha CRW8424S CD burning
Date: Mon, 13 Jan 2003 01:16:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113091635.GC9558@holomorphy.com>
References: <20030113071543.GA9558@holomorphy.com> <3E22738D.3020000@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E22738D.3020000@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

On Mon, Jan 13, 2003 at 07:06:37PM +1100, Douglas Gilbert wrote:
> Depending on which version of cdrecord you are using,
> cdrecord will get to the SCSI Yamaha burner via:
>   - scsi generic (sg) device (probably /dev/sg1)
>   - or directly to /dev/scd0 (via the SG_IO ioctl in
>     the block layer)
>   - or via /dev/scd0 using the CDROM_PACKET_COMMAND
>     ioctl
> Could you determine which one is happening? If the
> sg route is being used then the individual SCSI
> commands can be seen by observing 'cat /proc/scsi/sg/debug'
> while the burn is in progress. What version of cdrecord
> are you using and what does its output look like?

I'm trying Jens' patched cdrecord from people/axboe/tools/ on kernel.org
and got:

$ cat /proc/scsi/sg/debug
dev_max(currently)=6 max_active_device=3 (origin 1)
 def_reserved_size=32768
 >>> device=sg1 scsi0 chan=0 id=3 lun=0   em=0 sg_tablesize=128 excl=0
   FD(1): timeout=20500ms bufflen=129024 (res)sgat=4 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=0
     rb>> act: id=0 blen=63504 t_o/elap=40000/15ms sgat=2 op=0x2a
$ cat /proc/scsi/sg/debug
dev_max(currently)=6 max_active_device=3 (origin 1)
 def_reserved_size=32768
 >>> device=sg1 scsi0 chan=0 id=3 lun=0   em=0 sg_tablesize=128 excl=0
   FD(1): timeout=20500ms bufflen=129024 (res)sgat=4 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=0
     rb>> act: id=0 blen=63504 t_o/elap=40000/11ms sgat=2 op=0x2a
$ cat /proc/scsi/sg/debug
dev_max(currently)=6 max_active_device=3 (origin 1)
 def_reserved_size=32768
 >>> device=sg1 scsi0 chan=0 id=3 lun=0   em=0 sg_tablesize=128 excl=0
   FD(1): timeout=20500ms bufflen=129024 (res)sgat=4 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=0
     rb>> act: id=0 blen=63504 t_o/elap=40000/65ms sgat=2 op=0x2a

