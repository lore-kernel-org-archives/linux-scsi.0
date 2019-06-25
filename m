From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/4] block: add zone open, close and finish support
Date: Tue, 25 Jun 2019 08:55:56 -0700
Message-ID: <79ca395d-8019-9ec8-0c0b-194ca6d9eda0@acm.org>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-2-mb@lightnvm.io>
 <ee5764fb-473a-f118-eaac-95478d885f6f@acm.org>
 <BYAPR04MB5749CEFBB45EA34BD3345CD686E00@BYAPR04MB5749.namprd04.prod.outlook.com>
 <cce08df0-0b4d-833d-64ce-f9b81f7ad7ca@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cce08df0-0b4d-833d-64ce-f9b81f7ad7ca@lightnvm.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 6/25/19 3:35 AM, Matias Bjørling wrote:
> On 6/25/19 12:27 AM, Chaitanya Kulkarni wrote:
>> On 6/24/19 12:43 PM, Bart Van Assche wrote:
>>> static inline bool op_is_write(unsigned int op)
>>> {
>>>     return (op & 1);
>>> }
>>>
>>
> 
> The zone mgmt commands are neither write nor reads commands. I guess, 
> one could characterize them as write commands, but they don't write any 
> data, they update a state of a zone on a drive. One should keep it as 
> is? and make sure the zone mgmt commands don't get categorized as either 
> read/write.

Since the open, close and finish operations support modifying zone data 
I propose to characterize these as write commands. How about the 
following additional changes:
- Make bio_check_ro() refuse open/close/flush/reset zone operations for 
read-only partitions (see also commit a32e236eb93e ("Partially revert 
"block: fail op_is_write() requests to read-only partitions"") # v4.18).
- In submit_bio(), change op_is_write(bio_op(bio)) ? "WRITE" : "READ" 
into something that uses blk_op_str().
- Add open/close/flush zone support be added in blk_partition_remap().

Thanks,

Bart.
