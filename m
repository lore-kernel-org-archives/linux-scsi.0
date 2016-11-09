From: "George, Martin" <Martin.George@netapp.com>
Subject: RE: [PATCH] scsi_devinfo: remove synchronous ALUA for NETAPP/RDAC
 devices
Date: Wed, 9 Nov 2016 07:38:31 +0000
Message-ID: <BN1PR06MB1521E99DDAD4D921182C97695B90@BN1PR06MB152.namprd06.prod.outlook.com>
References: <20161108193242.3454-1-xose.vazquez@gmail.com>
 <e6686f70-5de7-2618-0ba7-5a7b98eba068@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx142.netapp.com ([216.240.21.19]:64818 "EHLO mx142.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752079AbcKIHil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 02:38:41 -0500
In-Reply-To: <e6686f70-5de7-2618-0ba7-5a7b98eba068@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "Stankey, Robert" <Robert.Stankey@netapp.com>, "Schremmer, Steven" <Steve.Schremmer@netapp.com>, "Stewart, Sean" <Sean.Stewart@netapp.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

As discussed with Hannes, this is not required for ONTAP's LUN C-Mode as we=
ll. So the ALUA blacklisting may be removed here as well, and not just for =
NetApp RDAC.

-Martin

-----Original Message-----
From: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Wednesday, November 9, 2016 12:20 PM
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: George, Martin <Martin.George@netapp.com>; Stankey, Robert <Robert.Stan=
key@netapp.com>; Schremmer, Steven <Steve.Schremmer@netapp.com>; Stewart, S=
ean <Sean.Stewart@netapp.com>; Christophe Varoqui <christophe.varoqui@opens=
vc.com>; James E . J . Bottomley <jejb@linux.vnet.ibm.com>; Martin K . Pete=
rsen <martin.petersen@oracle.com>; SCSI ML <linux-scsi@vger.kernel.org>; de=
vice-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH] scsi_devinfo: remove synchronous ALUA for NETAPP/RDAC =
devices

On 11/08/2016 08:32 PM, Xose Vazquez Perez wrote:
> NetApp did confirm this is only required for ONTAP(LUN C-Mode).
>
> Cc: Martin George <Martin.George@netapp.com>
> Cc: Robert Stankey <Robert.Stankey@netapp.com>
> Cc: Steven Schremmer <Steven.Schremmer@netapp.com>
> Cc: Sean Stewart <Sean.Stewart@netapp.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI ML <linux-scsi@vger.kernel.org>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  drivers/scsi/scsi_devinfo.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c=20
> index 2464569..1fb7964 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -221,7 +221,6 @@ static struct {
>  	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>  	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
>  	{"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},
> -	{"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},
>  	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>  	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>  	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN |=20
> BLIST_SINGLELUN},
>

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB 2128=
4 (AG N=FCrnberg)
