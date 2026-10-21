Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573469;
	b=KBz0tYvS3MSijfkuDp+qR74h2RcoQUgRyTUWRobplnvqKtlb8yVMFwTzAydUKfFa3LQ6
	 3s3eq/Of8whmqLHKCDWA6SjClK/DNdaIFy72pJud52hLarW4yWg+CnGAzOAPzmN68lx39
	 /l8mAphd/iWJzxcJJEJWDQ4MSBF4XjASKRbbqHSS8cvFHk4w1qz0g2ShYlrGihUcfWDwZ
	 VYyGN/WTLAHYXI+h2nXRVvLEc5rZRDw+xx38PyQ5EWpJsvIdF6hsbm2kmoS27cFzRZTVi
	 axsJlBLyukwcOqfd92QRLGAxfE2zzI/ewhE8Cjk07d1mZPAL3caI97Rm5mnpCAsvFQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573469;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3/hWLYB6w3Mj3LFP7HAS94SjHAyXxxTom+Qtezwgyi0=;
	b=CpcaYrQ0GCsg5BSU4fAyR6R8iJbXBCnBvOX2R+eCbHFDD8TgOrmNO7+tW19MDFkBwODG
	 zsLK+RCtHji+NUUw5AiYICFxs7Xav1OLppQ5saZh8fTZwSlUlJyfKhQngIuFITvCo2Vnp
	 ueooUHF1xsfeTc2KBuQ4IWndYFQUoefDauZf5/N3PPeilRkUn+5L9Q5U+FYTBL+2jrA4I
	 KcxYGE6R+cHtM4/Y2DIiy8dDR1oXRa8x24VeoG4iMycEvBDrGfeAfunbZHRr6QwFJBg5L
	 qkNDsmorBkZUMg5aXRMsJs61AJ4ovjEx8TkuiQd+in93bjWr+Pgi8dJ61Mw4zM6V/Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JitpVkAN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8898606A327;
	Wed, 21 Oct 2026 09:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JitpVkAN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E2C1F000D1;
	Wed, 21 Oct 2026 09:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792573468;
	bh=3/hWLYB6w3Mj3LFP7HAS94SjHAyXxxTom+Qtezwgyi0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JitpVkANZGg191X6WGfeHMrXrB40XWdFPKsZotCFqSpewg8/+ux2Z8g5eEPPnHuFw
	 2ugiuMPsx9onuLw5ZOP4Jtk6NTLc0dx33VV7WUsbFP1FEAPQY6LArQJ7hrDsnWUZw+
	 e7dKYSBaoyqAKzbT6HG+SOkdkQ9vHi3Ml1rI64gYthdr6vhGVrulauQVvgivsLIOVH
	 g1qfEvaM52oPGuLv4uUGfsJFOgANfTLvWKJzaY+t4TzorQqYRwilIpkkewyYBX7x7K
	 CJOI8e+ZHCOAZx9fNd6AxUllcTq7ScvTWyjxx5/jVnopavE/aRNnsU0pLhGsOFm8Bi
	 CBvXnLpxvAztw==
Message-ID: <sashiko-outbox-180003@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 2/2] zfcp: Use DMA streaming API to map I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "M Nikhil" <nikh1092@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261021083351.1626409-3-nikh1092@linux.ibm.com>
References: <20261021083351.1626409-1-nikh1092@linux.ibm.com>
 <20261021083351.1626409-3-nikh1092@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 09:04:27 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] scsi: zfcp: premature DMA mapping and missing sync of QTCB in =
zfcp_fsf
- [Critical] scsi: zfcp: premature DMA unmap before abort in zfcp_scsi_eh_a=
bort_handler()
- [High] scsi: zfcp: stale SBAL entries left in req_q on DMA map error paths
- [Medium] scsi: zfcp: stale sg_table nents in zfcp_fc_exec_bsg_job() trunc=
ates DMA map
--

commit 55b15d18ad86f261b72e93af06572f7a0dd07799
Author: M Nikhil <nikh1092@linux.ibm.com>

zfcp: Use DMA streaming API to map I/O

