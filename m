Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B848C17441
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 02:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD5CB20865
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 02:32:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rj7BOvuz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfKICcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 21:32:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39170 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfKICcl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 21:32:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA92TFh2007816;
        Sat, 9 Nov 2019 02:32:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=/tGPuyNo6dTo+RosAisHYzGar5QFi1gwezlwACAMwoI=;
 b=rj7BOvuzJh8aM9hJkizd4lLKSgfy8CL2XiOXspE0zg4hx0f29+AaBIWH73PCtoeyq7TU
 x6w16Ruyq5Jfqzb7/a2Pd72q4hDDB2Wma82bGG2AbFtAVTLWCvLmBolAV4lPtv4ufX1l
 nPVSUs0hKTeU7ppsDD/Snmzpmckgjw4P4XnRZPugDt5lwngZqh5GufP5P6yal4l02NJr
 wKMrII4y7+AL2fUUZW6wguUBssOR2Oc70gkA9+GbEgsMzRtygO3Fhe/CpGxKl9CMBewx
 7pJNvacvNrknLcCcSeupjz9IiacwB5lj+umF+XGGTX4IS1NYpNcdSHVORs1N36DvEhaT Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5hgwrceb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Nov 2019 02:32:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA92TBaM157698;
        Sat, 9 Nov 2019 02:32:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w5hh4psta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Nov 2019 02:32:35 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA92WZpv026371;
        Sat, 9 Nov 2019 02:32:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 18:32:35 -0800
To:     James Smart <jsmart2021@gmail.com>
Cc:     bvanassche@acm.org, linux-scsi@vger.kernel.org,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Subject: Re: [PATCH v2] lpfc: Fix lpfc_cpumask_of_node_init()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191108225947.1395-1-jsmart2021@gmail.com>
Date:   Fri, 08 Nov 2019 21:32:32 -0500
In-Reply-To: <20191108225947.1395-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 8 Nov 2019 14:59:47 -0800")
Message-ID: <yq17e49vkxr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=893
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911090023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=970 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911090023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Fix the following kernel warning:
>
> cpumask_of_node(-1): (unsigned)node >= nr_node_ids(1)

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
