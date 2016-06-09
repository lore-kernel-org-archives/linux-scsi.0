From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: remove redundant check for BLK_DEF_MAX_SECTORS
Date: Wed, 08 Jun 2016 23:29:33 -0400
Message-ID: <yq1fusnjazm.fsf@sermon.lab.mkp.net>
References: <1465012678-32547-1-git-send-email-longli@microsoft.com>
	<CAGnHSE=ZriFjvdXT5npv92VhqxtN1SqQL+jwMehCq42K3O+=VQ@mail.gmail.com>
	<BLUPR0301MB19724E7E002D1E47719D262CCE5A0@BLUPR0301MB1972.namprd03.prod.outlook.com>
	<yq1vb1lmzqq.fsf@sermon.lab.mkp.net>
	<SN1PR0301MB1983F2C779D54D1D4C57086BCE5E0@SN1PR0301MB1983.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN1PR0301MB1983F2C779D54D1D4C57086BCE5E0@SN1PR0301MB1983.namprd03.prod.outlook.com>
	(Long Li's message of "Wed, 8 Jun 2016 04:22:21 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Yan <tom.ty89@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Long" == Long Li <longli@microsoft.com> writes:

Long,

Long> The problem I'm trying to solve is that, I want to have lower
Long> layer driver to setup max_sectors bigger than
Long> BLK_DEF_MAX_SECTORS.

Capping at BLK_DEF_MAX_SECTORS unless a device has explicitly reported
requirements is intentional. We have not had good experiences with
making I/O requests too big in general. So BLK_DEF_MAX_SECTORS has
deliberately been kept small. However, it was recently bumped to 1MB and
change by default.

Long> n Hyper-v, we use 2MB max transfer I/O size, in future version the
Long> max transfer I/O size will increase to 8MB.

But presumably you provide a BLOCK LIMITS VPD for your virtual targets?

Long> The reason why I think it may not be necessary for sd.c to setup
Long> max_sectors, it's because this value may have already been setup
Long> twice before reaching the code in sd.c: 1. When this disk device
Long> is first scanned, or re-scanned (in scsi_scan.c), where it
Long> eventually calls __scsi_init_queue(), and use the max_sectors in
Long> the scsi_host_template.  2. in slave_configure of
Long> scsi_host_template, when the lower layer driver implements this
Long> function in its template and it can change this value there.

Those cause limits to be set for the controller. We won't know the
device limits until we hit revalidate.

blk_queue_max_hw_sectors() will also clamp the R/W max at
BLK_DEF_MAX_SECTORS, though.

-- 
Martin K. Petersen	Oracle Linux Engineering
