From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 1/2] target: make target db location configurable
Date: Thu, 14 Apr 2016 08:10:32 +0200
Message-ID: <570F3458.8010109@suse.de>
References: <cover.1460577841.git.lduncan@suse.com>
 <5f4f1bc2ac2177a37432f0afd22f16ddf65e9e9b.1460577841.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5f4f1bc2ac2177a37432f0afd22f16ddf65e9e9b.1460577841.git.lduncan@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, agrover@redhat.com, jxm@netiant.com
List-Id: linux-scsi@vger.kernel.org

On 04/13/2016 10:25 PM, Lee Duncan wrote:
> This commit adds the read-write attribute "dbroot",
> in the top-level CONFIGFS (core) target directory,
> normally /sys/kernel/config/target. This attribute
> defaults to "/var/target" but can be changed by
> writing a new pathname string to it. Changing this
> attribute is only allowed when no fabric drivers
> are loaded and the supplied value specifies an
> existing directory.
>=20
> Target modules that care about the target database
> root directory will be modified to use this
> attribute in a future commit.
>=20
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/target/target_core_configfs.c | 51 +++++++++++++++++++++++++=
++++++++++
>  drivers/target/target_core_internal.h |  6 +++++
>  2 files changed, 57 insertions(+)
>=20
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/t=
arget_core_configfs.c
> index 713c63d9681b..bfedbd92b77f 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -99,6 +99,56 @@ static ssize_t target_core_item_version_show(struc=
t config_item *item,
> =20
>  CONFIGFS_ATTR_RO(target_core_item_, version);
> =20
> +char db_root[DB_ROOT_LEN] =3D DB_ROOT_DEFAULT;
> +static char db_root_stage[DB_ROOT_LEN];
> +
> +static ssize_t target_core_item_dbroot_show(struct config_item *item=
,
> +					    char *page)
> +{
> +	return sprintf(page, "%s\n", db_root);
> +}
> +
> +static ssize_t target_core_item_dbroot_store(struct config_item *ite=
m,
> +					const char *page, size_t count)
> +{
> +	ssize_t read_bytes;
> +	struct file *fp;
> +
> +	if (!list_empty(&g_tf_list)) {
> +		pr_err("db_root: cannot be changed: target drivers registered");
> +		return -EINVAL;
> +	}
Locking?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
