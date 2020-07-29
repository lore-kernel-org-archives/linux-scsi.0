Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2074C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF00A20768
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C9o1hsfm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgG2EKy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:10:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgG2EKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 00:10:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T41eCM178590;
        Wed, 29 Jul 2020 04:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=k/wA48ninh3O4LNW4aoOyCLxoTQokP10S79obE2M3XU=;
 b=C9o1hsfmDzHESrOEsBrqQQMRoYJLTPMymnmGIl4T2ME4W7WEfo63qztqF4l8ZjO4OX3u
 NsjzxnUkyS/MXG7OfXrtfjWiCiqrVNA70sOweR1Tu5PnweDfer5xR8ov5QlDtXoi34/2
 uBbh23rU9Lt2JAwGKC75sp54zg4znTGs/fHHOdpCxltAtR3zHExYSMKFR6AWsI3CcaVp
 eu9rr8xvCx9U3sM/HSm/JnpoduV7ELzn0CCdPt6UyJ/JH271rt/pq6+GFuU9PWwy2PJq
 cQftc9gHnvDmZNCNyTpfCZDN1825voZIg0yU7WHNyxWz/FRsh7koE3EqcgxiSud6BncE gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32hu1jk62e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 04:10:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42a8I023765;
        Wed, 29 Jul 2020 04:10:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32hu5u1pvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 04:10:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06T4Ag2W011190;
        Wed, 29 Jul 2020 04:10:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:10:41 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>, jejb@linux.vnet.ibm.com,
        hare@suse.de
Subject: Re: [PATCH v2] scsi_debug: tur_ms_to_ready parameter
Date:   Wed, 29 Jul 2020 00:10:34 -0400
Message-Id: <159599579270.11289.12476844514299239357.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724155531.668144-1-dgilbert@interlog.com>
References: <20200724155531.668144-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Jul 2020 11:55:31 -0400, Douglas Gilbert wrote:

> The current driver responds to TEST UNIT READY (TUR) with a GOOD
> status immediately after a scsi_debug device (LU) is created. This is
> unrealistic as even SSDs take some time after power-on before
> accepting media access commands.
> 
> Add the tur_ms_to_ready parameter whose unit is milliseconds (default
> 0) and is the period before which a TUR (or any media access command)
> will set the CHECK CONDITION status with a sense key of NOT READY and
> an additional sense of "Logical unit is in process of becoming ready".
> The period starts when each scsi_debug device is created.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Implement tur_ms_to_ready parameter
      https://git.kernel.org/mkp/scsi/c/fc13638ae92e

-- 
Martin K. Petersen	Oracle Linux Engineering
