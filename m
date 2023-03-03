Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF2FC64EC4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 06:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCCGoq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 01:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCCGop (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 01:44:45 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B222D59CA
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 22:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677825882; x=1709361882;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F1uHd5tKUb9JRP98rqBvKZtR7nBpmSuMxdiTXPUg4uk=;
  b=cZzf6/5nq7touzW509b3w0BmiGzbo0NKuT9VN45yxdTvkQO+pcF0wndW
   kG8CF9IRE1etMA5FIHCBzsiS3sZxgTlDH4HMa5ddBPzOoDYUZYjmgTVj4
   Pq/vqNkqLRIIIX4fs37risqsGEk28+IGY9CazSv1m7iz2R55FVwWK/P7l
   6lqnlz1yu44JBlQB1MmzfweQ96LD5kPMIOZ6trc/xgseA4KkceeZLCgLt
   f8ois+3G4BKC2qlGYTinMtOuD7PHsMIAzVSmptgiuI8t0MRa8kw9cfNie
   X6pZOJ+wZ3WlHhcbiCFVr7OSG8i5WPbsra/3NhCQGOkZA0QRmu5qfEp6p
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,229,1673884800"; 
   d="scan'208";a="224487236"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2023 14:44:41 +0800
IronPort-SDR: yrltUjUPvbaP+NZqGqjs4dUUJ8amunHH6TrVFlqEaofwzy7Ha7Y6y4VwD6EzSaQPqHqn6aGmEd
 MZqzFGCTuczsSkAHFn/Sg/te69LzOlvzTlg3yV3wFCnqV632g0xC7/Rp7NcZu56cbOo4kL2WOp
 xUhdvIvBJWqjlZzXCCn0x0OoSP/t1ClsrKKRJsc7brcFt81J2kZD/yXu/c18jbfNzsHX0fvrz5
 NW9daWbCpBM9h2M8AQKPbIIcw4kP/DWoAzXMpjhMrESIgq4qua8C63SmoT1ZTm9NnImIPKkXb+
 ul4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2023 22:01:29 -0800
IronPort-SDR: 7+ObnUQsGxOvxtMNFUHTn49jMyge1tcdQ8chZ9YNHjGhM4iRpkK3RK9wuiA/aLKQssnxLyuLZx
 gqf5Vdrkyyd1Q6Wofo5CE/PtyussxmF/GuW1SFGNprx/CKxp1G/cIA8P6RQNgMJyHTFm+0b35Q
 Kv/TruetoSXH1huB856haVHpKeVrMcv2EvK9VHi71o02i1enr4mZqAfqmmwhFuAzr5k46I5RA7
 FdVZioEpnWl6B6TATksr8XpjiYaWp9tBJcstgUEhJk170cgXG+Xu3eHbLhlnOKjzB5bXhG9QKf
 68E=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2023 22:44:42 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PSdkK3l4yz1RvTp
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 22:44:41 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677825880; x=1680417881; bh=F1uHd5tKUb9JRP98rqBvKZtR7nBpmSuMxdi
        TXPUg4uk=; b=g8c3T+UtWJS2pDMXaIHTsLBecJpGrFZ2NsYsKBsjZCIklNMHGlZ
        rZjyDP/PbdZqJq2GJACPB3FgvxAm1rPW43EtTQBXpF9J14ib4NfidKaOxbTFcyee
        1WqEJpoNXKKp89PretTGvWfY1tUest49rohsB9jRlrlCaegwFX9sM0JCdNPL8B0v
        9S3TFYGlzJ0l3krOb77nNEBv7dQsl3FtAtLLSHAAtLrf6D1uYekxihaae+ohOGoh
        7sH6foV4yWFGM5fX0P1eSGLqt9y+NaKksbwkiB5YI4ZwUqFozc+LsqTsEg0UFPFq
        2Ls7gbvXHGfG/gDxzI2Hv80ICZpFKKj3W6A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mu9W67LoEF3P for <linux-scsi@vger.kernel.org>;
        Thu,  2 Mar 2023 22:44:40 -0800 (PST)
Received: from [10.225.163.47] (unknown [10.225.163.47])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PSdkH2vxrz1RvLy;
        Thu,  2 Mar 2023 22:44:39 -0800 (PST)
Message-ID: <1120bc4a-0c3a-47ab-8f33-cc3e048c10c2@opensource.wdc.com>
Date:   Fri, 3 Mar 2023 15:44:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
 <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 10:44, Shin'ichiro Kawasaki wrote:
> When host-managed SMR disks have different physical sector size and
> logical sector size, writes to conventional zones should be aligned to
> the logical sector size. On the other hand, ZBC/ZAC requires that writes
> to sequential write required zones shall be aligned to the physical
> sector size. Otherwise, the disks return the unaligned write command
> error. However, this error is common with other failure reasons. The
> error is also reported when the write start sector is not at the write
> pointer, or the write end sector is not in the same zone.
> 
> To clarify the write failure cause is the physical sector alignment,
> confirm before issuing write commands that the writes to sequential
> write required zones are aligned to the physical sector size. If not,
> print a relevant error message. This makes failure analysis easier, and
> also avoids error handling in low level drivers.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/sd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 47dafe6b8a66..6d115b2fa99a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1123,6 +1123,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>  	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
>  	sector_t threshold;
>  	unsigned int nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
> +	unsigned int pb_sectors = sdkp->physical_block_size >> SECTOR_SHIFT;
>  	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
>  	bool write = rq_data_dir(rq) == WRITE;
>  	unsigned char protect, fua;
> @@ -1145,6 +1146,15 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>  		goto fail;
>  	}
>  
> +	if (sdkp->device->type == TYPE_ZBC && blk_rq_zone_is_seq(rq) &&
> +	    (req_op(rq) == REQ_OP_WRITE || req_op(rq) == REQ_OP_ZONE_APPEND) &&
> +	    (!IS_ALIGNED(blk_rq_pos(rq), pb_sectors) ||
> +	     !IS_ALIGNED(blk_rq_sectors(rq), pb_sectors))) {
> +		scmd_printk(KERN_ERR, cmd,
> +			    "Sequential write request not aligned to the physical block size\n");
> +		goto fail;
> +	}

