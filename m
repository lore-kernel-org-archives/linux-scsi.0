Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6920EC63798
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C44D20857
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ojR/ZMNs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgKXDtD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:49:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41806 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKXDtD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:49:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3mnis149473;
        Tue, 24 Nov 2020 03:49:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=6HpbE0r504VsbC5JkrkLgncZBl481poS92wMj+nW6zk=;
 b=ojR/ZMNslWGlfrsJffRwa94XGCG9ItPVS9Hf7kNyq3KoGWJKKHYLyYM5DfvOFcpiI3QF
 pNInUouC+peGzOd0un7LDUXvuJBqBvPxxSm5zvLbNrGXrKvF1TgABZMsaklGWsrJHykE
 tODQywY1VqYmz9x40144PrpEJ9s7V0W8KbXlSTk5WkhrHJ0axR8u6Abz0+us3t/tMHW7
 wpjG2aAK7LZaEym+Z/yNHd69rfsHRgKAFIwudwB+SIBqbwyq+AYHLzHorZKSlxA4oP0X
 h8u/ayHWWPNBv61HeEiPHVVjpn+fzgm8ODjF8Q6NaN06jWK4P5H6I251XLcaSRPrZWfV sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34xtum0djg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:49:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3jrxK058272;
        Tue, 24 Nov 2020 03:48:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ycnrvpb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:48:59 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3mwL8023783;
        Tue, 24 Nov 2020 03:48:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:48:58 -0800
To:     Karan Tilak Kumar <kartilak@cisco.com>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, arulponn@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Validate io_req before others
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg8zl8im.fsf@ca-mkp.ca.oracle.com>
References: <20201121023337.19295-1-kartilak@cisco.com>
Date:   Mon, 23 Nov 2020 22:48:56 -0500
In-Reply-To: <20201121023337.19295-1-kartilak@cisco.com> (Karan Tilak Kumar's
        message of "Fri, 20 Nov 2020 18:33:37 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1
 mlxlogscore=835 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=847 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=1 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Karan,

> We need to check for a valid io_req before we check other data. Also,
> removing redundant checks.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
