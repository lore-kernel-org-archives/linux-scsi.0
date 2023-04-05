Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70775C761AF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Apr 2023 18:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbjDES0q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Apr 2023 14:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDES0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2023 14:26:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7A94226
        for <linux-scsi@vger.kernel.org>; Wed,  5 Apr 2023 11:26:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso38164546pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2023 11:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680719202;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=40L1KpnbNaApfY6Jqegb/JgWk30KiDpmnuAJ36ODgMc=;
        b=X4ZvWGkD0WKJyXoOzxHZtn4O3VcrPjAam71maWBunTX5/ybnKIG8rxx6MZUgglLMUq
         vDxIZDd3Gx13g1dfbl7BrHzKNci09SQ66uOnCSuzKGPr5NNtUvO37xMDMAinGA6g1sQ7
         ZWPXTumoAbVccGDATi26uXH2M94gbdcETow2dy8+llMBW/d6xbiN4fvb641V6IAefhKw
         XNn5wJcBHpoYBR967a0FDTrgwZa4vNNOJ0jc3KpOfyGnq1f175QEJgAahhIy1EI+qCc3
         L7+1jhpPgixLQx9bo94bWhr7uuw5jHw2VBjK+NCOdtE94yOvnQQIUZHZdLTZOaPYAnhZ
         kqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680719202;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40L1KpnbNaApfY6Jqegb/JgWk30KiDpmnuAJ36ODgMc=;
        b=3VSu+6Gpg+dwMvS7sa4I6FpPT6LFWoehCqV519npRi08NB9/rUFdIMdC/ytRiq9aBS
         bUqgCha7Q5KAw6Yu2BbhAurBdctrBXXB8hYicJVXvhdzsWD4BNrYZ2ad3nwdZ5nMZMmu
         y53j64qyaocEG622FTD5vQaPzu55VtwJHu4vKgmQiBhE/HFRHvaUX2qFOWXEUyayq7EC
         YwGCpJ7YHC0bRSc6R8A+P3tAMewqcQ0rlL0voFYr5xNMfGhVWvyr4TApdgDbJhTKGxng
         eTArFv4/WRC2aIX3bByZKqZugd+NKKyAfcRODvT+OvBE1KuAdEgmANk9fyYO+B9TWGGp
         5V0g==
X-Gm-Message-State: AAQBX9ccbA6f/8n7ijLHF1iA//H34hG1D3m6DLkrgvy8G1hHdoanmBQN
        5GyW+j+9VGSNmvlMk3kvPv46Gw==
X-Google-Smtp-Source: AKy350bbj5GuqBtzvQ6G3HkhXB3/jYYiubbbGojcGeVN4YdUw5kM1Rmy2aquWmt+oDofrV6cSOUwaw==
X-Received: by 2002:a05:6a20:1207:b0:d9:957f:612a with SMTP id v7-20020a056a20120700b000d9957f612amr116198pzf.29.1680719202318;
        Wed, 05 Apr 2023 11:26:42 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:13:873a:a865:8e8:d6b3])
        by smtp.gmail.com with ESMTPSA id 197-20020a6307ce000000b0051322ab5ccdsm9668423pgh.28.2023.04.05.11.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:26:41 -0700 (PDT)
Date:   Wed, 5 Apr 2023 11:26:36 -0700
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Niklas Cassel <nks@flawful.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v5 18/19] ata: libata: set read/write commands CDL index
Message-ID: <ZC29XNMS9CnQZn74@google.com>
References: <20230404182428.715140-1-nks@flawful.org>
 <20230404182428.715140-19-nks@flawful.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404182428.715140-19-nks@flawful.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 04, 2023 at 08:24:23PM +0200, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> For devices supporting the command duration limits feature, translate
> the dld field of read and write operation to set the command duration
> limit index field of the command task file when the duration limit
> feature is enabled.
> 
> The function ata_set_tf_cdl() is introduced to do this. For unqueued
> (non NCQ) read and write operations, this function sets the command
> duration limit index set as the lower 2 bits of the feature field.
> For queued NCQ read/write commands, the index is set as the lower
> 2 bits of the auxiliary field.

CDL index is lower 3 bits, not 2 bits.

> 
> The flag ATA_QCFLAG_HAS_CDL is introduced to indicate that a command
> taskfile has a non zero cdl field.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  drivers/ata/libata-core.c | 32 +++++++++++++++++++++++++++++---
>  drivers/ata/libata-scsi.c | 16 +++++++++++++++-
>  drivers/ata/libata.h      |  2 +-
>  include/linux/libata.h    |  1 +
>  4 files changed, 46 insertions(+), 5 deletions(-)
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

