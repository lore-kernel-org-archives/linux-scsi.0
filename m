From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: 29 Sep 2004 10:34:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096468472.2123.17.camel@mulgrave>
References: <1096401785.13936.5.camel@localhost.localdomain>
	<1096467125.2028.11.camel@mulgrave>
	<1096464245.15907.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:51936 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268582AbUI2Oee (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 10:34:34 -0400
In-Reply-To: <1096464245.15907.27.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-09-29 at 09:24, Alan Cox wrote:
>         badness in kref_get
>                 kobject_get, get_device, scsi_request_fn
>                 blk_insert_request, scsi_queue_insert
>                 scsi_eh_flush_done_q, scsi_unjam_host
>                 scsi_error_handler

Yes .. this is the significant one ... we're trying to get a reference
to a device that has already been released

>         OOPS scsi_device_dev_release
>                 device_release
>                 kobject_cleanup
>                 kobject_release
>                 kref_put
>                 scsi_request_fn

James


