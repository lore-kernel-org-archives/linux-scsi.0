From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Thu, 11 Aug 2016 12:51:47 -0400 (EDT)
Message-ID: <532021645.703156.1470934307915.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com> <1345038259.188657.1470696767844.JavaMail.zimbra@redhat.com> <1771573384.192110.1470701350622.JavaMail.zimbra@redhat.com> <2aaad6b7-bfa4-b965-53bf-4420fe01d3e5@sandisk.com> <1494059467.386778.1470762767417.JavaMail.zimbra@redhat.com> <ad12fd05-f931-30a5-2efd-3d8a171a73cb@sandisk.com> <967089395.387512.1470763275007.JavaMail.zimbra@redhat.com> <609737535.572896.1470865096150.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:58573 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbcHKQvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 12:51:52 -0400
In-Reply-To: <609737535.572896.1470865096150.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>



----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Bart Van Assche" <bart.vanassche@sandisk.com>
> Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, "Mike Snitzer" <snitzer@redhat.com>, "Johannes Thumshirn"
> <jthumshirn@suse.de>
> Sent: Wednesday, August 10, 2016 5:38:16 PM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> 
> 
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman@redhat.com>
> > To: "Bart Van Assche" <bart.vanassche@sandisk.com>
> > Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, "Mike Snitzer"
> > <snitzer@redhat.com>, "Johannes Thumshirn"
> > <jthumshirn@suse.de>
> > Sent: Tuesday, August 9, 2016 1:21:15 PM
> > Subject: Re: [dm-devel] dm-mq and end_clone_request()
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Bart Van Assche" <bart.vanassche@sandisk.com>
> > > To: "Laurence Oberman" <loberman@redhat.com>
> > > Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, "Mike Snitzer"
> > > <snitzer@redhat.com>, "Johannes Thumshirn"
> > > <jthumshirn@suse.de>
> > > Sent: Tuesday, August 9, 2016 1:16:52 PM
> > > Subject: Re: [dm-devel] dm-mq and end_clone_request()
> > > 
> > > On 08/09/2016 10:12 AM, Laurence Oberman wrote:
> > > > I was talking about this patch
> > > >
> > > > --- a/drivers/scsi/scsi_scan.c
> > > > +++ b/drivers/scsi/scsi_scan.c
> > > > @@ -1890,10 +1890,11 @@ void scsi_forget_host(struct Scsi_Host *shost)
> > > >   restart:
> > > >          spin_lock_irqsave(shost->host_lock, flags);
> > > >          list_for_each_entry(sdev, &shost->__devices, siblings) {
> > > > -                if (sdev->sdev_state == SDEV_DEL)
> > > > +                if (sdev->sdev_state == SDEV_DEL ||
> > > > scsi_device_get(sdev)
> > > > < 0)
> > > >                          continue;
> > > >                  spin_unlock_irqrestore(shost->host_lock, flags);
> > > >                  __scsi_remove_device(sdev);
> > > > +                scsi_device_put(sdev);
> > > >                  goto restart;
> > > >          }
> > > >          spin_unlock_irqrestore(shost->host_lock, flags);
> > > 
> > > Hello Laurence,
> > > 
> > > Did you run your tests with that patch applied? If so, it would help if
> > > you could rerun your tests without that patch. If the above patch makes
> > > a difference it means that it can happen that __scsi_remove_device()
> > > does not change the device state into SDEV_DEL. That's a bug and we need
> > > to know whether or not __scsi_remove_device() behaves correctly.
> > > 
> > > Thanks,
> > > 
> > > Bart.
> > > 
> > Yes Sir, I ran all yesterdays tests on your kernel with that patch applied.
> > Of course it may well just be luck/coincidence that the host delete race is
> > no longer happening
> > so I agree we need to re-run the tests so I will revert and re-run.
> > I will probably only get back to you tomorrow with the results.
> > 
> > Thanks
> > Laurence
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> Hello Bart
> 
> I only just got time now to revert that patch and build a kernel.
> Will test this tonight and let you know if I am back to seeing panics
> sporadically without the patch.
> As already mentioned, this is a different configuration to what I had when I
> was able to reproduce the panic.
> This means the lack of hitting this stack trace and panic may turn out to
> have nothing to do with the patch I applied.
> 
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hello Bart

I can no longer reproduce the stack even with the patch reverted so its behaving as you expected and the patch is as you already said, not valid.
I ran about 30 fio tests with your kernel and multiple host deletions and and did experience only one hard fio error.
My tests now produce the same results as you are seeing.

The single fio errors was with many more executions of the test so its not easy to get these fio errors.

Away from tomorrow on vacation for 10 days

Thanks
Laurence
