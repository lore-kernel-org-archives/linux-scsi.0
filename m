Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BB8C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 23:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B2BE206A2
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 23:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O3ex9/rL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgFBXrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:47:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38986 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgFBXrc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 19:47:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Nc5ce131985;
        Tue, 2 Jun 2020 23:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=i+1pdL3kpLv0aLocWGKPf1X0QbvLqHqWcMXdYEc5GyE=;
 b=O3ex9/rLyh7o2ZMbOmYBVjM4DYExHAISn4d666609SgvXQ9KFgrF3v//2RyC5oKNUgl2
 lkGk1NkGWNJNNkPiRtEQQn85IkT4SUPxcPWYobiwYAy7sArLGvrXoTXZ50iicLcl5TCn
 AE7hSQxNvDRnR3I/PTFQqr5AIh4u5omX3igoSDfdYHD+mIej61iOkCmXNoLDanYaJlPQ
 0yaykug439etLeJUW5+AChCfmiZoFbThtadQ2TZV3UXdNuM7KVOCgYdYdBHzJQZsdurq
 dggoOIWN+XWanJw43XR0HWEKCqOyeucSlzb90Iz4/5Uu7z0Hsg59gNrwbkPQX0rV4UvO IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31dkrukjhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 23:47:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052NhGj3171265;
        Tue, 2 Jun 2020 23:47:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dy2msd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 23:47:30 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052NlTZT023671;
        Tue, 2 Jun 2020 23:47:29 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 16:47:29 -0700
Subject: Re: [PATCH v3 2/3] target: fix NULL pointer dereference
From:   Mike Christie <michael.christie@oracle.com>
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shirley Ma <shirley.ma@oracle.com>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
 <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
 <14f78832-9b81-4e96-0b4a-27d2acff6f71@oracle.com>
Message-ID: <0ce0914e-6cd7-2aad-d144-c679cdfb86b0@oracle.com>
Date:   Tue, 2 Jun 2020 18:47:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <14f78832-9b81-4e96-0b4a-27d2acff6f71@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020162
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/2/20 6:26 PM, Mike Christie wrote:
>>
> 
> Maybe you need a new trace call for the case where we can't fully 
> initialize the cmd. It could be used for cases like where 
> transport_generic_new_cmd is used directly but fails, the 
> transport_handle_queue_full case, and your case where we fail during the 
> initial setup.

Ignore the transport_handle_queue_full case. I thought we had drivers 
using it when they initially read commands in, but that's not the case 
so the cmd is always setup in that function.
