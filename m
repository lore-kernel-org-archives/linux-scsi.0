From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v5 1/2] arcmsr: simplify ioctl data read/write
Date: Thu, 25 Sep 2014 17:56:33 +0800
Message-ID: <1411638993.8266.46.camel@Centos6.3-64>
References: <1411551214.4648.51.camel@Centos6.3-64>
	 <5422E7BB.6090108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5422E7BB.6090108@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-09-24 at 17:48 +0200, Tomas Henzl wrote:
> On 09/24/2014 11:33 AM, Ching Huang wrote:
> > From: Ching Huang <ching2048@areca.com.tw>
> >
> > This patch is relative to:
> > http://git.infradead.org/users/hch/scsi-queue.git/tree/drivers-for-3.18:/drivers/scsi/arcmsr
> >
> > change in v5:
> > 1. rename firstindex to getIndex, lastindex to putIndex for readability
> > 2. define ARCMSR_API_DATA_BUFLEN as 1032
> > 3. simplify ioctl data read by marcro CIRC_CNT_TO_END and CIRC_CNT
> >
> > Signed-off-by: Ching Huang <ching 2048@areca.com.tw>
> > ---
> >
> ...
> > +		pQbuffer = &acb->wqbuffer[acb->wqbuf_putIndex];
> > +		cnt2end = ARCMSR_MAX_QBUFFER - acb->wqbuf_putIndex;
> > +		if (user_len > cnt2end) {
> > +			memcpy(pQbuffer, ptmpuserbuffer, cnt2end);
> > +			ptmpuserbuffer += cnt2end;
> > +			user_len -= cnt2end;
> > +			acb->wqbuf_putIndex = 0;
> > +			pQbuffer = acb->wqbuffer;
> >  		}
> > +		memcpy(pQbuffer, ptmpuserbuffer, user_len);
> > +		acb->wqbuf_putIndex += user_len;
> > +		acb->wqbuf_putIndex %= ARCMSR_MAX_QBUFFER;
> > +		if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
> This test^ is most likely useless, it looks like you set the
> ACB_F_MESSAGE_WQBUFFER_CLEARED every time you have added some data to the buffer
> and clear it when the buffer gets empty. I think you could get rid of
> the ACB_F_MESSAGE_WQBUFFER_CLEARED completely. Also the ACB_F_MESSAGE_RQBUFFER_CLEARED doesn't
> seems to be ever evaluated.
> I'm not sure with the ACB_F_MESSAGE_WQBUFFER_READED, but that one probably is also
> a candidate for removal.
You are right. ACB_F_MESSAGE_WQBUFFER_CLEARED, ACB_F_MESSAGE_RQBUFFER_CLEARED, ACB_F_MESSAGE_WQBUFFER_READED
are seem useless.
> ...
> > @@ -678,15 +679,15 @@ struct AdapterControlBlock
> >  	unsigned int				uncache_size;
> >  	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
> >  	/* data collection buffer for read from 80331 */
> > -	int32_t				rqbuf_firstindex;
> > +	int32_t				rqbuf_getIndex;
> What is the reason for using an exact size int32 (instead of a plain int) here?
There is not special reason have to int32, int is OK.
> >  	/* first of read buffer  */
> > -	int32_t				rqbuf_lastindex;
> > +	int32_t				rqbuf_putIndex;
> >  	/* last of read buffer   */
> >  	uint8_t				wqbuffer[ARCMSR_MAX_QBUFFER];
> >  	/* data collection buffer for write to 80331  */
> > -	int32_t				wqbuf_firstindex;
> > +	int32_t				wqbuf_getIndex;
> >  	/* first of write buffer */
> > -	int32_t				wqbuf_lastindex;
> > +	int32_t				wqbuf_putIndex;
> >  	/* last of write buffer  */
> >  	uint8_t				devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
> >  	/* id0 ..... id15, lun0...lun7 */
> 
> The comments I've added are not directly related to this patch,
> but you may still address them in a new patch
> so -
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> 
> 
> 
