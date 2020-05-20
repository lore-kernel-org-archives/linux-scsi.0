Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0940CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 16:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C450A20709
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 16:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZfpUDZ79"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgETQnq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 12:43:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41360 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgETQnq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 12:43:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KGVPiQ026256;
        Wed, 20 May 2020 16:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=a5JjpI/96+5lbLICn+MJp90OjCyeNp0Emsljsrt4/9s=;
 b=ZfpUDZ79Dj+C6+ST09FIN/tioh4ta+BgjJ3j+H4Ekz+3/L+YLVPjyiFDPO6NSTMzf4pC
 R+2y7KPtWFIYQAWdSy0phZPa765urTjdwRZVf8pkm22/guvXLJ39yZoRJq/EIXtHKM2D
 8tUIt2NbLpxwygNGygWSYQOT2nDgnHjEgZoc2Q/MvsJ6bQNgE2Cgl881Dby5reNo/as4
 XQ6cCbIvOzLMjRZXaen8qOUt8WEHHl64gHcvXqXLef/dpFuefw7Yf/MmRqnaqmtuXrGF
 DO2wfZdsNgllZKWefhvifiW89zVGnHdDTAvdvCwzm+L7uzDivm4SJU1hz5oTCVN1EiHi bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31501raqsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 16:43:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KGYST7094575;
        Wed, 20 May 2020 16:41:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm7cedh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 16:41:36 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KGfY88009732;
        Wed, 20 May 2020 16:41:34 GMT
Received: from [192.168.1.35] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 09:41:34 -0700
Subject: Re: [PATCH] qla2xxx: Remove return value from qla_nvme_ls()
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200520130819.90625-1-dwagner@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <93e0ca46-06ea-6e89-5078-5f78f02db653@oracle.com>
Date:   Wed, 20 May 2020 11:41:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520130819.90625-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200135
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Daniel,

On 5/20/20 8:08 AM, Daniel Wagner wrote:
> The function always returns QLA_SUCCESS and the caller
> qla2x00_start_sp() doesn't even evalute the return value. So there is
> no point in returning a status.
> 
> Signed-off-by: Daniel Wagner<dwagner@suse.de>
> ---

Good Catch.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                     Oracle Linux Engineering
