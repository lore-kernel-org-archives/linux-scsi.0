From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 1/4] block: add zone open, close and finish support
Date: Mon, 24 Jun 2019 22:27:55 +0000
Message-ID: <BYAPR04MB5749CEFBB45EA34BD3345CD686E00@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-2-mb@lightnvm.io>
 <ee5764fb-473a-f118-eaac-95478d885f6f@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, =?iso-8859-1?Q?Matias_Bj=F8rling?= <mb@lightnvm.io>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 6/24/19 12:43 PM, Bart Van Assche wrote:=0A=
> On 6/21/19 6:07 AM, Matias Bj=F8rling wrote:=0A=
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
>> index 95202f80676c..067ef9242275 100644=0A=
>> --- a/include/linux/blk_types.h=0A=
>> +++ b/include/linux/blk_types.h=0A=
>> @@ -284,13 +284,20 @@ enum req_opf {=0A=
>>    	REQ_OP_DISCARD		=3D 3,=0A=
>>    	/* securely erase sectors */=0A=
>>    	REQ_OP_SECURE_ERASE	=3D 5,=0A=
>> -	/* reset a zone write pointer */=0A=
>> -	REQ_OP_ZONE_RESET	=3D 6,=0A=
>>    	/* write the same sector many times */=0A=
>>    	REQ_OP_WRITE_SAME	=3D 7,=0A=
>>    	/* write the zero filled sector many times */=0A=
>>    	REQ_OP_WRITE_ZEROES	=3D 9,=0A=
>>    =0A=
>> +	/* reset a zone write pointer */=0A=
>> +	REQ_OP_ZONE_RESET	=3D 16,=0A=
>> +	/* Open zone(s) */=0A=
>> +	REQ_OP_ZONE_OPEN	=3D 17,=0A=
>> +	/* Close zone(s) */=0A=
>> +	REQ_OP_ZONE_CLOSE	=3D 18,=0A=
>> +	/* Finish zone(s) */=0A=
>> +	REQ_OP_ZONE_FINISH	=3D 19,=0A=
>> +=0A=
>>    	/* SCSI passthrough using struct scsi_request */=0A=
>>    	REQ_OP_SCSI_IN		=3D 32,=0A=
>>    	REQ_OP_SCSI_OUT		=3D 33,=0A=
>> @@ -375,6 +382,22 @@ static inline void bio_set_op_attrs(struct bio *bio=
, unsigned op,=0A=
>>    	bio->bi_opf =3D op | op_flags;=0A=
>>    }=0A=
> =0A=
> Are the new operation types ever passed to op_is_write()? The definition=
=0A=
> of that function is as follows:=0A=
> =0A=
May be we should change numbering since blktrace also relies on the =0A=
having on_is_write() without looking at the rq_ops().=0A=
=0A=
197  * Data direction bit lookup=0A=
  198  */=0A=
  199 static const u32 ddir_act[2] =3D { BLK_TC_ACT(BLK_TC_READ),=0A=
  200                                  BLK_TC_ACT(BLK_TC_WRITE) };  <----=
=0A=
  201=0A=
  202 #define BLK_TC_RAHEAD           BLK_TC_AHEAD=0A=
  203 #define BLK_TC_PREFLUSH         BLK_TC_FLUSH=0A=
  204=0A=
  205 /* The ilog2() calls fall out because they're constant */=0A=
  206 #define MASK_TC_BIT(rw, __name) ((rw & REQ_ ## __name) << \=0A=
  207           (ilog2(BLK_TC_ ## __name) + BLK_TC_SHIFT - __REQ_ ## =0A=
__name))=0A=
  208=0A=
  209 /*=0A=
  210  * The worker for the various blk_add_trace*() types. Fills out a=0A=
  211  * blk_io_trace structure and places it in a per-cpu subbuffer.=0A=
  212  */=0A=
  213 static void __blk_add_trace(struct blk_trace *bt, sector_t sector, =
=0A=
int bytes,=0A=
  214                      int op, int op_flags, u32 what, int error, =0A=
int pdu_len,=0A=
  215                      void *pdu_data, union kernfs_node_id *cgid)=0A=
  216 {=0A=
  217         struct task_struct *tsk =3D current;=0A=
  218         struct ring_buffer_event *event =3D NULL;=0A=
  219         struct ring_buffer *buffer =3D NULL;=0A=
  220         struct blk_io_trace *t;=0A=
  221         unsigned long flags =3D 0;=0A=
  222         unsigned long *sequence;=0A=
  223         pid_t pid;=0A=
  224         int cpu, pc =3D 0;=0A=
  225         bool blk_tracer =3D blk_tracer_enabled;=0A=
  226         ssize_t cgid_len =3D cgid ? sizeof(*cgid) : 0;=0A=
  227=0A=
  228         if (unlikely(bt->trace_state !=3D Blktrace_running && =0A=
!blk_tracer))=0A=
  229                 return;=0A=
  230=0A=
  231         what |=3D ddir_act[op_is_write(op) ? WRITE : READ];  <--- =0A=
=0A=
=0A=
> static inline bool op_is_write(unsigned int op)=0A=
> {=0A=
> 	return (op & 1);=0A=
> }=0A=
> =0A=
=0A=
