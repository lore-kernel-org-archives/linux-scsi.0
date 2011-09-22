From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/5] libsas: disable scanning lun > 0 on ata devices
Date: Wed, 21 Sep 2011 22:29:19 -0400
Message-ID: <4E7A9D7F.1030003@pobox.com>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6> <20110920221008.1094.34064.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110920221008.1094.34064.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Luben Tuikov <ltuikov@yahoo.com>, JBottomley@parallels.com, Jack Wang <jack_wang@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>, Mark Salyzyn <msalyzyn@us.xyratex.com>, Darrick Wong <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 09/20/2011 06:10 PM, Dan Williams wrote:
> Currently mvsas and pm8001 have custom ->slave_alloc implementations to
> achieve this.  Uplevel it for all libsas drivers as isci encounters problems
> with atapi devices when scanning past lun0.
>
> Just do what Darrick suggested [1], and limit the scan for ata devices.
>
> [1] http://marc.info/?l=linux-scsi&m=116604101119861&w=2
>
> Cc: Darrick Wong<djwong@us.ibm.com>
> Cc: Xiangliang Yu<yuxiangl@marvell.com>
> Cc: Jack Wang<jack_wang@usish.com>
> Cc: Mark Salyzyn<msalyzyn@us.xyratex.com>
> Cc: Luben Tuikov<ltuikov@yahoo.com>
> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
> ---
>   drivers/scsi/scsi_transport_sas.c |   10 ++++++++--
>   1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index c6fcf76..9d9330a 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1545,8 +1545,14 @@ int sas_rphy_add(struct sas_rphy *rphy)
>
>   	if (identify->device_type == SAS_END_DEVICE&&
>   	rphy->scsi_target_id != -1) {
> -		scsi_scan_target(&rphy->dev, 0,
> -				rphy->scsi_target_id, SCAN_WILD_CARD, 0);
> +		int lun;
> +
> +		if (identify->target_port_protocols&  SAS_PROTOCOL_SSP)
> +			lun = SCAN_WILD_CARD;
> +		else
> +			lun = 0;
> +
> +		scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun, 0);

Acked-by: Jeff Garzik <jgarzik@redhat.com>



