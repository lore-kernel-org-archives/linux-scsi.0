From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] libfc: fix seconds_since_last_reset miscalculation
Date: Tue, 8 Nov 2016 15:04:43 +0000
Message-ID: <BLUPR02MB16830DECB29262BACBA94FA681A60@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1478594694-98847-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0043.outbound.protection.outlook.com ([104.47.33.43]:19232
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751479AbcKHPEp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 10:04:45 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>

On 11/08/16 00:45, Johannes Thumshirn wrote:=0A=
> Commit 540eb1eef 'scsi: libfc: fix seconds_since_last_reset calculation'=
=0A=
> removed the use of 'struct timespec' from fc_get_host_stats(). This broke=
 the=0A=
> output of 'fcoeadm -s' after kernel 4.8-rc1 as lport->boot_time - jiffies=
=0A=
> could become negative as in this example:=0A=
>=0A=
> $ cat /sys/class/fc_host/host8/statistics/seconds_since_last_reset=0A=
> 0x10624dd2f1977b4=0A=
>=0A=
> Take this into account so=0A=
> /sys/class/fc_host/hostX/statistics/seconds_since_last_reset is sane agai=
n.=0A=
>=0A=
> Fixes: 540eb1eef ('scsi: libfc: fix seconds_since_last_reset calculation'=
)=0A=
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>=0A=
> Tested-by: Holger Schranz <holger@fam-schranz.de>=0A=
> ---=0A=
>  drivers/scsi/libfc/fc_lport.c | 6 +++++-=0A=
>  1 file changed, 5 insertions(+), 1 deletion(-)=0A=
>=0A=
> diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.=
c=0A=
> index 04ce7cf..475c0a9 100644=0A=
> --- a/drivers/scsi/libfc/fc_lport.c=0A=
> +++ b/drivers/scsi/libfc/fc_lport.c=0A=
> @@ -304,11 +304,15 @@ struct fc_host_statistics *fc_get_host_stats(struct=
 Scsi_Host *shost)=0A=
>  	unsigned int cpu;=0A=
>  	u64 fcp_in_bytes =3D 0;=0A=
>  	u64 fcp_out_bytes =3D 0;=0A=
> +	unsigned long boot_time =3D lport->boot_time;=0A=
>=0A=
>  	fc_stats =3D &lport->host_stats;=0A=
>  	memset(fc_stats, 0, sizeof(struct fc_host_statistics));=0A=
>=0A=
> -	fc_stats->seconds_since_last_reset =3D (lport->boot_time - jiffies) / H=
Z;=0A=
> +	if (boot_time > jiffies)=0A=
> +		fc_stats->seconds_since_last_reset =3D (boot_time - jiffies) / HZ;=0A=
> +	else=0A=
> +		fc_stats->seconds_since_last_reset =3D (jiffies - boot_time) / HZ;=0A=
>=0A=
>  	for_each_possible_cpu(cpu) {=0A=
>  		struct fc_stats *stats;=0A=
=0A=
Hello Johannes,=0A=
=0A=
I think the above code will miscalculate seconds_since_last_reset if =0A=
'jiffies' wraps around after an lport has been created and before =0A=
seconds_since_last_reset is computed. Shouldn't seconds_since_last_reset =
=0A=
be computed as follows?=0A=
=0A=
	fc_stats->seconds_since_last_reset =3D (jiffies - boot_time) / HZ;=0A=
=0A=
Bart.=0A=
=0A=
=0A=
