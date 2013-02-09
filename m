From: Chris Boot <bootc@bootc.net>
Subject: Re: [PATCH 2/3] target: Fix error checking for UNMAP commands
Date: Sat, 09 Feb 2013 09:23:31 +0000
Message-ID: <51161593.9030007@bootc.net>
References: <1360365520-11972-1-git-send-email-roland@kernel.org> <1360365520-11972-2-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1360365520-11972-2-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On 08/02/2013 23:18, Roland Dreier wrote:
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index b526d23..b72ca5b 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -2674,6 +2675,15 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
>   		/* INVALID FIELD IN PARAMETER LIST */
>   		buffer[SPC_ASC_KEY_OFFSET] = 0x26;
>   		break;
> +	case TCM_PARAMETER_LIST_LENGTH_ERROR:
> +		/* CURRENT ERROR */
> +		buffer[0] = 0x70;
> +		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
> +		/* ILLEGAL REQUEST */
> +		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
> +		/* INVALID FIELD IN PARAMETER LIST */
> +		buffer[SPC_ASC_KEY_OFFSET] = 0x1a;
> +		break;
>   	case TCM_UNEXPECTED_UNSOLICITED_DATA:
>   		/* CURRENT ERROR */
>   		buffer[0] = 0x70;

Nitpick: I suspect a simple copy & paste error; "INVALID FIELD IN 
PARAMETER LIST" in your comment should probably read "PARAMETER LIST 
LENGTH ERROR" instead.

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net
