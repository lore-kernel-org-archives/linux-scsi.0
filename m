From: Tim Small <tim@buttersideup.com>
Subject: Re: [smartmontools-support] Apparent MPT ata pass-through bug SAS1068
 and SAS1068E - WAS SMART causes disks to go offline on an LSI SAS1068 controller
 - Dell	SAS 5/iR
Date: Thu, 29 Oct 2009 09:55:51 +0000
Message-ID: <4AE966A7.8040008@buttersideup.com>
References: <20090914142939.GE14072@boogie.lpds.sztaki.hu>	<4AE72E40.2000903@seoss.co.uk>	<4AE8448C.6070709@seoss.co.uk>	<0D1E8821739E724A86F4D16902CE275C1C93A02A34@inbmail01.lsi.com>	<4AE877D3.4040300@seoss.co.uk> <4AE959F3.8070104@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecurenet.com ([63.246.152.102]:48431 "EHLO
	relay1.allsecurenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbZJ2J4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 05:56:07 -0400
In-Reply-To: <4AE959F3.8070104@buttersideup.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, "smartmontools-support@lists.sourceforge.net" <smartmontools-support@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Linux-PowerEdge@dell.com" <Linux-PowerEdge@dell.com>

Tim Small wrote:
> ... I will impose a bit of extra IO load on the machine to see if that
> provokes more errors.
>   


The answer would seem to be yes - whilst simultaneously running these
two commands:

while true ; do dd if=/dev/zero of=empty count=1M ; sync ; rm empty ;
sync ; done

and:

while true ; do smartctl -a /dev/sg1 > /dev/null || echo failed && echo
-n . ; done

... about 10% of the smartctl commands fail, and this sort of thing gets
logged:

[61729.829710] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61729.833705] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61730.019141] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61741.334274] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[61741.353972] mptscsih: ioc0: attempting task abort! (sc=ffff880037b6c880)
[61741.367368] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61741.379314] mptscsih: ioc0: task abort: FAILED (sc=ffff880037b6c880)
[61741.392017] mptscsih: ioc0: attempting target reset!
(sc=ffff880037b6c880)
[61741.405757] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61741.417702] mptscsih: ioc0: target reset: FAILED (sc=ffff880037b6c880)
[61741.430752] mptscsih: ioc0: attempting bus reset! (sc=ffff880037b6c880)
[61741.443970] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61745.830347] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff880037b6c880)
[61757.329906] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[61757.348194] mptscsih: ioc0: attempting host reset! (sc=ffff880037b6c880)
[61757.361592] mptbase: ioc0: Initiating recovery
[61779.120762] mptscsih: ioc0: host reset: SUCCESS (sc=ffff880037b6c880)

[61795.240058] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61795.244054] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61806.744084] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[61806.763772] mptscsih: ioc0: attempting task abort! (sc=ffff880037b6c380)
[61806.777179] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61806.789127] mptscsih: ioc0: task abort: FAILED (sc=ffff880037b6c380)
[61806.801833] mptscsih: ioc0: attempting target reset!
(sc=ffff880037b6c380)
[61806.815575] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61806.827520] mptscsih: ioc0: target reset: FAILED (sc=ffff880037b6c380)
[61806.840575] mptscsih: ioc0: attempting bus reset! (sc=ffff880037b6c380)
[61806.853797] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61811.240162] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff880037b6c380)
[61822.739995] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[61822.758297] mptscsih: ioc0: attempting host reset! (sc=ffff880037b6c380)
[61822.771694] mptbase: ioc0: Initiating recovery
[61844.528012] mptscsih: ioc0: host reset: SUCCESS (sc=ffff880037b6c380)

[61865.400161] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61865.404157] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61865.404157] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61865.404157] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[61876.904450] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[61876.924174] mptscsih: ioc0: attempting task abort! (sc=ffff8800c0218d80)
[61876.937577] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61876.949527] mptscsih: ioc0: task abort: FAILED (sc=ffff8800c0218d80)
[61876.962233] mptscsih: ioc0: attempting target reset!
(sc=ffff8800c0218d80)
[61876.975974] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61876.987918] mptscsih: ioc0: target reset: FAILED (sc=ffff8800c0218d80)
[61877.000971] mptscsih: ioc0: attempting bus reset! (sc=ffff8800c0218d80)
[61877.014193] scsi 2:0:0:0: [sg1] CDB: Inquiry: 12 00 00 00 24 00
[61881.400528] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff8800c0218d80)
[61892.900633] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[61892.918924] mptscsih: ioc0: attempting host reset! (sc=ffff8800c0218d80)
[61892.932322] mptbase: ioc0: Initiating recovery
[61914.688765] mptscsih: ioc0: host reset: SUCCESS (sc=ffff8800c0218d80)
[61924.300535] INFO: task sync:15809 blocked for more than 120 seconds.
[61924.313245] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[61924.328907] sync          D 0000000000000000     0 15809   9780
0x00000000
[61924.342681]  ffffffff814ee8b0 0000000000000082 0000000000000000
000000005fb8f9b9
[61924.357538]  000000005fb8f9b9 0000000000000000 00000000000108a0
ffff8800379bdfd8
[61924.372387]  0000000000015980 0000000000015980 ffff88012e4ab040
ffff88012e4ab338
[61924.387241] Call Trace:
[61924.392145]  [<ffffffffa01afcf5>] ? log_wait_commit+0xcf/0x137 [jbd]
[61924.404848]  [<ffffffff8107cc8a>] ? autoremove_wake_function+0x0/0x59
[61924.417725]  [<ffffffffa01c9c8c>] ? ext3_sync_fs+0x52/0x70 [ext3]
[61924.429906]  [<ffffffff8116ae4d>] ? sync_quota_sb+0x59/0x133
[61924.441222]  [<ffffffff81141bbc>] ? __sync_filesystem+0x5f/0xab
[61924.453057]  [<ffffffff81141cb6>] ? sync_filesystems+0xae/0x110
[61924.464893]  [<ffffffff81141d9a>] ? sys_sync+0x2c/0x56
[61924.475169]  [<ffffffff81010e02>] ? system_call_fastpath+0x16/0x1b


... so I'm assuming that the same race occurs with ATA pass-through
commands, but error recovery is better with 2.6.32-rc4 + mptsas 3.04.13


Cheers,

Tim.