This commit converts zFCP I/O buffer handling (QTCB, SRB, CT/ELS, and SCSI
I/O buffers) from direct physical address translation to the DMA streaming
API using sg_table, dma_map_sgtable(), and dma_unmap_sgtable().

> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 12b3d2d0a2c87..2031055c48f8a 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -14,6 +14,7 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <scsi/fc/fc_els.h>
> +#include <linux/dma-mapping.h>
>  #include "zfcp_ext.h"
>  #include "zfcp_fc.h"
>  #include "zfcp_dbf.h"
> @@ -84,6 +85,86 @@ static void zfcp_fsf_class_not_supp(struct zfcp_fsf_re=
q *req)
>  	req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
>  }
> =20
> +/**
> + * zfcp_fsf_req_map_sg - map the scattergather list for DMA transfer
> + * @req: pointer to zfcp_fsf_req
> + * @sgt: pointer to scattergather list table
> + * @dma_dir: DMA data direction
> + * Returns: 0 on success, -EIO otherwise
> + */
> +int zfcp_fsf_req_map_sg(struct zfcp_fsf_req *req, struct sg_table *sgt,
> +			enum dma_data_direction dma_dir)
> +{
> +	unsigned int saved_orig_nents;
> +	int ret;
> +
> +	if (!valid_dma_direction(dma_dir))
> +		return sgt->orig_nents ? -EIO : 0;
> +
> +	if (!sgt->orig_nents)
> +		return 0;
> +
> +	/*
> +	 * The SCSI midlayer sets orig_nents to the allocated SG capacity and
> +	 * nents to the actually populated entry count (nents <=3D orig_nents).
> +	 * dma_map_sgtable() and dma_unmap_sgtable() both use orig_nents, so
> +	 * clamp it to the populated count to avoid mapping trailing zero-length
> +	 * entries. Only clamp when nents has been explicitly set (nents > 0);
> +	 * zFCP-internal sg_tables leave nents =3D 0 before mapping, relying
> +	 * solely on orig_nents.
> +	 */
> +	saved_orig_nents =3D sgt->orig_nents;
> +	if (sgt->nents > 0 && sgt->nents < sgt->orig_nents)
> +		sgt->orig_nents =3D sgt->nents;
> +
> +	ret =3D dma_map_sgtable(&req->adapter->ccw_device->dev, sgt, dma_dir, 0=
);
> +
> +	sgt->orig_nents =3D saved_orig_nents;
> +
> +	return ret;
> +}
> +
> +/**
> + * zfcp_fsf_req_unmap_sg - unmap the scattergather list after DMA transf=
er
> + * @req: pointer to zfcp_fsf_req
> + * @sgt: pointer to scattergather list table
> + * @dma_dir: DMA direction of the sg
> + */
> +void zfcp_fsf_req_unmap_sg(struct zfcp_fsf_req *req, struct sg_table *sg=
t,
> +			   enum dma_data_direction dma_dir)
> +{
> +	unsigned int saved_orig_nents;
> +
> +	/*
> +	 * We still need the check for mapped sg count here to not perform
> +	 * unmap for SCSI commands which have zero payload.
> +	 */
> +	if (!sgt->nents)
> +		return;
> +
> +	saved_orig_nents =3D sgt->orig_nents;
> +	if (sgt->nents < sgt->orig_nents)
> +		sgt->orig_nents =3D sgt->nents;
> +
> +	dma_unmap_sgtable(&req->adapter->ccw_device->dev, sgt, dma_dir, 0);
> +
> +	sgt->orig_nents =3D saved_orig_nents;
> +}

[Severity: Medium]
Can a reused BSG request tag leave a stale sgt->nents value in
ct_els->sgt_req or ct_els->sgt_resp and cause zfcp_fsf_req_map_sg() to
truncate the DMA mapping?

In drivers/s390/scsi/zfcp_fsf.c, zfcp_fsf_req_map_sg() assumes that
zFCP-internal sg_table structures always have sgt->nents =3D=3D 0 prior to
mapping, and clamps sgt->orig_nents to sgt->nents whenever
0 < sgt->nents < sgt->orig_nents. When the request completes,
zfcp_fsf_req_unmap_sg() leaves sgt->nents set to the mapped entry count.

