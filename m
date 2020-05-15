Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07B3C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 18:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD7872073E
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 18:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="M75s1AzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgEOSw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 14:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgEOSw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 14:52:57 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06780C061A0C
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 11:52:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f13so3293881wmc.5
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 11:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=CQibJcsW1riP710/wd8HzZKYzEd6nHQT+cA9QhF63CQ=;
        b=M75s1AzQKVcsInhjuIzspZLwTGeQE8XhIDSHw3MsYSebnCE/XZXkw4OhZLXv6cGbcG
         J0hF1Z3yn2zxuacgSZRBoM0EyYMCu/O81Q/V0s256CVieFNK0db836N3jEsy1TMlVHaL
         de8bdcajyllwA5Mhu9yYDt6qoJiNn+yOXLQAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CQibJcsW1riP710/wd8HzZKYzEd6nHQT+cA9QhF63CQ=;
        b=HgSMvMZluJ0vNxqZq4IiO9NKKhabMteXoPGu1LKkukzbb99348CY+5KU3SWOH5A9FQ
         0LlQlHuqxw5Xll8HfE4V2Nb4u+r9hD7JFKYzrqDPeXvkGsL0uSg3seRpH5SQ9/HrWcsf
         nHH8kyDxzKBT0Dse33kxa/yBCjTwlwuux/ouVlNKxrC6LjjiweUHuZdlBUiPBjfg3EnX
         h06ER/540A2zecNSlFyrs/FaWTXqVjKXWS6vQo7cK76lluRY06FgBU3mcHr/AH5A5cUo
         YtguEBr37IxO3/1wTFWiTmC5sfM1l9C0EIFFlW/C7AZiQxuld2wFmM4rn6T35nncdWz1
         x+Ug==
X-Gm-Message-State: AOAM531paB6I8bNDRqC6nwivSDIx5bPS3FWxukBT3BoseYaOkMH/U1ZX
        RAYBaUyXbzD1j7UpQSiUCS653g==
X-Google-Smtp-Source: ABdhPJzWkVMDiGz3Cuj+AMDWmeXDPp3l242ZNF+uf0sR9W3kSZkW+qIVO/teiSVbYPjFVAA0sqtWzw==
X-Received: by 2002:a1c:a910:: with SMTP id s16mr5431609wme.70.1589568775622;
        Fri, 15 May 2020 11:52:55 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w82sm4712169wmg.28.2020.05.15.11.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 11:52:55 -0700 (PDT)
Subject: Re: [PATCH 1/3] qla2xxx: Change in PUREX to handle FPIN ELS requests.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-2-njavali@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <75f6aa9d-faca-5e21-8af4-21ff656adbd3@broadcom.com>
Date:   Fri, 15 May 2020 11:52:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514101026.10040-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/14/2020 3:10 AM, Nilesh Javali wrote:
> From: Shyam Sundar <ssundar@marvell.com>
>
> SAN Congestion Management generates ELS pkts whose size
> can vary, and be > 64 bytes. Change the purex
> handling code to support non standard ELS pkt size.
>
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h |  17 ++++-
>   drivers/scsi/qla2xxx/qla_gbl.h |   3 +-
>   drivers/scsi/qla2xxx/qla_isr.c | 116 ++++++++++++++++++++++++---------
>   drivers/scsi/qla2xxx/qla_mbx.c |  22 +++++--
>   drivers/scsi/qla2xxx/qla_os.c  |  19 ++++--
>   5 files changed, 136 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 172ea4e5887d..954d1a230b8a 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -1270,6 +1270,11 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
>   
>   #define ELS_CMD_MAP_SIZE	32
>   #define ELS_COMMAND_RDP		0x18
> +/* Fabric Perf Impact Notification */
> +#define ELS_COMMAND_FPIN	0x16
> +/* Read Diagnostic Functions */
> +#define ELS_COMMAND_RDF		0x19
> +#define ELS_COMMAND_PUN		0x31

You should use the definitions for FPIN, RDF from 
include/uapi/scsi/fc/fc_els.h.  And add PUN to the file.

Note datastructures for FPIN and RDF are there as well.

-- james

