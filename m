From: "Andrew Kinney" <andykinney@advantagecom.net>
Subject: PERC3/DI aacraid failed disk detection slow
Date: Sun, 13 Mar 2005 02:11:32 -0800
Message-ID: <4233A154.32754.34B61B97@localhost>
Reply-To: andykinney@advantagecom.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from mail.advantagecom.net ([65.103.151.155]:45197 "EHLO
	mail.advantagecom.net") by vger.kernel.org with ESMTP
	id S263461AbVCMKNT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Mar 2005 05:13:19 -0500
Received: from SCSI-MONSTER (scsi-monster.advantagecom.net [207.109.186.200])
	by mail.advantagecom.net (8.11.6/8.11.6) with ESMTP id j2DADIf05970
	for <linux-scsi@vger.kernel.org>; Sun, 13 Mar 2005 02:13:18 -0800
Content-description: Mail message body
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I'm fairly sure that this is a firmware issue and not a Linux issue, 
but I'm hoping someone on this list would know who is the right 
person to contact about firmware issues.  If you know the right 
person to contact, please email me off list with their contact info. 

The Dell techs will replace the disk, of course, but that won't solve 
the real problem that caused the system to become unresponsive when 
the disk failed.  We've been grappling with them for just over a year 
on this issue and never once have they put me in touch with a 
firmware programmer, though they've replaced every component in the 
system during the same time.

We have two identical systems exhibiting these non-reproducable 
symptoms that only show with full production use (ugh). First it was 
drive ID 1 (the 2nd drive) in both systems.  Replaced those.  Now 
it's drive ID 4 (the 5th drive) in both systems.  Replaced it on one 
system and am now replacing it on the second system.  The difference 
between the original drive and the replacement?  The original was a 
QUANTUM  ATLAS10K3_36_SCA  rev. 120G U160 and the replacement was 
either Fujitsu U320 or Seagate U320 depending on what Dell shipped on 
that day.  I'm fairly sure that the Quantums just have a slightly 
flaky drive firmware that locks up under certain conditions unique to 
our I/O patterns, but since there is no firmware being developed for 
those drives the only option is to replace the drive with a different 
brand.

At any rate, since the pattern holds with both systems, it most 
probably points at a misbehaved drive model.  However, the RAID 
controller is still at fault for the entire system going down because 
it didn't mark the drive as failed and return control to the OS 
within 60 seconds.

The system became unresponsive. SNMP graphing showed load of 495 and 
all network activity stopped shortly after disk failure.  Probably 
resulted from build-up of block I/O after the kernel kicked the 
unresponsive storage offline.

The specific error message repeating across the console as fast as it 
would print was:

Assertion failure in do_get_write_access() at :0: "jh->b_transaction 
== journal->j_committing_transaction"


The following controller log indicates that the failed disk detection 
routine within the controller took too long to determine the disk was 
failed:

AFA0> diagnostic show history /old=TRUE
Executing: diagnostic show history /old=TRUE


 *** HISTORY BUFFER FROM LAST RUN ***

[00]: ID(0:04:0) Cmd[0x28] Fail: Block Range 15179520 : 15179647
[01]: at 5082220 sec
[02]: ID(0:04:0) Cmd[0x28] Fail: Block Range 23749824 : 23749839
[03]: at 5082220 sec
[04]: ID(0:04:0) Cmd[0x28] Fail: Block Range 41313205 : 41313206
[05]: at 5082220 sec
[06]: ID(0:04:0) Cmd[0x2a] Fail: Block Range 5270011 : 5270012 at
[07]:  5082220 sec
[08]: ID(0:04:0) Cmd[0x28] Fail: Block Range 43269255 : 43269256
[09]: at 5082220 sec
[10]: ID(0:04:0) Cmd[0x28] Fail: Block Range 41310245 : 41310246
[11]: at 5082220 sec
[12]: ID(0:04:0) Cmd[0x28] Fail: Block Range 3144832 : 3144959 at
[13]:  5082220 sec
[14]: ID(0:04:0) Cmd[0x28] Fail: Block Range 48800545 : 48800546
[15]: at 5082220 sec
[16]: ID(0:04:0) Cmd[0x28] Fail: Block Range 24652631 : 24652632
[17]: at 5082220 sec
[18]: ID(0:04:0) Cmd[0x28] Fail: Block Range 8102825 : 8102826 at
[19]:  5082220 sec
[20]: ID(0:04:0) Cmd[0x28] Fail: Block Range 59097920 : 59097951
[21]: at 5082220 sec
[22]: ID(0:04:0) Cmd[0x28] Fail: Block Range 5461313 : 5461318 at
[23]:  5082220 sec
[24]: ID(0:04:0) Cmd[0x28] Fail: Block Range 64466133 : 64466134
[25]: at 5082220 sec
[26]: ID(0:04:0) Cmd[0x2a] Fail: Block Range 3147136 : 3147263 at
[27]:  5082220 sec
[28]: ID(0:04:0) Cmd[0x28] Fail: Block Range 590215 : 590222 at 5
[29]: 082220 sec
[30]: ID(0:04:0) Cmd[0x2a] Fail: Block Range 12283087 : 12283088
[31]: at 5082220 sec
[32]: ID(0:04:0) Cmd[0x2a] Fail: Block Range 3147264 : 3147391 at
[33]:  5082220 sec
[34]: ID(0:04:0) Cmd[0x28] Fail: Block Range 19046144 : 19046271
[35]: at 5082220 sec
[36]: ID(0:04:0) Cmd[0x28] Fail: Block Range 54603697 : 54603698
[37]: at 5082220 sec
[38]: ID(0:04:0) Cmd[0x28] Fail: Block Range 215263 : 215270 at 5
[39]: 082220 sec
[40]: ID(0:04:0) Cmd[0x28] Fail: Block Range 70646759 : 70646764
[41]: at 5082220 sec
[42]: ID(0:04:0) Cmd[0x28] Fail: Block Range 64215 : 64222 at 508
[43]: 2220 sec
[44]: ID(0:04:0) Cmd[0x28] Fail: Block Range 46804736 : 46804751
[45]: at 5082220 sec
[46]: ID(0:04:0) Cmd[0x28] Fail: Block Range 70664653 : 70664654
[47]: at 5082220 sec
[48]: ID(0:04:0) Cmd[0x28] Fail: Block Range 46055040 : 46055167
[49]: at 5082220 sec
[50]: ID(0:04:0) Cmd[0x28] Fail: Block Range 39911821 : 39911830
[51]: at 5082220 sec
[52]: ID(0:04:0) Cmd[0x2a] Fail: Block Range 3146880 : 3147007 at
[53]:  5082220 sec
[54]: ID(0:04:0) Cmd[0x28] Fail: Block Range 5159344 : 5159359 at
[55]:  5082220 sec
[56]: ID(0:04:0) Cmd[0x28] Fail: Block Range 41295373 : 41295374
[57]: at 5082220 sec
[58]: ID(0:04:0) Cmd[0x28] Fail: Block Range 15544320 : 15544447
[59]: at 5082220 sec
[60]: ID(0:04:0) Cmd[0x28] Fail: Block Range 5166793 : 5166794 at
[61]:  5082220 sec
[62]: RAID5 Container 0 Drive 0:4:0 Failure
[63]: ID(0:04:0): Timeout detected on cmd[0x28]
[64]: SCSI Channel[0]: Timeout Detected On 1 Command(s)
[65]: ID(0:04:0) Timeout detected on cmd[0x28]
[66]: SCSI Channel[0]: Timeout Detected On 1 Command(s)
[67]: ID(0:04:0): Timeout detected on cmd[0x28]
[68]: SCSI Channel[0]: Timeout Detected On 1 Command(s)
[69]: ID(0:04:0): Timeout detected on cmd[0x28]
[70]: SCSI Channel[0]: Timeout Detected On 1 Command(s)
[71]: ID(0:04:0): Timeout detected on cmd[0x28]
[72]: SCSI Channel[0]: Timeout Detected On 1 Command(s)
[73]: ID(0:04:0): Timeout detected on cmd[0x28]
[74]: SCSI Channel[0]: Timeout Detected On 1 Command(s)
[75]: ID(0:04:0): Timeout detected on cmd[0x28]
[76]: SCSI Channel[0]: Timeout Detected On 1 Command(s)
[77]: ID(0:04:0) Timeout detected on cmd[0x28]
[78]: SCSI Channel[0]: Timeout Detected On 1 Command(s)
[79]: ID(0:04:0) Cmd[0x28] Fail: Block Range 0 : 0 at 5082308 sec
[80]: 2 can't read mbr dev_t:4
[81]:  <...repeats 1 more times>
[82]: can't read config from slice #[4]
[83]: 2 can't read mbr dev_t:4
[84]: can't read config from slice #[4]
[85]: CT_LogMissingEntry: Log missing entry, container 0, dev 4,
[86]: signature 0x8f950a4d, nvEntry 65
[87]: CtMarkDead: container 0, deadEntry 4, dev 4, signature 0x8f
[88]: 950a4d
[89]: CtMarkDead: container 0, deadEntry 4, dev 4, signature 0x8f
[90]: 950a4d
[91]: CtMarkDead: container 0, deadEntry 4, dev 4, signature 0x8f
[92]: 950a4d
[93]: CtMarkDead: container 0, deadEntry 4, dev 4, signature 0x8f
[94]: 950a4d
[95]: CtMarkDead: container 0, deadEntry 4, dev 4, signature 0x8f
[96]: 950a4d
[97]: RAID5 Failover Container 0 No Failover Assigned
[98]: Drive 0:4:0 returning error
[99]:
[/CODE]

88 seconds to determine the drive failed.  In other words, it took 88 
seconds from the time it stopped processing commands from the OS 
until it was ready to continue processing commands from the OS.  The 
kernel killed the storage at 60 seconds, thus hosing the OS since 
that was the only storage device.  Though the controller came back, 
the OS had already given up and couldn't recover.

Am I correct in assessing that the controller's firmware is 
responsible for this extended delay in detecting the failed disk?

Here's the information on our setup:

PERC3/DI on Dell PowerEdge 2500
5 disk U160 RAID5
AFA0> controller details
Executing: controller details
Controller Information
----------------------
             Device Name: AFA0
         Controller Type: PERC 3/Di
             Access Mode: READ-WRITE
Controller Serial Number: Last Six Digits = 4C20D2
         Number of Buses: 2
         Devices per Bus: 15
          Controller CPU: i960 R series
    Controller CPU Speed: 100 Mhz
       Controller Memory: 128 Mbytes
           Battery State: Ok

Component Revisions
-------------------
                CLI: 2.8-0 (Build #6076)
                API: 2.8-0 (Build #6076)
    Miniport Driver: 1.1-4 (Build #9999)
Controller Software: 2.8-0 (Build #6092)
    Controller BIOS: 2.8-0 (Build #6092)
Controller Firmware: (Build #6092)
 
Sincerely,
Andrew Kinney
President and
Chief Technology Officer
Advantagecom Networks, Inc.
http://www.advantagecom.net



