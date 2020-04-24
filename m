Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B26C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 18:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73269206B9
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 18:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s/7+yQ5z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgDXSMt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 14:12:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgDXSMs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 14:12:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OIBebr034793;
        Fri, 24 Apr 2020 18:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=YurED5CLE8U4DdthzJ/n7wN31Ht3UIS1SOvpP5CpPWw=;
 b=s/7+yQ5zT1mDe2mX3l3U201Ih//cYA5JIBltsDvTX0oY4Ri+MGm1u3umQO6CzdijZU83
 QzHrP9pBfIksnv/2EGqHVVJHfgTnQ9gL6eJ18H5s81eubJWBpVNHSt9joyEuJ1yjRh2p
 oqcu4dpkSkDTgvg+z9rW06207pAukZv4890zTlcf26+ZmQZeQ8EKPutnfwHPurtr4pyS
 RzlPnkukMmFx/5wiTlhIosDkuZxFdoAHqdyj9ZLatBV1eC7wVzC/eZGySvsZllfXM9iv
 fgZwc3JClwNkTtL8ztKL989LsBMWBAB15fkG2dwqX8xhbZ6JrjnfjEwegaDkzCtpFbmS NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30jvq52hs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 18:12:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OIBcrj172149;
        Fri, 24 Apr 2020 18:12:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30k7qxm67d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 18:12:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03OICUJ9024766;
        Fri, 24 Apr 2020 18:12:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 11:12:30 -0700
To:     Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Dexuan Cui <decui@microsoft.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2] scsi: avoid to run synchronize_rcu for each device in scsi_host_block
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200423020713.332743-1-ming.lei@redhat.com>
Date:   Fri, 24 Apr 2020 14:12:27 -0400
In-Reply-To: <20200423020713.332743-1-ming.lei@redhat.com> (Ming Lei's message
        of "Thu, 23 Apr 2020 10:07:13 +0800")
Message-ID: <yq1r1wcda7o.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240139
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> scsi_host_block() calls scsi_internal_device_block() for each
> scsi_device, and scsi_internal_device_block() calls
> blk_mq_quiesce_queue() for each LUN. However synchronize_rcu is
> run from blk_mq_quiesce_queue().

Applied to 5.8/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
