Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD28C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 03:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbiCPDW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238754AbiCPDWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 23:22:55 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED445C856
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 20:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647400902; x=1678936902;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0tMGg/mjHRA0kNh/9cBNcvbCDCHUiiq3kSLRADxKok0=;
  b=NZHOJwxVJHNhuh95isxtfRfEOwCV+CjLl56x5vqJEoW2rMz1lbMwSaZj
   MffTAVqCs6M4W0smn1tpmsnJrBraAvn5TQ44KGAf9NUe6rsCDlqc4Zx+n
   46+ZjXKmhgvFxsGBYluc3AAYBZu7NcVj93dq5XQ5TKMMpAn+8IEuxiHf5
   ErESlW3wp0AkO0phZ43FtVzxfdZ6TNIL/QjQ6lbULc3L46Vl/27Jh146n
   jtlRtsY4DM15cLLmgIbGQGScAmi211U1HrIZb2vZ+7X4LuJ5kbmbXyXzs
   zuQS6YMQL/knpmT13fAsjoVcYAoj2VxF7voWYZAJMjLQkxmUt/5/bRqVc
   A==;
X-IronPort-AV: E=Sophos;i="5.90,185,1643644800"; 
   d="scan'208";a="195467713"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2022 11:21:40 +0800
IronPort-SDR: S/5fBCOLjm2OCJP5AVOr6XgFiBnC5lAwynp/FArmKrMpDVcYf06qRWABZUKtJzG8qe8mgSTvvb
 o8sF5iyuBmHBbzmG5uWJhe4K7oScJQcyXGcCx4sukRMUYqy7e9eR7cQmrrcS1LisDcoQx52AId
 vEQVpbFEkC3p4iSBwFaP1EJqSfIiV/LolPNiRfE807ziU/UGOS6IFCyqF8CNSxhN2vdxRRCgcv
 ZFAYVt4Ijflz2Jdu+/vlkn/t7kDg8LjwJ5Dn/Nr7MzFZyB/bOeRNkFgUj7EeF0/KjW+I9fYVA/
 ngKqEkupi2LMEXXf8AqYA4oC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 19:52:47 -0700
IronPort-SDR: ExKIPsQAav6J71kJbXFYlNWtGzzkx+RcHtsQ8iDZMUQat8SBFIcpNrzZlPv1X1jrXErcoiAAVv
 QmAcQH160QYm8otX0XGVh8HvFcXnnXUI+XTJ+KYQdagyNeAI0yoD1PHwDDBa16hPqIlYZ7ArT/
 r4nlkrT2mim2TAUx7daR4sZX8XQBKE6b8kJdL9WgizWm32LyuLWqkqGSfCUe8AqwUxRa+cFvsj
 2Dvh5NWtcGnWDasKGSj18SkuRX08E95IZq2LAFdH3ozhlIGkrCiwPHHKCToJ68o9zVXW19dj/z
 bdw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 20:21:40 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KJFtX0ShLz1SVp5
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 20:21:40 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1647400899; x=1649992900; bh=0tMGg/mjHRA0kNh/9cBNcvbCDCHUiiq3kSL
        RADxKok0=; b=kcmRmBF///NauREsS7z15RCUw/ujRh+Uxq2qhXPSge3oP9gyMWv
        ZeFIi5eva7hzNg/HnkouVgm8KbvEMbUONguydZ6tVeecpl5qTuHj7GatkT7bYmEK
        p8aYKDOSz68qFrgaHlA577sdOG7iNcFBtR5L3TrZbCScO+nj6BWFLJBmimomTmlj
        UNu2CHTn2nc/iIWV5S/0UAArZE4miI9gcLZWvg/psyCx2ddsvk5OjKorvpuQn3UF
        grB86yScjJhiSyql2/GzVvGWkuvOzLQlH3ErX1DM10xWgdyDeN7P9xo0ozipfYCN
        2gY3sf6CiPbZzFia/diJcm+Qa/De49851lQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id A0e0TSDKZYLp for <linux-scsi@vger.kernel.org>;
        Tue, 15 Mar 2022 20:21:39 -0700 (PDT)
Received: from [10.225.163.101] (unknown [10.225.163.101])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KJFtT0d3pz1Rvlx;
        Tue, 15 Mar 2022 20:21:36 -0700 (PDT)
Message-ID: <99541f2d-2aea-6bd7-e3b6-21dbc355875d@opensource.wdc.com>
Date:   Wed, 16 Mar 2022 12:21:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH RFC 2/2] libata: Use scsi cmnd budget token for qc tag for
 SAS host
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, bvanassche@acm.org,
        ming.lei@redhat.com, hch@lst.de, hare@suse.de
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.wilck@suse.com
References: <1647340746-17600-1-git-send-email-john.garry@huawei.com>
 <1647340746-17600-3-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1647340746-17600-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/22 19:39, John Garry wrote:
