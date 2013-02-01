From: Tao Ma <tm@tao.ma>
Subject: Re: How to online remove an error scsi disk from the system?
Date: Fri, 01 Feb 2013 17:07:19 +0800
Message-ID: <510B85C7.8030105@tao.ma>
References: <510B5CFC.2040801@tao.ma> <510B749E.8020501@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <510B749E.8020501@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/01/2013 03:54 PM, Bart Van Assche wrote:
> On 02/01/13 07:13, Tao Ma wrote:
>>     In our product system, we have several sata disks attached to one
>> machine. So when one of the disk fails, the jbd2(yes, we use ext4) will
>> hang forever and we will get something in /var/log/messages like below.
>> It seems to me that the io sent to the scsi layer is never returned back
>> with -EIO which is a little bit surprised for me(It should be a timeout
>> somewhere, right?). We have tried echo "offline" >
>> /sys/block/sdl/device/state, but it doesn't work. So is there any way
>> for us to let the scsi device returns all the io requests back with EIO
>> so that all the end_io can be called accordingly? Am I missing something
>> here?
> 
> Please note that I'm not familiar with SAS. But I found this in
> drivers/scsi/scsi_proc.c:
> 
>  * proc_scsi_write - handle writes to /proc/scsi/scsi
>  * @file: not used
>  * @buf: buffer to write
>  * @length: length of buf, at most PAGE_SIZE
>  * @ppos: not used
>  *
>  * Description: this provides a legacy mechanism to add or remove
>  * devices by Host, Channel, ID, and Lun.  To use,
>  * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
>  * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
>  * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.
Sorry, it doesn't work since it will also send some IOs to the scsi. And
it hangs...

bash          D 0000000000000000     0 57479  57477 0x00000000
 ffff8817fee2dba0 0000000000000086 0000000000000000 0000000000000002
 ffffffff817c4ed5 0000000000015f40 ffff88180c7e45f8 ffff88180c7e4040
 ffffffff81a2d020 ffff88180c7e45f8 000000010fa4af09 0000000000000004
Call Trace:
 [<ffffffff8123eecf>] ? string+0x3f/0xd0
 [<ffffffff8123fdc2>] ? vsnprintf+0x242/0x580
 [<ffffffff811a0b14>] ? fsnotify_clear_marks_by_inode+0x34/0xf0
 [<ffffffff811d33c0>] ? sysfs_delete_inode+0x0/0x60
 [<ffffffff814aa5c5>] rwsem_down_failed_common+0x95/0x1c0
 [<ffffffff814aa746>] rwsem_down_read_failed+0x26/0x30
 [<ffffffff81241814>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff812385a0>] ? kobject_release+0x0/0x1f0
 [<ffffffff814a9cd4>] ? down_read+0x24/0x30
 [<ffffffff81167794>] get_super+0x74/0xc0
 [<ffffffff8119aa9e>] fsync_bdev+0x1e/0x60
 [<ffffffff812253ce>] invalidate_partition+0x2e/0x60
 [<ffffffff811d0bfe>] del_gendisk+0x3e/0x130
 [<ffffffff813070da>] ? device_del+0x16a/0x1a0
 [<ffffffff8132f437>] sd_remove+0x67/0xb0
 [<ffffffff8130adcf>] __device_release_driver+0x6f/0xe0
 [<ffffffff8130ae6d>] device_release_driver+0x2d/0x40
 [<ffffffff8130a723>] bus_remove_device+0x83/0xe0
 [<ffffffff8130709f>] device_del+0x12f/0x1a0
 [<ffffffff8132a7f5>] __scsi_remove_device+0xa5/0xb0
 [<ffffffff8132a830>] scsi_remove_device+0x30/0x50
 [<ffffffff8132cc3f>] proc_scsi_write+0x23f/0x280
 [<ffffffff81182869>] ? mntput_no_expire+0x39/0xd0
 [<ffffffff811c482f>] proc_reg_write+0x7f/0xc0
 [<ffffffff81165c6c>] vfs_write+0xcc/0x1a0
 [<ffffffff81165e25>] sys_write+0x55/0x90
 [<ffffffff8100b032>] system_call_fastpath+0x16/0x1b


Thanks,
Tao
> 
> Bart.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
