From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] aic94xx: update BIOS image from user space.
Date: Thu, 11 Oct 2007 09:46:49 +0200
Message-ID: <200710110946.56198.eike-kernel@sf-tec.de>
References: <1192066875.6747.3.camel@linux.site>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart397366476.njoANR0z7T";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:37796 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbXJKHrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 03:47:32 -0400
In-Reply-To: <1192066875.6747.3.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>
Cc: linux-scsi@vger.kernel.org

--nextPart397366476.njoANR0z7T
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Gilbert Wu wrote:

> diff -urN a/drivers/scsi/aic94xx/aic94xx_init.c
> b/drivers/scsi/aic94xx/aic94xx_init.c ---
> a/drivers/scsi/aic94xx/aic94xx_init.c	2007-10-10 17:13:29.000000000 -0700
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c	2007-10-10 17:15:58.000000000
> -0700
> @@ -313,6 +315,179 @@
>  }
>  static DEVICE_ATTR(pcba_sn, S_IRUGO, asd_show_dev_pcba_sn, NULL);
>
> +#define FLASH_CMD_NONE      0x00
> +#define FLASH_CMD_UPDATE    0x01
> +#define FLASH_CMD_VERIFY    0x02
> +
> +struct flash_command {
> +     u8      command[8];
> +     int     code;
> +};
> +
> +static struct flash_command flash_command_table[] =3D
> +{
> +     {"verify",      FLASH_CMD_VERIFY},
> +     {"update",      FLASH_CMD_UPDATE},
> +     {"",            FLASH_CMD_NONE}      /* Last entry should be NULL. =
*/
> +};
> +
> +
> +struct error_bios{     char    *reason;     int     err_code;
> +};
> +
> +static struct error_bios flash_error_table[] =3D
> +{
> +     {"Failed to open bios image file",      FAIL_OPEN_BIOS_FILE},
> +     {"PCI ID mismatch",                     FAIL_CHECK_PCI_ID},
> +     {"Checksum mismatch",                   FAIL_CHECK_SUM},
> +     {"Unknown Error",                       FAIL_UNKNOWN},
> +     {"Failed to verify.",                   FAIL_VERIFY},
> +     {"Failed to reset flash chip.",         FAIL_RESET_FLASH},
> +     {"Failed to find flash chip type.",     FAIL_FIND_FLASH_ID},
> +     {"Failed to erash flash chip.",         FAIL_ERASE_FLASH},
> +     {"Failed to program flash chip.",       FAIL_WRITE_FLASH},
> +     {"Flash in progress",                   FLASH_IN_PROGRESS},
> +     {"Image file size Error",               FAIL_FILE_SIZE},
> +     {"Input parameter error",               FAIL_PARAMETERS},
> +     {"Out of memory",                       FAIL_OUT_MEMORY},
> +     {"OK",0 }	/* Last entry err_code =3D 0. */
> +};
> +
> +static ssize_t asd_store_update_bios(struct device *dev,struct
> device_attribute *attr, +				    const char *buf, size_t count)
> +{
> +	struct asd_ha_struct *asd_ha =3D dev_to_asd_ha(dev);
> +	char *cmd_ptr,*filename_ptr;
> +	struct bios_file_header header, *hdr_ptr;
> +	int res,i;
> +	u32 csum =3D 0;
> +	int flash_command =3D FLASH_CMD_NONE;
> +	int err =3D 0;
> +
> +
> +	cmd_ptr =3D kmalloc(count*2, GFP_KERNEL);
> +
> +	if (!cmd_ptr) {
> +		err=3DFAIL_OUT_MEMORY;
> +		goto out;
> +	}
> +
> +	memset(cmd_ptr,0,count*2);

cmd_ptr =3D kzalloc(count * 2, GFP_KERNEL);

> +	filename_ptr =3D cmd_ptr+count;
> +	res =3D sscanf(buf, "%s %s", cmd_ptr, filename_ptr);
> +	if (res !=3D 2)
> +	{
> +		err =3D FAIL_PARAMETERS;
> +		goto out1;
> +	}
> +
> +	for (i =3D 0; flash_command_table[i].code !=3D FLASH_CMD_NONE; i++) {
> +		if (!memcmp(flash_command_table[i].command,cmd_ptr, strlen(cmd_ptr))) {
                                                           ^

Space missing

> +			flash_command =3D flash_command_table[i].code;
> +			break;
> +		}
> +	}
> +	if (flash_command =3D=3D FLASH_CMD_NONE) {
> +		err =3D FAIL_PARAMETERS;
> +		goto out1;
> +	}
> +
> +	if (asd_ha->bios_status =3D=3D FLASH_IN_PROGRESS) {
> +		err =3D FLASH_IN_PROGRESS;
> +		goto out1;
> +	}
> +	err =3D request_firmware(&asd_ha->bios_image,
> +				   filename_ptr,
> +				   &asd_ha->pcidev->dev);
> +	if (err) {
> +		asd_printk("Failed to load bios image file %s, error %d\n",
> +			   filename_ptr, err);
> +		err =3D FAIL_OPEN_BIOS_FILE;
> +		goto out1;
> +	}
> +
> +	hdr_ptr =3D (struct bios_file_header *)asd_ha->bios_image->data;
> +
> +	if ((hdr_ptr->contrl_id.vendor !=3D asd_ha->pcidev->vendor ||
> +		hdr_ptr->contrl_id.device !=3D asd_ha->pcidev->device) &&
> +		(hdr_ptr->contrl_id.sub_vendor !=3D asd_ha->pcidev->vendor ||
> +		hdr_ptr->contrl_id.sub_device !=3D asd_ha->pcidev->device)) {
> +
> +		ASD_DPRINTK("The PCI vendor id or device id does not match\n");
> +		ASD_DPRINTK("vendor=3D%x dev=3D%x sub_vendor=3D%x sub_dev=3D%x pci ven=
dor=3D%x pci
> dev=3D%x \n", +		hdr_ptr->contrl_id.vendor,
        ^
Superfluous whitespace

> +		hdr_ptr->contrl_id.device,
> +		hdr_ptr->contrl_id.sub_vendor,
> +		hdr_ptr->contrl_id.sub_device,
> +		asd_ha->pcidev->vendor,
> +		asd_ha->pcidev->device);
> +		err =3D FAIL_CHECK_PCI_ID;
> +		goto out2;
> +	}
> +
> +	if (hdr_ptr->filelen !=3D asd_ha->bios_image->size) {
> +		err =3D FAIL_FILE_SIZE;
> +		goto out2;
> +	}
> +
> +	/* calculate checksum */
> +	for (i =3D 0; i < hdr_ptr->filelen; i++)
> +		csum +=3D asd_ha->bios_image->data[i];
> +
> +	if ((csum & 0x0000ffff) !=3D hdr_ptr->checksum) {
> +		ASD_DPRINTK("BIOS file checksum mismatch\n");
> +		err =3D FAIL_CHECK_SUM;
> +		goto out2;
> +	}
> +	if (flash_command =3D=3D FLASH_CMD_UPDATE) {
> +		asd_ha->bios_status =3D FLASH_IN_PROGRESS;
> +		err =3D
> asd_write_flash_seg(asd_ha,&asd_ha->bios_image->data[sizeof(*hdr_ptr)]
> +			,0,hdr_ptr->filelen-sizeof(*hdr_ptr));
                        ^
This comma belongs in the last line.

> +		if (!err) {
> +			err =3D
> asd_verify_flash_seg(asd_ha,&asd_ha->bios_image->data[sizeof(*hdr_ptr)]
> +				,0,hdr_ptr->filelen-sizeof(*hdr_ptr));
                                ^
This one too.

> +		}
> +	}
> +	else {
> +		asd_ha->bios_status =3D FLASH_IN_PROGRESS;
> +		err =3D
> asd_verify_flash_seg(asd_ha,&asd_ha->bios_image->data[sizeof(header)]
> +			,0,hdr_ptr->filelen-sizeof(header));
> +	}
> +
> +out2:
> +	release_firmware(asd_ha->bios_image);
> +out1:
> +	// free buffer

It's rather obvious what kfree() does, isn't it?

> diff -urN a/drivers/scsi/aic94xx/aic94xx_sds.c
> b/drivers/scsi/aic94xx/aic94xx_sds.c ---
> a/drivers/scsi/aic94xx/aic94xx_sds.c	2007-10-10 17:13:43.000000000 -0700
> +++ b/drivers/scsi/aic94xx/aic94xx_sds.c	2007-10-10 17:16:10.000000000
> -0700 @@ -30,7 +30,7 @@
>
>  #include "aic94xx.h"
>  #include "aic94xx_reg.h"
> -
> +#include "aic94xx_sds.h"

I prefer a newline before this comment. YMMV.

>  /* ---------- OCM stuff ---------- */
>
>  struct asd_ocm_dir_ent {
> @@ -1083,3 +1083,443 @@
>  	kfree(flash_dir);
>  	return err;
>  }
> +/*
> + * Function:
> + *	asd_hwi_write_nv_segment()
> + *
> + * Description:
> + *	Writes data to an NVRAM segment.
> + */

Kernel-doc description?

/**
 * asd_hwi_write_nv_segment - Writes data to an NVRAM segment
 * @asd_ha: ...


> +int
> +asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
> +		void *src,u32 dest_offset, u32 bytes_to_verify)
> +{
> +	u8 *src_buf;
> +	u8 flash_char;
> +	int err;
> +	u32 nv_offset, reg, i;
> +
> +
> +	reg =3D asd_ha->hw_prof.flash.bar;
> +	src_buf =3D NULL;
> +
> +	err =3D FLASH_OK;
> +	nv_offset =3D dest_offset;
> +	src_buf =3D (u8 *)src;
> +	for (i =3D 0; i < bytes_to_verify; i++) {
> +
> +		flash_char =3D asd_read_reg_byte(asd_ha,reg +nv_offset+i);
> +		if (flash_char !=3D src_buf[i]) 		{
> +			err =3D FAIL_VERIFY;
> +			break;
> +		}
> +	}
> +	return (err);

return err;

> +}
> +/*
> + * Function:
> + *	asd_hwi_write_nv_segment()
> + *
> + * Description:
> + *	Writes data to an NVRAM segment.
> + */
> +int
> +asd_write_flash_seg(struct asd_ha_struct *asd_ha,
> +		void *src,u32 dest_offset, u32 bytes_to_write)
> +{
> +    u8	*src_buf;
> +	u32 nv_offset, reg, i;
> +	int err;
> +
> +
> +	reg =3D asd_ha->hw_prof.flash.bar;
> +		src_buf =3D NULL;
> +
> +	err =3D asd_check_flash_type(asd_ha);
> +	if (err) {
> +		ASD_DPRINTK("couldn't find the type of flah(%d)\n", err);
                                                          ^^
flash, I'd prefer whitespace before the number. In this form someone could=
=20
think it's a flash index and not the error code on the first look.

> +		return err;
> +	}
> +
> +	nv_offset =3D dest_offset;
> +	err =3D asd_erase_nv_sector(asd_ha, nv_offset,bytes_to_write);
> +	if (err) {
> +		ASD_DPRINTK("Erase failed at offset:0x%x\n",
> +			nv_offset);
> +		return err;
> +	}
> +
> +	err =3D asd_reset_flash(asd_ha);
> +	if (err) {
> +		ASD_DPRINTK("couldn't reset flash(%d)\n", err);
                                                 ^
Whitespace, too.

> +		return err;
> +	}
> +
> +	src_buf =3D (u8 *)src;
> +	for (i =3D 0; i < bytes_to_write; i++) {
> +		/* Setup program command sequence */
> +		switch (asd_ha->hw_prof.flash.method) {
> +		case FLASH_METHOD_A:
> +		{
> +
> +			asd_write_reg_byte(asd_ha,
> +					(reg + 0xAAA), 0xAA);
> +			asd_write_reg_byte(asd_ha,
> +					(reg + 0x555), 0x55);
> +			asd_write_reg_byte(asd_ha,
> +					(reg + 0xAAA), 0xA0);
> +			asd_write_reg_byte(asd_ha,
> +					(reg + nv_offset + i),
> +					(*(src_buf + i)));
> +			break;
> +		}
> +		case FLASH_METHOD_B:
> +		{
> +			asd_write_reg_byte(asd_ha,
> +					(reg + 0x555), 0xAA);
> +			asd_write_reg_byte(asd_ha,
> +					(reg + 0x2AA), 0x55);
> +			asd_write_reg_byte(asd_ha,
> +					(reg + 0x555), 0xA0);
> +			asd_write_reg_byte(asd_ha,
> +					(reg + nv_offset + i),
> +					(*(src_buf + i)));
> +			break;
> +		}
> +		default:
> +			break;
> +		}
> +		if (asd_chk_write_status(asd_ha, (nv_offset + i),
> +			0 /* WRITE operation */) !=3D 0) {

Putting the comment on an own line would make it more readable IMHO.

> +			ASD_DPRINTK("aicx: Write failed at offset:0x%x\n",
> +				reg + nv_offset + i);
> +			return FAIL_WRITE_FLASH;
> +		}
> +	}
> +
> +	err =3D asd_reset_flash(asd_ha);
> +	if (err) {
> +		ASD_DPRINTK("couldn't reset flash(%d)\n", err);
> +		return err;
> +	}
> +	return (0);
> +}
> +int

Empty line between functions missing. More of this on other places.

> +asd_chk_write_status(struct asd_ha_struct *asd_ha, u32 sector_addr,
> +			u8 erase_flag)
> +{
> +	u32 reg;
> +	u32 loop_cnt;
> +	u8	nv_data1, nv_data2;
> +	u8	toggle_bit1/*, toggle_bit2*/;
> +
> +	/*
> +	 * Read from DQ2 requires sector address
> +	 * while it's dont care for DQ6
> +	 */
> +	/* read_addr =3D asd->hw_prof.nv_flash_bar + sector_addr;*/
> +	reg =3D asd_ha->hw_prof.flash.bar;
> +	loop_cnt =3D 50000;
> +
> +	while (loop_cnt) {

for-loop?

> +		nv_data1 =3D asd_read_reg_byte(asd_ha, reg);
> +		nv_data2 =3D asd_read_reg_byte(asd_ha, reg);
> +
> +		toggle_bit1 =3D ((nv_data1 & FLASH_STATUS_BIT_MASK_DQ6)
> +				 ^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ6));
> +		/* toggle_bit2 =3D ((nv_data1 & FLASH_STATUS_BIT_MASK_DQ2)
> +				^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ2));*/
> +
> +		if (toggle_bit1 =3D=3D 0) {
> +			return (0);

return 0;

> +		} else {
> +			if (nv_data2 & FLASH_STATUS_BIT_MASK_DQ5) {
> +				nv_data1 =3D asd_read_reg_byte(asd_ha,
> +								reg);
> +				nv_data2 =3D asd_read_reg_byte(asd_ha,
> +								reg);
> +				toggle_bit1 =3D
> +				((nv_data1 & FLASH_STATUS_BIT_MASK_DQ6)
> +				^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ6));
> +				/*
> +				toggle_bit2 =3D
> +				   ((nv_data1 & FLASH_STATUS_BIT_MASK_DQ2)
> +				   ^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ2));
> +				*/
> +				if (toggle_bit1 =3D=3D 0) {
> +					return 0;
> +				}
> +			}
> +		}
> +		loop_cnt--;
> +
> +		/*
> +		 * ERASE is a sector-by-sector operation and requires
> +		 * more time to finish while WRITE is byte-byte-byte
> +		 * operation and takes lesser time to finish.
> +		 *
> +		 * For some strange reason a reduced ERASE delay gives different
> +		 * behaviour across different spirit boards. Hence we set
> +		 * a optimum balance of 50mus for ERASE which works well
> +		 * across all boards.
> +		 */
> +		if (erase_flag) {
> +			udelay(FLASH_STATUS_ERASE_DELAY_COUNT);
> +		} else {
> +			udelay(FLASH_STATUS_WRITE_DELAY_COUNT);
> +		}
> +	}
> +	return (-1);

