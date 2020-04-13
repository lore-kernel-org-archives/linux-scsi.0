Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242CFC2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 22:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE2332072A
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 22:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ng2utCRx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389726AbgDMWr6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 18:47:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48796 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389723AbgDMWrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 18:47:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMm3ei021420;
        Mon, 13 Apr 2020 22:48:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=4q0GRATtG4CE8PB+NwKzL361UFO5K3PXtj41EFRm+eE=;
 b=ng2utCRxQlV7wlCxnyZkOV5MnXzpfVxEClIejW1EbcXWkfeehuFpDmKGcSgMNs7monh6
 lQ32QaqFdNtpSnKOwh6XnfbkQ4hLGXSwfFTf9vh6skLzEYvEkSuhpMz9HXgtGl3LzE78
 W7aDny0IqJ/XlPt1B3wojoyfVvCc8pY1VyWa8ZH5ySDHM0/7XmmVctyvD2fwOhAGbCTa
 rkF0ZQB7QNS/f0srdZJx3KVV1YPUm8a10lWCXpX/sspVdR5v3UykSnXtqXgXhXON3B2l
 oZ9xue8dzzGEUFI0LfZFal6COVECQro7Gt6d+BfNHjxuQeljaWQpa+1SOAyXBBdxFKrm qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30b5um194p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:48:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMftKd080900;
        Mon, 13 Apr 2020 22:48:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30bqpdqdej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:48:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03DMm45x016876;
        Mon, 13 Apr 2020 22:48:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 15:48:04 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v4 03/14] scsi_debug: implement verify(10), add verify(16)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
        <20200225062351.21267-4-dgilbert@interlog.com>
Date:   Mon, 13 Apr 2020 18:48:02 -0400
In-Reply-To: <20200225062351.21267-4-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Tue, 25 Feb 2020 01:23:40 -0500")
Message-ID: <yq1mu7fvw7x.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=940 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> With the addition of the doublestore option, the ability to check
> whether the two different ramdisk images are the same or not becomes
> useful. Prior to this patch VERIFY(10) always returned true (i.e. the
> SCSI GOOD status) without checking. This option adds support for
> BYTCHK equal to 1 and 3 . If the comparison fails then a sense key of
> MISCOMPARE is returned as per the T10 standards. Add support for the
> VERIFY(16).

This looks OK in general. There are many cans of worms in the PI and LBP
department wrt. verify operations but we can deal with those later.

-- 
Martin K. Petersen	Oracle Linux Engineering
