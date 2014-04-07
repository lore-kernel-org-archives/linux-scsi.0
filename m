From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 5/9] target/sbc: Only expose PI read_cap16 bits when supported
 by fabric
Date: Mon, 07 Apr 2014 10:32:05 +0300
Message-ID: <53425475.80603@dev.mellanox.co.il>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com> <1396517753-23546-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41883 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbaDGHcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 03:32:11 -0400
Received: by mail-wi0-f176.google.com with SMTP id r20so4507187wiv.15
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2014 00:32:10 -0700 (PDT)
In-Reply-To: <1396517753-23546-6-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 4/3/2014 12:35 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Only expose the PI protection type bits in READ_CAPACITY_16
> if the session + fabric support DIX PASS operations.
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_sbc.c |    7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index ec204f7..f2d73dd 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -89,6 +89,7 @@ static sense_reason_t
>   sbc_emulate_readcapacity_16(struct se_cmd *cmd)
>   {
>   	struct se_device *dev = cmd->se_dev;
> +	struct se_session *sess = cmd->se_sess;
>   	unsigned char *rbuf;
>   	unsigned char buf[32];
>   	unsigned long long blocks = dev->transport->get_blocks(dev);
> @@ -109,8 +110,10 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
>   	/*
>   	 * Set P_TYPE and PROT_EN bits for DIF support
>   	 */
> -	if (dev->dev_attrib.pi_prot_type)
> -		buf[12] = (dev->dev_attrib.pi_prot_type - 1) << 1 | 0x1;
> +	if (sess->sup_prot_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS)) {
> +		if (dev->dev_attrib.pi_prot_type)
> +			buf[12] = (dev->dev_attrib.pi_prot_type - 1) << 1 | 0x1;
> +	}
>   
>   	if (dev->transport->get_lbppbe)
>   		buf[13] = dev->transport->get_lbppbe(dev) & 0x0f;
Looks good to me.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
