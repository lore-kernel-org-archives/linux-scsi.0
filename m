Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A06C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CD520773
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pTf1xwZT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgICDBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:01:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgICDBw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:01:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832xmup043729;
        Thu, 3 Sep 2020 03:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=RDPwcRGNtDYSnH+jzcaLLMQ9OnVuiH9B5rBS2x6t88Y=;
 b=pTf1xwZTV6+IfhXDohQU533PS5UhA3zZIuEvURhyQM3+QgtIGPH9kVnpVR+8KA7QEZV2
 s0yzSLJ1d6jg70jg16a7oxZSY6E50hgCBP+eU05XmZXhROED9m4TV3d4lTivSS1RALZC
 qA3mqSaKYiV9LOtPC3jBL4w1k9Lryu9JwXlUEwyPRzZjghhQ69r2nlLFsG9OFEkDTdNw
 U8OMWeJqGFabwPYDmG0POEyzgaM6BP5OW7iRBF2+R5VwGPo6EQ/lBdo2EHBNQhyiEHJM
 vxjRub4wjaGmai36miJ0mWsWfBA5Y/mFaBgpeRj6QBJG5lK2roMOP8Bwzn+F70bz6DIZ Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eer67m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 03:01:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832tGHS175929;
        Thu, 3 Sep 2020 03:01:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380kr1d5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 03:01:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08331A32016662;
        Thu, 3 Sep 2020 03:01:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:01:10 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Luo Jiaxing <luojiaxing@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        yanaijie@huawei.com, chenxiang66@hisilicon.com,
        john.garry@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: libsas: set data_dir as DMA_NONE if libata mark qc as NODATA
Date:   Wed,  2 Sep 2020 23:01:01 -0400
Message-Id: <159910202092.23499.14266650737882130791.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1598426666-54544-1-git-send-email-luojiaxing@huawei.com>
References: <1598426666-54544-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=944 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=935 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 26 Aug 2020 15:24:26 +0800, Luo Jiaxing wrote:

> We found that it will fail every time when set feature to SATA disk by
> "sdparm -s WCE=0 /dev/sde".
> 
> After checking protocol, we know that MODE SELECT is the SCSI command for
> setting WCE, and it do not exist in the SATA protocol. Therefore, this
> commands are encapsulated in the SET FEATURE command in SATA protocol.
> The difference is that the MODE SELECT command sent to SAS disk contains
> data and is sent through the DMA. But when send to SATA disk through
> SET FEATURE command, it does not contain data.
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA
      https://git.kernel.org/mkp/scsi/c/53de092f47ff

-- 
Martin K. Petersen	Oracle Linux Engineering
