From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Mon, 18 Feb 2008 15:34:54 -0800
Message-ID: <20080218233454.GD12905@tpepper-t42p.dolavim.us>
References: <20080213214324.GB18227@tpepper-t42p.dolavim.us> <532ABFBDAAC3A34EB12EBA6CEC2838F439964688@ADPE2K703.adaptec.com> <20080214000417.GA2741@tpepper-t42p.dolavim.us> <532ABFBDAAC3A34EB12EBA6CEC2838F4399FCFC9@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51268 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYBRXe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 18:34:56 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1INYuRq017197
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:34:56 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1INYtxv220600
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:34:55 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1INYt15025455
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 18:34:55 -0500
Content-Disposition: inline
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F4399FCFC9@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Mon 18 Feb at 06:57:14 -0800 Mark_Salyzyn@adaptec.com said:
> The path needs to be triggered, it is the path to handle spoofing
> of the Adapter's inquiry.
> 
> You need more printk instrumentation to determine *why* it is not
> reaching that code path. What is the result of scb->scsi_cmd.
> scb->bus, ips_is_passthru(scb->scsi_cmd)?
> 
> The sg breakup issue may need to be looked at, but keep in mind
> the driver is going down a path that was not intended.

Mark,

Fujita Tomonori has noted the following:

-       scsi_add_host(sh, NULL);
+       scsi_add_host(sh, &ha->pcidev->dev);

which appears to fix things for me.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
