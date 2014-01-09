From: Sagi Grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 02/14] target: Add DIF CHECK_CONDITION ASC/ASCQ exception
 cases
Date: Thu, 9 Jan 2014 12:43:11 +0200
Message-ID: <52CE7D3F.7030308@mellanox.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com> <1389212157-14540-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-3-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds support for DIF related CHECK_CONDITION ASC/ASCQ
> exception cases into transport_send_check_condition_and_sense().
>
> This includes:
>
>    LOGICAL BLOCK GUARD CHECK FAILED
>    LOGICAL BLOCK APPLICATION TAG CHECK FAILED
>    LOGICAL BLOCK REFERENCE TAG CHECK FAILED
>
> that used by DIF TYPE1 and TYPE3 failure cases.
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_transport.c |   30 ++++++++++++++++++++++++++++++
>   include/target/target_core_base.h      |    3 +++
>   2 files changed, 33 insertions(+)
>
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 91953da..707ee17 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2648,6 +2648,36 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
>   		buffer[SPC_ASC_KEY_OFFSET] = 0x1d;
>   		buffer[SPC_ASCQ_KEY_OFFSET] = 0x00;
>   		break;
> +	case TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED:
> +		/* CURRENT ERROR */
> +		buffer[0] = 0x70;
> +		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
> +		/* ILLEGAL REQUEST */
> +		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
> +		/* LOGICAL BLOCK GUARD CHECK FAILED */
> +		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
> +		buffer[SPC_ASCQ_KEY_OFFSET] = 0x01;

You have Enums for ASCQs (TARGET_GUARD_CHECK_FAILED, 
TARGET_APPTAG_CHECK_FAILED, TARGET_REFTAG_CHECK_FAILED). either use them 
or loose them.

> +		break;
> +	case TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED:
> +		/* CURRENT ERROR */
> +		buffer[0] = 0x70;
> +		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
> +		/* ILLEGAL REQUEST */
> +		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
> +		/* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
> +		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
> +		buffer[SPC_ASCQ_KEY_OFFSET] = 0x02;
> +		break;
> +	case TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED:
> +		/* CURRENT ERROR */
> +		buffer[0] = 0x70;
> +		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
> +		/* ILLEGAL REQUEST */
> +		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
> +		/* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
> +		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
> +		buffer[SPC_ASCQ_KEY_OFFSET] = 0x03;
> +		break;
>   	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
>   	default:
>   		/* CURRENT ERROR */
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 15f402c..9a6e091 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -206,6 +206,9 @@ enum tcm_sense_reason_table {
>   	TCM_OUT_OF_RESOURCES			= R(0x12),
>   	TCM_PARAMETER_LIST_LENGTH_ERROR		= R(0x13),
>   	TCM_MISCOMPARE_VERIFY			= R(0x14),
> +	TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED	= R(0x15),
> +	TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED	= R(0x16),
> +	TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED	= R(0x17),
>   #undef R
>   };
>   
