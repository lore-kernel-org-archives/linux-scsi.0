From: Alex Davis <alex14641@yahoo.com>
Subject: Fwd: [BUG] DVD assigned wrong SCSI level when using SCSI emulation
Date: Sun, 22 Jan 2006 20:36:44 -0800 (PST)
Message-ID: <20060123043644.60688.qmail@web50204.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web50204.mail.yahoo.com ([206.190.38.45]:48015 "HELO
	web50204.mail.yahoo.com") by vger.kernel.org with SMTP
	id S932318AbWAWEgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2006 23:36:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

I had originally posted this to linux-kernel.

--- Alex Davis <alex14641@yahoo.com> wrote:

> From Alex Davis Fri Jan 20 14:38:19 2006
> Received: from [162.84.36.193] by web50210.mail.yahoo.com via HTTP; Fri, 20 Jan 2006 14:38:19
> PST
> Date: Fri, 20 Jan 2006 14:38:19 -0800 (PST)
> From: Alex Davis <alex14641@yahoo.com>
> Subject: [BUG] DVD assigned wrong SCSI level when using SCSI emulation
> To: linux-kernel@vger.kernel.org
> MIME-Version: 1.0
> Content-Type: text/plain; charset=iso-8859-1
> Content-Transfer-Encoding: 8bit
> Content-Length: 1057
> 
> I've noticed that since I upgraded to 2.6.15, my IDE DVD ROM
> is assigned a bogus SCSI level. Here is output from /proc/scsi/scsi:
> 
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: HL-DT-ST Model: DVD-ROM GDR8082N Rev: 0106
>   Type:   CD-ROM                           ANSI SCSI revision: 0xffffffff
> 
> 
> Here's what I get with 2.6.8.1:
> 
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: HL-DT-ST Model: DVD-ROM GDR8082N Rev: 0106
>   Type:   CD-ROM                           ANSI SCSI revision: 02
> 
> 
> 
> I did a little digging, and it seems that in drivers/scsi/sr.c,
> function get_capabilities(), the call to scsi_mode_sense() is failing (it's returning
> 134217730). 
> 
> On a side note, I can't watch DVDs on 2.6.15.
> 
> I have ide-scsi and sr-mod loaded as modules.
> gcc version is 3.3.6
> 
> Here is the config for 2.6.8.1 : http://linux.ace-technologies.biz/config-2.6.8.1
> 
> Here is the config for 2.6.15: http://linux.ace-technologies.biz/config-2.6.15
> 
> lspci -v: http://linux.ace-technologies.biz/lspci-2.6.15
>
> lsmod: http://linux.ace-technologies.biz/lsmod-2.6.15
>
> I've tried booting with hdc=scsi; makes no difference.
> 
> Here's an excerpt from /var/log/messages:
> 
> Jan 19 20:46:29 boss kernel: [    1.662575] hdc: HL-DT-STDVD-ROM GDR8082N, ATAPI CD/DVD-ROM
> drive
> Jan 19 20:46:29 boss kernel: [    1.969598] ide1 at 0x170-0x177,0x376 on irq 15
> Jan 19 20:46:29 boss kernel: [    2.039442] IP route cache hash table entries: 65536 (order: 6,
> 262144 bytes)
> Jan 19 20:46:29 boss kernel: [    2.039716] TCP established hash table entries: 262144 (order:
> 9,
> 2097152 bytes)
> Jan 19 20:46:29 boss kernel: [    2.040901] TCP bind hash table entries: 65536 (order: 7, 524288
> bytes)
> Jan 19 20:46:29 boss kernel: [    2.042093] Using IPI Shortcut mode
> Jan 19 20:46:29 boss kernel: [    2.052961] VFS: Mounted root (ext2 filesystem) readonly.
> Jan 19 20:46:29 boss kernel: [    4.801179] ide-scsi is deprecated for cd burning! Use ide-cd
> and
> give dev=/dev/hdX as device
> Jan 19 20:46:29 boss kernel: [    4.954103] sr0: scsi-1 drive
> 
> 
> 
> 
> I can test patches if needed. 
> 
> Additional info will be provided upon request.
> 
> -Alex
> 
> 
> I code, therefore I am
> 
> __________________________________________________
> Do You Yahoo!?
> Tired of spam?  Yahoo! Mail has the best spam protection around 
> http://mail.yahoo.com 
> 


I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
