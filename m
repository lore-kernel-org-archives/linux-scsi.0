From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 03/13] mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices
Date: Thu, 27 Jul 2017 09:26:32 -0400
Message-ID: <yq1a83qvwmv.fsf@oracle.com>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        <1500038560-11231-4-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500038560-11231-4-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Fri, 14 Jul 2017 18:52:30 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Suganath,

> * Added support for translating the SGLs associated with incoming
> commands either to IEE SGL or NVMe PRPs for NVMe devices.

This all seems very convoluted. You should rely on the block layer
infrastructure instead of doing all this slicing and dicing by hand.

If the attached device is an NVMe drive, call blk_queue_virt_boundary()
and you will only receive requests that are suitable for a device with
PRP-style scatterlist constraints.

-- 
Martin K. Petersen	Oracle Linux Engineering
