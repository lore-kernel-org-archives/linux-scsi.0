Return-Path: <SRS0=kvmt=4R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F12C3F2D4
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 05:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90B6820684
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 05:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BO7uH1R0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgB2FSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Feb 2020 00:18:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60754 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2FSv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Feb 2020 00:18:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T5IFqb034572;
        Sat, 29 Feb 2020 05:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=VH9FJW2MoHSHl76KXeKFspJRl/dynnEyB2aZtkk6B5k=;
 b=BO7uH1R0oBj4VWisfm37nuGHNhiXEi5xVjUJVmFi6w6WgJZN+uOcpOfULOdtfBkJH3uR
 V0TpZywxn1iDbr9/4P/8tdnoKQlIZS4M3A2cEai49erZnnNFJ6sOqZPfzRYCqVRxdDJW
 1zGFWuaVTUUpO7OxtUaQdfsPoWQc93bz3dg7vTvW229bO7Fx9Ap6PCmKZ4M9oZnb4Q7v
 AIeSHBPtk/WuLb5+XnL8HppTHg5SnDbZ6r+GgPtcscbop2BiOMTGl8brp+Qck8FxMxmo
 r7X/0MmktdC4u1iTQaan/3/0zVicpdG6NLTuouw0FZDuU4SzeQoRfo8cdiHLmQDb7FIu PQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yffwq85cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 05:18:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T5IK9D144200;
        Sat, 29 Feb 2020 05:18:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yfd2vh6gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 05:18:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01T5IlLD023215;
        Sat, 29 Feb 2020 05:18:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 21:18:47 -0800
To:     Brian King <brking@linux.vnet.ibm.com>
Cc:     tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ibmvfc: Avoid loss of all paths during SVC node reboot
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1582767943-16611-1-git-send-email-brking@linux.vnet.ibm.com>
Date:   Sat, 29 Feb 2020 00:18:45 -0500
In-Reply-To: <1582767943-16611-1-git-send-email-brking@linux.vnet.ibm.com>
        (Brian King's message of "Wed, 26 Feb 2020 19:45:43 -0600")
Message-ID: <yq1a75255u2.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=910 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=973 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> When an SVC node goes down as part of a node reboot, its WWPNs are
> moved to the remaining node. When the node is back online, its WWPNs
> are moved back. The result is that the WWPN moves from one NPort_ID to
> another, then back again.  The ibmvfc driver was forcing the old port
> to be removed, but not sending an implicit logout. When the WWPN
> showed up at the new location, the PLOGI failed as there was already a
> login established for the old scsi id. The patch below fixes this by
> ensuring we always send an implicit logout for any scsi id associated
> with an rport prior to calling fc_remote_port_delete.

Applied to 5.7/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
