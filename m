Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USB_DRIVES autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC686C433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 02:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1A4020B7C
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 02:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0dAJ1Wha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbfHHCDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 22:03:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730655AbfHHCDn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 22:03:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781wwPF075632;
        Thu, 8 Aug 2019 02:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cJtla6ameY64EYzk8Tasr7Rpfu9RKZqi7QUI2xarFGM=;
 b=0dAJ1WhaftmjrEZVxs/Qov8hiwaKLzAFQ2h+qLVsSAAuNK2CkXsVlJRKCGSdL2HX9yN1
 zL5GT0BO/DCKiXsXBkEkc9OshSs/1hLsVgtWnIq5ZGov5A5fOpra6oHSNMmH24LIQ1qw
 AvAhe2YX27Izh3l20E3kKOBr4/WTeJEnM1sBLwVNHGIwY5uby7Fs63PvgbmTKBAUMyT2
 6bkWcwxIv/cRS5jgrPwSzOVp87AqqkEIlSKKygWkMzclrogDkrxBK8nKSio8lo9J7LJf
 lwkq44JY3wTSHELK5IqNUz/YK8XeFfwWuJql4IuGV5ImU/Fo3dmD+k15Wps3JOgVhIZO fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u52wrfjen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 02:03:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7823Cjx076651;
        Thu, 8 Aug 2019 02:03:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u75bx0pab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 02:03:39 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7823cKh009180;
        Thu, 8 Aug 2019 02:03:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 19:03:37 -0700
To:     "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc:     "'LKML'" <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion (resid=78, sector_sz=512)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
Date:   Wed, 07 Aug 2019 22:03:36 -0400
In-Reply-To: <006d01d549db$54e42140$feac63c0$@lucidpixels.com> (Justin
        Piszcz's message of "Sat, 3 Aug 2019 05:10:44 -0400")
Message-ID: <yq1ftmcct1j.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=863
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=919 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20190808020336.QXCeL_4PoSN6R4GrpQiDdcb5YWpm4DS_tJLvx_evlbg@z>


Justin,

> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back and
> ran some file copy tests and was getting these warnings-- is there any way
> to avoid these warnings?=C2=A0 I did confirm with parted that the partiti=
on was
> aligned but this appears to be something related to the firmware on the
> device according to [1] and [2]?

Please send us the output of:

# sg_vpd -p bl /dev/sdN
# sg_vpd -p bdc /dev/sdN
# sg_readcap -l /dev/sdN

--=20
Martin K. Petersen	Oracle Linux Engineering
