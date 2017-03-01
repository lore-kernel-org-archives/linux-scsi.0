From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Wed, 1 Mar 2017 13:27:41 -0800
Message-ID: <20170301132741.7aa3eb96@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170301104800.00322bd4@xeon-e3>
        <1488394620.2183.20.camel@linux.vnet.ibm.com>
        <1488396022.2183.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:33479 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdCAV3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 16:29:20 -0500
Received: by mail-pg0-f52.google.com with SMTP id 25so24259260pgy.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 13:27:49 -0800 (PST)
In-Reply-To: <1488396022.2183.26.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

Ok here is much better data, wasn't accounting for the offset in the payload


Working 4.10
[    1.020041] scsi host0: storvsc_host_t
[    1.024998] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.027452] hv_storvsc:  payload size 288 count 1 offset 3072 len 36 pfn 0x1f15d0
[    1.029385] hv_storvsc:  sg 0: phys 0x1f15d0000 virt ffff9270b15d0000 offset 0xc00 length 36
[    1.031720] data: 00000000: 00 00 05 02 1f 00 00 02 4d 73 66 74 20 20 20 20  ........Msft    
[    1.033846] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    1.036080] data: 00000020: 31 2e 30 20                                      1.0 
[    1.038249] scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 5
[    1.040394] hv_storvsc: INQUIRY cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    1.041494] scsi host1: storvsc_host_t
[    1.044683] hv_storvsc:  payload size 288 count 1 offset 0 len 255 pfn 0x1f0faf
[    1.046940] hv_storvsc:  sg 0: phys 0x1f0faf000 virt ffff9270b0faf000 offset 0x0 length 255
[    1.048555] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.048556] hv_storvsc:  payload size 288 count 1 offset 2816 len 36 pfn 0x1f15d6
[    1.048557] hv_storvsc:  sg 0: phys 0x1f15d6000 virt ffff9270b15d6000 offset 0xb00 length 36
[    1.048559] data: 00000000: 05 80 00 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    1.048560] data: 00000010: 56 69 72 74 75 61 6c 20 44 56 44 2d 52 4f 4d 20  Virtual DVD-ROM 
[    1.048560] data: 00000020: 31 2e 30 20                                      1.0 
[    1.048590] scsi 1:0:0:0: CD-ROM            Msft     Virtual DVD-ROM  1.0  PQ: 0 ANSI: 0
[    1.048920] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.048920] hv_storvsc:  payload size 288 count 1 offset 1024 len 36 pfn 0x1f15d7
[    1.048921] hv_storvsc:  sg 0: phys 0x1f15d7000 virt ffff9270b15d7000 offset 0x400 length 36
[    1.048922] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.048923] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.048923] data: 00000020: 00 00 00 00                                      ....
[    1.048942] scsi host1: scsi scan: INQUIRY result too short (5), using 36


Broken 4.11

