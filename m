From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/4] block: add zone open, close and finish support
Date: Mon, 24 Jun 2019 12:43:19 -0700
Message-ID: <ee5764fb-473a-f118-eaac-95478d885f6f@acm.org>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-2-mb@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621130711.21986-2-mb@lightnvm.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>, axboe@fb.com, hch@lst.de, damien.lemoal@wdc.com, chaitanya.kulkarni@wdc.com, dmitry.fomichev@wdc.com, ajay.joshi@wdc.com, aravind.ramesh@wdc.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, agk@redhat.com, snitzer@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, =?UTF-8?Q?Matias_Bj=c3=b8rling?= <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 6/21/19 6:07 AM, Matias Bjørling wrote:
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 95202f80676c..067ef9242275 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -284,13 +284,20 @@ enum req_opf {
>   	REQ_OP_DISCARD		= 3,
>   	/* securely erase sectors */
>   	REQ_OP_SECURE_ERASE	= 5,
> -	/* reset a zone write pointer */
> -	REQ_OP_ZONE_RESET	= 6,
>   	/* write the same sector many times */
>   	REQ_OP_WRITE_SAME	= 7,
>   	/* write the zero filled sector many times */
>   	REQ_OP_WRITE_ZEROES	= 9,
>   
> +	/* reset a zone write pointer */
> +	REQ_OP_ZONE_RESET	= 16,
> +	/* Open zone(s) */
> +	REQ_OP_ZONE_OPEN	= 17,
> +	/* Close zone(s) */
> +	REQ_OP_ZONE_CLOSE	= 18,
> +	/* Finish zone(s) */
> +	REQ_OP_ZONE_FINISH	= 19,
> +
>   	/* SCSI passthrough using struct scsi_request */
>   	REQ_OP_SCSI_IN		= 32,
>   	REQ_OP_SCSI_OUT		= 33,
> @@ -375,6 +382,22 @@ static inline void bio_set_op_attrs(struct bio *bio, unsigned op,
>   	bio->bi_opf = op | op_flags;
>   }

Are the new operation types ever passed to op_is_write()? The definition 
of that function is as follows:

static inline bool op_is_write(unsigned int op)
{
	return (op & 1);
}
