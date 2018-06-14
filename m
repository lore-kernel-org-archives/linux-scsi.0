From: "sayali" <sayalil@codeaurora.org>
Subject: RE: [PATCH V2 3/3] scsi: ufs: Add sysfs support for ufs provision
Date: Thu, 14 Jun 2018 17:22:01 +0530
Message-ID: <000301d403d6$1ed2e790$5c78b6b0$@codeaurora.org>
References: <1528455990-24572-1-git-send-email-sayalil@codeaurora.org> <1528455990-24572-4-git-send-email-sayalil@codeaurora.org> <20180609072454.GH24148@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180609072454.GH24148@kroah.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, linux-scsi@vger.kernel.org, 'Stanislav Nijnikov' <stanislav.nijnikov@wdc.com>, 'Adrian Hunter' <adrian.hunter@intel.com>, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org] 
Sent: Saturday, June 09, 2018 12:55 PM
To: Sayali Lokhande <sayalil@codeaurora.org>
Cc: subhashj@codeaurora.org; cang@codeaurora.org;
vivek.gautam@codeaurora.org; rnayak@codeaurora.org; vinholikatti@gmail.com;
jejb@linux.vnet.ibm.com; martin.petersen@oracle.com;
asutoshd@codeaurora.org; evgreen@chromium.org; linux-scsi@vger.kernel.org;
Stanislav Nijnikov <stanislav.nijnikov@wdc.com>; Adrian Hunter
<adrian.hunter@intel.com>; open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] scsi: ufs: Add sysfs support for ufs provision

On Fri, Jun 08, 2018 at 04:36:30PM +0530, Sayali Lokhande wrote:
> Add sysfs support to trigger ufs provisioning at runtime.
> Usage : echo <desc_buf> > /sys/bus/platform/drivers/*/
> 	config_descriptor/ufs_provision
> To check provisioning status:
> cat /sys/bus/platform/drivers/*/config_descriptor/ufs_provision
> 1- > Success (Reboot device to check updated provisioning)
> 
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs |  16 ++++
>  drivers/scsi/ufs/ufs-sysfs.c               |  25 ++++++
>  drivers/scsi/ufs/ufs.h                     |   2 +
>  drivers/scsi/ufs/ufshcd.c                  | 128
+++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h                  |   5 ++
>  5 files changed, 176 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs 
> b/Documentation/ABI/testing/sysfs-driver-ufs
> index 016724e..43419b5 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -883,3 +883,19 @@ Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry shows the target state of an UFS UIC link
>  		for the chosen system power management level.
>  		The file is read only.
> +
> +What:
/sys/bus/platform/drivers/ufshcd/*/config_descriptor/ufs_provision
> +Date:		February 2018
> +Contact:	Sayali Lokhande <sayalil@codeaurora.org>
> +Description:	This file shows the status of runtime ufs provisioning.
> +		This can be used to provision ufs device if bConfigDescrLock
is 0.
> +		Configuration buffer needs to be written in space separated
format
> +		specificied as:
> +		echo <bNumberLU> <bBootEnable> <bDescrAccessEn>
<bInitPowerMode>
> +		<bHighPriorityLUN> <bSecureRemovalType>
<bInitActiveICCLevel>
> +		<wPeriodicRTCUpdate> <bConfigDescrLock> <LUNum> <bLUEnable>
> +		<bBootLunID> <size_in_kb> <bDataReliability>
<bLUWriteProtect>
> +		<bMemoryType> <bLogicalBlockSize> <bProvisioningType>
> +		<wContextCapabilities> > ufs_provision

That's crazy big, please use configfs for this if you really want to
"provision" hardware with a new api.  That is what configfs was created for,
do not abuse sysfs like this, it is not a "single" value.
[Sayali] Sure. I will check and update my next patchset accordingly to use
configfs for provisioning at runtime.

thanks,

greg k-h
