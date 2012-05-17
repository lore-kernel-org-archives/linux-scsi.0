From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] V2: target: Handle ATA_PASS_THROUGH_16 passthrough
Date: Wed, 16 May 2012 23:13:11 -0700
Message-ID: <1337235191.32217.150.camel@haakon2.linux-iscsi.org>
References: <1337146409.18429.11.camel@mengcong>
	 <1337153889.2985.5.camel@dabdike.int.hansenpartnership.com>
	 <1337224486.18429.14.camel@mengcong>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38371 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2EQGNO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 02:13:14 -0400
In-Reply-To: <1337224486.18429.14.camel@mengcong>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mc@linux.vnet.ibm.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

On Thu, 2012-05-17 at 11:14 +0800, mengcong wrote:
> The cdrecord uses ATA_PASS_THROUGH_16 command while burning CDs
> with a SATA CD-ROM. This patch adds support to it so that PSCSI 
> CD-ROM passthrough works with the cdrecord.
> 
> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_transport.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 

Ok, I've added the extra !passthrough check to enforce pSCSI backends
only usage + /* ... */ style comments changes mentioned as feedback you
missed in the last mail.  (That's OK this time, but please don't get
into the habit of ignoring patch feedback..)

So committed into lio-core.git, and queuing shortly into
target-pending/for-next to be picked up for tomorrow's linux-next build.

Thanks for your patch MC!

--nab

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 2d75c29..25e0fc0 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2926,6 +2926,36 @@ static int transport_generic_cmd_sequencer(
>  		size = (cdb[7] << 8) | cdb[8];
>  		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
>  		break;
> +	case ATA_16:
> +		// T_LENGTH
> +		switch (cdb[2] & 0x3) {
> +		case 0x0:
> +			sectors = 0;
> +			break;
> +		case 0x1:
> +			sectors = (((cdb[1] & 0x1) ? cdb[3] : 0) << 8) | cdb[4];
> +			break;
> +		case 0x2:
> +			sectors = (((cdb[1] & 0x1) ? cdb[5] : 0) << 8) | cdb[6];
> +			break;
> +		case 0x3:
> +			pr_err("T_LENGTH=0x3 not supported\n");
> +			goto out_invalid_cdb_field;
> +			break;
> +		}
> +		
> +		// BYTE_BLOCK
> +		if (cdb[2] & 0x4) {
> +			// BLOCK
> +			// T_TYPE: 512 or sector
> +			size = sectors * ((cdb[2] & 0x10) ? 
> +				dev->se_sub_dev->se_dev_attrib.block_size : 512);
> +		} else {
> +			// BYTE
> +			size = sectors;
> +		}
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
> +		break;
>  	default:
>  		pr_warn("TARGET_CORE[%s]: Unsupported SCSI Opcode"
>  			" 0x%02x, sending CHECK_CONDITION.\n",


