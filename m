Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FE1C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 03:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiF1DZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 23:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiF1DZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 23:25:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7634324F26;
        Mon, 27 Jun 2022 20:25:01 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S2CXNZ026396;
        Tue, 28 Jun 2022 03:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=fh2Por29itIJMzpPEE0SGEMmzczOTbSrONXpc98u6V8=;
 b=LGD8OY+MxQRcxk/S5iK8l0l0QTZi9FmyBX08yTCOzOj6KFA1f37fV8owgYqnHtXWd4qD
 sVZ/DVJLoCMCrIpaGkkd7EgoseqAjHdazGZBTXpxlwFO7c852xW/5OkAxQ3RU/1OZ3DY
 UyA9RtUh7Vgvd8gsysOuk/vsAXIMt+HOpWPrOhSm+Wa3xXwpI0O615BHXpuWIS7jVfZF
 BSrwsHTulOaipan6wZtdhbjeC28giPc7kk/TIX50Ft5XrJ2m+bnx93tYH8jYBxLWGtb9
 +8VoWhXgOot6xLZtin8LvMAGDftHyatpQwNP7S2suNYgcMe4LxfLvZz+U2QWANz/svUD 1Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsyscrs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:24:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S3F1E5002519;
        Tue, 28 Jun 2022 03:24:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:24:55 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25S3Nvpw016584;
        Tue, 28 Jun 2022 03:24:54 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjkg-1;
        Tue, 28 Jun 2022 03:24:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Bart van Assche <bvanassche@acm.org>,
        Rajat Jain <rajatja@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] trace: events: scsi: Print driver_tag and scheduler_tag in SCSI trace
Date:   Mon, 27 Jun 2022 23:24:39 -0400
Message-Id: <165638665787.7726.13498903914695990280.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621181125.3211399-1-changyuanl@google.com>
References: <f21b7a51-ccb0-b8dc-a48e-94a7a0f7e125@acm.org> <20220621181125.3211399-1-changyuanl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: mJfQGeBOvg7adypUt_R9zvfGIt2wXSVL
X-Proofpoint-GUID: mJfQGeBOvg7adypUt_R9zvfGIt2wXSVL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 21 Jun 2022 18:11:25 +0000, Changyuan Lyu wrote:

> Trace events like scsi_dispatch_cmd_start and scsi_dispatch_cmd_done
> are useful for tracking a command throughout its lifetime. But for
> some ATA passthrough commands, the information printed in current logs
> is not enough to identify and match them. For example, if two threads
> send SMART cmd to the same disk at the same time, their trace logs may
> look the same, which makes it hard to match scsi_dispatch_cmd_done and
> scsi_dispatch_cmd_start. Printing tags can help us solve the problem.
> Further, if a command failed for some reason and then is retried, its
> driver_tag will change. So scheduler_tag is also included such that we
> can track the retries of a command.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/1] trace: events: scsi: Print driver_tag and scheduler_tag in SCSI trace
      https://git.kernel.org/mkp/scsi/c/cc06af0bbc21

-- 
Martin K. Petersen	Oracle Linux Engineering
