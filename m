Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1815EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF48220829
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Miu5hJDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgETCaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:30:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbgETCaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:30:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2TA2b031251;
        Wed, 20 May 2020 02:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=IHFiHpJA4mPjJpzNfK0U6GD2nk7hWyJyD3UKRV8jRFY=;
 b=Miu5hJDu7jipa+6fPAGblGTk3f+y9O1IP5VBurbh3sxZRc6hVIwzMOWTauW4sPNGXEyY
 Segz8yyKQv25Z+qVd/RZrpxkr/WayLGx56xffOMDBq+3eGngYZsLsfiYlc48FlP2w5xq
 Oz41aC67UXZIcrE46IpqnffVYSjIoWUkZFnKo8e8M6g5R+3Jx8UXhc0GfSjiM9VxqY+t
 mYoldwFLuDcpIC2ZgXEtwerjrhNZfOPMqKgjGFD+NHf3xx/fmy4ICPdz9EdMdm7dXhft
 m/WpyO2P5ETuHQC/SZcz9ygcQjQETfpkbBgcvqI+ap0iB2b2e041YESrcEHGZYE2b3p9 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284m0m90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:30:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2SQb0001492;
        Wed, 20 May 2020 02:30:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm65d4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:17 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K2UGV7011809;
        Wed, 20 May 2020 02:30:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:16 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Add zoned capabilities device attribute
Date:   Tue, 19 May 2020 22:30:04 -0400
Message-Id: <158994171817.20861.12266891813465992810.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515054856.1408575-1-damien.lemoal@wdc.com>
References: <20200515054856.1408575-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 May 2020 14:48:56 +0900, Damien Le Moal wrote:

> Export through sysfs as a scsi_disk attribute the zoned capabilities of
> a disk ("zoned_cap" attribute file). This new attribute indicates in
> human readable form (i.e. a string) the zoned block capabilities
> implemented by the disk as found in the ZONED field of the disk block
> device characteristics VPD page. The possible values are:
> - "none": ZONED=00b (not reported), regular disk
> - "host-aware": ZONED=01b, host-aware ZBC disk
> - "drive-managed": ZONED=10b, drive-managed ZBC disk (regular disk
>   interface)
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: sd: Add zoned capabilities device attribute
      https://git.kernel.org/mkp/scsi/c/c5f8852273dd

-- 
Martin K. Petersen	Oracle Linux Engineering
