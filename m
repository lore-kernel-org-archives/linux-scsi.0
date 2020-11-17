Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CF2C63798
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 22:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1426B24248
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 22:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GAMAWdfV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgKQWHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 17:07:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728411AbgKQWHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 17:07:03 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHM4H5d083997;
        Tue, 17 Nov 2020 17:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ai6BAreswhyDf4MnMxZzL8UpCtwkvNq9pLaziKNJwZA=;
 b=GAMAWdfVh3mlc+7/SZ06WB8euH4+ynkd0/e0UPnnjcm1aUyl35L4v7E9a7WaegG8v7bS
 6E5ZBOwMErfHu6kKDIaJNgsXzn8B4046Ah/iP5FTVsniXIYSQJdktd58B5XBSNxtFHjT
 RFZEDyfeSrAGtjx4t6sBiFyLGiWcEnODMyDzPdkM93Nw/0HAtyfNXpHOWVLpVqXdPhbY
 IGGyrDAhwV7xfdYWFy+UQ2nmtZHmt5i1nKaZBedsIj9426+Fvt5PRE4E3rDQlnIKpTLn
 hEJm0OAVxVy4SlCyYd/M9NhNGaXoLr9b5xcUe9EzynZk75wdmROPZd2Lcy7k1KVFD9SA Ww== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vfd8f0x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 17:06:54 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHM1wxj029891;
        Tue, 17 Nov 2020 22:06:52 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 34vfj9tud1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 22:06:52 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHM6pKX3277442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 22:06:51 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DC091363AD;
        Tue, 17 Nov 2020 22:06:51 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E0491363AF;
        Tue, 17 Nov 2020 22:06:50 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.40.231])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 22:06:50 +0000 (GMT)
Subject: Re: [PATCH 3/6] ibmvfc: add new fields for version 2 of several MADs
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201112010442.102589-1-tyreld@linux.ibm.com>
 <20201112010442.102589-3-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <5b772ce2-3119-f05b-15d3-357729e46e70@linux.vnet.ibm.com>
Date:   Tue, 17 Nov 2020 16:06:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201112010442.102589-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_12:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1011 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170162
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/20 7:04 PM, Tyrel Datwyler wrote:
> @@ -211,7 +214,9 @@ struct ibmvfc_npiv_login_resp {
>  	__be64 capabilities;
>  #define IBMVFC_CAN_FLUSH_ON_HALT	0x08
>  #define IBMVFC_CAN_SUPPRESS_ABTS	0x10
> -#define IBMVFC_CAN_SUPPORT_CHANNELS	0x20
> +#define IBMVFC_MAD_VERSION_CAP		0x20
> +#define IBMVFC_HANDLE_VF_WWPN		0x40
> +#define IBMVFC_CAN_SUPPORT_CHANNELS	0x80
>  	__be32 max_cmds;
>  	__be32 scsi_id_sz;
>  	__be64 max_dma_len;
> @@ -293,6 +298,7 @@ struct ibmvfc_port_login {
>  	__be32 reserved2;
>  	struct ibmvfc_service_parms service_parms;
>  	struct ibmvfc_service_parms service_parms_change;
> +	__be64 targetWWPN;

For consistency, can you make this target_wwpn?

>  	__be64 reserved3[2];
>  } __packed __aligned(8);
>  
> @@ -344,6 +350,7 @@ struct ibmvfc_process_login {
>  	__be16 status;
>  	__be16 error;			/* also fc_reason */
>  	__be32 reserved2;
> +	__be64 targetWWPN;

For consistency, can you make this target_wwpn?

>  	__be64 reserved3[2];
>  } __packed __aligned(8);
>  
> @@ -378,6 +385,8 @@ struct ibmvfc_tmf {
>  	__be32 cancel_key;
>  	__be32 my_cancel_key;
>  	__be32 pad;
> +	__be64 targetWWPN;

For consistency, can you make this target_wwpn?

> +	__be64 taskTag;

and make this task_tag. 

>  	__be64 reserved[2];
>  } __packed __aligned(8);
>  
> @@ -474,9 +483,19 @@ struct ibmvfc_cmd {
>  	__be64 correlation;
>  	__be64 tgt_scsi_id;
>  	__be64 tag;
> -	__be64 reserved3[2];
> -	struct ibmvfc_fcp_cmd_iu iu;
> -	struct ibmvfc_fcp_rsp rsp;
> +	__be64 targetWWPN;

For consistency, can you make this target_wwpn?

> +	__be64 reserved3;
> +	union {
> +		struct {
> +			struct ibmvfc_fcp_cmd_iu iu;
> +			struct ibmvfc_fcp_rsp rsp;
> +		} v1;
> +		struct {
> +			__be64 reserved4;
> +			struct ibmvfc_fcp_cmd_iu iu;
> +			struct ibmvfc_fcp_rsp rsp;
> +		} v2;
> +	};
>  } __packed __aligned(8);
>  
>  struct ibmvfc_passthru_fc_iu {
> @@ -503,6 +522,7 @@ struct ibmvfc_passthru_iu {
>  	__be64 correlation;
>  	__be64 scsi_id;
>  	__be64 tag;
> +	__be64 targetWWPN;

For consistency, can you make this target_wwpn?

>  	__be64 reserved2[2];
>  } __packed __aligned(8);
>  
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

