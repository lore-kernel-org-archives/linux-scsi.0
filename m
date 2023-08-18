Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62E9EE4992
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 22:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241694AbjHRWqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 18:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241581AbjHRWpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 18:45:33 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300E82D5A
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2023 15:45:32 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1c4c6717e61so942110fac.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2023 15:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692398731; x=1693003531;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QygEeSu2+EI7ASxsujX9swnwPudJtp2NTT1DQMu/YOY=;
        b=13eNzCD9sX2VN/KksrBUrqJj3CGxkKFOftkmqC9MoQ5hJVsQ9127+SZDg5ckS/b3Kw
         KhTQf8vpNt3pdyL1Kk7Nsz78fYti+ZhRuHEcb9Q67blmaPLrEbouJCi6VU15h8ryspFV
         MC7DFKEFdO+hTaZJDPDw96NxIrylQfhQfKPA+l2luv2yHIZ80tqZZV6gol4ugWM4sEFE
         5wqWUP6MhU0DNBvrndI8tcsx1UB1RaRC5dqgKKTBSkYx/7eaeieoqRrwiVXIg7nv/cQt
         UpSqC80A0gw1ecCFMYLGI/n7dVbC1yiaVNImYieaRw2yFhx8mn/xA4YY/39t8CnGlKcD
         ibsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692398731; x=1693003531;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QygEeSu2+EI7ASxsujX9swnwPudJtp2NTT1DQMu/YOY=;
        b=CDkhEiGaP8BZsyhE0AxMfS5dovh6+LVN32JAOvVZFhisxh1QyYgDdQS+KrPLacTDYJ
         pJlej9yVntaAlOxDsQblB+Y2+dyDlvY5kgeK0hXm5LIvQ0oX9caAbBlRjuFIxhZ5N4Wv
         vY6DQoyVyUJLsV3ZGgDW3D6D8xHKkL+kCmDYGDBwcd/ORngOiw6y6jjSO2NS8FfSXBXF
         Mb+DxlsRNfQTOdGpvcm+5S2MSEQhqVEzhLJATfk/ZThF0HF5TN8SFacQgP8+CRczou26
         +iRljdIWFTfcQizwGLxMVlO85we4fFcc0tnqAlil5xz4kWpXrahqh0RZTtcy7sD6D8yd
         6XNw==
X-Gm-Message-State: AOJu0Yz4ymIXAz71/PrykhCMAdRSPNhxROwXY5c95bEsYhJm2jONB0nR
        u7DFKYXluhmHDiy4WaxsWni+PQ==
X-Google-Smtp-Source: AGHT+IHHLZE3H+zbLOa5NBrwKUFwLqQmXu4bECmXZKV5vhrm0a5tdv9fJXyOcjWdzH50ZAebC+Ea6A==
X-Received: by 2002:a05:6871:68d:b0:187:92fb:6ecb with SMTP id l13-20020a056871068d00b0018792fb6ecbmr650959oao.20.1692398730939;
        Fri, 18 Aug 2023 15:45:30 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:13:4f6e:2bd9:cb46:7849])
        by smtp.gmail.com with ESMTPSA id 101-20020a17090a09ee00b00263f8915aa3sm4038761pjo.31.2023.08.18.15.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 15:45:30 -0700 (PDT)
Date:   Fri, 18 Aug 2023 15:45:25 -0700
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 3/3] scsi: pm80xx: Set RETFIS when requested by libsas
Message-ID: <ZN/0heaKv6DfNrFj@google.com>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-3-ipylypiv@google.com>
 <febb997e-fc77-5ac2-0a58-57f66c20b313@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <febb997e-fc77-5ac2-0a58-57f66c20b313@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 18, 2023 at 08:12:13AM +0900, Damien Le Moal wrote:
> On 2023/08/18 6:41, Igor Pylypiv wrote:
> > By default PM80xx HBAs return FIS only when a drive reports an error.
> 
> s/FIS/SDB FIS or even better "Set Device Bits (SDB) FIS" to be clear.
> 
> > The RETFIS bit forces the controller to populate FIS even when a drive
> > reports no error.
> 
> And here s/FIS/SDB FIS

Keeping "FIS" per discussion in PATCH 2/3 (SDB FIS applies only to NCQ).

