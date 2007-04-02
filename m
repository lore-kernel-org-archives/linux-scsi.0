From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 1/1] scsi: Disable short inquiry log by default
Date: Mon, 2 Apr 2007 15:35:39 -0600
Message-ID: <20070402213539.GI826@parisc-linux.org>
References: <200704022120.l32LKOZU018499@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43692 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965920AbXDBVfk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 17:35:40 -0400
Content-Disposition: inline
In-Reply-To: <200704022120.l32LKOZU018499@d03av02.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Apr 02, 2007 at 04:20:22PM -0500, brking@linux.vnet.ibm.com wrote:
>  	if (sdev->inquiry_len < 36) {
> -		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
> -				" using 36\n", sdev->inquiry_len);
> +		SCSI_LOG_SCAN_BUS(1, printk(KERN_INFO "scsi scan: INQUIRY result too"
> +					    " short (%d), using 36\n", sdev->inquiry_len));
>  		sdev->inquiry_len = 36;

The wrapping's a bit awkward.  How about:
+		SCSI_LOG_SCAN_BUS(1, printk(KERN_INFO "scsi scan: INQUIRY "
+					"result too short (%d), using 36\n",
+					sdev->inquiry_len);