Thanks,
Igor
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 62e100fa90e2..c68e7b684a87 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -665,12 +665,29 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
>  	return block;
>  }
>  
> +/*
> + * Set a taskfile command duration limit index.
> + */
> +static inline void ata_set_tf_cdl(struct ata_queued_cmd *qc, int cdl)
> +{
> +	struct ata_taskfile *tf = &qc->tf;
> +
> +	if (tf->protocol == ATA_PROT_NCQ)
> +		tf->auxiliary |= cdl;
> +	else
> +		tf->feature |= cdl;
> +
> +	/* Mark this command as having a CDL */
> +	qc->flags |= ATA_QCFLAG_HAS_CDL;
> +}
> +
>  /**
>   *	ata_build_rw_tf - Build ATA taskfile for given read/write request
>   *	@qc: Metadata associated with the taskfile to build
>   *	@block: Block address
>   *	@n_block: Number of blocks
>   *	@tf_flags: RW/FUA etc...
> + *	@cdl: Command duration limit index
>   *	@class: IO priority class
>   *
>   *	LOCKING:
> @@ -685,7 +702,7 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
>   *	-EINVAL if the request is invalid.
>   */
>  int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
> -		    unsigned int tf_flags, int class)
> +		    unsigned int tf_flags, int cdl, int class)
>  {
>  	struct ata_taskfile *tf = &qc->tf;
>  	struct ata_device *dev = qc->dev;
> @@ -724,11 +741,20 @@ int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
>  		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED &&
>  		    class == IOPRIO_CLASS_RT)
>  			tf->hob_nsect |= ATA_PRIO_HIGH << ATA_SHIFT_PRIO;
> +
> +		if ((dev->flags & ATA_DFLAG_CDL_ENABLED) && cdl)
> +			ata_set_tf_cdl(qc, cdl);
> +
>  	} else if (dev->flags & ATA_DFLAG_LBA) {
>  		tf->flags |= ATA_TFLAG_LBA;
>  
> -		/* We need LBA48 for FUA writes */
> -		if (!(tf->flags & ATA_TFLAG_FUA) && lba_28_ok(block, n_block)) {
> +		if ((dev->flags & ATA_DFLAG_CDL_ENABLED) && cdl)
> +			ata_set_tf_cdl(qc, cdl);
> +
> +		/* Both FUA writes and a CDL index require 48-bit commands */
> +		if (!(tf->flags & ATA_TFLAG_FUA) &&
> +		    !(qc->flags & ATA_QCFLAG_HAS_CDL) &&
> +		    lba_28_ok(block, n_block)) {
>  			/* use LBA28 */
>  			tf->device |= (block >> 24) & 0xf;
>  		} else if (lba_48_ok(block, n_block)) {
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 8dde1cede5ca..05bde27947a2 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1380,6 +1380,18 @@ static inline void scsi_16_lba_len(const u8 *cdb, u64 *plba, u32 *plen)
>  	*plen = get_unaligned_be32(&cdb[10]);
>  }
>  
> +/**
> + *	scsi_dld - Get duration limit descriptor index
> + *	@cdb: SCSI command to translate
> + *
> + *	Returns the dld bits indicating the index of a command duration limit
> + *	descriptor.
> + */
> +static inline int scsi_dld(const u8 *cdb)
> +{
> +	return ((cdb[1] & 0x01) << 2) | ((cdb[14] >> 6) & 0x03);
> +}
> +
>  /**
>   *	ata_scsi_verify_xlat - Translate SCSI VERIFY command into an ATA one
>   *	@qc: Storage for translated ATA taskfile
> @@ -1548,6 +1560,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
>  	struct request *rq = scsi_cmd_to_rq(scmd);
>  	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
>  	unsigned int tf_flags = 0;
> +	int dld = 0;
>  	u64 block;
>  	u32 n_block;
>  	int rc;
> @@ -1598,6 +1611,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
>  			goto invalid_fld;
>  		}
>  		scsi_16_lba_len(cdb, &block, &n_block);
> +		dld = scsi_dld(cdb);
>  		if (cdb[1] & (1 << 3))
>  			tf_flags |= ATA_TFLAG_FUA;
>  		if (!ata_check_nblocks(scmd, n_block))
> @@ -1622,7 +1636,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
>  	qc->flags |= ATA_QCFLAG_IO;
>  	qc->nbytes = n_block * scmd->device->sector_size;
>  
> -	rc = ata_build_rw_tf(qc, block, n_block, tf_flags, class);
> +	rc = ata_build_rw_tf(qc, block, n_block, tf_flags, dld, class);
>  	if (likely(rc == 0))
>  		return 0;
>  
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 2cd6124a01e8..73dd2ebc277c 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -45,7 +45,7 @@ static inline void ata_force_cbl(struct ata_port *ap) { }
>  extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
>  extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
>  extern int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
> -			   unsigned int tf_flags, int class);
> +			   unsigned int tf_flags, int dld, int class);
>  extern u64 ata_tf_read_block(const struct ata_taskfile *tf,
>  			     struct ata_device *dev);
>  extern unsigned ata_exec_internal(struct ata_device *dev,
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index d7fe735e6322..ab8b62036c12 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -209,6 +209,7 @@ enum {
>  	ATA_QCFLAG_CLEAR_EXCL	= (1 << 5), /* clear excl_link on completion */
>  	ATA_QCFLAG_QUIET	= (1 << 6), /* don't report device error */
>  	ATA_QCFLAG_RETRY	= (1 << 7), /* retry after failure */
> +	ATA_QCFLAG_HAS_CDL	= (1 << 8), /* qc has CDL a descriptor set */
>  
>  	ATA_QCFLAG_EH		= (1 << 16), /* cmd aborted and owned by EH */
>  	ATA_QCFLAG_SENSE_VALID	= (1 << 17), /* sense data valid */
> -- 
> 2.39.2
> 