> 
> > 
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > ---
> >  drivers/scsi/pm8001/pm8001_hwi.c |  8 +++++---
> >  drivers/scsi/pm8001/pm8001_hwi.h |  2 +-
> >  drivers/scsi/pm8001/pm80xx_hwi.c | 11 ++++++-----
> >  drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
> >  4 files changed, 13 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> > index 73cd25f30ca5..255553dcadb9 100644
> > --- a/drivers/scsi/pm8001/pm8001_hwi.c
> > +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> > @@ -4095,7 +4095,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
> >  	u32 hdr_tag, ncg_tag = 0;
> >  	u64 phys_addr;
> >  	u32 ATAP = 0x0;
> > -	u32 dir;
> > +	u32 dir, retfis;
> >  	u32  opc = OPC_INB_SATA_HOST_OPSTART;
> >  
> >  	memset(&sata_cmd, 0, sizeof(sata_cmd));
> > @@ -4124,8 +4124,10 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
> >  	sata_cmd.tag = cpu_to_le32(tag);
> >  	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
> >  	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
> > -	sata_cmd.ncqtag_atap_dir_m =
> > -		cpu_to_le32(((ncg_tag & 0xff)<<16)|((ATAP & 0x3f) << 10) | dir);
> > +	retfis = task->ata_task.return_fis_on_success;
> 
> While I think this should be OK, I think it would be safer to do:
> 
> 	u32 dir, retfis = 0;
> 
> 	...
> 
> 	if (task->ata_task.return_fis_on_success)
> 		retfis = 1;
> 
> to avoid issues with funky compilers doing some tricky handling of single bit
> fields.
> 
> > +	sata_cmd.retfis_ncqtag_atap_dir_m =
> > +		cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
> > +				((ATAP & 0x3f) << 10) | dir);
> 
> Please align this line with "(retfis << 24)" above.

Thanks Damien! I'll update the code in v2.
 
> >  	sata_cmd.sata_fis = task->ata_task.fis;
> >  	if (likely(!task->ata_task.device_control_reg_update))
> >  		sata_cmd.sata_fis.flags |= 0x80;/* C=1: update ATA cmd reg */
> > diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
> > index 961d0465b923..fc2127dcb58d 100644
> > --- a/drivers/scsi/pm8001/pm8001_hwi.h
> > +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> > @@ -515,7 +515,7 @@ struct sata_start_req {
> >  	__le32	tag;
> >  	__le32	device_id;
> >  	__le32	data_len;
> > -	__le32	ncqtag_atap_dir_m;
> > +	__le32	retfis_ncqtag_atap_dir_m;
> 
> Naming this field from what is set in it is unusual... Not sure how the
> controller spce named this field, but we should use that and stop changing it's
> name whenever we change the bits that are set.

I see this naming as "what can be set" rather than "what is set" (yes, retfis
wasn't there for some reason). These four bytes are assentially a bitfield.

While we can change this to a bitfield I would like to keep the current single
filed as there are other fields that follow the same naming pattern
e.g. ase_sh_lm_slr_phyid, phyid_npip_portstate, phyid_portid, etc.

> 
> >  	struct host_to_dev_fis	sata_fis;
> >  	u32	reserved1;
> >  	u32	reserved2;
> > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> > index 39a12ee94a72..e839fb53f0e3 100644
> > --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> > +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> > @@ -4457,7 +4457,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
> >  	u64 phys_addr, end_addr;
> >  	u32 end_addr_high, end_addr_low;
> >  	u32 ATAP = 0x0;
> > -	u32 dir;
> > +	u32 dir, retfis;
> >  	u32 opc = OPC_INB_SATA_HOST_OPSTART;
> >  	memset(&sata_cmd, 0, sizeof(sata_cmd));
> >  
> > @@ -4487,6 +4487,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
> >  	sata_cmd.tag = cpu_to_le32(tag);
> >  	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
> >  	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
> > +	retfis = task->ata_task.return_fis_on_success;
> >  
> >  	sata_cmd.sata_fis = task->ata_task.fis;
> >  	if (likely(!task->ata_task.device_control_reg_update))
> > @@ -4502,8 +4503,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
> >  		opc = OPC_INB_SATA_DIF_ENC_IO;
> >  
> >  		/* set encryption bit */
> > -		sata_cmd.ncqtag_atap_dir_m_dad =
> > -			cpu_to_le32(((ncg_tag & 0xff)<<16)|
> > +		sata_cmd.retfis_ncqtag_atap_dir_m_dad =
> > +			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
> >  				((ATAP & 0x3f) << 10) | 0x20 | dir);
> 
> Same comments here.
> 
> >  							/* dad (bit 0-1) is 0 */
> >  		/* fill in PRD (scatter/gather) table, if any */
> > @@ -4569,8 +4570,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
> >  			   "Sending Normal SATA command 0x%x inb %x\n",
> >  			   sata_cmd.sata_fis.command, q_index);
> >  		/* dad (bit 0-1) is 0 */
> > -		sata_cmd.ncqtag_atap_dir_m_dad =
> > -			cpu_to_le32(((ncg_tag & 0xff)<<16) |
> > +		sata_cmd.retfis_ncqtag_atap_dir_m_dad =
> > +			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
> >  					((ATAP & 0x3f) << 10) | dir);
> >  
> >  		/* fill in PRD (scatter/gather) table, if any */
> > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> > index acf6e3005b84..eb8fd37b2066 100644
> > --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> > +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> > @@ -731,7 +731,7 @@ struct sata_start_req {
> >  	__le32	tag;
> >  	__le32	device_id;
> >  	__le32	data_len;
> > -	__le32	ncqtag_atap_dir_m_dad;
> > +	__le32	retfis_ncqtag_atap_dir_m_dad;
> >  	struct host_to_dev_fis	sata_fis;
> >  	u32	reserved1;
> >  	u32	reserved2;	/* dword 11. rsvd for normal I/O. */
> 
> -- 
> Damien Le Moal
> Western Digital Research

Thank you,
Igor 
