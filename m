From: Minwoo Im <dn3108@gmail.com>
Subject: Re: [PATCH] scsi/libata: Support variable-length cdb of ata pass-thru(32).
Date: Sat, 24 Jun 2017 02:59:49 +0900
Message-ID: <CAKv8XUWxJUxaWzJmJeSuOj7i7tv4_3w=iYmnNyxxGYXwnMwy4g@mail.gmail.com>
References: <1497697243-3724-1-git-send-email-dn3108@gmail.com>
 <1498071149.2746.26.camel@wdc.com> <CAKv8XUU-k0dFjHAu9G2rM+is4AZw9BKfsFDh1zG0zwq=GzSVkg@mail.gmail.com>
 <1498238136.2735.8.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:33407 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754773AbdFWSAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 14:00:35 -0400
In-Reply-To: <1498238136.2735.8.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

On Sat, Jun 24, 2017 at 2:15 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Sat, 2017-06-24 at 01:50 +0900, Minwoo Im wrote:
>> - *     Handles either 12 or 16-byte versions of the CDB.
>> + *     Handles either 12 16, or 32-byte versions of the CDB.
>
> Please insert a comma between "12" and "16" to avoid that this comment
> gets confusing.

I'm sorry for making a confusion for a mistyping. It's applied to patch.

>
>> +       if ((tf->protocol = ata_scsi_map_proto(cdb[1 + cdb_offset]))
>> +                       == ATA_PROT_UNKNOWN) {
>
> Have you verified this patch with checkpatch? The recommended style is
> *not* to use assignments in the expression that controls an if-statement
> and also if a comparison expression has to be split to keep the comparison
> operator at the end of the first line.

I was trying to keep it in a way it used to be.
"Assignment expression separated and comparison expression in a line" applied.

>
>> -               shost->max_cmd_len = 16;
>> +               /*
>> +                * SPC says that CDB may have a fixed length of up to 16 bytes
>> +                * or variable length of between 12 and 260 bytes.
>> +                */
>> +               shost->max_cmd_len = 260;
>
> As mentioned before, I think a maximum CDB length of 260 is overkill.

I used to think of it only in perspective of SPC specification.
As you said, 32 would be enough for this patch which is only for ata
pass-thru(32).

>
>>  /* Values for T10/04-262r7 */
>> +#define        ATA_32                0x1ff0    /* 32-byte pass-thru,
>> service action */
>>  #define        ATA_16                0x85      /* 16-byte pass-thru */
>>  #define        ATA_12                0xa1      /* 12-byte pass-thru */
>
> Defining ATA_32 just above ATA_12 and ATA_16 is misleading because
> the latter two are CDB opcodes while the former is a service action
> code. Please move the definition of the ATA_32 service action code
> one line up such that it appears at the end of the list of already
> defined service codes, namely this list:

I completely agree with you. ATA_32 was moved to variable length command list.

I really appreciate those reviews for this patch.

Thanks,

Minwoo.


Signed-off-by: Minwoo Im <dn3108@gmail.com>
---
 drivers/ata/libata-core.c |    2 +-
 drivers/ata/libata-scsi.c |   72 ++++++++++++++++++++++++++++++
+++++++++++----
 include/scsi/scsi_proto.h |    1 +
 3 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2d83b8c..4777e76 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2587,7 +2587,7 @@ int ata_dev_configure(struct ata_device *dev)
                }
                ata_dev_config_sense_reporting(dev);
                ata_dev_config_zac(dev);
-               dev->cdb_len = 16;
+               dev->cdb_len = 32;
        }

        /* ATAPI-specific feature tests */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 49ba983..dc59860 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3127,7 +3127,7 @@ static struct ata_device
