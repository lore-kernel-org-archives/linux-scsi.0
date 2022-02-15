Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41125C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiBODTo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:19:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiBODTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:19:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D972720194
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 19:19:34 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F2UJik023654;
        Tue, 15 Feb 2022 03:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=7lKLaI8WKhLqPnUO/Yrdw71XS+3/wAjb5K66UK03vpE=;
 b=z/mocVVUOfyRmqbYq3dPOnSs0DweZSgkQ/08amiMm5M437vXBXcrhDpiudEKphMl2WkE
 8ge/NBgGnSy53r5NDRwvvri2qyTUkPObBHIRhHZPb8TivBuGa95fohvxgLGSiwDxHf87
 4Kzb9ymdPFdJwSS6bPgWTC0OApg3LflYZECz65yLmNwY9Iix42ATDTcXRm4BA363ePRe
 UQG0Y7SxzdtOA1e2T9DywhqXq3raoR+BCbtaKA6nk/vcrzyOgd23ZOtjP5/jKLSmkRHo
 2CklNE9hicGmGU8x/BCEiTXUhFozIXw9aLbJCdqFpRANMsgCQ6SQs/WCiNosRXFM0ota 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e65euee2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3Gm8Z057544;
        Tue, 15 Feb 2022 03:19:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e620wpgt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:32 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21F3JMPG064243;
        Tue, 15 Feb 2022 03:19:31 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e620wpgqq-8;
        Tue, 15 Feb 2022 03:19:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH 0/9] mpi3mr: Bug fixes
Date:   Mon, 14 Feb 2022 22:19:20 -0500
Message-Id: <164489513315.15031.3816596916239864582.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
References: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: j0ZTgyaTLAu0BuM1ieQFn-O6QKT7cIq8
X-Proofpoint-GUID: j0ZTgyaTLAu0BuM1ieQFn-O6QKT7cIq8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Feb 2022 15:28:08 +0530, Sreekanth Reddy wrote:

> This patch set contains bug fixes for some of the
> mpi3mr driver bugs.
> 
> Sreekanth Reddy (9):
>   mpi3mr: Fix deadlock while canceling the fw event
>   mpi3mr: Fix print proper pending IO count
>   mpi3mr: update MPI3 headers
>   mpi3mr: Fix hibernation issue
>   mpi3mr: Fix cmnd getting marked as inuse forever
>   mpi3mr: Fix report actual data transfer sz
>   mpi3mr: Update the copyright year
>   mpi3mr: Fix memory leaks
>   mpi3mr: Bump driver version to 8.0.0.68.0
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/9] mpi3mr: Fix deadlock while canceling the fw event
      https://git.kernel.org/mkp/scsi/c/580e6742205e
[2/9] mpi3mr: Fix print proper pending IO count
      https://git.kernel.org/mkp/scsi/c/6d211f1d2635
[3/9] mpi3mr: update MPI3 headers
      https://git.kernel.org/mkp/scsi/c/04b27e538d50
[4/9] mpi3mr: Fix hibernation issue
      https://git.kernel.org/mkp/scsi/c/191a3ef58634
[5/9] mpi3mr: Fix cmnd getting marked as inuse forever
      https://git.kernel.org/mkp/scsi/c/b3911ab3a76e
[6/9] mpi3mr: Fix report actual data transfer sz
      https://git.kernel.org/mkp/scsi/c/999224612724
[7/9] mpi3mr: Update the copyright year
      https://git.kernel.org/mkp/scsi/c/21401408ddeb
[8/9] mpi3mr: Fix memory leaks
      https://git.kernel.org/mkp/scsi/c/d44b5fefb22e
[9/9] mpi3mr: Bump driver version to 8.0.0.68.0
      https://git.kernel.org/mkp/scsi/c/22754f7fbb40

-- 
Martin K. Petersen	Oracle Linux Engineering
