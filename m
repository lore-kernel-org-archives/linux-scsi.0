From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [patch v2] scsi_dh_alua: uninitialized variable in
 alua_check_vpd()
Date: Fri, 11 Mar 2016 08:40:17 -0600
Message-ID: <56E2D8D1.7040306@linux.vnet.ibm.com>
References: <20160311111903.GA12332@mwanda>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:41639 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389AbcCKOjj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 09:39:39 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Fri, 11 Mar 2016 07:39:38 -0700
In-Reply-To: <20160311111903.GA12332@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On 3/11/2016 5:19 AM, Dan Carpenter wrote:
> The pg_updated variable is support to be set to false at the start but
> it is uninitialized.
>
> Fixes: cb0a168cb6b8 ('scsi_dh_alua: update 'access_state' field')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 5bcdf8d..a404a41 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -332,7 +332,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
>   {
>   	int rel_port = -1, group_id;
>   	struct alua_port_group *pg, *old_pg = NULL;
> -	bool pg_updated;
> +	bool pg_updated = false;
>   	unsigned long flags;

Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

---
Manoj Kumar


