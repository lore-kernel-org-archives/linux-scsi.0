From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 02/17] target: Add DIF CHECK_CONDITION ASC/ASCQ exception
 cases
Date: Wed, 22 Jan 2014 18:44:30 +0200
Message-ID: <52DFF56E.2010502@dev.mellanox.co.il>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com> <1390099480-29013-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-3-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Oren Duer <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 1/19/2014 4:44 AM, Nicholas A. Bellinger wrote:
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
> index 18c828d..fa4fc04 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2674,6 +2674,36 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
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

Hey Nic,

I think we missed the failed LBA here. AFAICT According to SPC-4, a DIF
error should be accompanied by Information sense-data descriptor with 
the (first) failed
sector in the information field. This means that this routine should be 
ready to accept a
u32 bad_sector or something. I'm not sure how much of a must it really is.

Let me prepare a patch...

Sagi.

>   	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
>   	default:
>   		/* CURRENT ERROR */
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index d98048b..0336d70 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -205,6 +205,9 @@ enum tcm_sense_reason_table {
>   	TCM_OUT_OF_RESOURCES			= R(0x12),
>   	TCM_PARAMETER_LIST_LENGTH_ERROR		= R(0x13),
>   	TCM_MISCOMPARE_VERIFY			= R(0x14),
> +	TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED	= R(0x15),
> +	TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED	= R(0x16),
> +	TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED	= R(0x17),
>   #undef R
>   };
>   
