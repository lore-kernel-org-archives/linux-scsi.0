Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5BEC63793
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 11:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D1796121E
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 11:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhGVKWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 06:22:33 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:54958 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231286AbhGVKWc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 06:22:32 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8E1C148A6C;
        Thu, 22 Jul 2021 11:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1626951784; x=
        1628766185; bh=id7EW5tJlMBcdgL+pskGpJceVrot5gFOIDRWiVSCMuM=; b=A
        N2AqeoK/byST7ZEo7ApO/MpyY1dfvWOonoHsTZOgcl34LjhJ0AgfKvvqvjr33nG0
        pLHJ+XDfoQLx+4+xmc5wBMUrQ+TeqSQlmM3461IUzBmVrFDo284btm157JRA4zko
        0me698Ta+BWcEm0254QVxY4JwPS9HO57HL1GVq3ihQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rEQ7_FuonnFG; Thu, 22 Jul 2021 14:03:04 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5683341317;
        Thu, 22 Jul 2021 14:03:03 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 22 Jul 2021 14:03:02 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Thu, 22 Jul 2021 14:03:02 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     David Disseldorp <ddiss@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>
Subject: RE: [PATCH 0/1] scsi: target: core: Fix sense key for invalid XCOPY
 request
Thread-Topic: [PATCH 0/1] scsi: target: core: Fix sense key for invalid XCOPY
 request
Thread-Index: AQHXaOrulzhKjQiRek2XLeHree9A8KtN7zSAgAECYhA=
Date:   Thu, 22 Jul 2021 11:03:02 +0000
Message-ID: <a860bf3f89594f6982ce126ebaa0ab94@yadro.com>
References: <20210624111926.63176-1-s.samoylenko@yadro.com>
 <20210721234505.45c93a48@suse.de>
In-Reply-To: <20210721234505.45c93a48@suse.de>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.226]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi David,

> Hi Sergey,
>
> On Thu, 24 Jun 2021 14:19:25 +0300, Sergey Samoylenko wrote:
>
>> EXTENDED COPY tests in libiscsi [1] show that TCM doesn't follow SPC4=20
>> when detects invalid parameters in a XCOPY command or IO errors. The=20
>> replies from TCM contain wrong sense key or ASCQ for incorrect=20
>> request.
>>=20
>> The series fixes the following tests from libiscsi:
>
> We've hit this too. The incorrect sense reporting appears to also affect =
VMware XCOPY fallback to initiator driven READ/WRITE. I'm pretty sure this =
is a regression from
> d877d7275be34ad70ce92bcbb4bb36cec77ed004, so should probably be marked as=
 such via a Fixes tag.
>
> Cheers, David

The d877d7275be34ad70ce92bcbb4bb36cec77ed004 was added for v4.10.x kernel a=
nd it was necessary
for to avoid LUN removal race conditions. Later you excluded using configfs=
 in the XCOPY workqueue.
It was the 2896c93811e39d63a4d9b63ccf12a8fbc226e5e4.

If we remove the d877d7275be34ad70ce92bcbb4bb36cec77ed004, will it break an=
ything?
We have accumulated many changes between v4.10 and v5.14.

David, maybe can we move the helper 'target_complete_cmd_with_sense' from y=
our path to mainline kernel?
I think it will be useful in the future.

Best regards,
Sergey



From 2e96d8ac2695a13edf71976bd099003dda52056d Mon Sep 17 00:00:00 2001
From: Mike Christie <michaelc@cs.wisc.edu>
Date: Wed, 29 Jul 2015 04:23:49 -0500
Subject: [PATCH] target: compare and write backend driver sense handling
References: fate#318836
Patch-mainline: Not yet, SES2 clustered LIO/RBD

Currently, backend drivers seem to only fail IO with
SAM_STAT_CHECK_CONDITION which gets us
TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE.
For compare and write support we will want to be able to fail with
TCM_MISCOMPARE_VERIFY. This patch adds a new helper that allows backend
drivers to fail with specific sense codes.

It also allows the backend driver to set the miscompare offset.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: David Disseldorp <ddiss@suse.de>
[ddiss@suse.de rebase against ab78fef4d5 and 9ec1e1ce3a]
---
 drivers/target/target_core_transport.c |   34 ++++++++++++++++++++++++++++=