[    1.487930] scsi host0: storvsc_host_t
[    1.541254] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.545242] hv_storvsc:  payload size 288 count 1 offset 768 len 36 pfn 0x1f1196
[    1.545242] hv_storvsc:  sg 0: phys 0x1f1196000 virt ffff9a42f1196000 offset 0x300 length 36
[    1.545242] data: 00000000: 00 00 05 02 1f 00 00 02 4d 73 66 74 20 20 20 20  ........Msft    
[    1.545242] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    1.545242] data: 00000020: 31 2e 30 20                                      1.0 
[    1.570136] scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 5
[    1.571001] scsi host1: storvsc_host_t
[    1.608793] hv_storvsc: INQUIRY cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    1.610316] hv_storvsc:  payload size 288 count 1 offset 0 len 255 pfn 0x1f0577
[    1.611749] hv_storvsc:  sg 0: phys 0x1f0577000 virt ffff9a42f0577000 offset 0x0 length 255
[    1.612788] data: 00000000: 00 00 00 08 00 83 8f b0 b1 b2 ce cf 72 65 61 74  ............reat
[    1.612788] data: 00000010: 65 5f 66 69 6c 65 00 5f 5f 63 72 63 5f 68 69 64  e_file.__crc_hid
[    1.612788] data: 00000020: 5f 72 65 70 6f 72 74 5f 72 61 77 5f 65 76 65 6e  _report_raw_even
[    1.612788] data: 00000030: 74 00 76 66 72 65 65 00 75 6e 72 65 67 69 73 74  t.vfree.unregist
[    1.612788] data: 00000040: 65 72 5f 63 68 72 64 65 76 5f 72 65 67 69 6f 6e  er_chrdev_region
[    1.612788] data: 00000050: 00 6d 75 74 65 78 5f 75 6e 6c 6f 63 6b 00 68 69  .mutex_unlock.hi
[    1.612788] data: 00000060: 64 5f 64 65 62 75 67 5f 65 78 69 74 00 6b 6d 65  d_debug_exit.kme
[    1.612788] data: 00000070: 6d 64 75 70 00 68 69 64 72 61 77 5f 65 78 69 74  mdup.hidraw_exit
[    1.612788] data: 00000080: 00 5f 5f 67 65 74 5f 75 73 65 72 5f 34 00 70 6f  .__get_user_4.po
[    1.612788] data: 00000090: 77 65 72 5f 73 75 70 70 6c 79 5f 70 6f 77 65 72  wer_supply_power
[    1.612788] data: 000000a0: 73 00 64 65 76 69 63 65 5f 64 65 73 74 72 6f 79  s.device_destroy
[    1.612788] data: 000000b0: 00 5f 5f 63 72 63 5f 68 69 64 5f 73 6e 74 6f 33  .__crc_hid_snto3
[    1.612788] data: 000000c0: 32 00 63 61 6e 63 65 6c 5f 77 6f 72 6b 5f 73 79  2.cancel_work_sy
[    1.612788] data: 000000d0: 6e 63 00 73 65 71 5f 70 72 69 6e 74 66 00 64 6f  nc.seq_printf.do
[    1.612788] data: 000000e0: 77 6e 5f 69 6e 74 65 72 72 75 70 74 69 62 6c 65  wn_interruptible
[    1.612788] data: 000000f0: 00 5f 5f 63 72 63 5f 68 69 64 5f 70 61 72 73     .__crc_hid_pars
[    1.649097] hv_storvsc: INQUIRY cmd 0x12 0x1 0x83 scsi status 0x0 srb status 0x1 length 52
[    1.649097] random: fast init done
[    1.649097] hv_storvsc:  payload size 288 count 1 offset 0 len 255 pfn 0x1f0576
[    1.649097] hv_storvsc:  sg 0: phys 0x1f0576000 virt ffff9a42f0576000 offset 0x0 length 255
[    1.649097] data: 00000000: 00 83 00 30 01 01 00 18 4d 53 46 54 20 20 20 20  ...0....MSFT    
[    1.649097] data: 00000010: 43 77 cc 85 5f 19 c2 46 ac 48 c7 33 b9 dd 2d 2a  Cw.._..F.H.3..-*
[    1.649097] data: 00000020: 01 03 00 10 60 02 24 80 43 77 cc 85 5f 19 c7 33  ....`.$.Cw.._..3
[    1.649097] data: 00000030: b9 dd 2d 2a 5f 55 4e 49 51 55 45 5f 49 44 5f 69  ..-*_UNIQUE_ID_i
[    1.649097] data: 00000040: 67 6e 6f 72 65 5f 73 70 65 63 69 61 6c 5f 64 72  gnore_special_dr
[    1.649097] data: 00000050: 69 76 65 72 73 74 79 70 65 31 34 00 5f 5f 70 61  iverstype14.__pa
[    1.649097] data: 00000060: 72 61 6d 5f 69 67 6e 6f 72 65 5f 73 70 65 63 69  ram_ignore_speci
[    1.649097] data: 00000070: 61 6c 5f 64 72 69 76 65 72 73 00 5f 5f 70 61 72  al_drivers.__par
[    1.649097] data: 00000080: 61 6d 5f 73 74 72 5f 69 67 6e 6f 72 65 5f 73 70  am_str_ignore_sp
[    1.649097] data: 00000090: 65 63 69 61 6c 5f 64 72 69 76 65 72 73 00 5f 5f  ecial_drivers.__
[    1.649097] data: 000000a0: 6b 73 79 6d 74 61 62 5f 68 69 64 5f 64 65 62 75  ksymtab_hid_debu
[    1.649097] data: 000000b0: 67 00 5f 5f 6b 73 74 72 74 61 62 5f 68 69 64 5f  g.__kstrtab_hid_
[    1.649097] data: 000000c0: 64 65 62 75 67 00 5f 5f 55 4e 49 51 55 45 5f 49  debug.__UNIQUE_I
[    1.649097] data: 000000d0: 44 5f 64 65 62 75 67 31 33 00 5f 5f 55 4e 49 51  D_debug13.__UNIQ
[    1.649097] data: 000000e0: 55 45 5f 49 44 5f 64 65 62 75 67 74 79 70 65 31  UE_ID_debugtype1
[    1.649097] data: 000000f0: 32 00 5f 5f 70 61 72 61 6d 5f 64 65 62 75 67     2.__param_debug
[    1.805271] input: Microsoft Vmbus HID-compliant Mouse as /devices/0006:045E:0621.0001/input/input1
[    1.805350] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.805351] hv_storvsc:  payload size 288 count 1 offset 2304 len 36 pfn 0x1f1988
[    1.805352] hv_storvsc:  sg 0: phys 0x1f1988000 virt ffff9a42f1988000 offset 0x900 length 36
[    1.805353] data: 00000000: 05 80 00 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    1.805353] data: 00000010: 56 69 72 74 75 61 6c 20 44 56 44 2d 52 4f 4d 20  Virtual DVD-ROM 
[    1.805354] data: 00000020: 31 2e 30 20                                      1.0 
[    1.805379] scsi 1:0:0:0: CD-ROM            Msft     Virtual DVD-ROM  1.0  PQ: 0 ANSI: 0
[    1.812926] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.812927] hv_storvsc:  payload size 288 count 1 offset 2816 len 36 pfn 0x1f198b
[    1.812928] hv_storvsc:  sg 0: phys 0x1f198b000 virt ffff9a42f198b000 offset 0xb00 length 36
[    1.812953] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.812953] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.812954] data: 00000020: 00 00 00 00                                      ....
[    1.813258] scsi host1: scsi scan: INQUIRY result too short (5), using 36
[    1.813271] scsi 1:0:0:1: Direct-Access                                    PQ: 0 ANSI: 0
[    1.817903] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.817921] hv_storvsc:  payload size 288 count 1 offset 2048 len 36 pfn 0x1f198a
[    1.817932] hv_storvsc:  sg 0: phys 0x1f198a000 virt ffff9a42f198a000 offset 0x800 length 36
[    1.817940] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.817941] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.817941] data: 00000020: 00 00 00 00                                      ....



The response from offline DVD device is shorter and contains stale data.
