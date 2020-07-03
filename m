Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8845C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97E06208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dv0YDx32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGCEER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:04:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgGCEER (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:04:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06341T68158538;
        Fri, 3 Jul 2020 04:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4L+MvHZ8M0MvEMta2g/UXgscdME5fkuFvt18ijNsUvo=;
 b=Dv0YDx32DKkhCTdrcTlPqRsXzlU7vadB3rutxYdtUFV19ufD4QAZU90xAouj8L2D7Usk
 laShj28q5iHavmbWCF8PURH/TmK1yRk4XbY/ewzXXO15GNrp0aZRlkZo8UHyeWChgTaf
 7rIM6cKDYUMMVuM53wutvXveqdaVHvPDPrv1+tv4c4DHe0Muo0H/OJhcNZKY0mOi+5+u
 GIgW95vOHExJc6vsmV+WmytryJWZQZpfJES4QNaiZbPWOHiShiaHkQxvgVpCMxJOpuSL
 u5opThqHZYq34SAAxj8HN5yVqXwHmYIkSZ9hbzFv/ADD2+AeqiSnTAXQagJg+JYsjsNu tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrc1wrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 04:04:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633wp5d161637;
        Fri, 3 Jul 2020 04:04:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg1b5p4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 04:04:03 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06343xPM005839;
        Fri, 3 Jul 2020 04:03:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 04:03:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux@armlinux.org.uk,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: eesox: Fix different dev_id between 'request_irq()' and 'free_irq()'
Date:   Fri,  3 Jul 2020 00:03:52 -0400
Message-Id: <159374899165.14731.1540154014107361984.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626040553.944352-1-christophe.jaillet@wanadoo.fr>
References: <26d388f5-be67-b643-c76c-b9fe52f111f7@wanadoo.fr> <20200626040553.944352-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=907 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=916
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 26 Jun 2020 06:05:53 +0200, Christophe JAILLET wrote:

> The dev_id used in 'request_irq()' and 'free_irq()' should match.
> So use 'info' in both cases.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: eesox: Fix different dev_id between request_irq() and free_irq()
      https://git.kernel.org/mkp/scsi/c/86f2da1112cc

-- 
Martin K. Petersen	Oracle Linux Engineering
