From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/7] aacraid: 4KB sector support
Date: Wed, 18 Mar 2015 12:06:09 +0100
Message-ID: <55095C21.3030102@suse.de>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com> <1425458313-1956-4-git-send-email-Mahesh.Rajashekhara@pmcs.com> <307F48E420013C4E85C75C93E532197AB8092033@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbbCRLGL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2015 07:06:11 -0400
In-Reply-To: <307F48E420013C4E85C75C93E532197AB8092033@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <Achim.Leubner@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/17/2015 04:26 PM, Achim Leubner wrote:
> Reviewed-by: Achim Leubner <Achim.Leubner@pmcs.com>
>=20
>=20
> -----Original Message-----
> From: Mahesh Rajashekhara=20
> Sent: Wednesday, March 4, 2015 9:38 AM
> To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
> Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pa=
ndurangan; Rich Bono; Mahesh Rajashekhara
> Subject: [PATCH 3/7] aacraid: 4KB sector support
>=20
> Add 4KB sector support
>=20
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
> ---
>  drivers/scsi/aacraid/aachba.c  |  195 ++++++++++++++++++++++++++++++=
+---------
>  drivers/scsi/aacraid/aacraid.h |   10 ++-
>  2 files changed, 160 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aac=
hba.c index b32e77d..0819644 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -111,6 +111,41 @@
>  #define BYTE2(x) (unsigned char)((x) >> 16)  #define BYTE3(x) (unsig=
ned char)((x) >> 24)
> =20
> +/* MODE_SENSE data format */
> +typedef struct {
> +	struct {
> +		u8	data_length;
> +		u8	med_type;
> +		u8	dev_par;
> +		u8	bd_length;
> +	} __attribute__((packed)) hd;
> +	struct {
> +		u8	dens_code;
> +		u8	block_count[3];
> +		u8	reserved;
> +		u8	block_length[3];
> +	} __attribute__((packed)) bd;
> +		u8	mpc_buf[3];
> +} __attribute__((packed)) aac_modep_data;
> +
> +/* MODE_SENSE_10 data format */
> +typedef struct {
> +	struct {
> +		u8	data_length[2];
> +		u8	med_type;
> +		u8	dev_par;
> +		u8	rsrvd[2];
> +		u8	bd_length[2];
> +	} __attribute__((packed)) hd;
> +	struct {
> +		u8	dens_code;
> +		u8	block_count[3];
> +		u8	reserved;
> +		u8	block_length[3];
> +	} __attribute__((packed)) bd;
> +		u8	mpc_buf[3];
> +} __attribute__((packed)) aac_modep10_data;
> +
>  /*------------------------------------------------------------------=
------------
>   *              S T R U C T S / T Y P E D E F S
>   *------------------------------------------------------------------=
----------*/
> @@ -539,6 +574,13 @@ static void _aac_probe_container2(void * context=
, struct fib * fibptr)
>  		if ((le32_to_cpu(dresp->status) =3D=3D ST_OK) &&
>  		    (le32_to_cpu(dresp->mnt[0].vol) !=3D CT_NONE) &&
>  		    (le32_to_cpu(dresp->mnt[0].state) !=3D FSCS_HIDDEN)) {
> +			if (!(fibptr->dev->supplement_adapter_info.SupportedOptions2 &
> +			    AAC_OPTION_VARIABLE_BLOCK_SIZE)) {
> +				dresp->mnt[0].fileinfo.bdevinfo.block_size =3D 0x200;
> +				fsa_dev_ptr->block_size =3D 0x200;
> +			} else {
> +				fsa_dev_ptr->block_size =3D le32_to_cpu(dresp->mnt[0].fileinfo.b=
devinfo.block_size);
> +			}
>  			fsa_dev_ptr->valid =3D 1;
>  			/* sense_key holds the current state of the spin-up */
>  			if (dresp->mnt[0].state & cpu_to_le32(FSCS_NOT_READY)) @@ -586,7 =
+628,12 @@ static void _aac_probe_container1(void * context, struct fib=
 * fibptr)
> =20
>  	dinfo =3D (struct aac_query_mount *)fib_data(fibptr);
> =20
> -	dinfo->command =3D cpu_to_le32(VM_NameServe64);
> +	if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
> +	    AAC_OPTION_VARIABLE_BLOCK_SIZE)
> +		dinfo->command =3D cpu_to_le32(VM_NameServeAllBlk);
> +	else
> +		dinfo->command =3D cpu_to_le32(VM_NameServe64);
> +
>  	dinfo->count =3D cpu_to_le32(scmd_id(scsicmd));
>  	dinfo->type =3D cpu_to_le32(FT_FILESYS);
> =20
> @@ -621,7 +668,12 @@ static int _aac_probe_container(struct scsi_cmnd=
 * scsicmd, int (*callback)(stru
> =20
>  		dinfo =3D (struct aac_query_mount *)fib_data(fibptr);
> =20
> -		dinfo->command =3D cpu_to_le32(VM_NameServe);
> +		if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
> +		    AAC_OPTION_VARIABLE_BLOCK_SIZE)
> +			dinfo->command =3D cpu_to_le32(VM_NameServeAllBlk);
> +		else
> +			dinfo->command =3D cpu_to_le32(VM_NameServe);
> +
>  		dinfo->count =3D cpu_to_le32(scmd_id(scsicmd));
>  		dinfo->type =3D cpu_to_le32(FT_FILESYS);
>  		scsicmd->SCp.ptr =3D (char *)callback;
> @@ -982,7 +1034,7 @@ static int aac_read_raw_io(struct fib * fib, str=
uct scsi_cmnd * cmd, u64 lba, u3
>  		memset(readcmd2, 0, sizeof(struct aac_raw_io2));
>  		readcmd2->blockLow =3D cpu_to_le32((u32)(lba&0xffffffff));
>  		readcmd2->blockHigh =3D cpu_to_le32((u32)((lba&0xffffffff00000000L=
L)>>32));
> -		readcmd2->byteCount =3D cpu_to_le32(count<<9);
> +		readcmd2->byteCount =3D cpu_to_le32(count *=20
> +dev->fsa_dev[scmd_id(cmd)].block_size);

Wrong indentation.

>  		readcmd2->cid =3D cpu_to_le16(scmd_id(cmd));
>  		readcmd2->flags =3D cpu_to_le16(RIO2_IO_TYPE_READ);
>  		ret =3D aac_build_sgraw2(cmd, readcmd2, @@ -997,7 +1049,7 @@ stati=
c int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba=
, u3
>  		readcmd =3D (struct aac_raw_io *) fib_data(fib);
>  		readcmd->block[0] =3D cpu_to_le32((u32)(lba&0xffffffff));
>  		readcmd->block[1] =3D cpu_to_le32((u32)((lba&0xffffffff00000000LL)=
>>32));
> -		readcmd->count =3D cpu_to_le32(count<<9);
> +		readcmd->count =3D cpu_to_le32(count *=20
> +dev->fsa_dev[scmd_id(cmd)].block_size);

Same here.

>  		readcmd->cid =3D cpu_to_le16(scmd_id(cmd));
>  		readcmd->flags =3D cpu_to_le16(RIO_TYPE_READ);
>  		readcmd->bpTotal =3D 0;
> @@ -1062,6 +1114,7 @@ static int aac_read_block(struct fib * fib, str=
uct scsi_cmnd * cmd, u64 lba, u32  {
>  	u16 fibsize;
>  	struct aac_read *readcmd;
> +	struct aac_dev *dev =3D fib->dev;
>  	long ret;
> =20
>  	aac_fib_init(fib);
> @@ -1069,7 +1122,7 @@ static int aac_read_block(struct fib * fib, str=
uct scsi_cmnd * cmd, u64 lba, u32
>  	readcmd->command =3D cpu_to_le32(VM_CtBlockRead);
>  	readcmd->cid =3D cpu_to_le32(scmd_id(cmd));
>  	readcmd->block =3D cpu_to_le32((u32)(lba&0xffffffff));
> -	readcmd->count =3D cpu_to_le32(count * 512);
> +	readcmd->count =3D cpu_to_le32(count *=20
> +dev->fsa_dev[scmd_id(cmd)].block_size);
> =20

Here.

>  	ret =3D aac_build_sg(cmd, &readcmd->sg);
>  	if (ret < 0)
> @@ -1104,7 +1157,7 @@ static int aac_write_raw_io(struct fib * fib, s=
truct scsi_cmnd * cmd, u64 lba, u
>  		memset(writecmd2, 0, sizeof(struct aac_raw_io2));
>  		writecmd2->blockLow =3D cpu_to_le32((u32)(lba&0xffffffff));
>  		writecmd2->blockHigh =3D cpu_to_le32((u32)((lba&0xffffffff00000000=
LL)>>32));
> -		writecmd2->byteCount =3D cpu_to_le32(count<<9);
> +		writecmd2->byteCount =3D cpu_to_le32(count *=20
> +dev->fsa_dev[scmd_id(cmd)].block_size);

Here.

>  		writecmd2->cid =3D cpu_to_le16(scmd_id(cmd));
>  		writecmd2->flags =3D (fua && ((aac_cache & 5) !=3D 1) &&
>  						   (((aac_cache & 5) !=3D 5) || !fib->dev->cache_protected)) ?
> @@ -1122,7 +1175,7 @@ static int aac_write_raw_io(struct fib * fib, s=
truct scsi_cmnd * cmd, u64 lba, u
>  		writecmd =3D (struct aac_raw_io *) fib_data(fib);
>  		writecmd->block[0] =3D cpu_to_le32((u32)(lba&0xffffffff));
>  		writecmd->block[1] =3D cpu_to_le32((u32)((lba&0xffffffff00000000LL=
)>>32));
> -		writecmd->count =3D cpu_to_le32(count<<9);
> +		writecmd->count =3D cpu_to_le32(count *=20
> +dev->fsa_dev[scmd_id(cmd)].block_size);

Here.

>  		writecmd->cid =3D cpu_to_le16(scmd_id(cmd));
>  		writecmd->flags =3D (fua && ((aac_cache & 5) !=3D 1) &&
>  						   (((aac_cache & 5) !=3D 5) || !fib->dev->cache_protected)) ?
> @@ -1190,6 +1243,7 @@ static int aac_write_block(struct fib * fib, st=
ruct scsi_cmnd * cmd, u64 lba, u3  {
>  	u16 fibsize;
>  	struct aac_write *writecmd;
> +	struct aac_dev *dev =3D fib->dev;
>  	long ret;
> =20
>  	aac_fib_init(fib);
> @@ -1197,7 +1251,7 @@ static int aac_write_block(struct fib * fib, st=
ruct scsi_cmnd * cmd, u64 lba, u3
>  	writecmd->command =3D cpu_to_le32(VM_CtBlockWrite);
>  	writecmd->cid =3D cpu_to_le32(scmd_id(cmd));
>  	writecmd->block =3D cpu_to_le32((u32)(lba&0xffffffff));
> -	writecmd->count =3D cpu_to_le32(count * 512);
> +	writecmd->count =3D cpu_to_le32(count *=20
> +dev->fsa_dev[scmd_id(cmd)].block_size);

And here.

>  	writecmd->sg.count =3D cpu_to_le32(1);
>  	/* ->stable is not used - it did mean which type of write */
> =20
> @@ -2329,10 +2383,10 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>  		cp[5] =3D (capacity >> 16) & 0xff;
>  		cp[6] =3D (capacity >> 8) & 0xff;
>  		cp[7] =3D (capacity >> 0) & 0xff;
> -		cp[8] =3D 0;
> -		cp[9] =3D 0;
> -		cp[10] =3D 2;
> -		cp[11] =3D 0;
> +		cp[8] =3D (fsa_dev_ptr[cid].block_size >> 24) & 0xff;
> +		cp[9] =3D (fsa_dev_ptr[cid].block_size >> 16) & 0xff;
> +		cp[10] =3D (fsa_dev_ptr[cid].block_size >> 8) & 0xff;
> +		cp[11] =3D (fsa_dev_ptr[cid].block_size) & 0xff;
>  		cp[12] =3D 0;
> =20
>  		alloc_len =3D ((scsicmd->cmnd[10] << 24) @@ -2369,10 +2423,10 @@ i=
nt aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>  		cp[1] =3D (capacity >> 16) & 0xff;
>  		cp[2] =3D (capacity >> 8) & 0xff;
>  		cp[3] =3D (capacity >> 0) & 0xff;
> -		cp[4] =3D 0;
> -		cp[5] =3D 0;
> -		cp[6] =3D 2;
> -		cp[7] =3D 0;
> +		cp[4] =3D (fsa_dev_ptr[cid].block_size >> 24) & 0xff;
> +		cp[5] =3D (fsa_dev_ptr[cid].block_size >> 16) & 0xff;
> +		cp[6] =3D (fsa_dev_ptr[cid].block_size >> 8) & 0xff;
> +		cp[7] =3D (fsa_dev_ptr[cid].block_size) & 0xff;
>  		scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
>  		/* Do not cache partition table for arrays */
>  		scsicmd->device->removable =3D 1;
> @@ -2385,30 +2439,55 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
> =20
>  	case MODE_SENSE:
>  	{
> -		char mode_buf[7];
>  		int mode_buf_length =3D 4;
> +		u32 capacity;
> +		aac_modep_data mpd;
> +
> +		if (fsa_dev_ptr[cid].size <=3D 0x100000000ULL)
> +			capacity =3D fsa_dev_ptr[cid].size - 1;
> +		else
> +			capacity =3D (u32)-1;
> =20
>  		dprintk((KERN_DEBUG "MODE SENSE command.\n"));
> -		mode_buf[0] =3D 3;	/* Mode data length */
> -		mode_buf[1] =3D 0;	/* Medium type - default */
> -		mode_buf[2] =3D 0;	/* Device-specific param,
> +		memset((char *)&mpd, 0, sizeof(aac_modep_data));
> +
> +		mpd.hd.data_length =3D sizeof(mpd.hd) - 1;	/* Mode data length */
> +		mpd.hd.med_type =3D 0;	/* Medium type - default */
> +		mpd.hd.dev_par =3D 0;	/* Device-specific param,
>  					   bit 8: 0/1 =3D write enabled/protected
>  					   bit 4: 0/1 =3D FUA enabled */
>  		if (dev->raw_io_interface && ((aac_cache & 5) !=3D 1))
> -			mode_buf[2] =3D 0x10;
> -		mode_buf[3] =3D 0;	/* Block descriptor length */
> +			mpd.hd.dev_par =3D 0x10;
> +		if (scsicmd->cmnd[1] & 0x8) {
> +			mpd.hd.bd_length =3D 0;	/* Block descriptor length */
> +		} else {

No braces around conditions in a single line.

Remember to run './scripts/checkpatch.pl' before submission.

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
