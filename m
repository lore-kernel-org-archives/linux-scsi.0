Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FC6C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 22:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65287204EC
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 22:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eqX9VAuQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgKQWbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 17:31:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728726AbgKQWbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 17:31:47 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHM38vf190903;
        Tue, 17 Nov 2020 17:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7MrrKV5Y2QJgd8GDuAPq+YmtMal0O5LLBFJHp8Cfj3M=;
 b=eqX9VAuQsxKFBrQe54iXwmzlG1I14skqNrnbKmxC+KrLwXjtOtheXEVo3nYIlg8RqwIU
 RKaSEn+pxIOHL+fuS6LrsGWUrKKq139taOitPXxbHl7gsbkRfe3kXdYqZZjIWlNI8Wvs
 Q03EUEV/Sp6fU51dj+lWjP5wNwK1GBeKks/wHTaciuAmx+2UZoOogs6q8k0FMMPMi+j0
 HVYwdH/L1N7txcq7dzpYLhTZxMy34mmCIpyiS83IUQvdwPcspJtyfFayooe8SiVPaXht
 vxvcs4nCy1ePD978sPJvaewo/DirSpi0bk54/Apm3dsuvIZTTqYkGBOB5oNa1ZAUVNqP YQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vcs3jyg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 17:31:43 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHMS3m6005430;
        Tue, 17 Nov 2020 22:31:41 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 34t6v91ube-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 22:31:41 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHMVVFR41025976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 22:31:31 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3F351367BD;
        Tue, 17 Nov 2020 22:14:10 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C6481367BB;
        Tue, 17 Nov 2020 22:14:10 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.40.231])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 22:14:10 +0000 (GMT)
Subject: Re: [PATCH 4/6] ibmvfc: add FC payload retrieval routines for
 versioned vfcFrames
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201112010442.102589-1-tyreld@linux.ibm.com>
 <20201112010442.102589-4-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <9e38f449-d2e6-6408-4fef-cfb5351393cc@linux.vnet.ibm.com>
Date:   Tue, 17 Nov 2020 16:14:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201112010442.102589-4-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_09:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 phishscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170162
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/20 7:04 PM, Tyrel Datwyler wrote:
> The FC iu and response payloads are located at different offsets
> depending on the ibmvfc_cmd version. This is a result of the version 2
> vfcFrame definition adding an extra 64bytes of reserved space to the
> structure prior to the payloads.
> 
> Add helper routines to determine the current vfcFrame version and
> returning pointers to the proper iu or response structures within that
> ibmvfc_cmd.
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 76 ++++++++++++++++++++++++----------
>  1 file changed, 53 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index aa3445bec42c..5e666f7c9266 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -138,6 +138,22 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
>  
>  static const char *unknown_error = "unknown error";
>  
> +static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost, struct ibmvfc_cmd *vfc_cmd)
> +{
> +	if (be64_to_cpu(vhost->login_buf->resp.capabilities) & IBMVFC_HANDLE_VF_WWPN)

Suggest adding a flag to the vhost structure that you setup after login in order to
simplify this check and avoid chasing multiple pointers along with a byte swap.

Maybe something like:

vhost->is_v2

> +		return &vfc_cmd->v2.iu;
> +	else
> +		return &vfc_cmd->v1.iu;
> +}
> +
> +static struct ibmvfc_fcp_rsp *ibmvfc_get_fcp_rsp(struct ibmvfc_host *vhost, struct ibmvfc_cmd *vfc_cmd)
> +{
> +	if (be64_to_cpu(vhost->login_buf->resp.capabilities) & IBMVFC_HANDLE_VF_WWPN)

Same here

> +		return &vfc_cmd->v2.rsp;
> +	else
> +		return &vfc_cmd->v1.rsp;
> +}
> +
>  #ifdef CONFIG_SCSI_IBMVFC_TRACE
>  /**
>   * ibmvfc_trc_start - Log a start trace entry



-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

