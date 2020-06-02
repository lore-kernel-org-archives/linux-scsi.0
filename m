Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFA5C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 23:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0195320734
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 23:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BRSbP8WY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgFBX25 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:28:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46856 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgFBX25 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 19:28:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052NN5e1110158;
        Tue, 2 Jun 2020 23:28:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9QTDh0fIgwa8i6OCbqe/e6lFC+Z0RNGgVg+4DMvObZg=;
 b=BRSbP8WYyCh2CnIJp8okUjEzrskHws4zutwuUTeWNvZyDNTN1xnoCDBOrjyZly8/MvUN
 jp/NaJq/yJjvt5o+dKDATMw79rkzewnCgIn1vMat2WDMbQlb17U52L995T31UcR6N1n5
 Vuw0XXPapIzjeYZFQt7LtzRCUwTms0PBHyr12dUa1zZGPJKiP4PzNfRR163NJQg68Wai
 CPvKjQd3fn2dL8xv8xbgiVaLuy873sJDVSDvaBVDbN6pnjES0b7pcA4/ev27Dyy/FEZv
 WLDTuWlQ4OUp8+5Brvq92uX0acSBPGuDAupXtkrRpbZvN7omwW1zYz8EQg+Qp+QRCq3f rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem6dsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 23:28:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052NID7c007148;
        Tue, 2 Jun 2020 23:28:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31c25qage1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 23:28:55 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052NStQS016202;
        Tue, 2 Jun 2020 23:28:55 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 16:28:54 -0700
Subject: Re: [PATCH v3 2/3] target: fix NULL pointer dereference
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shirley Ma <shirley.ma@oracle.com>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
 <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
 <b88dd350-16d6-4551-9602-03368e639642@default>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <86ebdc00-afd7-dfc6-3fe7-7e1128b70ee4@oracle.com>
Date:   Tue, 2 Jun 2020 18:28:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b88dd350-16d6-4551-9602-03368e639642@default>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/2/20 6:01 PM, Sudhakar Panneerselvam wrote:
>>> Maybe move this to after target_get_sess_cmd().
>>
>> I moved it before target_get_sess_cmd() because if target_get_sess_cmd() fails
>> then we have NULL pointer dereference issue again. For instance, the sequence
>>    vhost_scsi_submission_work
>>       target_submit_cmd_map_sgls
>>         target_get_sess_cmd() -- Suppose this fails
>>       transport_send_check_condition_and_sense
>>          trace_target_cmd_complete -- NULL ptr derefence.
>>
>> Still thinking how to address both these issues together.
> 
> Also, noticed that not all callers of target_get_sess_cmd() check for return value.( iscsit_setup_scsi_cmd() and iscsit_handle_task_mgt_cmd()). Could this cause problems?
> 

I think it's ok. iscsi doesn't use target_sess_cmd_list_set_waiting so 
the only way it fails there is if there is a driver bug.
