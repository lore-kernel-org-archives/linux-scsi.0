Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29345C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 03:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0CD20EDD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 03:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xao951SH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIIDCu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 23:02:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIIDCt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 23:02:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08930AEg044832;
        Wed, 9 Sep 2020 03:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8mKsHMuEGfytn0bau35zqGmaHov27J/peCowNOzRPts=;
 b=xao951SHCxAnYvxcly1owtsDPfj+7fzNQcWoe2YZoSqTKOdQt2IknEg4UJHwONVl/QiM
 8UXWI0UUWAcEks8np18UTuCzNDAEa71swYGZxB6O746jbzQ/3lPDutdMjPPEb8hIbJj0
 SO9HqvDEpGMY++C7/BorQGbS3yQtxsXUbh3570HBFffN3AdBbQIXvnQY1GC7AQYwM8ty
 930/LrgIWGmJkqnIE/kPA16GUJgYuiTYQ4Vja3i5uS/oTHu3oUfsZXBS8YEbk624npRQ
 Vel7bnzkClVN/PuJNMj7+4y7lnqZDgPsA4b+SmSJY1oOt3R+ImLDKEfHZ+DEb1ZlJJ9F rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33c3amxxgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 03:02:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08931ZmY024463;
        Wed, 9 Sep 2020 03:02:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33dacjrcsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 03:02:45 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08932iVV005057;
        Wed, 9 Sep 2020 03:02:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 20:02:44 -0700
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v1] mpt3sas: Add support for Non-secure Aero and Sea PCI
 IDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1d02v4pxt.fsf@ca-mkp.ca.oracle.com>
References: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
        <yq1a6yoviti.fsf@ca-mkp.ca.oracle.com>
        <CAK=zhgq-5CNQObiwDutLPGG3CbmpAbj+RbDGX-xGu6mVP_WZYw@mail.gmail.com>
        <yq1r1rvqxqe.fsf@ca-mkp.ca.oracle.com>
        <CAK=zhgpg754D6J6k3s+xmyxH+2MGWjuNb44Tfccq2z+gFuLPRA@mail.gmail.com>
Date:   Tue, 08 Sep 2020 23:02:42 -0400
In-Reply-To: <CAK=zhgpg754D6J6k3s+xmyxH+2MGWjuNb44Tfccq2z+gFuLPRA@mail.gmail.com>
        (Sreekanth Reddy's message of "Wed, 26 Aug 2020 21:53:19 +0530")
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Broadcom adapters participate in a Secure Boot process, where every
> piece of FW is digitally signed by Broadcom and is checked for a valid
> signature.  If any piece of our adapter FW fails this signature check,
> it is possible the FW has been tampered with and the adapter should
> not be used.  Our driver should not make any additional access to the
> =E2=80=9Cinvalid/tampered=E2=80=9D adapter because the FW is not valid (c=
ould be
> malicious FW). This type of detection is added into latest Aero and
> Sea family adapters h/w.

While I appreciate the intent, I would still like there to be an option
to permit using the adapter. I am concerned about users being unable to
boot their system due to this if, for whatever reason, these validation
checks fail. Maybe there is limited risk of that happening since this is
restricted to Aero and Sea adapters. But I am still concerned about
enforcing policy decisions like this in the kernel.

--=20
Martin K. Petersen	Oracle Linux Engineering
