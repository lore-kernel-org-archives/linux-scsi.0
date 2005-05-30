From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 30 May 2005 13:17:20 -0500
Message-ID: <1117477040.4913.12.camel@mulgrave>
References: <20050521232220.GD28654@gmail.com>
	 <1116770040.5002.13.camel@mulgrave> <20050524153930.GA10911@gmail.com>
	 <1117113563.4967.17.camel@mulgrave> <20050526143516.GA9593@gmail.com>
	 <1117118766.4967.22.camel@mulgrave> <20050526173518.GA9132@gmail.com>
	 <1117463938.4913.3.camel@mulgrave> <20050530150950.GA14351@gmail.com>
	 <1117467248.4913.9.camel@mulgrave>  <20050530160147.GD14351@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:36061 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261670AbVE3SRh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 14:17:37 -0400
In-Reply-To: <20050530160147.GD14351@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-30 at 18:01 +0200, Gr=E9goire Favre wrote:
>  target1:0:1: Beginning Domain Validation
>  target1:0:1: Domain Validation skipping write tests
> (scsi1:A:1): 10.000MB/s transfers (10.000MHz, offset 15)
>  target1:0:1: Ending Domain Validation

Well that's good ... it proves the theory that if the DV were correctly
limited initially, everything would work.

However ... lets see if we can get it to work properly even with the
initial mismatch.  Reverse the previous patch, apply this one and try
rebooting ...

Thanks,

James

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1230,6 +1230,9 @@ static void scsi_eh_offline_sdevs(struct
 				scmd->device->channel,
 				scmd->device->id,
 				scmd->device->lun);
+		/* try to reset the bus and the card to a sane state */
+		scsi_try_bus_reset(scmd);
+		scsi_try_host_reset(scmd);
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
 		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
 			/*


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
