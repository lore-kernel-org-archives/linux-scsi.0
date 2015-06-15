From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 13/20] [SCSI] mpt3sas: MPI 2.5 Rev K (2.5.6)
 specifications
Date: Mon, 15 Jun 2015 11:54:14 +0200
Message-ID: <20150615095414.GG5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-14-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbbFOJyR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2015 05:54:17 -0400
Content-Disposition: inline
In-Reply-To: <1434102153-38581-14-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:25PM +0530, Sreekanth Reddy wrote:
> Below are the new changes to MPI 2.5 Rev K(2.5.6) specification and 2=
=2E00.35 header files
> 1) Added a minimum size requirement for target mode command buffers.
> 2) Added MinMSIxIndex and MaxMSIxIndex fields to CommandBufferPostBas=
e Request.
> 3) For BIOS Page 1, added SSUTimeout field, and added Product Name St=
ring Format bits to the BiosOptions field
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpi/mpi2.h      |  5 +++--
>  drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 17 ++++++++++++++---
>  2 files changed, 17 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/m=
pi/mpi2.h
> index c2d127c..ec27ad2 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
> @@ -8,7 +8,7 @@
>   *                 scatter/gather formats.
>   * Creation Date:  June 21, 2006
>   *
> - * mpi2.h Version:  02.00.34
> + * mpi2.h Version:  02.00.35
>   *
>   * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or =
Mpi25
>   *       prefix are for use only on MPI v2.5 products, and must not =
be used
> @@ -91,6 +91,7 @@
>   * 08-19-13  02.00.32  Bumped MPI2_HEADER_VERSION_UNIT.
>   * 12-05-13  02.00.33  Bumped MPI2_HEADER_VERSION_UNIT.
>   * 01-08-14  02.00.34  Bumped MPI2_HEADER_VERSION_UNIT
> + * 06-13-14  02.00.35  Bumped MPI2_HEADER_VERSION_UNIT.
>   * -----------------------------------------------------------------=
---------
>   */
> =20
> @@ -124,7 +125,7 @@
>  #define MPI2_VERSION_02_05                  (0x0205)
> =20
>  /*Unit and Dev versioning for this MPI header set */
> -#define MPI2_HEADER_VERSION_UNIT            (0x22)
> +#define MPI2_HEADER_VERSION_UNIT            (0x23)
>  #define MPI2_HEADER_VERSION_DEV             (0x00)
>  #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
>  #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3=
sas/mpi/mpi2_cnfg.h
> index 66f2cc1..c337a85 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> @@ -6,7 +6,7 @@
>   *         Title:  MPI Configuration messages and pages
>   * Creation Date:  November 10, 2006
>   *
> - *   mpi2_cnfg.h Version:  02.00.28
> + *   mpi2_cnfg.h Version:  02.00.29
>   *
>   * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or =
Mpi25
>   *       prefix are for use only on MPI v2.5 products, and must not =
be used
> @@ -177,6 +177,8 @@
>   *		       MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
>   * 01-08-14  02.00.28  Added more defines for the BiosOptions field =
of
>   *		       MPI2_CONFIG_PAGE_BIOS_1.
> + * 06-13-14  02.00.29  Added SSUTimeout field to MPI2_CONFIG_PAGE_BI=
OS_1, and
> + *		       more defines for the BiosOptions field..
>   * -----------------------------------------------------------------=
---------
>   */
> =20
> @@ -1324,7 +1326,9 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1 {
>  	MPI2_CONFIG_PAGE_HEADER Header;                     /*0x00 */
>  	U32                     BiosOptions;                /*0x04 */
>  	U32                     IOCSettings;                /*0x08 */
> -	U32                     Reserved1;                  /*0x0C */
> +	U8                      SSUTimeout;                 /*0x0C */
> +	U8                      Reserved1;                  /*0x0D */
> +	U16                     Reserved2;                  /*0x0E */
>  	U32                     DeviceSettings;             /*0x10 */
>  	U16                     NumberOfDevices;            /*0x14 */
>  	U16                     UEFIVersion;                /*0x16 */
> @@ -1336,9 +1340,16 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1 {
>  	*PTR_MPI2_CONFIG_PAGE_BIOS_1,
>  	Mpi2BiosPage1_t, *pMpi2BiosPage1_t;
> =20
> -#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x06)
> +#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x07)
> =20
>  /*values for BIOS Page 1 BiosOptions field */
> +#define MPI2_BIOSPAGE1_OPTIONS_PNS_MASK                         (0x0=
0003800)
> +#define MPI2_BIOSPAGE1_OPTIONS_PNS_PBDHL                        (0x0=
0000000)
> +#define MPI2_BIOSPAGE1_OPTIONS_PNS_ENCSLOSURE                   (0x0=
0000800)
> +#define MPI2_BIOSPAGE1_OPTIONS_PNS_LWWID                        (0x0=
0001000)
> +#define MPI2_BIOSPAGE1_OPTIONS_PNS_PSENS                        (0x0=
0001800)
> +#define MPI2_BIOSPAGE1_OPTIONS_PNS_ESPHY                        (0x0=
0002000)
> +
>  #define MPI2_BIOSPAGE1_OPTIONS_X86_DISABLE_BIOS		    (0x00000400)
> =20
>  #define MPI2_BIOSPAGE1_OPTIONS_MASK_REGISTRATION_UEFI_BSD	(0x0000030=
0)
> --=20
> 2.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
