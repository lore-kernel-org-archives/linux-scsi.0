From: Roberto Nibali <ratz@tac.ch>
Subject: Possible AIC problems?
Date: Mon, 04 Aug 2003 11:30:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F2E27B0.6040303@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.terreactive.ch ([212.90.202.121]:56561 "HELO
	toe.terreactive.ch") by vger.kernel.org with SMTP id S271688AbTHDJa1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2003 05:30:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I've got a "sick" productive machine (file server) which crashes infrequently. 
I've done several kernel upgrades and had no success so far. I am specifically 
interested in knowing what the following two entries mean:

zap May 12 07:30:14 SCSI disk error : host 1 channel 0 id 3 lun 1 return code = 8
zap May 12 07:30:14 I/O error: dev 08:31, sector 4128

After such a message the kernel seems to lock up hard, no sysrq possible 
according to the admin, console is completely unusuable. I'm running an SMP (HT 
enabled) kernel 2.4.21-rc6 plus the Adaptec AIC7xxx driver version 6.2.35. 
Please tell me if you need more information and which ones. Unfortunately there 
is no oops.

We have a RAID attached to it so maybe it is also the cable which is broken, as 
the indicated failing devices are all RAID devices. I also do not have 
all-the-time access to this machine (debugging could be hard) as it is operated 
by someone else in the company, I only provide the kernel.

zap:~# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: IBM      Model: IC35L018UCD210-0 Rev: S5CS
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
   Vendor: IBM      Model: IC35L018UCD210-0 Rev: S5CS
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 06 Lun: 00
   Vendor: ESG-SHV  Model: SCA HSBP M15     Rev: 0.10
   Type:   Processor                        ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 03 Lun: 00
   Vendor: JetStor  Model: II-LVD           Rev:
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 03 Lun: 01
   Vendor: JetStor  Model: II-LVD           Rev:
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 03 Lun: 02
   Vendor: JetStor  Model: II-LVD           Rev:
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 00
   Vendor: COMPAQ   Model: SuperDLT1        Rev: 2E2E
   Type:   Sequential-Access                ANSI SCSI revision: 02
zap:~#

zap:~# cat /proc/scsi/aic7xxx/0
Adaptec AIC7xxx driver version: 6.2.35
Adaptec aic7899 Ultra160 SCSI adapter
aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
Allocated SCBs: 254, SG List Length: 102

Serial EEPROM:
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0x58f4 0x5d5e 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x144f

Target 0 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
         Goal: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
         Curr: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
         Channel A Target 0 Lun 0 Settings
                 Commands Queued 60975
                 Commands Active 0
                 Command Openings 128
                 Max Tagged Openings 128
                 Device Queue Frozen Count 0
Target 1 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 2 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 3 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
         Goal: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
         Curr: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
         Channel A Target 3 Lun 0 Settings
                 Commands Queued 9
                 Commands Active 0
                 Command Openings 253
                 Max Tagged Openings 253
                 Device Queue Frozen Count 0
Target 4 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 5 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 6 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
         Goal: 3.300MB/s transfers
         Curr: 3.300MB/s transfers
         Channel A Target 6 Lun 0 Settings
                 Commands Queued 1
                 Commands Active 0
                 Command Openings 1
                 Max Tagged Openings 0
                 Device Queue Frozen Count 0
Target 7 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 8 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 9 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 10 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 11 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 12 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 13 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 14 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 15 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
zap:~#

While we go on checking the cables I sure would appreciate if someone could give 
me some more input on the problem. So far we had 4 reported incidents by our 
admin and he listed the appropriate traces as follows:

#############################################################################
#
# 0 1 .  I n c i d e n t
#
#############################################################################

  /data/log/tac/zap 20030512.base: May 12 07:30:14 zap May 12 07:30:14 SCSI disk 
error : host 1 channel 0 id 3 lun 1 return code = 8
  /data/log/tac/zap 20030512.base: May 12 07:30:14 zap May 12 07:30:14 I/O 
error: dev 08:31, sector 4128

### E n d  - I n c i d e n t ################################################


#############################################################################
#
# 0 2 .  I n c i d e n t
#
#############################################################################

  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 counted 
segments is 1f
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xdacccd40, blocks 8, addr 0x31053fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xdacccce0, blocks 8, addr 0x166fefff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xdaccc740, blocks 8, addr 0x267fcfff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xdaccc200, blocks 8, addr 0x2598efff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xd9b24f80, blocks 8, addr 0x21d9dfff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xd9b24f20, blocks 8, addr 0x249f6fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xd9b24e60, blocks 8, addr 0x2bb75fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xd9b24aa0, blocks 8, addr 0x26a59fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xd9b248c0, blocks 8, addr 0x17bf1fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xd9b247a0, blocks 8, addr 0x16a7ffff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xd9b24500, blocks 8, addr 0x<6>Jul 5 06:03:04
 
