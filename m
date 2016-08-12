From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/2] libata-scsi: use dev->max_sectors from libata-core appropriately
Date: Fri, 12 Aug 2016 22:31:19 +0800
Message-ID: <CAGnHSEkZrCykRwdmPk8JHdp8NH4W7LQbTAtO6XQ2_NnO-or6Zw@mail.gmail.com>
References: <911c68378b91bf275a4bbed5717b4639641d7029.1471002480.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <911c68378b91bf275a4bbed5717b4639641d7029.1471002480.git.tom.ty89@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 12 August 2016 at 19:56,  <tom.ty89@gmail.com> wrote:
>
> Also note that ATA_HORKAGE_MAX_SEC_LBA48 is not supposed to work
> automatically anyway, even when max_hw_sectors is as high as 65535,
> since the effective max_sectors will be set by the SCSI disk driver.
>
I missed the fact that ATA_HORKAGE_MAX_SEC_LBA48 is only (and should
only be) used by a few ATAPI devices, and the SCSI cdrom devices will
not touch max_sectors like the SCSI disk driver. Therefore, I guess I
should really just use blk_queue_max_hw_sectors() to set both
max_hw_sectors and max_sectors for ATAPI devices. Sending a v2.
