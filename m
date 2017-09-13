From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V2 1/9] pm80xx : redefine sas_identify_frame structure
Date: Wed, 13 Sep 2017 13:09:36 +0200
Message-ID: <CAMGffEkTAUoum3-z4k4uoO2WRgJXnaefF1D1Yf_UzEB_At5aBQ@mail.gmail.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com> <20150217233650.9091-2-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:37015 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdIMLJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 07:09:58 -0400
Received: by mail-wr0-f179.google.com with SMTP id k20so28005277wre.4
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2017 04:09:58 -0700 (PDT)
In-Reply-To: <20150217233650.9091-2-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Feb 18, 2015 at 12:36 AM, Viswas G <Viswas.G@microsemi.com> wrote:
> sas_identify structure defined by pm80xx doesn't have CRC field.
> So added a new sas_identify structure without CRC.
>
> v2:
>         - Since the structure changes is applicable for only pm80xx,
>           sas_identify_frame_local structure moved to pm80xx_hwi.h.
>
> Signed-off-by: Raj Dinesh <Raj.Dinesh@microsemi.com>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.h | 98 ++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 97 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80x=
x_hwi.h
> index 7a443bad6163..82b8cf581da9 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -229,6 +229,102 @@
>  #define IT_NEXUS_TIMEOUT       0x7D0
>  #define PORT_RECOVERY_TIMEOUT  ((IT_NEXUS_TIMEOUT/100) + 30)
>
> +#ifdef __LITTLE_ENDIAN_BITFIELD
> +struct sas_identify_frame_local {
> +       /* Byte 0 */
> +       u8  frame_type:4;
> +       u8  dev_type:3;
> +       u8  _un0:1;
> +
> +       /* Byte 1 */
> +       u8  _un1;
> +
> +       /* Byte 2 */
> +       union {
> +               struct {
> +                       u8  _un20:1;
> +                       u8  smp_iport:1;
> +                       u8  stp_iport:1;
> +                       u8  ssp_iport:1;
> +                       u8  _un247:4;
> +               };
> +               u8 initiator_bits;
> +       };
> +
> +       /* Byte 3 */
> +       union {
> +               struct {
> +                       u8  _un30:1;
> +                       u8 smp_tport:1;
> +                       u8 stp_tport:1;
> +                       u8 ssp_tport:1;
> +                       u8 _un347:4;
> +               };
> +               u8 target_bits;
> +       };
> +
> +       /* Byte 4 - 11 */
> +       u8 _un4_11[8];
> +
> +       /* Byte 12 - 19 */
> +       u8 sas_addr[SAS_ADDR_SIZE];
> +
> +       /* Byte 20 */
> +       u8 phy_id;
> +
> +       u8 _un21_27[7];
> +
> +} __packed;
> +
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +struct sas_identify_frame_local {
> +       /* Byte 0 */
> +       u8  _un0:1;
> +       u8  dev_type:3;
> +       u8  frame_type:4;
> +
> +       /* Byte 1 */
> +       u8  _un1;
> +
> +       /* Byte 2 */
> +       union {
> +               struct {
> +                       u8  _un247:4;
> +                       u8  ssp_iport:1;
> +                       u8  stp_iport:1;
> +                       u8  smp_iport:1;
> +                       u8  _un20:1;
> +               };
> +               u8 initiator_bits;
> +       };
> +
> +       /* Byte 3 */
> +       union {
> +               struct {
> +                       u8 _un347:4;
> +                       u8 ssp_tport:1;
> +                       u8 stp_tport:1;
> +                       u8 smp_tport:1;
> +                       u8 _un30:1;
> +               };
> +               u8 target_bits;
> +       };
> +
> +       /* Byte 4 - 11 */
> +       u8 _un4_11[8];
> +
> +       /* Byte 12 - 19 */
> +       u8 sas_addr[SAS_ADDR_SIZE];
> +
> +       /* Byte 20 */
> +       u8 phy_id;
> +
> +       u8 _un21_27[7];
> +} __packed;
> +#else
> +#error "Bitfield order not defined!"
> +#endif
> +
>  struct mpi_msg_hdr {
>         __le32  header; /* Bits [11:0] - Message operation code */
>         /* Bits [15:12] - Message Category */
> @@ -248,7 +344,7 @@ struct mpi_msg_hdr {
>  struct phy_start_req {
>         __le32  tag;
>         __le32  ase_sh_lm_slr_phyid;
> -       struct sas_identify_frame sas_identify; /* 28 Bytes */
> +       struct sas_identify_frame_local sas_identify; /* 28 Bytes */
>         __le32 spasti;
>         u32     reserved[21];
>  } __attribute__((packed, aligned(4)));
> --
> 2.12.3
>
Thanks,
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>

--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
