Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4129C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 02:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353806AbiFNCpz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 22:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354493AbiFNCpm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 22:45:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E69562E3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 19:23:18 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E1TBAq014673;
        Tue, 14 Jun 2022 02:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=v8AiQ4zP7O7XbEJvQzOIR4wUxbYav2IzJfjCM2rtU/Q=;
 b=GlgoKigwQsbYOh2erL+y8RIi+7MxStU9fPQhEMIZq7kwgH71gf8LPAZVKI2QLa1L6uT3
 vNotOxMUXntk1/uAd4s4oWZMcKTSD/UeLHdY3d0wBxMNlhyu8ufLLnVneF0MHqPEQc6V
 yZ6DSSXP/TI9xdMkOobh5SyVyyXFOw0ZDChuB+z6Qv5xl+t+kZNgUHGnmIW5TcG3gR57
 3+cp0vnIKFPo/bga05VhRJk13LkyUW39IOyZcyobLnnqt1Si/3ZUIJTyrhxOUPiE5Tn7
 dIQM+QbenPpVjTR6AUsGF7PVGawcs8nMCVnJTYoA2l+mVRzR8B8Xx2VqwhS9QQrN/kOJ xw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkktcjkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 02:22:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25E2JoOu039072;
        Tue, 14 Jun 2022 02:22:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpgmx8ysb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 02:22:36 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25E2Ma0T005585;
        Tue, 14 Jun 2022 02:22:36 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpgmx8ys7-1;
        Tue, 14 Jun 2022 02:22:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Chris Leech <cleech@redhat.com>,
        Sergey Gorenko <sergeygo@nvidia.com>,
        Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: Re: [PATCH] scsi: iscsi: Exclude zero from the endpoint ID range
Date:   Mon, 13 Jun 2022 22:22:34 -0400
Message-Id: <165517334627.25277.2425699154359671655.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220613123854.55073-1-sergeygo@nvidia.com>
References: <20220613123854.55073-1-sergeygo@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: w2gEsmiqLegykIcoiDe-ZNT1nJdD7X9Z
X-Proofpoint-ORIG-GUID: w2gEsmiqLegykIcoiDe-ZNT1nJdD7X9Z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jun 2022 15:38:54 +0300, Sergey Gorenko wrote:

> The kernel returns an endpoint ID as r.ep_connect_ret.handle in the
> iscsi_uevent. The iscsid validates a received endpoint ID and treats
> zero as an error. The commit referenced in the fixes line changed the
> endpoint ID range, and zero is always assigned to the first endpoint ID.
> So, the first attempt to create a new iSER connection always fails.
> 
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: iscsi: Exclude zero from the endpoint ID range
      https://git.kernel.org/mkp/scsi/c/f6eed15f3ea7

-- 
Martin K. Petersen	Oracle Linux Engineering
