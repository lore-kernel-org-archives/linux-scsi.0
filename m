From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: scsi_dh_rdac: Changing the memory allocation flag
 from GFP_KERNEL to GFP_NOIO
Date: Thu, 4 Nov 2010 09:20:57 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4F4F3014C@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4877BC7E8@cosmail01.lsi.com>
	<20101104151436.GA1026@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101104151436.GA1026@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Seetharaman <chandra.seetharaman@us.ibm.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Rob Evers <revers@redhat.com>, Chandra@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Thursday, November 04, 2010 10:15 AM
> To: device-mapper development
> Cc: linux-scsi@vger.kernel.org; Chandra Seetharaman;
> michaelc@cs.wisc.edu; Rob Evers; Moger, Babu
> Subject: Re: scsi_dh_rdac: Changing the memory allocation flag from
> GFP_KERNEL to GFP_NOIO
> 
> This patch appears to have gotten lost in the shuffle but still seems
> relevant.  I found it while auditing dm-devel's patchwork, patch is
> here: https://patchwork.kernel.org/patch/71073/

  Yes, Please.. We need this patch.. 
> 
> On Tue, Jan 05 2010 at 12:20pm -0500,
> Moger, Babu <Babu.Moger@lsi.com> wrote:
> 
> > This patch changes the memory allocation flag from GFP_KERNEL to
> GFP_NOIO which is more appropriate.
> >
> > This was noticed by Mike Christie and Rob Evers..
> > Mike Christie wrote:
> > > Rob Evers wrote:
> > >> +
> > >> +static int queue_mode_select(struct scsi_device *sdev,
> > >> +                activate_complete fn, void *data)
> > >> +{
> > >> +    struct rdac_queue_data *qdata;
> > >> +    struct rdac_controller *ctlr;
> > >> +
> > >> +    qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> > >> +    if (!qdata)
> > >> +        return SCSI_DH_RETRY;
> > >> +
> > >
> > > It looks like this is called in the main IO path. A failed IO could
> cause, the path to go down,
> > > then we would call this to active a new path. If the system needed
> to write out pages to the same
> > > disk that just had the failed path so it can allocate memory then
> GFP_KERNEL would be bad to use here.
> > > You would use a mempool and still use something like GFP_NOIO. If a
> mempool is not possible for some
> > > reason, then you would want to still use GFP_NOIO.
> >
> > Using mempool would become bit more complex here because I cannot
> assume about the number of elements
> > during the allocation. I would use GFP_NOIO.
> >
> > CC: Mike Christie <michaelc@cs.wisc.edu>
> > CC: Rob Evers <revers@redhat.com>
> > CC: Chandra Seetharaman <chandra.seetharaman@us.ibm.com>
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> >
> > ---
> > --- linux-2.6.33-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 	2010-01-05 11:49:22.000000000 -0400
> > +++ linux-2.6.33-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-
> 01-05 11:53:13.000000000 -0400
> > @@ -624,7 +624,7 @@ static int queue_mode_select(struct scsi
> >  	struct rdac_queue_data *qdata;
> >  	struct rdac_controller *ctlr;
> >
> > -	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> > +	qdata = kzalloc(sizeof(*qdata), GFP_NOIO);
> >  	if (!qdata)
> >  		return SCSI_DH_RETRY;
> >
> >
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
