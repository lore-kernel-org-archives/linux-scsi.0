From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Handle ATA_PASS_THROUGH_16 passthrough
Date: Wed, 16 May 2012 16:41:49 -0700
Message-ID: <1337211709.32217.100.camel@haakon2.linux-iscsi.org>
References: <1337146409.18429.11.camel@mengcong>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48043 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760774Ab2EPXlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 19:41:52 -0400
In-Reply-To: <1337146409.18429.11.camel@mengcong>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mc@linux.vnet.ibm.com
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, James Bottomley <jbottomley@parallels.com>

On Wed, 2012-05-16 at 13:33 +0800, mengcong wrote:
> The cdrecord uses ATA_PASS_THROUGH_16 command while burning CDs
> with a SATA CD-ROM. This patch adds support to it so that PSCSI 
> CD-ROM passthrough works with the cdrecord.
> 
> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_transport.c |   30 ++++++++++++++++++++++++++++++
>  include/scsi/scsi.h                    |    1 +
>  2 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 2d75c29..41439b3 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2926,6 +2926,36 @@ static int transport_generic_cmd_sequencer(
>  		size = (cdb[7] << 8) | cdb[8];
>  		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
>  		break;
> +	case ATA_PASS_THROUGH_16:
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

Mmmm, I think using SCF_SCSI_CONTROL_SG_IO_CDB here for all ATA
passthrough cases should be OK with pSCSI, but you'll want to fail this
type of cdb when if (!passthrough) for non pSCSI type devices to be safe
with virtual backends..

Also just an FYI, checkpatch.pl will complain here using '//' style
comments, so you'll want to always use '/* ... */' style comments when
submitting a target patch.

So please go ahead and fix up these two bits + use ATA_16 following
jejb's comment, and I'm fine with including your v2 into the for-3.5
target queue..

Thanks!

--nab

