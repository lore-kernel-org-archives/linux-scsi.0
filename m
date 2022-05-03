Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED6FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 09:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiECJP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 05:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiECJPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 05:15:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E40E19C2E
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 02:12:17 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242NVcjv026132;
        Tue, 3 May 2022 00:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=2mDgisxTPsttLZBcCQhpi7PsmJW7kbEioklPCkO1md8=;
 b=cnZNr1AVoBPEYSS+v07/HmtMv5bM+uSCa/sOWvSlfadf5a1jUFdIcXM8HDKDa+ql/hoZ
 4t0mwJeyTRbYB3ugKHCGS7cPccKpLMk5XCa0lu3iT4xd/S8LPHttvB5WMyIjU/zNQMP6
 WPif2+WnFayF0IIsPHbQ6+j0LMDFiSnsnVfrbQEH5mWMnp3yL3DaOW0dWwVd8CaoDKvK
 /llO3Ch/LW3NSC0dlXjVjgsSGuu7d28WmAyMYl9VCcuk+uABtl1MvEvhPoCWsEtG6dAp
 Ct9lM40Up0gZPgxZdphOC7PpuWJS8qxEP+BJRl6rZdtY2tgRP+oAIgNpAgKn4AXk7eXb 8g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruhc4m3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:50:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430fH9E040389;
        Tue, 3 May 2022 00:50:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a493en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:50:28 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430mf4t010456;
        Tue, 3 May 2022 00:50:28 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a493ef-1;
        Tue, 03 May 2022 00:50:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA transitioning state
Date:   Mon,  2 May 2022 20:50:25 -0400
Message-Id: <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: nqbwuSRf73Ah_Pem5Dk_ycsOlavX_qHV
X-Proofpoint-ORIG-GUID: nqbwuSRf73Ah_Pem5Dk_ycsOlavX_qHV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:

> The handling of the ALUA transitioning state is currently broken. When
> a target goes into this state, it is expected that the target is
> allowed to stay in this state for the implicit transition timeout
> without a path failure. The handler has this logic, but it gets
> skipped currently.
> 
> When the target transitions, there is in-flight I/O from the
> initiator. The first of these responses from the target will be a unit
> attention letting the initiator know that the ALUA state has changed.
> The remaining in-flight I/Os, before the initiator finds out that the
> portal state has changed, will return not ready, ALUA state is
> transitioning. The portal state will change to
> SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new I/O
> immediately failing the path unexpectedly. The path failure happens in
> less than a second instead of the expected successes until the
> transition timer is exceeded.
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi_dh_alua: properly handling the ALUA transitioning state
      https://git.kernel.org/mkp/scsi/c/6056a92ceb2a

-- 
Martin K. Petersen	Oracle Linux Engineering
