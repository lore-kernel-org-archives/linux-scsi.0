From: Steven Dake <sdake@mvista.com>
Subject: Re: Fibre-Channel Access : interuptive access
Date: Mon, 25 Nov 2002 12:37:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DE27BE3.2090402@mvista.com>
References: <3DE261E5.3F61EBC4@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

Fabien,

What you want is hotswap support.  The kernel has basic support for 
hotswap but only if a device is not in use.  Search the archives for 
hotswap.

I'm currently working on forced block device removal, even if the device 
is in use, properly shutting down files in VFS, RAID, and filesystem 
mount layers.  This is what you really need when hotswap happens, but it 
just isn't ready yet.

The correct way to configure your system so it will be alive during this 
type of failure is to have two HBAs, two switches, and have each hba go 
through a seperate switch.  This way, if your link/HBA/switch fails, 
there is automatic failover.

Then create a RAID 1 array across both HBAs.  In the case of a switch 
failure, the RAID subsystem will automatically correct any errors and 
rebuild arrays on disk reinsertions.  Or you could use the RAID 
multipathing personality to create a multipath across two hbas to the 
same device.

Hope this helps.
-steve

Fabien Salvi wrote:

>Hello,
>
>We have Fibre-Channel HBA (Qlogic 2200F) with a Sanbox2 switch connected
>to a storage enclosure with a CMD 7240 Raid FC - SCSI controller.
>
>We use qla2x00 (v6.01) driver.
>
>When I reboot the FC switch, access is interrupted for 1 minute.
>If I still have partition mounted on external enclosure while rebooting,
>it brings failure on the server with a "semi-crash" of linux :
>
>I can still access on it, but fsync is impossible, access to the data
>after the reboot is not possible and reboot is blocked...
>So, I must do a hard reset.
>
>Well, this is something not really anormal you will say me, but what can
>I do to reduce damages ?
>Is there a way to prevent access to the partition while rebooting ?
>When there is a timeout in NFS mounts, it is still possible to reboot
>normally and to get back data when NFS is ok. Is there a solution like
>this with FibreChannel SCSI ?
>
>Here are the logs (I use Reiserfs filesystem) :
>
>Nov 25 16:26:27 d4 kernel: scsi(0): LOOP DOWN detected
>Nov 25 16:27:07 d4 kernel: SCSI disk error : host 0 channel 0 id 0 lun 7
>return code = 10000
>Nov 25 16:27:07 d4 kernel:  I/O error: dev 08:01, sector 50056
>Nov 25 16:27:07 d4 kernel: journal-601, buffer write failed
>Nov 25 16:27:07 d4 kernel: kernel BUG at prints.c:334!
>Nov 25 16:27:07 d4 kernel: invalid operand: 0000
>Nov 25 16:27:07 d4 kernel: CPU:    0
>Nov 25 16:27:07 d4 kernel: EIP:    0010:[reiserfs_panic+41/96]    Not
>tainted
>Nov 25 16:27:07 d4 kernel: EFLAGS: 00010286
>Nov 25 16:27:07 d4 kernel: eax: 00000024   ebx: c02764c0   ecx:
>c7fb0000   edx: 00000000
>Nov 25 16:27:07 d4 kernel: esi: c3470400   edi: 00000000   ebp:
>c3470400   esp: c7fb1ee4
>Nov 25 16:27:07 d4 kernel: ds: 0018   es: 0018   ss: 0018
>Nov 25 16:27:07 d4 kernel: Process kupdated (pid: 7, stackpage=c7fb1000)
>Nov 25 16:27:07 d4 kernel: Stack: c027495a c031f0c0 c02764c0 c7fb1f08
>c888c798 00000003 c01a83cf
> c3470400 
>Nov 25 16:27:07 d4 kernel:        c02764c0 00000011 00000012 00000010
>00000000 c888c7cc c888c7c0
> 00000004 
>Nov 25 16:27:07 d4 kernel:        00000000 00000012 c7a032c0 c01abcfe
>c3470400 c888c798 00000001
> c7fb1fa4 
>Nov 25 16:27:07 d4 kernel: Call Trace:    [flush_commit_list+687/928]
>[do_journal_end+1982/2704]
> [flush_old_commits+287/320] [reiserfs_write_super+21/32]
>[sync_supers+191/240]
>Nov 25 16:27:07 d4 kernel:   [sync_old_buffers+12/64] [kupdate+213/256]
>[kernel_thread+40/64]
>Nov 25 16:27:07 d4 kernel: 
>Nov 25 16:27:07 d4 kernel: Code: 0f 0b 4e 01 60 49 27 c0 68 c0 f0 31 c0
>85 f6 74 16 0f b7 46 
>Nov 25 16:27:08 d4 kernel:  SCSI disk error : host 0 channel 0 id 0 lun
>7 return code = 10000
>Nov 25 16:27:08 d4 kernel:  I/O error: dev 08:01, sector 50064
>Nov 25 16:27:09 d4 kernel: SCSI disk error : host 0 channel 0 id 0 lun 7
>return code = 10000
>Nov 25 16:27:09 d4 kernel:  I/O error: dev 08:01, sector 50072
>Nov 25 16:27:30 d4 kernel: scsi(0): LOOP UP detected
>
>
>Thanks a lot for your help !
>
>--
>Fabien
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

