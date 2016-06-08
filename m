From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] sd: remove redundant check for BLK_DEF_MAX_SECTORS
Date: Wed, 8 Jun 2016 04:22:21 +0000
Message-ID: <SN1PR0301MB1983F2C779D54D1D4C57086BCE5E0@SN1PR0301MB1983.namprd03.prod.outlook.com>
References: <1465012678-32547-1-git-send-email-longli@microsoft.com>
	<CAGnHSE=ZriFjvdXT5npv92VhqxtN1SqQL+jwMehCq42K3O+=VQ@mail.gmail.com>
	<BLUPR0301MB19724E7E002D1E47719D262CCE5A0@BLUPR0301MB1972.namprd03.prod.outlook.com>
 <yq1vb1lmzqq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:40576
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751608AbcFHEiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2016 00:38:07 -0400
In-Reply-To: <yq1vb1lmzqq.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tom Yan <tom.ty89@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Martin,

Thanks for looking into this. The problem I'm trying to solve is that, I want to have lower layer driver to setup max_sectors bigger than BLK_DEF_MAX_SECTORS. In Hyper-v, we use 2MB max transfer I/O size, in future version the max transfer I/O size will increase to 8MB.
 
The implementation of sd.c limits the maximum value of max_sectors  to BLK_DEF_MAX_SECTORS.  Because sd_revalidate_disk is called late in the SCSI disk initialization process, there is no way for a lower layer driver to set this value to its "bigger" optimal size. 

The reason why I think it may not be necessary for sd.c to setup max_sectors, it's because this value may have already been setup twice before reaching the code in sd.c:
1. When this disk device is first scanned, or re-scanned (in scsi_scan.c), where it eventually calls __scsi_init_queue(), and use the max_sectors in the scsi_host_template.
2. in slave_configure of scsi_host_template, when the lower layer driver implements this function in its template and it can change this value there.

Long

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Monday, June 6, 2016 8:42 PM
> To: Long Li <longli@microsoft.com>
> Cc: Tom Yan <tom.ty89@gmail.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] sd: remove redundant check for
> BLK_DEF_MAX_SECTORS
> 
> >>>>> "Long" == Long Li <longli@microsoft.com> writes:
> 
> Long,
> 
> Long> The reason is that, max_sectors already has value at this point,
> Long> the default value is SCSI_DEFAULT_MAX_SECTORS
> Long> (include/scsi/scsi_host.h). The lower layer host driver can change
> Long> this value in its template.
> 
> The LLD sets max_hw_sectors which indicates the capabilities of the
> controller DMA hardware. Whereas the max_sectors limit is set by sd to
> either follow advise by the device or--if not provided--use the block layer
> default. max_sectors governs the size of READ/WRITE requests and do not
> reflect the capabilities of the DMA hardware.
> 
> Long> I think the drivers care about this value have already set it. So
> Long> it's better not to change it again. If they want max_sectors to be
> Long> set by sd, they can use BLOCK LIMITS VPD to tell it to do so.
> 
> Most drivers don't have the luxury of being able to generate VPDs for their
> attached target devices :)
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
