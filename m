From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH 4/7][SCSI] mpt3sas: Infinite loops can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
Date: Fri, 28 Jun 2013 18:11:02 +0200
Message-ID: <87sj02z04p.fsf@nemi.mork.no>
References: <20130628222302.GA5055@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:43586 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab3F1QOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jun 2013 12:14:30 -0400
In-Reply-To: <20130628222302.GA5055@lsi.com> (Sreekanth Reddy's message of
	"Sat, 29 Jun 2013 03:53:02 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com

Sreekanth Reddy <Sreekanth.Reddy@lsi.com> writes:

> Infinite loop can occur if IOCStatus is not equal to
> MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value in the while loops in functi=
ons=20
> _scsih_search_responding_sas_devices,
> _scsih_search_responding_raid_devices and
> _scsih_search_responding_expanders
>
> So, Instead of checking for MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value,
> in this patch code is modified to check for IOCStatus not equals to=20
> MPI2_IOCSTATUS_SUCCESS to break the while loop.
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |   16 ++++------------
>  1 files changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> index 9ebc9dc..632eba7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -6406,7 +6406,7 @@ _scsih_search_responding_sas_devices(struct MPT=
3SAS_ADAPTER *ioc)
>  	    handle))) {
>  		ioc_status =3D le16_to_cpu(mpi_reply.IOCStatus) &
>  		    MPI2_IOCSTATUS_MASK;
> -		if (ioc_status =3D=3D MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
> +		if (ioc_status !=3D MPI2_IOCSTATUS_SUCCESS)
>  			break;
>  		handle =3D le16_to_cpu(sas_device_pg0.DevHandle);
>  		device_info =3D le32_to_cpu(sas_device_pg0.DeviceInfo);

Doesn't the same apply to the code mpt2sas driver you copied this code
from?



Bj=C3=B8rn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
