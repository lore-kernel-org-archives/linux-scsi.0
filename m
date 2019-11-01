Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6EECA9ECB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 02:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 288B8208CB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 02:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oekX6Eho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfKACcV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 22:32:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53358 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbfKACcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 22:32:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA12TeiQ151579;
        Fri, 1 Nov 2019 02:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=MuJWAL8dDp+AIlGsnCFrDh1VSS0Bcoqog/dfkmNAz2k=;
 b=oekX6Ehop7O5m/cYccBrCxFYBqKIJ9eMwFrlOS7cDpHGI5t9fBhDKtuAmJDKv0y5Egh7
 b7z8OQsU1Lh3eXlmwxZZavf612JlhrKfFCiSTJS3GPtx/5b7EASladzxAwsJQ6ofactJ
 6GiJQMYe9tNWQHV/JxPSfahrydZWiO/0G+kv+1I7b/5BD8PItgnTKK7ASJ9mcdqj2Q8D
 Cr5cQJauklvwzW5ckl26egcQwz8pPJ1db9O2UUBBs9uiaznHuj+GOxEUDDCBtTm6LZ3x
 IQa3RrlsIK9eH7JPuEu4He4Hud+bJty7YW2apH5jTE6p/k9A9G66mpLPQ9cj1XqoCmBL rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vxwhfxxj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 02:31:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA12Rp5t075252;
        Fri, 1 Nov 2019 02:31:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vyqpfbewy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 02:31:42 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA12VdIJ015089;
        Fri, 1 Nov 2019 02:31:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Oct 2019 19:31:38 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] scsi/trace: Use get_unaligned_be*()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191031174217.124406-1-bvanassche@acm.org>
Date:   Thu, 31 Oct 2019 22:31:36 -0400
In-Reply-To: <20191031174217.124406-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 31 Oct 2019 10:42:17 -0700")
Message-ID: <yq15zk45nuf.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9427 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=573
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9427 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=654 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch fixes an unintended sign extension on left shifts. From
> Colin King: "Shifting a u8 left will cause the value to be promoted to
> an integer. If the top bit of the u8 is set then the following
> conversion to an u64 will sign extend the value causing the upper 32
> bits to be set in the result."

Looks good in general. One minor nit:

> +	 * From SBC-2: a TRANSFER LENGTH field set to zero specifies that 256
> +	 * logical blocks shall be read (READ(6)) or written (WRITE(6)).
> +	 */
> +	txlen = cdb[4] ? : 256;

Please avoid using the gcc conditional extension. Please either write it
out in full or make it an if statement.

Also, maybe this change should be a separate patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
