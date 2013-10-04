From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: Derive the FLUSH_TIMEOUT from the
 basic I/O timeout
Date: Fri, 4 Oct 2013 22:33:09 +0000
Message-ID: <e099a0ad7a30465da12bf9b6c7dab33a@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1380915516-28720-1-git-send-email-kys@microsoft.com>
	 <1380922944.3868.8.camel@dabdike.int.hansenpartnership.com>
	 <2c2ffa39467f4931b2b66ca0602af766@SN2PR03MB061.namprd03.prod.outlook.com>
 <1380925890.3868.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1380925890.3868.12.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "eric@purestorage.com" <eric@purestorage.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Friday, October 04, 2013 3:31 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org;
> eric@purestorage.com; nab@linux-iscsi.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: Derive the FLUSH_TIMEOUT from the basic
> I/O timeout
> 
> On Fri, 2013-10-04 at 22:01 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: James Bottomley [mailto:jbottomley@parallels.com]
> > > Sent: Friday, October 04, 2013 2:42 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org;
> > > eric@purestorage.com; nab@linux-iscsi.org; linux-scsi@vger.kernel.org
> > > Subject: Re: [PATCH 1/1] Drivers: scsi: Derive the FLUSH_TIMEOUT from the
> basic
> > > I/O timeout
> > >
> > > On Fri, 2013-10-04 at 12:38 -0700, K. Y. Srinivasan wrote:
> > > > Rather than having a separate constant for specifying the timeout on FLUSH
> > > > operations, use the basic I/O timeout value that is already configurable
> > > > on a per target basis to derive the FLUSH timeout. Looking at the current
> > > > definitions of these timeout values, the FLUSH operation is supposed to
> have
> > > > a value that is twice the normal timeout value. This patch preserves this
> > > > relationship while leveraging the flexibility of specifying the I/O timeout.
> > > >
> > > > I would like to thank Eric Seppanen <eric@purestorage.com> and
> > > > Nicholas A. Bellinger <nab@linux-iscsi.org> for their help in resolving
> > > > this issue.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > ---
> > > >  drivers/scsi/sd.c |    5 +++--
> > > >  1 files changed, 3 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > > > index e62d17d..8aff306 100644
> > > > --- a/drivers/scsi/sd.c
> > > > +++ b/drivers/scsi/sd.c
> > > > @@ -829,7 +829,7 @@ static int sd_setup_write_same_cmnd(struct
> > > scsi_device *sdp, struct request *rq)
> > > >
> > > >  static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request
> *rq)
> > > >  {
> > > > -	rq->timeout = SD_FLUSH_TIMEOUT;
> > > > +	rq->timeout *= 2;
> > > >  	rq->retries = SD_MAX_RETRIES;
> > > >  	rq->cmd[0] = SYNCHRONIZE_CACHE;
> > > >  	rq->cmd_len = 10;
> > > > @@ -1433,6 +1433,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
> > > >  {
> > > >  	int retries, res;
> > > >  	struct scsi_device *sdp = sdkp->device;
> > > > +	unsigned int timeout = sdp->request_queue->rq_timeout;
> > >
> > > The timeout is signed in the function prototype
> > >
> > > >  	struct scsi_sense_hdr sshdr;
> > > >
> > > >  	if (!scsi_device_online(sdp))
> > > > @@ -1448,7 +1449,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
> > > >  		 * flush everything.
> > > >  		 */
> > > >  		res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0,
> > > > -					     &sshdr, SD_FLUSH_TIMEOUT,
> > > > +					     &sshdr, timeout * 2,
> > > >  					     SD_MAX_RETRIES, NULL, REQ_PM);
> > > >  		if (res == 0)
> > > >  			break;
> > >
> > > Not like this, please: you now leave us with a dangling #define whose
> > > name makes you think it should be related to flushing and a couple of
> > > curious magic constants.  It's almost hand crafted to confuse people
> > > reading the code.
> > >
> > > Please do it like this instead: with a comment explaining what we're
> > > doing above the #define and a name that clearly relates to the actions.
> > >
> > > James
> > >
> > > ---
> > >
> > > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > > index e62d17d..5c9496d 100644
> > > --- a/drivers/scsi/sd.c
> > > +++ b/drivers/scsi/sd.c
> > > @@ -829,7 +829,7 @@ static int sd_setup_write_same_cmnd(struct
> scsi_device
> > > *sdp, struct request *rq)
> > >
> > >  static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
> > >  {
> > > -	rq->timeout = SD_FLUSH_TIMEOUT;
> > > +	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> > >  	rq->retries = SD_MAX_RETRIES;
> > >  	rq->cmd[0] = SYNCHRONIZE_CACHE;
> > >  	rq->cmd_len = 10;
> > > @@ -1433,6 +1433,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
> > >  {
> > >  	int retries, res;
> > >  	struct scsi_device *sdp = sdkp->device;
> > > +	const int timeout = sdp->request_queue->rq_timeout
> > > +		* SD_FLUSH_TIMEOUT_MULTIPLIER;
> > >  	struct scsi_sense_hdr sshdr;
> > >
> > >  	if (!scsi_device_online(sdp))
> > > @@ -1448,8 +1450,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
> > >  		 * flush everything.
> > >  		 */
> > >  		res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0,
> > > -					     &sshdr, SD_FLUSH_TIMEOUT,
> > > -					     SD_MAX_RETRIES, NULL, REQ_PM);
> > > +					     &sshdr, timeout, SD_MAX_RETRIES,
> > > +					     NULL, REQ_PM);
> > >  		if (res == 0)
> > >  			break;
> > >  	}
> > > diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> > > index 7a049de..7f7999c 100644
> > > --- a/drivers/scsi/sd.h
> > > +++ b/drivers/scsi/sd.h
> > > @@ -13,7 +13,11 @@
> > >   */
> > >  #define SD_TIMEOUT		(30 * HZ)
> > >  #define SD_MOD_TIMEOUT		(75 * HZ)
> > > -#define SD_FLUSH_TIMEOUT	(60 * HZ)
> > > +/*
> > > + * Flush timeout is a multiplier over the standard device timeout which is
> > > + * user modifiable via sysfs but initially set to SD_TIMEOUT
> > > + */
> > > +#define SD_FLUSH_TIMEOUT_MULTIPLIER	2
> > >  #define SD_WRITE_SAME_TIMEOUT	(120 * HZ)
> > >
> > >  /*
> >
> > Thanks James. Given that you have already made the changes you want done
> (in the
> > Patch above), do you still want me to send you a fixed up patch?
> 
> Either way is fine.  I just need the patch to be on the mailing list for
> my workflow (which it is now).

In that case, we will go with the patch you have. Thank you for taking the time on this.

Regards,

K. Y
> 
> James
> 
