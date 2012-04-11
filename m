From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [isci PATCH v2 12/18] libata: make ata_print_id atomic
Date: Tue, 10 Apr 2012 19:21:41 -0700
Message-ID: <CAA9_cmdc3kxJCqwiqpXXqWXUQHJ1SSpbK3u9bDSsgSc0p93Wuw@mail.gmail.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
	<20120311072845.6320.68461.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311072845.6320.68461.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Ping? I assume this fairly uncontroversial and can be 3.4-rc material.

On Sat, Mar 10, 2012 at 11:28 PM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> This variable is incremented from multiple contexts (module_init via
> libata-lldds and the libsas discovery thread). =A0Make it atomic to h=
ead
> off any chance of libsas and libata creating duplicate ids.
>
> Acked-by: Jacek Danecki <jacek.danecki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0drivers/ata/libata-core.c | =A0 =A04 ++--
> =A0drivers/ata/libata-scsi.c | =A0 =A04 ++--
> =A0drivers/ata/libata.h =A0 =A0 =A0| =A0 =A02 +-
> =A03 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ea8444e..bd79c8b 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -97,7 +97,7 @@ static unsigned int ata_dev_set_xfermode(struct ata=
_device *dev);
> =A0static void ata_dev_xfermask(struct ata_device *dev);
> =A0static unsigned long ata_dev_blacklisted(const struct ata_device *=
dev);
>
> -unsigned int ata_print_id =3D 1;
> +atomic_t ata_print_id =3D ATOMIC_INIT(1);
>
> =A0struct ata_force_param {
> =A0 =A0 =A0 =A0const char =A0 =A0 =A0*name;
> @@ -6031,7 +6031,7 @@ int ata_host_register(struct ata_host *host, st=
ruct scsi_host_template *sht)
>
> =A0 =A0 =A0 =A0/* give ports names and add SCSI hosts */
> =A0 =A0 =A0 =A0for (i =3D 0; i < host->n_ports; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 host->ports[i]->print_id =3D ata_print_=
id++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 host->ports[i]->print_id =3D atomic_inc=
_return(&ata_print_id);
>
>
> =A0 =A0 =A0 =A0/* Create associated sysfs transport objects =A0*/
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 1ee00c8..93dabdc 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3843,7 +3843,7 @@ int ata_sas_async_port_init(struct ata_port *ap=
)
> =A0 =A0 =A0 =A0int rc =3D ap->ops->port_start(ap);
>
> =A0 =A0 =A0 =A0if (!rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->print_id =3D ata_print_id++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->print_id =3D atomic_inc_return(&ata=
_print_id);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__ata_port_probe(ap);
> =A0 =A0 =A0 =A0}
>
> @@ -3867,7 +3867,7 @@ int ata_sas_port_init(struct ata_port *ap)
> =A0 =A0 =A0 =A0int rc =3D ap->ops->port_start(ap);
>
> =A0 =A0 =A0 =A0if (!rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->print_id =3D ata_print_id++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->print_id =3D atomic_inc_return(&ata=
_print_id);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D ata_port_probe(ap);
> =A0 =A0 =A0 =A0}
>
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 2e26fca..9d0fd0b 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -53,7 +53,7 @@ enum {
> =A0 =A0 =A0 =A0ATA_DNXFER_QUIET =A0 =A0 =A0 =A0=3D (1 << 31),
> =A0};
>
> -extern unsigned int ata_print_id;
> +extern atomic_t ata_print_id;
> =A0extern int atapi_passthru16;
> =A0extern int libata_fua;
> =A0extern int libata_noacpi;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
