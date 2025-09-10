Received: from bsdbackstore.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE27255F24;
	Wed, 10 Sep 2025 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757528014; cv=none; b=YAxrGsvF2bdzLgCwbQGT5mkLcwGrgwt3kPO1RATHrnI6M5hEjKyTMVgo4QbbQagtGFj6t8tVA+IC5MaY/qL5C9n3Gplcw+Qj6i+Na3X2o4pxIM499fSWS+ZNTePCiMlug1GbN6Lu+Tcrj1jIuqjZzvseKIhm+iNxY/wsEusR28A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757528014; c=relaxed/simple;
	bh=66IewO7UFTnc3G2DgscPYMaJ6YaubmawGe4S03S+mVI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=LBsMF1aCAPEQW+8zIfpcTBsCLv/l2aIuBRLcykMO3icL6HHiZcPWjk7Xj+7wFJxgbozVVHMN8xR21pryNx4+mPNKWU3Sdcdz8DMFwd/Fipchf5idZ255M6kFW/TjkKuEdBnPkSunb+nXDXmSNyk/yJQgUh2j1J0drLegA4iMCYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu; spf=pass smtp.mailfrom=bsdbackstore.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsdbackstore.eu
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by bsdbackstore.eu (OpenSMTPD) with ESMTPSA id 37fe6665 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 10 Sep 2025 20:13:22 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Sep 2025 20:13:21 +0200
Message-Id: <DCPBOHQA8AO3.36BA5ELXZJXMY@bsdbackstore.eu>
Subject: Re: [RFC] target: Support for CD/DVD device emulation in fileio
 backstore
From: "Maurizio Lombardi" <mlombard@bsdbackstore.eu>
To: "Davy Davidse" <davydavidse@gmail.com>, <martin.petersen@oracle.com>
Cc: <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
X-Mailer: aerc
References: <CADzRqdBCLjA=6nLxUivDm=hA5vkfkMiE+BmC_zKtA2DCUxu2Dg@mail.gmail.com>
In-Reply-To: <CADzRqdBCLjA=6nLxUivDm=hA5vkfkMiE+BmC_zKtA2DCUxu2Dg@mail.gmail.com>

On Wed Sep 10, 2025 at 12:09 AM CEST, Davy Davidse wrote:
> # Request for Comments
>
> Would the maintainers be interested in accepting a patch to add configura=
ble
> device type support to the fileio backstore? This would:
>
> - Maintain full backward compatibility (default to TYPE_DISK)
> - Enable proper CD/DVD/ROM device emulation
> - Bring kernel-space target capabilities in line with user-space solution=
s
> - Address real deployment scenarios currently requiring TGT
>
> As someone primarily focused on high level coding languages, rather than =
kernel
> development, I'm hoping this RFC might inspire a kernel developer who see=
s
> value in this functionality to take on the implementation.
>
> Thank you for your time and consideration.
>

This sound like an interesting idea to me.

Maybe we could modify the file backstore to emulate a CDROM device when
needed, something like the following:

I didn't really tested it to see if works correctly, I've just verified
that the initiator's lsblk sees the device like a CDROM.

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core=
_file.c
index 2d78ef74633c..ab36773d9177 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -689,7 +689,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *s=
gl, u32 sgl_nents,

 enum {
 	Opt_fd_dev_name, Opt_fd_dev_size, Opt_fd_buffered_io,
-	Opt_fd_async_io, Opt_err
+	Opt_fd_async_io, Opt_emulate_cdrom, Opt_err
 };

 static match_table_t tokens =3D {
@@ -697,6 +697,7 @@ static match_table_t tokens =3D {
 	{Opt_fd_dev_size, "fd_dev_size=3D%s"},
 	{Opt_fd_buffered_io, "fd_buffered_io=3D%d"},
 	{Opt_fd_async_io, "fd_async_io=3D%d"},
+	{Opt_emulate_cdrom, "emulate_cdrom=3D%d"},
 	{Opt_err, NULL}
 };

@@ -777,6 +778,20 @@ static ssize_t fd_set_configfs_dev_params(struct se_de=
vice *dev,

 			fd_dev->fbd_flags |=3D FDBD_HAS_ASYNC_IO;
 			break;
+		case Opt_emulate_cdrom:
+			ret =3D match_int(args, &arg);
+			if (ret)
+				goto out;
+			if (arg !=3D 1) {
+				pr_err("bogus emulate_cdrom=3D%d value\n", arg);
+				ret =3D -EINVAL;
+				goto out;
+			}
+
+			pr_debug("FILEIO: Emulating CDROM device type\n");
+
+			fd_dev->fbd_flags |=3D FDBD_HAS_EMULATE_CDROM;
+			break;
 		default:
 			break;
 		}
@@ -793,11 +808,13 @@ static ssize_t fd_show_configfs_dev_params(struct se_=
device *dev, char *b)
 	ssize_t bl =3D 0;

 	bl =3D sprintf(b + bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
-	bl +=3D sprintf(b + bl, "        File: %s  Size: %llu  Mode: %s Async: %d=
\n",
+	bl +=3D sprintf(b + bl,
+		"        File: %s  Size: %llu  Mode: %s Async: %d cdrom: %d\n",
 		fd_dev->fd_dev_name, fd_dev->fd_dev_size,
 		(fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) ?
 		"Buffered-WCE" : "O_DSYNC",
-		!!(fd_dev->fbd_flags & FDBD_HAS_ASYNC_IO));
+		!!(fd_dev->fbd_flags & FDBD_HAS_ASYNC_IO),
+		!!(fd_dev->fbd_flags & FDBD_HAS_EMULATE_CDROM));
 	return bl;
 }

@@ -909,6 +926,14 @@ fd_parse_cdb(struct se_cmd *cmd)
 	return sbc_parse_cdb(cmd, &fd_exec_cmd_ops);
 }

+static u32 fd_get_device_type(struct se_device *dev)
+{
+	if (FD_DEV(dev)->fbd_flags & FDBD_HAS_EMULATE_CDROM)
+		return TYPE_ROM;
+
+	return sbc_get_device_type(dev);
+}
+
 static const struct target_backend_ops fileio_ops =3D {
 	.name			=3D "fileio",
 	.inquiry_prod		=3D "FILEIO",
@@ -924,7 +949,7 @@ static const struct target_backend_ops fileio_ops =3D {
 	.parse_cdb		=3D fd_parse_cdb,
 	.set_configfs_dev_params =3D fd_set_configfs_dev_params,
 	.show_configfs_dev_params =3D fd_show_configfs_dev_params,
-	.get_device_type	=3D sbc_get_device_type,
+	.get_device_type	=3D fd_get_device_type,
 	.get_blocks		=3D fd_get_blocks,
 	.init_prot		=3D fd_init_prot,
 	.format_prot		=3D fd_format_prot,
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core=
_file.h
index 929b1ecd544e..8e36948cdaba 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -23,6 +23,7 @@
 #define FBDF_HAS_SIZE		0x02
 #define FDBD_HAS_BUFFERED_IO_WCE 0x04
 #define FDBD_HAS_ASYNC_IO	 0x08
+#define FDBD_HAS_EMULATE_CDROM  0x10
 #define FDBD_FORMAT_UNIT_SIZE	2048

 struct fd_dev {
--
2.47.3


$ lsblk=20
NAME                                            MAJ:MIN RM   SIZE RO TYPE  =
MOUNTPOINTS
sr0                                              11:0    1     1G  0 rom=20
