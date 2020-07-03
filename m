Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C756C433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1960C206DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jbTzDwSd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgGCEEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:04:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgGCEEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:04:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06341TIq158531;
        Fri, 3 Jul 2020 04:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=AOBc9D1qv+XEASgZh3wECnHUcd6OlXCBMNLivaou9R0=;
 b=jbTzDwSdcOBPArV4Pah6RpjQs8JMZoA8TOpQq2yI6pEfFZf+8SO7USd1SiV6arD3lKnL
 DFUhGRDghlP6op3mr79vDw9QZzUFyOND4nwLN8nTTjDGreRY4d11puiNXQnKi5awNMC9
 wa4pm3vAsSX1/iA/P8y25qA+Wbz8IBkwBFiiprneVQiZVY48C+NkhiW4Ghn9IN5msUYV
 or1XiaN4MtJs3WjtKCNPWGfs0h/EW1CkiuhhldeBZYbZqOz71rcJTf9Fz5moqOJTG5BF
 gxptRfa/hnyo225yJw+DxREZ5lKrDwERoqmr/4YrNSg23UlpYWxjxZlbxIdii8fJrjgq Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31ywrc1wrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 04:04:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633wtbt009056;
        Fri, 3 Jul 2020 04:04:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52npxwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 04:04:02 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 063441ew003824;
        Fri, 3 Jul 2020 04:04:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 04:04:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien.LeMoal@wdc.com, hare@suse.de, jejb@linux.vnet.ibm.com
Subject: Re: [PATCH] scsi_debug: fix in_use bitmap corruption
Date:   Fri,  3 Jul 2020 00:03:54 -0400
Message-Id: <159374899165.14731.1676114329249032974.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702145355.522283-1-dgilbert@interlog.com>
References: <20200702145355.522283-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1011 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2 Jul 2020 10:53:55 -0400, Douglas Gilbert wrote:

> Heavy testing indicates the irqsave() spinlock around the
> __set_bit() is insufficient to stop following clear_bit() calls
> being rarely applied out-of-order. Also the nearby failed
> kzalloc() path leading to SCSI_MLQUEUE_HOST_BUSY does not
> properly undo the in_use bitmap and num_in_q, fix.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Fix in_use bitmap corruption
      https://git.kernel.org/mkp/scsi/c/74595c044cb5

-- 
Martin K. Petersen	Oracle Linux Engineering
