From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/7] aacraid: vpd page code 0x83 support
Date: Wed, 18 Mar 2015 12:26:01 +0100
Message-ID: <550960C9.4090804@suse.de>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com> <1425458313-1956-6-git-send-email-Mahesh.Rajashekhara@pmcs.com> <307F48E420013C4E85C75C93E532197AB809204C@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbbCRL0D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2015 07:26:03 -0400
In-Reply-To: <307F48E420013C4E85C75C93E532197AB809204C@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <Achim.Leubner@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/17/2015 04:27 PM, Achim Leubner wrote:
> Reviewed-by: Achim Leubner <Achim.Leubner@pmcs.com>
>=20
>=20
> -----Original Message-----
> From: Mahesh Rajashekhara=20
> Sent: Wednesday, March 4, 2015 9:39 AM
> To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
> Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pa=
ndurangan; Rich Bono; Mahesh Rajashekhara
> Subject: [PATCH 5/7] aacraid: vpd page code 0x83 support
>=20
> Add vpd page code 0x83 support
>=20
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
> ---
>  drivers/scsi/aacraid/aachba.c   |  154 +++++++++++++++++++++++++++++=
+++++++---
>  drivers/scsi/aacraid/aacraid.h  |    4 +
>  drivers/scsi/aacraid/comminit.c |    8 ++-
>  drivers/scsi/aacraid/commsup.c  |   12 +---
>  drivers/scsi/aacraid/linit.c    |   20 +----
>  drivers/scsi/aacraid/src.c      |   34 +++++++--
>  6 files changed, 185 insertions(+), 47 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aac=
hba.c index eb524e6..3e4e0c8 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -163,6 +163,45 @@ struct inquiry_data {
>  	u8 inqd_prl[4];	/* Product Revision Level */
>  };
> =20
> +/* Added for VPD 0x83 */
> +typedef struct {
> +	u8 CodeSet:4;	/* VPD_CODE_SET */
> +	u8 Reserved:4;
> +	u8 IdentifierType:4;	/* VPD_IDENTIFIER_TYPE */
> +	u8 Reserved2:4;
> +	u8 Reserved3;
> +	u8 IdentifierLength;
> +	u8 VendId[8];
> +	u8 ProductId[16];
> +	u8 SerialNumber[8];	/* SN in ASCII */
> +} TVPD_ID_Descriptor_Type_1;
> +
> +typedef struct {
> +	u8 CodeSet:4;	/* VPD_CODE_SET */
> +	u8 Reserved:4;
> +	u8 IdentifierType:4;	/* VPD_IDENTIFIER_TYPE */
> +	u8 Reserved2:4;
> +	u8 Reserved3;
> +	u8 IdentifierLength;
> +	struct TEU64Id {
> +		u32 Serial;
> +		 /* The serial number supposed to be 40 bits,
> +		  * bit we only support 32, so make the last byte zero. */
> +		u8 Reserved;
> +		u8 VendId[3];
> +	} EU64Id;
> +} TVPD_ID_Descriptor_Type_2;
> +
> +typedef struct {
> +	u8 DeviceType:5;
> +	u8 DeviceTypeQualifier:3;
> +	u8 PageCode;
> +	u8 Reserved;
> +	u8 PageLength;
> +	TVPD_ID_Descriptor_Type_1 IdDescriptorType1;
> +	TVPD_ID_Descriptor_Type_2 IdDescriptorType2; } TVPD_Page83;
> +
>  /*
>   *              M O D U L E   G L O B A L S
>   */
> @@ -420,6 +459,9 @@ int aac_get_containers(struct aac_dev *dev)
>  	if (status >=3D 0) {
>  		dresp =3D (struct aac_get_container_count_resp *)fib_data(fibptr);
>  		maximum_num_containers =3D le32_to_cpu(dresp->ContainerSwitchEntri=
es);
> +		if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
> +		    AAC_OPTION_SUPPORTED_240_VOLUMES)
> +			maximum_num_containers =3D le32_to_cpu(dresp->MaxSimpleVolumes);
>  		aac_fib_complete(fibptr);
>  	}
>  	/* FIB should be freed only after getting the response from the F/W=
 */ @@ -889,14 +931,81 @@ static void get_container_serial_callback(voi=
d *context, struct fib * fibptr)

Garbled patch?

