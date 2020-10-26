Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F252C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 01:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1283B2225C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 01:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y9q08Eug"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1419436AbgJZBQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 21:16:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1419390AbgJZBQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Oct 2020 21:16:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09Q1GjVH019747;
        Mon, 26 Oct 2020 01:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=e/Ha+goufUHs3iTzYf3Pq2fpxf2TqdxOy0eiJ6xL9B4=;
 b=Y9q08EugPH9iHAc65f8DPgXtJA12F04r9RqbYO2RdsNIvUuU8UPzeAvEn+f2PDsX2bwy
 kKWYOSGNVcwZ1CVJCb1tdXwMxR4RCfJRseJQNBBe6x1rgxeKKHGLotm5o/1g+/HNH74J
 tc63VvxG8Cgvg+kjgmJNtCzeY/KS3QdFpo/ilxOpPLk6Ng1MZpI/9cJR96CEwLybjMlG
 eN8D7LzcxPkGfCGgiNCECaUu0sftN4fvu9iEKhQfIhexpBlsDg/XRRJJY0gomTrrHRJX
 cfcNHquned1e8rn8lkmy15pAbddGF4WIbGHZIw+diM45BhEmNhwYi0adft80Tkjgcdyn gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kjm7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 01:16:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09Q15D7M018331;
        Mon, 26 Oct 2020 01:14:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx6ubd0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 01:14:44 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09Q1Eh5j027019;
        Mon, 26 Oct 2020 01:14:43 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Oct 2020 18:14:43 -0700
Subject: Re: [PATCH 5/5] scsi: target: return COMPARE AND WRITE miscompare
 offsets
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
References: <20201023205723.17880-1-ddiss@suse.de>
 <20201023205723.17880-6-ddiss@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <311cb7dd-2cdb-e653-ab97-41d644c0d293@oracle.com>
Date:   Sun, 25 Oct 2020 20:14:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201023205723.17880-6-ddiss@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/20 3:57 PM, David Disseldorp wrote:
> SBC-4 r15 5.3 COMPARE AND WRITE command states:
>    if the compare operation does not indicate a match, then terminate the
>    command with CHECK CONDITION status with the sense key set to
>    MISCOMPARE and the additional sense code set to MISCOMPARE DURING
>    VERIFY OPERATION. In the sense data (see 4.18 and SPC-5) the offset
>    from the start of the Data-Out Buffer to the first byte of data that
>    was not equal shall be reported in the INFORMATION field.
> 
> This change implements the missing logic to report the miscompare offset
> in the sense data INFORMATION field.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>   drivers/target/target_core_sbc.c       | 35 ++++++++++++++++++--------
>   drivers/target/target_core_transport.c |  1 +
>   2 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 79216d0355e7..e40359e45726 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -435,13 +435,13 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
>   }
>   
>   /*
> - * compare @cmp_len bytes of @read_sgl with @cmp_sgl. On miscompare return
> - * TCM_MISCOMPARE_VERIFY.
> + * compare @cmp_len bytes of @read_sgl with @cmp_sgl. On miscompare, fill
> + * @miscmp_off and return TCM_MISCOMPARE_VERIFY.
>    */
>   static sense_reason_t
>   compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
>   			 struct scatterlist *cmp_sgl, unsigned int cmp_nents,
> -			 unsigned int cmp_len)
> +			 unsigned int cmp_len, unsigned int *miscmp_off)
>   {
>   	unsigned char *buf = NULL;
>   	struct scatterlist *sg;
> @@ -468,17 +468,20 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
>   	 */
>   	offset = 0;
>   	for_each_sg(read_sgl, sg, read_nents, i) {
> +		unsigned int i;
>   		unsigned int len = min(sg->length, cmp_len);
>   		unsigned char *addr = kmap_atomic(sg_page(sg));
>   
> -		if (memcmp(addr, buf + offset, len)) {
> -			pr_warn("Detected MISCOMPARE for addr: %p buf: %p\n",
> -				addr, buf + offset);
> -			kunmap_atomic(addr);
> +		for (i = 0; i < len && addr[i] == buf[offset + i]; i++);

I think it's a little nicer to put the ";" on the next line. It's just 
not a common line of code so your eyes miss it. It should also make the 
checkpatch script happy.

> +
> +		kunmap_atomic(addr);
> +		if (i < len) {
> +			*miscmp_off = offset + i;
> +			pr_warn("Detected MISCOMPARE at offset %u\n",
> +				*miscmp_off);
>   			ret = TCM_MISCOMPARE_VERIFY;
>   			goto out;
>   		}
> -		kunmap_atomic(addr);
>   
>   		offset += len;
>   		cmp_len -= len;
> @@ -503,6 +506,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>   	unsigned int nlbas = cmd->t_task_nolb;
>   	unsigned int block_size = dev->dev_attrib.block_size;
>   	unsigned int compare_len = (nlbas * block_size);
> +	unsigned int miscmp_off = 0;
>   	sense_reason_t ret = TCM_NO_SENSE;
>   	int i;
>   
> @@ -534,8 +538,19 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>   				       cmd->t_bidi_data_nents,
>   				       cmd->t_data_sg,
>   				       cmd->t_data_nents,
> -				       compare_len);
> -	if (ret)
> +				       compare_len,
> +				       &miscmp_off);
> +	if (ret == TCM_MISCOMPARE_VERIFY) {
> +		/*
> +		 * SBC-4 r15: 5.3 COMPARE AND WRITE command
> +		 * In the sense data (see 4.18 and SPC-5) the offset from the
> +		 * start of the Data-Out Buffer to the first byte of data that
> +		 * was not equal shall be reported in the INFORMATION field.
> +		 */
> +		WARN_ON(miscmp_off >= compare_len);

I'm not sure how useful this is. If we hit this then we went wild in 
compare_and_write_do_cmp since we only allocate the cmp buffer to be 
compare_len bytes. If we think it's possible to hit this due to a 
incorrectly setup cmd or buffer/sgl or something, I would be more 
defensive in compare_and_write_do_cmp.


> +		cmd->sense_info = miscmp_off;
> +		goto out;
> +	} else if (ret)
>   		goto out;
>   
>   	if (sg_alloc_table(&write_tbl, cmd->t_data_nents, GFP_KERNEL) < 0) {
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index c6f45c12d564..693ed3fe4388 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3196,6 +3196,7 @@ static const struct sense_detail sense_detail_table[] = {
>   		.key = MISCOMPARE,
>   		.asc = 0x1d, /* MISCOMPARE DURING VERIFY OPERATION */
>   		.ascq = 0x00,
> +		.add_sense_info = true,
>   	},
>   	[TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED] = {
>   		.key = ABORTED_COMMAND,
> 

