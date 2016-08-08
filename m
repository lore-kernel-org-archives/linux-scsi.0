From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Mon, 8 Aug 2016 10:32:22 -0400 (EDT)
Message-ID: <1258167324.126153.1470666742190.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com> <1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com> <1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com> <73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com> <1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com> <ae1a211d-9351-e5fa-e3cb-0a9ba5be9dcd@acm.org> <1978328717.106590.1470660359078.JavaMail.zimbra@redhat.com> <20160808134440.67am2eafnd4yrkxl@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:51492 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcHHOc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 10:32:26 -0400
In-Reply-To: <20160808134440.67am2eafnd4yrkxl@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Johannes Thumshirn" <jthumshirn@suse.de>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "Bart Van Assche" <bvanassche@acm.org>, "Mike Snitzer" <snitzer@redhat.com>, dm-devel@redhat.com,
> linux-scsi@vger.kernel.org
> Sent: Monday, August 8, 2016 9:44:40 AM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> On Mon, Aug 08, 2016 at 08:45:59AM -0400, Laurence Oberman wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Bart Van Assche" <bvanassche@acm.org>
> > > To: "Laurence Oberman" <loberman@redhat.com>
> > > Cc: "Mike Snitzer" <snitzer@redhat.com>, dm-devel@redhat.com,
> > > linux-scsi@vger.kernel.org
> > > Sent: Sunday, August 7, 2016 6:31:11 PM
> > > Subject: Re: [dm-devel] dm-mq and end_clone_request()
> > > 
> > > On 08/06/16 07:47, Laurence Oberman wrote:
> > > > [66813.933246] Workqueue: srp_remove srp_remove_work [ib_srp]
> > > > [ ... ]
> > > > [66815.152051]  [<ffffffff814ac790>] scsi_forget_host+0x60/0x70
> > > > [66815.183939]  [<ffffffff814a0137>] scsi_remove_host+0x77/0x110
> > > > [66815.216152]  [<ffffffffa0677be0>] srp_remove_work+0x90/0x200
> > > > [ib_srp]
> > > > [66815.253221]  [<ffffffff810a2e72>] process_one_work+0x152/0x400
> > > > [66815.286221]  [<ffffffff810a3765>] worker_thread+0x125/0x4b0
> > > > [66815.317313]  [<ffffffff810a3640>] ? rescuer_thread+0x380/0x380
> > > > [66815.349770]  [<ffffffff810a9298>] kthread+0xd8/0xf0
> > > > [66815.376082]  [<ffffffff816c6b3f>] ret_from_fork+0x1f/0x40
> > > > [66815.404767]  [<ffffffff810a91c0>] ? kthread_park+0x60/0x60
> > > 
> > > Hello Laurence,
> > > 
> > > This is a callstack I have not yet encountered myself during any test.
> > > Please provide the output of the following commands:
> > > $ gdb /lib/modules/$(uname -r)/build/vmlinux
> > > (gdb) list *(scsi_forget_host+0x60)
> > > 
> > > Thanks,
> > > 
> > > Bart.
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > [loberman@jumptest1 linux]$ gdb vmlinux
> > GNU gdb (GDB) Red Hat Enterprise Linux 7.6.1-80.el7
> > Copyright (C) 2013 Free Software Foundation, Inc.
> > License GPLv3+: GNU GPL version 3 or later
> > <http://gnu.org/licenses/gpl.html>
> > This is free software: you are free to change and redistribute it.
> > There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> > and "show warranty" for details.
> > This GDB was configured as "x86_64-redhat-linux-gnu".
> > For bug reporting instructions, please see:
> > <http://www.gnu.org/software/gdb/bugs/>...
> > Reading symbols from /home/loberman/bart/linux/vmlinux...done.
> > (gdb) list *(scsi_forget_host+0x60)
> > 0xffffffff814ac790 is in scsi_forget_host (drivers/scsi/scsi_scan.c:1895).
> > 1890		list_for_each_entry(sdev, &shost->__devices, siblings) {
> > 1891			if (sdev->sdev_state == SDEV_DEL)
> > 1892				continue;
> > 1893			spin_unlock_irqrestore(shost->host_lock, flags);
> > 1894			__scsi_remove_device(sdev);
> > 1895			goto restart;
> > 1896		}
> > 1897		spin_unlock_irqrestore(shost->host_lock, flags);
> > 1898	}
> > 1899
> 
> 
> So __scsi_remove_device() is also checking for sdev->sdev_state == SDEV_DEL
> and returns if so. If it would have the chance to do so the goto restart
> would
> be hit and we'd reatart the list traverse. The if in turn just continues and
> I've seen endless loops with this pattern (check the 40998193560 ->
> 90a88d6ef88edc -> f05795d3d771f30a7bd commit chain).
> 
> Might want to give the below patch a shot?
> 
> 
> From fee838ebfea88b581994b3f855eab8da20b07fc9 Mon Sep 17 00:00:00 2001
> From: Johannes Thumshirn <jthumshirn@suse.de>
> Date: Mon, 8 Aug 2016 15:41:09 +0200
> Subject: [PATCH] scsi: restart full list search when re-encountering a
> deleted device
> 
> __scsi_remove_device() already checks for reentrency with a deleted device,
> so there's no need to do it in scsi_forget_host() as well.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_scan.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e0a78f5..1c5a4d6 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1890,8 +1890,6 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> -			continue;
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		__scsi_remove_device(sdev);
>  		goto restart;
> --
> 2.9.2
> 
> 
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: Felix Imendörffer, Jane Smithard, Graham Norton
> HRB 21284 (AG Nürnberg)
> Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Johannes,
Thanks very much.
Regards
Laurence
