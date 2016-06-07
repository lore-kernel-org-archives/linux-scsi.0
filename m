From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: remove redundant check for BLK_DEF_MAX_SECTORS
Date: Mon, 06 Jun 2016 23:42:05 -0400
Message-ID: <yq1vb1lmzqq.fsf@sermon.lab.mkp.net>
References: <1465012678-32547-1-git-send-email-longli@microsoft.com>
	<CAGnHSE=ZriFjvdXT5npv92VhqxtN1SqQL+jwMehCq42K3O+=VQ@mail.gmail.com>
	<BLUPR0301MB19724E7E002D1E47719D262CCE5A0@BLUPR0301MB1972.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BLUPR0301MB19724E7E002D1E47719D262CCE5A0@BLUPR0301MB1972.namprd03.prod.outlook.com>
	(Long Li's message of "Sat, 4 Jun 2016 15:18:43 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>
Cc: Tom Yan <tom.ty89@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Long" == Long Li <longli@microsoft.com> writes:

Long,

Long> The reason is that, max_sectors already has value at this point,
Long> the default value is SCSI_DEFAULT_MAX_SECTORS
Long> (include/scsi/scsi_host.h). The lower layer host driver can change
Long> this value in its template.

The LLD sets max_hw_sectors which indicates the capabilities of the
controller DMA hardware. Whereas the max_sectors limit is set by sd to
either follow advise by the device or--if not provided--use the block
layer default. max_sectors governs the size of READ/WRITE requests and
do not reflect the capabilities of the DMA hardware.

Long> I think the drivers care about this value have already set it. So
Long> it's better not to change it again. If they want max_sectors to be
Long> set by sd, they can use BLOCK LIMITS VPD to tell it to do so.

Most drivers don't have the luxury of being able to generate VPDs for
their attached target devices :)

-- 
Martin K. Petersen	Oracle Linux Engineering
