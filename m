From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: bug 2400
Date: Tue, 6 Apr 2004 17:09:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFB970B8CE.7E8A2208-ONC1256E6E.004FE4A4-C1256E6E.00536930@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:35031 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S263865AbUDFPOA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 11:14:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

>> When a USB unplug comes along, it calls scsi_remove_device, which
>> eventually calls device_del().  The problem is that device_del triggers
>> the ->remove methods of all the attached drivers and the sr_remove
>> method calls cdrom_unregister which throws away the cdrom device state,
>> even though the actual device has active references.
>Yes, we reordered some of this in sd. As your comment down below
>indicates reordering will reduce the window but not eliminate it.
>>[...]
>> This problem, by the way, exists in a lesser form for sd: the sd remove
>> method will free the device for reattachment even though it might have
>> active references.
>I have looked at the sd issue off and on due to the previous open race
>reported by Alan Stern. While the window can be narrowed inside SCSI you
>need help for the calling subsystem to know when it is OK to cleanup and
>your routine will not be called anymore. A similar problem also showed
>up in the tear down the host directory entry in /proc/scsi but was only
>fixed up so far due to its depreciated status.

I think we hit a problem which is related to this on s390 using the zfcp
lldd. What happened is that the lldd called scsi_add_device for a new lun
just before scsi_remove_host is called. The result is the Oops below.
If there is a delay of about a second between scsi_add_device and
scsi_remove_host this Oops doesn't happen anymore.

Is this related to what you described or could it be something different?
I haven't looked deeply into this yet...

Unable to handle kernel pointer dereference at virtual kernel address 
0000000000000000
Oops: 0004 [#1]
CPU:    0    Not tainted
Process fcp_crash.sh (pid: 687, task: 0000000005ec0100, ksp: 
000000000519b7b0)
Krnl PSW : 0700100180000000 00000000000ad574 
(sysfs_hash_and_remove+0x38/0xec)
Krnl GPRS: 0000000000200200 0000000000000000 00000000000000b0 
0000000000000001
           00000000ffffffff 0000000000000000 0000000000000000 
0000000000000002
           000000000519b808 00000000003609a0 00000000060beaf0 
0000000000000000
           00000000002adfbc 0000000000295538 000000000519b428 
000000000519b388
Krnl Code: ba 54 20 00 a7 44 ff fc 12 44 a7 44 00 4f b9 04 00 3c b9 04 
Call Trace:
 [<00000000000ae758>] sysfs_remove_link+0x20/0x30
 [<00000000001240cc>] class_device_dev_unlink+0x40/0x44
 [<00000000001246c4>] class_device_del+0xf4/0x150
 [<000000000012473e>] class_device_unregister+0x1e/0x38
 [<000000000013f9c8>] scsi_remove_device+0x50/0xd0
 [<000000000013eb82>] scsi_forget_host+0x86/0xec
 [<00000000001368fa>] scsi_remove_host+0x36/0x80
 [<00000000001b24e4>] zfcp_adapter_scsi_unregister+0x30/0x70
 [<00000000001b0ea2>] zfcp_ccw_set_offline+0x66/0xbc
 [<000000000016602c>] ccw_device_set_offline+0x60/0x188
 [<0000000000166658>] online_store+0x264/0x380
 [<0000000000121982>] dev_attr_store+0x46/0x50
 [<00000000000ad94c>] flush_write_buffer+0x44/0x58
 [<00000000000ad9bc>] sysfs_write_file+0x5c/0x7c
 [<000000000006e180>] vfs_write+0xe8/0x13c
 [<000000000006e290>] sys_write+0x48/0x74
 [<0000000000020b4a>] sysc_do_restart+0x16/0x1c

Thanks,
Heiko

