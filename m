Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A04C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 18:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C50660F36
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 18:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhHBSbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 14:31:23 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:48198 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229719AbhHBSbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Aug 2021 14:31:20 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C90AB4319D;
        Mon,  2 Aug 2021 18:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1627929068; x=
        1629743469; bh=pCk4OB9f6GgcT9S9NTIUfPDxT4KtAQ0hMYwtQyTwwXg=; b=j
        QkoWo50tWD8shX3pSQSuqgXA96dEbgvmnbOLmi/hRjj4zU9qkxQcIIXRKHnSJ43m
        4qFRmmKXZuDJt4oZA1LBguO0tKwEOC7anhaUmO/dhW/iXkKyVCSbn8BptkgT1Jas
        n5Be2vTd8i3alKKlHl8n4h+WYVDAECZEooHiIy8CkI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 39CZof-7WUtV; Mon,  2 Aug 2021 21:31:08 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8FEFB412C6;
        Mon,  2 Aug 2021 21:31:07 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 2 Aug 2021 21:31:07 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Mon, 2 Aug 2021 21:31:06 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     David Disseldorp <ddiss@suse.de>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>
Subject: RE: [v2 1/2] target: allows backend drivers to fail with specific
 sense codes
Thread-Topic: [v2 1/2] target: allows backend drivers to fail with specific
 sense codes
Thread-Index: AQHXgjFY02NZV15vSUWwRIojmR8tfqtbi9QAgAUC+IA=
Date:   Mon, 2 Aug 2021 18:31:06 +0000
Message-ID: <54db7e6756e945b7abd3b368d52600db@yadro.com>
References: <20210726151646.32631-1-s.samoylenko@yadro.com>
        <20210726151646.32631-2-s.samoylenko@yadro.com>
 <20210730183758.6efb3f95@suse.de>
In-Reply-To: <20210730183758.6efb3f95@suse.de>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi David,
Sorry for the long answer.

> Hi Sergey,
>
> On Mon, 26 Jul 2021 18:16:45 +0300, Sergey Samoylenko wrote:
>
>> Currently, backend drivers can fail IO with
>> SAM_STAT_CHECK_CONDITION which gets us
>> TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE. The patch adds
>> a new helper that allows backend drivers to fail with
>> specific sense codes.
>>=20
>> This is based on a patch from Mike Christie <michael.christie@oracle.com=
>.
>
> This looks good and works for me, but I have one comment...
>
> It's a little unclear from the function prototype that this actually
> fails the command with SAM_STAT_CHECK_CONDITION. I could imagine people
> erroneously calling target_complete_cmd_with_sense(cmd, TCM_NO_SENSE)
> and expecting success.
> I think it might be a bit clearer if you just export
> __target_complete_cmd() as target_complete_cmd_with_sense() with all
> three parameters and leave it up to the caller to flag
> CHECK_CONDITION.
>
> Cheers, David

David, am I getting the idea right?

We want to get something like this:
---------------------------------------------------------------------------=
--------
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index 7e35eddd9eb7..6dbfba7f16a6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -736,8 +736,7 @@ static void target_complete_failure_work(struct work_st=
ruct *work)
 {
        struct se_cmd *cmd =3D container_of(work, struct se_cmd, work);

-       transport_generic_request_failure(cmd,
-                       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+       transport_generic_request_failure(cmd, cmd->sense_reason);
 }

 /*
@@ -855,7 +854,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 }

 /* May be called from interrupt context so must not sleep. */
-void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
+void target_complete_cmd_with_sense(struct se_cmd *cmd, u8 scsi_status,
+                                   sense_reason_t sense_reason)
 {
        struct se_wwn *wwn =3D cmd->se_sess->se_tpg->se_tpg_wwn;
        int success, cpu;
@@ -865,6 +865,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_st=
atus)
                return;

        cmd->scsi_status =3D scsi_status;
+       cmd->sense_reason =3D sense_reason;

        spin_lock_irqsave(&cmd->t_state_lock, flags);
        switch (cmd->scsi_status) {
@@ -893,6 +894,14 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_s=
tatus)

        queue_work_on(cpu, target_completion_wq, &cmd->work);
 }
+EXPORT_SYMBOL(target_complete_cmd_with_sense);
+
+void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
+{
+       target_complete_cmd_with_sense(cmd, scsi_status, scsi_status ?
+                             TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE :
+                             TCM_NO_SENSE);
+}
 EXPORT_SYMBOL(target_complete_cmd);

 void target_set_cmd_data_length(struct se_cmd *cmd, int length)
---------------------------------------------------------------------------=
--------

Then we use it as follows:
---------------------------------------------------------------------------=
--------
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_cor=
e_xcopy.c
index 0f1319336f3e..1b4faafedb1a 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -674,12 +674,16 @@ static void target_xcopy_do_work(struct work_struct *=
work)
...
err_free:
        kfree(xop);
-       /*
-        * Don't override an error scsi status if it has already been set
-        */
-       if (ec_cmd->scsi_status =3D=3D SAM_STAT_GOOD) {
-               pr_warn_ratelimited("target_xcopy_do_work: rc: %d, Setting =
X-COPY"
-                       " CHECK_CONDITION -> sending response\n", rc);
-               ec_cmd->scsi_status =3D SAM_STAT_CHECK_CONDITION;
-       }
-       target_complete_cmd(ec_cmd, ec_cmd->scsi_status);
+       pr_warn_ratelimited("target_xcopy_do_work: rc: %d, sense: %u,"
+               " XCOPY operation failed\n", rc, sense_rc);
+       target_complete_cmd_with_sense(ec_cmd, SAM_STAT_CHECK_CONDITION, se=
nse_rc);
 }
---------------------------------------------------------------------------=
--------

Best regards,
Sergey
