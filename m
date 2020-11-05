Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE43C55179
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 15:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32A5C20A8B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 15:59:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U7cX5g6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbgKEP7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 10:59:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730660AbgKEP7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 10:59:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5FrbLs142451;
        Thu, 5 Nov 2020 15:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r7kRTL2DAg7ujqNaK/ka520qWI3kloxS7ggURP6eXyg=;
 b=U7cX5g6kdAl4FaYHNgwYljJfaFAh7c+iQ799By5GOQ1abFS1CK40EDfK40t3qa/DiFPw
 CmeLEaKCEN0yNPxqKnB/YybuaUxF+lMuMCrz4bu2rCf1krQQ8eJjFPip3GEeaGqRlZHj
 j4VX7VaLvKLqy2u+4Bow3yoKnPIkjXglaHVslGVp3/x0e9C+KvBPR9mJ0AG5Ch3ollap
 2FjDdBh8PCb9vrI58A+5CdEegiiqnHmfsc2Rjz3yVW48AkAcwwhn8U3WLjtTxdM4BQxW
 SARWoPUTYa/f/9QXdvsbxfdkcrmYVA6zFrLeg00Hhf4AKrymXNLobRVu969zWTyC95Nc lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34hhvcmmt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 15:59:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5Fookx187347;
        Thu, 5 Nov 2020 15:59:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34hw0hkttj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 15:59:14 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A5FxDit009253;
        Thu, 5 Nov 2020 15:59:13 GMT
Received: from [20.15.0.19] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Nov 2020 07:59:13 -0800
Subject: Re: [PATCH v6 3/4] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1604556596-27228-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604556596-27228-4-git-send-email-muneendra.kumar@broadcom.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <e575da88-8b40-3062-9835-419456b46989@oracle.com>
Date:   Thu, 5 Nov 2020 09:59:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604556596-27228-4-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/20 12:09 AM, Muneendra wrote:
>   int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
>   {
>   	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
> +	int ret = 0;
>   
>   	if (WARN_ON_ONCE(!rport))
>   		return FAST_IO_FAIL;
>   
> -	return fc_block_rport(rport);
> +	ret = fc_block_rport(rport);
> +	/*
> +	 * Clear the SCMD_NORETRIES_ABORT bit if the Port state has
> +	 * changed from marginal to online due to
> +	 * fc_remote_port_delete and fc_remote_port_add
> +	 */
> +	if (rport->port_state != FC_PORTSTATE_MARGINAL)
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmnd->state);
> +	return ret;
>   }


Hey sorry for the late reply. I was trying to test some things out but 
am not sure if all drivers work the same.

For the code above, what will happen if we have passed that check in the 
driver, then the driver does the report del and add sequence? Let's say 
it's initially calling the abort callout, and we passed that check, we 
then do the del/add seqeuence, what will happen next? Do the fc drivers 
return success or failure for the abort call. What happens for the other 
callouts too?

If failure, then the eh escalates and when we call the next callout, and 
we hit the check above and will clear it, so we are ok.

If success then we would not get a chance to clear it right? If this is 
the case, then I think you need to instead go the route where you add 
the eh cmd completion/decide_disposition callout. You would call it in 
scmd_eh_abort_handler, scsi_eh_bus_device_reset, etc when we are 
deciding if we want to retry/fail the command. In this approach you do 
not need the eh_timed_out changes, since we only seem to care about the 
port state after the eh callout has completed.


