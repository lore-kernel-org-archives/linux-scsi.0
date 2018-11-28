From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 40/41] scsi: ufs: ufshcd: mark expected switch
 fall-throughs
Date: Wed, 28 Nov 2018 06:15:41 +0000
Message-ID: <SN6PR04MB4925E511F16036DF52A6FFA7FCD10@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <f4ee30ab52b0fadd2242dd189fe03b60ecba1f47.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f4ee30ab52b0fadd2242dd189fe03b60ecba1f47.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Already submitted by Tomas:
https://www.spinics.net/lists/linux-scsi/msg125659.html

Thanks,
Avri

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> On Behalf Of Gustavo A. R. Silva
> Sent: Wednesday, November 28, 2018 6:34 AM
> To: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Gustavo A. R. Silva <gustavo@embeddedor.com>
> Subject: [PATCH 40/41] scsi: ufs: ufshcd: mark expected switch fall-throu=
ghs
>=20
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
>=20
> Addresses-Coverity-ID: 1087954 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 003d489f1b4b..be207197b63f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1551,6 +1551,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  		 * currently running. Hence, fall through to cancel gating
>  		 * work and to enable clocks.
>  		 */
> +		/* fall through */
>  	case CLKS_OFF:
>  		ufshcd_scsi_block_requests(hba);
>  		hba->clk_gating.state =3D REQ_CLKS_ON;
> @@ -1562,6 +1563,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  		 * fall through to check if we should wait for this
>  		 * work to be done or not.
>  		 */
> +		/* fall through */
>  	case REQ_CLKS_ON:
>  		if (async) {
>  			rc =3D -EAGAIN;
> @@ -4620,6 +4622,7 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp,
> int scsi_status)
>  	switch (scsi_status) {
>  	case SAM_STAT_CHECK_CONDITION:
>  		ufshcd_copy_sense_data(lrbp);
> +		/* fall through */
>  	case SAM_STAT_GOOD:
>  		result |=3D DID_OK << 16 |
>  			  COMMAND_COMPLETE << 8 |
> --
> 2.17.1
