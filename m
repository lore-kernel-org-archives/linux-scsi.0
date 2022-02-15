Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A69BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbiBODTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:19:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiBODTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:19:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DDE205C9
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 19:19:29 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F2WvHf022038;
        Tue, 15 Feb 2022 03:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=46zFtglfi8sjiXQSLhriwktINhdNnGTcag4ltk2w420=;
 b=Bf1BQOsAB5fI4KcdkJj2CITJq35uXV/lAmKbw9VY3bjs276/wpKCbSgeREg2g6V6+0NP
 1jcftlExiQZiuBhodkKdsoJ1+FBOBBzVgZ2YLnjJXfzHdwcnaIvtlRxZS5MtAlUTg/PZ
 s1mJU38FL0h5BugkwnoO2CjbEB+F4csdgaZdVI8uczL9nkWRxO6g3QEW7z8DHdUbrMSU
 T9omhLdTk+xxiXeWU1VvZE77bypAZAgBy9sl6M7nSZ56v2PrquFwYKxu4x2J0yo+/h0J
 TeWvg6oAsLVKNMoOHW5mfwaqRUFvlXJKIznWXu1FpnRAG1+a21KBDFZrf4JNhB7wkYk3 XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63ad6bqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3GmOk057516;
        Tue, 15 Feb 2022 03:19:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e620wpgrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:25 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21F3JMP6064243;
        Tue, 15 Feb 2022 03:19:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e620wpgqq-3;
        Tue, 15 Feb 2022 03:19:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Don Brace <don.brace@microchip.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mike.mcgowen@microchip.com, balsundar.p@microchip.com,
        murthy.bhat@microchip.com, mahesh.rajashekhara@microchip.com,
        Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com
Subject: Re: [PATCH] smartpqi: fix unused variable pqi_pm_ops for clang
Date:   Mon, 14 Feb 2022 22:19:15 -0500
Message-Id: <164489513314.15031.15243432127896154049.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210201151.236170-1-don.brace@microchip.com>
References: <20220210201151.236170-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: xd2wWdV7WZjD7tOfk6ZTBf9gMwoMpRZt
X-Proofpoint-ORIG-GUID: xd2wWdV7WZjD7tOfk6ZTBf9gMwoMpRZt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Feb 2022 14:11:51 -0600, Don Brace wrote:

> Driver added a new dev_pm_ops structure used only if CONFIG_PM is set.
> The CONFIG_PM MACRO needed to be moved up in the code to avoid the
> compiler warnings. The HUNK to move the location was missing from
> the above patch.
> 
> Found by kernel test robot by building driver with
> CONFIG_PM disabled.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] smartpqi: fix unused variable pqi_pm_ops for clang
      https://git.kernel.org/mkp/scsi/c/31b17c3aeb5e

-- 
Martin K. Petersen	Oracle Linux Engineering
