Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584E6C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41D1A610CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhJUDqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49136 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230507AbhJUDpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:20 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L33AdG029729;
        Thu, 21 Oct 2021 03:43:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=sCa0DBuKWiePDVne6M/kw2h8j0FJir/ih2Kit+gL7nY=;
 b=ZloWzcvaEump9ursU8PAbEDle1if2kw5tQLGYnE5MrqxkVqhxATHSj3n3exkxncjfFg4
 ryPrR+kV8/Al02K+kq6Kh3XCV0KQuJ/ZkP26ShOInV38KDIMoFgKZS96tCCiAuzotUet
 HDlRNzIDcHOzDp2tWVgkLtwxvyxmXTDYpyU0qvdQTDHau/Fw0VtticspVXzBfhjURemh
 urWX4n1kVvfAWnveD8blHBUeTSdAl6HawVKxKJAQPHnK8idh/puqgEF+sWwsXBvi020D
 JZkYW8QsjiGTXcMiQflHU9tybn6OG6UK/Z7SHPC90Y5UPmsHifEmC8ob9HSwBGzOcAUj Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3wvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esWY078082;
        Thu, 21 Oct 2021 03:42:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:59 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu7u082116;
        Thu, 21 Oct 2021 03:42:59 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-6;
        Thu, 21 Oct 2021 03:42:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Adam Radford <aradford@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: 3w-xxx: Remove redundant initialization of variable retval
Date:   Wed, 20 Oct 2021 23:42:37 -0400
Message-Id: <163478764103.7011.7284356461891990689.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013182834.137410-1-colin.king@canonical.com>
References: <20211013182834.137410-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: W4ohr29NiuhibCb7pX-9_LMH2jbxNPkn
X-Proofpoint-GUID: W4ohr29NiuhibCb7pX-9_LMH2jbxNPkn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2021 19:28:34 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable retvasl is being initialized with a value that is never
> read, it is being updated immediately afterwards. The assignment is
> redundant and can be removed.
> 
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: 3w-xxx: Remove redundant initialization of variable retval
      https://git.kernel.org/mkp/scsi/c/8ecfb16c9be2

-- 
Martin K. Petersen	Oracle Linux Engineering
