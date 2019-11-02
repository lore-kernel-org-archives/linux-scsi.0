Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0884FCA9ECF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 03:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D173C208E3
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 03:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfKBD2a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 23:28:30 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:53760 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfKBD2a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 23:28:30 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id B05C82994C;
        Fri,  1 Nov 2019 23:28:26 -0400 (EDT)
Date:   Sat, 2 Nov 2019 14:28:26 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 17/24] scsi: do not use DRIVER_INVALID
In-Reply-To: <20191031110452.73463-18-hare@suse.de>
Message-ID: <alpine.LNX.2.21.1911021412001.35@nippy.intranet>
References: <20191031110452.73463-1-hare@suse.de> <20191031110452.73463-18-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 31 Oct 2019, Hannes Reinecke wrote:

> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 74e5ed940952..e988a8c3fc7f 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -572,25 +572,25 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
>  		case BTSTAT_LINKED_COMMAND_COMPLETED:
>  		case BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG:
>  			/* If everything went fine, let's move on..  */
> -			cmd->result = (DID_OK << 16);
> +			set_host_byte(cmd, DID_OK);
>  			break;
>  
>  		case BTSTAT_DATARUN:
>  		case BTSTAT_DATA_UNDERRUN:
>  			/* Report residual data in underruns */
>  			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
> -			cmd->result = (DID_ERROR << 16);
> +			set_host_byte(cmd, DID_ERROR);
>  			break;
>  
>  		case BTSTAT_SELTIMEO:
>  			/* Our emulation returns this for non-connected devs */
> -			cmd->result = (DID_BAD_TARGET << 16);
> +			set_host_byte(cmd, DID_BAD_TARGET);
>  			break;
>  
>  		case BTSTAT_LUNMISMATCH:
>  		case BTSTAT_TAGREJECT:
>  		case BTSTAT_BADMSG:
> -			cmd->result = (DRIVER_INVALID << 24);
> +			cmd->result = 0;
>  			/* fall through */
>  
>  		case BTSTAT_HAHARDWARE:

That cmd->result = 0 assignment already exists (before the switch).

-- 
