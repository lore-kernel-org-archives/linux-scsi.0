Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBCAC433E8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 18:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51EFA20714
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 18:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TILvl5kg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbgG0SN5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 14:13:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48460 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbgG0SN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 14:13:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RIBa3f086665;
        Mon, 27 Jul 2020 18:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=o37VbToTbIhNJVlzIhHl/VDVaZiERhaMiVJdtdW3pkY=;
 b=TILvl5kgvMc2Egus8pOWq/vQOzJMoxEBVQ5i9KM2e2kjwVyARiwqUAobkmTV/db+25oz
 eK9M9EoGKepeo8YBMr8DUVXdaJnc1mpxW/M3w9tFrdsIndF2j7NIgMcLezoaaLb52Ujx
 IMilTg1810ufGc3SnEec/aZK2sl34KDh90oPs6MhLbcEixjosgN/ef56Y+2gzLeg3W4v
 BFgc37DZDncNt/NG7uJsT4E3kQ6ufWrmz1hAwcrpzr25w1S5QW22DMPFS0Z0p+UxOHqN
 tujvaq+nUzMpZ37SNY1eCqlPXFVmAoVGIUQRLRqKHD7L0Mx7a8xB9SE6kPu50VL+vBq1 jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32hu1jb4ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 18:13:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RICNtv124136;
        Mon, 27 Jul 2020 18:13:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32hu5rcdt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 18:13:52 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RIDpAn032613;
        Mon, 27 Jul 2020 18:13:51 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 11:13:51 -0700
Subject: Re: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
 <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
 <2694d1fc-8792-0fe2-4dec-78f15d3b4ec5@ts.fujitsu.com>
 <90048ea8-3b8f-cc06-7869-dca645cd68f2@oracle.com>
 <7c2d8052-fb5e-0a3b-a894-df8bfab44f21@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <b8fc90b9-7038-b202-e7ef-bc4da56816f0@oracle.com>
Date:   Mon, 27 Jul 2020 13:13:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7c2d8052-fb5e-0a3b-a894-df8bfab44f21@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=2 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/20 9:26 AM, Bodo Stroesser wrote:
> On 2020-07-26 20:37, Mike Christie wrote:
>> On 7/26/20 6:02 AM, Bodo Stroesser wrote:
>>> On 2020-07-26 07:16, Mike Christie wrote:
>>>> On 7/15/20 11:04 AM, Bodo Stroesser wrote:
>>>>> Fix:
>>>>> After calling the aborted_task callback the core immediately
>>>>> releases the se_cmd that represents the ABORT_TASK. The woken
>>>>> up thread (tcm_loop_issue_tmr) therefore must not access se_cmd
>>>>> and tl_cmd in case of aborted TMRs.
>>>>
>>>> The code and fix description below look ok. I didn't get the above part though. If we have TARGET_SCF_ACK_KREF set then doesn't the se_cmd and tl_cmd stay around until we do the target_put_sess_cmd in tcm_loop_issue_tmr?
>>>
>>> No. For an aborted ABORT_TASK, target_handle_abort is called.
>>> If tas is not set, it executes this code:
>>>
>>>          } else {
>>>                  /*
>>>                   * Allow the fabric driver to unmap any resources before
>>>                   * releasing the descriptor via TFO->release_cmd().
>>>                   */
>>>                  cmd->se_tfo->aborted_task(cmd);
>>>                  if (ack_kref)
>>>                          WARN_ON_ONCE(target_put_sess_cmd(cmd) != 0);
>>>                  /*
>>>                   * To do: establish a unit attention condition on the I_T
>>>                   * nexus associated with cmd. See also the paragraph "Aborting
>>>                   * commands" in SAM.
>>>                   */
>>>          }
>>>
>>>          WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);
>>>
>>>          transport_lun_remove_cmd(cmd);
>>>
>>>          transport_cmd_check_stop_to_fabric(cmd);
>>>
>>> That means: no matter whether SCF_ACK_REF is set in the cmd or not:
>>> 1) fabric's aborted_task handler and a waiter woken up by aborted_task must not call target_put_sess_cmd.
>>> 2) a waiter woken up by aborted_task() must not access se_cmd (or tl_cmd) since target_handle_abort
>>>     might have released it completely meanwhile.
>>>
>>
>> Oh no, so xen has the same cmd lifetime issue as loop right?
> 
> To me it looks like xen uses nearly the same code like tcm_loop did before my patch.
> There is nothing wrong with that code regarding the cmd lifetim> The problem instead is, that the thread which started a TMR (ABORT_TASK) will sleep forever if that TMR itself is aborted by a further TMR (LUN_RESET).
> This is because tcm_loop_aborted_task() misses the complete() call.
>  
> But if we just add the complete() call to XXXX_aborted_task(), we run into trouble because what core expects from fabric handlers is different:
> 1) If core calls XXXX_queue_tm_rsp(), then fabric has to release one ref count only if SCF_ACK_REF is set. Otherwise it must not.
> 2) If core calls XXXX_aborted_task(), then fabric must not release ref count, no matter whether SCF_ACK_REF is set.

Maybe we agree.

I was calling #2 a cmd lifetime issue. At least loop, xen and iscsi think they can access the cmd after aborted_cmd. For loop/xen we just don't hit it, because we hit #1 first. For iscsi we are.

> 
> So I decided for my patch to no longer use TARGET_SCF_ACK_KREF, since then we can handle both situation the same way.
> After that it was a short step to move the data fields used by the thread after wakeup() from tl_cmd to stack, because then the woken up theqard has no need to access tl_cmd, which can be freed meanwhile.
> 
> I think, the same way to fix the problem would be fine for xen also, but I'm still wondering why the thread there does not call target_put_sess_cmd, but calls transport_generic_free_cmd.

For xen and #1 and #2 I agree we can do a similar fix as you did for xen.

I would really like to figure out if #2 is a regression and understand what happened so we don't make the same mistake again and also fix iscsi. The problem with iscsi though is every couple kernels has a bug in this code path so git bisect is being a pain.
