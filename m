Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A98C55185
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9695020724
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ofwk05m8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgDUVTH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:19:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57652 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDUVTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 17:19:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LLIiu6063368;
        Tue, 21 Apr 2020 21:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KMdTlG2rPmioxSiQ4x0nxmKawtk+H1nIb3qC1og/GgA=;
 b=Ofwk05m8QtjJia8DX84LLzZ4bGpn+Sazhrcv4mMV6RbjDnnRSte7hNTZcMenwtsKZHkq
 Q8HGDFBMxVTkfjKltV2VUpC6vajRT9wV+VLBubqtz+iOhgo0oYLhwNhG6jSYq8LxOvtd
 ZXPLk9mmxsmmE31lnpm2QnBgFru4CDUBHMpYjH2LNzQYJ4snkJ4NrOY3w/DY5lKK6Z33
 WExxoLmexq8jE5yRpBUWMqbsEcKDJmpBthJtQrt1YI2heFvfJwfyU4otjsl6VKYmOUH8
 zjyn8ov8wSiz1RbfqPXdARvnOykPvLWgx1r0jCNjUeIQKuk6J79uFYMJsXbISn5/muqU zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30fsgkyd04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 21:18:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LLIUJU151013;
        Tue, 21 Apr 2020 21:18:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30gb1gxev7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 21:18:56 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03LLItfj006889;
        Tue, 21 Apr 2020 21:18:55 GMT
Received: from [10.154.114.8] (/10.154.114.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 14:18:55 -0700
Subject: Re: [PATCH v4 2/2] scsi: qla2xxx: check UNLOADING before posting
 async work
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
References: <20200421204621.19228-1-mwilck@suse.com>
 <20200421204621.19228-3-mwilck@suse.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <ca151707-3089-8ab2-c40e-586d6c3457fe@oracle.com>
Date:   Tue, 21 Apr 2020 16:18:54 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421204621.19228-3-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004210154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=2 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210154
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/21/20 3:46 PM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> qlt_free_session_done() tries to post async PRLO / LOGO, and
> waits for the completion of these async commands. If UNLOADING
> is set, this is doomed to timeout, because the async logout
> command will never complete.
> 
> The only way to avoid waiting pointlessly is to fail posting
> these commands in the first place if the driver is in UNLOADING state.
> In general, posting any command should be avoided when the driver
> is UNLOADING.
> 
> With this patch, "rmmod qla2xxx" completes without noticeable delay.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index ce0dabb..8cce3e2 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4862,6 +4862,9 @@ qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
>   	struct qla_work_evt *e;
>   	uint8_t bail;
>   
> +	if (test_bit(UNLOADING, &vha->dpc_flags))
> +		return NULL;
> +
>   	QLA_VHA_MARK_BUSY(vha, bail);
>   	if (bail)
>   		return NULL;
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
