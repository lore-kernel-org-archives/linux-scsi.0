Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D07C10DCE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 23:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DE7021927
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 23:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PAACmhBK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCJXp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 19:45:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35830 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgCJXp1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 19:45:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ANf3e5032736;
        Tue, 10 Mar 2020 23:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=d++pBOAa1FdXyAcpnc6NBDFsyfEdneSErw8Gddqne/c=;
 b=PAACmhBK2qP8iS9epvnlcwBMY9Ux2PRc9cLsuTcGeRmkSyjCshAjaof3QnpW+aiRm9K5
 NJPh4fDPhfPrBHtzi80sPUYF2IDsRQOMbQ07XfkgTYifEah30JwauA05xOPW9v2m+P2g
 6ejSe3Uanjl8Pg4CvJ0LzObCg/7tfZNsDz3kAkOeZV4MiXbtpnCTPT3CINW7L2dWtH/M
 WA7/KBSVX6oPIiDzAioANH73oxZSnn4RCpzpnE7WQ1Ob3C+ME/B31Q+LEw4Zz+cu77z3
 kHfLQArKEGVqRqoln5pgaymUTTo0rGCuJGQzJOtKkkCWaGv4f94I6W8tMLTU8/0cdYo/ HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ym31ugjcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 23:42:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ANciVM028239;
        Tue, 10 Mar 2020 23:40:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yp8puubhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 23:40:41 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02ANePNm009536;
        Tue, 10 Mar 2020 23:40:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 16:40:24 -0700
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
Date:   Tue, 10 Mar 2020 19:40:19 -0400
In-Reply-To: <cover.1583136624.git.mchehab+huawei@kernel.org> (Mauro Carvalho
        Chehab's message of "Mon, 2 Mar 2020 09:15:33 +0100")
Message-ID: <yq14kuvu6cc.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100141
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mauro,

> This patch series manually convert all SCSI documentation files to
> ReST.
>
> This is part of a bigger series that finaly finishes the migration to
> ReST.  After that, we can focus on more interesting tasks from the
> documentation PoV, like cleaning obsolete stuff and filling the gaps.

Applied to 5.7/scsi-queue.

For some reason patch 23 didn't show up in the mbox so I had a bunch of
conflicts due to the ncr53c8xx entry missing from index.rst. I thought
you had somehow lost that patch along the way and decided to proceed
regardless. However, it turns out the patch was missing due to a lore
issue. By the time I figured out what the problem was, I had made it to
the end of the series. And as a result, in my tree the ncr53c8xx patch
comes last.

Anyway. Thanks for cleaning this up!

-- 
Martin K. Petersen	Oracle Linux Engineering
