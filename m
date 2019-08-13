Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C09C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10395206C1
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:58:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PQsQDzHj";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rak3Swn5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfHMB6z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:58:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47206 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHMB6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 21:58:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1waQJ025607;
        Tue, 13 Aug 2019 01:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ITMIjDVLpzTQCfGpvQLSc02vOee/pkcmzHm9KD5wTqE=;
 b=PQsQDzHjR2xEFcqrD63iqGn7ZYLgIq7EscGNgOtbuUfp1I+ThBLmTcDESb1GFBpdz4LV
 uUpJF4WLA9a+A9sPo//PyYJYhJiguAkdk/nAwcEJE55dEcofB/W579cup54fhbTeGmk2
 DHFWenEg6p62HB/UcCAPJ5q8bHPlw2r/Q8p3fy/a5BSxkxEUI95WW7a/S9Z/YXYAuK/I
 uiESxPNJOElsjdPppSaGuj17FmV4EyGFgjOiYKd2RGhmWCktILQjM/tgmg8NUx5J4Q7G
 rxZy1Ob5pDmi0M/ud2QQ8pTE9vDpXy2Im7oKYcGs8E6ffZ9NR59F50EhbIBUeICAS88E FQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=ITMIjDVLpzTQCfGpvQLSc02vOee/pkcmzHm9KD5wTqE=;
 b=Rak3Swn5tAk4XJ1HFUEgV6mSI385EnHLCIrVhp7pZ7QIG3vcyneW19l5FY8ZCRJMKGLl
 etqt07Ba5tdDNLKCQV3Pj4w9nCfRS1zE8WaVaG/1FkHbgM9YH23Nj7g/BTnu0Hj45VDH
 OJnvWu+9J3/9n/pvoOCUN/jNXSG/dzgOZ7bt2cL+SWaOW0sl+ClExjYdmX3h90GPdI9P
 doEO/oykWP/1yN/RDPzlVljrMLNG0/yHvuX2Xwqwd3d33yiWIzM4JZ2DQs0ByOELKkW0
 okFIbPkTOqIUtGa5U1NqY1RirJoCqGLFUnnKJUMDpzY7pxkAsOYYlA2fpbSdigxiDgUE OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqayrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:58:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1w0pw174503;
        Tue, 13 Aug 2019 01:58:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2u9m0asmx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:58:37 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D1wZRG025178;
        Tue, 13 Aug 2019 01:58:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 18:58:35 -0700
To:     Colin King <colin.king@canonical.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sym53c8xx_2: remove redundant assignment to retv
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190809175932.10197-1-colin.king@canonical.com>
Date:   Mon, 12 Aug 2019 21:58:33 -0400
In-Reply-To: <20190809175932.10197-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 9 Aug 2019 18:59:32 +0100")
Message-ID: <yq14l2l967q.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=919
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=986 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> Variable retv is initialized to a value that is never read and it is
> re-assigned later. The initialization is redundant and can be removed.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
