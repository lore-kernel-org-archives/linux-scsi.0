From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Mon, 18 Feb 2008 19:48:49 -0800
Message-ID: <eada2a070802181948p782a4862p3bc08db7b2b64beb@mail.gmail.com>
References: <20080217233701.GA30994@tpepper-t42p.dolavim.us>
	 <20080218223246I.tomof@acm.org>
	 <20080218233057.GC12905@tpepper-t42p.dolavim.us>
	 <20080219091121I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:44636 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYBSDsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 22:48:50 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3184006wah.23
        for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 19:48:49 -0800 (PST)
In-Reply-To: <20080219091121I.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Feb 18, 2008 4:11 PM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> Can you please help me just once more? 2.6.25-rc2 fixed this bug in a
> bit different way by chance. Please test 2.6.25-rc2 with the attached
> patch to make sure that ips in 2.6.25 works well.

Confirmed...the patch below against 2.6.25-rc2 also works for me.

Thank you again Fujita-san!

>
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index bb152fb..429592a 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -1576,7 +1576,7 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
>         METHOD_TRACE("ips_make_passthru", 1);
>
>          scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
> -                length += sg[i].length;
> +                length += sg->length;
>
>         if (length < sizeof (ips_passthru_t)) {
>                 /* wrong size */
> @@ -3510,15 +3510,16 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
>          struct scatterlist *sg = scsi_sglist(scmd);
>
>          for (i = 0, xfer_cnt = 0;
> -             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
> -                min_cnt = min(count - xfer_cnt, sg[i].length);
> +             (i < scsi_sg_count(scmd)) && (xfer_cnt < count);
> +             i++, sg = sg_next(sg)) {
> +                min_cnt = min(count - xfer_cnt, sg->length);
>
>                  /* kmap_atomic() ensures addressability of the data buffer.*/
>                  /* local_irq_save() protects the KM_IRQ0 address slot.     */
>                  local_irq_save(flags);
> -                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
> +                buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
>                  memcpy(buffer, &cdata[xfer_cnt], min_cnt);
> -                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
> +                kunmap_atomic(buffer - sg->offset, KM_IRQ0);
>                  local_irq_restore(flags);
>
>                  xfer_cnt += min_cnt;
> @@ -3543,15 +3544,16 @@ ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
>          struct scatterlist *sg = scsi_sglist(scmd);
>
>          for (i = 0, xfer_cnt = 0;
> -             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
> -                min_cnt = min(count - xfer_cnt, sg[i].length);
> +             (i < scsi_sg_count(scmd)) && (xfer_cnt < count);
> +             i++, sg = sg_next(sg)) {
> +                min_cnt = min(count - xfer_cnt, sg->length);
>
>                  /* kmap_atomic() ensures addressability of the data buffer.*/
>                  /* local_irq_save() protects the KM_IRQ0 address slot.     */
>                  local_irq_save(flags);
> -                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
> +                buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
>                  memcpy(&cdata[xfer_cnt], buffer, min_cnt);
> -                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
> +                kunmap_atomic(buffer - sg->offset, KM_IRQ0);
>                  local_irq_restore(flags);
>
>                  xfer_cnt += min_cnt;
