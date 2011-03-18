From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] ses: Avoid kernel panic when lun 0 is not mapped
Date: Fri, 18 Mar 2011 09:49:22 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF94513D@cosmail01.lsi.com>
References: <35D9CA00EB0D2346A1F23EB8FC42940A03CC57DAA2@palmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35081 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184Ab1CRPss convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2011 11:48:48 -0400
In-Reply-To: <35D9CA00EB0D2346A1F23EB8FC42940A03CC57DAA2@palmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>

James,  Can you please take a look at this patch.. 

> -----Original Message-----
> From: Krishnasamy, Somasundaram
> Sent: Monday, February 28, 2011 5:13 PM
> To: linux-scsi@vger.kernel.org
> Cc: Moger, Babu
> Subject: [PATCH] ses: Avoid kernel panic when lun 0 is not mapped
> 
> During device discovery, scsi mid layer sends INQUIRY command to LUN 0.
> If the LUN 0 is not mapped to host, it creates a temporary scsi_device
> with LUN id 0 and sends REPORT_LUNS command to it. After the REPORT_LUNS
> succeeds, it walks through the LUN table and adds each LUN found to
> sysfs. At the end of REPORT_LUNS lun table scan, it will delete the
> temporary scsi_device of LUN 0.
> 
> When scsi devices are added to sysfs, it calls add_dev function of all
> the registered class interfaces. If ses driver has been registered,
> ses_intf_add() of ses module will be called. This function calls
> scsi_device_enclosure() to check the inquiry data for EncServ bit. Since
> inquiry was not allocated for temporary LUN 0 scsi_device, it will cause
> NULL pointer exception.
> 
> To fix the problem, sdev->inquiry is checked for NULL before reading it.
> 
> Signed-off-by: Somasundaram Krishnasamy
> <Somasundaram.Krishnasamy@lsi.com>
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> ---
> --- linux-2.6.38-rc6/include/scsi/scsi_device.h.orig	2011-02-28
> 16:12:51.000000000 -0600
> +++ linux-2.6.38-rc6/include/scsi/scsi_device.h	2011-02-28
> 16:16:02.000000000 -0600
> @@ -461,7 +461,7 @@ static inline int scsi_device_qas(struct
>  }
>  static inline int scsi_device_enclosure(struct scsi_device *sdev)
>  {
> -	return sdev->inquiry[6] & (1<<6);
> +	return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
>  }
> 
>  static inline int scsi_device_protection(struct scsi_device *sdev)
> 

