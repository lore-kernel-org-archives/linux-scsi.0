From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Tue, 9 Aug 2016 13:21:15 -0400 (EDT)
Message-ID: <967089395.387512.1470763275007.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com> <551419047.135340.1470669997660.JavaMail.zimbra@redhat.com> <077d2708-3360-d8d7-fb3c-d3a73a1e03ee@sandisk.com> <1345038259.188657.1470696767844.JavaMail.zimbra@redhat.com> <1771573384.192110.1470701350622.JavaMail.zimbra@redhat.com> <2aaad6b7-bfa4-b965-53bf-4420fe01d3e5@sandisk.com> <1494059467.386778.1470762767417.JavaMail.zimbra@redhat.com> <ad12fd05-f931-30a5-2efd-3d8a171a73cb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:42166 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbcHIRVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 13:21:19 -0400
In-Reply-To: <ad12fd05-f931-30a5-2efd-3d8a171a73cb@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche@sandisk.com>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, "Mike Snitzer" <snitzer@redhat.com>, "Johannes Thumshirn"
> <jthumshirn@suse.de>
> Sent: Tuesday, August 9, 2016 1:16:52 PM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> On 08/09/2016 10:12 AM, Laurence Oberman wrote:
> > I was talking about this patch
> >
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -1890,10 +1890,11 @@ void scsi_forget_host(struct Scsi_Host *shost)
> >   restart:
> >          spin_lock_irqsave(shost->host_lock, flags);
> >          list_for_each_entry(sdev, &shost->__devices, siblings) {
> > -                if (sdev->sdev_state == SDEV_DEL)
> > +                if (sdev->sdev_state == SDEV_DEL || scsi_device_get(sdev)
> > < 0)
> >                          continue;
> >                  spin_unlock_irqrestore(shost->host_lock, flags);
> >                  __scsi_remove_device(sdev);
> > +                scsi_device_put(sdev);
> >                  goto restart;
> >          }
> >          spin_unlock_irqrestore(shost->host_lock, flags);
> 
> Hello Laurence,
> 
> Did you run your tests with that patch applied? If so, it would help if
> you could rerun your tests without that patch. If the above patch makes
> a difference it means that it can happen that __scsi_remove_device()
> does not change the device state into SDEV_DEL. That's a bug and we need
> to know whether or not __scsi_remove_device() behaves correctly.
> 
> Thanks,
> 
> Bart.
> 
Yes Sir, I ran all yesterdays tests on your kernel with that patch applied.
Of course it may well just be luck/coincidence that the host delete race is no longer happening
so I agree we need to re-run the tests so I will revert and re-run.
I will probably only get back to you tomorrow with the results.

Thanks
Laurence
