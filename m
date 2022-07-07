Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CBEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 19:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiGGTgT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiGGTgS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 15:36:18 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F6622517;
        Thu,  7 Jul 2022 12:36:17 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 13686412DA;
        Thu,  7 Jul 2022 19:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657222574; x=1659036975; bh=Ejx3KHXWDsyuZUzT/uIXZDasL+ANz5YXuZ/
        bgW4MrIQ=; b=rU5YN06+MkipXJnnFKEoS2GpZlNjkIVKahs1bhcJ3H8Xuq0SFyf
        uKuTCoWCTFay5Pw4iXumd+n4PplvU4j+4hdGBID8xaJDYwf409vChvGq8UCuF5m0
        VlkyhgpL0+8uPGXqccS5JbOIMoej4uij04i3in9TOFWiqUa0J3q8nmAE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ypAz3xAqdxFr; Thu,  7 Jul 2022 22:36:14 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EBC15412C8;
        Thu,  7 Jul 2022 22:36:13 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 22:36:13 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 22:36:13 +0300
Date:   Thu, 7 Jul 2022 22:36:12 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 09/36] target: Add common Task Management values
Message-ID: <20220707193612.GG23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <d89b41eb3be83be3ef532209245caca356a8db49.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d89b41eb3be83be3ef532209245caca356a8db49.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,

On Wed, Jul 06, 2022 at 04:35:20PM -0700, Thinh Nguyen wrote:
> Add some standard TMR and match their code id based on UAS-r04 and
> SPL4-r13. Note that the non-standard TMR_LUN_RESET_PRO is using the same
> id value of QUERY TASK. Change it to 0xf0 instead.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_transport.c | 10 ++++++++++
>  include/target/target_core_base.h      |  8 ++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 105d3b0e470f..cbd876e44cf0 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3090,6 +3090,10 @@ static const char *target_tmf_name(enum tcm_tmreq_table tmf)
>  	case TMR_TARGET_WARM_RESET:	return "TARGET_WARM_RESET";
>  	case TMR_TARGET_COLD_RESET:	return "TARGET_COLD_RESET";
>  	case TMR_LUN_RESET_PRO:		return "LUN_RESET_PRO";
> +	case TMR_I_T_NEXUS_RESET:	return "I_T_NEXUS_RESET";
> +	case TMR_QUERY_TASK:		return "QUERY_TASK";
> +	case TMR_QUERY_TASK_SET:	return "QUERY_TASK_SET";
> +	case TMR_QUERY_ASYNC_EVENT:	return "QUERY_ASYNC_EVENT";
>  	case TMR_UNKNOWN:		break;
>  	}
>  	return "(?)";
> @@ -3538,6 +3542,12 @@ static void target_tmr_work(struct work_struct *work)
>  	case TMR_TARGET_COLD_RESET:
>  		tmr->response = TMR_FUNCTION_REJECTED;
>  		break;
> +	case TMR_I_T_NEXUS_RESET:
> +	case TMR_QUERY_TASK:
> +	case TMR_QUERY_TASK_SET:
> +	case TMR_QUERY_ASYNC_EVENT:
> +		tmr->response = TMR_FUNCTION_REJECTED;
> +		break;
>  	default:
>  		pr_err("Unknown TMR function: 0x%02x.\n",
>  				tmr->function);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 8e3da143a1ce..ccd98604eaf4 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -206,12 +206,16 @@ enum target_sc_flags_table {
>  enum tcm_tmreq_table {
>  	TMR_ABORT_TASK		= 1,
>  	TMR_ABORT_TASK_SET	= 2,
> -	TMR_CLEAR_ACA		= 3,
> +	TMR_CLEAR_ACA		= 0x40,
There is no need to align that values to some standart. This enum is not
standard. That is even stated in the comment for it:
   /* fabric independent task management function values */
So, just add new values continuing from 8. 
>  	TMR_CLEAR_TASK_SET	= 4,
>  	TMR_LUN_RESET		= 5,
>  	TMR_TARGET_WARM_RESET	= 6,
>  	TMR_TARGET_COLD_RESET	= 7,
> -	TMR_LUN_RESET_PRO	= 0x80,
> +	TMR_I_T_NEXUS_RESET	= 0x10,
> +	TMR_QUERY_TASK		= 0x80,
> +	TMR_QUERY_TASK_SET	= 0x81,
> +	TMR_QUERY_ASYNC_EVENT	= 0x82,
> +	TMR_LUN_RESET_PRO	= 0xf0,
>  	TMR_UNKNOWN		= 0xff,
>  };
>  
