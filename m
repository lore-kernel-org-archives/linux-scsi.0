Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA86C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 19:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6872822365
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 19:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="izHDIvsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgJSTFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 15:05:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55808 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbgJSTFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 15:05:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JJ5HVK113417;
        Mon, 19 Oct 2020 19:05:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2p3j057tCJE/RfGLPhN3ayiI6VPowoZ/W1R46nwXOC8=;
 b=izHDIvslFj15dKjrhgNekdtrwWXIst7I1TTr86T3ulfUwlmZrVP04vsRQ1GCVjL+hGeS
 7IGAaAj6tD4Do85vKYWDPH7zqxdhops/C/aw93ZMwqk90/W77oshLohm5u7wpGTo2j1w
 MnVKx14cORiZK0+h4swHyYwYItZy/j5qF3fS2X1ds4QrFyDeOm6BYauWYuNEXzSHNT3g
 GU2XR/IXKGPWdjagApjNhQlyZxZzI7EacaUsHMq6CQ0uvC7Oz070YBEzk6dgHS9lcqqI
 CUPK/c5ljFAH2LWYlOPgYvytsJRrjz/lpCJIGxX4IVPsxEALDUgFQwvwT50jV00dPfgH gA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 347rjkq70k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 19:05:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JItxDS104254;
        Mon, 19 Oct 2020 19:05:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6m8ed5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 19:05:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09JJ5GxB030715;
        Mon, 19 Oct 2020 19:05:16 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 12:05:15 -0700
Subject: Re: [PATCH v3 03/17] scsi: No retries on abort success
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-4-git-send-email-muneendra.kumar@broadcom.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <d13fc9bd-a5da-134f-df21-33f8ac14f7b8@oracle.com>
Date:   Mon, 19 Oct 2020 14:05:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1602732462-10443-4-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190127
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/14/20 10:27 PM, Muneendra wrote:
>   check_type:
> +	/*
> +	 * Check whether caller has decided not to do retries on
> +	 * abort success by setting the SCMD_NORETRIES_ABORT bit
> +	 */
> +	if ((test_bit(SCMD_NORETRIES_ABORT, &scmd->state)) &&
> +		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
> +		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);

Hey, one other thing that might be confusing me is this check and the 
naming. The 0/17 email description and the SCMD_NORETRIES_ABORT name 
makes me think we want to only run this if the cmd timedout and we went 
through the SCSI EH TMF operations. However, I think this will end up 
failing other errors with DID_TRANSPORT_MARGINAL right?

Did you want just the the SCSI EH timeout/abort case to hit this or any 
errors that hit this code path?

> +		return 1;
> +	}
> +
