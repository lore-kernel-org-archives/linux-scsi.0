Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D59C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 13:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97F4C20840
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 13:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kKYKcwkW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfHMNTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 09:19:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfHMNTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 09:19:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DDEOUi005488;
        Tue, 13 Aug 2019 13:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=k7TTtVj2NunJ0RECYPXm4Q9yMluI1ySqxRPbjTuFfSc=;
 b=kKYKcwkW7vRoJWzTqTE/HiDcA+NQYIkHTejMTDgTCnISFmhFK/t4tSol6FFQmo4qqv4F
 NGitYrBuvjUaiwUi9RWsMsyy5FOZy5ysLIeSV5swOx+CIm7e31aOHOYspxjv8bKWCNKc
 g67Rxs94k1V3hy7+zdKbtjSrlSlW1KLCgx+hSPoRsliA4kXdwIN35A8kP5S/KjGq4sOb
 4kcLf2OXVfzNICwg+LdTviaY1eapQfriPFbbqTQosSs261JvqeaEeyLjTBO7WmSdW/6V
 VtZhR2bTppwEqnw1hX88/okPc8+hSOxjH5iKE8Vo60ZhEvlartkxZ9mRYppn/p042Uay Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjqe5c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 13:19:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DDHqcK090516;
        Tue, 13 Aug 2019 13:19:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ubwcwscwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 13:19:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DDJ7Oa004970;
        Tue, 13 Aug 2019 13:19:07 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 06:19:07 -0700
Date:   Tue, 13 Aug 2019 16:14:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sym53c8xx_2: remove redundant assignment to retv
Message-ID: <20190813131420.GS1974@kadam>
References: <20190809175932.10197-1-colin.king@canonical.com>
 <20190809181733.GQ5482@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809181733.GQ5482@bombadil.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130142
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 09, 2019 at 11:17:33AM -0700, Matthew Wilcox wrote:
> On Fri, Aug 09, 2019 at 06:59:32PM +0100, Colin King wrote:
> > Variable retv is initialized to a value that is never read and it
> > is re-assigned later. The initialization is redundant and can be
> > removed.
> 
> Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Seems like a bit of a pointless class of warnings, given that gcc now
> initialises all locals.  But I'm happy for James or Martin to pick it up.

GCC doesn't initialize all locals.  Just some depending on the
optimization level.  It's related to a bug that's several years old.

This warning does find some bugs.  The common one is where people forget
to check the return.

	ret = something();
	// blank line here indicates that ret is never checked again.

regards,
dan carpenter

