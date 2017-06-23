From: Minwoo Im <dn3108@gmail.com>
Subject: Re: [PATCH] scsi/libata: Support variable-length cdb of ata pass-thru(32).
Date: Sat, 24 Jun 2017 01:50:30 +0900
Message-ID: <CAKv8XUU-k0dFjHAu9G2rM+is4AZw9BKfsFDh1zG0zwq=GzSVkg@mail.gmail.com>
References: <1497697243-3724-1-git-send-email-dn3108@gmail.com> <1498071149.2746.26.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35557 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753893AbdFWQvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 12:51:12 -0400
In-Reply-To: <1498071149.2746.26.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

On Thu, Jun 22, 2017 at 3:52 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Sat, 2017-06-17 at 20:00 +0900, Minwoo Im wrote:
>> -     if ((tf->protocol = ata_scsi_map_proto(cdb[1])) == ATA_PROT_UNKNOWN) {
>> +     /*
>> +      * if SCSI operation code in cdb[0] is ATA_12 or ATA_16,
>> +      * then cdb[1] will contain protocol of ATA PASS-THROUGH.
>> +      * otherwise, Its operation code shall be ATA_32(7Fh).
>> +      * in this case, cdb[10] will contain protocol of it.
>> +      * we call this command as a variable-length cdb.
>> +      */
>> +     if (cdb[0] == ATA_12 || cdb[0] == ATA_16)
>> +             tf->protocol = ata_scsi_map_proto(cdb[1]);
>> +     else
>> +             tf->protocol = ata_scsi_map_proto(cdb[10]);
>> +
>> +     if (tf->protocol == ATA_PROT_UNKNOWN) {
>>               fp = 1;
>>               goto invalid_fld;
>>       }
>
> Hello Minwoo,
>
> Please consider introducing a variable (e.g. called "cdb_offset") in which the
> value 9 is stored for 32-byte CDBs and 0 for 12-byte and 16-byte CDBs. That
> will allow to rewrite the above code as follows:
>
>         tf->protocol = ata_scsi_map_proto(cdb[1 + cdb_offset])
>
> I think that will allow to remove most "if (cdb[0] == ATA_12 || cdb[0] == ATA_16)"
> statements introduced by this patch.

Hello Bart,

I really appreciate that you gave me a simple way to handle 12, 16
and 32 bytes commands in a function above.
I have applied those things to my patch.

>
>> +             tf->auxiliary = (cdb[28] << 24) | (cdb[29] << 16)
>> +                     | (cdb[30] << 8) | cdb[31];
>
> Please use get_unaligned_be32() instead of open-coding it.
>
>> +     const u16 sa = (cdb[8] >> 8) | cdb[9];  /* service action */
>
> Please use get_unaligned_be16() instead of open-coding it.

I have applied "get_unaligned_be16 and 32" function to those parts.
Please refer a new patch below.
Thanks, again.

>
>> @@ -4385,7 +4463,12 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
>>               shost->max_id = 16;
>>               shost->max_lun = 1;
>>               shost->max_channel = 1;
>> -             shost->max_cmd_len = 16;
>> +             /*
>> +              * SPC-3, SPC-4: Definition of CDB
>> +              * A CDB may have a fixed length of up to 16 bytes or
>> +              * variable length of between 12 and 260 bytes.
>> +              */
>> +             shost->max_cmd_len = 260;
>
> Does ATA pass-through really support 260-byte CDBs or is the maximum CDB length
> that is supported by ATA_32 perhaps 32 bytes?

Here's my opinion about your question.
In perspective of SCSI host, I guess the max cmd len should be 260 bytes.
Because SPC says that, in case of variable-length command, it could be
from 12 to 260 bytes.
That's why I have applied 260 value to max_cmd_len of scsi host.
Please feel free to give any opinions about it.

>
> Thanks,
>
> Bart.

Thanks,
Minwoo.

Signed-off-by: Minwoo Im <dn3108@gmail.com>
---
 drivers/ata/libata-core.c |    2 +-
 drivers/ata/libata-scsi.c |   76 ++++++++++++++++++++++++++++++
++++++++++++---
 include/scsi/scsi_proto.h |    1 +
 3 files changed, 73 insertions(+), 6 deletions(-)

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
index 49ba983..d99c4e8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3127,7 +3127,7 @@ static struct ata_device
*__ata_scsi_find_dev(struct ata_port *ap,
  *     ata_scsi_pass_thru - convert ATA pass-thru CDB to taskfile
  *     @qc: command structure to be initialized
  *
- *     Handles either 12 or 16-byte versions of the CDB.
+ *     Handles either 12 16, or 32-byte versions of the CDB.
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
+       if ((tf->protocol = ata_scsi_map_proto(cdb[1 + cdb_offset]))
+                       == ATA_PROT_UNKNOWN) {
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
@@ -4385,7 +4447,11 @@ int ata_scsi_add_hosts(struct ata_host *host,
struct scsi_host_template *sht)
                shost->max_id = 16;
                shost->max_lun = 1;
                shost->max_channel = 1;
-               shost->max_cmd_len = 16;
+               /*
+                * SPC says that CDB may have a fixed length of up to 16 bytes
+                * or variable length of between 12 and 260 bytes.
+                */
+               shost->max_cmd_len = 260;

                /* Schedule policy is determined by ->qc_defer()
                 * callback and it needs to see every deferred qc.
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index ce78ec8..8545e34 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -164,6 +164,7 @@
 #define WRITE_SAME_32        0x0d

 /* Values for T10/04-262r7 */
+#define        ATA_32                0x1ff0    /* 32-byte pass-thru,
service action */
 #define        ATA_16                0x85      /* 16-byte pass-thru */
 #define        ATA_12                0xa1      /* 12-byte pass-thru */
