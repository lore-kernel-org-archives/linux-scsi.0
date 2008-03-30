From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 14/17] drivers/scsi/hptiop.c: fix build warning
Date: Sun, 30 Mar 2008 12:36:26 -0500
Message-ID: <1206898586.4224.61.camel@localhost.localdomain>
References: <200803282148.m2SLmfAG012255@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40104 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbYC3Rg3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 13:36:29 -0400
In-Reply-To: <200803282148.m2SLmfAG012255@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, linux@highpoint-tech.com

On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> powerpc:
> 
> drivers/scsi/hptiop.c: In function 'iop_set_config_mv':
> drivers/scsi/hptiop.c:395: warning: large integer implicitly truncated to unsigned type
> 
> This field is only 32-bit, so cpu_to_le64() seems wrong.
> 
> Cc: HighPoint Linux Team <linux@highpoint-tech.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/hptiop.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/hptiop.c~drivers-scsi-hptiopc-fix-build-warning drivers/scsi/hptiop.c
> --- a/drivers/scsi/hptiop.c~drivers-scsi-hptiopc-fix-build-warning
> +++ a/drivers/scsi/hptiop.c
> @@ -392,7 +392,7 @@ static int iop_set_config_mv(struct hpti
>  	req->header.size =
>  		cpu_to_le32(sizeof(struct hpt_iop_request_set_config));
>  	req->header.result = cpu_to_le32(IOP_RESULT_PENDING);
> -	req->header.context = cpu_to_le64(IOP_REQUEST_TYPE_SET_CONFIG<<5);
> +	req->header.context = cpu_to_le32(IOP_REQUEST_TYPE_SET_CONFIG<<5);
>  
>  	if (iop_send_sync_request_mv(hba, 0, 20000)) {
>  		dprintk("Set config send cmd failed\n");

I'm curious to know why the identical statement in iop_get_config_mv()
doesn't trigger any warnings.

Regardless, the usage of this field is 64 bits; it's just split high and
low, so the correct fix is to do the le32 for the low field and to zero
out the high one.

Fortunately, I suspect nothing ever sets the high field, so it's
probably accidentally zero most of the time.

Can I get an ack for this (or a better fix) from the highpoint team?

James

---

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 44dccf2..beecda9 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -338,7 +338,8 @@ static int iop_get_config_mv(struct hptiop_hba *hba,
 	req->header.size =
 		cpu_to_le32(sizeof(struct hpt_iop_request_get_config));
 	req->header.result = cpu_to_le32(IOP_RESULT_PENDING);
-	req->header.context = cpu_to_le64(IOP_REQUEST_TYPE_GET_CONFIG<<5);
+	req->header.context = cpu_to_le32(IOP_REQUEST_TYPE_GET_CONFIG<<5);
+	req->header.context_hi32 = 0;
 
 	if (iop_send_sync_request_mv(hba, 0, 20000)) {
 		dprintk("Get config send cmd failed\n");
@@ -392,7 +393,8 @@ static int iop_set_config_mv(struct hptiop_hba *hba,
 	req->header.size =
 		cpu_to_le32(sizeof(struct hpt_iop_request_set_config));
 	req->header.result = cpu_to_le32(IOP_RESULT_PENDING);
-	req->header.context = cpu_to_le64(IOP_REQUEST_TYPE_SET_CONFIG<<5);
+	req->header.context = cpu_to_le32(IOP_REQUEST_TYPE_SET_CONFIG<<5);
+	req->header.context_hi32 = 0;
 
 	if (iop_send_sync_request_mv(hba, 0, 20000)) {
 		dprintk("Set config send cmd failed\n");
 

