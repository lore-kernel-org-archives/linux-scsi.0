From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 1/2] target: Fix R_HOLDER bit usage for AllRegistrants
Date: Wed, 17 Dec 2014 23:01:37 -0800
Message-ID: <54927BD1.3080805@suse.com>
References: <1418688544-18825-1-git-send-email-nab@daterainc.com> <1418688544-18825-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:35104 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaLRHBn (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Thu, 18 Dec 2014 02:01:43 -0500
In-Reply-To: <1418688544-18825-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ilias Tsitsimpis <i.tsitsimpis@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 12/15/2014 04:09 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch fixes the usage of R_HOLDER bit for an All Registrants
> reservation in READ_FULL_STATUS, where only the registration who
> issued RESERVE was being reported as having an active reservation.
> 
> It changes core_scsi3_pri_read_full_status() to check ahead of the
> list walk of active registrations to see if All Registrants is active,
> and if so set R_HOLDER bit and scope/type fields for all active
> registrations.
> 
> Reported-by: Ilias Tsitsimpis <i.tsitsimpis@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_pr.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index f91b6a1..c4a8da5 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3834,7 +3834,8 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
>  	unsigned char *buf;
>  	u32 add_desc_len = 0, add_len = 0, desc_len, exp_desc_len;
>  	u32 off = 8; /* off into first Full Status descriptor */
> -	int format_code = 0;
> +	int format_code = 0, pr_res_type = 0, pr_res_scope = 0;
> +	bool all_reg = false;
>  
>  	if (cmd->data_length < 8) {
>  		pr_err("PRIN SA READ_FULL_STATUS SCSI Data Length: %u"
> @@ -3851,6 +3852,19 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
>  	buf[2] = ((dev->t10_pr.pr_generation >> 8) & 0xff);
>  	buf[3] = (dev->t10_pr.pr_generation & 0xff);
>  
> +	spin_lock(&dev->dev_reservation_lock);
> +	if (dev->dev_pr_res_holder) {
> +		struct t10_pr_registration *pr_holder = dev->dev_pr_res_holder;
> +
> +		if (pr_holder->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG ||
> +		    pr_holder->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG) {
> +			all_reg = true;
> +			pr_res_type = pr_holder->pr_res_type;
> +			pr_res_scope = pr_holder->pr_res_scope;
> +		}
> +	}
> +	spin_unlock(&dev->dev_reservation_lock);
> +
>  	spin_lock(&pr_tmpl->registration_lock);
>  	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
>  			&pr_tmpl->registration_list, pr_reg_list) {
> @@ -3898,14 +3912,20 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
>  		 * reservation holder for PR_HOLDER bit.
>  		 *
>  		 * Also, if this registration is the reservation
> -		 * holder, fill in SCOPE and TYPE in the next byte.
> +		 * holder or there is an All Registrants reservation
> +		 * active, fill in SCOPE and TYPE in the next byte.
>  		 */
>  		if (pr_reg->pr_res_holder) {
>  			buf[off++] |= 0x01;
>  			buf[off++] = (pr_reg->pr_res_scope & 0xf0) |
>  				     (pr_reg->pr_res_type & 0x0f);
> -		} else
> +		} else if (all_reg) {
> +			buf[off++] |= 0x01;
> +			buf[off++] = (pr_res_scope & 0xf0) |
> +				     (pr_res_type & 0x0f);
> +		} else {
>  			off += 2;
> +		}
>  
>  		off += 4; /* Skip over reserved area */
>  		/*
> 
Passes my test suite now for All Registrants.

Tested-by: Lee Duncan <lduncan@suse.com>
