From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Mon, 8 Aug 2016 08:45:59 -0400 (EDT)
Message-ID: <1978328717.106590.1470660359078.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com> <4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com> <20160804235850.GB13132@redhat.com> <1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com> <1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com> <73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com> <1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com> <ae1a211d-9351-e5fa-e3cb-0a9ba5be9dcd@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:44473 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbcHHMqZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 08:46:25 -0400
In-Reply-To: <ae1a211d-9351-e5fa-e3cb-0a9ba5be9dcd@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bvanassche@acm.org>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "Mike Snitzer" <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
> Sent: Sunday, August 7, 2016 6:31:11 PM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> On 08/06/16 07:47, Laurence Oberman wrote:
> > [66813.933246] Workqueue: srp_remove srp_remove_work [ib_srp]
> > [ ... ]
> > [66815.152051]  [<ffffffff814ac790>] scsi_forget_host+0x60/0x70
> > [66815.183939]  [<ffffffff814a0137>] scsi_remove_host+0x77/0x110
> > [66815.216152]  [<ffffffffa0677be0>] srp_remove_work+0x90/0x200 [ib_srp]
> > [66815.253221]  [<ffffffff810a2e72>] process_one_work+0x152/0x400
> > [66815.286221]  [<ffffffff810a3765>] worker_thread+0x125/0x4b0
> > [66815.317313]  [<ffffffff810a3640>] ? rescuer_thread+0x380/0x380
> > [66815.349770]  [<ffffffff810a9298>] kthread+0xd8/0xf0
> > [66815.376082]  [<ffffffff816c6b3f>] ret_from_fork+0x1f/0x40
> > [66815.404767]  [<ffffffff810a91c0>] ? kthread_park+0x60/0x60
> 
> Hello Laurence,
> 
> This is a callstack I have not yet encountered myself during any test.
> Please provide the output of the following commands:
> $ gdb /lib/modules/$(uname -r)/build/vmlinux
> (gdb) list *(scsi_forget_host+0x60)
> 
> Thanks,
> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
[loberman@jumptest1 linux]$ gdb vmlinux
GNU gdb (GDB) Red Hat Enterprise Linux 7.6.1-80.el7
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /home/loberman/bart/linux/vmlinux...done.
(gdb) list *(scsi_forget_host+0x60)
0xffffffff814ac790 is in scsi_forget_host (drivers/scsi/scsi_scan.c:1895).
1890		list_for_each_entry(sdev, &shost->__devices, siblings) {
1891			if (sdev->sdev_state == SDEV_DEL)
1892				continue;
1893			spin_unlock_irqrestore(shost->host_lock, flags);
1894			__scsi_remove_device(sdev);
1895			goto restart;
1896		}
1897		spin_unlock_irqrestore(shost->host_lock, flags);
1898	}
1899	
