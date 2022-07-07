Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9002C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 20:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbiGGUxY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 16:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiGGUxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 16:53:17 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A192CE3B;
        Thu,  7 Jul 2022 13:53:15 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3AA4B412E1;
        Thu,  7 Jul 2022 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657227193; x=1659041594; bh=Hr2U4GySC3atC93YCtxMCMcbN+oriMPyVTi
        bUXsAHpY=; b=JJ6etdmBkvU9AyGed9TmcRSUpS77pB69tLHdqtOGqcj+0lqfXK3
        6P8qcvzCEbAAiVBs/3nfymoOJQIte0pOAs6URiHiAHM7h+kI0RrrAroNOjqFozoJ
        +ayW0NH0aRWC6YoMdAeOcedz1S5wcqZlQKkoVUMViBuLTNcuT515Bslo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1sDmnN9HZCmY; Thu,  7 Jul 2022 23:53:13 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7AEEE412C5;
        Thu,  7 Jul 2022 23:53:12 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 23:53:12 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 23:53:11 +0300
Date:   Thu, 7 Jul 2022 23:53:11 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 12/36] target: Properly set Sense data length when copy
 sense
Message-ID: <20220707205311.GJ23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <9cb2ee13f6edbcfd9b719e4b4b53f7cec0080d3b.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9cb2ee13f6edbcfd9b719e4b4b53f7cec0080d3b.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,
On Wed, Jul 06, 2022 at 04:35:38PM -0700, Thinh Nguyen wrote:
> The transport_get_sense_buffer() sets sense data length to be the
> allocated sense buffer length TRANSPORT_SENSE_BUFFER. However, the sense
> data length is depending on the sense data description. Check the sense
> data for cmd->scsi_sense_length.
> 
> See SPC4-R37 section 4.5.2.1.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_transport.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 9734952a6228..2fc4ba1814c6 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -771,8 +771,6 @@ static unsigned char *transport_get_sense_buffer(struct se_cmd *cmd)
>  	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION)
>  		return NULL;
>  
> -	cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER;
> -
>  	pr_debug("HBA_[%u]_PLUG[%s]: Requesting sense for SAM STATUS: 0x%02x\n",
>  		dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
>  	return cmd->sense_buffer;
> @@ -791,7 +789,12 @@ void transport_copy_sense_to_cmd(struct se_cmd *cmd, unsigned char *sense)
>  	}
>  
>  	cmd->se_cmd_flags |= SCF_TRANSPORT_TASK_SENSE;
> -	memcpy(cmd_sense_buf, sense, cmd->scsi_sense_length);
> +	memcpy(cmd_sense_buf, sense, TRANSPORT_SENSE_BUFFER);
> +
> +	/* Sense data length = min sense data + additional sense data length */
> +	cmd->scsi_sense_length = min_t(int, 8 + cmd_sense_buf[7],
> +				       TRANSPORT_SENSE_BUFFER);
Looks a bit strange - to copy big amount of data and then to reduce the
length. Better vice versa - set correct length and copy only that data. 
> +
>  	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>  }
>  EXPORT_SYMBOL(transport_copy_sense_to_cmd);
