Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USB_DRIVES autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B10FC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 02:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C44F20665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 02:12:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UfXc3FW2";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gfPesdM8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfHMCMt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 22:12:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34536 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHMCMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 22:12:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D29Ud2034089;
        Tue, 13 Aug 2019 02:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ep/5s03WYKZmNZQZLZc9SLB3YvDlCS12ax1hJySZBAw=;
 b=UfXc3FW2kQ5xAzsVHGWqtYIoWab9W5OvMHXNTBqB4r5MF9ESY3nEsktzGGc/XAM0W1Ya
 Uq8uudTcPKXz3Oswc3JT4YUXvdZAiWsMEtz+UhOtJaXplowaMksxPTcLJ6p5/J3k5Wq7
 6O+TlEwbdec0XOTXHl1wk11DRpTQIFXpWZsuQi/rEjQBuS5QmHVgvzE9wpA68K3m4JPl
 KNsJBa+6s0FkIRWCoGvn8pjDLdVKHiCm3zYZ4n9W1Bh5wYK+8yc2Tm8KmfwrNQzVDDYa
 cnc80XfjqnZF2HKRHx0E0NtxKKlstJ13rPNlvTI+rpYAVrGgPEIyJ5dzAY4B3HJl9ztz qg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=ep/5s03WYKZmNZQZLZc9SLB3YvDlCS12ax1hJySZBAw=;
 b=gfPesdM80xaZA1f9yjM96QAscRnGAxDdQZ2vgktBVu3M8vjWsJDaS/qe8Fk0NPWP7AAU
 NzWHRrt1IZorXl53N9V52j0u8411SR9NDRlZ/3Rnz9O/kxXM6vT3jUgdz/EaQlKukmPA
 aofegeHA/Hyy4c0PMe59DynjhNy11v3Oc3oTO7hRgHMBslVCxej+Cpu0dAFl5cXATq01
 A1JMubjAzbybkPFUni52vKXUDXyvVY+MaUG4NRZ1kfSdCowS7tIkzYxXALuATuuraOQj
 uvWtScYC3jmc7wp+KtvC7KlTHMvquTDN7lCOApIsApU1JYwpvObtgLrAYoyNkMid/rro bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqb17j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 02:12:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D28nvC131833;
        Tue, 13 Aug 2019 02:12:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9hk4hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 02:12:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7D2CiSw019898;
        Tue, 13 Aug 2019 02:12:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 19:12:44 -0700
To:     "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc:     "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion (resid=78, sector_sz=512)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
        <yq1ftmcct1j.fsf@oracle.com>
        <002d01d54dc3$17c278c0$47476a40$@lucidpixels.com>
Date:   Mon, 12 Aug 2019 22:12:42 -0400
In-Reply-To: <002d01d54dc3$17c278c0$47476a40$@lucidpixels.com> (Justin
        Piszcz's message of "Thu, 8 Aug 2019 04:27:18 -0400")
Message-ID: <yq1r25p7qzp.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=942
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=992 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130021
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

>> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back
>> and ran some file copy tests and was getting these warnings-- is
>> there any way to avoid these warnings?  I did confirm with parted
>> that the partition was aligned but this appears to be something
>> related to the firmware on the device according to [1] and [2]?

> sg_vpd_bdc.txt
> Block device characteristics VPD page (SBC):
>   Nominal rotation rate: 5400 rpm
>   Product type: Not specified
>   WABEREQ=0
>   WACEREQ=0
>   Nominal form factor: 3.5 inch
>   ZONED=0

Damien: What can we do to limit the messages in cases like this? Would
it make sense to make the residual warning conditional on sd_is_zoned()?

-- 
Martin K. Petersen	Oracle Linux Engineering