A little helper for this complicated check would be better, and that will avoid
the built bot warning you got when CONFIG_BLK_DEV_ZONED is not set.
Something like this:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a38c71511bc9..71e4e51898d8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1146,6 +1146,9 @@ static blk_status_t sd_setup_read_write_cmnd(struct
scsi_cmnd *cmd)
 		goto fail;
 	}

+	if (sdkp->device->type == TYPE_ZBC && !sd_zbc_check_write(cmd))
+		goto fail;
+
 	if ((blk_rq_pos(rq) & mask) || (blk_rq_sectors(rq) & mask)) {
 		scmd_printk(KERN_ERR, cmd, "request not aligned to the logical block size\n");
 		goto fail;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5eea762f84d1..f19711b92f25 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -254,6 +254,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 				        unsigned int nr_blocks);

+bool sd_zbc_check_write(struct scsi_cmnd *cmd);
+
 #else /* CONFIG_BLK_DEV_ZONED */

 static inline void sd_zbc_free_zone_info(struct scsi_disk *sdkp) {}
@@ -290,6 +292,11 @@ static inline blk_status_t
sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,

 #define sd_zbc_report_zones NULL

+static inline bool sd_zbc_check_write(struct scsi_cmnd *cmd)
+{
+	return true;
+}
+
 #endif /* CONFIG_BLK_DEV_ZONED */

 void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr);
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6b3a02d4406c..3025cb35f30c 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -983,3 +983,33 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8
buf[SD_BUF_SIZE])

 	return ret;
 }
+
+/**
+ * sd_zbc_check_write - Check if a write to a sequential zone is aligned to
+ *			the physical block size of the disk.
+ * @cmd: The command to check.
+ *
+ * Return false for write and zone append commands that are not aligned to
+ * the disk physical block size and true otherwise.
+ */
+bool sd_zbc_check_write(struct scsi_cmnd *cmd)
+{
+	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
+	unsigned int pb_sectors = sdkp->physical_block_size >> SECTOR_SHIFT;
+
+	if (!blk_rq_zone_is_seq(rq))
+		return true;
+
+	if (req_op(rq) != REQ_OP_WRITE && req_op(rq) != REQ_OP_ZONE_APPEND)
+		return true;
+
+	if (!IS_ALIGNED(blk_rq_pos(rq), pb_sectors) ||
+	     !IS_ALIGNED(blk_rq_sectors(rq), pb_sectors)) {
+		scmd_printk(KERN_ERR, cmd,
+			"Write request not aligned to the physical block size\n");
+		return false;
+	}
+
+	return true;
+}
-- 
2.39.2




> +
>  	if ((blk_rq_pos(rq) & mask) || (blk_rq_sectors(rq) & mask)) {
>  		scmd_printk(KERN_ERR, cmd, "request not aligned to the logical block size\n");
>  		goto fail;

-- 
Damien Le Moal
Western Digital Research

