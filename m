From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/4] [SCSI] Blacklist RSOC for Microsoft iSCSI target
 devices
Date: Thu, 04 Dec 2014 19:24:39 -0600
Message-ID: <54810957.8080706@cs.wisc.edu>
References: <1417659492-2679-1-git-send-email-martin.petersen@oracle.com> <1417659492-2679-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41223 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaLEBYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 20:24:48 -0500
In-Reply-To: <1417659492-2679-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org.#.v3.10+

On 12/3/14, 8:18 PM, Martin K. Petersen wrote:
> The Microsoft iSCSI target does not support REPORT SUPPORTED OPERATION
> CODES. Blacklist these devices so we don't attempt to send the command.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: jazz@deti74.ru
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: stable@vger.kernel.org # v3.10+
> ---
>   drivers/scsi/scsi_devinfo.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 8c228e049bb6..db42c37e1230 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -210,6 +210,7 @@ static struct {
>   	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
>   	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
>   	{"MICROP", "4110", NULL, BLIST_NOTQ},
> +	{"MSFT", "Virtual HD", NULL, BLIST_NO_RSOC},
>   	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
>   	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
>   	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>

Thanks Martin.

Tested-by: Mike Christie <michaelc@cs.wisc.edu>

In case other people test this patch, I wanted to warn people that the 
MS iSCSI target does the same sequence (sends reject PDU then drops the 
connection on us) for any command it does not support. We end up seeing 
the same problem for other commands. For example, some distros have 
tools that send CDB 0x85 during initialization, and the MS target will 
fail on that in the same way we saw here.
