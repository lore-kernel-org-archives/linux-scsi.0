Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EADC31E40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A4AC20679
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kUHYayAg";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VjC4vIhA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfHMB5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:57:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36584 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHMB5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 21:57:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1rf0r009204;
        Tue, 13 Aug 2019 01:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=6JS/Ruy8i1YKO9bWmxOKhb5y+/jkyvZ6KokgXOpJ2YU=;
 b=kUHYayAg9bmM0iJuLtMDP+ajfmS1RmtqVEo1VpZQCZ8l7doKaDHusQ0u9N6AjbYL9SqD
 j2w52M7uK7/e7dfb51ItN2zdV+pTXY4rIXWfGf91Ab7YBz2uH70z4xVRSIlotorajRsj
 3zx9/z+sC/INF8TtXSpdG8BmzcDHaJPmnyn+RsK1+px5ExtFudGUjd7vw5HGYN7Qi4nj
 pZWiCZj2NmliY1HGRO2ygcPXOQQ3ZN0Uu20jN5nsnAMO2ax1ty+POgCZKypFeOvMsyuK
 rbwpvBNtxZHrmKfRbC9aol0h2Uh7DAO1NOWOvzt0aZ5h4PCiUXmwPUA0FpU4XVOqH50g iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=6JS/Ruy8i1YKO9bWmxOKhb5y+/jkyvZ6KokgXOpJ2YU=;
 b=VjC4vIhAt8ZRCSydDWUj7jdQ3FIpoLiYY+EWgABcgryCJHpBtnFRZdr4Q5I30Ir7c8X5
 byY2OC4opGvpn4YDF2RzhkKCWskZe5NAz00+MXQPRNdA4+s+zgy/VK2A7rEd9AfZKB0K
 Qs15ERkHqfTCXg/ZVlVNZIWZa600sct92aHJIDLtHCo+ilZdc3BV5R50hl8PDRVGfUtT
 2pH2EV93JlDai35Ls0Qk5bG8sgyrm9c9izzBEGqaoMGXp41hqADbAP0o5+ldMAJsCtDq
 +lbq+2IXiGoMmx6KgqzQSUdqeOIcn9GI6kMqznsudGVGjW8d3I1gCuNqOWFkrX9Arb6H Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtb38q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:57:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1rxas085608;
        Tue, 13 Aug 2019 01:57:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u9k1vwcgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:57:32 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D1vTlH024766;
        Tue, 13 Aug 2019 01:57:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 18:57:29 -0700
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: pmcraid: Fix a typo - pcmraid --> pmcraid
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190809150214.24454-1-christophe.jaillet@wanadoo.fr>
Date:   Mon, 12 Aug 2019 21:57:27 -0400
In-Reply-To: <20190809150214.24454-1-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Fri, 9 Aug 2019 17:02:14 +0200")
Message-ID: <yq18srx969k.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=854
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=907 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christophe,

> This should be 'pmcraid', not 'pcmraid'

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
