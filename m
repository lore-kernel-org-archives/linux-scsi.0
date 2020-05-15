Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F7CC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46D55206D8
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pDGciFm9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgEOBKz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 21:10:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgEOBKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 21:10:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F13Bi0130937;
        Fri, 15 May 2020 01:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=TyrYiqH+VfGA6jGGAeVFMBRZ9nDOnNrJysU+L3STKvo=;
 b=pDGciFm9XOhkzHLEKW1j3p8x0Cw91o2/496QHQaynWPmEbodkGb3VQuJSRo5cMmsayEV
 8z31eISIGPglK+S/ydF66IVQoczDO6JQWd71LlGHcpsK1Wu0Y1dfhpku4XhiXBOWk546
 PKQLBOH4rykfTavleSX0gnfwCSMcblEA6oMzyqC7EKp81YtC5FlEGHdW6NTXMNkeLxzC
 7owIfQjpnkeHjIHPcEKjSRBScP/T3DDPyaWFB7P5I6JxSagzKO3/X2a3LEf4Dx/Pw1US
 J9yVpDL15ZiNT1t5wM8nEKkJy9zUtTNTuTfdS3fTyfn3lLrwToQfc7nnMK/dw6VOoaFP wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3100xwxpb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 01:10:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F12l2s161327;
        Fri, 15 May 2020 01:10:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3100yqf440-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 01:10:41 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04F1AcA0014071;
        Fri, 15 May 2020 01:10:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 18:10:37 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     john.garry@huawei.com, Jason Yan <yanaijie@huawei.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: Re: [PATCH v2] scsi: hisi_sas: display proc_name in sysfs
Date:   Thu, 14 May 2020 21:10:30 -0400
Message-Id: <158932946186.30297.18353935418962789564.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512113258.30781-1-yanaijie@huawei.com>
References: <20200512113258.30781-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=931 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=974 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150007
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 May 2020 19:32:58 +0800, Jason Yan wrote:

> The 'proc_name' entry in sysfs for hisi_sas is 'null' now becuase it is
> not initialized in scsi_host_template. It looks like:
> 
> [root@localhost ~]# cat /sys/class/scsi_host/host2/proc_name
> (null)
> 
> While the other driver's entry looks like:
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: hisi_sas: Display proc_name in sysfs
      https://git.kernel.org/mkp/scsi/c/55ce24b3bfd7

-- 
Martin K. Petersen	Oracle Linux Engineering
