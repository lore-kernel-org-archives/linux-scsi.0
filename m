Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EEFC32792
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABC162087F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r74kGM8n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbfJADF0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:05:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731164AbfJADF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:05:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9133ll6129155;
        Tue, 1 Oct 2019 03:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=eITAOOwKjJja+W4v1U/cL6ydjEO1kNXle3KHTuD3GhM=;
 b=r74kGM8nR2RfFdonZGO8j8KCmAGH0BB5M13H6FMIqPJH6mf+JVHtk0x90qpCUyDc3sud
 hwpp+rvBTMwM5FM8X8thzEUsc/NY+3JXxqa690Kfbj6PsAr4GloqS1VoNYND4VPDJ+Mu
 HQBu8MxI1i3eoUyVQmk0d5H5z3/vQ+o03+rhNA/tqgrif4tUA8eHrSFoSHUz9pGFeDJf
 zuFaXGOuKp3q4BKkqe9lobhy3Sk7T6mUWqIiXBMwqMyclDgfWwCjRPdoYHf14pexSvPj
 wD4ZvrYWSWe9VaCuWdp4ZOW7w5g5Lq/wuu+vqTga3yDvJO8YDyWLIxKskRpiCvxFyUXm Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v9xxujwtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:05:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9133d7q046677;
        Tue, 1 Oct 2019 03:05:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vbsm13wkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:05:19 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9135IWq006943;
        Tue, 1 Oct 2019 03:05:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:05:18 -0700
To:     Daniel Wagner <dwagner@suse.de>
Cc:     QLogic-Storage-Upstream@cavium.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: qedf: Add port_id getter
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
        <20190924072906.23737-1-dwagner@suse.de>
Date:   Mon, 30 Sep 2019 23:05:16 -0400
In-Reply-To: <20190924072906.23737-1-dwagner@suse.de> (Daniel Wagner's message
        of "Tue, 24 Sep 2019 09:29:06 +0200")
Message-ID: <yq1k19pxj0z.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> Add qedf_get_host_port_id() to the transport template.
>
> The fc_transport_template initializes the port_id member to the
> default value of -1. The new getter ensures that the sysfs entry shows
> the current value and not the default one, e.g by using 'lsscsi -H -t'

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
