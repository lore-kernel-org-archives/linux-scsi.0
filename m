From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH RESEND V2 3/7] scsi: storvsc: Untangle the storage protocol negotiation from the vmbus protocol negotiation.
Date: Fri, 14 Aug 2015 08:45:57 +0200
Message-ID: <mqdwpwy74gq.fsf@c203.arch.suse.de>
References: <1439480609-11099-1-git-send-email-kys@microsoft.com>
	<1439480632-11144-1-git-send-email-kys@microsoft.com>
	<1439480632-11144-3-git-send-email-kys@microsoft.com>
	<mqda8tv6yx1.fsf@c203.arch.suse.de>
	<SN1PR0301MB166260423693200F01696E72A07D0@SN1PR0301MB1662.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN1PR0301MB166260423693200F01696E72A07D0@SN1PR0301MB1662.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Thu, 13 Aug 2015 15:18:57 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Keith Mange <Keith.Mange@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org

KY Srinivasan <kys@microsoft.com> writes:

>> -----Original Message-----
>> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
>> Sent: Thursday, August 13, 2015 7:34 AM
>> To: KY Srinivasan <kys@microsoft.com>; Keith Mange
>> <Keith.Mange@microsoft.com>
>> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; ohering@suse.com;
>> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.=
org;
>> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com
>> Subject: Re: [PATCH RESEND V2 3/7] scsi: storvsc: Untangle the stora=
ge
>> protocol negotiation from the vmbus protocol negotiation.
>>=20
>> "K. Y. Srinivasan" <kys@microsoft.com> writes:
>>=20
>> > From: Keith Mange <keith.mange@microsoft.com>
>> >
>> > Currently we are making decisions based on vmbus protocol versions
>> > that have been negotiated; use storage potocol versions instead.
>> >
>> > Tested-by: Alex Ng <alexng@microsoft.com>
>> > Signed-off-by: Keith Mange <keith.mange@microsoft.com>
>> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>> > ---
>> >  drivers/scsi/storvsc_drv.c |  109
>> +++++++++++++++++++++++++++++++++++---------
>> >  1 files changed, 87 insertions(+), 22 deletions(-)
>> >
>> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv=
=2Ec
>> > index 5f9d133..f29871e 100644
>> > --- a/drivers/scsi/storvsc_drv.c
>> > +++ b/drivers/scsi/storvsc_drv.c
>> > @@ -56,14 +56,18 @@
>> >   * V1 RC > 2008/1/31:  2.0
>> >   * Win7: 4.2
>> >   * Win8: 5.1
>> > + * Win8.1: 6.0
>> > + * Win10: 6.2
>> >   */
>> >
>> >  #define VMSTOR_PROTO_VERSION(MAJOR_, MINOR_)	((((MAJOR_)
>> & 0xff) << 8) | \
>> >  						(((MINOR_) & 0xff)))
>> >
>> > +#define VMSTOR_PROTO_VERSION_WIN6
>> 	VMSTOR_PROTO_VERSION(2, 0)
>> >  #define VMSTOR_PROTO_VERSION_WIN7
>> 	VMSTOR_PROTO_VERSION(4, 2)
>> >  #define VMSTOR_PROTO_VERSION_WIN8
>> 	VMSTOR_PROTO_VERSION(5, 1)
>> > -
>> > +#define VMSTOR_PROTO_VERSION_WIN8_1
>> 	VMSTOR_PROTO_VERSION(6, 0)
>> > +#define VMSTOR_PROTO_VERSION_WIN10
>> 	VMSTOR_PROTO_VERSION(6, 2)
>> >
>> >  /*  Packet structure describing virtual storage requests. */
>> >  enum vstor_packet_operation {
>> > @@ -205,6 +209,46 @@ struct vmscsi_request {
>> >
>> >
>> >  /*
>> > + * The list of storage protocols in order of preference.
>> > + */
>> > +struct vmstor_protocol {
>> > +	int protocol_version;
>> > +	int sense_buffer_size;
>> > +	int vmscsi_size_delta;
>> > +};
>> > +
>> > +#define VMSTOR_NUM_PROTOCOLS    5
>>=20
>> can't you just use ARRAY_SIZE() here, so you don't have to touch the
>> constant every time a new protocol is appended to the list?
>
> Certainly. These patches have been floating around for more than a mo=
nth now and if it is ok
> with you, I will submit a patch on top of this current series to addr=
ess the concern you have raised.
> James, please let me know.
>

No objections from my side, but it's up to James to decide what and whe=
n
he picks up patches.

Thanks,
        Johannes

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
