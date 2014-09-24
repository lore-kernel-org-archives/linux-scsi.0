From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 1/2] arcmsr: simplify ioctl data read/write
Date: Wed, 24 Sep 2014 17:48:11 +0200
Message-ID: <5422E7BB.6090108@redhat.com>
References: <1411551214.4648.51.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411551214.4648.51.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/24/2014 11:33 AM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>
> This patch is relative to:
> http://git.infradead.org/users/hch/scsi-queue.git/tree/drivers-for-3.18:/drivers/scsi/arcmsr
>
> change in v5:
> 1. rename firstindex to getIndex, lastindex to putIndex for readability
> 2. define ARCMSR_API_DATA_BUFLEN as 1032
> 3. simplify ioctl data read by marcro CIRC_CNT_TO_END and CIRC_CNT
>
> Signed-off-by: Ching Huang <ching 2048@areca.com.tw>
> ---
>
...
> +		pQbuffer = &acb->wqbuffer[acb->wqbuf_putIndex];
> +		cnt2end = ARCMSR_MAX_QBUFFER - acb->wqbuf_putIndex;
> +		if (user_len > cnt2end) {
> +			memcpy(pQbuffer, ptmpuserbuffer, cnt2end);
> +			ptmpuserbuffer += cnt2end;
> +			user_len -= cnt2end;
> +			acb->wqbuf_putIndex = 0;
> +			pQbuffer = acb->wqbuffer;
>  		}
> +		memcpy(pQbuffer, ptmpuserbuffer, user_len);
> +		acb->wqbuf_putIndex += user_len;
> +		acb->wqbuf_putIndex %= ARCMSR_MAX_QBUFFER;
> +		if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
This test^ is most likely useless, it looks like you set the
ACB_F_MESSAGE_WQBUFFER_CLEARED every time you have added some data to the buffer
and clear it when the buffer gets empty. I think you could get rid of
the ACB_F_MESSAGE_WQBUFFER_CLEARED completely. Also the ACB_F_MESSAGE_RQBUFFER_CLEARED doesn't
seems to be ever evaluated.
I'm not sure with the ACB_F_MESSAGE_WQBUFFER_READED, but that one probably is also
a candidate for removal.
...
> @@ -678,15 +679,15 @@ struct AdapterControlBlock
>  	unsigned int				uncache_size;
>  	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
>  	/* data collection buffer for read from 80331 */
> -	int32_t				rqbuf_firstindex;
> +	int32_t				rqbuf_getIndex;
What is the reason for using an exact size int32 (instead of a plain int) here?
>  	/* first of read buffer  */
> -	int32_t				rqbuf_lastindex;
> +	int32_t				rqbuf_putIndex;
>  	/* last of read buffer   */
>  	uint8_t				wqbuffer[ARCMSR_MAX_QBUFFER];
>  	/* data collection buffer for write to 80331  */
> -	int32_t				wqbuf_firstindex;
> +	int32_t				wqbuf_getIndex;
>  	/* first of write buffer */
> -	int32_t				wqbuf_lastindex;
> +	int32_t				wqbuf_putIndex;
>  	/* last of write buffer  */
>  	uint8_t				devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
>  	/* id0 ..... id15, lun0...lun7 */

The comments I've added are not directly related to this patch,
but you may still address them in a new patch
so -
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
