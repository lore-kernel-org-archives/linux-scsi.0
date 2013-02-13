From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] target: Fix parameter list length checking in MODE
 SELECT
Date: Wed, 13 Feb 2013 12:27:23 -0800
Message-ID: <1360787243.13707.56.camel@haakon2.linux-iscsi.org>
References: <1360365520-11972-1-git-send-email-roland@kernel.org>
	 <1360365520-11972-3-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50727 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3BMU1Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 15:27:25 -0500
In-Reply-To: <1360365520-11972-3-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

On Fri, 2013-02-08 at 15:18 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> An empty parameter list (length == 0) is not an error, so succeed MODE
> SELECT in this case.  If the parameter list length is too small,
> return the correct sense code of PARAMETER LIST LENGTH ERROR.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Applied.

Thanks Roland!

--nab

>  drivers/target/target_core_spc.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 2d88f08..73c5d53 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -983,6 +983,14 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
>  	int ret = 0;
>  	int i;
>  
> +	if (!cmd->data_length) {
> +		target_complete_cmd(cmd, GOOD);
> +		return 0;
> +	}
> +
> +	if (cmd->data_length < off + 2)
> +		return TCM_PARAMETER_LIST_LENGTH_ERROR;
> +
>  	buf = transport_kmap_data_sg(cmd);
>  	if (!buf)
>  		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> @@ -1007,6 +1015,11 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
>  	goto out;
>  
>  check_contents:
> +	if (cmd->data_length < off + length) {
> +		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
> +		goto out;
> +	}
> +
>  	if (memcmp(buf + off, tbuf, length))
>  		ret = TCM_INVALID_PARAMETER_LIST;
>  


