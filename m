From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 10:41:35 -0800
Message-ID: <20170228104135.50f62736@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/v5469qu4MSHzXbwt90MEgtR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:35808 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdB1SmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 13:42:24 -0500
Received: by mail-pg0-f46.google.com with SMTP id b129so8734051pgc.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 10:41:44 -0800 (PST)
In-Reply-To: <1488301573.3046.9.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org

--MP_/v5469qu4MSHzXbwt90MEgtR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, 28 Feb 2017 09:06:13 -0800
James Bottomley <jejb@linux.vnet.ibm.com> wrote:

> On Tue, 2017-02-28 at 08:32 -0700, Jens Axboe wrote:
> > On 02/28/2017 07:08 AM, Christoph Hellwig wrote:  
> > > On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger wrote:  
> > > > Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each
> > > > I/O")
> > > > 
> > > > but that is already in linux-next.
> > > > 
> > > > Noticed another place where memset(of the data was being done not
> > > > the extra bits.
> > > > Tried this, but didn't fix it either...  
> > > 
> > > Are you using blk-mq or the legacy request code?  
> > 
> > Stephen doesn't have MQ set in the config he posted, I'm assuming he 
> > didn't boot with scsi_mod.use_blk_mq=true. In a previous email, I 
> > asked if turning on MQ makes a difference.  
> 
> OK, since we're not making much progress, Stephen, could you insert
> some debugging into the storvsc driver?  The trace clearly shows we're
> getting zeros back in the buffer when we should have data from the
> initial scan.  Firstly, does the vmbus think it's transferring any data
> for the INQUIRY and READ_CAPACITY commands (looks like
> storvsc_command_completion() data_transfer_length)?  If it does,
> there's probably an issue initialising the sg list.  If it doesn't,
> we're probably sending bogus commands.
> 
> James
> 

This is log of failed boot of linux-next (with blk_mq enabled).
See attached if you want to see exactly what got added.

Sorry don't speak SCSI yet.


[    1.496999] hv_utils: Registering HyperV Utility Driver
[    1.505415] hv_vmbus: registering driver hv_util
[    1.508074] input: AT Translated Set 2 keyboard as /devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0004:00/VMBUS:00/d34b2567-b9b6-42b9-8778-0a4ec0b955bf/serio0/input/input0
[    1.524314] hv_vmbus: registering driver hid_hyperv
[    1.543577] hv_storvsc f71e9b3b-aed9-4dd2-a1ff-c00218a39853: complete init request
[    1.547120] hv_storvsc f71e9b3b-aed9-4dd2-a1ff-c00218a39853: complete init request
[    1.549952] hv_storvsc f71e9b3b-aed9-4dd2-a1ff-c00218a39853: complete init request
[    1.552876] hv_storvsc f71e9b3b-aed9-4dd2-a1ff-c00218a39853: complete init request
[    1.555931] hv_storvsc f71e9b3b-aed9-4dd2-a1ff-c00218a39853: complete init request
[    1.559151] scsi host0: storvsc_host_t
[    1.590197] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.590765] hv_storvsc e7d171c1-a71d-400e-854e-7e0cc000ce3d: complete init request
[    1.590796] hv_storvsc e7d171c1-a71d-400e-854e-7e0cc000ce3d: complete init request
[    1.590820] hv_storvsc e7d171c1-a71d-400e-854e-7e0cc000ce3d: complete init request
[    1.590839] hv_storvsc e7d171c1-a71d-400e-854e-7e0cc000ce3d: complete init request
[    1.590942] hv_storvsc e7d171c1-a71d-400e-854e-7e0cc000ce3d: complete init request
[    1.591506] scsi host1: storvsc_host_t
[    1.600925] hv_utils: Heartbeat IC version 3.0
[    1.619450] input: Microsoft Vmbus HID-compliant Mouse as /devices/0006:045E:0621.0001/input/input1
[    1.620658] hid 0006:045E:0621.0001: input: <UNKNOWN> HID v0.01 Mouse [Microsoft Vmbus HID-compliant Mouse] on 
[    1.627185] hv_utils: Shutdown IC version 3.0
[    1.627280] hv_utils: cannot register PTP clock: 0
[    1.628081] random: fast init done
[    1.628890] hv_utils: TimeSync IC version 4.0
[    1.629407] hv_utils: VSS IC version 5.0
[    1.651620] scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 5
[    1.651956] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.651977] scsi 1:0:0:0: CD-ROM            Msft     Virtual DVD-ROM  1.0  PQ: 0 ANSI: 0
[    1.652279] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.652297] scsi host1: scsi scan: INQUIRY result too short (5), using 36
[    1.652299] scsi 1:0:0:1: Direct-Access                                    PQ: 0 ANSI: 0
[    1.652595] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.652611] scsi 1:0:0:2: Direct-Access                                    PQ: 0 ANSI: 0
[    1.652892] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.652910] scsi 1:0:0:3: Direct-Access                                    PQ: 0 ANSI: 0
[    1.653178] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.653195] scsi 1:0:0:4: Direct-Access                                    PQ: 0 ANSI: 0
[    1.653445] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.653464] scsi 1:0:0:5: Direct-Access                                    PQ: 0 ANSI: 0
[    1.653729] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.653746] scsi 1:0:0:6: Direct-Access                                    PQ: 0 ANSI: 0
[    1.669879] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.670143] scsi 1:0:0:7: Direct-Access                                    PQ: 0 ANSI: 0
[    1.676751] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.743942] hv_storvsc:  IO cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    1.747036] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.768853] hv_storvsc:  IO cmd 0x12 0x1 0x83 scsi status 0x0 srb status 0x1 length 52
[    1.774631] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.777923] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.780840] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.783152] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.786505] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.788084] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 16
[    1.788479] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.811204] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.820176] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.820331] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.826554] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.830840] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.831215] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.837045] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.839988] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.840349] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.868201] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.869954] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.876507] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.876864] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.881562] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.882989] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.886024] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.896434] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.911852] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.915128] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.915373] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.924119] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.927047] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.927308] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.932912] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.957147] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.957686] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.961663] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.964497] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.964832] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.974266] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.977079] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.977447] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.990732] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.995647] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.007795] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.007822] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.016152] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.019489] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.022557] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.025126] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.025351] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.049022] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.054078] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.054462] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.059436] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.061848] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.062183] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.066910] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.070172] hv_storvsc:  IO cmd 0x9e 0x10 0x0 scsi status 0x0 srb status 0x1 length 32
[    2.070334] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.075439] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.099383] hv_storvsc:  IO cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 8
[    2.099707] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.104995] hv_storvsc:  IO cmd 0x12 0x1 0xb2 scsi status 0x0 srb status 0x1 length 8
[    2.105415] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.110451] hv_storvsc:  IO cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    2.110769] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.117049] hv_storvsc:  IO cmd 0x12 0x1 0xb0 scsi status 0x0 srb status 0x1 length 64
[    2.117367] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.122357] hv_storvsc:  IO cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    2.122479] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x2 srb status 0x84 length 0
[    2.122480] hv_storvsc:  error status 0x4
[    2.122511] hv_storvsc:  IO cmd 0x1a 0x0 0x2a scsi status 0x2 srb status 0x6 length 128
[    2.122525] sr 1:0:0:0: [sr0] scsi3-mmc drive: 0x/0x caddy
[    2.122526] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.122828] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.122934] sd 1:0:0:1: Attached scsi generic sg2 type 0
[    2.123014] sd 1:0:0:2: Attached scsi generic sg3 type 0
[    2.123086] hv_storvsc:  IO cmd 0x4a 0x1 0x0 scsi status 0x0 srb status 0x1 length 8
[    2.123124] sd 1:0:0:3: Attached scsi generic sg4 type 0
[    2.123134] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 0
[    2.123135] hv_storvsc:  error status 0x20
[    2.123221] sd 1:0:0:4: Attached scsi generic sg5 type 0
[    2.123193] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.123211] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 0
[    2.123195] hv_storvsc:  error status 0x20
[    2.123212] hv_storvsc:  error status 0x20
[    2.123209] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 0
[    2.123210] hv_storvsc:  error status 0x20
[    2.123248] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.123232] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 0
[    2.123249] hv_storvsc:  error status 0x20
[    2.123232] hv_storvsc:  error status 0x20
[    2.123246] sd 1:0:0:2: [sdc] Sector size 0 reported, assuming 512.
[    2.123248] sd 1:0:0:1: [sdb] Sector size 0 reported, assuming 512.
[    2.123249] sd 1:0:0:2: [sdc] 1 512-byte logical blocks: (512 B/512 B)
[    2.123250] sd 1:0:0:1: [sdb] 1 512-byte logical blocks: (512 B/512 B)
[    2.123250] sd 1:0:0:2: [sdc] 0-byte physical blocks
[    2.123282] sd 1:0:0:1: [sdb] 0-byte physical blocks
[    2.123291] hv_storvsc:  IO cmd 0x1a 0x0 0x3f scsi status 0x0 srb status 0x20 length 4
[    2.123274] hv_storvsc:  IO cmd 0x1a 0x0 0x3f scsi status 0x0 srb status 0x20 length 4
[    2.123288] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.123288] hv_storvsc:  error status 0x20
[    2.123288] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.123288] hv_storvsc:  error status 0x20
[    2.123284] sd 1:0:0:2: [sdc] Write Protect is off
[    2.123291] sd 1:0:0:3: [sdd] Sector size 0 reported, assuming 512.
[    2.123321] sd 1:0:0:5: Attached scsi generic sg6 type 0
[    2.123291] sd 1:0:0:3: [sdd] 1 512-byte logical blocks: (512 B/512 B)
[    2.123294] sd 1:0:0:3: [sdd] 0-byte physical blocks
[    2.123325] hv_storvsc:  IO cmd 0x1a 0x0 0x8 scsi status 0x0 srb status 0x20 length 4
[    2.123305] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 0
[    2.123305] hv_storvsc:  error status 0x20
[    2.123312] hv_storvsc:  IO cmd 0x1a 0x0 0x3f scsi status 0x0 srb status 0x20 length 4
** 8 printk messages dropped ** [    2.123331] sd 1:0:0:4: [sde] 0-byte physical blocks
** 1081 printk messages dropped ** [    2.147310] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 1272 printk messages dropped ** [    2.152802] hv_storvsc:  error status 0x20
** 953 printk messages dropped ** [    2.177996] hv_storvsc:  error status 0x20
** 1023 printk messages dropped ** [    2.183087] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 1930 printk messages dropped ** [    2.190078] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 1726 printk messages dropped ** [    2.195667] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
--MP_/v5469qu4MSHzXbwt90MEgtR
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=storvsc-instrumentation.patch

