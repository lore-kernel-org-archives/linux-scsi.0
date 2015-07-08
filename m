From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 2/3] megaraid_sas : use dev_printk when possible
Date: Wed, 08 Jul 2015 12:47:26 +0200
Message-ID: <559CFFBE.80801@suse.de>
References: <20150707204916.6218.37871.stgit@bhelgaas-glaptop2.roam.corp.google.com> <20150707205233.6218.13548.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150707205233.6218.13548.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 07/07/2015 10:52 PM, Bjorn Helgaas wrote:
> Use dev_printk() when possible to make messages more useful.
>=20
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  304 +++++++++++++----=
----------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   95 ++++----
>  2 files changed, 196 insertions(+), 203 deletions(-)
>=20
[ .. ]
> @@ -1873,8 +1872,8 @@ static int megasas_get_ld_vf_affiliation_111(st=
ruct megasas_instance *instance,
>  	cmd =3D megasas_get_cmd(instance);
> =20
>  	if (!cmd) {
> -		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation_111:"
> -		       "Failed to get cmd for scsi%d.\n",
> +		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_af=
filiation_111:"
> +		       "Failed to get cmd for scsi%d\n",
>  			instance->host->host_no);
>  		return -ENOMEM;
>  	}
Makes one wonder why we don't have a 'dev_debug'; dev_notice() and
dev_warn() are there ...

Otherwise: Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