++---
 include/target/target_core_backend.h   |    1
 include/target/target_core_base.h      |    5 +++-
 3 files changed, 36 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -718,8 +718,7 @@ static void target_complete_failure_work
 {
  struct se_cmd *cmd =3D container_of(work, struct se_cmd, work);

- transport_generic_request_failure(cmd,
-     TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+ transport_generic_request_failure(cmd, cmd->sense_reason);
 }

 /*
@@ -837,7 +836,8 @@ static bool target_cmd_interrupted(struc
 }

 /* May be called from interrupt context so must not sleep. */
-void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
+static void __target_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
+         sense_reason_t sense_reason)
 {
  int success;
  unsigned long flags;
@@ -846,6 +846,7 @@ void target_complete_cmd(struct se_cmd *
    return;

  cmd->scsi_status =3D scsi_status;
+ cmd->sense_reason =3D sense_reason;

  spin_lock_irqsave(&cmd->t_state_lock, flags);
  switch (cmd->scsi_status) {
@@ -871,8 +872,22 @@ void target_complete_cmd(struct se_cmd *
  else
    queue_work(target_completion_wq, &cmd->work);
 }
+
+void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
+{
+ __target_complete_cmd(cmd, scsi_status, scsi_status ?
+          TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE :
+          TCM_NO_SENSE);
+}
 EXPORT_SYMBOL(target_complete_cmd);

+void target_complete_cmd_with_sense(struct se_cmd *cmd,
+           sense_reason_t sense_reason)
+{
+ __target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION, sense_reason);
+}
+EXPORT_SYMBOL(target_complete_cmd_with_sense);
+
 void target_set_cmd_data_length(struct se_cmd *cmd, int length)
 {
  if (length < cmd->data_length) {
@@ -1917,6 +1932,7 @@ void transport_generic_request_failure(s
  case TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE:
  case TCM_TOO_MANY_SEGMENT_DESCS:
  case TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE:
+ case TCM_MISCOMPARE_VERIFY:
    break;
  case TCM_OUT_OF_RESOURCES:
    cmd->scsi_status =3D SAM_STAT_TASK_SET_FULL;
@@ -3101,11 +3117,13 @@ bool transport_wait_for_tasks(struct se_
 }
 EXPORT_SYMBOL(transport_wait_for_tasks);

+
 struct sense_info {
  u8 key;
  u8 asc;
  u8 ascq;
  bool add_sector_info;
+ bool add_sense_info;
 };

 static const struct sense_info sense_info_table[] =3D {
@@ -3203,6 +3221,7 @@ static const struct sense_info sense_inf
    .key =3D MISCOMPARE,
    .asc =3D 0x1d, /* MISCOMPARE DURING VERIFY OPERATION */
    .ascq =3D 0x00,
+   .add_sense_info =3D true,
  },
  [TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED] =3D {
    .key =3D ABORTED_COMMAND,
@@ -3255,6 +3274,13 @@ static const struct sense_info sense_inf
  },
 };

+static void transport_err_sense_info(unsigned char *buffer, u32 info)
+{
+ buffer[SPC_INFO_VALIDITY_OFFSET] |=3D 0x80;
+ /* Sense Information */
+ put_unaligned_be32(info, &buffer[3]);
+}
+
 /**
  * translate_sense_reason - translate a sense reason into T10 key, asc and=
 ascq
  * @cmd: SCSI command in which the resulting sense buffer or SCSI status w=
ill
@@ -3304,6 +3330,8 @@ static void translate_sense_reason(struc
    WARN_ON_ONCE(scsi_set_sense_information(buffer,
              cmd->scsi_sense_length,
              cmd->bad_sector) < 0);
+ if (si->add_sense_info)
+   transport_err_sense_info(buffer, cmd->sense_info);
 }

 int
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -74,6 +74,7 @@ void  target_backend_unregister(const str

 void target_complete_cmd(struct se_cmd *, u8);
 void target_set_cmd_data_length(struct se_cmd *, int);
+void target_complete_cmd_with_sense(struct se_cmd *, sense_reason_t);
 void target_complete_cmd_with_length(struct se_cmd *, u8, int);

 void transport_copy_sense_to_cmd(struct se_cmd *, unsigned char *);
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -22,11 +22,12 @@
  */
 #define TRANSPORT_SENSE_BUFFER     96
 /* Used by transport_send_check_condition_and_sense() */
+#define SPC_INFO_VALIDITY_OFFSET   0
 #define SPC_SENSE_KEY_OFFSET     2
 #define SPC_ADD_SENSE_LEN_OFFSET   7
 #define SPC_DESC_TYPE_OFFSET     8
 #define SPC_ADDITIONAL_DESC_LEN_OFFSET   9
-#define SPC_VALIDITY_OFFSET      10
+#define SPC_CMD_INFO_VALIDITY_OFFSET   10
 #define SPC_ASC_KEY_OFFSET     12
 #define SPC_ASCQ_KEY_OFFSET      13
 #define TRANSPORT_IQN_LEN      224
@@ -452,6 +453,8 @@ enum target_core_dif_check {
 #define TCM_ACA_TAG  0x24

 struct se_cmd {
+ sense_reason_t    sense_reason;
+ u32     sense_info;
  /* SAM response code being sent to initiator */
  u8      scsi_status;
  u8      scsi_asc;