> For attaining a qc tag for a SAS host we need to allocate a bit in
> ata_port.sas_tag_allocated bitmap.
> 
> However we already have a unique tag per device in range
> [0, ATA_MAX_QUEUE) in the scsi cmnd budget token, so just use that
> instead.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/ata/libata-core.c |  5 +++--
>  drivers/ata/libata-sata.c | 21 ++++-----------------
>  drivers/ata/libata-scsi.c |  2 +-
>  drivers/ata/libata.h      |  4 ++--
>  include/linux/libata.h    |  1 -
>  5 files changed, 10 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 0c854aebfe0b..2c0a550d3ecd 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4572,8 +4572,9 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
>   *	None.
>   */
>  
> -struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag)
> +struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, struct scsi_cmnd *scmd)
>  {
> +	int tag = scsi_cmd_to_rq(scmd)->tag;
>  	struct ata_port *ap = dev->link->ap;
>  	struct ata_queued_cmd *qc;
>  
> @@ -4583,7 +4584,7 @@ struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag)
>  
>  	/* libsas case */
>  	if (ap->flags & ATA_FLAG_SAS_HOST) {
> -		tag = ata_sas_allocate_tag(ap);
> +		tag = ata_sas_allocate_tag(ap, scmd);
>  		if (tag < 0)
>  			return NULL;
>  	}
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 071158c0c44c..a4374fdffc43 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1268,29 +1268,16 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
>  }
>  EXPORT_SYMBOL_GPL(ata_sas_queuecmd);
>  
> -int ata_sas_allocate_tag(struct ata_port *ap)
> +int ata_sas_allocate_tag(struct ata_port *ap, struct scsi_cmnd *scmd)
>  {
> -	unsigned int max_queue = ap->host->n_tags;
> -	unsigned int i, tag;
> +	if (scmd->budget_token >= ATA_MAX_QUEUE)
> +		return -1;
>  
> -	for (i = 0, tag = ap->sas_last_tag + 1; i < max_queue; i++, tag++) {
> -		tag = tag < max_queue ? tag : 0;
> -
> -		/* the last tag is reserved for internal command. */
> -		if (ata_tag_internal(tag))
> -			continue;
> -
> -		if (!test_and_set_bit(tag, &ap->sas_tag_allocated)) {
> -			ap->sas_last_tag = tag;
> -			return tag;
> -		}
> -	}
> -	return -1;
> +	return scmd->budget_token;
>  }

Since this is now not actually allocating a tag, I would rename this
something like ata_sas_get_tag(). Or even better, simply open code this
in ata_qc_new_init() since that is the only caller.

>  
>  void ata_sas_free_tag(unsigned int tag, struct ata_port *ap)
>  {
> -	clear_bit(tag, &ap->sas_tag_allocated);
>  }

This is called only in ata_qc_free(). With this change, the function is
empty, so let's completely remove it.

>  
>  /**
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index ed8be585a98f..45d63a2ba3ee 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -640,7 +640,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>  {
>  	struct ata_queued_cmd *qc;
>  
> -	qc = ata_qc_new_init(dev, scsi_cmd_to_rq(cmd)->tag);
> +	qc = ata_qc_new_init(dev, cmd);
>  	if (qc) {
>  		qc->scsicmd = cmd;
>  		qc->scsidone = scsi_done;
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 51e01acdd241..65302d7829fe 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -44,7 +44,7 @@ static inline void ata_force_cbl(struct ata_port *ap) { }
>  #endif
>  extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
>  extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
> -extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag);
> +extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, struct scsi_cmnd *scmd);
>  extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
>  			   u64 block, u32 n_block, unsigned int tf_flags,
>  			   unsigned int tag, int class);
> @@ -93,7 +93,7 @@ extern unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
>  
>  /* libata-sata.c */
>  #ifdef CONFIG_SATA_HOST
> -int ata_sas_allocate_tag(struct ata_port *ap);
> +int ata_sas_allocate_tag(struct ata_port *ap, struct scsi_cmnd *scmd);
>  void ata_sas_free_tag(unsigned int tag, struct ata_port *ap);
>  #else
>  static inline int ata_sas_allocate_tag(struct ata_port *ap)
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 7f99b4d78822..3b9399f67b39 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -814,7 +814,6 @@ struct ata_port {
>  	unsigned int		cbl;	/* cable type; ATA_CBL_xxx */
>  
>  	struct ata_queued_cmd	qcmd[ATA_MAX_QUEUE + 1];
> -	unsigned long		sas_tag_allocated; /* for sas tag allocation only */
>  	u64			qc_active;
>  	int			nr_active_links; /* #links with active qcs */
>  	unsigned int		sas_last_tag;	/* track next tag hw expects */


-- 
Damien Le Moal
Western Digital Research
