Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C260FC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 15:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9575F2076F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 15:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YBI6YEtM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCXPy6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 11:54:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40566 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgCXPy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2020 11:54:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OFn5B5046342;
        Tue, 24 Mar 2020 15:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Hv+3hGC26i+fuUM8jlNABIs7Byy2Xqko8ZabWUWGDxU=;
 b=YBI6YEtMn038TELWnvzcCSe66kgJndwJ921W1sBIjMGYeR1GrcUXefCsEFaIVAtfV+Ao
 keqP4JD6rDBKeFSTvGgmntR2xgt+jzLosW+x3TybN5nGzr90AqQLkWQcmuPR5AjdIMR7
 aQuq2fTjh/+9JF4XFMmzPmc7qkAYf+KPg07qnNF3smYoYNFPsfBccLOGOekkxQvHfKVq
 RjnWQmtC3bt4+t46xTSZ3JOpd2wTyBRSRw2huK1U9J6IxMNIatHGx35WDgjJac1okfpx
 brao2QfEya5zYh4DVmxxm2jZTE1CYmbSEghQHwIaqF0Vea7oWpePSzuFNWvx5BD7mcr2 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ywavm5573-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 15:54:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OFniqk099426;
        Tue, 24 Mar 2020 15:52:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yxw6my6sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 15:52:53 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OFqqPR013392;
        Tue, 24 Mar 2020 15:52:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 08:52:51 -0700
To:     Bernhard Sulzer <micraft.b@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bryan Gurney <bgurney@redhat.com>
Subject: Re: Invalid optimal transfer size 33553920 accepted when physical_block_size 512
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
        <yq1o8sowfzn.fsf@oracle.com>
        <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
        <yq1pnd4tbxm.fsf@oracle.com>
        <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
        <yq1eetkrtf6.fsf@oracle.com>
        <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
        <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com>
        <yq14kugrou0.fsf@oracle.com>
        <44de25f9-2d57-e90d-7773-b060ccd55358@gmail.com>
        <yq1v9mwq82t.fsf@oracle.com>
        <4f6eb89d-57e4-a229-2e95-29fe4a691381@gmail.com>
Date:   Tue, 24 Mar 2020 11:52:49 -0400
In-Reply-To: <4f6eb89d-57e4-a229-2e95-29fe4a691381@gmail.com> (Bernhard
        Sulzer's message of "Mon, 23 Mar 2020 00:40:39 +0100")
Message-ID: <yq1wo79n41a.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240086
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bernhard,

>> And I am guessing your device does not trigger a Unit Attention as a
>> result. You don't see something like "Inquiry data has changed" or
>> "Capacity data has changed" in the log, do you?

I have been working on a set of patches that will address devices like
this that change their tune halfway through discovery. Your case is
really just the tip of the iceberg, more changes are needed to handle
this gracefully.

I'll try to get these changes completed in time for 5.7. However, we
need a smaller fix for 5.6 and stable. Can you please try the patch I
just sent?

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
