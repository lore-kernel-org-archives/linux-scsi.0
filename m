From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Mon, 8 Aug 2016 20:09:10 -0400 (EDT)
Message-ID: <1771573384.192110.1470701350622.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com> <1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com> <73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com> <1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com> <SN1PR0201MB1870C587B123A8F84A49C1BD811B0@SN1PR0201MB1870.namprd02.prod.outlook.com> <551419047.135340.1470669997660.JavaMail.zimbra@redhat.com> <077d2708-3360-d8d7-fb3c-d3a73a1e03ee@sandisk.com> <1345038259.188657.1470696767844.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:38144 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbcHIAJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 20:09:16 -0400
In-Reply-To: <1345038259.188657.1470696767844.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>



----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Bart Van Assche" <bart.vanassche@sandisk.com>
> Cc: dm-devel@redhat.com, "Mike Snitzer" <snitzer@redhat.com>, linux-scsi@vger.kernel.org, "Johannes Thumshirn"
> <jthumshirn@suse.de>
> Sent: Monday, August 8, 2016 6:52:47 PM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> 
> 
> ----- Original Message -----
> > From: "Bart Van Assche" <bart.vanassche@sandisk.com>
> > To: "Laurence Oberman" <loberman@redhat.com>
> > Cc: dm-devel@redhat.com, "Mike Snitzer" <snitzer@redhat.com>,
> > linux-scsi@vger.kernel.org, "Johannes Thumshirn"
> > <jthumshirn@suse.de>
> > Sent: Monday, August 8, 2016 6:39:07 PM
> > Subject: Re: [dm-devel] dm-mq and end_clone_request()
> > 
> > On 08/08/2016 08:26 AM, Laurence Oberman wrote:
> > > I will test this as well.
> > > I have lost my DDN array today (sadly:)) but I have two systems
> > > back to back again using ramdisk on the one to serve LUNS.
> > > 
> > > If I pull from  https://github.com/bvanassche/linux again, and
> > > switch branch to srp-initiator-for-next, will I get all Mikes
> > > latest patches from last week + this. I guess I can just check
> > > myself, but might as well just ask.
> > 
> > Hello Laurence,
> > 
> > Sorry but I do not yet have a fix available for the scsi_forget_host()
> > crash you reported in an earlier e-mail. But Mike's latest patches
> > including the patch below are now available at
> > https://github.com/bvanassche/linux in the srp-initiator-for-next
> > branch. Further feedback is welcome.
> > 
> > Thanks,
> > 
> > Bart.
> > 
> > [PATCH] Check invariants at runtime
> > 
> > Warn if sdev->sdev_state != SDEV_DEL when __scsi_remove_device()
> > returns. Check whether all __scsi_remove_device() callers hold the
> > scan_mutex.
> > ---
> >  drivers/scsi/scsi_sysfs.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 82209ad4..a21e321 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1312,6 +1312,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
> >  {
> >  	struct device *dev = &sdev->sdev_gendev, *sdp = NULL;
> >  
> > +	lockdep_assert_held(&sdev->host->scan_mutex);
> > +
> >  	/*
> >  	 * This cleanup path is not reentrant and while it is impossible
> >  	 * to get a new reference with scsi_device_get() someone can still
> > @@ -1321,8 +1323,11 @@ void __scsi_remove_device(struct scsi_device *sdev)
> >  		return;
> >  
> >  	if (sdev->is_visible) {
> > -		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> > +		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0) {
> > +			WARN_ONCE(sdev->sdev_state != SDEV_DEL,
> > +				  "sdev state %d\n", sdev->sdev_state);
> >  			return;
> > +		}
> >  
> >  		bsg_unregister_queue(sdev->request_queue);
> >  		sdp = scsi_get_ulpdev(dev);
> > @@ -1339,6 +1344,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
> >  	 * device.
> >  	 */
> >  	scsi_device_set_state(sdev, SDEV_DEL);
> > +	WARN_ONCE(sdev->sdev_state != SDEV_DEL, "sdev state %d\n",
> > +		  sdev->sdev_state);
> >  	blk_cleanup_queue(sdev->request_queue);
> >  	cancel_work_sync(&sdev->requeue_work);
> >  
> > --
> > 2.9.2
> > 
> Hello Bart
> 
> No problem Sir. I did apply the patch just to help you test and so far it
> been stable.
> I will revert it and carry on my debugging of the dm issue.
> I do have the other patches in the original pull request I took so I am
> running with all Mike's patches.
> 
> Many Thanks as always for all the help you provide all of us.
> 
> Thanks
> Laurence
> 
> 
Hello Bart

So now back to a 10 LUN dual path (ramdisk backed) two-server configuration I am unable to reproduce the dm issue.
Recovery is very fast with the servers connected back to back.
This is using your kernel and this multipath.conf

        device {
                vendor "LIO-ORG"
                product "*"
                path_grouping_policy "multibus"
                path_selector "round-robin 0"
                path_checker "tur"
                features "0"
                hardware_handler "0"
                no_path_retry "queue"
        }

Mikes patches have definitely stabilized this issue for me on this configuration.

I will see if I can move to a larger target server that has more memory and allocate more mpath devices.
I feel this issue in large configurations is now rooted in multipath not bringing back maps sometimes even when the actual paths are back via srp_daemon.
I am still tracking that down.

If you recall, last week I caused some of our own issues by forgetting I had a no_path_retry 12 hiding in my multipath.conf.
Since removing that and spending most of the weekend testing on the DDN array (had to give that back today), 
most of my issues were either the sporadic host delete race or multipath not re-instantiating paths.

I dont know if this helps, but since applying your latest patch I have not seen the host delete race.

Thanks
Laurence
