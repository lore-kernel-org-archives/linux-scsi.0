From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: RE:[PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Mon, 24 Jun 2013 12:17:33 +0200
Message-ID: <51C81CBD.5070709@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:61104 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3FXKRj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 06:17:39 -0400
Received: by mail-bk0-f44.google.com with SMTP id r7so4099951bkg.3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jun 2013 03:17:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>

> @@ -646,14 +703,20 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
>  static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
>  {
>         int rtn;
> -       struct scsi_host_template *hostt = scmd->device->host->hostt;
> +       struct Scsi_Host *host = scmd->device->host;
> +       struct scsi_host_template *hostt = host->hostt;
> 
>         if (!hostt->eh_device_reset_handler)
>                 return FAILED;
> 
> +       if (scsi_begin_eh(host))
> +               return FAST_IO_FAIL;
> +
>         rtn = hostt->eh_device_reset_handler(scmd);
>         if (rtn == SUCCESS)
>                 __scsi_report_device_reset(scmd->device, NULL);
> +       scsi_end_eh(host);
> +
>         return rtn;
>  }

As the new eh from Hannes haven't make it into mainline, maybe we still
need also check scsi_try_to_abort_cmd?

Jack
