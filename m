Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E12DC4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 05:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855BE61351
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 05:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFWFgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 01:36:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229665AbhFWFgg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 01:36:36 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N5XvRY111969;
        Wed, 23 Jun 2021 01:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=o3ADjnAgcsEwiijG0eXmmifGWgN8v6XefEBzlOVFZCY=;
 b=KbfTDg/TIL0X4AeI358JQaC2PCQluFg2vFlTlhnjEy7UM3ZZYpl3OLtN8GiRxfLYtMhs
 gcWDM6+Tf4KkzhzMncQlUsHNVYldQRq54c0AANRF2DV0kfw85vNV3w36b3JYyy7105Qs
 TbKTxshp49UkQaOF7Uy87ZUM6FZacfiUWS+nUNm1OG9qhqhx/6D9Vm8lz6mKK+bDxw98
 jAiWuhrgqP9Tc0GnY8jbU+oghNN2QTGR/1gQoRr2Nl7ueu71TuDlw4u3+BaRVy5Q786Z
 p9BLhNfFSGETpG+E29F11egoCVJYUX6wlT7g5JHVvsfwWFG9FCBikEl7kANb5MYMpKjk JA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bwrqhn02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 01:33:59 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15N5VJdC017191;
        Wed, 23 Jun 2021 05:33:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3998789s64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 05:33:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15N5XmwK30212594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 05:33:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0988A4067;
        Wed, 23 Jun 2021 05:33:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACAD1A407E;
        Wed, 23 Jun 2021 05:33:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 23 Jun 2021 05:33:46 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 52D2FE07C7; Wed, 23 Jun 2021 07:33:46 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     martin.petersen@oracle.com
Cc:     hare@suse.de, hch@lst.de, james.bottomley@hansenpartnership.com,
        jirislaby@kernel.org, linux-scsi@vger.kernel.org,
        linux@roeck-us.net, borntraeger@de.ibm.com
Subject: [Re: [PATCHv2] virtio_scsi: do not overwrite SCSI status
Date:   Wed, 23 Jun 2021 07:33:45 +0200
Message-Id: <20210623053345.254596-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <yq1eects61b.fsf@ca-mkp.ca.oracle.com>
References: <yq1eects61b.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1fxiz5Zcka8MHEQ4mhnL0ukRKE0P1-8D
X-Proofpoint-ORIG-GUID: 1fxiz5Zcka8MHEQ4mhnL0ukRKE0P1-8D
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_01:2021-06-22,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxlogscore=569
 bulkscore=0 clxscore=1011 spamscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Applied to 5.14/scsi-staging, thanks!

This fixes virtio-scsi for me.
Thanks.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
