Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D15C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 00:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E33DC2074D
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 00:52:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TKq+ndyM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgC0AwC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 20:52:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbgC0AwC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 20:52:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R0oSj4057789;
        Fri, 27 Mar 2020 00:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=l1vFOPNbArzslp1vg7kCFr/e2tNmGWCR3hpU/0TDbX8=;
 b=TKq+ndyMBkZG9Vv25s5vLUy5m5KcADWaR78F4C3If7SwEjhA55MgCq/Wonm0ijS2l5xJ
 Rf/61AXZj0UtiglSLT1+7lS3tYNfGzsMZ2/m1ERSm9ozFpg40IBAyEXRQ6Oet4ybCJrb
 NjU8MDHi1xjX+L1ertcO5Yf7On0wYAHR4A+KkDMeYEJTUJnK//wuSTi9iM6GxDoiUjEh
 kVlvPzOpPxVsbtSLb73d3qb77DTtegUlO5vS3shdo/wPf5vt65pufgLdqu8tojUtXpHt
 kP/UHEZ/vsbVdenUGxgGISLdVIfp/aG7GP94pjnaQdJOccPw3HiYpHpjLs2tfRoKoEUT YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ywavmjsdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 00:51:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R0pw1D143717;
        Fri, 27 Mar 2020 00:51:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3003gmwb12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 00:51:58 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R0pvS3008364;
        Fri, 27 Mar 2020 00:51:57 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 17:51:57 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: Make MODE SENSE DBD a boolean
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <116e8e24-d442-6239-b401-dd3145f4e8e8@acm.org>
        <20200325222416.5094-1-martin.petersen@oracle.com>
        <257ddb5a-87f3-9e27-8f9a-d647483528ab@interlog.com>
Date:   Thu, 26 Mar 2020 20:51:55 -0400
In-Reply-To: <257ddb5a-87f3-9e27-8f9a-d647483528ab@interlog.com> (Douglas
        Gilbert's message of "Wed, 25 Mar 2020 21:44:00 -0400")
Message-ID: <yq1y2rmfwlw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270005
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> I think scsi_mode_sense() needs looking at. It says this in its header:
>
> *      @dbd:   set if mode sense will allow block descriptors to be returned

Yeah, that's also broken.

> which is a worry when you consider that DBD bit means "DISABLE block
> descriptors" [spc6r01.pdf chapter 6.14.1]. If the caller wants block
> descriptors (i.e. dbd=0 (or false)) then they really should set the
> LLBA bit or they will be truncating any LBAs (in the returned block
> descriptors) greater than 2**32-1 to the lower 32 bits. However only
> the MODE SENSE(10) command has the LLBA bit. So if MODE SENSE(10)
> fails and you leave the LLBA bit set and switch to MODE SENSE(6) then
> the device server is within its rights to say: WTF is bit 4 in
> byte 1 set? Hence ==> illegal request.

I agree. I simply zapped it because none of the callers of
scsi_mode_sense() actually set LLBAA, nor did any of them care about the
block descriptors.

I think it's mostly a historical artifact that some callers request the
descriptors. But the concern is obviously what blows up if we suddenly
start setting DBD flag while querying the Caching Mode Page on the usual
suspects in the USB department.

> That function is just badly designed and does not allow for subpages.
> Can it be thrown out?

Given the very limited use inside the kernel it didn't seem worth the
hassle/risk to make it a full fledged MODE SENSE implementation. But I
am happy to entertain cleanups in this department. I was really just
trying to silence a warning.

-- 
Martin K. Petersen	Oracle Linux Engineering
