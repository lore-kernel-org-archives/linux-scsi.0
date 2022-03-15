Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45067C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 18:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351006AbiCOSYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 14:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiCOSYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 14:24:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804725F7F
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 11:22:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FIEgmO021510;
        Tue, 15 Mar 2022 18:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=3oENNCA4hDy8nsGVe/95YhfhtMTmjAap7zZ01RKLEdA=;
 b=jMf2BtZLPU098vW7ezHeqUfwx4FapUSfMFHXIlA4lWsBXHZSrYiZW1BcpW2TWVtvxu7K
 AmfS3+u5xDCkGeKkCz2vu7OOXw81kuegCLFSYqwqNNjupwyOe+6tjosAFIFd6md5QBf5
 JHB7hkVaWW+2QZYeXExq+oNRswShey2M9M68M4DRoDYOguqwtLxgZ8cgclb177Dff70f
 AAXikzkiKE2vvpziiGQVOIzPsEzz/m/bUTz9LJznuxNaW6E8/9QdJD1uQpjuAmp5W5D/
 TiUUrFGtQJtAJ8Y+/H801dc588D84cLMG1wmJ0GXFbEN/+T7UPGmJDYE2XgcRhXHZVV0 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rm1nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 18:22:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22FIC0YA113222;
        Tue, 15 Mar 2022 18:22:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3et64k60yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 18:22:53 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22FIGXAk125646;
        Tue, 15 Mar 2022 18:22:53 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3et64k60yb-1;
        Tue, 15 Mar 2022 18:22:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     David Jeffery <djeffery@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Laurence Oberman <loberman@redhat.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        John Pittman <jpittman@redhat.com>,
        Satish Kharat <satishkh@cisco.com>
Subject: Re: [PATCH] fnic: finish scsi_cmnd before dropping the spinlock to prevent abort race
Date:   Tue, 15 Mar 2022 14:22:51 -0400
Message-Id: <164736856233.25507.10610104640146479593.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220311184359.2345319-1-djeffery@redhat.com>
References: <20220311184359.2345319-1-djeffery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wId_HCGV20IX_tr6n3l5vtt9hyyclBto
X-Proofpoint-GUID: wId_HCGV20IX_tr6n3l5vtt9hyyclBto
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Mar 2022 13:43:59 -0500, David Jeffery wrote:

> When aborting a scsi command through fnic, there is a race with the fnic
> interrupt handler which can result in the scsi command and its request
> being completed twice. If the interrupt handler claims the command by
> setting CMD_SP to NULL first, the abort handler assumes the interrupt
> handler has completed the command and returns SUCCESS, causing the request
> for the scsi_cmnd to be re-queued.
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] fnic: finish scsi_cmnd before dropping the spinlock to prevent abort race
      https://git.kernel.org/mkp/scsi/c/733ab7e1b5d1

-- 
Martin K. Petersen	Oracle Linux Engineering
