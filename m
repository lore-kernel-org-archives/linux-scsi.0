Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05DAC33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 06:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEC712073A
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 06:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L01Yn+1n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgATGfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 01:35:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38858 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgATGfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 01:35:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00K6TErG080116;
        Mon, 20 Jan 2020 06:35:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=B9npXv5m7EYu+6b/APDFwlrTW91173+NogzOJ4xQxdQ=;
 b=L01Yn+1npPN3rV0sinC/DuFT97DCzSydGaKrr14VaM9Ccr+1aTcA/zXb0AZ17UwX3eAN
 m7uOqdojV8rZyanciGtSbUqousHfupfm1USqlyCK6Tm/jg3sTEcIWScp6xDt/k7tGbUM
 jERcboM1REyVmyMDOnR/CZiCpZHCq6J1xNWNxl1ZJ75bDaOlAnkja5hztIx7Qqkd/Zbl
 4dZDeM28GtUyQPb9InpCgkRW1NZvZbMpucJuSygK+iQMs+Pbt9mFEA4VN7S1tWOFBu2I
 5NlGz0nxq9Xlh40ufI/cRlLvvsXsns0ZKsns08jowN3RnxDZvum8E46fFcUi5ZH4m39j zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseu5ec2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 06:35:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00K6TDlP116331;
        Mon, 20 Jan 2020 06:35:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xmbg7ttkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 06:35:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00K6ZjJf028394;
        Mon, 20 Jan 2020 06:35:45 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 19 Jan 2020 22:35:44 -0800
Date:   Mon, 20 Jan 2020 09:39:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Tom Hatskevich <tom2001tom.23@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: mptfusion: Fix double fetch bug in ioctl
Message-ID: <20200120063930.GG19765@kadam>
References: <20200114123414.GA7957@kadam>
 <yq1d0bkniwv.fsf@oracle.com>
 <CA++so2v3BOih2VcQ7nDpWaLaCi+yViB9Sc=NP5zpJy5-whPT_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA++so2v3BOih2VcQ7nDpWaLaCi+yViB9Sc=NP5zpJy5-whPT_A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9505 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=803
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9505 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=865 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200056
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 19, 2020 at 12:46:32PM +0200, Tom Hatskevich wrote:
> I have a question about the bug I found:
> When this patch will committed to linux kernel mainline ?
> Could I see any pull-request ?

It's already merged into Linus's tree and he's going to release v5.5 in
a week or two.

You have Reported-by: credit.

https://github.com/torvalds/linux/commit/28d76df18f0ad5bcf5fa48510b225f0ed262a99b


regards,
dan carpenter


