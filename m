From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: prevent stack buffer overflow in host_reset
Date: Fri, 30 Nov 2012 09:07:57 +0000
Message-ID: <1354266477.2259.5.camel@dabdike.int.hansenpartnership.com>
References: <1353012706-28182-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1353012706-28182-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-11-15 at 15:51 -0500, Sasha Levin wrote:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index ce5224c..77ba946 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -249,9 +249,9 @@ static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR=
, show_shost_active_mode, NULL)
> =20
>  static int check_reset_type(char *str)
>  {
> -	if (strncmp(str, "adapter", 10) =3D=3D 0)
> +	if (sysfs_streq(str, "adapter"))
>  		return SCSI_ADAPTER_RESET;
> -	else if (strncmp(str, "firmware", 10) =3D=3D 0)
> +	else if (sysfs_streq(str, "firmware"))
>  		return SCSI_FIRMWARE_RESET;
>  	else
>  		return 0;
> @@ -264,12 +264,9 @@ store_host_reset(struct device *dev, struct devi=
ce_attribute *attr,
>  	struct Scsi_Host *shost =3D class_to_shost(dev);
>  	struct scsi_host_template *sht =3D shost->hostt;
>  	int ret =3D -EINVAL;
> -	char str[10];
>  	int type;
> =20
> -	sscanf(buf, "%s", str);
> -	type =3D check_reset_type(str);
> -
> +	type =3D check_reset_type(buf);
>  	if (!type)
>  		goto exit_store_host_reset;

You didn't compile test this:

  CC [M]  drivers/scsi/scsi_sysfs.o
drivers/scsi/scsi_sysfs.c: In function =E2=80=98store_host_reset=E2=80=99=
:
drivers/scsi/scsi_sysfs.c:269:2: warning: passing argument 1 of =E2=80=98=
check_reset_type=E2=80=99 discards =E2=80=98const=E2=80=99 qualifier fr=
om pointer target type [enabled by default]
drivers/scsi/scsi_sysfs.c:250:12: note: expected =E2=80=98char *=E2=80=99=
 but argument is of type =E2=80=98const char *=E2=80=99

It needs a const in check_reset_type().

I've added it.

James
