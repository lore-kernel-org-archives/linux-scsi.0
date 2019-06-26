From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/4] block: add zone open, close and finish support
Date: Wed, 26 Jun 2019 00:42:40 +0000
Message-ID: <BYAPR04MB5816BCFFAF9648A7A55B144AE7E20@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-2-mb@lightnvm.io>
 <ee5764fb-473a-f118-eaac-95478d885f6f@acm.org>
 <BYAPR04MB5749CEFBB45EA34BD3345CD686E00@BYAPR04MB5749.namprd04.prod.outlook.com>
 <cce08df0-0b4d-833d-64ce-f9b81f7ad7ca@lightnvm.io>
 <79ca395d-8019-9ec8-0c0b-194ca6d9eda0@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, =?iso-8859-1?Q?Matias_Bj=F8rling?= <mb@lightnvm.io>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 2019/06/26 0:56, Bart Van Assche wrote:=0A=
> On 6/25/19 3:35 AM, Matias Bj=F8rling wrote:=0A=
>> On 6/25/19 12:27 AM, Chaitanya Kulkarni wrote:=0A=
>>> On 6/24/19 12:43 PM, Bart Van Assche wrote:=0A=
>>>> static inline bool op_is_write(unsigned int op)=0A=
>>>> {=0A=
>>>> =A0=A0=A0=A0return (op & 1);=0A=
>>>> }=0A=
>>>>=0A=
>>>=0A=
>>=0A=
>> The zone mgmt commands are neither write nor reads commands. I guess, =
=0A=
>> one could characterize them as write commands, but they don't write any =
=0A=
>> data, they update a state of a zone on a drive. One should keep it as =
=0A=
>> is? and make sure the zone mgmt commands don't get categorized as either=
 =0A=
>> read/write.=0A=
> =0A=
> Since the open, close and finish operations support modifying zone data =
=0A=
> I propose to characterize these as write commands. How about the =0A=
> following additional changes:=0A=
> - Make bio_check_ro() refuse open/close/flush/reset zone operations for =
=0A=
> read-only partitions (see also commit a32e236eb93e ("Partially revert =0A=
> "block: fail op_is_write() requests to read-only partitions"") # v4.18).=
=0A=
> - In submit_bio(), change op_is_write(bio_op(bio)) ? "WRITE" : "READ" =0A=
> into something that uses blk_op_str().=0A=
> - Add open/close/flush zone support be added in blk_partition_remap().=0A=
=0A=
Sounds good to me. And indeed, all operations should be failed for RO=0A=
devices/partitions. Of note though is that only reset and finish operations=
 have=0A=
an effect on the zone data. Open and close have no effect at all on the zon=
e=0A=
data and only change the zone condition/state. But since they do change=0A=
something on the drive, we can still consider them as "write" operations.=
=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
