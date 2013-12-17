From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/8] target_core_spc: Include target device descriptor
 in VPD page 83
Date: Tue, 17 Dec 2013 11:50:49 -0800
Message-ID: <1387309849.20247.306.camel@haakon3.risingtidesystems.com>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
	 <1387268330-121064-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387268330-121064-7-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-12-17 at 09:18 +0100, Hannes Reinecke wrote:
> We should be including a descriptor referring to the target device
> to allow identification of different TCM instances.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_spc.c | 43 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 

One issue with this patch.  The local buffer in spc_emulate_inquiry is
currently hardcoded to SE_INQUIRY_BUF=512, so two large scsi name
designators could overflow here..

So for the largest case with EVPD=0x83, this would be:

4 bytes for header +
20 bytes for NAA IEEE Registered Extended Assigned designator +
56 bytes for T10 Vendor Identifier +
8 bytes for Relative target port +
8 bytes for Target port group +
8 bytes for Logical unit group +
256 bytes for SCSI name (target port) +
256 bytes for SCSI name (target device) == 616 bytes.

So for good measure, bumping up SE_INQUIRY_BUF to 1024.

--nab

> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 603c411..39054d9 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -267,7 +267,7 @@ check_t10_vend_desc:
>  	port = lun->lun_sep;
>  	if (port) {
>  		struct t10_alua_lu_gp *lu_gp;
> -		u32 padding, scsi_name_len;
> +		u32 padding, scsi_name_len, scsi_target_len;
>  		u16 lu_gp_id = 0;
>  		u16 tg_pt_gp_id = 0;
>  		u16 tpgt;
> @@ -402,6 +402,47 @@ check_scsi_name:
>  		off += scsi_name_len;
>  		/* Header size + Designation descriptor */
>  		len += (scsi_name_len + 4);
> +
> +		/*
> +		 * Target device designator
> +		 */
> +		buf[off] =
> +			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
> +		buf[off++] |= 0x3; /* CODE SET == UTF-8 */
> +		buf[off] = 0x80; /* Set PIV=1 */
> +		/* Set ASSOCIATION == target device: 10b */
> +		buf[off] |= 0x20;
> +		/* DESIGNATOR TYPE == SCSI name string */
> +		buf[off++] |= 0x8;
> +		off += 2; /* Skip over Reserved and length */
> +		/*
> +		 * SCSI name string identifer containing, $FABRIC_MOD
> +		 * dependent information.  For LIO-Target and iSCSI
> +		 * Target Port, this means "<iSCSI name>" in
> +		 * UTF-8 encoding.
> +		 */
> +		scsi_target_len = sprintf(&buf[off], "%s",
> +					  tpg->se_tpg_tfo->tpg_get_wwn(tpg));
> +		scsi_target_len += 1 /* Include  NULL terminator */;
> +		/*
> +		 * The null-terminated, null-padded (see 4.4.2) SCSI
> +		 * NAME STRING field contains a UTF-8 format string.
> +		 * The number of bytes in the SCSI NAME STRING field
> +		 * (i.e., the value in the DESIGNATOR LENGTH field)
> +		 * shall be no larger than 256 and shall be a multiple
> +		 * of four.
> +		 */
> +		padding = ((-scsi_target_len) & 3);
> +		if (padding)
> +			scsi_target_len += padding;
> +		if (scsi_name_len > 256)
> +			scsi_name_len = 256;
> +
> +		buf[off-1] = scsi_target_len;
> +		off += scsi_target_len;
> +
> +		/* Header size + Designation descriptor */
> +		len += (scsi_target_len + 4);
>  	}
>  	buf[2] = ((len >> 8) & 0xff);
>  	buf[3] = (len & 0xff); /* Page Length for VPD 0x83 */
