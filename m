From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Wed, 4 Jun 2014 17:15:15 +0000
Message-ID: <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <1401901323.17510.23.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1401901323.17510.23.camel@dabdike>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Wednesday, June 4, 2014 10:02 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; apw@canonical.com;
> devel@linuxdriverproject.org; hch@infradead.org; linux-
> scsi@vger.kernel.org; ohering@suse.com; gregkh@linuxfoundation.org;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
> from the basic I/O timeout
> 
> On Wed, 2014-06-04 at 09:33 -0700, K. Y. Srinivasan wrote:
> > Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to
> > derive the FLUSH_TIMEOUT from the basic I/O timeout. However, this
> > patch did not use the basic I/O timeout of the device. Fix this bug.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/sd.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> > e9689d5..54150b1 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -832,7 +832,9 @@ static int sd_setup_write_same_cmnd(struct
> > scsi_device *sdp, struct request *rq)
> >
> >  static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct
> > request *rq)  {
> > -	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> > +	int timeout = sdp->request_queue->rq_timeout;
> > +
> > +	rq->timeout = (timeout * SD_FLUSH_TIMEOUT_MULTIPLIER);
> 
> Could you share where you found this to be a problem?  It looks like a bug in
> block because all inbound requests being prepared should have a timeout
> set, so block would be the place to fix it.

Perhaps; what I found was that the value in rq->timeout was 0 coming into
this function and thus multiplying obviously has no effect.

> 
> I can't see how this can happen because we definitely add the timer after the
> request is prepared in my reading of the block code, unless I'm missing some
> path in block that violates this.
> 
> James

K. Y