*__ata_scsi_find_dev(struct ata_port *ap,
  *     ata_scsi_pass_thru - convert ATA pass-thru CDB to taskfile
  *     @qc: command structure to be initialized
  *
- *     Handles either 12 or 16-byte versions of the CDB.
+ *     Handles either 12, 16, or 32-byte versions of the CDB.
  *
  *     RETURNS:
  *     Zero on success, non-zero on failure.
@@ -3139,13 +3139,19 @@ static unsigned int ata_scsi_pass_thru(struct
ata_queued_cmd *qc)
        struct ata_device *dev = qc->dev;
        const u8 *cdb = scmd->cmnd;
        u16 fp;
+       u16 cdb_offset = 0;

-       if ((tf->protocol = ata_scsi_map_proto(cdb[1])) == ATA_PROT_UNKNOWN) {
+       /* 7Fh variable length cmd means a ata pass-thru(32) */
+       if (cdb[0] == VARIABLE_LENGTH_CMD)
+               cdb_offset = 9;
+
+       tf->protocol = ata_scsi_map_proto(cdb[1 + cdb_offset]);
+       if (tf->protocol == ATA_PROT_UNKNOWN) {
                fp = 1;
                goto invalid_fld;
        }

-       if (ata_is_ncq(tf->protocol) && (cdb[2] & 0x3) == 0)
+       if (ata_is_ncq(tf->protocol) && (cdb[2 + cdb_offset] & 0x3) == 0)
                tf->protocol = ATA_PROT_NCQ_NODATA;

        /* enable LBA */
@@ -3181,7 +3187,7 @@ static unsigned int ata_scsi_pass_thru(struct
ata_queued_cmd *qc)
                tf->lbah = cdb[12];
                tf->device = cdb[13];
                tf->command = cdb[14];
-       } else {
+       } else if (cdb[0] == ATA_12) {
                /*
                 * 12-byte CDB - incapable of extended commands.
                 */
@@ -3194,6 +3200,30 @@ static unsigned int ata_scsi_pass_thru(struct
ata_queued_cmd *qc)
                tf->lbah = cdb[7];
                tf->device = cdb[8];
                tf->command = cdb[9];
+       } else {
+               /*
+                * 32-byte CDB - may contain extended command fields.
+                *
+                * If that is the case, copy the upper byte register values.
+                */
+               if (cdb[10] & 0x01) {
+                       tf->hob_feature = cdb[20];
+                       tf->hob_nsect = cdb[22];
+                       tf->hob_lbal = cdb[16];
+                       tf->hob_lbam = cdb[15];
+                       tf->hob_lbah = cdb[14];
+                       tf->flags |= ATA_TFLAG_LBA48;
+               } else
+                       tf->flags &= ~ATA_TFLAG_LBA48;
+
+               tf->feature = cdb[21];
+               tf->nsect = cdb[23];
+               tf->lbal = cdb[19];
+               tf->lbam = cdb[18];
+               tf->lbah = cdb[17];
+               tf->device = cdb[24];
+               tf->command = cdb[25];
+               tf->auxiliary = get_unaligned_be32(&cdb[28]);
        }

        /* For NCQ commands copy the tag value */
@@ -4068,6 +4098,35 @@ static unsigned int
ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 }

 /**
+ *     ata_scsi_var_len_cdb_xlat - SATL variable length CDB to Handler
+ *     @qc: Command to be translated
+ *
+ *     Translate a SCSI variable length CDB to specified commands.
+ *     It checks a service action value in CDB to call corresponding handler.
+ *
+ *     RETURNS:
+ *     Zero on success, non-zero on failure
+ *
+ */
+static unsigned int ata_scsi_var_len_cdb_xlat(struct ata_queued_cmd *qc)
+{
+       struct scsi_cmnd *scmd = qc->scsicmd;
+       const u8 *cdb = scmd->cmnd;
+       const u16 sa = get_unaligned_be16(&cdb[8]);
+
+       /*
+        * if service action represents a ata pass-thru(32) command,
+        * then pass it to ata_scsi_pass_thru handler.
+        */
+       if (sa == ATA_32)
+               return ata_scsi_pass_thru(qc);
+
+unspprt_sa:
+       /* unsupported service action */
+       return 1;
+}
+
+/**
  *     ata_get_xlat_func - check if SCSI to ATA translation is possible
  *     @dev: ATA device
  *     @cmd: SCSI command opcode to consider
@@ -4107,6 +4166,9 @@ static inline ata_xlat_func_t
ata_get_xlat_func(struct ata_device *dev, u8 cmd)
        case ATA_16:
                return ata_scsi_pass_thru;

+       case VARIABLE_LENGTH_CMD:
+               return ata_scsi_var_len_cdb_xlat;
+
        case MODE_SELECT:
        case MODE_SELECT_10:
                return ata_scsi_mode_select_xlat;
@@ -4385,7 +4447,7 @@ int ata_scsi_add_hosts(struct ata_host *host,
struct scsi_host_template *sht)
                shost->max_id = 16;
                shost->max_lun = 1;
                shost->max_channel = 1;
-               shost->max_cmd_len = 16;
+               shost->max_cmd_len = 32;

                /* Schedule policy is determined by ->qc_defer()
                 * callback and it needs to see every deferred qc.
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index ce78ec8..06076b8 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -162,6 +162,7 @@
 #define VERIFY_32            0x0a
 #define WRITE_32             0x0b
 #define WRITE_SAME_32        0x0d
+#define ATA_32               0x1ff0

 /* Values for T10/04-262r7 */
 #define        ATA_16                0x85      /* 16-byte pass-thru */
