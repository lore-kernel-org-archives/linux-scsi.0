From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi/libata: Support variable-length cdb of ata
 pass-thru(32).
Date: Fri, 23 Jun 2017 17:15:37 +0000
Message-ID: <1498238136.2735.8.camel@wdc.com>
References: <1497697243-3724-1-git-send-email-dn3108@gmail.com>
         <1498071149.2746.26.camel@wdc.com>
         <CAKv8XUU-k0dFjHAu9G2rM+is4AZw9BKfsFDh1zG0zwq=GzSVkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAKv8XUU-k0dFjHAu9G2rM+is4AZw9BKfsFDh1zG0zwq=GzSVkg@mail.gmail.com>
Content-Language: en-US
Content-ID: <AAD3BEA6C8878E49AFF58AF9BE8D4351@namprd04.prod.outlook.com>
Sender: linux-ide-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "dn3108@gmail.com" <dn3108@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2017-06-24 at 01:50 +0900, Minwoo Im wrote:
> - *     Handles either 12 or 16-byte versions of the CDB.
> + *     Handles either 12 16, or 32-byte versions of the CDB.

Please insert a comma between "12" and "16" to avoid that this comment
gets confusing.

> +       if ((tf->protocol =3D ata_scsi_map_proto(cdb[1 + cdb_offset]))
> +                       =3D=3D ATA_PROT_UNKNOWN) {

Have you verified this patch with checkpatch? The recommended style is
*not* to use assignments in the expression that controls an if-statement
and also if a comparison expression has to be split to keep the comparison
operator at the end of the first line.

> -               shost->max_cmd_len =3D 16;
> +               /*
> +                * SPC says that CDB may have a fixed length of up to 16 =
bytes
> +                * or variable length of between 12 and 260 bytes.
> +                */
> +               shost->max_cmd_len =3D 260;

As mentioned before, I think a maximum CDB length of 260 is overkill.

>  /* Values for T10/04-262r7 */
> +#define        ATA_32                0x1ff0    /* 32-byte pass-thru,
> service action */
>  #define        ATA_16                0x85      /* 16-byte pass-thru */
>  #define        ATA_12                0xa1      /* 12-byte pass-thru */

Defining ATA_32 just above ATA_12 and ATA_16 is misleading because
the latter two are CDB opcodes while the former is a service action
code. Please move the definition of the ATA_32 service action code
one line up such that it appears at the end of the list of already
defined service codes, namely this list:

/* values for variable length command */
#define XDREAD_32	      0x03
#define XDWRITE_32	      0x04
#define XPWRITE_32	      0x06
#define XDWRITEREAD_32	      0x07
#define READ_32		      0x09
#define VERIFY_32	      0x0a
#define WRITE_32	      0x0b
#define WRITE_SAME_32	      0x0d

Thanks,

Bart.=
