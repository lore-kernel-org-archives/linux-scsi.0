Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEE6CCA47F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 07:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237228AbiGHHfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 03:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiGHHfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 03:35:54 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC64E7C1AB;
        Fri,  8 Jul 2022 00:35:53 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 297CF41263;
        Fri,  8 Jul 2022 07:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657265751; x=1659080152; bh=pyi3WPmYCwLTZLN0o14rSoiMGYCctnNyG0Q
        VEsJk9vM=; b=A0f2B9Tnw8WhG33dWjDaM0y5gSAOdVjNtQY7rH5H4CEF7ifocWP
        m05/xC4Spb0hhfsJwcp0WiZX5imcEI7hlflMe1qWx+zhy/zkDBFlz+LHIXOA773g
        88Hqw0H7yb6pNMR2rAIM5iVb3koVTIee/kKVNG3Eqxbl+nC5u7Ncq29w=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oQfybfdEI_kI; Fri,  8 Jul 2022 10:35:51 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CE8F8412E1;
        Fri,  8 Jul 2022 10:35:46 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 8 Jul 2022 10:35:46 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 8 Jul 2022
 10:35:45 +0300
Date:   Fri, 8 Jul 2022 10:35:46 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 32/36] usb: gadget: f_tcm: Send sense reason
Message-ID: <20220708073546.GL23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <ce84775a1364314625f366d1bf5f71befb1ca335.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ce84775a1364314625f366d1bf5f71befb1ca335.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2022 at 04:37:43PM -0700, Thinh Nguyen wrote:
> If there's a failure, report it back to the host with a sense reason.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/usb/gadget/function/f_tcm.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index 7162be5fdf2f..fb9b71158c4b 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -669,6 +669,9 @@ static int uasp_send_read_response(struct usbg_cmd *cmd)
>  			pr_err("%s(%d) => %d\n", __func__, __LINE__, ret);
>  	}
>  out:
> +	if (ret)
> +		transport_send_check_condition_and_sense(&cmd->se_cmd,
> +				TCM_CHECK_CONDITION_UNIT_ATTENTION, 0);
>  	return ret;
>  }
>  
> @@ -711,6 +714,9 @@ static int uasp_send_write_request(struct usbg_cmd *cmd)
>  	}
>  
>  cleanup:
> +	if (ret)
> +		transport_send_check_condition_and_sense(&cmd->se_cmd,
> +				TCM_CHECK_CONDITION_UNIT_ATTENTION, 0);
1. TCM_CHECK_CONDITION_UNIT_ATTENTION is used if some UA is allocated.
You do not have UA allocated here, so that reason is not apropriate.
2. I am not sure that it's ok to initiate sending failure response if
you cannot send a response right now.
Other fabric drivers just returns -EAGAIN in case of some lack of
resources to send a response. Then TCM Core will retry to sent that
response again.
>  	return ret;
>  }
>  
> @@ -955,7 +961,15 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
>  	return;
>  
>  cleanup:
> -	transport_generic_free_cmd(&cmd->se_cmd, 0);
> +	/* Command was aborted */
> +	if (cmd->state == UASP_QUEUE_COMMAND) {
> +		transport_generic_free_cmd(se_cmd, 0);
> +		return;
> +	}
> +
> +	cmd->state = UASP_QUEUE_COMMAND;
> +	transport_send_check_condition_and_sense(se_cmd,
> +			TCM_CHECK_CONDITION_UNIT_ATTENTION, 0);
>  }
>  
>  static int usbg_prepare_w_request(struct usbg_cmd *cmd, struct usb_request *req)
