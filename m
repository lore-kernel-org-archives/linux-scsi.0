From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 22/43] qla2xxx: Add switch command to simplify fabric
 discovery
Date: Wed, 20 Dec 2017 13:09:37 -0500
Message-ID: <1513793377.10760.169.camel@localhost.localdomain>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
         <20171220065644.21511-23-himanshu.madhani@cavium.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755911AbdLTSJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 13:09:38 -0500
In-Reply-To: <20171220065644.21511-23-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2017-12-19 at 22:56 -0800, Himanshu Madhani wrote:
> @@ -4915,12 +4941,32 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
>  		}
>  
>  		if (sess != NULL) {
> +			bool delete = false;
>  			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
>  			switch (sess->fw_login_state) {
> +			case DSC_LS_PLOGI_PEND:
>  			case DSC_LS_PLOGI_COMP:
>  			case DSC_LS_PRLI_COMP:
>  				break;
>  			default:
> +			    	delete = true;

Nitpick:  git quiltimport complains about the whitespace error
(space before tab) on the above line.
