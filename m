Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF383C00A89
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 00:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66934208B6
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 00:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgJaAGf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 20:06:35 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:49085 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJaAGf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 20:06:35 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id DF71C2EA004;
        Fri, 30 Oct 2020 20:06:33 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id D2m70ZN8kqVU; Fri, 30 Oct 2020 19:58:19 -0400 (EDT)
Received: from [192.168.0.18] (unknown [198.52.162.92])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 60DAC2EA0B5;
        Fri, 30 Oct 2020 20:06:32 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 4/4] scsi: target: return COMPARE AND WRITE miscompare
 offsets
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
References: <20201030213931.10720-1-ddiss@suse.de>
 <20201030213931.10720-5-ddiss@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <e475cbf3-6dc8-901f-b5e3-30228e9a03a4@interlog.com>
Date:   Fri, 30 Oct 2020 20:06:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030213931.10720-5-ddiss@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-30 5:39 p.m., David Disseldorp wrote:
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
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_sbc.c       | 34 ++++++++++++++++++--------
>   drivers/target/target_core_transport.c |  1 +
>   2 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 22d0cbba6ff3..0fa52a98d6cf 100644
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
> @@ -467,17 +467,20 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
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
> +		for (i = 0; i < len && addr[i] == buf[offset + i]; i++)
> +			;

I believe the logic is correct (and scsi_debug doesn't set the INFO field
in its CAW, but should), but I wonder about performance.

If the probability of equality is high (e.g. like it is usually with
VERIFY(BytChk=1) ) and memcmp() is faster than that for-loop (which
could be optimized), then a better strategy might be to always do memcmp()
first and only if it fails go into the byte by byte for-loop to find the
offset of the first miscompare.

IMO this should only be considered, if there is going to be a "v4" of
this patchset.

Doug Gilbert

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
> @@ -501,6 +504,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>   	unsigned int len;
>   	unsigned int block_size = dev->dev_attrib.block_size;
>   	unsigned int compare_len = (cmd->t_task_nolb * block_size);
> +	unsigned int miscmp_off = 0;
>   	sense_reason_t ret = TCM_NO_SENSE;
>   	int i;
>   
> @@ -532,8 +536,18 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
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

