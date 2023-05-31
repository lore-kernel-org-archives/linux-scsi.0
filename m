Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AD9C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 12:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbjEaMds (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 08:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjEaMdr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 08:33:47 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861228E
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 05:33:46 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1b1806264e9so1375905ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 05:33:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685536426; x=1688128426;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99KMGE8WDZ9cWEvhvApN/YKNyqOK8gluMsjFb51l2Bg=;
        b=gkG4pZRhkilfGrELtVx4lrePWpGkOZNlf2x9V6hALjBZqzEAjyIgNjOkm40ErQIUlB
         XDzI0eKRNqShInevveaub+q5gogPljRI7Zta7yr+CBkti2nMW/kUgkFAKALFr2TK8yf/
         wqc4raxHfeTXUdDsig9iGwTEF32Q8tGF35wj/hlx0bn0lNMSkCihA2nZEyJ3XXzwFrVo
         p5/bjcXwKDkwRKlDhouvJ5tlp54ED/fDnt0pvJZPd2CQ/ilQvxP+iUeGVsDq1SSbha1A
         Ne7z6QYW6jmil+9a0YOkJ1rBy9BmA4pDT3GJ/gBqZgGJxfDMOBOkSiM3nzx1u5AT6Spm
         XNmQ==
X-Gm-Message-State: AC+VfDxaHjcfN9KsslMCu2TDH0rX6w3Kcof/eJQBCvD5acso0mSW8e9P
        zx9qqQJRSewkBTzCqvqHBHuqwkpuTu0=
X-Google-Smtp-Source: ACHHUZ5amKSv1eA8diZ17sXkogN+1+iTmJ+eITwDbMvHp5bRRsvDYUQzVi/Uul1+xPBqa4Ycs4PndQ==
X-Received: by 2002:a17:902:e993:b0:1af:aafb:64c8 with SMTP id f19-20020a170902e99300b001afaafb64c8mr3749405plb.21.1685536425851;
        Wed, 31 May 2023 05:33:45 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t14-20020a1709028c8e00b001b01448ba72sm1235815plo.215.2023.05.31.05.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 05:33:45 -0700 (PDT)
Message-ID: <8563e3b4-3347-e702-03b5-94133d9472c1@acm.org>
Date:   Wed, 31 May 2023 05:33:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [EXT] Re: [PATCH 2/8] qla2xxx: klocwork - Fix potential null
 pointer dereference
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>
References: <20230518075841.40363-1-njavali@marvell.com>
 <20230518075841.40363-3-njavali@marvell.com>
 <f312be96-786e-f5f3-a92e-54a5983dfa19@acm.org>
 <CO6PR18MB45008A33CB0D57741DDB828CAF489@CO6PR18MB4500.namprd18.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CO6PR18MB45008A33CB0D57741DDB828CAF489@CO6PR18MB4500.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/23 04:43, Nilesh Javali wrote:
> We can prevent the crash and notify the occurrence of this
> rare case by adding warn_on like,
> 
> +       WARN_ON_ONCE(!cur_dsd);
> +       if (cur_dsd) {
> +               cur_dsd->address = 0;
> +               cur_dsd->length = 0;
> +               cur_dsd++;
> +       }
>          cmd_pkt->control_flags |= cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
>          return 0;
>   }

I think there is a much better solution: drop the new "if (cur_dsd) {" 
test and instead add the following code:

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c 
b/drivers/scsi/qla2xxx/qla_iocb.c
index 6acfdcc48b16..a1675f056a5c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -607,7 +607,8 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct 
cmd_type_6 *cmd_pkt,
  	put_unaligned_le32(COMMAND_TYPE_6, &cmd_pkt->entry_type);

  	/* No data transfer */
-	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
+	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE ||
+	    tot_dsds == 0) {
  		cmd_pkt->byte_count = cpu_to_le32(0);
  		return 0;
  	}

Is the above change sufficient to suppress the Klocwork warning?

Thanks,

Bart.
