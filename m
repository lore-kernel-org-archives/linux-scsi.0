From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <mb@lightnvm.io>
Subject: Re: [PATCH 1/4] block: add zone open, close and finish support
Date: Tue, 25 Jun 2019 18:53:34 +0200
Message-ID: <CAOA7RkP83-6PgsKxzoa3i0bY7RW1R3Jh2zhLkywKsYJSnA3AMw@mail.gmail.com>
References: <20190621130711.21986-1-mb@lightnvm.io> <20190621130711.21986-2-mb@lightnvm.io>
 <ee5764fb-473a-f118-eaac-95478d885f6f@acm.org> <BYAPR04MB5749CEFBB45EA34BD3345CD686E00@BYAPR04MB5749.namprd04.prod.outlook.com>
 <cce08df0-0b4d-833d-64ce-f9b81f7ad7ca@lightnvm.io> <79ca395d-8019-9ec8-0c0b-194ca6d9eda0@acm.org>
 <BYAPR04MB5749977B2FFB5CDC8A254F5A86E30@BYAPR04MB5749.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BYAPR04MB5749977B2FFB5CDC8A254F5A86E30@BYAPR04MB5749.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc: Bart Van Assche <bvanassche@acm.org>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 25, 2019 at 6:51 PM Chaitanya Kulkarni
<Chaitanya.Kulkarni@wdc.com> wrote:
>
> On 06/25/2019 08:56 AM, Bart Van Assche wrote:
> > On 6/25/19 3:35 AM, Matias Bj=C3=B8rling wrote:
> >> On 6/25/19 12:27 AM, Chaitanya Kulkarni wrote:
> >>> On 6/24/19 12:43 PM, Bart Van Assche wrote:
> >>>> static inline bool op_is_write(unsigned int op)
> >>>> {
> >>>>      return (op & 1);
> >>>> }
> >>>>
> >>>
> >>
> >> The zone mgmt commands are neither write nor reads commands. I guess,
> >> one could characterize them as write commands, but they don't write an=
y
> >> data, they update a state of a zone on a drive. One should keep it as
> >> is? and make sure the zone mgmt commands don't get categorized as eith=
er
> >> read/write.
> >
> > Since the open, close and finish operations support modifying zone data
> > I propose to characterize these as write commands. How about the
> > following additional changes:
> > - Make bio_check_ro() refuse open/close/flush/reset zone operations for
>                                           ^
> Since finish also listed above which supports modifying data do we need
> to add finish here with flush in above line ?
>
> > read-only partitions (see also commit a32e236eb93e ("Partially revert
> > "block: fail op_is_write() requests to read-only partitions"") # v4.18)=
.
> > - In submit_bio(), change op_is_write(bio_op(bio)) ? "WRITE" : "READ"
> > into something that uses blk_op_str().
> Good idea, I've a patch for blk_op_str() and debugfs just waiting for
> this to merge. Does it make sense to add that patch in this series ?

Ship it off separately. Your patches can go in first.

> > - Add open/close/flush zone support be added in blk_partition_remap().
> same here for finish ?
> >
> > Thanks,
> >
> > Bart.
> >
>
