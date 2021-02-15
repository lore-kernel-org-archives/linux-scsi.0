Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7501BC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 20:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 350DC64DF0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 20:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhBOUxX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 15:53:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59830 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhBOUxW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Feb 2021 15:53:22 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11FKlcOH080060;
        Mon, 15 Feb 2021 15:52:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ix5xI4eV4ktS+Si1szwX06PnD5N08iIL8loUbC9USd4=;
 b=WgI1rCnu55qJBxYlo2+anOSbJE3qo/wP+I5mUyI38JAHlQ9CphTjNZlljRVUKRcmzjJo
 E5FkxrH1tDzo7OvVlCOdFK1N+CPIGtjpzgy42BbdH0wY+SWnz+0GqUSWXh/6chnSN6Jc
 /6XE31qElrQxKhxjAYL89QMl6Zeqfrm2+rclDXOTWREr087Ja6MW1QLmklKM0d46dmoc
 m8WPAkBNaqHBZEbE6pyJZjNDVPWA3Qo2EvLvSpECnTSyFaIAeMnjJPpCr0HUTyAwEOjj
 ty7M6jRwagt2hDlEdD3r4XN3w2HiAb4HX3V+ErmwynAA8v8H3OwtGPN4vHN0T6e9O7O6 Ww== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36r0a9g23a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 15:52:34 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11FKlfxL007425;
        Mon, 15 Feb 2021 20:52:33 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 36p6d8skr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 20:52:33 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11FKqW7v11600228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 20:52:32 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 062B978060;
        Mon, 15 Feb 2021 20:52:32 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 895A37805E;
        Mon, 15 Feb 2021 20:52:31 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.130.226])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 15 Feb 2021 20:52:31 +0000 (GMT)
Subject: Re: [PATCH 1/4] ibmvfc: simplify handling of sub-CRQ initialization
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210211185742.50143-1-tyreld@linux.ibm.com>
 <20210211185742.50143-2-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <a3a7b428-3225-0645-0621-fc4b1c5ec618@linux.vnet.ibm.com>
Date:   Mon, 15 Feb 2021 14:52:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210211185742.50143-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-15_16:2021-02-12,2021-02-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 clxscore=1011 mlxscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150156
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

