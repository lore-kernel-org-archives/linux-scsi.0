From: Laurence Oberman <loberman@redhat.com>
Subject: Re: sg driver, sg_io and sg tablesize
Date: Wed, 1 Mar 2017 17:11:31 -0500 (EST)
Message-ID: <50601133.40845997.1488406291147.JavaMail.zimbra@redhat.com>
References: <791707934.40662785.1488383072891.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:58574 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdCBGaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 01:30:20 -0500
In-Reply-To: <791707934.40662785.1488383072891.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Linux SCSI List <linux-scsi@vger.kernel.org>
Cc: Ewan Milne <emilne@redhat.com>



----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: dgilbert@interlog.com, "Linux SCSI List" <linux-scsi@vger.kernel.org>
> Sent: Wednesday, March 1, 2017 10:44:32 AM
> Subject: sg driver, sg_io and sg tablesize
> 
> Hi Doug
> I have a quick question here regarding the sg tablesize and retrieval of the
> supported size via a userspace ioctl.
> 
> lpfc defaults to
> lpfc_sg_seg_cnt:Max Scatter Gather Segment Count (uint) = 64
> 
> For sg_io sent from qemu if we exceed 512K I/O we fail, qlogic allows 128 by
> default.
> 
> 7:0:2:13 /dev/sdbb 67:80   /dev/sg55           Emulex lpfc LUN
> 
> [root@dhcp40-131 ~]# sg_dd if=/dev/zero of=/dev/sdbb bpt=0x400 count=0x400
> blk_sgio=1
> Assume default 'bs' (block size) of 512 bytes
> writing (SG_IO) on sg device, error: Invalid argument
> sg_write failed, seek=0
> Some error occurred,  remaining block count=1024
> 1024+0 records in
> 0+0 records out
> 
> 9:0:1:13 /dev/sdcm 71:240  /dev/sg92         Qlogic qla2xxx LUN
> 
> [root@dhcp40-131 ~]# sg_dd if=/dev/zero of=/dev/sdcm bpt=0x400 count=0x400
> blk_sgio=1
> Assume default 'bs' (block size) of 512 bytes
> 1024+0 records in
> 1024+0 records out
> 
> Using ioctl(sg_fd, BLKSECTGET, &max_sectors) from userspace correctly returns
> the /sys/block/sdcm/queue/max_sectors_kb
> 
> How can we query the sg tablesize using a userspace ioctl for the sg driver.
> 
> Figured I would ask you first.
> 
> Thanks
> Laurence
> 

Answering my own email,
I chatted with Ewan and we decided we would point our Virt/Qemu team to simply go after max_segments in sysfs
This was suggested by Ewan and is the best way to know what the actual max I/O size for sg_io would be for the LPFC driver.

Thanks
Laurence
