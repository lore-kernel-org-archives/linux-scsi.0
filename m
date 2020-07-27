Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29E6C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44A08208E4
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="IelngzuU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbgG0O01 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:26:27 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.113]:40833 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732592AbgG0O0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Jul 2020 10:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595859981; i=@ts.fujitsu.com;
        bh=4E27zNem+Z9EGkXpiHjf/1zOwy1imGa6yfZ6czr2aGA=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=IelngzuUlVzfTNtAGVr4xqibdaV+nG6aUVdczneiZMW3cCzfxODZcsTEHdrlPVN3A
         EghQXut3iOcE8mwmtdPfRbnpe7qyGxY42aclgfl6681Xoz5e8Y0n3yXyfeWfAY+V49
         6rtTs1VFQbQz5XA2n/Jw66oyGkiLhwjXUT30osjuzCrFB6d5816OlVSHEiLD/xv4Yn
         Qfb8BfVqu6HZNepU2gI6KR29i/HSVfls1wNxlD7s0kwowPxY8Qd9cUXbQd7gxDQFk6
         JiiV4Yb48PL9ZQ/SmW6qpPcwpsG2ot8Lbhyu6TvDY1rB3nvgVQkxi+70Aw7od7I1Ym
         BD/8oGXk9/pxw==
Received: from [100.113.7.116] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-central-1.aws.symcld.net id B1/C2-35251-D04EE1F5; Mon, 27 Jul 2020 14:26:21 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRWlGSWpSXmKPExsViZ8MxVZfniVy
  8wYL7lhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjCs3JjEW
  PJWpuHTzPWMDY49YFyMXh5DAZEaJjj+32CCcfkaJzuanjF2MnBzCAq4Sq9ddZwFJiAisYZRY9
  HopE0TVbUaJO4t2s4BUsQkYSKyYdB/M5hVwlNj4vY8NxGYRUJW4fn0b0CQODlGBcIlnK/whSg
  QlTs58AlbOKWAnsW7pXFYQm1lAXeLPvEvMELa4xK0n85kgbHmJ7W/nME9g5JuFpH0WkpZZSFp
  mIWlZwMiyitEiqSgzPaMkNzEzR9fQwEDX0NBY10zXwlwvsUo3SS+1VDc5Na+kKBEoqZdYXqxX
  XJmbnJOil5dasokRGNAphWzhOxjPvP6gd4hRkoNJSZT332K5eCG+pPyUyozE4oz4otKc1OJDj
  DIcHEoSvEoPgXKCRanpqRVpmTnA6IJJS3DwKInwWj8CSvMWFyTmFmemQ6ROMepyXL4+bxGzEE
  tefl6qlDivLUiRAEhRRmke3AhYpF9ilJUS5mVkYGAQ4ilILcrNLEGVf8UozsGoJMw7G+QSnsy
  8ErhNr4COYAI6ovG4LMgRJYkIKakGppn/ytKmOk6OyJijcW+Ga86zNdts/3D85Ig7oevpE1T9
  S6G3jPVGRkKpz2K5N5UyJq5X7bqy+6+b1SRP/i2m9ntH+MSszpN5/xtfTL3/N212/80tveqdL
  2L22+6JVH3NdmiOt2NXwdHOxd5RQicDfn0SuNdfl8sQmavaLa/TtP/E1IpJs3rdeGP87xdeN5
  izu7+u8Mrpsgg/qXubIq6L2Ndrt1sr3ytX+PG/5HTN22/tC1nbUyzuP3ELjDu8c9nt7TkNSsJ
  /7VeYl2lZ5Vs6bur2Yn3ZIt21mYt9BfNN1ZMT1mqnWh7fvm5dzZOAkMfJ/88fPf1i+vqlQpxL
  HSvEdq+LW3/q9rOt1WoSN1ZvVGIpzkg01GIuKk4EAHDDHnpvAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-20.tower-248.messagelabs.com!1595859980!272158!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 25483 invoked from network); 27 Jul 2020 14:26:20 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-20.tower-248.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 27 Jul 2020 14:26:20 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06REQDK1028624;
        Mon, 27 Jul 2020 15:26:13 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 26B50201DA;
        Mon, 27 Jul 2020 16:26:09 +0200 (CEST)
