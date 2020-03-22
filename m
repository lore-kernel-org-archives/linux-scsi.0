Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44C8C4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 15:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8677720722
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 15:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uEAAeNc0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCVPpW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 11:45:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCVPpW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 11:45:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02MFjKvC067568;
        Sun, 22 Mar 2020 15:45:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=8KKUJ2cNS/x6N1XA/z5fJYallr9xfcAOB9iWPmsTKhc=;
 b=uEAAeNc0S+Qm8taF/i/dsvNWQNqIR+TjaTyRydPPy6Xqn9/wtcKq3S3186ZWojse65Fu
 u+zY9mBJTOmd+UJKojT6rQSbZLyCb99qfBkft4zbVY3Z90ZBbqLd3fUD9ee14/jbcwgp
 BSZIQpf2d+UKFJ/mA5WL8eiwMTjpg+UHqClb9mkjyltEwVEHODzW9FB5+6wgLdP6mAUr
 H0cqR7vMwaa0wdRA+KKp6YlpvqY/cY+tPDWxAFOdp9qB+U6DlLzoM3cSPFUH+/yqDEAF
 /2VaRvosiMrY/4MKhCYu96YmaYF4FzLyYaE4MkY+5hz3iXyfXvHXY1u2unisMs7up79V GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ywavku8f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 15:45:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02MFgupI054167;
        Sun, 22 Mar 2020 15:45:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ywvdacnj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 15:45:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02MFjIOP018184;
        Sun, 22 Mar 2020 15:45:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Mar 2020 08:45:18 -0700
To:     Bernhard Sulzer <micraft.b@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: Invalid optimal transfer size 33553920 accepted when physical_block_size 512
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
Date:   Sun, 22 Mar 2020 11:45:16 -0400
In-Reply-To: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com> (Bernhard
        Sulzer's message of "Sun, 22 Mar 2020 15:32:38 +0100")
Message-ID: <yq1o8sowfzn.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=976 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003220095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003220095
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bernhard,

> This is pretty curious in itself, because lsblk reports 4096 physical
> sector size / 512 logical sector size and I would have thought
> physical sector size and physical block size should be the same.  Is
> this a bug that should be reported?

That's peculiar. What does:

# dmesg | grep Optimal

have to say?

Also, please send the output of:

# sg_readcap -l /dev/sdc
# sg_vpd -p bl /dev/sdc

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
