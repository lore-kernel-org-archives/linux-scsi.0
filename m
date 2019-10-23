Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7584CCA9EA0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 02:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 423A720679
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 02:33:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fF/IEJZd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732279AbfJWCd0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 22:33:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40476 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730655AbfJWCd0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Oct 2019 22:33:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N2UAwP034399;
        Wed, 23 Oct 2019 02:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=50FkkD1tlc6Jl7z36oTDHqnFkTLU8MePNrzE19IPc58=;
 b=fF/IEJZdMLzsAYX/D6yszrQFdg8iP/K3yCHjgGmMaiQU6Nbecf3puXT+VdMgOnYFJc8V
 s7wZsqmEfnZ90csriBNe2he6qxpKmU2jICRZGcbn8Aaqn4IFl7ynsM7GBKrxrkDvhTkC
 zq5OQ3AzosuZowMxjELFIvomdfvWRFPJuESQ3r5VAT3j3I05mOPkkxLDs8QXEnE/vsdd
 06xjRW/FgkYBonWXc7/2lXHzHbgNMsNZfWuqy1pJog17C1Cd8/7aAbOoF7IxheegGl0c
 pBlyQA5h8keHPCsHAKEe678YDO2cz12ELup9z42XTvamr4tyM89ptoBZJqw2pErRBYMr Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteptba7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 02:33:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N2X7OP108206;
        Wed, 23 Oct 2019 02:33:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vsp40ym4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 02:33:20 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9N2XJmk026762;
        Wed, 23 Oct 2019 02:33:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Oct 2019 02:33:18 +0000
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2] scsi: lpfc: Honor module parameter lpfc_use_adisc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191022072112.132268-1-dwagner@suse.de>
Date:   Tue, 22 Oct 2019 22:33:16 -0400
In-Reply-To: <20191022072112.132268-1-dwagner@suse.de> (Daniel Wagner's
        message of "Tue, 22 Oct 2019 09:21:12 +0200")
Message-ID: <yq1a79sdwcz.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=925
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910230024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910230023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Daniel,

> The initial lpfc_desc_set_adisc implementation dea3101e0a5c ("lpfc:
> add Emulex FC driver version 8.0.28") enabled ADISC if

Fixed up Hannes' email typo and applied to 5.4/scsi-fixes.

Also, please run checkpatch next time. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