However, in the FC BSG path:

  bsg_transport_sg_io_fn()
    bsg_queue_rq()
      fc_bsg_dispatch()
        zfcp_fc_exec_bsg_job()
          zfcp_fsf_send_ct() / zfcp_fsf_send_els()
            zfcp_fsf_setup_ct_els()
              zfcp_fsf_setup_ct_els_sbals()
                zfcp_qdio_sbals_from_sg()
                  zfcp_fsf_req_map_sg()

bsg_transport_sg_io_fn() only zeroes sizeof(struct bsg_job) and does not
clear job->dd_data (struct zfcp_fsf_ct_els) in the blk-mq request PDU. In
drivers/s390/scsi/zfcp_fc.c, zfcp_fc_exec_bsg_job() initializes sgl and
orig_nents without resetting nents:

	ct_els->sgt_req.sgl =3D job->request_payload.sg_list;
	ct_els->sgt_resp.sgl =3D job->reply_payload.sg_list;
	ct_els->sgt_req.orig_nents =3D sg_nents(ct_els->sgt_req.sgl);
	ct_els->sgt_resp.orig_nents =3D sg_nents(ct_els->sgt_resp.sgl);

If a BSG request tag is reused for a multi-segment payload after a command
that mapped fewer SG segments, won't zfcp_fsf_req_map_sg() clamp orig_nents
to the stale sgt->nents value and map only part of the scatterlist into
SBALEs while zfcp_qdio_real_bytes() sets req_buf_length and resp_buf_length
to the full byte count, causing the adapter to reject the request with
FSF_SBAL_MISMATCH?

[ ... ]

> @@ -870,10 +954,27 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(str=
uct zfcp_qdio *qdio,
>  		req->qtcb->prefix.qtcb_version =3D FSF_QTCB_CURRENT_VERSION;
>  		req->qtcb->header.req_handle =3D req->req_id;
>  		req->qtcb->header.fsf_command =3D fsf_cmd;
> -	}
> =20
> -	zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id, sbtype,
> -			   req->qtcb, sizeof(struct fsf_qtcb));
> +		sg_init_one(&req->metadata_sg, req->qtcb,
> +			    sizeof(struct fsf_qtcb));
> +		req->metadata_sgt.sgl =3D &req->metadata_sg;
> +		req->metadata_sgt.orig_nents =3D 1;
> +
> +		if (zfcp_fsf_req_map_sg(req, &req->metadata_sgt,
> +					DMA_BIDIRECTIONAL)) {
> +			zfcp_fsf_req_free(req);
> +			return ERR_PTR(-EIO);
> +		}
> +
> +		zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id,
> +				   sbtype, true,
> +				   sg_dma_len(req->metadata_sgt.sgl),
> +				   sg_dma_address(req->metadata_sgt.sgl));
> +	} else {
> +		/* SRB */
> +		zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id,
> +				   sbtype, false, 0, 0);
> +	}
> =20
>  	return req;
>  }

[ ... ]

