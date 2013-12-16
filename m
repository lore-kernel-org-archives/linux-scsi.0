From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 02/32] target: Don't keep looping in report_luns if too
 big
Date: Mon, 16 Dec 2013 12:41:42 -0800
Message-ID: <1387226502.20247.193.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-3-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37784 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3LPUkt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 15:40:49 -0500
In-Reply-To: <1386979160-6928-3-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> All further loops will still fail the conditional so just bail right
> away.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_spc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 021c3f4..8f52974 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -1162,7 +1162,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
>  		 */
>  		lun_count++;
>  		if ((offset + 8) > cmd->data_length)
> -			continue;
> +			break;
>  
>  		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
>  		offset += 8;

NAK.

REPORT_LUNS is supposed to return the total lun_count, even if there is
no more buffer space to fill..

This is how the initiator knows it should send another REPORT_LUNS with
a larger payload to receive the complete layout.

--nab

