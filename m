From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] target: change sprintf to snprintf
Date: Fri, 18 Jan 2013 11:36:52 -0800
Message-ID: <1358537812.18551.446.camel@haakon2.linux-iscsi.org>
References: <20130118130512.GA1634@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20130118130512.GA1634@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-01-18 at 16:05 +0300, Dan Carpenter wrote:
> "buf" is 128 characters and "vpd->device_identifier" is 256.  It makes
> the static checkers complain.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Applied to target-pending/for-next.

> Probably we should just raise VPD_TMP_BUF_SIZE to 300.

Also bumping up VPD_TMP_BUF_SIZE to 254 to match the usage with
INQUIRY_VPD_DEVICE_IDENTIFIER_LEN sized vpd->device_identifier[] below.

Thanks Dan!

--nab

> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index bd587b7..96b64d5 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -907,15 +907,18 @@ int transport_dump_vpd_ident(
>  
>  	switch (vpd->device_identifier_code_set) {
>  	case 0x01: /* Binary */
> -		sprintf(buf, "T10 VPD Binary Device Identifier: %s\n",
> +		snprintf(buf, sizeof(buf),
> +			"T10 VPD Binary Device Identifier: %s\n",
>  			&vpd->device_identifier[0]);
>  		break;
>  	case 0x02: /* ASCII */
> -		sprintf(buf, "T10 VPD ASCII Device Identifier: %s\n",
> +		snprintf(buf, sizeof(buf),
> +			"T10 VPD ASCII Device Identifier: %s\n",
>  			&vpd->device_identifier[0]);
>  		break;
>  	case 0x03: /* UTF-8 */
> -		sprintf(buf, "T10 VPD UTF-8 Device Identifier: %s\n",
> +		snprintf(buf, sizeof(buf),
> +			"T10 VPD UTF-8 Device Identifier: %s\n",
>  			&vpd->device_identifier[0]);
>  		break;
>  	default:
