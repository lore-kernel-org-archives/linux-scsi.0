From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/19] qla2xxx: Separate ISP type bits out from device
 type.
Date: Fri, 15 Jul 2016 15:01:29 +0200
Message-ID: <839e736a-f030-38d3-f7f7-028a2d69f762@suse.de>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
 <1467818075-15246-16-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbcGONBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:01:31 -0400
In-Reply-To: <1467818075-15246-16-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 07/06/2016 05:14 PM, Himanshu Madhani wrote:
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
>=20
> Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h |  6 ++++--
>  drivers/scsi/qla2xxx/qla_os.c  | 44 +++++++++++++++++++++-----------=
----------
>  2 files changed, 26 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/ql=
a_def.h
> index c04d83e..ae4a747 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3130,7 +3130,7 @@ struct qla_hw_data {
>  #define PCI_DEVICE_ID_QLOGIC_ISP2271	0x2271
>  #define PCI_DEVICE_ID_QLOGIC_ISP2261	0x2261
> =20
> -	uint32_t	device_type;
> +	uint32_t	isp_type;
>  #define DT_ISP2100                      BIT_0
>  #define DT_ISP2200                      BIT_1
>  #define DT_ISP2300                      BIT_2
> @@ -3155,6 +3155,7 @@ struct qla_hw_data {
>  #define DT_ISP2261			BIT_21
>  #define DT_ISP_LAST			(DT_ISP2261 << 1)
> =20
> +	uint32_t	device_type;
>  #define DT_T10_PI                       BIT_25
>  #define DT_IIDMA                        BIT_26
>  #define DT_FWI2                         BIT_27
> @@ -3162,7 +3163,8 @@ struct qla_hw_data {
>  #define DT_OEM_001                      BIT_29
>  #define DT_ISP2200A                     BIT_30
>  #define DT_EXTENDED_IDS                 BIT_31
> -#define DT_MASK(ha)     ((ha)->device_type & (DT_ISP_LAST - 1))
> +
> +#define DT_MASK(ha)     ((ha)->isp_type & (DT_ISP_LAST - 1))
>  #define IS_QLA2100(ha)  (DT_MASK(ha) & DT_ISP2100)
>  #define IS_QLA2200(ha)  (DT_MASK(ha) & DT_ISP2200)
>  #define IS_QLA2300(ha)  (DT_MASK(ha) & DT_ISP2300)
Hmm.
I would've thought that you take the opportunity to reshuffle the
device_type bit to start with '0'; as it stands now it doesn't
really buy you anything right now...

But anyway.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
