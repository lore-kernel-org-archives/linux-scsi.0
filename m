Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B2C2C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB72321874
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uu3OylLf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfH2WNd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:13:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbfH2WNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 18:13:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM6STu009015;
        Thu, 29 Aug 2019 22:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=+UhTFexQ8brHvX4pqa8MGXkKQ3SWU7/Ujb7G5Vlc4jo=;
 b=Uu3OylLfhKDOyyFL+1o496Y0eZuYUxJYUEKU8fHa94XGX65SJGntSN2un2QgMFIynFLy
 sJLVrb+Dd6W6s2nm0DrNNebCAX/+sEGxqTHkqtr5R2ylzCrIzW3FIGHC+EZWQLaQGAqv
 2B2QBEqTble2gWr/oshuKHrpsmrPe/RHckyMqG8R8bbOTqljEuZu+eQzCajLPKgHgauq
 JXAP8JZLXp/9fcm0wupTw7l1tEoRzVK0+8UWt4WVUIGTYrRe6pW9RM/Fpad066UR+MF1
 ff7w0h3OV2oC+g94JwawZSDHobD8qlZ8h4s/JMTscBkZ01Y7ebT2ty2vcO6mbUDsedFL sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2upq6y811p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:13:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM47d8134079;
        Thu, 29 Aug 2019 22:13:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2unvu0p6dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:13:28 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TMDRLk022879;
        Thu, 29 Aug 2019 22:13:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 15:13:26 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] lpfc: Raise config max for lpfc_fcp_mq_threshold variable
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190827212823.30107-1-jsmart2021@gmail.com>
Date:   Thu, 29 Aug 2019 18:13:25 -0400
In-Reply-To: <20190827212823.30107-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 27 Aug 2019 14:28:23 -0700")
Message-ID: <yq14l1zr56i.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=743
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290220
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=804 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290220
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Raise the config max for lpfc_fcp_mq_threshold variable to 256.

Not a big fan of these magic values.

Applied to 5.3/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
