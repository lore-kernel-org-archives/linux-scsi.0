Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35F6CA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 04:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94ECE2053B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 04:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="itnt4B3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbfKEEy2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 23:54:28 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52440 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387408AbfKEEy2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 23:54:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA54sOms073390;
        Tue, 5 Nov 2019 04:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=1+swH+vEjVdEsw0ewYvI4CX5cXPJEsFW2ToN4E+I7rw=;
 b=itnt4B3FSkWbKFAT+hx4Z0iV95b3fnwf8qYhYBk1N2bB6rpdLyV5JsGiI23tXW0IESYO
 3FXc23sFvmNTh9Qv+hgBNAhGpKiM9r9dLGT1Az5vO3TCNrAaAZoQ23Lfh5Z+4qmVIk4i
 gOPF5jmRmHbbGos4QwznWPtCXzei2ebsL8fOTFcmflkDtghEpHtyDDTR+oe7jcLsKMqU
 MwKqrwOcoQ4XVg30AqUQIh2xq+3uRGGRBpCbE6TGm8rMlM9o4wrLPJfrn38hDH0lKq9+
 cC/8EFtGZ9WnrLH2vaI4xZp1acwQ/X8t7pOruFiu6jfXESUCPGrEXsEHyAbXClLU5w/o Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12er3cv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 04:54:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA54rmB9159723;
        Tue, 5 Nov 2019 04:54:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w3160jx9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 04:54:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA54sM3J007738;
        Tue, 5 Nov 2019 04:54:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 20:54:22 -0800
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHES] drivers/scsi/sg.c uaccess cleanups/fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <CAHk-=wgOWxqwqCFuP_Bw=Hxxf9njeHJs0OLNGNc63peNd=kRqw@mail.gmail.com>
        <20191010195504.GI26530@ZenIV.linux.org.uk>
        <CAHk-=wgWRQo0m7TUCK4T_J-3Vqte+p-FWzvT3CB1jJHgX-KctA@mail.gmail.com>
        <20191011001104.GJ26530@ZenIV.linux.org.uk>
        <CAHk-=wgg3jzkk-jObm1FLVYGS8JCTiKppEnA00_QX7Wsm5ieLQ@mail.gmail.com>
        <20191013181333.GK26530@ZenIV.linux.org.uk>
        <CAHk-=wgrWGyACBM8N8KP7Pu_2VopuzM4A12yQz6Eo=X2Jpwzcw@mail.gmail.com>
        <20191013191050.GL26530@ZenIV.linux.org.uk>
        <CAHk-=wjJNE9hOKuatqh6SFf4nd65LG4ZR3gQSgg+rjSpVxe89w@mail.gmail.com>
        <20191016202540.GQ26530@ZenIV.linux.org.uk>
        <20191017193659.GA18702@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 23:54:20 -0500
In-Reply-To: <20191017193659.GA18702@ZenIV.linux.org.uk> (Al Viro's message of
        "Thu, 17 Oct 2019 20:36:59 +0100")
Message-ID: <yq1muda53er.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=503
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=584 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050038
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Al!

> I've got a series that presumably fixes and cleans the things up
> in that area; it didn't get any serious testing (the kernel builds
> and boots, smartctl works as well as it used to, but that's not
> worth much - all it says is that SG_IO doesn't fail terribly;
> I don't have any test setup for really working with /dev/sg*).

I tested this last week without noticing any problems.

What's your plan for this series? Want me to queue it up for 5.5?

-- 
Martin K. Petersen	Oracle Linux Engineering
