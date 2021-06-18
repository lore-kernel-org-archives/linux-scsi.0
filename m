Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F686C49361
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 09:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1C861175
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 09:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFRJSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 05:18:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21996 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229819AbhFRJSi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 05:18:38 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I9AplU000520;
        Fri, 18 Jun 2021 09:16:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=K8avlVPq0hxl05kCY5IGzkfDWTZ/UD/8Tq9tAa/KM74=;
 b=sAFIs++BOVgrp2HHkN9jxLLFG/AzU8rf0B4S3PVSWQ53rk5W/tPSMFbKX97B6/OFC7yt
 nWK+zngjbR/vZSa81iNf+tDMcFxRRrdun2OB1h8b64VgnorVopDPJiAsLKVmlZbus08N
 n8P6pU/TD1M4L+vGXjthQ0FLU0uZR+DwdQ+9JBPnkDzkVbp+YZlxgzq1nto2+p3KB1ss
 ElpTD6mc8Ed5aie5Ly8cKw/f87ISsjJh8EQwKsRYf/15qHCbRrGwk9pZZfvMZL38OML5
 z8JX1qI/3buZySO9QSP3+T6b2n2Nrh+Fo/2Tqk5zw+x8OX1GEbJ3fBVANNLMe5swHu8o CQ== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 397mptkm38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 09:16:29 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15I9GSjC179089;
        Fri, 18 Jun 2021 09:16:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 396waynqww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 09:16:28 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15I9GRmh179074;
        Fri, 18 Jun 2021 09:16:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 396waynqwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 09:16:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15I9GQMK003282;
        Fri, 18 Jun 2021 09:16:26 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jun 2021 09:16:26 +0000
Date:   Fri, 18 Jun 2021 12:16:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: elx: efct: Driver initialization routines
Message-ID: <YMxkZB0OCqDwAUWR@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: xDWpWrdeFX-GQSxX_oKUFkAltEAN_AV-
X-Proofpoint-ORIG-GUID: xDWpWrdeFX-GQSxX_oKUFkAltEAN_AV-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 4df84e846624: "scsi: elx: efct: Driver initialization
routines" from Jun 1, 2021, leads to the following static checker
warning:

	drivers/scsi/elx/efct/efct_hw.c:348 efct_hw_iotype_is_originator()
	warn: signedness bug returning '(-5)'

drivers/scsi/elx/efct/efct_hw.c
   341  static u8 efct_hw_iotype_is_originator(u16 io_type)
               ^^

   342  {
   343          switch (io_type) {
   344          case EFCT_HW_FC_CT:
   345          case EFCT_HW_ELS_REQ:
   346                  return 0;
   347          default:
   348                  return -EIO;
                        ^^^^^^^^^^^^
   349          }
   350  }

Looking at the comments at the call site and the name of this function,
I wonder if it's supposed to be a boolean function which returns true
if it's the originator.

regards,
dan carpenter
