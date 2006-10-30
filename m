From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Mon, 30 Oct 2006 17:32:16 +0100
Message-ID: <45462910.1090409@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0610301017020.6233-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:50119 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S965023AbWJ3QcR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 11:32:17 -0500
In-Reply-To: <Pine.LNX.4.44L0.0610301017020.6233-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> +	int copy_len;
...
> +	copy_len = max((int) sdev->inquiry_len, 36);
> +	sdev->inquiry = kmalloc(copy_len, GFP_ATOMIC);
>  	if (sdev->inquiry == NULL) {
>  		return SCSI_SCAN_NO_RESPONSE;
>  	}
...
> +	memcpy(sdev->inquiry, inq_result, copy_len);
...

Can be written slightly more concise:

	sdev->inquiry = kmemdup(inq_result,
				max_t(size_t, sdev->inquiry_len, 36),
				GFP_ATOMIC);
	if (sdev->inquiry == NULL)
		return SCSI_SCAN_NO_RESPONSE;

This is untested. kmemdup is only available since 2.6.19-rc1.
-- 
Stefan Richter
-=====-=-==- =-=- ====-
http://arcgraph.de/sr/