>From 216c0364bd42f2f5c57623dbfa8f20f28b4bb3b7 Mon Sep 17 00:00:00 2001
From: Stephen Hemminger <sthemmin@microsoft.com>
Date: Tue, 28 Feb 2017 09:38:57 -0800
Subject: [PATCH] storvsc instrumentation

Add some debug output to Hyper-v storvsc driver to log results
of SCSI requests.
---
 drivers/scsi/storvsc_drv.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 638e5f427c90..dbd4c21059ff 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -20,6 +20,8 @@
  *   K. Y. Srinivasan <kys@microsoft.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
@@ -520,6 +522,8 @@ static void storvsc_host_scan(struct work_struct *work)
 	wrk = container_of(work, struct storvsc_scan_work, work);
 	host = wrk->host;
 
+	pr_info(" host scan initiated\n");
+
 	/*
 	 * Before scanning the host, first check to see if any of the
 	 * currrently known devices have been hot removed. We issue a
@@ -923,6 +927,9 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	void (*process_err_fn)(struct work_struct *work);
 	bool do_work = false;
 
+	pr_info(" error status %#x\n",
+		SRB_STATUS(vm_srb->srb_status));
+
 	switch (SRB_STATUS(vm_srb->srb_status)) {
 	case SRB_STATUS_ERROR:
 		/*
@@ -1060,6 +1067,12 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	 * We do this so we can distinguish truly fatal failues
 	 * (srb status == 0x4) and off-line the device in that case.
 	 */
+	pr_info(" IO cmd %#x %#x %#x scsi status %#x srb status %#x length %u\n",
+		stor_pkt->vm_srb.cdb[0], stor_pkt->vm_srb.cdb[1],
+		stor_pkt->vm_srb.cdb[2],
+		vstor_packet->vm_srb.scsi_status,
+		vstor_packet->vm_srb.srb_status,
+		vstor_packet->vm_srb.data_transfer_length);
 
 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
 	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
@@ -1178,6 +1191,9 @@ static void storvsc_on_channel_callback(void *context)
 			if ((request == &stor_device->init_request) ||
 			    (request == &stor_device->reset_request)) {
 
+				dev_info(&device->device, "complete %s request\n",
+					 request == &stor_device->init_request ? "init" : "reset");
+
 				memcpy(&request->vstor_packet, packet,
 				       (sizeof(struct vstor_packet) -
 					vmscsi_size_delta));
-- 
2.11.0


--MP_/v5469qu4MSHzXbwt90MEgtR--