>  	get_serial_reply =3D (struct aac_get_serial_resp *) fib_data(fibptr=
);
>  	/* Failure is irrelevant, using default value instead */
>  	if (le32_to_cpu(get_serial_reply->status) =3D=3D CT_OK) {
> -		char sp[13];
> -		/* EVPD bit set */
> -		sp[0] =3D INQD_PDT_DA;
> -		sp[1] =3D scsicmd->cmnd[2];
> -		sp[2] =3D 0;
> -		sp[3] =3D snprintf(sp+4, sizeof(sp)-4, "%08X",
> -		  le32_to_cpu(get_serial_reply->uid));
> -		scsi_sg_copy_from_buffer(scsicmd, sp, sizeof(sp));
> +		/*Check to see if it's for VPD 0x83 or 0x80 */
> +		if (scsicmd->cmnd[2] =3D=3D 0x83) {
> +			/* vpd page 0x83 - Device Identification Page */
> +			int i;
> +			TVPD_Page83 VPDPage83Data;
> +
> +			memset(((u8 *)&VPDPage83Data), 0,
> +			       sizeof(VPDPage83Data));
> +
> +			/* DIRECT_ACCESS_DEVIC */
> +			VPDPage83Data.DeviceType =3D 0;
> +			/* DEVICE_CONNECTED */
> +			VPDPage83Data.DeviceTypeQualifier =3D 0;
> +			/* VPD_DEVICE_IDENTIFIERS */
> +			VPDPage83Data.PageCode =3D 0x83;
> +			VPDPage83Data.Reserved =3D 0;
> +			VPDPage83Data.PageLength =3D sizeof(VPDPage83Data.IdDescriptorTyp=
e1) +
> +				sizeof(VPDPage83Data.IdDescriptorType2);
> +
> +			/* T10 Vendor Identifier Field Format */
> +			/* VpdCodeSetAscii */
> +			VPDPage83Data.IdDescriptorType1.CodeSet =3D 2;
> +			/* VpdIdentifierTypeVendorId */
> +			VPDPage83Data.IdDescriptorType1.IdentifierType =3D 1;
> +			VPDPage83Data.IdDescriptorType1.IdentifierLength =3D=20
> +sizeof(VPDPage83Data.IdDescriptorType1) - 4;
> +
Wrong indentation.

> +			/* "ADAPTEC " for adaptec */
> +			memcpy(VPDPage83Data.IdDescriptorType1.VendId, "ADAPTEC ",
> +				sizeof(VPDPage83Data.IdDescriptorType1.VendId));
> +			memcpy(VPDPage83Data.IdDescriptorType1.ProductId, "ARRAY         =
  ",
> +				sizeof(VPDPage83Data.IdDescriptorType1.ProductId));
> +
> +			/* Convert to ascii based serial number.
> +			 * The LSB is the the end.
> +			 */
> +			for (i =3D 0; i < 8; i++) {
> +				u8 temp =3D (u8)((get_serial_reply->uid >> ((7 - i) * 4)) & 0xF)=
;
> +				if (temp  > 0x9) {
> +					VPDPage83Data.IdDescriptorType1.SerialNumber[i] =3D 'A' + (temp=
 - 0xA);
> +				} else {
> +					VPDPage83Data.IdDescriptorType1.SerialNumber[i] =3D '0' + temp;
> +				}
> +			}
> +
> +			/* EUI-64 Vendor Identifier Field Format,
> +			 * 24 bits for VendId and 40 bits for SN.
> +			 */
> +			/* VpdCodeSetBinary */
> +			VPDPage83Data.IdDescriptorType2.CodeSet =3D 1;
> +			/* VpdIdentifierTypeEUI64 */
> +			VPDPage83Data.IdDescriptorType2.IdentifierType =3D 2;
> +			VPDPage83Data.IdDescriptorType2.IdentifierLength =3D=20
> +sizeof(VPDPage83Data.IdDescriptorType2) - 4;
> +
Same here.
> +			/* 0x0000055 for IBM, 0x0000D0 for Adaptec */

Do you ever use the IBM Vendor ID?
If not, why do you mention it here?

> +			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[0] =3D 0xD0;
> +			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[1] =3D 0;
> +			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[2] =3D 0;
> +
> +			VPDPage83Data.IdDescriptorType2.EU64Id.Serial =3D get_serial_repl=
y->uid;
> +			VPDPage83Data.IdDescriptorType2.EU64Id.Reserved =3D 0;
> +
> +			/* Move the inquiry data to the response buffer. */
> +			scsi_sg_copy_from_buffer(scsicmd, &VPDPage83Data,
> +						 sizeof(VPDPage83Data));
> +		} else {
> +			/* It must be for VPD 0x80 */
> +			char sp[13];
> +			/* EVPD bit set */
> +			sp[0] =3D INQD_PDT_DA;
> +			sp[1] =3D scsicmd->cmnd[2];
> +			sp[2] =3D 0;
> +			sp[3] =3D snprintf(sp+4, sizeof(sp)-4, "%08X",
> +				le32_to_cpu(get_serial_reply->uid));
> +			scsi_sg_copy_from_buffer(scsicmd, sp, sizeof(sp));
> +		}
>  	}
> =20
>  	scsicmd->result =3D DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT=
_GOOD; @@ -2302,9 +2411,10 @@ int aac_scsi_cmd(struct scsi_cmnd * scsic=
md)
>  			  INQD_PDT_PROC : INQD_PDT_DA;
>  			if (scsicmd->cmnd[2] =3D=3D 0) {
>  				/* supported vital product data pages */
> -				arr[3] =3D 2;
> +				arr[3] =3D 3;
>  				arr[4] =3D 0x0;
>  				arr[5] =3D 0x80;
> +				arr[6] =3D 0x83;
>  				arr[1] =3D scsicmd->cmnd[2];
>  				scsi_sg_copy_from_buffer(scsicmd, &inq_data,
>  							 sizeof(inq_data));
> @@ -2323,6 +2433,16 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>  				/* SLES 10 SP1 special */
Gods. Are we still in there?
I guess it's time to remove that, at least the comment ...

>  				scsicmd->result =3D DID_OK << 16 |
>  				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
> +			} else if (scsicmd->cmnd[2] =3D=3D 0x83) {
> +				/* vpd page 0x83 - Device Identification Page */
> +				char *sno =3D (char *)&inq_data;
> +				sno[3] =3D setinqserial(dev, &sno[4],
> +						      scmd_id(scsicmd));
> +				if (aac_wwn !=3D 2)
> +					return aac_get_container_serial(
> +						scsicmd);
> +				scsicmd->result =3D DID_OK << 16 |
> +				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
>  			} else {
>  				/* vpd page not implemented */
>  				scsicmd->result =3D DID_OK << 16 |
> @@ -2468,6 +2588,15 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>  			mpd.bd.block_length[0] =3D (fsa_dev_ptr[cid].block_size >> 16) & =
0xff;
>  			mpd.bd.block_length[1] =3D (fsa_dev_ptr[cid].block_size >> 8) &  =
0xff;
>  			mpd.bd.block_length[2] =3D fsa_dev_ptr[cid].block_size  & 0xff;
> +
> +			mpd.mpc_buf[0] =3D scsicmd->cmnd[2];
> +			if (scsicmd->cmnd[2] =3D=3D 0x1C) {
> +				mpd.mpc_buf[1] =3D 0xa;	/* page length */
> +				mpd.hd.data_length =3D 23;	/* Mode data length */
> +			} else {
> +				mpd.hd.data_length =3D 15;	/* Mode data length */
> +			}
> +
>  			if (capacity > 0xffffff) {
>  				mpd.bd.block_count[0] =3D 0xff;
>  				mpd.bd.block_count[1] =3D 0xff;
> @@ -2486,9 +2615,12 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>  			mpd.mpc_buf[2] =3D ((aac_cache & 6) =3D=3D 2)
>  				? 0 : 0x04; /* WCE */
>  			mode_buf_length =3D sizeof(mpd);
> -			if (mode_buf_length > scsicmd->cmnd[4])
> -				mode_buf_length =3D scsicmd->cmnd[4];
>  		}
> +
> +		if (mode_buf_length > scsicmd->cmnd[4])
> +			mode_buf_length =3D scsicmd->cmnd[4];
> +		else
> +			mode_buf_length =3D sizeof(mpd);
>  		scsi_sg_copy_from_buffer(scsicmd, (char *)&mpd, mode_buf_length);
>  		scsicmd->result =3D DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STA=
T_GOOD;
>  		scsicmd->scsi_done(scsicmd);
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h index c162a65..a37762e 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1015,6 +1015,7 @@ struct aac_supplement_adapter_info
>  #define AAC_OPTION_POWER_MANAGEMENT	cpu_to_le32(0x00000004)
>  #define AAC_OPTION_DOORBELL_RESET	cpu_to_le32(0x00004000)
>  #define AAC_OPTION_VARIABLE_BLOCK_SIZE	cpu_to_le32(0x00040000) /* 4K=
B sector size */
> +#define AAC_OPTION_SUPPORTED_240_VOLUMES	cpu_to_le32(0x10000000)
>  #define AAC_SIS_VERSION_V3	3
>  #define AAC_SIS_SLOT_UNKNOWN	0xFF
> =20
> @@ -1212,11 +1213,13 @@ struct aac_dev
>  	int			sync_mode;
>  	struct fib		*sync_fib;
>  	struct list_head	sync_fib_list;
> +	u32			doorbell_mask;	/* from GET_ADAPTER_PROP */
>  	u32			max_msix;	/* max. MSI-X vectors */
>  	u32			vector_cap;	/* MSI-X vector capab.*/
>  	int			msi_enabled;	/* MSI/MSI-X enabled */
>  	struct msix_entry	msixentry[AAC_MAX_MSIX];
>  	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
> +	u8			adapter_shutdown;
>  };
> =20
>  #define aac_adapter_interrupt(dev) \
> @@ -1749,6 +1752,7 @@ struct aac_get_container_count_resp {
>  	__le32		MaxContainers;
>  	__le32		ContainerSwitchEntries;
>  	__le32		MaxPartitions;
> +	__le32		MaxSimpleVolumes;
>  };
> =20
> =20
What exactly has this to do with VPD page support?
Please split if off into a separate patch.

> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/c=
omminit.c index 29c35c8..c3e13ae 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -53,7 +53,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void=
 **commaddr, unsigned long co  {
>  	unsigned char *base;
>  	unsigned long size, align;
> -	const unsigned long fibsize =3D 4096;
> +	const unsigned long fibsize =3D dev->max_fib_size;
>  	const unsigned long printfbufsiz =3D 256;
>  	unsigned long host_rrq_size =3D 0;
>  	struct aac_init *init;
> @@ -230,6 +230,7 @@ int aac_send_shutdown(struct aac_dev * dev)
>  	/* FIB should be freed only after getting the response from the F/W=
 */
>  	if (status !=3D -ERESTARTSYS)
>  		aac_fib_free(fibctx);
> +	dev->adapter_shutdown =3D 1;
>  	if ((dev->pdev->device =3D=3D PMC_DEVICE_S7 ||
>  	     dev->pdev->device =3D=3D PMC_DEVICE_S8 ||
>  	     dev->pdev->device =3D=3D PMC_DEVICE_S9) && @@ -357,8 +358,9 @@=
 struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>  	dev->raw_io_interface =3D dev->raw_io_64 =3D 0;
> =20
>  	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
> -		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
> +		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, status+3, NULL)) &=
&
>  	 		(status[0] =3D=3D 0x00000001)) {
> +		dev->doorbell_mask =3D status[3];
>  		if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
>  			dev->raw_io_64 =3D 1;
>  		dev->sync_mode =3D aac_sync_mode;
> @@ -397,6 +399,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *=
dev)
>  	}
>  	dev->max_msix =3D 0;
>  	dev->msi_enabled =3D 0;
> +	dev->adapter_shutdown =3D 0;
>  	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
>  	  0, 0, 0, 0, 0, 0,
>  	  status+0, status+1, status+2, status+3, status+4)) @@ -508,6 +511=
,7 @@ static void aac_define_int_mode(struct aac_dev *dev)
> =20
>  	int i, msi_count;
> =20
> +	msi_count =3D i =3D 0;
>  	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */
>  	if (dev->max_msix =3D=3D 0 ||
>  	    dev->pdev->device =3D=3D PMC_DEVICE_S6 || diff --git a/drivers/=
scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c index 83c5d3f..=
2bed445 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -208,14 +208,11 @@ struct fib *aac_fib_alloc(struct aac_dev *dev)
> =20
>  void aac_fib_free(struct fib *fibptr)
>  {
> -	unsigned long flags, flagsv;
> +	unsigned long flags;
> =20
> -	spin_lock_irqsave(&fibptr->event_lock, flagsv);
>  	if (fibptr->done =3D=3D 2) {
> -		spin_unlock_irqrestore(&fibptr->event_lock, flagsv);
>  		return;
>  	}
> -	spin_unlock_irqrestore(&fibptr->event_lock, flagsv);
> =20
>  	spin_lock_irqsave(&fibptr->dev->fib_lock, flags);
>  	if (unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) @@ -775,7=
 +772,6 @@ int aac_fib_adapter_complete(struct fib *fibptr, unsigned sh=
ort size)
> =20
>  int aac_fib_complete(struct fib *fibptr)  {
> -	unsigned long flags;
>  	struct hw_fib * hw_fib =3D fibptr->hw_fib_va;
> =20
>  	/*
> @@ -798,12 +794,6 @@ int aac_fib_complete(struct fib *fibptr)
>  	 *	command is complete that we had sent to the adapter and this
>  	 *	cdb could be reused.
>  	 */
> -	spin_lock_irqsave(&fibptr->event_lock, flags);
> -	if (fibptr->done =3D=3D 2) {
> -		spin_unlock_irqrestore(&fibptr->event_lock, flags);
> -		return 0;
> -	}
> -	spin_unlock_irqrestore(&fibptr->event_lock, flags);
> =20
>  	if((hw_fib->header.XferState & cpu_to_le32(SentFromHost)) &&
>  		(hw_fib->header.XferState & cpu_to_le32(AdapterProcessed))) diff -=
-git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c inde=
x 7813a9b..4c5ba9e 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -56,7 +56,7 @@
> =20
>  #include "aacraid.h"
> =20
> -#define AAC_DRIVER_VERSION		"1.2-0"
> +#define AAC_DRIVER_VERSION		"1.2-1"
>  #ifndef AAC_DRIVER_BRANCH
>  #define AAC_DRIVER_BRANCH		""
>  #endif
> @@ -65,7 +65,7 @@
>  #ifdef AAC_DRIVER_BUILD
>  #define _str(x) #x
>  #define str(x) _str(x)
> -#define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION "[" str(AAC_DRIVE=
R_BUILD) "]" AAC_DRIVER_BRANCH
> +#define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION "." str(AAC_DRIVE=
R_BUILD) "" AAC_DRIVER_BRANCH
>  #else
>  #define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION AAC_DRIVER_BRANCH
>  #endif
> @@ -253,19 +253,7 @@ static struct aac_driver_ident aac_drivers[] =3D=
 {
> =20
>  static int aac_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(=
struct scsi_cmnd *))  {
> -	struct Scsi_Host *host =3D cmd->device->host;
> -	struct aac_dev *dev =3D (struct aac_dev *)host->hostdata;
> -	u32 count =3D 0;
>  	cmd->scsi_done =3D done;
> -	for (; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
> -		struct fib * fib =3D &dev->fibs[count];
> -		struct scsi_cmnd * command;
> -		if (fib->hw_fib_va->header.XferState &&
> -		    ((command =3D fib->callback_data)) &&
> -		    (command =3D=3D cmd) &&
> -		    (cmd->SCp.phase =3D=3D AAC_OWNER_FIRMWARE))
> -			return 0; /* Already owned by Adapter */
> -	}
>  	cmd->SCp.phase =3D AAC_OWNER_LOWLEVEL;
>  	return (aac_scsi_cmd(cmd) ? FAILED : 0);  } @@ -713,7 +701,9 @@ sta=
tic long aac_cfg_ioctl(struct file *file,
>  		unsigned int cmd, unsigned long arg)
>  {
>  	int ret;
> -	if (!capable(CAP_SYS_RAWIO))
> +	struct aac_dev *aac;
> +	aac =3D (struct aac_dev *)file->private_data;
> +	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
>  		return -EPERM;
>  	mutex_lock(&aac_mutex);
>  	ret =3D aac_do_ioctl(file->private_data, cmd, (void __user *)arg); =
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c in=
dex c010248..82ff025 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -200,6 +200,7 @@ static int src_sync_cmd(struct aac_dev *dev, u32 =
command,
>  	u32 *status, u32 * r1, u32 * r2, u32 * r3, u32 * r4)  {
>  	unsigned long start;
> +	unsigned long delay;
>  	int ok;
> =20
>  	/*
> @@ -240,10 +241,15 @@ static int src_sync_cmd(struct aac_dev *dev, u3=
2 command,
>  		ok =3D 0;
>  		start =3D jiffies;
> =20
> -		/*
> -		 *	Wait up to 5 minutes
> -		 */
> -		while (time_before(jiffies, start+300*HZ)) {
> +		if (command =3D=3D IOP_RESET_ALWAYS) {
> +			/* Wait up to 10 sec */
> +			delay =3D 10*HZ;
> +		} else {
> +			/* Wait up to 5 minutes */
> +			delay =3D 300*HZ;
> +		}
> +		while (time_before(jiffies, start+delay)) {
> +
>  			udelay(5);	/* Delay 5 microseconds to let Mon960 get info. */
>  			/*
>  			 *	Mon960 will set doorbell0 bit when it has completed the comman=
d.
> @@ -562,10 +568,16 @@ static int aac_src_restart_adapter(struct aac_d=
ev *dev, int bled)
>  		if (bled)
>  			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
>  				dev->name, dev->id, bled);
> +		dev->a_ops.adapter_enable_int =3D aac_src_disable_interrupt;
>  		bled =3D aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
>  			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL, NULL);
> -			if (bled || (var !=3D 0x00000001))
> +			if ((bled || (var !=3D 0x00000001)) && !dev->doorbell_mask)
>  				return -EINVAL;
> +			else if (dev->doorbell_mask) {
> +				reset_mask =3D dev->doorbell_mask;
> +				bled =3D 0;
> +				var =3D 0x00000001;
> +			}
> =20
>  		if ((dev->pdev->device =3D=3D PMC_DEVICE_S7 ||
>  		    dev->pdev->device =3D=3D PMC_DEVICE_S8 || @@ -575,10 +587,13 @=
@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
>  			msleep(5000); /* Delay 5 seconds */
>  		}
> =20
> -		if (dev->supplement_adapter_info.SupportedOptions2 &
> -			AAC_OPTION_DOORBELL_RESET) {
> +		if (!bled && (dev->supplement_adapter_info.SupportedOptions2 &
> +			AAC_OPTION_DOORBELL_RESET)) {
>  			src_writel(dev, MUnit.IDR, reset_mask);
>  			ssleep(45);
> +		} else {
> +			src_writel(dev, MUnit.IDR, 0x100);
> +			ssleep(45);
>  		}
>  	}
> =20
> @@ -600,7 +615,6 @@ int aac_src_select_comm(struct aac_dev *dev, int =
comm)  {
>  	switch (comm) {
>  	case AAC_COMM_MESSAGE:
> -		dev->a_ops.adapter_enable_int =3D aac_src_enable_interrupt_message=
;
>  		dev->a_ops.adapter_intr =3D aac_src_intr_message;
>  		dev->a_ops.adapter_deliver =3D aac_src_deliver_message;
>  		break;
> @@ -698,6 +712,7 @@ int aac_src_init(struct aac_dev *dev)
>  	 */
>  	dev->a_ops.adapter_interrupt =3D aac_src_interrupt_adapter;
>  	dev->a_ops.adapter_disable_int =3D aac_src_disable_interrupt;
> +	dev->a_ops.adapter_enable_int =3D aac_src_disable_interrupt;
>  	dev->a_ops.adapter_notify =3D aac_src_notify_adapter;
>  	dev->a_ops.adapter_sync_cmd =3D src_sync_cmd;
>  	dev->a_ops.adapter_check_health =3D aac_src_check_health; @@ -735,6=
 +750,7 @@ int aac_src_init(struct aac_dev *dev)
>  	dev->dbg_base =3D pci_resource_start(dev->pdev, 2);
>  	dev->dbg_base_mapped =3D dev->regs.src.bar1;
>  	dev->dbg_size =3D AAC_MIN_SRC_BAR1_SIZE;
> +	dev->a_ops.adapter_enable_int =3D aac_src_enable_interrupt_message;
> =20
>  	aac_adapter_enable_int(dev);
> =20
> @@ -861,6 +877,7 @@ int aac_srcv_init(struct aac_dev *dev)
>  	 */
>  	dev->a_ops.adapter_interrupt =3D aac_src_interrupt_adapter;
>  	dev->a_ops.adapter_disable_int =3D aac_src_disable_interrupt;
> +	dev->a_ops.adapter_enable_int =3D aac_src_disable_interrupt;
>  	dev->a_ops.adapter_notify =3D aac_src_notify_adapter;
>  	dev->a_ops.adapter_sync_cmd =3D src_sync_cmd;
>  	dev->a_ops.adapter_check_health =3D aac_src_check_health; @@ -913,6=
 +930,7 @@ int aac_srcv_init(struct aac_dev *dev)
>  	dev->dbg_base =3D dev->base_start;
>  	dev->dbg_base_mapped =3D dev->base;
>  	dev->dbg_size =3D dev->base_size;
> +	dev->a_ops.adapter_enable_int =3D aac_src_enable_interrupt_message;
> =20
>  	aac_adapter_enable_int(dev);
> =20
> --
> 1.7.7.3
>=20
Please split off the unrelated bits into a separate patch. Otherwise
tracking and regression testing becomes really hard.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