Subject: Re: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
 <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
 <2694d1fc-8792-0fe2-4dec-78f15d3b4ec5@ts.fujitsu.com>
 <90048ea8-3b8f-cc06-7869-dca645cd68f2@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <7c2d8052-fb5e-0a3b-a894-df8bfab44f21@ts.fujitsu.com>
Date:   Mon, 27 Jul 2020 16:26:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <90048ea8-3b8f-cc06-7869-dca645cd68f2@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-26 20:37, Mike Christie wrote:
> On 7/26/20 6:02 AM, Bodo Stroesser wrote:
>> On 2020-07-26 07:16, Mike Christie wrote:
>>> On 7/15/20 11:04 AM, Bodo Stroesser wrote:
>>>> Fix:
>>>> After calling the aborted_task callback the core immediately
>>>> releases the se_cmd that represents the ABORT_TASK. The woken
>>>> up thread (tcm_loop_issue_tmr) therefore must not access se_cmd
>>>> and tl_cmd in case of aborted TMRs.
>>>
>>> The code and fix description below look ok. I didn't get the above part though. If we have TARGET_SCF_ACK_KREF set then doesn't the se_cmd and tl_cmd stay around until we do the target_put_sess_cmd in tcm_loop_issue_tmr?
>>
>> No. For an aborted ABORT_TASK, target_handle_abort is called.
>> If tas is not set, it executes this code:
>>
>>          } else {
>>                  /*
>>                   * Allow the fabric driver to unmap any resources before
>>                   * releasing the descriptor via TFO->release_cmd().
>>                   */
>>                  cmd->se_tfo->aborted_task(cmd);
>>                  if (ack_kref)
>>                          WARN_ON_ONCE(target_put_sess_cmd(cmd) != 0);
>>                  /*
>>                   * To do: establish a unit attention condition on the I_T
>>                   * nexus associated with cmd. See also the paragraph "Aborting
>>                   * commands" in SAM.
>>                   */
>>          }
>>
>>          WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);
>>
>>          transport_lun_remove_cmd(cmd);
>>
>>          transport_cmd_check_stop_to_fabric(cmd);
>>
>> That means: no matter whether SCF_ACK_REF is set in the cmd or not:
>> 1) fabric's aborted_task handler and a waiter woken up by aborted_task must not call target_put_sess_cmd.
>> 2) a waiter woken up by aborted_task() must not access se_cmd (or tl_cmd) since target_handle_abort
>>     might have released it completely meanwhile.
>>
> 
> Oh no, so xen has the same cmd lifetime issue as loop right?

To me it looks like xen uses nearly the same code like tcm_loop did before my patch.
There is nothing wrong with that code regarding the cmd lifetime.
The problem instead is, that the thread which started a TMR (ABORT_TASK) will sleep forever if that TMR itself is aborted by a further TMR (LUN_RESET).
This is because tcm_loop_aborted_task() misses the complete() call.
 
But if we just add the complete() call to XXXX_aborted_task(), we run into trouble because what core expects from fabric handlers is different:
1) If core calls XXXX_queue_tm_rsp(), then fabric has to release one ref count only if SCF_ACK_REF is set. Otherwise it must not.
2) If core calls XXXX_aborted_task(), then fabric must not release ref count, no matter whether SCF_ACK_REF is set.

So I decided for my patch to no longer use TARGET_SCF_ACK_KREF, since then we can handle both situation the same way.
After that it was a short step to move the data fields used by the thread after wakeup() from tl_cmd to stack, because then the woken up theqard has no need to access tl_cmd, which can be freed meanwhile.

I think, the same way to fix the problem would be fine for xen also, but I'm still wondering why the thread there does not call target_put_sess_cmd, but calls transport_generic_free_cmd.

> 
> And, it looks like iscsi has an issue too. I can hit both of those WARNs.
> 
> I'm ok with your patch, but is there a way to fix this in core for everyone?
> 
> It seems like something that must have worked at some point for everyone, but we broke. I'll try to get some time today and git bisect this to see if it's a regression.
> 

I'm wondering whether aborting an Abort ever was tested at least for these drivers.
