Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94F7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 03:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C243D20720
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 03:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cyhc4uU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgGBDFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 23:05:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgGBDFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 23:05:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06233BsN083722;
        Thu, 2 Jul 2020 03:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=3BVJuMJfGv519RrYmQikLlcBr87w9tThfNUOvcUMI+w=;
 b=Cyhc4uU3Vd0/oxhPQN94HSpBemPDtBfBw+3TU0lfXcHAL7/bVaA4Lv9kn1Y5DofDXttq
 SqclTsd01Zd88peHWWujtmkhKMv+g4zobH2f/qSI2uwtktRNhcJxg4eFVfKqvMP2aaEh
 YemkfGcE+5kF6/fu0JSAWH0vADQNXWAxltJJdAdtjLGSdzFNyWEQ/nsy8ITqEuKwhgWZ
 o2+PlJAaY109JVwtQmOsHpgKN4KuuYU4nTU6cNA4IQugjOQzT7yhWbKp3/95JcY8O4FO
 YZvcoMDAm9hpOQlJ/xOLDIsWLbBddF1E+yNBx7+ab358UPB6XEQjXP/xzefHwYPXj1OI uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31xx1e2qmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 03:05:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06232dIs189993;
        Thu, 2 Jul 2020 03:05:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvuukqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 03:05:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06235HlB017606;
        Thu, 2 Jul 2020 03:05:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 03:05:17 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH 03/14] lpfc: Fix first-burst driver implementation.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8oyaaeh.fsf@ca-mkp.ca.oracle.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
        <20200630215001.70793-4-jsmart2021@gmail.com>
Date:   Wed, 01 Jul 2020 23:05:15 -0400
In-Reply-To: <20200630215001.70793-4-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 30 Jun 2020 14:49:50 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020021
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> - Upon PRLI completion, if first-burst is enabled and the target supports
>   first burst, the driver will issue a modesense6 scsi command to obtain
>   the disconnect-reconnect page that has transport specific limits. This
>   page reports the max first-burst size supported on the target. The size
>   supported is saved in the target node structure.

I didn't make it beyond this patch :(

Why do this in the driver? If you need the Disconnect-Reconnect page,
then let's ask for it in the core code. Maybe in the fc transport so we
don't risk upsetting USB devices, etc. See sas_read_port_mode_page().

-- 
Martin K. Petersen	Oracle Linux Engineering
