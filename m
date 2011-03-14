From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/13] qla4xxx: cleanup DDB relogin logic during initialization
Date: Mon, 14 Mar 2011 16:55:46 -0500
Message-ID: <4D7E8EE2.7070107@cs.wisc.edu>
References: <5E4F49720D0BAD499EE1F01232234BA872263B150A@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50494 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab1CNVzc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 17:55:32 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA872263B150A@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

On 03/14/2011 12:24 AM, Vikas Chaudhary wrote:
> diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
> index 22fc57e..bf1c30b 100644
> --- a/drivers/scsi/qla4xxx/ql4_init.c
> +++ b/drivers/scsi/qla4xxx/ql4_init.c
> @@ -723,13 +723,38 @@ int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err)
>          return relogin;
>   }
>
> +static void qla4xxx_flush_AENS(struct scsi_qla_host *ha)
> +{

I think it is ok for now since the patch is moving the old function, but 
in some future coding style cleanup patch could you fix mixed cases like 
this. So it would be qla4xxx_flush_aens instead of _AENS. It then 
matches the kernel coding style and matches functions like 
qla4xxx_process_aen.


> -
> -static void qla4xxx_flush_AENS(struct scsi_qla_host *ha)
