From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH RESEND V2 3/7] scsi: storvsc: Untangle the storage
 protocol negotiation from the vmbus protocol negotiation.
Date: Fri, 14 Aug 2015 19:26:19 +0000
Message-ID: <BY2PR0301MB1654C2E84D0B28E453AEBE9DA07C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1439480609-11099-1-git-send-email-kys@microsoft.com>
 <1439480632-11144-1-git-send-email-kys@microsoft.com>
 <1439480632-11144-3-git-send-email-kys@microsoft.com>
 <mqda8tv6yx1.fsf@c203.arch.suse.de>
 <SN1PR0301MB166260423693200F01696E72A07D0@SN1PR0301MB1662.namprd03.prod.outlook.com>
 <mqdwpwy74gq.fsf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <mqdwpwy74gq.fsf@c203.arch.suse.de>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Keith Mange <Keith.Mange@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Thursday, August 13, 2015 11:46 PM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: Keith Mange <Keith.Mange@microsoft.com>;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com
> Subject: Re: [PATCH RESEND V2 3/7] scsi: storvsc: Untangle the storage
> protocol negotiation from the vmbus protocol negotiation.
> 
> KY Srinivasan <kys@microsoft.com> writes:
> 
> >> -----Original Message-----
> >> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> >> Sent: Thursday, August 13, 2015 7:34 AM
> >> To: KY Srinivasan <kys@microsoft.com>; Keith Mange
> >> <Keith.Mange@microsoft.com>
> >> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >> devel@linuxdriverproject.org; ohering@suse.com;
> >> jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org;
> >> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com
> >> Subject: Re: [PATCH RESEND V2 3/7] scsi: storvsc: Untangle the storage
> >> protocol negotiation from the vmbus protocol negotiation.
> >>
> >> "K. Y. Srinivasan" <kys@microsoft.com> writes:
> >>
> >> > From: Keith Mange <keith.mange@microsoft.com>
> >> >
> >> > Currently we are making decisions based on vmbus protocol versions
> >> > that have been negotiated; use storage potocol versions instead.
> >> >
> >> > Tested-by: Alex Ng <alexng@microsoft.com>
> >> > Signed-off-by: Keith Mange <keith.mange@microsoft.com>
> >> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >> > ---
> >> >  drivers/scsi/storvsc_drv.c |  109
> >> +++++++++++++++++++++++++++++++++++---------
> >> >  1 files changed, 87 insertions(+), 22 deletions(-)
> >> >
> >> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> >> > index 5f9d133..f29871e 100644
> >> > --- a/drivers/scsi/storvsc_drv.c
> >> > +++ b/drivers/scsi/storvsc_drv.c
> >> > @@ -56,14 +56,18 @@
> >> >   * V1 RC > 2008/1/31:  2.0
> >> >   * Win7: 4.2
> >> >   * Win8: 5.1
> >> > + * Win8.1: 6.0
> >> > + * Win10: 6.2
> >> >   */
> >> >
> >> >  #define VMSTOR_PROTO_VERSION(MAJOR_, MINOR_)	((((MAJOR_)
> >> & 0xff) << 8) | \
> >> >  						(((MINOR_) & 0xff)))
> >> >
> >> > +#define VMSTOR_PROTO_VERSION_WIN6
> >> 	VMSTOR_PROTO_VERSION(2, 0)
> >> >  #define VMSTOR_PROTO_VERSION_WIN7
> >> 	VMSTOR_PROTO_VERSION(4, 2)
> >> >  #define VMSTOR_PROTO_VERSION_WIN8
> >> 	VMSTOR_PROTO_VERSION(5, 1)
> >> > -
> >> > +#define VMSTOR_PROTO_VERSION_WIN8_1
> >> 	VMSTOR_PROTO_VERSION(6, 0)
> >> > +#define VMSTOR_PROTO_VERSION_WIN10
> >> 	VMSTOR_PROTO_VERSION(6, 2)
> >> >
> >> >  /*  Packet structure describing virtual storage requests. */
> >> >  enum vstor_packet_operation {
> >> > @@ -205,6 +209,46 @@ struct vmscsi_request {
> >> >
> >> >
> >> >  /*
> >> > + * The list of storage protocols in order of preference.
> >> > + */
> >> > +struct vmstor_protocol {
> >> > +	int protocol_version;
> >> > +	int sense_buffer_size;
> >> > +	int vmscsi_size_delta;
> >> > +};
> >> > +
> >> > +#define VMSTOR_NUM_PROTOCOLS    5
> >>
> >> can't you just use ARRAY_SIZE() here, so you don't have to touch the
> >> constant every time a new protocol is appended to the list?
> >
> > Certainly. These patches have been floating around for more than a month
> now and if it is ok
> > with you, I will submit a patch on top of this current series to address the
> concern you have raised.
> > James, please let me know.
> >
> 
> No objections from my side, but it's up to James to decide what and when
> he picks up patches.

James,

I have sent a separate patch on top of the set I sent yesterday that addresses Johannes' comments.

Regards,

K. Y
