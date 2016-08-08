From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Mon, 8 Aug 2016 11:26:37 -0400 (EDT)
Message-ID: <551419047.135340.1470669997660.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com> <4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com> <20160804235850.GB13132@redhat.com> <1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com> <1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com> <73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com> <1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com> <SN1PR0201MB1870C587B123A8F84A49C1BD811B0@SN1PR0201MB1870.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:53197 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbcHHP0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 11:26:43 -0400
In-Reply-To: <SN1PR0201MB1870C587B123A8F84A49C1BD811B0@SN1PR0201MB1870.namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche@sandisk.com>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, "Mike Snitzer" <snitzer@redhat.com>, "Johannes Thumshirn"
> <jthumshirn@suse.de>
> Sent: Monday, August 8, 2016 11:11:56 AM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> On 08/06/16 07:47, Laurence Oberman wrote:
> > [66814.772851]  [<ffffffff8118e72f>] ? panic+0x1eb/0x233
> > [66814.800207]  [<ffffffff810308f8>] oops_end+0xb8/0xd0
> > [66814.827454]  [<ffffffff8106977e>] no_context+0x13e/0x3a0
> > [66814.858368]  [<ffffffff811f3feb>] ? __slab_free+0x9b/0x280
> > [66814.890365]  [<ffffffff81069ace>] __bad_area_nosemaphore+0xee/0x1d0
> > [66814.926508]  [<ffffffff81069bc4>] bad_area_nosemaphore+0x14/0x20
> > [66814.959939]  [<ffffffff8106a269>] __do_page_fault+0x89/0x4a0
> > [66814.992039]  [<ffffffff811f3feb>] ? __slab_free+0x9b/0x280
> > [66815.023052]  [<ffffffff8106a6b0>] do_page_fault+0x30/0x80
> > [66815.053368]  [<ffffffff816c8b88>] page_fault+0x28/0x30
> > [66815.083196]  [<ffffffff814ae4e9>] ? __scsi_remove_device+0x79/0x160
> > [66815.117444]  [<ffffffff814ae5c2>] ? __scsi_remove_device+0x152/0x160
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
> Hello Laurence and Johannes,
> 
> Later today I will start testing the following patch:
> 
> 
> Subject: [PATCH] Fix a use-after-free in scsi_forget_host()
> 
> Avoid that scsi_forget_host() can call __scsi_remove_device()
> while scsi_device_dev_release_usercontext() is freeing the same
> SCSI device.
> ---
>  drivers/scsi/scsi_scan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e0a78f5..6cffc90 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1890,10 +1890,11 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> +		if (sdev->sdev_state == SDEV_DEL || scsi_device_get(sdev) < 0)
>  			continue;
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		__scsi_remove_device(sdev);
> +		scsi_device_put(sdev);
>  		goto restart;
>  	}
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> --
> 2.9.2
> 
> 
> 
Hello Bart, Johannes

I will test this as well.
I have lost my DDN array today (sadly:)) but I have two systems back to back again using ramdisk on the one to serve LUNS.

If I pull from  https://github.com/bvanassche/linux again, and switch branch to srp-initiator-for-next, will I get all Mikes latest patches from last week + this.
I guess I can just check myself, but might as well just ask.

Thanks!!
Laurence
