From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Fix for Login failure
Date: Thu, 12 Aug 2010 13:24:38 -0500
Message-ID: <4C643C66.8030507@cs.wisc.edu>
References: <20100812180547.GA8202@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47275 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760722Ab0HLSU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 14:20:26 -0400
In-Reply-To: <20100812180547.GA8202@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 08/12/2010 01:06 PM, Jayamohan Kallickal wrote:
>     The current code in tree has problems with Login.
> This patch fixes the Login Failure .
>
>   This patch has been made on the latest scsi-misc tree pulled today
>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> ---
>   drivers/scsi/be2iscsi/be_iscsi.c |    5 ++---
>   drivers/scsi/be2iscsi/be_mgmt.c  |    2 +-
>   2 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index 7d4d227..7f11f3e 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -300,8 +300,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
>   			   enum iscsi_host_param param, char *buf)
>   {
>   	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
> -	int len = 0;
> -	int status;
> +	int status = 0;
>
>   	SE_DEBUG(DBG_LVL_8, "In beiscsi_get_host_param, param= %d\n", param);
>   	switch (param) {
> @@ -315,7 +314,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
>   	default:
>   		return iscsi_host_get_param(shost, param, buf);
>   	}
> -	return len;
> +	return status;

Can't believe I missed that.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
