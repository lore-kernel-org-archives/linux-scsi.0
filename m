From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 25/27] block: remove the discard_zeroes_data flag
Date: Mon, 1 May 2017 20:45:21 +0000
Message-ID: <1493671519.2665.15.camel@sandisk.com>
References: <20170405172125.22600-1-hch@lst.de>
         <20170405172125.22600-26-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170405172125.22600-26-hch@lst.de>
Content-Language: en-US
Content-ID: <6057828B6A69B94887FF6CB79814747D@namprd04.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "agk@redhat.com" <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "shli@kernel.org" <shli@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-04-05 at 19:21 +0200, Christoph Hellwig wrote:
> Now that we use the proper REQ_OP_WRITE_ZEROES operation everywhere we ca=
n
> kill this hack.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> [ ... ]
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_=
core_device.c
> index c754ae33bf7b..d2f089cfa9ae 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -851,7 +851,7 @@ bool target_configure_unmap_from_queue(struct se_dev_=
attrib *attrib,
>  	attrib->unmap_granularity =3D q->limits.discard_granularity / block_siz=
e;
>  	attrib->unmap_granularity_alignment =3D q->limits.discard_alignment /
>  								block_size;
> -	attrib->unmap_zeroes_data =3D q->limits.discard_zeroes_data;
> +	attrib->unmap_zeroes_data =3D 0;
>  	return true;
>  }
>  EXPORT_SYMBOL(target_configure_unmap_from_queue);

Hello Christoph,

Sorry that I hadn't noticed this before but I think that this patch
introduces a significant performance regressions for LIO users. Before
this patch the LBPRZ flag was reported correctly to initiator systems
through the thin provisioning VPD. With this patch applied that flag
will always be reported as zero, forcing initiators to submit WRITE
commands with zeroed data buffers instead of submitting the SCSI UNMAP
command to block devices for which=A0discard_zeroes_data was set. From
target_core_spc.c:

/* Thin Provisioning VPD */
static sense_reason_t spc_emulate_evpd_b2(struct se_cmd *cmd, unsigned char=
 *buf)
{
	[ ... ]
	/*
	 * The unmap_zeroes_data set means that the underlying device supports
	 * REQ_DISCARD and has the discard_zeroes_data bit set. This satisfies
	 * the SBC requirements for LBPRZ, meaning that a subsequent read
	 * will return zeroes after an UNMAP or WRITE SAME (16) to an LBA
	 * See sbc4r36 6.6.4.
	 */
	if (((dev->dev_attrib.emulate_tpu !=3D 0) ||
	=A0=A0=A0=A0=A0(dev->dev_attrib.emulate_tpws !=3D 0)) &&
	=A0=A0=A0=A0=A0(dev->dev_attrib.unmap_zeroes_data !=3D 0))
		buf[5] |=3D 0x04;
	[ ... ]
}

Please advise how to proceed.

Thanks,

Bart.=
