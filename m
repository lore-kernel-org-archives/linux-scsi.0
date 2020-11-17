Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA15C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3A9246A4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:23:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GBM1eXiW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgKQDXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:23:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgKQDXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 22:23:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3AQMh121488;
        Tue, 17 Nov 2020 03:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=SbsbLn2KScETq2z0f+Y5TDcNNoh/QOWarOD1dmNqu0g=;
 b=GBM1eXiW4OAo+b793cjKHJHOH3l/fbMMbIhGv070SBlfl9xNkmqA6r1nLFAmyY9sqPRm
 ZIrjCxRP9EcWIph9KNsU5OTn9a3C20EPAFn9WBIKyq/LoYCS1o7vr553iMZK7nOWsVCG
 nn98kQJZVbfVblzMKnOOHMJdbN5+7Zxxq2fomGZZ8dlblLhwunejP7IqL+jB2WXw8u2I
 OGILlEDkE3Bk8RFGCvqKfzb/qFSBHs+dKGVbTWWAAXmtfs95faUai8rAL7g0kj79Eim3
 AFV2cc1P+5hHJXiGRJz1bkWbvmfKi7ZFhsrQzYP/gZyBPeCJ7/Ndg0wexiWclVjhWthD 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34t7vn0abr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 03:22:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH39XZY048279;
        Tue, 17 Nov 2020 03:22:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34uspstcds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:22:56 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH3MeWC023330;
        Tue, 17 Nov 2020 03:22:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 19:22:40 -0800
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/6] ibmvfc: byte swap login_buf.resp values in
 attribute show functions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18sb07l17.fsf@ca-mkp.ca.oracle.com>
References: <20201112010442.102589-1-tyreld@linux.ibm.com>
        <20201112093752.GA24235@infradead.org>
        <7df9d768-e008-a849-5fbd-78d6bd0536fa@linux.ibm.com>
Date:   Mon, 16 Nov 2020 22:22:37 -0500
In-Reply-To: <7df9d768-e008-a849-5fbd-78d6bd0536fa@linux.ibm.com> (Tyrel
        Datwyler's message of "Fri, 13 Nov 2020 11:39:35 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> The checkpatch script only warns at 100 char lines these days. To be
> fair though I did have two lines go over that limit by a couple
> characters, there are a couple commit log typos, and I had an if
> keyword with no space after before the opening parenthesis. So, I'll
> happily re-spin.

Please tweak the little things that need fixing and resubmit.

> However, for my info going forward is the SCSI subsystem sticking to
> 80 char lines as a hard limit?

As far as I'm concerned the 80 char limit is mainly about ensuring that
the code is structured in a sensible way. Typesetting best practices
also suggest that longer lines are harder to read. So while I generally
don't strictly enforce the 80 char limit for drivers, I do push back if
I feel that readability could be improved by breaking the line or
restructuring the code.

Use your best judgment to optimize for readability.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
