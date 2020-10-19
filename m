Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A436C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 18:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E340D223AE
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 18:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kblceLHV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgJSSo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 14:44:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54634 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbgJSSo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 14:44:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JIYnf4163271;
        Mon, 19 Oct 2020 18:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=S3h6vcCzyFzMvMc5Crhm9jd/b9N8Zyfr/vnjyAYIZEs=;
 b=kblceLHVX0VIWzYDoprObVbrGai4G/dJf5m2XWh9kZUiv3ILa+g47xPqJEzRfnRwIaf4
 /a2Ifu9In3AjkMVea9upjQbsMBAhwU6xU9AeKf/l5KGe/4PaLvmA7iQDCRxK8+ldQEVc
 tnbY/1Klt/YvmT1oSZqnONf/SKF+RehiPtGuUYZfOoN4S6Z6KDVdaxInxrP3Mz7D7HS/
 0gNqj99vi14wTdqbTkGH89iqkeo/yWVeuiu3lx7RpaJkgC/efgACoPr6YCXsGUtcNdNx
 8Z0e3BkonY5nOt0durZKMEybwxF3Ptu0I4tJ37oFecI3T8ENalYZwJRSY36DTYH1X3oS Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 347p4aq9qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 18:44:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JIZpoB015649;
        Mon, 19 Oct 2020 18:44:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 348acpt8m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 18:44:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09JIik4b012162;
        Mon, 19 Oct 2020 18:44:46 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 11:44:46 -0700
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
 <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
 <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de>
 <e031f239c4bc02cafde13ad573523559@mail.gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <0863bb07-1f74-ba14-50dc-717c7f68af7e@oracle.com>
Date:   Mon, 19 Oct 2020 13:44:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e031f239c4bc02cafde13ad573523559@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190125
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/20 1:03 PM, Muneendra Kumar M wrote:
> Hi Michael,
> Regarding the TUR (Test Unit Ready)command which I was mentioning .
> Multipath daemon issues TUR commands on a regular intervals to check the
> path status.
> When a port_state is set to marginal we are not suppose to end up failing
> the cmd  with DID_TRANSPORT_MARGINAL with out proceeding it.
> This may  leads to give wrong health status.


If your daemon works such that you only move paths from marginal to 
active if you get an ELS indicating the path is ok or you get a link up, 
then why have multipathd send path tester IO to the paths in the 
marginal path group? They do not do anything do they?



> Hannes/James Correct me if this is wrong.
> 
> Regards,
> Muneendra.
> 
> -----Original Message-----
> From: Muneendra Kumar M [mailto:muneendra.kumar@broadcom.com]
> Sent: Monday, October 19, 2020 11:01 PM
> To: 'Hannes Reinecke' <hare@suse.de>; 'Michael Christie'
> <michael.christie@oracle.com>
> Cc: 'linux-scsi@vger.kernel.org' <linux-scsi@vger.kernel.org>;
> 'jsmart2021@gmail.com' <jsmart2021@gmail.com>; 'emilne@redhat.com'
> <emilne@redhat.com>; 'mkumar@redhat.com' <mkumar@redhat.com>
> Subject: RE: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
> FC_PORTSTATE_MARGINAL
> 
> Hi Michael,
> 
> 
>>
>>
>> Oh yeah, to be clear I meant why try to send it on the marginal path
>> when you are setting up the path groups so they are not used and only the
>> optimal paths are used.
>> When the driver/scsi layer fails the IO then the multipath layer will
>> make sure it goes on a optimal path right so you do not have to worry
>> about hitting a cmd timeout and firing off the scsi eh.
>>
>> However, one other question I had though, is are you setting up
>> multipathd so the marginal paths are used if the optimal ones were to
>> fail (like the optimal paths hit a link down, dev_loss_tmo or
>> fast_io_fail fires, etc) or will they be treated like failed paths?
>>
>> So could you end up with 3 groups:
>>
>> 1. Active optimal paths
>> 2. Marginal
>> 3. failed
>>
>> If the paths in 1 move to 3, then does multipathd handle it like a all
>> paths down or does multipathd switch to #2?
>>
>> Actually, marginal path work similar to the ALUA non-optimized state.
>> Yes, the system can sent I/O to it, but it'd be preferable for the I/O to
>> be moved somewhere else.
>> If there is no other path (or no better path), yeah, tough.
> 
>> Hence the answer would be 2)
> 
> 
> [Muneendra]As Hannes mentioned if there are no active paths, the marginal
> paths will be moved to normal and the system will send the io.
> 
> Regards,
> Muneendra.
> 