> @@ -1130,19 +1247,41 @@ static void zfcp_fsf_send_ct_handler(struct zfcp_=
fsf_req *req)
>  		ct->handler(ct->handler_data);
>  }
> =20
> -static void zfcp_fsf_setup_ct_els_unchained(struct zfcp_qdio *qdio,
> -					    struct zfcp_qdio_req *q_req,
> -					    struct scatterlist *sg_req,
> -					    struct scatterlist *sg_resp)
> +static int zfcp_fsf_setup_ct_els_unchained(struct zfcp_fsf_req *req,
> +					   struct zfcp_qdio *qdio,
> +					   struct sg_table *sg_req_table,
> +					   struct sg_table *sg_resp_table)
>  {
> -	zfcp_qdio_fill_next(qdio, q_req, sg_virt(sg_req), sg_req->length);
> -	zfcp_qdio_fill_next(qdio, q_req, sg_virt(sg_resp), sg_resp->length);
> -	zfcp_qdio_set_sbale_last(qdio, q_req);
> +	int retval =3D 0;
> +
> +	retval =3D zfcp_fsf_req_map_sg(req, sg_req_table, DMA_TO_DEVICE);
> +	if (unlikely(retval))
> +		goto err;
> +
> +	retval =3D zfcp_fsf_req_map_sg(req, sg_resp_table,
> +				     DMA_FROM_DEVICE);
> +	if (unlikely(retval))
> +		goto err_unmap;
> +
> +	zfcp_qdio_fill_next(qdio, &req->qdio_req,
> +			    sg_dma_address(sg_req_table->sgl),
> +			    sg_dma_len(sg_req_table->sgl));
> +	zfcp_qdio_fill_next(qdio, &req->qdio_req,
> +			    sg_dma_address(sg_resp_table->sgl),
> +			    sg_dma_len(sg_resp_table->sgl));
> +	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
> +
> +	return 0;
> +
> +err_unmap:
> +	zfcp_fsf_req_unmap_sg(req, sg_req_table, DMA_TO_DEVICE);
> +err:
> +	return retval;
>  }
> =20
>  static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
> -				       struct scatterlist *sg_req,
> -				       struct scatterlist *sg_resp)
> +				       struct sg_table *sgt_req,
> +				       struct sg_table *sgt_resp)
>  {
>  	struct zfcp_adapter *adapter =3D req->adapter;
>  	struct zfcp_qdio *qdio =3D adapter->qdio;
> @@ -1150,57 +1289,72 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfc=
p_fsf_req *req,
>  	u32 feat =3D adapter->adapter_features;
> =20
>  	if (zfcp_adapter_multi_buffer_active(adapter)) {
> -		if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_req))
> +		if (zfcp_qdio_sbals_from_sg(qdio, sgt_req, req, DMA_TO_DEVICE))
>  			return -EIO;
> +
>  		qtcb->bottom.support.req_buf_length =3D
> -			zfcp_qdio_real_bytes(sg_req);
> -		if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_resp))
> -			return -EIO;
> +			zfcp_qdio_real_bytes(sgt_req->sgl);
> +
> +		if (zfcp_qdio_sbals_from_sg(qdio, sgt_resp, req, DMA_FROM_DEVICE))
> +			goto err_unmap;
> +
>  		qtcb->bottom.support.resp_buf_length =3D
> -			zfcp_qdio_real_bytes(sg_resp);
> +			zfcp_qdio_real_bytes(sgt_resp->sgl);
> =20
> -		zfcp_qdio_set_data_div(qdio, &req->qdio_req, sg_nents(sg_req));
> +		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
> +				       sgt_req->nents);
>  		zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
>  		zfcp_qdio_set_scount(qdio, &req->qdio_req);
>  		return 0;
>  	}
> =20
>  	/* use single, unchained SBAL if it can hold the request */
> -	if (zfcp_qdio_sg_one_sbale(sg_req) && zfcp_qdio_sg_one_sbale(sg_resp)) {
> -		zfcp_fsf_setup_ct_els_unchained(qdio, &req->qdio_req,
> -						sg_req, sg_resp);
> +	if (zfcp_qdio_sg_one_sbale(sgt_req->sgl) &&
> +	    zfcp_qdio_sg_one_sbale(sgt_resp->sgl)) {
> +		if (zfcp_fsf_setup_ct_els_unchained(req, qdio, sgt_req,
> +						    sgt_resp))
> +			return -EIO;
> +
>  		return 0;
>  	}
> =20
>  	if (!(feat & FSF_FEATURE_ELS_CT_CHAINED_SBALS))
>  		return -EOPNOTSUPP;
> =20
> -	if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_req))
> +	if (zfcp_qdio_sbals_from_sg(qdio, sgt_req, req, DMA_TO_DEVICE))
>  		return -EIO;
> =20
> -	qtcb->bottom.support.req_buf_length =3D zfcp_qdio_real_bytes(sg_req);
> +	qtcb->bottom.support.req_buf_length =3D
> +		zfcp_qdio_real_bytes(sgt_req->sgl);
> =20
>  	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
>  	zfcp_qdio_skip_to_last_sbale(qdio, &req->qdio_req);
> =20
> -	if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_resp))
> -		return -EIO;
> +	if (zfcp_qdio_sbals_from_sg(qdio, sgt_resp, req, DMA_FROM_DEVICE))
> +		goto err_unmap;
> =20
> -	qtcb->bottom.support.resp_buf_length =3D zfcp_qdio_real_bytes(sg_resp);
> +	qtcb->bottom.support.resp_buf_length =3D
> +		zfcp_qdio_real_bytes(sgt_resp->sgl);
> =20
>  	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
> =20
>  	return 0;
> +
> +err_unmap:
> +	zfcp_fsf_req_unmap_sg(req, sgt_req, DMA_TO_DEVICE);
> +	zfcp_qdio_zero_sbals(qdio->req_q, req->qdio_req.sbal_first,
> +			     req->qdio_req.sbal_number);
> +	return -EIO;
>  }

[ ... ]

> @@ -2606,6 +2793,10 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
>  	io->service_class =3D FSF_CLASS_3;
>  	io->fcp_cmnd_length =3D FCP_CMND_LEN;
> =20
> +	dma_sync_sgtable_for_device(&req->adapter->ccw_device->dev,
> +				    &req->metadata_sgt,
> +				    DMA_BIDIRECTIONAL);
> +
>  	if (scsi_get_prot_op(scsi_cmnd) !=3D SCSI_PROT_NORMAL) {
>  		io->data_block_length =3D scsi_prot_interval(scsi_cmnd);
>  		io->ref_tag_value =3D scsi_prot_ref_tag(scsi_cmnd);

[Severity: Critical]
When SWIOTLB bounce buffering is active (such as under s390 Secure Executio=
n),
won't the device see stale/zeroed QTCB contents for SCSI commands and all
other QTCB-based FSF requests?

In drivers/s390/scsi/zfcp_fsf.c, zfcp_fsf_req_create() maps req->qtcb with
zfcp_fsf_req_map_sg(req, &req->metadata_sgt, DMA_BIDIRECTIONAL) immediately
after setting only the initial prefix and header fields. Under SWIOTLB,
dma_map_sgtable() copies req->qtcb into the bounce buffer at that point.

In zfcp_fsf_fcp_cmnd(), dma_sync_sgtable_for_device() is called before the
remaining fields in req->qtcb->bottom.io are populated:

	dma_sync_sgtable_for_device(&req->adapter->ccw_device->dev,
				    &req->metadata_sgt,
				    DMA_BIDIRECTIONAL);

	if (scsi_get_prot_op(scsi_cmnd) !=3D SCSI_PROT_NORMAL) {
		io->data_block_length =3D scsi_prot_interval(scsi_cmnd);
		io->ref_tag_value =3D scsi_prot_ref_tag(scsi_cmnd);
	}

	if (zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction))
		goto failed_scsi_cmnd;

	BUILD_BUG_ON(sizeof(struct fcp_cmnd) > FSF_FCP_CMND_SIZE);
	fcp_cmnd =3D &req->qtcb->bottom.io.fcp_cmnd.iu;
	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);

As a result, io->data_block_length, io->ref_tag_value, io->data_direction,
fcp_cmnd (including the FCP LUN, CDB, and transfer length), and
io->prot_data_length are written after the sync and are never copied to the
bounce buffer.

In addition, none of the other QTCB-based FSF functions in
drivers/s390/scsi/zfcp_fsf.c (zfcp_fsf_abort_fcp_cmnd(), zfcp_fsf_send_ct(),
zfcp_fsf_send_els(), zfcp_fsf_exchange_config_data(),
zfcp_fsf_exchange_config_data_sync(), zfcp_fsf_exchange_port_data(),
zfcp_fsf_exchange_port_data_sync(), zfcp_fsf_open_port(),
zfcp_fsf_close_port(), zfcp_fsf_open_wka_port(), zfcp_fsf_close_wka_port(),
zfcp_fsf_close_physical_port(), zfcp_fsf_open_lun(), zfcp_fsf_close_lun(),
and zfcp_fsf_fcp_task_mgmt()) or zfcp_fsf_req_send() call
dma_sync_sgtable_for_device() after filling in req->qtcb.

Should req->qtcb be synced in zfcp_fsf_req_send() right before
zfcp_qdio_send(), or mapped only after req->qtcb is fully populated?

> @@ -2620,20 +2811,22 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
> =20
>  	if ((scsi_get_prot_op(scsi_cmnd) !=3D SCSI_PROT_NORMAL) &&
>  	    scsi_prot_sg_count(scsi_cmnd)) {
> -		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
> -				       scsi_prot_sg_count(scsi_cmnd));
> -		retval =3D zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
> -						 scsi_prot_sglist(scsi_cmnd));
> +		retval =3D zfcp_qdio_sbals_from_sg(qdio,
> +						 &scsi_cmnd->prot_sdb->table,
> +						 req,
> +						 scsi_cmnd->sc_data_direction);
>  		if (retval)
>  			goto failed_scsi_cmnd;
> +		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
> +				       scsi_cmnd->prot_sdb->table.nents);
>  		io->prot_data_length =3D zfcp_qdio_real_bytes(
>  						scsi_prot_sglist(scsi_cmnd));
>  	}
> =20
> -	retval =3D zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
> -					 scsi_sglist(scsi_cmnd));
> +	retval =3D zfcp_qdio_sbals_from_sg(qdio, &scsi_cmnd->sdb.table, req,
> +					 scsi_cmnd->sc_data_direction);
>  	if (unlikely(retval))
> -		goto failed_scsi_cmnd;
> +		goto failed_normal_scsi_map;
> =20
>  	zfcp_qdio_set_sbale_last(adapter->qdio, &req->qdio_req);
>  	if (zfcp_adapter_multi_buffer_active(adapter))
> @@ -2641,12 +2834,25 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
> =20
>  	retval =3D zfcp_fsf_req_send(req);
>  	if (unlikely(retval))
> -		goto failed_scsi_cmnd;
> +		goto failed_req_send;
> +
>  	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
> =20
>  	goto out;
> =20
> +failed_req_send:
> +	zfcp_fsf_req_unmap_sg(req, &scsi_cmnd->sdb.table,
> +			      scsi_cmnd->sc_data_direction);
> +failed_normal_scsi_map:
> +	if ((scsi_get_prot_op(scsi_cmnd) !=3D SCSI_PROT_NORMAL) &&
> +	    scsi_prot_sg_count(scsi_cmnd)) {
> +		zfcp_fsf_req_unmap_sg(req, &scsi_cmnd->prot_sdb->table,
> +				      scsi_cmnd->sc_data_direction);
> +		zfcp_qdio_zero_sbals(qdio->req_q, req->qdio_req.sbal_first,
> +				     req->qdio_req.sbal_number);
> +	}
>  failed_scsi_cmnd:
> +	zfcp_fsf_req_unmap_metadata(req);
>  	zfcp_fsf_req_free(req);
>  	scsi_cmnd->host_scribble =3D NULL;
>  out:

[ ... ]

> diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
> index bac8385e069fa..50db08388514c 100644
> --- a/drivers/s390/scsi/zfcp_qdio.c
> +++ b/drivers/s390/scsi/zfcp_qdio.c
> @@ -233,31 +233,40 @@ zfcp_qdio_sbale_next(struct zfcp_qdio *qdio, struct=
 zfcp_qdio_req *q_req)
>  }
> =20
>  /**
> - * zfcp_qdio_sbals_from_sg - fill SBALs from scatter-gather list
> + * zfcp_qdio_sbals_from_sg - DMA map scatter-gather list and fill SBALs =
from it
>   * @qdio: pointer to struct zfcp_qdio
> - * @q_req: pointer to struct zfcp_qdio_req
> - * @sg: scatter-gather list
> - * Returns: zero or -EINVAL on error
> + * @sgt: pointer to scattergather list table
> + * @req: pointer to zfcp_fsf_req
> + * @dma_dir: DMA direction of I/O
> + * Returns: zero on success, -EINVAL or -EIO otherwise
>   */
> -int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req=
 *q_req,
