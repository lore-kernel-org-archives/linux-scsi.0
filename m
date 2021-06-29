Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE25FC11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 17:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A355661DB4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 17:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhF2Rhr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 13:37:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232308AbhF2Rhq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 13:37:46 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15THXYHh156261
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 13:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Rm+14CQWPVxFE6gStQrf44OhJb2LeyaOWLO6WRgOtOw=;
 b=eeF1saSbGsMSrIAO6XzrJh2pfGlr95ywk5g9DgEWfObzcDInQNShuJOU4CAu6GdGMNeP
 k2fk3PSNF0izIUX4Ub+ndwS4Z+gf7qIgU6vPzsyVFW1RSaai8dsydM04DzTiEVJMChPG
 7jP5vKtiC+LUF+BtDT38rLB4DKbhWA1JzdGUlor2iS1tLt/G/DwRDI26pu2hpWf0TxSc
 bUw8zzyOpZ8cwgqKbPPM5SBiwsPtOJG4KpJg2InQ0sH0J5mF81JLMSZqU/If09GHrISs
 igNpFvHOE3yUvAR7DMCiYIQAGW+SpNFEvQwNFNrAEez1sF9SJJiW9Fy8picbJ2hUTgJt Hg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g2ngaf4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 13:35:18 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15THYwKn025877
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 17:35:18 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 39duvbnt2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 17:35:18 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15THXvEo15532330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 17:33:57 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15CCF2807B;
        Tue, 29 Jun 2021 17:33:32 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6920D283A3;
        Tue, 29 Jun 2021 17:33:31 +0000 (GMT)
Received: from li-8b42f0cc-24d8-11b2-a85c-df7e17c2bac6.ibm.com (unknown [9.211.149.48])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 17:33:31 +0000 (GMT)
Subject: Re: [PATCH 1/1] ipr: system crashes when seeing type 20 error
To:     wenxiong@linux.vnet.ibm.com, jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        wenxiong@us.ibm.com
References: <1624587085-10073-1-git-send-email-wenxiong@linux.vnet.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <395b2318-75c5-c250-04a1-66053ea264ca@linux.vnet.ibm.com>
Date:   Tue, 29 Jun 2021 12:33:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624587085-10073-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4XPAqlt0IKnYkzk5iTHK-oVjmy2yALW_
X-Proofpoint-GUID: 4XPAqlt0IKnYkzk5iTHK-oVjmy2yALW_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_10:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=815
 spamscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>
