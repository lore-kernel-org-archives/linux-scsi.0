Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAC4C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A482166E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:10:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nub1iRBI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfH2WKA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:10:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2WKA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 18:10:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM89jP013201;
        Thu, 29 Aug 2019 22:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ZrFF35bqsvZEurPfDRzbh+zo8fNOI1pMt9r+cYGSDOA=;
 b=Nub1iRBIYF86PjamajKQYQTKFXtVoH6Ej4DyX81602Pz9tUAZzxdV3NR6EYBZ7sDy7h3
 VhwJR3dvDWEpfSabGFQjXQQtxoZRyUhEVRre3lC7rK1LEudyTKT+r9NuBedTpixmUpU+
 8R26b5A2ntVeHlbc4ezib0CAGEHM8nPcaRwRxY7ny6AHS/6R0dwgVX7edso608SXl2rw
 tMKadZQPK0FeGqgcZ3ShWs+LBJ5oQRi4p6v5f9HBEKnUGHF9qV9PhV+sjzMWZpLnzZq6
 g3JvUNZ5INJYev+kZZkSqa+A3DvOzyAkR9TaqYsx3KEDk+DFYyhgDuIUIyA2kKIOn6kz sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2upq7sr060-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:09:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM49vf190335;
        Thu, 29 Aug 2019 22:09:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uphauc02y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:09:52 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TM9pVB017381;
        Thu, 29 Aug 2019 22:09:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 15:09:51 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] lpfc: Remove bg debugfs buffers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190827212805.30060-1-jsmart2021@gmail.com>
Date:   Thu, 29 Aug 2019 18:09:49 -0400
In-Reply-To: <20190827212805.30060-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 27 Aug 2019 14:28:05 -0700")
Message-ID: <yq18srbr5ci.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=882
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290220
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=959 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290220
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Capturing and downloading dif command data and dif data was done a
> dozen years ago and no longer being used. Also creates a potential
> security hole.
>
> Remove the debugfs buffer for dif debugging.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