s_int@hop Packet log: input DENY eth0 PROTO=17
 
172.23.3.4:55775 239.255.255.253:427 L=77 S=0x00
 
I=11719 F=0x0000 T=255 (#80) Rule=5000
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xd9b240e0, blocks 8, addr 0x20e01fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc5093d20, blocks 8, addr 0x92adfff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc5093c60, blocks 8, addr 0x32ef7fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc5093ae0, blocks 8, addr 0x1049bfff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc50939c0, blocks 8, addr 0x1f70cfff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc5093840, blocks 8, addr 0x329b5fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc5093780, blocks 8, addr 0x152d8fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc50936c0, blocks 8, addr 0x132d9fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc5093600, blocks 8, addr 0x2f603fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc50935a0, blocks 8, addr 0x2625efff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc5093540, blocks 8, addr 0x182fffff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Segment 
0xc5093180, blocks 8, addr 0x25443fff
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 SCSI disk 
error : host 1 channel 0 id 3 lun 2 return code = 8
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Incorrect 
segment count at 0xc01ca3acnr_segments is 20
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 I/O error: 
dev 08:43, sector 13571448
  /data/log/tac/zap 20030705.base: Jul 5 06:03:05 zap Jul 5 06:03:05 Flags 1 0
  /data/log/tac/zap 20030705.base: Jul 5 06:03:02 zap Jul 5 06:03:02 SCSI disk 
error : host 1 channel 0 id 3 lun 2 return code = 8
  /data/log/tac/zap 20030705.base: Jul 5 06:03:02 zap Jul 5 06:03:02 I/O error: 
dev 08:43, sector 58144
  /data/log/tac/zap 20030705.base: Jul 5 06:02:13 zap Jul 5 06:02:13 
nmbd[29966]: [2003/07/05 06:02:13, 0] 
nmbd/nmbd_packets.c:process_browse_packet(1063)
  /data/log/tac/zap 20030705.base: Jul 5 06:02:13 zap Jul 5 06:02:13 
nmbd[29966]: process_browse_packet: Discarding datagram from IP 192.168.99.2. 
Source name ZAP<00> is one of our names !
  /data/log/tac/zap 20030705.base: Jul 5 06:00:03 zap Jul 5 06:00:03 
/root/bin/watchsyslogng[21259]: /root/bin/watchsyslogng: No 
`/usr/sbin/syslog-ng\' daemon running
  /data/log/tac/zap 20030705.mark: Jul 5 06:00:02 zap Jul 5 06:00:02 syslog: MARK
  /data/log/tac/zap 20030705.base: Jul 5 04:53:37 zap Jul 5 04:53:37 SCSI disk 
error : host 1 channel 0 id 3 lun 2 return code = 8
  /data/log/tac/zap 20030705.base: Jul 5 04:53:37 zap Jul 5 04:53:37 I/O error: 
dev 08:42, sector 25288
  /data/log/tac/zap 20030705.base: Jul 5 04:53:35 zap Jul 5 04:53:35 SCSI disk 
error : host 1 channel 0 id 3 lun 2 return code = 8
  /data/log/tac/zap 20030705.base: Jul 5 04:53:35 zap Jul 5 04:53:35 I/O error: 
dev 08:42, sector 25280
  /data/log/tac/zap 20030705.base: Jul 5 04:52:36 zap Jul 5 04:52:36 SCSI disk 
error : host 1 channel 0 id 3 lun 2 return code = 8
  /data/log/tac/zap 20030705.base: Jul 5 04:52:36 zap Jul 5 04:52:36 I/O error: 
dev 08:42, sector 26340424
  /data/log/tac/zap 20030705.base: Jul 5 04:04:22 zap Jul 5 04:04:22 SCSI disk 
error : host 1 channel 0 id 3 lun 2 return code = 8
  /data/log/tac/zap 20030705.base: Jul 5 04:04:22 zap Jul 5 04:04:22 I/O error: 
dev 08:43, sector 46808
### E n d  - I n c i d e n t ################################################



#############################################################################
#
# 0 3 .  I n c i d e n t
#
#############################################################################

Jul 26 04:44:01 zap Jul 26 04:43:59 Segment 0xdd0ae240, blocks 8, addr 
0x3a9<43>Jul 26 04:44:01 s_int@dev syslog: bloody cron
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xe34714a0, blocks 8, addr 0x3ba22fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xd6c7b7e0, blocks 8, addr 0x39de9fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xe8810ae0, blocks 8, addr 0x3a681fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xdeabee60, blocks 8, addr 0x1f5a1fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xe6d576e0, blocks 8, addr 0x2ea08fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xe3c38e00, blocks 8, addr 0x5628fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xf6c0af00, blocks 8, addr 0x2d97bfff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xd4b72d40, blocks 8, addr 0x21c7cfff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xeb265900, blocks 8, addr 0x2b62ffff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xc36a5b40, blocks 8, addr 0x18ff1fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xf3d09140, blocks 8, addr 0x2000dfff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xeea3f5c0, blocks 8, addr 0xa074fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xf73e4120, blocks 8, addr 0x20367fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xf76a1860, blocks 8, addr 0x203e6fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xed4ba4a0, blocks 8, addr 0x19149fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xedfe1a40, blocks 8, addr 0x1303cfff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xdc423300, blocks 8, addr 0x2e57fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xc28c32c0, blocks 8, addr 0x4a9bfff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xc28c36e0, blocks 8, addr 0x17bdafff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xc28c31a0, blocks 8, addr 0x157dffff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xda43ae40, blocks 8, addr 0x274c0fff
Jul 26 04:43:59 zap Jul 26 04:43:59 Segment 0xe4669660, blocks 8, addr 0x16d8bfff
Jul 26 04:43:59 zap Jul 26 04:43:59 Flags 1 0
Jul 26 04:43:59 zap Jul 26 04:43:59 counted segments is 1f
Jul 26 04:43:59 zap Jul 26 04:43:59 Incorrect segment count at 
0xc01ca3acnr_segments is 20
Jul 26 04:43:59 zap Jul 26 04:43:59 I/O error: dev 08:34, sector 13642720
Jul 26 04:43:59 zap Jul 26 04:43:59 SCSI disk error : host 1 channel 0 id 3 lun 
1 return code = 8
Jul 26 04:43:06 zap Jul 26 04:43:06 lockd: cannot monitor 172.23.1.1
Jul 26 04:43:06 zap Jul 26 04:43:06 lockd: cannot monitor 172.23.1.1
Jul 26 04:43:04 zap Jul 26 04:43:04 lockd: cannot monitor 172.23.1.1
Jul 26 04:43:04 zap Jul 26 04:43:04 lockd: cannot monitor 172.23.1.1
Jul 26 04:40:01 zap Jul 26 04:40:01 /root/bin/watchsyslogng[12344]: 
/root/bin/watchsyslogng: No `/usr/sbin/syslog-ng\' daemon running
### E n d  - I n c i d e n t ################################################


#############################################################################
#
# 0 4 .  I n c i d e n t
#
#############################################################################
/data/log/tac/zap 20030803.base: Aug 3 07:54:04 zap Aug 3 07:54:04 SCSI disk 
error : host 1 channel 0 id 3 lun 1 return code = 8
/data/log/tac/zap 20030803.base: Aug 3 07:54:04 zap Aug 3 07:54:04 I/O error: 
dev 08:34, sector 6291536
/data/log/tac/zap 20030803.base: Aug 3 07:53:50 zap Aug 3 07:53:50 lockd: cannot 
monitor 172.23.1.1
/data/log/tac/zap 20030803.base: Aug 3 07:53:50 zap Aug 3 07:53:50 lockd: cannot 
monitor 172.23.1.1
/data/log/tac/zap 20030803.mark: Aug 3 07:50:01 zap Aug 3 07:50:01 syslog: MARK
/data/log/tac/zap 20030803.base: Aug 3 07:50:01 zap Aug 3 07:50:01 
/root/bin/watchsyslogng[23581]: /root/bin/watchsyslogng: No 
`/usr/sbin/syslog-ng\' daemon running
/data/log/tac/zap 20030803.base: Aug 3 07:49:51 zap Aug 3 07:49:51 lockd: cannot 
monitor 172.23.1.1
/data/log/tac/zap 20030803.base: Aug 3 07:49:51 zap Aug 3 07:49:51 lockd: cannot 
monitor 172.23.1.1
/data/log/tac/zap 20030803.base: Aug 3 07:49:50 zap Aug 3 07:49:50 lockd: cannot 
monitor 172.23.1.1
/data/log/tac/zap 20030803.base: Aug 3 07:49:50 zap Aug 3 07:49:50 lockd: cannot 
monitor 172.23.1.1
/data/log/tac/zap 20030803.base: Aug 3 07:48:03 zap Aug 3 07:48:03 nmbd[819]: 
[2003/08/03 07:48:03, 0] 
nmbd/nmbd_browsesync.c:find_domain_master_name_query_fail(358)
/data/log/tac/zap 20030803.base: Aug 3 07:48:03 zap Aug 3 07:48:03 nmbd[819]: 
find_domain_master_name_query_fail:
/data/log/tac/zap 20030803.base: Aug 3 07:48:03 zap Aug 3 07:48:03 nmbd[819]: 
Unable to sync browse lists in this workgroup.
/data/log/tac/zap 20030803.base: Aug 3 07:48:03 zap Aug 3 07:48:03 nmbd[819]:
### E n d  - I n c i d e n t ################################################

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc

