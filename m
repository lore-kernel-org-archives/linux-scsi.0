Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4CF262FD8
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 09:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758877351; cv=none; b=Rv8GbGrD0hAcyM5bhWIEWyPUCpsIpjtMc55Z7aQtn1OatM2b3bWYh3aL+1VkbPwOnlYTudLejJTwQtUMJHw15aqTE1gXp7u4hfK+OrTJTxIcVdXYeCS+9pxHbJmgcQsvPzVXXOtYYyp96plj7WMcYTXPThqpcVIX9BDKMd7sXkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758877351; c=relaxed/simple;
	bh=GxtMTtlZmwg3480C/zH8WQFEBEMqh5xME9dklmIzEpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WmGFxdLSCk+tkHPguuGpGPn4y9lSw2DgSFKdWVNe0JqI+D0lIX9qCgoERlJNMd4WwcGpmemtIS/ZSniVltwdX2LK43woE64WCiYMZGnaEpdOepI42BcLO02qHF86k4IGTfM6wk6e84hi+V4cR/oGeZMcND6hk9lUmptme8REIkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=jS6lpnE/; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="jS6lpnE/"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id 22Rbv7TvKaPqL24K3vSypX; Fri, 26 Sep 2025 09:00:59 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 24K1vk81YwoI224K2vv5Us; Fri, 26 Sep 2025 09:00:58 +0000
X-Authority-Analysis: v=2.4 cv=PZX/hjhd c=1 sm=1 tr=0 ts=68d6564a
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=IWwJ09ifmDHnqRraTvDMjw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VWGkDn4_SsZSIYDccDIA:9 a=QEXdDO2ut3YA:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Xf/TnhuotQyAVfIYtjawNDt8QOmaQD9IeOcCllJouSE=; b=jS6lpnE/jlJPfkwp3lH3beXZEu
	XTFcdRa+7mJxl2qTVgGgEDCFPQcRag7Exyg+mlLILOPPwjG0sKwpSZJa7Y+b8yRQ0SZIFBzFmUCKF
	cLq0CYRoP5CYg4iP3JfNZgxoIvDBHiMafneqetisP5r9/CVlT93J2fCVMRm/iJgcmLA6o82QZUCmT
	zdr5I7KtEy/xgaxhaXMqYcZCBH3nVpcqlEbjp6rGHfEyidUdQZfJk+Jhgai9/fTW2ccQPnGvuuVhq
	ngcCVuXhDF9Ur/X1ouUWfngNrqWjnIflU3PmaRBh1Dv161myMJOdQcJL/nGT+qg6XfuPJBeOfy2eD
	LdxCTbYQ==;
Received: from wifi-guest-88-012.paris.inria.fr ([128.93.88.12]:39980)
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1v24K0-00000001OSk-2gjL;
	Fri, 26 Sep 2025 04:00:57 -0500
Message-ID: <0af9cbc4-a410-44f3-affc-a09e5c41ccd4@embeddedor.com>
Date: Fri, 26 Sep 2025 11:00:35 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 11/11] scsi: qla2xxx: Fix 2 memcpy field-spanning
 write issue
To: John Meneghini <jmeneghi@redhat.com>, hare@suse.de, kbusch@kernel.org,
 martin.petersen@oracle.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com,
 gustavoars@kernel.org, hch@lst.de, james.smart@broadcom.com,
 kees@kernel.org, linux-hardening@vger.kernel.org, njavali@marvell.com,
 sagi@grimberg.me
References: <20250926000200.837025-1-jmeneghi@redhat.com>
 <20250926000200.837025-12-jmeneghi@redhat.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20250926000200.837025-12-jmeneghi@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 128.93.88.12
X-Source-L: No
X-Exim-ID: 1v24K0-00000001OSk-2gjL
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: wifi-guest-88-012.paris.inria.fr [128.93.88.12]:39980
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 11
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLq4EE9jCnTt4VPtklbVe5W1JIkzh/Z9l9i8OQNgSr4LNl/6jq1L2v/vh2lJibUqxv5OP31hcAABLuFMv/dfZFUpnPJNlZiSMl1eaZCUL9z5CZQYpzGE
 DPCh+fId0LTz2K/acvp7byXQGuCOgNeYK88EPbDhGu9H1SgIe4FrAkBfyQ9V3LM8x2Q9R2bfvwOSiY1Lc16F/dbQK8K2Trjez0wUkcOOgRanuufNJSPopR26

Hi,

Shouldn't this patch be removed from this series, since it's going to be
reverted anyways?

Thanks
-Gustavo

