Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C994C10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 17:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C784222C4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 17:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S1B4FJXQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgCJRyG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 13:54:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42970 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgCJRyG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 13:54:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02AHgWnk177439;
        Tue, 10 Mar 2020 17:51:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=nhOIAxPWBW/vFald2XMRhINHxcne+kQkEpN70xmoA78=;
 b=S1B4FJXQBE4f0RtPDOLlmdFgewG/zzZPZPuW8UYnHQAaOg+rL5lLjj8YuKjN5eKCDZie
 JLm4fFwJDoina7GuRyg48Hixut+yRGsOgmaT6YZBq+omzdg1N634ngiJYgYpqjajNMwx
 +PxsSQNEhtLxAK3NM1CXPSC5vL3B7iIBqDQQ4PbxoEABWOAM/j/7drS1gZ1RPEbp3Am0
 8bIn8uDE3aSaFgemFUJx95BeP/UXkFO7Sr2c6szGpJ343rFl2Jct/c0WrhZmrc0wl95C
 JBTb9XiOH9K4qbAlkWt6NK3DV9pA8OdETkkAYWXbaQrDiOE6mMy6xNdJ6bkm9gZsEkSp 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yp9v626mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 17:51:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02AHhHZw122274;
        Tue, 10 Mar 2020 17:51:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yp8qphhv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 17:51:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02AHon6j002138;
        Tue, 10 Mar 2020 17:50:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 10:50:49 -0700
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Matthew Wilcox <willy@infradead.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kai =?utf-8?Q?M?= =?utf-8?Q?=C3=A4kisara?= 
        <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        megaraidlinux.pdl@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        esc.storagedev@microsemi.com, Doug Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Hannes Reinecke <hare@suse.com>, dc395x@twibble.org,
        Oliver Neukum <oliver@neukum.org>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Khalid Aziz <khalid@gonehiking.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Ali Akcaagac <aliakc@web.de>,
        Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Avri Altman <avri.altman@wdc.com>,
        GOTO Masanori <gotom@debian.or.jp>
Subject: Re: [PATCH 00/42] Manually convert SCSI documentation to ReST format
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
        <20200310114328.6354cffb@lwn.net>
Date:   Tue, 10 Mar 2020 13:50:44 -0400
In-Reply-To: <20200310114328.6354cffb@lwn.net> (Jonathan Corbet's message of
        "Tue, 10 Mar 2020 11:43:28 -0600")
Message-ID: <yq1zhco14ln.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100107
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jon,

> Any thoughts from the SCSI maintainers on this series?  Assuming
> you're favorable, would you like to carry it or should I?

I'm fine with this series and was going to queue it up. Unless you guys
prefer to take it through docs?

-- 
Martin K. Petersen	Oracle Linux Engineering
