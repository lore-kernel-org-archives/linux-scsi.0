Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7888BC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 00:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B791208CA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 00:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IY+PWBA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgEHA4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 20:56:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33026 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgEHA4T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 20:56:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0480tTQC090798;
        Fri, 8 May 2020 00:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=74OoXJha9YRi+Rb6Cto4iXXmlC65kQwoiw3DxdiI128=;
 b=IY+PWBA7P/G6yp4NHvH0lwvM8VPRH8AO649kHp50a2STiO6Qryo4oxDMzmIdXGzhgRmj
 NOpm315n5bdNfl8L3kbaSfH+qafmqU3JDhz7cK9UwzA6n0kLUo/6qcRaFvqX2t4UeovC
 aF14JA0BzhYbQ0gvy8oDs+0LB0GwygofEs7E6errEHWbTaS/XLRNOd1pmN55EsNTcJPA
 J6rdKMNtfRkQXSFRT54bv3VIAGhGwCdwg3LF8wdOFOzOjOg+cfOhXSaLObrudmdZNAha
 TY9ZfFUNP1R8WK/npypxPsqbp2ZJcI/q0XmZU6cMH7MHOli0miBAd+z4JFQazKUAmX7s Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30vtepgg0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 00:56:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0480rXGq030961;
        Fri, 8 May 2020 00:56:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30vtdxr72s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 00:56:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0480uDDH006838;
        Fri, 8 May 2020 00:56:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 17:56:13 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Fix compilation error on 32bits arch
Date:   Thu,  7 May 2020 20:56:12 -0400
Message-Id: <158889873927.7304.4812677615111222210.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507023526.221574-1-damien.lemoal@wdc.com>
References: <20200507023526.221574-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=984 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005080005
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 7 May 2020 11:35:26 +0900, Damien Le Moal wrote:

> Allowing a non-power-of-2 zone size forces the use of direct division
> operations of 64bits sector values to obtain a zone number or number of
> zones. Doing so without using do_div() leads to compilation errors on
> 32bits architecture.
> 
> Devices with a zone size that is not a power of 2 do not exist today so
> allowing their emulation is of limited interest, as the sd driver will
> not support them anyway. So to fix this compilation error, instead of
> using do_div() for sector values divisions, simply disallow zone size
> values that are not a power of 2 value, allowing to use bitshift for
> divisions in all cases.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Disallow zone sizes that are not powers of 2
      https://git.kernel.org/mkp/scsi/c/108e36f0d8bf

-- 
Martin K. Petersen	Oracle Linux Engineering