> -			    struct scatterlist *sg)
> +int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct sg_table *sgt,
> +			    struct zfcp_fsf_req *req,
> +			    enum dma_data_direction dma_dir)
>  {
>  	struct qdio_buffer_element *sbale;
> +	int i;
> +	struct scatterlist *sg_element;
> +
> +	if (zfcp_fsf_req_map_sg(req, sgt, dma_dir))
> +		return -EIO;
> =20
>  	/* set storage-block type for this request */
> -	sbale =3D zfcp_qdio_sbale_req(qdio, q_req);
> -	sbale->sflags |=3D q_req->sbtype;
> +	sbale =3D zfcp_qdio_sbale_req(qdio, &req->qdio_req);
> +	sbale->sflags |=3D req->qdio_req.sbtype;
> =20
> -	for (; sg; sg =3D sg_next(sg)) {
> -		sbale =3D zfcp_qdio_sbale_next(qdio, q_req);
> +	for_each_sgtable_dma_sg(sgt, sg_element, i) {
> +		sbale =3D zfcp_qdio_sbale_next(qdio, &req->qdio_req);
>  		if (!sbale) {
>  			atomic_inc(&qdio->req_q_full);
> -			zfcp_qdio_zero_sbals(qdio->req_q, q_req->sbal_first,
> -					     q_req->sbal_number);
> +			zfcp_qdio_zero_sbals(qdio->req_q,
> +					     req->qdio_req.sbal_first,
> +					     req->qdio_req.sbal_number);
> +			zfcp_fsf_req_unmap_sg(req, sgt, dma_dir);
>  			return -EINVAL;
>  		}
> -		sbale->addr =3D u64_to_dma64(sg_phys(sg));
> -		sbale->length =3D sg->length;
> +		sbale->addr =3D u64_to_dma64(sg_dma_address(sg_element));
> +		sbale->length =3D sg_dma_len(sg_element);
>  	}
>  	return 0;
>  }
> diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
> index 8f7d2ae94441a..9f89f2975f6ff 100644
> --- a/drivers/s390/scsi/zfcp_qdio.h
> +++ b/drivers/s390/scsi/zfcp_qdio.h
> @@ -106,16 +107,19 @@ zfcp_qdio_sbale_curr(struct zfcp_qdio *qdio, struct=
 zfcp_qdio_req *q_req)
>   * @q_req: the qdio request to start
>   * @req_id: The request id
>   * @sbtype: type flags to set for all sbals
> - * @data: First data block
> - * @len: Length of first data block
> + * @has_qtcb: FSF request has a QTCB
> + * @qtcb_len: Length of first data block QTCB, if any
> + * @qtcb_dma_handle: DMA handle of the QTCB, if any
>   *
>   * This is the start of putting the request into the queue, the last
>   * step is passing the request to zfcp_qdio_send. The request queue
>   * lock must be held during the whole process from init to send.
>   */
>  static inline
> -void zfcp_qdio_req_init(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_=
req,
> -			u64 req_id, u8 sbtype, void *data, u32 len)
> +void zfcp_qdio_req_init(struct zfcp_qdio *qdio,
> +			struct zfcp_qdio_req *q_req, u64 req_id,
> +			u8 sbtype, bool has_qtcb, u32 qtcb_len,
> +			dma_addr_t qtcb_dma_handle)
>  {
>  	struct qdio_buffer_element *sbale;
>  	int count =3D min(atomic_read(&qdio->req_q_free),
> @@ -133,33 +137,34 @@ void zfcp_qdio_req_init(struct zfcp_qdio *qdio, str=
uct zfcp_qdio_req *q_req,
>  	sbale->eflags =3D 0;
>  	sbale->sflags =3D SBAL_SFLAGS0_COMMAND | sbtype;
> =20
> -	if (unlikely(!data))
> +	if (unlikely(!has_qtcb))
>  		return;
>  	sbale++;
> -	sbale->addr =3D virt_to_dma64(data);
> -	sbale->length =3D len;
> +	sbale->addr =3D u64_to_dma64(qtcb_dma_handle);
> +	sbale->length =3D qtcb_len;
>  }

[Severity: High]
If a payload DMA mapping fails after zfcp_fsf_req_create() has already
initialized the SBAL in qdio->req_q, doesn't this leave a stale, unmapped
QTCB DMA address in element[1] of qdio->req_q[qdio->req_q_idx]?

In zfcp_fsf_req_create(), zfcp_qdio_req_init() writes req_id and sflags to
element[0] and writes qtcb_dma_handle and qtcb_len to element[1] of the SBAL
at qdio->req_q_idx.

If zfcp_fsf_req_map_sg() then fails in zfcp_qdio_sbals_from_sg() or
zfcp_fsf_setup_ct_els_unchained(), it returns -EIO without zeroing the SBAL:
- In zfcp_fsf_fcp_cmnd() (drivers/s390/scsi/zfcp_fsf.c), if mapping
  scsi_cmnd->sdb.table fails on a command without DIF/DIX protection data (=
or
  if mapping scsi_cmnd->prot_sdb->table fails, or zfcp_fsf_set_data_dir()
  fails), failed_normal_scsi_map and failed_scsi_cmnd unmap and free
  req->qtcb without calling zfcp_qdio_zero_sbals().
- In zfcp_fsf_setup_ct_els_sbals() (drivers/s390/scsi/zfcp_fsf.c), if
  mapping sgt_req fails or zfcp_fsf_setup_ct_els_unchained() fails, it
  returns -EIO without calling zfcp_qdio_zero_sbals().

Because qdio->req_q_idx is only advanced in zfcp_qdio_send(), the next
request reuses the same SBAL slot. If that next request is
zfcp_fsf_status_read(), zfcp_qdio_req_init() is called with has_qtcb =3D fa=
lse,
which returns early while leaving sbale_curr =3D 1 and leaving the freed QT=
CB's
DMA address and length in element[1], and zfcp_qdio_fill_next() then writes
sr_buf into element[2].

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index ea4b968352f4d..091be339d309c 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -184,6 +184,20 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cm=
nd *scpnt)
>  		zfcp_dbf_scsi_abort("abrt_or", scpnt, NULL);
>  		return FAILED; /* completion could be in progress */
>  	}
> +
> +	/*
> +	 * Unmap SCSI payload DMA mappings before clearing req->data.
> +	 * Once req->data is NULL the hardware completion handler cannot
> +	 * reach the sg_tables, causing a permanent IOVA leak.
> +	 */
> +	if ((scsi_get_prot_op(scpnt) !=3D SCSI_PROT_NORMAL) &&
> +	    scsi_prot_sg_count(scpnt))
> +		zfcp_fsf_req_unmap_sg(old_req, &scpnt->prot_sdb->table,
> +				      scpnt->sc_data_direction);
> +
> +	zfcp_fsf_req_unmap_sg(old_req, &scpnt->sdb.table,
> +			      scpnt->sc_data_direction);
> +
>  	old_req->data =3D NULL;
> =20
>  	/* don't access old fsf_req after releasing the abort_lock */

[Severity: Critical]
Is it safe to unmap scpnt->prot_sdb->table and scpnt->sdb.table in
zfcp_scsi_eh_abort_handler() before the FCP adapter has actually aborted
old_req?

Here in drivers/s390/scsi/zfcp_scsi.c, zfcp_scsi_eh_abort_handler() unmaps
the SCSI command's DMA buffers and clears old_req->data before calling
zfcp_fsf_abort_fcp_cmnd(scpnt) and waiting on abrt_req->completion:

	zfcp_fsf_req_unmap_sg(old_req, &scpnt->sdb.table,
			      scpnt->sc_data_direction);

	old_req->data =3D NULL;

	/* don't access old fsf_req after releasing the abort_lock */
	write_unlock_irqrestore(&adapter->abort_lock, flags);

	while (retry--) {
		abrt_req =3D zfcp_fsf_abort_fcp_cmnd(scpnt);

Until the adapter processes the abort command (or if zfcp_fsf_abort_fcp_cmn=
d()
cannot be sent, fc_block_scsi_eh() returns early, or the abort fails and
returns FAILED), old_req is still active on the FCP channel and may continue
DMA transfers into or out of the unmapped buffers and released SWIOTLB boun=
ce
pages.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021083351.1626=
409-1-nikh1092@linux.ibm.com?part=3D2
