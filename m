From: Ankit Jain <jankit@suse.de>
Subject: Re: [PATCH] scsi_io_completion: extend description of default host-byte
 handling
Date: Fri, 14 Oct 2011 03:38:52 +0530
Message-ID: <4E976174.5050403@suse.de>
References: <1318541476-27243-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab1JMWGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2011 18:06:00 -0400
In-Reply-To: <1318541476-27243-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 10/14/2011 03:01 AM, Rob Evers wrote:
> replace "unhandled error code" message in scsi_io_completion default
> host-byte condition with a descriptive message of what the host-byte
> indicates.  The descriptive messages for the host bytes were derived
> from the corresponding comments for the DID_HOST_ definitions in scsi.h.
> 
> Also softened the corresponding default sense code message.
> 
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
>  drivers/scsi/constants.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/scsi_lib.c  |    4 ++--
>  include/scsi/scsi_dbg.h  |    1 +
>  3 files changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 450e011..900333c 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1422,9 +1422,52 @@ static const char * const hostbyte_table[]={
>  "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
>  "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
>  "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
> -"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST" };
> +"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
> +"DID_NEXUS_FAILURE" };
>  #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
>  
> +/*
> + * derived from comments following 'Host byte codes' in scsi.h
> + */
> +static char *hostbyte_table_ext_msg[] = {
> +	"No Error",
> +	"Couldn't connect before timeout period",
> +	"Bus stayed busy through timeout period",
> +	"Timed out for other reason",
> +	"Bad target",
> +	"Abort for some other reason",
> +	"Parity Error",
> +	"Internal Error",
> +	"Reset",
> +	"Interrupt that is not expected",
> +	"Force command past mid-layer",
> +	"Low level driver requests a retry",
> +	"Retry immediately, don't decrement retry count",
> +	"Requeue command, not immediate, don't decrement retry count",
> +	"Transport disrupted, driver blocked port to recover link, transport class will retry or fail the IO",
> +	"Transport class fastfailed the IO",
> +	"Permanent target failure, don't retry other paths",
> +	"Permanent nexus failure, retry on other paths may yield different results"
> +};
> +#define NUM_HOSTBYTE_EXT_MSG_STRS ARRAY_SIZE(hostbyte_table_ext_msg)
> +
> +#endif
> +
> +char *
> +scsi_ext_host_byte_msg(unsigned char index)
> +{
> +#ifdef CONFIG_SCSI_CONSTANTS
> +	if (index < NUM_HOSTBYTE_EXT_MSG_STRS)
> +		return hostbyte_table_ext_msg[index];
> +	else
> +		return NULL;

Some message, rather than nothing(NULL) would be more useful, IMHO.

> +#else
> +	return NULL;
> +#endif

Wouldn't it be better to fallback to "Unhandled error code" in case
CONFIG_SCSI_CONSTANTS is not defined? Maybe same for the earlier comment?

-- 
Ankit Jain
SUSE Labs
