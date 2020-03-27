Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEF3C2D0EE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 01:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 054A22070A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 01:59:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XkP++K7g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgC0B5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 21:57:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50848 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgC0B5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 21:57:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R1t9em192144;
        Fri, 27 Mar 2020 01:56:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=j2J8xWtW8DF5g4+kRsmkdpfKWba5AvOkJ/ZdpShAo2c=;
 b=XkP++K7g3K/j5g+DX5D1VdUGhPwVyvfGcLKw/m5P7ONcLl90XcSB9vm6oqpWhjo8WN+v
 amaRpRJUGTaEZtt76sv15pfH6wDdVFodUChvJq8dgqUFPdWFBFLrjgmm07m4Dhsf10zo
 vf3OM6VKjtY1C5XdBxC345sUQDnw4j/U8fl6Lmw7CgnjkZ19s8LNnDFw07d99MDPHIQT
 pmxAsgAdPXtWCD8p9cEZ5LPxAuZ6X0IVQnqJ7JtDf3Eo0/DlNYC3WudWtZlucKblQrPw
 cZ/ARk4VCjj+T6VKuNQ+STR5L6JvuzJUSL/KTclNttZ5DeEJb1Aj6/e7zLrGqCh1DdL9 SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 300urk3mms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 01:56:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R1r40A035015;
        Fri, 27 Mar 2020 01:56:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yxw4usgdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 01:56:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R1ul7V010305;
        Fri, 27 Mar 2020 01:56:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 18:56:47 -0700
To:     Viacheslav Dubeyko <slava@dubeyko.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, v.dubeiko@yadro.com, rostedt@goodmis.org,
        mingo@redhat.com, r.bolshakov@yadro.com, k.shelekhin@yadro.com
Subject: Re: [PATCH] scsi: target: core: add task tag to trace events
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
Date:   Thu, 26 Mar 2020 21:56:44 -0400
In-Reply-To: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
        (Viacheslav Dubeyko's message of "Mon, 16 Mar 2020 16:07:17 +0300")
Message-ID: <yq17dz6ftlv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 clxscore=1011 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Viacheslav,

> However, it's still hard to identify command on the initiator and
> command on the target in the real life output of system log.  For that
> purpose SCSI provides a command identifier or task tag (term used in
> previous standards). This patch adds tag ID in the system log's
> output:

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
