From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: Remove unreachable code
Date: Mon, 8 Jul 2019 08:04:50 -0700
Message-ID: <82794d9a-8f36-7012-da6a-1e05ce2bb3cb@acm.org>
References: <1562234156-11945-1-git-send-email-dingxiang@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1562234156-11945-1-git-send-email-dingxiang@cmss.chinamobile.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ding Xiang <dingxiang@cmss.chinamobile.com>, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/4/19 2:55 AM, Ding Xiang wrote:
> The return code after switch default is unreachable,
> so remove it.
> 
> Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
> ---
>   drivers/scsi/scsi_error.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index bfa569f..12180f0 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1909,7 +1909,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>   	default:
>   		return FAILED;
>   	}
> -	return FAILED;

I'd rather remove the "default: return FAILED;" code than make the above 
change. If status_byte() ever would be changed into an inline function 
that returns an enum then my alternative will allow the compiler to 
verify whether all enum labels have been handled. No such check will be 
performed if the above patch would be applied.

Bart.
