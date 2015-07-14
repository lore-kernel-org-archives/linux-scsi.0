From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/3] target: Return descriptor format sense data
Date: Tue, 14 Jul 2015 14:59:51 +0300
Message-ID: <55A4F9B7.905@dev.mellanox.co.il>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
 <1436697423-20611-4-git-send-email-sagig@mellanox.com>
 <20150714071703.GC31117@infradead.org> <yq1r3obrvyn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35513 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbGNL75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2015 07:59:57 -0400
Received: by wiga1 with SMTP id a1so97226807wig.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2015 04:59:55 -0700 (PDT)
In-Reply-To: <yq1r3obrvyn.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 7/14/2015 11:21 AM, Martin K. Petersen wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
>
> Christoph> I think this needs to be a tunable as old initiators might
> Christoph> not be able to cope with descriptor sense data.  My idea was
> Christoph> to only turn it own if the LU is large enough to need it.
>
> We could make it conditional and only use the descriptor format if the
> LBA is big enough to warrant it.
>

So would this be acceptable?

target: Return descriptor format sense data in case the LU spans 64bit 
sectors

In case a LU spans 64bit sectors, fixed size sense data information
field is only 32 bits which means the sector information will be truncated.

Thus, if the LU spans 64bit sectors, use descriptor format sense data to
correctly report sector information.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
  drivers/target/target_core_spc.c       |   12 +++++++++---
  drivers/target/target_core_transport.c |    3 ++-
  include/target/target_core_backend.h   |    3 +++
  3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_spc.c 
b/drivers/target/target_core_spc.c
index c43dcbf..f66abc1 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -761,7 +761,12 @@ static int spc_modesense_control(struct se_cmd 
*cmd, u8 pc, u8 *p)
         if (pc == 1)
                 goto out;

-       p[2] = 2;
+       /* GLTSD: No implicit save of log parameters */
+       p[2] = (1 << 1);
+       if (TARGET_SENSE_DESC_FORMAT(dev))
+               /* D_SENSE: Descriptor format sense data for 64bit 
sectors */
+               p[2] |= (1 << 2);
+
         /*
          * From spc4r23, 7.4.7 Control mode page
          *
@@ -1144,6 +1149,7 @@ static sense_reason_t 
spc_emulate_request_sense(struct se_cmd *cmd)
         unsigned char *rbuf;
         u8 ua_asc = 0, ua_ascq = 0;
         unsigned char buf[SE_SENSE_BUF];
+       bool desc_format = TARGET_SENSE_DESC_FORMAT(cmd->se_dev);

         memset(buf, 0, SE_SENSE_BUF);

@@ -1158,10 +1164,10 @@ static sense_reason_t 
spc_emulate_request_sense(struct se_cmd *cmd)
                 return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;

         if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))
-               scsi_build_sense_buffer(0, buf, UNIT_ATTENTION,
+               scsi_build_sense_buffer(desc_format, buf, UNIT_ATTENTION,
                                         ua_asc, ua_ascq);
         else
-               scsi_build_sense_buffer(0, buf, NO_SENSE, 0x0, 0x0);
+               scsi_build_sense_buffer(desc_format, buf, NO_SENSE, 0x0, 
0x0);

         memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
         transport_kunmap_data_sg(cmd);
diff --git a/drivers/target/target_core_transport.c 
b/drivers/target/target_core_transport.c
index 7fb031b..238c778 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2735,6 +2735,7 @@ static int translate_sense_reason(struct se_cmd 
*cmd, sense_reason_t reason)
         u8 *buffer = cmd->sense_buffer;
         int r = (__force int)reason;
         u8 asc, ascq;
+       bool desc_format = TARGET_SENSE_DESC_FORMAT(cmd->se_dev);

         if (r < ARRAY_SIZE(sense_info_table) && sense_info_table[r].key)
                 si = &sense_info_table[r];
@@ -2754,7 +2755,7 @@ static int translate_sense_reason(struct se_cmd 
*cmd, sense_reason_t reason)
                 ascq = si->ascq;
         }

-       scsi_build_sense_buffer(0, buffer, si->key, asc, ascq);
+       scsi_build_sense_buffer(desc_format, buffer, si->key, asc, ascq);
         if (si->add_sector_info)
                 return scsi_set_sense_information(buffer,
                                                   cmd->scsi_sense_length,
diff --git a/include/target/target_core_backend.h 
b/include/target/target_core_backend.h
index 1e5c8f9..6ce370f 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -3,6 +3,9 @@

  #define TRANSPORT_FLAG_PASSTHROUGH             1

+#define TARGET_SENSE_DESC_FORMAT(dev)          \
+       dev->transport->get_blocks(dev) >= 0xffffffffULL
+
  struct target_backend_ops {
         char name[16];
         char inquiry_prod[16];
--

