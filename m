From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 7/9] ufs: sysfs: unit descriptor
Date: Wed, 27 Dec 2017 16:23:06 +0100
Message-ID: <20171227152306.GH20967@kroah.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514387627-27817-8-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514387627-27817-8-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 27, 2017 at 05:13:45PM +0200, Stanislav Nijnikov wrote:
> This patch introduces a sysfs group entry for the UFS unit descriptor
> parameters. The group adds "unit_descriptor" folder under the corresponding
> SCSI device sysfs entry (/sys/class/scsi_device/*/device/). The parameters
> are shown as hexadecimal numbers. The full information about the parameters
> could be found at UFS specifications 2.1.
> In addition the patch presents an additional field in the
> scsi_host_template structure - struct attribute_group **sdev_group.
> This field allows to define groups of attributes. It will provide an
> ability to use binary attributes in addition to device attributes and
> to group them under subfolders if necessary.
> 
> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 108 +++++++++++++++++++++++++++++
>  drivers/scsi/scsi_sysfs.c                  |  14 ++++
>  drivers/scsi/ufs/ufs-sysfs.c               |  58 ++++++++++++++++
>  drivers/scsi/ufs/ufs-sysfs.h               |   3 +
>  drivers/scsi/ufs/ufs.h                     |  11 +++
>  drivers/scsi/ufs/ufshcd.c                  |  23 ++----
>  drivers/scsi/ufs/ufshcd.h                  |  15 ++++
>  include/scsi/scsi_host.h                   |   6 ++
>  8 files changed, 222 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index 736280e..5ff8dfa 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -489,4 +489,112 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file contains a product revision string. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +		The file is read only.
> +
> +
> +What:		/sys/class/scsi_device/*/device/unit_descriptor/boot_lun_id
> +Date:		August 2017

Minor nit for all of these, August 2017 was a few months ago :)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
