From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 04/14] blk-mq-sched: improve dispatching from sw queue
Date: Thu, 3 Aug 2017 17:33:13 +0000
Message-ID: <1501781583.2922.12.camel@wdc.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
         <20170731165111.11536-6-ming.lei@redhat.com>
         <1501544074.2466.29.camel@wdc.com> <20170801101718.GB31452@ming.t460p>
         <20170801105013.GD31452@ming.t460p> <1501600301.2475.1.camel@wdc.com>
         <20170802033135.GB7267@ming.t460p> <1501724126.30887.3.camel@wdc.com>
         <20170803031344.GA8327@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170803031344.GA8327@ming.t460p>
Content-Language: en-US
Content-ID: <DA8E3C97DA13A74C9D571A474B121B00@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-08-03 at 11:13 +0800, Ming Lei wrote:
> On Thu, Aug 03, 2017 at 01:35:29AM +0000, Bart Van Assche wrote:
> > On Wed, 2017-08-02 at 11:31 +0800, Ming Lei wrote:
> > > On Tue, Aug 01, 2017 at 03:11:42PM +0000, Bart Van Assche wrote:
> > > > On Tue, 2017-08-01 at 18:50 +0800, Ming Lei wrote:
> > > > > On Tue, Aug 01, 2017 at 06:17:18PM +0800, Ming Lei wrote:
> > > > > > How can we get the accurate 'number of requests in progress' ef=
ficiently?
> > > >=20
> > > > Hello Ming,
> > > >=20
> > > > How about counting the number of bits that have been set in the tag=
 set?
> > > > I am aware that these bits can be set and/or cleared concurrently w=
ith the
> > > > dispatch code but that count is probably a good starting point.
> > >=20
> > > It has to be atomic_t, which is too too heavy for us, please see the =
report:
> > >=20
> > > 	http://marc.info/?t=3D149868448400003&r=3D1&w=3D2
> > >=20
> > > Both Jens and I want to kill hd_struct.in_flight, but looks still no
> > > good way.=20
> >=20
> > Hello Ming,
> >=20
> > Sorry but I disagree that a new atomic variable should be added to keep=
 track
> > of the number of busy requests. Counting the number of bits that are se=
t in
> > the tag set should be good enough in this context.
>=20
> That won't work because the tag set is host wide and shared by all LUNs.

Hello Ming,

Are you aware that the SCSI core already keeps track of the number of busy =
requests
per LUN? See also the device_busy member of struct scsi_device. How about g=
iving the
block layer core access in some way to that counter?

Bart.=
