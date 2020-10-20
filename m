Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A58FC4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 20:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0206B2225D
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 20:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aOt18dUx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409396AbgJTUTE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 16:19:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46122 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391626AbgJTUTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 16:19:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KKIwq0143855;
        Tue, 20 Oct 2020 20:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gJqVnPIwyzlklZpNVFLDoxTZDh/jONUPhYxB5c07Hms=;
 b=aOt18dUxGhk9tfj/baYAM3Pc0iWILGoCpBSwGIcPP7Gq3NnIODxajgEpOzoANZoG+6Me
 mD5gVU5x25Q0wKpOHGpCVGiSAQSY2gj7mKj7WubZm3n94CoL3NZE+Nbmvu8yNhmkplJn
 AF7S61bZOv9xnYPiDa4x+q4GbfF8atRQAOJx13V+xJbzjymYcwxThigR8ZhMHZumpuZh
 UuxRsyISxmg+iIWX3bGCevWiROnTtPp5apcc7RyjgKxg8sJ4K7ngUPMqdNBJy3bLk1AI
 3tk8Knh6B7kZW4nTxBL/k0obXfahZNyG2fK1h6IKAQDu7q7c/uP1H10VFLxbYxoeAe/X zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 347p4awc0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 20:18:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KKA39V178154;
        Tue, 20 Oct 2020 20:18:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 348a6nkhhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 20:18:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09KKItIa013030;
        Tue, 20 Oct 2020 20:18:55 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Oct 2020 13:18:55 -0700
Subject: Re: [PATCH v3 03/17] scsi: No retries on abort success
From:   Mike Christie <michael.christie@oracle.com>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-4-git-send-email-muneendra.kumar@broadcom.com>
 <d13fc9bd-a5da-134f-df21-33f8ac14f7b8@oracle.com>
 <af17dfd40fc54d819b5f33259f7cd63b@mail.gmail.com>
 <63d24f21-1f65-87d3-0a0b-d474541b32e0@oracle.com>
Message-ID: <268e8833-d06e-666e-1813-0c74c9a0806d@oracle.com>
Date:   Tue, 20 Oct 2020 15:18:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <63d24f21-1f65-87d3-0a0b-d474541b32e0@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200137
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/20 2:53 PM, Mike Christie wrote:
> On 10/19/20 2:26 PM, Muneendra Kumar M wrote:
>> Hi Michael,
>>
>>>   check_type:
>>> +	/*
>>> +	 * Check whether caller has decided not to do retries on
>>> +	 * abort success by setting the SCMD_NORETRIES_ABORT bit
>>> +	 */
>>> +	if ((test_bit(SCMD_NORETRIES_ABORT, &scmd->state)) &&
>>> +		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
>>> +		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
>>
>>> Hey, one other thing that might be confusing me is this check and the
>>> naming. The 0/17 email description and the SCMD_NORETRIES_ABORT name makes
>>> me think we want to only run this if the cmd timedout and we went >through
>>> the SCSI EH TMF operations. However, I think this will end up failing other
>>> errors with DID_TRANSPORT_MARGINAL right?
>>
>>> Did you want just the the SCSI EH timeout/abort case to hit this or any
>>> errors that hit this code path?
>> [Muneendra]At present we want SCSI EH timeout/abort case to hit this.
> 
> What about adding a new eh callout that the transport classes can implement.
> They can check the port state at this time and decide if the cmd should be
> retried or failed. It would be similar to fc_eh_timed_out for example.
> 

Or, in the fc_eh_timed_out callout set the SCMD_NORETRIES_ABORT if port
state is marginal and it indicates it wants to abort the cmd. In
scsi_noretry_cmd above then you know we got there, because the cmd
timedout and we tried/were going to abort it. We don't need the code to
loop over running commands, the chkready changes, etc.
