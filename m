Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE84C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D36261AA7
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhKSEUD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:20:03 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17662 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233958AbhKSEUA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:20:00 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ1jgjY019269;
        Fri, 19 Nov 2021 04:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=2hPKR/yQAwymMrY4ZyHZlkyqZBdcPI8DN8f+qfc06D0=;
 b=SWN40jEQEQLQhUlzCo/s6aR0oFoXYu455ojSv6dWLsP2hgkWJVrFHXUUsh9B38EfI3C6
 hVcwbdG3GzCbZlKcOvxkY6bWcH9D+zsT6NgGLCSJ3MdVUwr36brO7qzGsiZ9+U7o38No
 JRyZdL0xa6KWZRv93His0v6vJgMVlzZfhRA4qLyYzQMN1uN8Ci586pVAp7eUqh8tiAvZ
 26KyinFUMDaI69Yq7gj/okvsU9rEUwGeUMZT7h5tJ2bbuE7XykWBosd612vB7SzglmBi
 MFYAdcH2700DEqeeLCAawU6i690Zj95VRrsLFVKUb87EEloygcxrosDDqajnQv9qHsgx Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2w93kbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FC5f020463;
        Fri, 19 Nov 2021 04:16:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:53 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwY024731;
        Fri, 19 Nov 2021 04:16:53 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-10;
        Fri, 19 Nov 2021 04:16:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     cleech@redhat.com, Mike Christie <michael.christie@oracle.com>,
        jejb@linux.ibm.com, lduncan@suse.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] iscsi: Unblock session then wake up error handler
Date:   Thu, 18 Nov 2021 23:16:39 -0500
Message-Id: <163729506335.21244.12011833253029564693.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211105221048.6541-2-michael.christie@oracle.com>
References: <20211105221048.6541-1-michael.christie@oracle.com> <20211105221048.6541-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: mYm_upf4ccsmV4FnJ6jQZGzzOm8P8Ogd
X-Proofpoint-ORIG-GUID: mYm_upf4ccsmV4FnJ6jQZGzzOm8P8Ogd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 5 Nov 2021 17:10:47 -0500, Mike Christie wrote:

> We can race where iscsi_session_recovery_timedout has woken up the error
> handler thread and it's now setting the devices to offline, and
> session_recovery_timedout's call to scsi_target_unblock is also trying to
> set the device's state to transport-offline. We can then get a mix of
> states.
> 
> For the case where we can't relogin we want the devices to be in
> transport-offline so when we have repaired the connection
> __iscsi_unblock_session can set the state back to running. So this patch
> has us set the device state then call into libiscsi to wake up the error
> handler.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/2] iscsi: Unblock session then wake up error handler
      https://git.kernel.org/mkp/scsi/c/a0c2f8b6709a
[2/2] scsi: Fix hang when device state is set via sysfs
      https://git.kernel.org/mkp/scsi/c/4edd8cd4e86d

-- 
Martin K. Petersen	Oracle Linux Engineering
