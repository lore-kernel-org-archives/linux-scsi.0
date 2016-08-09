From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Tue, 9 Aug 2016 13:12:47 -0400 (EDT)
Message-ID: <1494059467.386778.1470762767417.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com> <1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com> <SN1PR0201MB1870C587B123A8F84A49C1BD811B0@SN1PR0201MB1870.namprd02.prod.outlook.com> <551419047.135340.1470669997660.JavaMail.zimbra@redhat.com> <077d2708-3360-d8d7-fb3c-d3a73a1e03ee@sandisk.com> <1345038259.188657.1470696767844.JavaMail.zimbra@redhat.com> <1771573384.192110.1470701350622.JavaMail.zimbra@redhat.com> <2aaad6b7-bfa4-b965-53bf-4420fe01d3e5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:34594 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbcHIRMx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 13:12:53 -0400
In-Reply-To: <2aaad6b7-bfa4-b965-53bf-4420fe01d3e5@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche@sandisk.com>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: dm-devel@redhat.com, "Mike Snitzer" <snitzer@redhat.com>, linux-scsi@vger.kernel.org, "Johannes Thumshirn"
> <jthumshirn@suse.de>
> Sent: Tuesday, August 9, 2016 11:51:00 AM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> On 08/08/2016 05:09 PM, Laurence Oberman wrote:
> > So now back to a 10 LUN dual path (ramdisk backed) two-server
> > configuration I am unable to reproduce the dm issue.
> > Recovery is very fast with the servers connected back to back.
> > This is using your kernel and this multipath.conf
> > 
> > [ ... ]
> > 
> > Mikes patches have definitely stabilized this issue for me on this
> > configuration.
> > 
> > I will see if I can move to a larger target server that has more
> > memory and allocate more mpath devices. I feel this issue in large
> > configurations is now rooted in multipath not bringing back maps
> > sometimes even when the actual paths are back via srp_daemon.
> > I am still tracking that down.
> > 
> > If you recall, last week I caused some of our own issues by
> > forgetting I had a no_path_retry 12 hiding in my multipath.conf.
> > Since removing that and spending most of the weekend testing on
> > the DDN array (had to give that back today), most of my issues
> > were either the sporadic host delete race or multipath not
> > re-instantiating paths.
> > 
> > I dont know if this helps, but since applying your latest patch I
> > have not seen the host delete race.
> 
> Hello Laurence,
> 
> My latest SCSI core patch adds additional instrumentation to the SCSI
> core but does not change the behavior of the SCSI core. So it cannot
> fix the scsi_forget_host() crash you had reported.
> 
> On my setup, with the kernel code from the srp-initiator-for-next
> branch and with CONFIG_DM_MQ_DEFAULT=n, I still see that when I run the
> srp-test software that fio reports I/O errors every now and then. What
> I see in syslog seems to indicate that these I/O errors are generated
> by dm-mpath:
> 
> Aug  9 08:45:39 ion-dev-ib-ini kernel: mpath 254:1: queue_if_no_path 1 -> 0
> Aug  9 08:45:39 ion-dev-ib-ini kernel: must_push_back: 107 callbacks
> suppressed
> Aug  9 08:45:39 ion-dev-ib-ini kernel: device-mapper: multipath:
> must_push_back: queue_if_no_path=0 suspend_active=1 suspending=0
> Aug  9 08:45:39 ion-dev-ib-ini kernel: __multipath_map(): (a) returning -5
> Aug  9 08:45:39 ion-dev-ib-ini kernel: map_request(): clone_and_map_rq()
> returned -5
> Aug  9 08:45:39 ion-dev-ib-ini kernel: dm_complete_request: error = -5
> Aug  9 08:45:39 ion-dev-ib-ini kernel: dm_softirq_done: dm-1 tio->error = -5
> 
> Bart.
> 
> 
Hello Bart

I was talking about this patch

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1890,10 +1890,11 @@ void scsi_forget_host(struct Scsi_Host *shost)
  restart:
         spin_lock_irqsave(shost->host_lock, flags);
         list_for_each_entry(sdev, &shost->__devices, siblings) {
-                if (sdev->sdev_state == SDEV_DEL)
+                if (sdev->sdev_state == SDEV_DEL || scsi_device_get(sdev) < 0)
                         continue;
                 spin_unlock_irqrestore(shost->host_lock, flags);
                 __scsi_remove_device(sdev);
+                scsi_device_put(sdev);
                 goto restart;
         }
         spin_unlock_irqrestore(shost->host_lock, flags);
-- 

This is the one I applied. that's not just instrumentation right ?

Thanks
Laurence
