Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82C4C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 20:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbiGGU1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 16:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiGGU1p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 16:27:45 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564FD2559D;
        Thu,  7 Jul 2022 13:27:44 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D4E04412E1;
        Thu,  7 Jul 2022 20:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657225661; x=1659040062; bh=cwq/jk26lA1GO4HK5KdLrUeHCgVnbK1n6Ch
        HWivRRds=; b=m/Qn2Yq8/hd9PubGygub3t2pJZ0tlv4/nLGuxhucDblfk+6/mfV
        3knAq0sP7YHqL1dsoUGj6Zg5h5Z1d+4PMC3h4SUC+YEXSadtp+5daBVz6uXln2Rt
        x8vLMfahzPKViQQDSfVkhGmYLUJ4FzeTQ/5aAIIOwD7kSg7Iu9D0+JeM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zdykcl6JJAkd; Thu,  7 Jul 2022 23:27:41 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id F12C941244;
        Thu,  7 Jul 2022 23:27:40 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 23:27:40 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 23:27:40 +0300
Date:   Thu, 7 Jul 2022 23:27:39 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 11/36] target: Properly set Sense Data Length of CHECK
 CONDITION
Message-ID: <20220707202739.GI23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <61593a434f543184f41df91a4ba858e1158fd33c.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <61593a434f543184f41df91a4ba858e1158fd33c.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,

On Wed, Jul 06, 2022 at 04:35:32PM -0700, Thinh Nguyen wrote:
> CHECK CONDITION returns sense data, and sense data is minimum 8 bytes
> long plus additional sense data length in the data buffer. Don't just
> set the allocated buffer length to the cmd->scsi_sense_length and check
> the sense data for that.
> 
> See SPC4-r37 section 4.5.2.1.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_transport.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index bc1e4a7c4538..9734952a6228 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3459,12 +3459,20 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
>  
>  	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
>  	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
> -	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
> +
> +	/*
> +	 * CHECK CONDITION returns sense data, and sense data is minimum 8
> +	 * bytes long. See SPC4-r37 section 4.5.2.1.
> +	 */
> +	cmd->scsi_sense_length = 8;
> +
>  	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
>  	if (sd->add_sense_info)
>  		WARN_ON_ONCE(scsi_set_sense_information(buffer,
>  							cmd->scsi_sense_length,
scsi_set_sense_information()'s second argument is buffer length; send
there TRANSPORT_SENSE_BUFFER and the patch will be correct.
>  							cmd->sense_info) < 0);
> +	/* Additional sense data length */
> +	cmd->scsi_sense_length += buffer[7];
>  }
>  
>  int
