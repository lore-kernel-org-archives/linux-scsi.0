From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Adaptec 39160 / Yamaha CRW8424S CD burning
Date: Tue, 14 Jan 2003 10:01:24 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E234544.6050508@torque.net>
References: <20030113071543.GA9558@holomorphy.com> <3E22738D.3020000@torque.net> <20030113091635.GC9558@holomorphy.com> <20030113093833.GD9558@holomorphy.com> <20030113103502.GA940@holomorphy.com> <20030113125723.GD940@holomorphy.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com, axboe@suse.de

William Lee Irwin III wrote:
> On Mon, Jan 13, 2003 at 02:35:02AM -0800, William Lee Irwin III wrote:
> 
>>Okay, 2.5.56-mm1 + your SG_IO fixes got the following in the debug stuff
>>with Jens' patched cdrecord:
> 
> 
> I'm giving up at this point. I got another skipping CD (again, this
> produces playable CD's in 2.4.x, and the only difference is the kernel):

Bill,
Thanks for all the testing.

One comment:
'cat /proc/scsi/sg/debug' will only show SCSI commands
being sent to the burner when the sg interface is being used.
So it seems that your earlier posts showed sg being
used in all cases.
For example:
 > $ cat /proc/scsi/sg/debug
 > dev_max(currently)=6 max_active_device=3 (origin 1)
 >  def_reserved_size=32768
 >  >>> device=sg1 scsi0 chan=0 id=3 lun=0   em=0 sg_tablesize=128 excl=0
 >    FD(1): timeout=20500ms bufflen=129024 (res)sgat=4 low_dma=0
 >    cmd_q=1 f_packid=0 k_orphan=0 closed=0
 >      rb>> act: id=0 blen=63504 t_o/elap=40000/15ms sgat=2 op=0x2a
shows a SCSI WRITE (10) command in progress. This is typical
for cdrecord using sg during a burn.

> Included as a MIME attachment is a compressed log of the following cmd:
> 
> /share/projects/kernel/hacking/misc/axboe/cdrtools-1.11/cdrecord/OBJ/i686-linux-cc/cdrecord -v -pad -swab debug=2 fs=16m timeout=120 speed=0 dev=0,3,0 -audio `cat tracks` >/share/projects/kernel/hacking/cdrecord.log 2>&1

Well that log looks fine, no errors or underruns. cdrecord
checks the status of each executed command quite closely
and would not complete if there was something wrong.

> run on 2.5.56-mm1 with your (Doug Gilbert's) SG_IO fixes.
> 
> If there's some fix for this this, I'd be much obliged if it were
> included in mainline.

In this case my SG_IO fixes should not have made any difference
as they are not in the code path when sg is being used.
Unfortunately those fixes didn't get into lk 2.5.57 .

So I can't explain what you are seeing. It's probably
time to pull out my Yamaha 4416 (SCSI burner) and waste
my own CDRs to see if I get the same problem :-)

Doug Gilbert




