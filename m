From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: RE: Why is the kernel complaining about large SCSI LUNs
Date: Wed, 12 Jan 2005 18:12:32 -0500
Message-ID: <a0610056ebe0b5e0291be@[129.98.90.227]>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw.aecom.yu.edu ([129.98.1.16]:15572 "EHLO
	mailgw.aecom.yu.edu") by vger.kernel.org with ESMTP id S261219AbVALXLv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 18:11:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsil.com, James.Bottomley@SteelEye.com

I previously asked about the cause of this message

>  scsi: host 1 channel 0 id 0 lun 0x5a5a5a5a5a5a5a5a has a LUN larger
>  than currently supported.

I recompiled the kernel with debug defines turned on for the LSI 
card, and it spewed out the following on bootup. Oddly, that message 
is not there now.


Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e000c
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2480,mr=0000000000000000,sc=00000101fcb88e08,idx=12)
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0011 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   0000c801 00000800 00001000 0c083440 
d3001000 0f643000 00000000 00000000
Jan 12 18:01:13 [kernel]   00000000 00000000 00000000 00000000 
04010404 0000ff00
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068662 
req_idx=17 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2660 idx=17
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0011 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 0000c801 00000800 00001000 0c083440 d3001000 
0f643000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 04010404 
0000ff00 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0011
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2660,mr=0000000000000000,sc=00000101fcb88e08,idx=17)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac26c0
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac26c0:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0012 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   0000d001 00000800 00001000 0c083480 
d3001000 0f644000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c0686c2 
req_idx=18 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac26c0 idx=18
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0012 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 0000d001 00000800 00001000 0c083480 d3001000 
0f644000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0012
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac26c0,mr=0000000000000000,sc=00000101fcb88e08,idx=18)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2720:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0013 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   0000d801 00000800 00001000 0c0834c0 
d3001000 0f645000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068722 
req_idx=19 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2720 idx=19
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0017 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 0000f801 00000800 00001000 0c0835c0 d3001000 
0f649000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0017
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac28a0,mr=0000000000000000,sc=00000101fcb88e08,idx=23)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2900
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2900:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0018 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00000002 00000800 00001000 0c083600 
d3001000 0f64a000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068902 
req_idx=24 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2900 idx=24
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2a80
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2a80:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e001c 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00002802 00000800 00001000 0c083700 
d3001000 0f64f000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068a82 
req_idx=28 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2a80 idx=28
Jan 12 18:01:13 [kernel] 00000000 01004010 000e001c 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 00002802 00000800 00001000 0c083700 d3001000 
0f64f000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e001c
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2a80,mr=0000000000000000,sc=00000101fcb88e08,idx=28)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2b40:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e001e 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00003002 00000800 00001000 0c083780 
d3001000 0f650000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068b42 
req_idx=30 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2b40 idx=30
Jan 12 18:01:13 [kernel] 00000000 01004010 000e001e 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 00003002 00000800 00001000 0c083780 d3001000 
0f650000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e001e
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2b40,mr=0000000000000000,sc=00000101fcb88e08,idx=30)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2c00
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2c00:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0020 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00003802 00000800 00001000 0c083800 
d3001000 0f651000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068c02 
req_idx=32 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2c00 idx=32
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0020 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 00003802 00000800 00001000 0c083800 d3001000 
0f651000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0020
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2c00,mr=0000000000000000,sc=00000101fcb88e08,idx=32)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2ba0
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2ba0:
Jan 12 18:01:13 [kernel]   00004002 00000800 00001000 0c0837c0 
d3001000 0f652000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068ba2 
req_idx=31 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2ba0 idx=31
Jan 12 18:01:13 [kernel] 00000000 01004010 000e001f 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 00004002 00000800 00001000 0c0837c0 d3001000 
0f652000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e001f
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2ba0,mr=0000000000000000,sc=00000101fcb88e08,idx=31)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2cc0
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2cc0:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0022 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00004802 00000800 00001000 0c083880 
d3001000 0f653000 00000000 00000000
Jan 12 18:01:13 [kernel]   00000000 00000000 00000000 00000000 
00000000 00000000 f7e47d88 00000100
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068cc2 
req_idx=34 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2cc0 idx=34
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0022 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 00004802 00000800 00001000 0c083880 d3001000 
0f653000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 f7e47d88 00000100
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0022
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2cc0,mr=0000000000000000,sc=00000101fcb88e08,idx=34)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2c60
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2c60:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0021 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00005002 00000800 00001000 0c083840 
d3001000 0f654000
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2c60 idx=33
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0021 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 00005002 00000800 00001000 0c083840 d3001000 
0f654000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0021
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2c60,mr=0000000000000000,sc=00000101fcb88e08,idx=33)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2d80
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2d80:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0024 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00005802 00000800 00001000 0c083900 
d3001000 0f655000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068d82 
req_idx=36 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2d80 idx=36
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0024 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 00005802 00000800 00001000 0c083900 d3001000 
0f655000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0024
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2d80,mr=0000000000000000,sc=00000101fcb88e08,idx=36)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2d20
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2d20:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0023 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00006002 00000800 00001000 0c0838c0 
d3001000 0f656000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068d22 
req_idx=35 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2d20 idx=35
Jan 12 18:01:13 [kernel] 00006002 00000800 00001000 0c0838c0 d3001000 
0f656000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0023
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2d20,mr=0000000000000000,sc=00000101fcb88e08,idx=35)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2de0
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2de0:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0025 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00006802 00000800 00001000 0c083940 
d3001000 0f657000 00000000 00000000
Jan 12 18:01:13 [kernel]   00000000 00000000 00000000 00000000 
00000000 00000000 f7e47d88 00000100
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068de2 
req_idx=37 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2de0 idx=37
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0025 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] 00006802 00000800 00001000 0c083940 d3001000 
0f657000 00000000 00000000
Jan 12 18:01:13 [kernel] 00000000 00000000 00000000 00000000 00000000 
00000000 f7e47d88 00000100
Jan 12 18:01:13 [kernel] mptbase: ioc0: Got TURBO reply req_idx=000e0025
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ScsiDone 
(mf=00000101ffac2de0,mr=0000000000000000,sc=00000101fcb88e08,idx=37)
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: mpt_get_msg_frame(14,0), got 
mf=00000101ffac2e40
Jan 12 18:01:13 [kernel] mptscsih: ioc0: ERROR - Single Buffer 
RequestNB=2, sgeOffset=60
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2e40:
Jan 12 18:01:13 [kernel]   00000000 01004010 000e0026 00000000 
00000000 02000000 00000088 00950100
Jan 12 18:01:13 [kernel]   00007002 00000800 00001000 0c083980 
d3001000 0f658000
Jan 12 18:01:13 [kernel] mptbase: ioc0: mf_dma_addr=c068e42 
req_idx=38 RequestNB=2
Jan 12 18:01:13 [kernel] mptscsih: ioc0: Issued SCSI cmd 
(00000101fcb88e08) mf=00000101ffac2e40 idx=38
Jan 12 18:01:13 [kernel] 00000000 01004010 000e0026 00000000 00000000 
02000000 00000088 00950100
Jan 12 18:01:13 [kernel] mptscsih: ioc0: qcmd: 
SCpnt=00000101fcb88e08, done()=ffffffff802a2140
Jan 12 18:01:13 [kernel] mptbase: ioc0: About to Put msg frame @ 
00000101ffac2ea0:
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
