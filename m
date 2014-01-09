From: Sagi Grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Thu, 9 Jan 2014 12:24:43 +0200
Message-ID: <52CE78EB.60108@mellanox.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com> <1389212157-14540-8-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:52844 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbaAIKZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2014 05:25:05 -0500
In-Reply-To: <1389212157-14540-8-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch updates sbc_emulate_readcapacity_16() to set
> P_TYPE and PROT_EN bits when DIF emulation is enabled by
> the backend device.
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_sbc.c |    5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 366b9bb..22599e8 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -106,6 +106,11 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
>   	buf[9] = (dev->dev_attrib.block_size >> 16) & 0xff;
>   	buf[10] = (dev->dev_attrib.block_size >> 8) & 0xff;
>   	buf[11] = dev->dev_attrib.block_size & 0xff;
> +	/*
> +	 * Set P_TYPE and PROT_EN bits for DIF support
> +	 */
> +	if (dev->dev_attrib.pi_prot_type)
> +		buf[12] = (dev->dev_attrib.pi_prot_type - 1) << 1 | 0x1;
>   
>   	if (dev->transport->get_lbppbe)
>   		buf[13] = dev->transport->get_lbppbe(dev) & 0x0f;

Hey Nic,

What about FORMAT_UNIT emulation?
The backstore protection configuration is done at the target side via 
configfs/targetcli, if you publish DIF support in 
INQUERY_EVPD/READ_CAPACITY you need to accept protection information format?
Did I miss that one? or is it still under WIP?

Sagi.
