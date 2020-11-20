Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BECC5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43ADC22249
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xsGcQ3Qo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKTDY7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:24:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42360 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgKTDY7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:24:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3OUfu070114;
        Fri, 20 Nov 2020 03:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : mime-version :
 content-type; s=corp-2020-01-29;
 bh=dQWJOrnj3mw6JIRHWrcMexXtHqc0RwecP/89n5DZ8Rc=;
 b=xsGcQ3QoEizcAvLjSRd3JYQ1fwQSbvbzsAz8GdNzBXtpeglecZZrYanP1ydCWh1LsZIX
 p7ZA0xQx6YjXrPB2iDMzZ9UwrhpkqtIJDa0XBV3HqWE29m0hYF0z3Pc1G1nJGpFcMwMp
 YfrnsWLhjAhtYmGEn8DpobUyuVgX+Cd7ERYAjJqgiazVJCz8FjUIPFKTfUWpo7hJEBmo
 Y7JfJM+eAzUVmEVluW9ZHmfaLDElhrrtJ/H674P2TE+Uhob0713C7fD//dz0+OSJj4OZ
 FTA3KImRw5+WIYUncIeO5W4FXF/2k+SkoLWBxv5Ho13oKaEO8g9KK1nBehrClrrvUxJn 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rb8tkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:24:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK35ilW166518;
        Fri, 20 Nov 2020 03:22:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34uspx29v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:22:55 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3MtMr022363;
        Fri, 20 Nov 2020 03:22:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:22:54 -0800
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix variable 'vport' set but not used in
 lpfc_sli4_abts_err_handler
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20201119203407.121913-1-james.smart@broadcom.com> (James Smart's
        message of "Thu, 19 Nov 2020 12:34:07 -0800")
Organization: Oracle Corporation
Message-ID: <yq1v9e0vhja.fsf@ca-mkp.ca.oracle.com>
References: <20201119203407.121913-1-james.smart@broadcom.com>
Date:   Thu, 19 Nov 2020 22:22:53 -0500
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=854 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=866 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Remove vport variable that is assigned but not used in
> lpfc_sli4_abts_err_handler().

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
