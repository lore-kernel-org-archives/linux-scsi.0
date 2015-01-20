From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] scsi: qla2xxx: print port name via %*phC
Date: Tue, 20 Jan 2015 15:39:30 -0800
Message-ID: <1421797170.9970.11.camel@haakon3.risingtidesystems.com>
References: <1421321287-22235-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49093 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbbATXjc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2015 18:39:32 -0500
In-Reply-To: <1421321287-22235-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: qla2xxx-upstream@qlogic.com, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, 2015-01-15 at 13:28 +0200, Andy Shevchenko wrote:
> Instead of pushing each byte via stack let's use custom specifier which allows
> to print small buffers as a hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 73f9fee..99f43b7 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1570,9 +1570,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
>  	 * match the format by tcm_qla2xxx explict ConfigFS NodeACLs.
>  	 */
>  	memset(&port_name, 0, 36);
> -	snprintf(port_name, 36, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
> -		fc_wwpn[0], fc_wwpn[1], fc_wwpn[2], fc_wwpn[3], fc_wwpn[4],
> -		fc_wwpn[5], fc_wwpn[6], fc_wwpn[7]);
> +	snprintf(port_name, sizeof(port_name), "%8phC", fc_wwpn);
>  	/*
>  	 * Locate our struct se_node_acl either from an explict NodeACL created
>  	 * via ConfigFS, or via running in TPG demo mode.

Picking this one up, since it's specific to tcm_qla2xxx code.

Applied to target-pending/for-next.

Thanks Andy!

--nab


