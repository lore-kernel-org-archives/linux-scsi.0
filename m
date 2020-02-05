Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067AAC35247
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 02:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC5B6214AF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 02:56:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dd6cgkB0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgBEC41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 21:56:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgBEC41 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 21:56:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0152masn014904;
        Wed, 5 Feb 2020 02:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ai3uVdzyQzVrJ+SL5JpsnVZYL09CQUstBPe4KYUt56c=;
 b=Dd6cgkB0uqGH4+oUB6svYne6jwFihodZBaPfg+WUwGbgajBgRewO8/bYpTEE4iDRFg3I
 06+/xmmVqZmRoXC5SYoDDizV+NQsp8Tvms9CdWGuuIpoFyMInIlLXZE5Of+XuHV/0Cti
 8dlebvWj6juDtqiTD6Xhk9d5mi3L73hW6nvELvXi+UPIkrvvknvFY6osPcq8RcG5hfUf
 7gqjmgpPrro2ukAX0APm4vzcITtWR9oPLtDe7YzXJLrNM1XosLCXq1dVrb2f5MlCOHpu
 1rWOKz+/W+/W8CCtmlczQxa5Vo75Aq+1WCcu0JRGupmnkS8K5i9rhX3JrOPdyfaFk7L6 jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xykbp0bx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 02:56:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0152mYTt044872;
        Wed, 5 Feb 2020 02:56:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xykbqpq80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 02:56:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0152uIsF016742;
        Wed, 5 Feb 2020 02:56:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 18:56:17 -0800
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, bvanassche@acm.org
Subject: Re: [PATCH v3 0/3] scsi: add attribute to set lun queue depth on all luns on shost
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200124230115.14562-1-jsmart2021@gmail.com>
Date:   Tue, 04 Feb 2020 21:56:16 -0500
In-Reply-To: <20200124230115.14562-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 24 Jan 2020 15:01:12 -0800")
Message-ID: <yq1v9olzqr3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> There has been a desire to set the lun queue depth on all luns on an
> shost. Today that is done by an external script looping through
> discovered sdevs and set an sdev attribute. The desire is to have a
> single shost attribute that performs this work removing the
> requirement for scripting.

I'd like you to elaborate a bit on this.

 - Why is scripting or adding a udev rule inadequate?

 - Why is there a requirement to statically clamp the queue depth
   instead of letting the device manage it?

-- 
Martin K. Petersen	Oracle Linux Engineering
