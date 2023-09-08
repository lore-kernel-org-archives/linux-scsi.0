Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CEDEC875F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Sep 2023 00:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240052AbjIHA0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Sep 2023 20:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbjIHA0e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2023 20:26:34 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4D11BCD
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 17:26:30 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 387NeUGq015513;
        Fri, 8 Sep 2023 00:26:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=2czvY7E/+gcny2XL9WJB8oDH27bAv/V5UmdApAvTy+U=;
 b=FsciUPZzUyqHW54mT5RU5YeWU/FlaRhIGgWXT3URQA0c/60IVn50lUd1jnz5iHEB1G4E
 q4y39Nhf3RFDwxuY2TrU/7DPHzHZ0Y7FLHUtOMmOKRQfAYT7G7f8/uS+bcPWGPqPGfYo
 WlqTJqrn0K7wmIN1pvxrqaafklx+Comskdr3Bv6/DroGYw8rKQwvCOa8vTe6r48nwju5
 YQWy+2J0MXhkug2dlPLCBjGnRcbkhrI5p//wCepuUGdkBcu9uJJ8oaE5+zV7Ip0IriiN
 krOiD9aFbQXtOHCF3zDZyHW7hnjDZX8FZzItQR2IlSbDj/BFf9l3mZJFJ4pNFLWNeDuT YA== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3synyq8a2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Sep 2023 00:26:09 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3880Pnwk003585
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 8 Sep 2023 00:25:49 GMT
Received: from [10.253.8.161] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Thu, 7 Sep
 2023 17:25:44 -0700
Message-ID: <2fef7d17-2451-9910-a069-8eeb01492eb2@quicinc.com>
Date:   Fri, 8 Sep 2023 08:25:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2] scsi: ufs: Include the SCSI ID in UFS command tracing
 output
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
References: <20230907183739.905938-1-bvanassche@acm.org>
Content-Language: en-US
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20230907183739.905938-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: KMghW7l7SDaOyS2CwYSZ0zpqr5Z8rECK
X-Proofpoint-GUID: KMghW7l7SDaOyS2CwYSZ0zpqr5Z8rECK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-07_14,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 spamscore=0 clxscore=1011 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309080002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 9/8/2023 2:37 AM, Bart Van Assche wrote:
> The logical unit information is missing from the UFS command tracing
> output. Although the device name is logged, e.g. 13200000.ufs, this
> name does not include logical unit information. Hence this patch that
> replaces the device name with the SCSI ID in the tracing output. An
> example of tracing output with this patch applied:
>
>      kworker/8:0H-80      [008] .....    89.106063: ufshcd_command: send_req: 0:0:0:4: tag: 10, DB: 0x7ffffbff, size: 524288, IS: 0, LBA: 1085538, opcode: 0x8a (WRITE_16), group_id: 0x0
>                dd-4225    [000] d.h..    89.106219: ufshcd_command: complete_rsp: 0:0:0:4: tag: 11, DB: 0x7ffff7ff, size: 524288, IS: 0, LBA: 1081728, opcode: 0x8a (WRITE_16), group_id: 0x0
>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c  |  4 ++--
>   include/trace/events/ufs.h | 15 ++++++++-------
>   2 files changed, 10 insertions(+), 9 deletions(-)
>
> Changes compared to v1 (see also
> https://lore.kernel.org/linux-scsi/20230706215124.4113546-1-bvanassche@acm.org/):
> replaced major and minor numbers with the SCSI ID.
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c2df07545f96..bb3f100276c5 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -447,8 +447,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
>   	} else {
>   		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>   	}
> -	trace_ufshcd_command(dev_name(hba->dev), str_t, tag,
> -			doorbell, hwq_id, transfer_len, intr, lba, opcode, group_id);
> +	trace_ufshcd_command(cmd->device, str_t, tag, doorbell, hwq_id,
> +			     transfer_len, intr, lba, opcode, group_id);
>   }
>   
>   static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index 992517ac3292..b930669bd1f0 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -267,15 +267,15 @@ DEFINE_EVENT(ufshcd_template, ufshcd_wl_runtime_resume,
>   	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
>   
>   TRACE_EVENT(ufshcd_command,
> -	TP_PROTO(const char *dev_name, enum ufs_trace_str_t str_t,
> +	TP_PROTO(struct scsi_device *sdev, enum ufs_trace_str_t str_t,
>   		 unsigned int tag, u32 doorbell, u32 hwq_id, int transfer_len,
>   		 u32 intr, u64 lba, u8 opcode, u8 group_id),
>   
> -	TP_ARGS(dev_name, str_t, tag, doorbell, hwq_id, transfer_len,
> -			intr, lba, opcode, group_id),
> +	TP_ARGS(sdev, str_t, tag, doorbell, hwq_id, transfer_len, intr, lba,
> +		opcode, group_id),
>   
>   	TP_STRUCT__entry(
> -		__string(dev_name, dev_name)
> +		__field(struct scsi_device *, sdev)
>   		__field(enum ufs_trace_str_t, str_t)
>   		__field(unsigned int, tag)
>   		__field(u32, doorbell)
> @@ -288,7 +288,7 @@ TRACE_EVENT(ufshcd_command,
>   	),
>   
>   	TP_fast_assign(
> -		__assign_str(dev_name, dev_name);
> +		__entry->sdev = sdev;
>   		__entry->str_t = str_t;
>   		__entry->tag = tag;
>   		__entry->doorbell = doorbell;
> @@ -302,8 +302,9 @@ TRACE_EVENT(ufshcd_command,
>   
>   	TP_printk(
>   		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x, hwq_id: %d",
> -		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
> -		__entry->tag, __entry->doorbell, __entry->transfer_len, __entry->intr,
> +		show_ufs_cmd_trace_str(__entry->str_t),
> +		dev_name(&__entry->sdev->sdev_dev), __entry->tag,
> +		__entry->doorbell, __entry->transfer_len, __entry->intr,
>   		__entry->lba, (u32)__entry->opcode, str_opcode(__entry->opcode),
>   		(u32)__entry->group_id, __entry->hwq_id
>   	)

Reviewed-by: Can Guo <quic_cang@quicinc.com>

