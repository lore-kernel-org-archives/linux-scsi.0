From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] aic94xx: update BIOS image from user space.
Date: Mon, 15 Oct 2007 21:32:07 +0200
Message-ID: <200710152132.14601.eike-kernel@sf-tec.de>
References: <1192154518.6403.2.camel@linux.site>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2398027.h8A6enNebp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:41317 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111AbXJSGBS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 02:01:18 -0400
In-Reply-To: <1192154518.6403.2.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>
Cc: Linux-scsi@vger.kernel.org

--nextPart2398027.h8A6enNebp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Gilbert Wu wrote:

> diff -urN a/drivers/scsi/aic94xx/aic94xx_init.c
> b/drivers/scsi/aic94xx/aic94xx_init.c ---
> a/drivers/scsi/aic94xx/aic94xx_init.c	2007-10-10 17:13:29.000000000 -0700
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c	2007-10-11 19:31:03.000000000
> -0700
> @@ -313,6 +315,180 @@
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

Make this definition multi-line like the one of flash_command above.

> diff -urN a/drivers/scsi/aic94xx/aic94xx_sds.c
> b/drivers/scsi/aic94xx/aic94xx_sds.c ---
> a/drivers/scsi/aic94xx/aic94xx_sds.c	2007-10-10 17:13:43.000000000 -0700
> +++ b/drivers/scsi/aic94xx/aic94xx_sds.c	2007-10-11 18:38:09.000000000
> -0700
> @@ -1083,3 +1084,432 @@
>  	kfree(flash_dir);
>  	return err;
>  }
> +
> +/**
> + * asd_verify_flash_seg - verify data with flash memory
> + * @asd_ha: pointer to the host adapter structure
> + * @src: pointer to the source data to be verified
> + * @dest_offset: offset from flash memory
> + * @bytes_to_verify: total bytes to verify
> + */
> +int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
> +		void *src, u32 dest_offset, u32 bytes_to_verify)
> +{
> +	u8 *src_buf;
> +	u8 flash_char;
> +	int err;
> +	u32 nv_offset, reg, i;
> +
> +

Double newline.

> +	reg =3D asd_ha->hw_prof.flash.bar;
> +	src_buf =3D NULL;
> +
> +	err =3D FLASH_OK;
> +	nv_offset =3D dest_offset;
> +	src_buf =3D (u8 *)src;
> +	for (i =3D 0; i < bytes_to_verify; i++) {
> +
> +		flash_char =3D asd_read_reg_byte(asd_ha, reg + nv_offset + i);
> +		if (flash_char !=3D src_buf[i]) {
> +			err =3D FAIL_VERIFY;
> +			break;
> +		}
> +	}
> +	return err;
> +}
> +
> +/**
> + * asd_write_flash_seg - write data into flash memory
> + * @asd_ha: pointer to the host adapter structure
> + * @src: pointer to the source data to be written
> + * @dest_offset: offset from flash memory
> + * @bytes_to_write: total bytes to write
> + */
> +int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
> +		void *src, u32 dest_offset, u32 bytes_to_write)
> +{
> +	u8 *src_buf;
> +	u32 nv_offset, reg, i;
> +	int err;
> +
> +

Again.

> +	reg =3D asd_ha->hw_prof.flash.bar;
> +	src_buf =3D NULL;
> +
> +	err =3D asd_check_flash_type(asd_ha);
> +	if (err) {
> +		ASD_DPRINTK("couldn't find the type of flash. err=3D%d\n", err);
> +		return err;
> +	}
> +
> +	nv_offset =3D dest_offset;
> +	err =3D asd_erase_nv_sector(asd_ha, nv_offset, bytes_to_write);
> +	if (err) {
> +		ASD_DPRINTK("Erase failed at offset:0x%x\n",
> +			nv_offset);
> +		return err;
> +	}
> +
> +	err =3D asd_reset_flash(asd_ha);
> +	if (err) {
> +		ASD_DPRINTK("couldn't reset flash. err=3D%d\n", err);
> +		return err;
> +	}
> +
> +	src_buf =3D (u8 *)src;
> +	for (i =3D 0; i < bytes_to_write; i++) {
> +		/* Setup program command sequence */
> +		switch (asd_ha->hw_prof.flash.method) {
> +
> +		case FLASH_METHOD_A:
> +		{
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
> +		if (asd_chk_write_status(asd_ha,
> +				(nv_offset + i), 0) !=3D 0) {
> +			ASD_DPRINTK("aicx: Write failed at offset:0x%x\n",
> +				reg + nv_offset + i);
> +			return FAIL_WRITE_FLASH;
> +		}
> +	}
> +
> +	err =3D asd_reset_flash(asd_ha);
> +	if (err) {
> +		ASD_DPRINTK("couldn't reset flash. err=3D%d\n", err);
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +int asd_chk_write_status(struct asd_ha_struct *asd_ha,
> +	 u32 sector_addr, u8 erase_flag)
> +{
> +	u32 reg;
> +	u32 loop_cnt;
> +	u8  nv_data1, nv_data2;
> +	u8  toggle_bit1;
> +
> +	/*
> +	 * Read from DQ2 requires sector address
> +	 * while it's dont care for DQ6
> +	 */
> +	reg =3D asd_ha->hw_prof.flash.bar;
> +
> +	for (loop_cnt =3D 0; loop_cnt < 50000; loop_cnt++) {
> +		nv_data1 =3D asd_read_reg_byte(asd_ha, reg);
> +		nv_data2 =3D asd_read_reg_byte(asd_ha, reg);
> +
> +		toggle_bit1 =3D ((nv_data1 & FLASH_STATUS_BIT_MASK_DQ6)
> +				 ^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ6));
> +
> +		if (toggle_bit1 =3D=3D 0) {
> +			return 0;
> +		} else {
> +			if (nv_data2 & FLASH_STATUS_BIT_MASK_DQ5) {
> +				nv_data1 =3D asd_read_reg_byte(asd_ha,
> +								reg);
> +				nv_data2 =3D asd_read_reg_byte(asd_ha,
> +								reg);
> +				toggle_bit1 =3D
> +				((nv_data1 & FLASH_STATUS_BIT_MASK_DQ6)
> +				^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ6));
> +
> +				if (toggle_bit1 =3D=3D 0)
> +					return 0;
> +			}
> +		}
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
> +	return -1;
> +}
> +
> +/**
> + * asd_hwi_erase_nv_sector - Erase the flash memory sectors.
> + * @asd_ha: pointer to the host adapter structure
> + * @flash_addr: pointer to offset from flash memory
> + * @size: total bytes to erase.
> + */
> +int asd_erase_nv_sector(struct asd_ha_struct *asd_ha, u32 flash_addr, u32
> size) +{
> +	u32 reg;
> +	u32 sector_addr;
> +
> +	reg =3D asd_ha->hw_prof.flash.bar;
> +
> +	/* sector staring address */
> +	sector_addr =3D flash_addr & FLASH_SECTOR_SIZE_MASK;
> +
> +	/*
> +	 * Erasing an flash sector needs to be done in six consecutive
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
> +		if (asd_chk_write_status(asd_ha, sector_addr, 1) !=3D 0)
> +			return FAIL_ERASE_FLASH;
> +
> +		sector_addr +=3D FLASH_SECTOR_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +int asd_check_flash_type(struct asd_ha_struct *asd_ha)
> +{
> +	u8 manuf_id;
> +	u8 dev_id;
> +	u8 sec_prot;
> +	u32 inc;
> +	u32 reg;
> +	int err;
> +
> +	/* get Flash memory base address */
> +	reg =3D asd_ha->hw_prof.flash.bar;
> +
> +

Again.

> +	/* Determine flash info */
> +	err =3D asd_reset_flash(asd_ha);
> +	if (err) {
> +		ASD_DPRINTK("couldn't reset flash. err=3D%d\n", err);
> +		return err;
> +	}
> +
> +	asd_ha->hw_prof.flash.method =3D FLASH_METHOD_UNKNOWN;
> +	asd_ha->hw_prof.flash.manuf =3D FLASH_MANUF_ID_UNKNOWN;
> +	asd_ha->hw_prof.flash.dev_id =3D FLASH_DEV_ID_UNKNOWN;
> +
> +	/* Get flash info. This would most likely be AMD Am29LV family flash.
> +	 * First try the sequence for word mode.  It is the same as for
> +	 * 008B (byte mode only), 160B (word mode) and 800D (word mode).
> +	 */
> +	inc =3D asd_ha->hw_prof.flash.wide ? 2 : 1;
> +	asd_write_reg_byte(asd_ha, reg + 0xAAA, 0xAA);
> +	asd_write_reg_byte(asd_ha, reg + 0x555, 0x55);
> +	asd_write_reg_byte(asd_ha, reg + 0xAAA, 0x90);
> +	manuf_id =3D asd_read_reg_byte(asd_ha, reg);
> +	dev_id =3D asd_read_reg_byte(asd_ha, reg + inc);
> +	sec_prot =3D asd_read_reg_byte(asd_ha, reg + inc + inc);
> +	/* Get out of autoselect mode. */
> +	err =3D asd_reset_flash(asd_ha);
> +	if (err) {
> +		ASD_DPRINTK("couldn't reset flash. err=3D%d\n", err);
> +		return err;
> +	}
> +	ASD_DPRINTK("Flash MethodA manuf_id(0x%x) dev_id(0x%x) "
> +		"sec_prot(0x%x)\n", manuf_id, dev_id, sec_prot);
> +	err =3D asd_reset_flash(asd_ha);
> +	if (err !=3D 0)
> +		return err;
> +
> +	switch (manuf_id) {
> +
> +	case FLASH_MANUF_ID_AMD:
> +
> +		switch (sec_prot) {
> +
> +		case FLASH_DEV_ID_AM29LV800DT:
> +		case FLASH_DEV_ID_AM29LV640MT:
> +		case FLASH_DEV_ID_AM29F800B:
> +			asd_ha->hw_prof.flash.method =3D FLASH_METHOD_A;
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
> +
> +	case FLASH_MANUF_ID_ST:
> +
> +		switch (sec_prot) {
> +
> +		case FLASH_DEV_ID_STM29W800DT:
> +		case FLASH_DEV_ID_STM29LV640:
> +			asd_ha->hw_prof.flash.method =3D FLASH_METHOD_A;
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
> +
> +	case FLASH_MANUF_ID_FUJITSU:
> +
> +		switch (sec_prot) {
> +
> +		case FLASH_DEV_ID_MBM29LV800TE:
> +		case FLASH_DEV_ID_MBM29DL800TA:
> +			asd_ha->hw_prof.flash.method =3D FLASH_METHOD_A;
> +			break;
> +
> +		}
> +		break;
> +
> +	case FLASH_MANUF_ID_MACRONIX:
> +
> +		switch (sec_prot) {
> +
> +		case FLASH_DEV_ID_MX29LV800BT:
> +			asd_ha->hw_prof.flash.method =3D FLASH_METHOD_A;
> +			break;
> +		}
> +		break;
> +	}
> +
> +	if (asd_ha->hw_prof.flash.method =3D=3D FLASH_METHOD_UNKNOWN) {
> +
> +		err =3D asd_reset_flash(asd_ha);
> +		if (err) {
> +			ASD_DPRINTK("couldn't reset flash. err=3D%d\n", err);
> +			return err;
> +		}
> +
> +		/* Issue Unlock sequence for AM29LV008BT */
> +		asd_write_reg_byte(asd_ha, (reg + 0x555), 0xAA);
> +		asd_write_reg_byte(asd_ha, (reg + 0x2AA), 0x55);
> +		asd_write_reg_byte(asd_ha, (reg + 0x555), 0x90);
> +		manuf_id =3D asd_read_reg_byte(asd_ha, reg);
> +		dev_id =3D asd_read_reg_byte(asd_ha, reg + inc);
> +		sec_prot =3D asd_read_reg_byte(asd_ha, reg + inc + inc);
> +
> +		ASD_DPRINTK("Flash MethodB manuf_id(0x%x) dev_id(0x%x) sec_prot"
> +			"(0x%x)\n", manuf_id, dev_id, sec_prot);
> +
> +		err =3D asd_reset_flash(asd_ha);
> +		if (err !=3D 0) {
> +			ASD_DPRINTK("couldn't reset flash. err=3D%d\n", err);
> +			return err;
> +		}
> +
> +		switch (manuf_id) {
> +		case FLASH_MANUF_ID_AMD:
> +
> +			switch (dev_id) {
> +
> +			case FLASH_DEV_ID_AM29LV008BT:
> +				asd_ha->hw_prof.flash.method =3D FLASH_METHOD_B;
> +				break;
> +			default:
> +				break;
> +			}
> +			break;
> +
> +		case FLASH_MANUF_ID_ST:
> +
> +			switch (dev_id) {
> +
> +			case FLASH_DEV_ID_STM29008:
> +				asd_ha->hw_prof.flash.method =3D FLASH_METHOD_B;
> +				break;
> +			default:
> +				break;
> +			}
> +			break;
> +
> +		case FLASH_MANUF_ID_FUJITSU:
> +
> +			switch (dev_id) {
> +
> +			case FLASH_DEV_ID_MBM29LV008TA:
> +				asd_ha->hw_prof.flash.method =3D FLASH_METHOD_B;
> +				break;
> +
> +			}
> +			break;
> +
> +		case FLASH_MANUF_ID_INTEL:
> +
> +			switch (dev_id) {
> +
> +			case FLASH_DEV_ID_I28LV00TAT:
> +				asd_ha->hw_prof.flash.method =3D FLASH_METHOD_B;
> +				break;
> +
> +			}
> +			break;
> +
> +		case FLASH_MANUF_ID_MACRONIX:
> +
> +			switch (dev_id) {
> +
> +			case FLASH_DEV_ID_I28LV00TAT:
> +				asd_ha->hw_prof.flash.method =3D FLASH_METHOD_B;
> +				break;
> +
> +			}
> +			break;
> +
> +		default:
> +			return FAIL_FIND_FLASH_ID;
> +		}
> +	}
> +
> +	if (asd_ha->hw_prof.flash.method =3D=3D FLASH_METHOD_UNKNOWN)
> +	      return FAIL_FIND_FLASH_ID;
> +
> +
> +	asd_ha->hw_prof.flash.manuf =3D manuf_id;
> +	asd_ha->hw_prof.flash.dev_id =3D dev_id;
> +	asd_ha->hw_prof.flash.sec_prot =3D sec_prot;
> +	return 0;
> +}
> diff -urN a/drivers/scsi/aic94xx/aic94xx_sds.h
> b/drivers/scsi/aic94xx/aic94xx_sds.h ---
> a/drivers/scsi/aic94xx/aic94xx_sds.h	1969-12-31 16:00:00.000000000 -0800
> +++ b/drivers/scsi/aic94xx/aic94xx_sds.h	2007-10-11 18:38:06.000000000
> -0700 @@ -0,0 +1,167 @@
> +/*
> + * Aic94xx SAS/SATA driver hardware interface header file.
> + *
> + * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
> + * Copyright (C) 2005 Gilbert Wu <gilbert_wu@adaptec.com>
> + *
> + * This file is licensed under GPLv2.
> + *
> + * This file is part of the aic94xx driver.
> + *
> + * The aic94xx driver is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; version 2 of the
> + * License.
> + *
> + * The aic94xx driver is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with the aic94xx driver; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301=
=20
> USA + *
> + */
> +#ifndef _AIC94XX_SDS_H_
> +#define _AIC94XX_SDS_H_
> +
> +enum {
> +	FLASH_METHOD_UNKNOWN,
> +	FLASH_METHOD_A,
> +	FLASH_METHOD_B
> +};
> +
> +#define FLASH_MANUF_ID_AMD              0x01
> +#define FLASH_MANUF_ID_ST               0x20
> +#define FLASH_MANUF_ID_FUJITSU          0x04
> +#define FLASH_MANUF_ID_MACRONIX         0xC2
> +#define FLASH_MANUF_ID_INTEL            0x89
> +#define FLASH_MANUF_ID_UNKNOWN          0xFF
> +
> +#define FLASH_DEV_ID_AM29LV008BT        0x3E
> +#define FLASH_DEV_ID_AM29LV800DT        0xDA
> +#define FLASH_DEV_ID_STM29W800DT        0xD7
> +#define FLASH_DEV_ID_STM29LV640         0xDE
> +#define FLASH_DEV_ID_STM29008           0xEA
> +#define FLASH_DEV_ID_MBM29LV800TE       0xDA
> +#define FLASH_DEV_ID_MBM29DL800TA       0x4A
> +#define FLASH_DEV_ID_MBM29LV008TA       0x3E
> +#define FLASH_DEV_ID_AM29LV640MT        0x7E
> +#define FLASH_DEV_ID_AM29F800B          0xD6
> +#define FLASH_DEV_ID_MX29LV800BT        0xDA
> +#define FLASH_DEV_ID_MX29LV008CT        0xDA
> +#define FLASH_DEV_ID_I28LV00TAT         0x3E
> +#define FLASH_DEV_ID_UNKNOWN            0xFF
> +/* status bit mask values */
> +#define FLASH_STATUS_BIT_MASK_DQ6       0x40
> +#define FLASH_STATUS_BIT_MASK_DQ5       0x20
> +#define FLASH_STATUS_BIT_MASK_DQ2       0x04
> +
> +/* minimum value in micro seconds needed for checking status */
> +#define FLASH_STATUS_ERASE_DELAY_COUNT  50
> +#define FLASH_STATUS_WRITE_DELAY_COUNT  25
> +
> +#define FLASH_SECTOR_SIZE               0x010000
> +#define FLASH_SECTOR_SIZE_MASK          0xffff0000
> +
> +
> +
> +#define FLASH_OK                        0x000000
> +#define FAIL_OPEN_BIOS_FILE             0x000100
> +#define FAIL_CHECK_PCI_ID               0x000200
> +#define FAIL_CHECK_SUM                  0x000300
> +#define FAIL_UNKNOWN                    0x000400
> +#define FAIL_VERIFY                     0x000500
> +#define FAIL_RESET_FLASH                0x000600
> +#define FAIL_FIND_FLASH_ID              0x000700
> +#define FAIL_ERASE_FLASH                0x000800
> +#define FAIL_WRITE_FLASH                0x000900
> +#define FAIL_FILE_SIZE                  0x000a00
> +#define FAIL_PARAMETERS                 0x000b00
> +#define FAIL_OUT_MEMORY                 0x000c00
> +#define FLASH_IN_PROGRESS               0x001000
> +
> +

Double newline again.

> +struct controller_id
> +{
> +    u32 vendor;
> +    /* PCI Vendor ID */
> +
> +    u32 device;
> +    /* PCI Device ID */
> +
> +    u32 sub_vendor;
> +    /* PCI Subvendor ID */
> +
> +    u32 sub_device;
> +    /* PCI Subdevice ID */
> +
> +};
> +struct image_info

Newline missing here.

> +{
> +	u32 ImageId;
> +	/*Identifies the image(e.g 0=3DFootbridge image,1=3DDrawbridge image)*/
> +
> +	u32 ImageOffset;
> +	/*Offset of the image from the beginning of the file*/
> +
> +	u32 ImageLength;
> +	/*length of the image*/
> +
> +	u32 ImageChecksum;
> +	/*Image checksum*/
> +
> +	u32 ImageVersion;
> +	/*Version of the image, could be build number*/
> +};
> +
> +struct bios_file_header
> +{
> +	u8 signature[32];
> +	/* Signature/Cookie to identify the file*/
> +	/* The signature above is only 25 characters long.  */
> +
> +	u32 checksum;
> +	/*Entire file checksum with this field zero*/
> +
> +	u32 antidote;
> +	/*Entire file checksum antidote with this field 0xFFFFFFFF*/
> +
> +	struct controller_id contrl_id;
> +	/*Controller id to identify the controller whose images are*/
> +	/*stored in the file.  */
> +
> +	u32 filelen;
> +	/*Length of the entire file*/
> +
> +	u32 chunk_num;
> +	/*The chunk/part number of this DOS file in case the Image */
> +	/*is stored in parts in multiple DOS files across floppies*/
> +
> +	u32 total_chunks;
> +	/*Total number of chunks/parts in which the image file is stored*/
> +
> +	u32 num_images;
> +	/*Number of images in the file,e.g Footbridge image, Drawbridge image*/
> +
> +	u32 build_num;
> +	/*Build number of the process that generated this image*/
> +
> +	struct image_info image_header;
> +};
> +
> +int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
> +		void *src, u32 dest_offset, u32 bytes_to_verify);
> +int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
> +		void *src, u32 dest_offset, u32 bytes_to_write);
> +int asd_chk_write_status(struct asd_ha_struct *asd_ha,
> +		u32 sector_addr, u8 erase_flag);
> +int asd_check_flash_type(struct asd_ha_struct *asd_ha);
> +int asd_erase_nv_sector(struct asd_ha_struct *asd_ha,
> +		u32 flash_addr, u32 size);
> +#endif
> +
> +
> +
> +

Trailing newline garbage.

--nextPart2398027.h8A6enNebp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHE8A+XKSJPmm5/E4RAgeSAJ922L0N0Hyn2QCtvwK+FeNZEB1yjwCeN/6K
cm4WPxX/K46ap8QMJIRGCpU=
=lNko
-----END PGP SIGNATURE-----

--nextPart2398027.h8A6enNebp--
