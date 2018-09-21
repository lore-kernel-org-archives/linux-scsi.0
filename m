From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: advansys: Remove unnecessary parentheses
Date: Fri, 21 Sep 2018 07:57:31 +0200
Message-ID: <9432dde7-c63f-9c0c-fc9b-8728a0715ff3@suse.com>
References: <20180920205858.6035-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920205858.6035-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9/20/18 10:58 PM, Nathan Chancellor wrote:
> Clang warns when multiple pairs of parentheses are used for a single
> conditional statement.
> 
> drivers/scsi/advansys.c:6451:20: warning: equality comparison with
> extraneous parentheses [-Wparentheses-equality]
>                                  if ((sdtr_data == 0xFF)) {
>                                       ~~~~~~~~~~^~~~~~~
> drivers/scsi/advansys.c:6451:20: note: remove extraneous parentheses
> around the comparison to silence this warning
>                                  if ((sdtr_data == 0xFF)) {
>                                      ~          ^      ~
> drivers/scsi/advansys.c:6451:20: note: use '=' to turn this equality
> comparison into an assignment
>                                  if ((sdtr_data == 0xFF)) {
>                                                 ^~
>                                                 =
> 1 warning generated.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/155
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>   drivers/scsi/advansys.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 713f69033f20..44c96199e00a 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -6448,7 +6448,7 @@ static void AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
>   				sdtr_data =
>   				    AscCalSDTRData(asc_dvc, ext_msg.xfer_period,
>   						   ext_msg.req_ack_offset);
> -				if ((sdtr_data == 0xFF)) {
> +				if (sdtr_data == 0xFF) {
>   
>   					q_cntl |= QC_MSG_OUT;
>   					asc_dvc->init_sdtr &= ~target_id;
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
