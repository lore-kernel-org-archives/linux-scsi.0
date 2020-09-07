Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B0EC43461
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 23:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FF221741
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 23:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f+KvpGzx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgIGXPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 19:15:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58148 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgIGXPE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 19:15:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087NDsL8144903;
        Mon, 7 Sep 2020 23:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ix6Y6JjZeh7TBlfeYYjwl7+9wh3u5mgubHtORH10LSs=;
 b=f+KvpGzxqYlhw20q9QmPHa2PNzCber1x8KvxM7tILT2QXmsHgDnhaTnmVm8/PAmm+I8z
 tfBTY3DHAFdQgZnm7ttNb29FN6inotbKI8v8FpWhaa6xgKRoOiWlj+W8vkqXV6OHsCB0
 FDZYhLLNIC1Yv7XMbNsycImxzI9T0GTZs6ntk2m0FRWM2n2s7VXCLRDKYi8bI/YwUVZu
 fAowVvd1nZBEblo0SlWovdWKfQc6XJJFrULyvCDxCFE0oGRP2qEqc5VgVygiGKvbKBNH
 s5Ioil3HyHMg9gji6tzLGGbij5VEfK0CQx+gS7G2lelkNrgVWjFChvt5LKSEIS21jikd yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3amr766-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 23:14:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087NBN3x028016;
        Mon, 7 Sep 2020 23:14:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33cmeq39wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 23:14:56 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087NEplY008519;
        Mon, 7 Sep 2020 23:14:55 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 16:14:51 -0700
Subject: Re: [PATCH v2] scsi: target: tcmu: add compat mode for 32bit
 userspace on 64bit kernel
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200903174105.4571-1-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <8f276b52-f741-b00b-9b00-77fcd855c4fe@oracle.com>
Date:   Mon, 7 Sep 2020 18:14:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903174105.4571-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070225
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070225
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/20 12:41 PM, Bodo Stroesser wrote:
> +#ifdef TCMU_COMPAT
> +static inline void compat_new_iov(struct iovec **iov, int *iov_cnt)
> +{
> +	struct compat_iovec **c_iov = (struct compat_iovec **)iov;
> +
> +	if (*iov_cnt != 0)
> +		(*c_iov)++;
> +	(*iov_cnt)++;
> +
> +	memset(*c_iov, 0, sizeof(struct compat_iovec));
> +}
> +
> +static inline size_t compat_iov_tail(struct iovec *iov)
> +{
> +	struct compat_iovec *c_iov = (struct compat_iovec *)iov;
> +
> +	return (size_t)c_iov->iov_base + c_iov->iov_len;
> +}
> +#endif
> +
>  static void scatter_data_area(struct tcmu_dev *udev,
>  	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
>  	unsigned int data_nents, struct iovec **iov,
> @@ -705,13 +763,41 @@ static void scatter_data_area(struct tcmu_dev *udev,
>  			to_offset = get_block_offset_user(udev, dbi,
>  					block_remaining);
>  
> +			copy_bytes = min_t(size_t, sg_remaining,
> +					block_remaining);
> +			if (copy_data) {
> +				offset = DATA_BLOCK_SIZE - block_remaining;
> +				memcpy(to + offset,
> +				       from + sg->length - sg_remaining,
> +				       copy_bytes);
> +			}
> +			sg_remaining -= copy_bytes;
> +			block_remaining -= copy_bytes;
> +
>  			/*
>  			 * The following code will gather and map the blocks
>  			 * to the same iovec when the blocks are all next to
>  			 * each other.
>  			 */
> -			copy_bytes = min_t(size_t, sg_remaining,
> -					block_remaining);
> +#ifdef TCMU_COMPAT
> +			if (udev->compat) {
> +				struct compat_iovec *c_iov;
> +
> +				if (*iov_cnt != 0 &&
> +				    to_offset == compat_iov_tail(*iov)) {
> +					c_iov = (struct compat_iovec *)*iov;
> +					c_iov->iov_len += copy_bytes;
> +				} else {
> +					compat_new_iov(iov, iov_cnt);
> +					c_iov = (struct compat_iovec *)*iov;
> +					c_iov->iov_base =
> +						(compat_uptr_t)to_offset;
> +					c_iov->iov_len = copy_bytes;
> +				}
> +				continue;
> +			}
> +#endif

I think a couple one or two liner ifdefs in the middle of a function is something people look the other way on. Maybe here we went a little too wild though. If we are not going the callout route, I think it would be nicer here to separate this part into functions. In the ifdef with compat_new_iov/compat_iov_tail above this function, add a tcmu_compat_iov_set and move the code above there. Move the code below it that does the non compat code to a new function tcmu_iov_set. We will still need a ifdef for the tcmu_compat_iov_set somewhere, but it feels more organized.