return -1;

> +}
> +/*
> + * Function:
> + *	asd_hwi_erase_nv_sector()
> + *
> + * Description:
> + *	Erase the requested NVRAM sector.
> + */

Kerneldoc again?

> +int
> +asd_erase_nv_sector(struct asd_ha_struct *asd_ha, u32 flash_addr,u32 siz=
e)
> +{
> +	u32 reg;
> +	u32 sector_addr;
> +	reg =3D asd_ha->hw_prof.flash.bar;
> +	/* sector staring address */
> +	sector_addr =3D flash_addr & FLASH_SECTOR_SIZE_MASK;
> +	/*
> +	 * Erasing an NVRAM sector needs to be done in six consecutive
> +	 * write cyles.
> +	 */
> +	while (sector_addr < flash_addr+size) {
> +		switch (asd_ha->hw_prof.flash.method) {
> +
> +		case FLASH_METHOD_A:
> +			asd_write_reg_byte(asd_ha, (reg + 0xAAA), 0xAA);
> +			asd_write_reg_byte(asd_ha, (reg + 0x555), 0x55);
> +			asd_write_reg_byte(asd_ha, (reg + 0xAAA), 0x80);
> +			asd_write_reg_byte(asd_ha, (reg + 0xAAA), 0xAA);
> +			asd_write_reg_byte(asd_ha, (reg + 0x555), 0x55);
> +			asd_write_reg_byte(asd_ha, (reg + sector_addr), 0x30);
> +			break;
> +
> +		case FLASH_METHOD_B:
> +			asd_write_reg_byte(asd_ha, (reg + 0x555), 0xAA);
> +			asd_write_reg_byte(asd_ha, (reg + 0x2AA), 0x55);
> +			asd_write_reg_byte(asd_ha, (reg + 0x555), 0x80);
> +			asd_write_reg_byte(asd_ha, (reg + 0x555), 0xAA);
> +			asd_write_reg_byte(asd_ha, (reg + 0x2AA), 0x55);
> +			asd_write_reg_byte(asd_ha, (reg + sector_addr), 0x30);
> +			break;
> +
> +		default:
> +			break;
> +		}
> +
> +		if (asd_chk_write_status(asd_ha, sector_addr,
> +					1 /* ERASE operation */) !=3D 0) {
> +			return FAIL_ERASE_FLASH;
> +		}
> +
> +		sector_addr +=3D FLASH_SECTOR_SIZE;
> +	}
> +
> +	return (0);

return 0;

Greetings,

Eike

--nextPart397366476.njoANR0z7T
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHDdTwXKSJPmm5/E4RApHDAJ9cG3pQlhDsHzip7SvFZqu4ZMmtVQCfbsbt
LjwaTHAC7ctkgdif/T2JBKk=
=ZRGy
-----END PGP SIGNATURE-----

--nextPart397366476.njoANR0z7T--
