Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084F5C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 05:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB81B217D7
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 05:08:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LQd89Jv8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbfKFFIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 00:08:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47218 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfKFFIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 00:08:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA654PAf093265;
        Wed, 6 Nov 2019 05:07:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=7Zfy4mxrk93C2Ctei3E1hh+7VOGpiHjp48smjxQ0tWU=;
 b=LQd89Jv87GrM9XzeuHXQrNZlpLMIaOsMfR7NdhqOcCJnGm50RmVNI4Dg8+kilc32N/wX
 4Qol/8HorrscKSZaXhqzv0fZ9lwC/zGUC9Y25l6AELa67gUsU1SnDnLN6yJg9DTkTGLI
 pbKJ3GnyP92ieN0rUAA7vfu/roCBAiirSgSPEhn9ZDrB3btANrrW6rY+vRrPivceuq6v
 gHCQ7vzEJ6UD8rne8xhLWeTphxkfBkb5KbxSPVclFRDfXmwk3aMoL8103MfgtDQmj6lA
 uwwEqdQqDRVbY/e+M1HFHCGtt9EA+Xjn6xhJKltEal+BMYzkebgLkoQ3vpUYybS9HQ1l Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12erb1cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:07:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA654Gsf019356;
        Wed, 6 Nov 2019 05:07:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w3162ppwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:07:35 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA657Xsa021176;
        Wed, 6 Nov 2019 05:07:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 21:07:33 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6) and WRITE(6)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191105215553.185018-1-bvanassche@acm.org>
Date:   Wed, 06 Nov 2019 00:07:30 -0500
In-Reply-To: <20191105215553.185018-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 5 Nov 2019 13:55:53 -0800")
Message-ID: <yq1tv7h1tkd.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=841
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=941 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060053
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> According to SBC-2 a TRANSFER LENGTH field of zero means that 256
> logical blocks must be transferred. Make the SCSI tracing code follow
> SBC-2.

Thanks, Bart! Applied to 5.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
