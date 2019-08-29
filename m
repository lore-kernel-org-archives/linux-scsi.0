Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E81C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E276F2166E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:15:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BCzZTpa/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfH2WPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:15:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfH2WPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 18:15:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM73ZT193211;
        Thu, 29 Aug 2019 22:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=pH+E1WBw1ja0a06OzSFRxlDCSu5yCFiqWE70BnELpi8=;
 b=BCzZTpa/u45JxQPsWk1iv9dMHz/sKGBrN725CwCCY1XJ0UWeg03igcniaJ7qtVL7G8gO
 av7Af0lt/fSSmobgQ1soN8q9fSGE9uoMjqY38ndh1AguUpFu0lo9sxWfU7dyd3rWwZ2M
 ohQxZ9ru8KP6szTaogQdpZ/3E/whSeqVIPpIfLikY4fiLg0+9zfsCudnU3OHQkMeZcKk
 eOH0TjdKnfnwTS04AA2ietqemtJuj+4hUCaMjz4Sml25L0hLg9aMRAeu+1nT7eDaQ6Wx
 otBrF6m8fobsCpLA8nOZpLWzbrWaV1OrUzE6Lr2eLqVqECDtZ0lZYuw+turaPzZw43t3 TA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2upq7br16c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:15:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM455V137154;
        Thu, 29 Aug 2019 22:15:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2upc8v6cxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:15:47 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TMFlD1020751;
        Thu, 29 Aug 2019 22:15:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 15:15:46 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: fix 12.4.0.0 GPF at boot
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190828231911.8587-1-jsmart2021@gmail.com>
Date:   Thu, 29 Aug 2019 18:15:44 -0400
In-Reply-To: <20190828231911.8587-1-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 28 Aug 2019 16:19:11 -0700")
Message-ID: <yq1zhjrpqi7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=622
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290220
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=699 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290220
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> The 12.4.0.0 patch that merged WQ/CQ pairs into single per-cpu pair
> contained a bug: a local variable was set to the queue pair by index.
> This should have allowed the local variable to be natively used.
> Instead, the code reused the index relative to the local variable,
> obtaining a random pointer value that when used eventually faulted
> the system
>
> Convert offending code to use local variable.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
