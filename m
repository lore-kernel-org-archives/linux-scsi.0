From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH] [SCSI] pm8001 DEV_IS_GONE infinite retry
Date: Mon, 26 Sep 2011 10:20:39 +0800
Message-ID: <5675343CD6004372A7AB259CFE619A9D@usish.com.cn>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE2D8@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:52181 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1IZCUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2011 22:20:19 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2D8@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@us.xyratex.com>, linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <jbottomley@parallels.com>

Hi Mark

Thanks for your fix. You can add my acked.
Acked-by: Jack Wang <jack_wang@usish.com>.

Ps, your signed-off-by mail addr is not same with your sender mail address,
is this a mistake?

Re [PATCH] [SCSI] pm8001 DEV_IS_GONE infinite retry
> 
> On the pm8001, when a device is in the process of going away (device
> power off or hot plug), depending on the timing, the driver would return
> SAS_PHY_DOWN as the return value to the queuecommand DEV_IS_GONE logic.
> The net result is an near infinite retry (especially if SAS debugging is
> enabled), the logs will fill with:
> 
> kernel: mpi_ssp_completion 2119:e21:SSP IO status 0x13 tag 0xcc1c0000
> dlen=90 param=0xe
> kernel: wwn=5000c50034069e86  cdb=12 00 00 00 5a 00 00 00 00 00 00 00 00
> 00 00 00
> kernel: sas: lldd_execute_task returned: 138
> kernel: sas: lldd_execute_task returned: 138
> kernel: sas: lldd_execute_task returned: 138
> kernel: sas: lldd_execute_task returned: 138
> kernel: sas: lldd_execute_task returned: 138
> kernel: sas: lldd_execute_task returned: 138
> kernel: sas: lldd_execute_task returned: 138
> . . .
> 
> This patch changes to leverage the port_attached logic to complete the
> command with a status of PHY_DOWN so that the disposition can be handled
> immediately and correctly.
> 
> The real patch is enclosed as an attachment since Outlook is my current
> MTA.
> 
> Signed-off-by: Mark Salyzyn <mark_salyzyn@xyus.xyratex.com>
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Jack Wang <jack_wang@usish.com>
> 
>  pm8001_sas.c |   15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff -ru scsi-misc-2.6/drivers/scsi/pm8001/pm8001_sas.c
> scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_sas.c
> --- scsi-misc-2.6/drivers/scsi/pm8001/pm8001_sas.c	2011-08-31
> 08:32:21.000000000 -0400
> +++ scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_sas.c	2011-09-22
> 11:36:24.000000000 -0400
> @@ -385,21 +385,8 @@
>  	do {
>  		dev = t->dev;
>  		pm8001_dev = dev->lldd_dev;
> -		if (DEV_IS_GONE(pm8001_dev)) {
> -			if (pm8001_dev) {
> -				PM8001_IO_DBG(pm8001_ha,
> -					pm8001_printk("device %d not
> ready.\n",
> -					pm8001_dev->device_id));
> -			} else {
> -				PM8001_IO_DBG(pm8001_ha,
> -					pm8001_printk("device %016llx
> not "
> -					"ready.\n",
> SAS_ADDR(dev->sas_addr)));
> -			}
> -			rc = SAS_PHY_DOWN;
> -			goto out_done;
> -		}
>  		port = &pm8001_ha->port[sas_find_local_port_id(dev)];
> -		if (!port->port_attached) {
> +		if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
>  			if (sas_protocol_ata(t->task_proto)) {
>  				struct task_status_struct *ts =
> &t->task_status;
>  				ts->resp = SAS_TASK_UNDELIVERED;
> 
> ______________________________________________________________________
> This email may contain privileged or confidential information, which
should
> only be used for the purpose for which it was sent by Xyratex. No further
rights
> or licenses are granted to use such information. If you are not the
intended
> recipient of this message, please notify the sender by return and delete
it.
> You may not use, copy, disclose or rely on the information contained in
it.
> 
> Internet email is susceptible to data corruption, interception and
> unauthorised amendment for which Xyratex does not accept liability. While
we
> have taken reasonable precautions to ensure that this email is free of
viruses,
> Xyratex does not accept liability for the presence of any computer viruses
in
> this email, nor for any losses caused as a result of viruses.
> 
> Xyratex Technology Limited (03134912), Registered in England & Wales,
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
> The Xyratex group of companies also includes, Xyratex Ltd, registered in
> Bermuda, Xyratex International Inc, registered in California, Xyratex
> (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co
Ltd
> registered in The People's Republic of China and Xyratex Japan Limited
> registered in Japan.
> ______________________________________________________________________
> 
> 


