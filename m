Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAC3C1975A
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 23:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B549B20736
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 23:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cHNaRhbR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgCVXct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 19:32:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53818 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCVXct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 19:32:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02MNSwtH075141;
        Sun, 22 Mar 2020 23:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=pMB1aDyk5kXG+a8jFH9SFoS4IIAfMTkI07weYrFAZa8=;
 b=cHNaRhbRIftMbhZE1Zt9st+IHPSTNk+F8EsFgTvKaCqEC+NbQiCF2JXhYPMrDv271i6+
 bWHhFgk6Hn2Y6sCIUdhHZVyWtdrgUXRtYccS50VFCofYZNqWQzcjOHmpcPDbF2KBJNmL
 Rmtm39PRTU8QH3JBr2bjHGJZLo8AXHGXVUMc+kB8Hr/uNaBab7Mz7JMVQxPdnX9n2Id4
 MiiKcwZhGJJvS2kvWNRDchFAVSigRoRP9ZCny0LlNGmOCrd7sm13tA8BkSvt47yqeoNO
 qrwwPbEhFbwnBtvE63kTHezSskN/tbbLAJ1BVZJuQm7rzXGPDDHF8lrkT8DB0MI/St4p GQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ywavkuudf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 23:32:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02MNNcJV034560;
        Sun, 22 Mar 2020 23:32:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ywwuh0n2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 23:32:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02MNWjC1019086;
        Sun, 22 Mar 2020 23:32:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Mar 2020 16:32:45 -0700
To:     Bernhard Sulzer <micraft.b@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
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
Date:   Sun, 22 Mar 2020 19:32:42 -0400
In-Reply-To: <44de25f9-2d57-e90d-7773-b060ccd55358@gmail.com> (Bernhard
        Sulzer's message of "Mon, 23 Mar 2020 00:22:27 +0100")
Message-ID: <yq1v9mwq82t.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003220143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003220143
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bernhard,

Ugh, it *does* change on the fly:

> sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 512, last LBA 3a3812aae
[...]
> sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, last LBA 3a3812aae
[...]
> sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, last LBA 3a3812aae

And I am guessing your device does not trigger a Unit Attention as a
result. You don't see something like "Inquiry data has changed" or
"Capacity data has changed" in the log, do you?

-- 
Martin K. Petersen	Oracle Linux Engineering