On 9/26/25 02:02, John Meneghini wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> 
> purex_item.iocb is defined as a 64-element u8 array, but 64 is the
> minimum size and it can be allocated larger. This makes it a standard
> empty flex array.
> 
> This was motivated by field-spanning write warnings during FPIN testing.
> 
>    >  kernel: memcpy: detected field-spanning write (size 60) of single
>    >  field "((uint8_t *)fpin_pkt + buffer_copy_offset)"
>    >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)
> 
> I removed the outer wrapper from the iocb flex array, so that it can be
> linked to `purex_item.size` with `__counted_by`.
> 
> These changes remove the default minimum 64-byte allocation, requiring
> further changes.
> 
>    In `struct scsi_qla_host` the embedded `default_item` is now followed
>    by `__default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE]` to reserve space
>    that will be used as `default_item.iocb`. This is wrapped using the
>    `TRAILING_OVERLAP()` macro helper, which effectively creates a union
>    between flexible-array member `default_item.iocb` and
>    `__default_item_iocb`.
> 
>    Since `struct pure_item` now contains a flexible-array member, the
>    helper must be placed at the end of `struct scsi_qla_host` to prevent
>    a `-Wflex-array-member-not-at-end` warning.
> 
>    `qla24xx_alloc_purex_item()` is adjusted to no longer expect the
>    default minimum size to be part of `sizeof(struct purex_item)`,
>    the entire flexible array size is added to the structure size for
>    allocation.
> 
> This also slightly changes the layout of the purex_item struct, as
> 2-bytes of padding are added between `size` and `iocb`. The resulting
> size is the same, but iocb is shifted 2-bytes (the original `purex_item`
> structure was padded at the end, after the 64-byte defined array size).
> I don't think this is a problem.
> 
> In qla_os.c:qla24xx_process_purex_rdp()
> 
> To avoid a null pointer dereference the vha->default_item should be set
> to 0 last if the item pointer passed to the function matches.  Also use
> a local variable to avoid multiple de-referencing of the item.
> 
> Tested-by: Bryan Gurney <bgurney@redhat.com>
> Co-developed-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  | 10 ++++++----
>   drivers/scsi/qla2xxx/qla_isr.c  | 17 ++++++++---------
>   drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
>   drivers/scsi/qla2xxx/qla_os.c   |  9 ++++++---
>   4 files changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index cb95b7b12051..604e66bead1e 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4890,9 +4890,7 @@ struct purex_item {
>   			     struct purex_item *pkt);
>   	atomic_t in_use;
>   	uint16_t size;
> -	struct {
> -		uint8_t iocb[64];
> -	} iocb;
> +	uint8_t iocb[] __counted_by(size);
>   };
>   
>   #include "qla_edif.h"
> @@ -5101,7 +5099,6 @@ typedef struct scsi_qla_host {
>   		struct list_head head;
>   		spinlock_t lock;
>   	} purex_list;
> -	struct purex_item default_item;
>   
>   	struct name_list_extended gnl;
>   	/* Count of active session/fcport */
> @@ -5130,6 +5127,11 @@ typedef struct scsi_qla_host {
>   #define DPORT_DIAG_IN_PROGRESS                 BIT_0
>   #define DPORT_DIAG_CHIP_RESET_IN_PROGRESS      BIT_1
>   	uint16_t dport_status;
> +
> +	/* Must be last --ends in a flexible-array member. */
> +	TRAILING_OVERLAP(struct purex_item, default_item, iocb,
> +		uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
> +	);
>   } scsi_qla_host_t;
>   
>   struct qla27xx_image_status {
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 8ff8781dae47..ccb044693dcb 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1078,17 +1078,17 @@ static struct purex_item *
>   qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
>   {
>   	struct purex_item *item = NULL;
> -	uint8_t item_hdr_size = sizeof(*item);
>   
>   	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
> -		item = kzalloc(item_hdr_size +
> -		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
> +		item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
>   	} else {
>   		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
>   			item = &vha->default_item;
>   			goto initialize_purex_header;
>   		} else {
> -			item = kzalloc(item_hdr_size, GFP_ATOMIC);
> +			item = kzalloc(
> +				struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
> +				GFP_ATOMIC);
>   		}
>   	}
>   	if (!item) {
> @@ -1128,17 +1128,16 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
>    * @vha: SCSI driver HA context
>    * @pkt: ELS packet
>    */
> -static struct purex_item
> -*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
> +static struct purex_item *
> +qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
>   {
>   	struct purex_item *item;
>   
> -	item = qla24xx_alloc_purex_item(vha,
> -					QLA_DEFAULT_PAYLOAD_SIZE);
> +	item = qla24xx_alloc_purex_item(vha, QLA_DEFAULT_PAYLOAD_SIZE);
>   	if (!item)
>   		return item;
>   
> -	memcpy(&item->iocb, pkt, sizeof(item->iocb));
> +	memcpy(&item->iocb, pkt, QLA_DEFAULT_PAYLOAD_SIZE);
>   	return item;
>   }
>   
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 8ee2e337c9e1..92488890bc04 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -1308,7 +1308,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
>   
>   	ql_dbg(ql_dbg_unsol, vha, 0x2121,
>   	       "PURLS OP[%01x] size %d xchg addr 0x%x portid %06x\n",
> -	       item->iocb.iocb[3], item->size, uctx->exchange_address,
> +	       item->iocb[3], item->size, uctx->exchange_address,
>   	       fcport->d_id.b24);
>   	/* +48    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
>   	 * ----- -----------------------------------------------
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d4b484c0fd9d..32437bae1a30 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -6459,9 +6459,12 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
>   void
>   qla24xx_free_purex_item(struct purex_item *item)
>   {
> -	if (item == &item->vha->default_item)
> -		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
> -	else
> +	scsi_qla_host_t *base_vha = item->vha;
> +
> +	if (item == &base_vha->default_item) {
> +		memset(&base_vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
> +		memset(&base_vha->default_item, 0, sizeof(struct purex_item));
> +	} else
>   		kfree(item);
>   }
>   

