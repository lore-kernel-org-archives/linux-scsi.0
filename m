From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RFC] increase ST_MAX_TAPES from 128 to 1024
Date: Fri, 17 Aug 2012 16:37:53 +0100
Message-ID: <1345217873.2838.12.camel@dabdike.int.hansenpartnership.com>
References: <1345215024-5883-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47046 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758306Ab2HQPh6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Aug 2012 11:37:58 -0400
In-Reply-To: <1345215024-5883-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: Kai.Makisara@kolumbus.fi, jeffm@suse.com, lduncan@suse.com, linux-scsi@vger.kernel.org

On Fri, 2012-08-17 at 10:50 -0400, Rob Evers wrote:
> Wondering if this would be an acceptable interim solution
> to increasing the limit on the number of tape drives
> while http://marc.info/?l=linux-scsi&m=134212042809524&w=2
> gets sorted out.
> 
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
>  drivers/scsi/st.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
> index b548923..408d24f 100644
> --- a/drivers/scsi/st.h
> +++ b/drivers/scsi/st.h
> @@ -76,7 +76,7 @@ struct st_modedef {
>  #define ST_MODE_SHIFT (7 - ST_NBR_MODE_BITS)
>  #define ST_MODE_MASK ((ST_NBR_MODES - 1) << ST_MODE_SHIFT)
>  
> -#define ST_MAX_TAPES 128
> +#define ST_MAX_TAPES 1024

This is going to cause an order 2 GFP_ATOMIC allocation (on 64 bit
platforms) for the contiguous scsi_tapes array ... if large numbers of
tapes are genuinely required, shouldn't we fix this first and then
expand the number quite a bit more?

James


