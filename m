From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 2/3] scsi: disable VPD page check on error
Date: Mon, 20 Jun 2016 11:03:24 -0400
Message-ID: <1466435004.4039.25.camel@localhost.localdomain>
References: <1466405868-87720-1-git-send-email-hare@suse.de>
	 <1466405868-87720-3-git-send-email-hare@suse.de>
	 <1466429138.4039.15.camel@localhost.localdomain>
	 <1466430242.2350.4.camel@HansenPartnership.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858AbcFTPNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 11:13:37 -0400
In-Reply-To: <1466430242.2350.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Mon, 2016-06-20 at 06:44 -0700, James Bottomley wrote:
> On Mon, 2016-06-20 at 09:25 -0400, Ewan D. Milne wrote:
> > On Mon, 2016-06-20 at 08:57 +0200, Hannes Reinecke wrote:
> > > If we encounter an error during initial VPD page scan we should be
> > > setting the 'skip_vpd_pages' bit to avoid further accesses.
> > > Any errors during rescan should be ignored, as we might encounter
> > > temporary I/O errors during rescan.
> > > 
> > > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > > ---
> > >  drivers/scsi/scsi.c      | 9 ++++++++-
> > >  drivers/scsi/scsi_priv.h | 2 +-
> > >  drivers/scsi/scsi_scan.c | 4 ++--
> > >  3 files changed, 11 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > > index 1deb6ad..1ff4a0b 100644
> > > --- a/drivers/scsi/scsi.c
> > > +++ b/drivers/scsi/scsi.c
> > > @@ -770,13 +770,14 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
> > >  /**
> > >   * scsi_attach_vpd - Attach Vital Product Data to a SCSI device
> > > structure
> > >   * @sdev: The device to ask
> > > + * @first_scan: true if called during initial scan
> > >   *
> > >   * Attach the 'Device Identification' VPD page (0x83) and the
> > >   * 'Unit Serial Number' VPD page (0x80) to a SCSI device
> > >   * structure. This information can be used to identify the device
> > >   * uniquely.
> > >   */
> > > -void scsi_attach_vpd(struct scsi_device *sdev)
> > > +void scsi_attach_vpd(struct scsi_device *sdev, bool first_scan)
> > >  {
> > >  	int result, i;
> > >  	int vpd_len = SCSI_VPD_PG_LEN;
> > > @@ -796,6 +797,8 @@ retry_pg0:
> > >  	result = scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
> > >  	if (result < 0) {
> > >  		kfree(vpd_buf);
> > > +		if (first_scan)
> > > +			sdev->skip_vpd_pages = 1;
> > >  		return;
> > >  	}
> > >  	if (result > vpd_len) {
> > > @@ -822,6 +825,8 @@ retry_pg80:
> > >  		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80,
> > > vpd_len);
> > >  		if (result < 0) {
> > >  			kfree(vpd_buf);
> > > +			if (first_scan)
> > > +				sdev->skip_vpd_pages = 1;
> > >  			return;
> > >  		}
> > >  		if (result > vpd_len) {
> > > @@ -851,6 +856,8 @@ retry_pg83:
> > >  		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x83,
> > > vpd_len);
> > >  		if (result < 0) {
> > >  			kfree(vpd_buf);
> > > +			if (first_scan)
> > > +				sdev->skip_vpd_pages = 1;
> > >  			return;
> > >  		}
> > >  		if (result > vpd_len) {
> > > diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> > > index 6c3db56..0c4cc6d 100644
> > > --- a/drivers/scsi/scsi_priv.h
> > > +++ b/drivers/scsi/scsi_priv.h
> > > @@ -31,7 +31,7 @@ extern void scsi_exit_hosts(void);
> > >  /* scsi.c */
> > >  extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
> > >  extern void scsi_destroy_command_freelist(struct Scsi_Host
> > > *shost);
> > > -void scsi_attach_vpd(struct scsi_device *sdev);
> > > +void scsi_attach_vpd(struct scsi_device *sdev, bool first_scan);
> > >  #ifdef CONFIG_SCSI_LOGGING
> > >  void scsi_log_send(struct scsi_cmnd *cmd);
> > >  void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
> > > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > > index e0a78f5..dcc08ad 100644
> > > --- a/drivers/scsi/scsi_scan.c
> > > +++ b/drivers/scsi/scsi_scan.c
> > > @@ -997,7 +997,7 @@ static int scsi_add_lun(struct scsi_device
> > > *sdev, unsigned char *inq_result,
> > >  	}
> > >  
> > >  	if (sdev->scsi_level >= SCSI_3)
> > > -		scsi_attach_vpd(sdev);
> > > +		scsi_attach_vpd(sdev, true);
> > >  
> > >  	sdev->max_queue_depth = sdev->queue_depth;
> > >  
> > > @@ -1536,7 +1536,7 @@ void scsi_rescan_device(struct device *dev)
> > >  
> > >  	device_lock(dev);
> > >  
> > > -	scsi_attach_vpd(sdev);
> > > +	scsi_attach_vpd(sdev, false);
> > >  
> > >  	if (sdev->handler && sdev->handler->rescan)
> > >  		sdev->handler->rescan(sdev);
> > 
> > Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> 
> I take it your concerns about never asking the device for VPD pages
> again are addressed?
> 
> I also don't really like this.  If the device has a failure like the
> QEMU one where it just hangs up, this won't help because the problem
> already happened.  Conversely, if the device replies in the negative,
> it should always do so, so I can't see what this buys us, except the
> possibility of doing the wrong thing on a transient error (which can
> happen on your ALUA devices during path switch, I believe?)
> 
> I'd be much happier if you can point to a problem that this would
> solve.
> 
> James

My concern with the earlier patch was that any time a rescan was
performed, and the VPD inquiry failed, we might have VPD data that
had been obtained on the initial scan, but might now be stale.
And then the failed inquiry would result in it never being updated
again, ever.  (This could happen if a path was down, for example.)

With this approach, if the VPD inquiry info isn't obtained initially,
it won't be attempted in the future.  So there shouldn't be a problem
with stale data, since we didn't obtain it in the first place.

This is predicated on the assumption that stale data is an issue,
but that was the whole point of Hannes' change to re-probe the VPD
data on rescan.

-Ewan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


