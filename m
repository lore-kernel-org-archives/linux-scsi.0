From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: rewrite code to avoid hitting gcc bug 70646
Date: Fri, 15 Apr 2016 07:40:03 -0700
Message-ID: <1460731203.2331.7.camel@HansenPartnership.com>
References: <1460716583-15673-1-git-send-email-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35782 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbcDOOkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 10:40:08 -0400
In-Reply-To: <1460716583-15673-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: qla2xxx-upstream@qlogic.com, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2016-04-15 at 12:36 +0200, Denys Vlasenko wrote:
> More info here:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646

This bug is under investigation, so I'd rather not alter code for a gcc
bug until we know if we can supply options to fix it rather than
changing code.

James


> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Himanshu Madhani <himanshu.madhani@qlogic.com>
> CC: James Bottomley <James.Bottomley@HansenPartnership.com>
> CC: qla2xxx-upstream@qlogic.com
> CC: Josh Poimboeuf <jpoimboe@redhat.com>
> CC: linux-scsi@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> ---
>  drivers/scsi/qla2xxx/qla_attr.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c
> b/drivers/scsi/qla2xxx/qla_attr.c
> index 4dc06a13..2dd9c72 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2003,9 +2003,14 @@ static void
>  qla2x00_get_host_fabric_name(struct Scsi_Host *shost)
>  {
>  	scsi_qla_host_t *vha = shost_priv(shost);
> +	/*
> +	 * This can trigger gcc 4.9/5.3 bug.
> +	 * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646
>  	uint8_t node_name[WWN_SIZE] = { 0xFF, 0xFF, 0xFF, 0xFF, \
>  		0xFF, 0xFF, 0xFF, 0xFF};
>  	u64 fabric_name = wwn_to_u64(node_name);
> +	 */
> +	u64 fabric_name = (u64)(s64)-1; /* the same as above */
>  
>  	if (vha->device_flags & SWITCH_FOUND)
>  		fabric_name = wwn_to_u64(vha->fabric_node_name);

