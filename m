Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07CBC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 444FD2245D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cHENuH0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440683AbgJVAiz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:38:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39604 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408647AbgJVAiz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:38:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0T5RQ056687;
        Thu, 22 Oct 2020 00:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Yl6vggUs77C5+6sZg3xAkrP6G21Pij9kiz9cP3SsQ7o=;
 b=cHENuH0ckpYD6FE92B4A5z1Hi17j25ueuLTS97qoDyYqOI24poCb97vEY5KX3xQMRNJg
 M1aLZ2RyddtBmZ9pB5G2yUXfhbVkLAWS423CStkG+2ugkfcRzZPy9i4dAL1U6i+9MIQK
 SoCwAaz9gMQ+/tF67q2PUi4vr42Vi67dqcgrsFsBB7JYQtQswq60dIePj1idZYZn5Swg
 YprPuy9r4FHSI1p4lOMowRA18YfU9yCjCdhJMo92jKpi5FqD1TLPAByPC/dptWchAFya
 sAhX7WvGy9lSaT5tjkMwogV1MJRA7IXzy0S4iZdCh1jdQHM5PrJVBNxLIsYz8uX/0kBM HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 347p4b3fbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:38:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0U6Lk177064;
        Thu, 22 Oct 2020 00:36:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 348a6q16xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:36:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M0aqDL030476;
        Thu, 22 Oct 2020 00:36:52 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:36:52 -0700
Subject: Re: [PATCH v2] scsi: target: tcmu: scatter_/gather_data_area rework
To:     Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20201019115118.11949-1-bostroesser@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <417c848e-ee17-e600-2c99-c1e4896f5709@oracle.com>
Date:   Wed, 21 Oct 2020 19:36:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019115118.11949-1-bostroesser@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/20 6:51 AM, Bodo Stroesser wrote:
> This is made on top of the scsi-staging tree plus my previous
> patch:
> "scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel"
> 
> ---
> 
> scatter_data_area and gather_data_area are not easy to understand,
> since data is copied in nested loops over sg_list and tcmu dbi
> list. Since sg list can contain only partly filled pages, the loop
> has to be prepared to handle sg pages not matching dbi pages
> 1 by 1.
> 
> Existing implementation uses kmap_atomic()/kunmap_atomic() due to
> performance reasons. But instead of using these calls strictly
> nested for sg and dpi pages, the code holds the mappings in an
> overlapping way, which indeed is a bug that would trigger on archs
> using highmem.
> 
> The scatterlist lib contains the sg_miter_start/_next/_stop
> functions which can be used to simplify such complicated loops.
> 
> The new code now processes the dbi list in the outer loop, while
> sg list is handled by the inner one. That way the code can take
> advantage of the sg_miter_* family calls.
> 
> Calling sg_miter_stop() after the end of the inner loop enforces
> strict nesting of atomic kmaps.
> 
> Since the nested loops in scatter_/gather_data_area were very
> similar, I replaced them by the new helper function
> tcmu_copy_data().
> 
> Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
> 

Acked-by: Mike Christie <michael.christie@oracle.com>
