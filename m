Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EFBC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF4420738
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:40:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="rA7G+zTi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgGMLkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 07:40:12 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.115]:38483 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgGMLkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 07:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594640409; i=@ts.fujitsu.com;
        bh=zX8aArxIPWFWC1A4AX3KP2qqMpq3f5jMdIZ5wsPRAF0=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=rA7G+zTiGMBqKN2PdCymWU7z2/X5qcrSe2U+D6QiDZBoAAZAGXlEffI6BuaQvK8na
         tpvpos2CJkKZSe4m5esQiEMX9PliArNnpSLbn2HKDbmfYq2NBHlfAhM61M8FA8R33C
         GlzMEa+yzkyh05SyGxUhFXkgwK8f6cZuibUC40Cpj8XPru0/AZjdRkTYyEKbj7wYvp
         n1JfWgpc1c8CDnLdArcBPPCboV4wRsv7Sw4aMmzOpcP+OHzhsEnkE60Lpj7EusRzj0
         3u5Ggiof80sDyF7VFnOGDh1tw+hNU/XDcKfV6K/DyFhoHcSlCwAybuUvA4JU4vftOJ
         2JyvlwoDeu+aw==
Received: from [100.113.4.20] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-central-1.aws.symcld.net id AC/75-24114-9184C0F5; Mon, 13 Jul 2020 11:40:09 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRWlGSWpSXmKPExsViZ8MxVVfCgyf
  e4OpsM4vu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxoqP59kK
  rihVzPu3hKWB8atcFyMXh5DAZEaJrd17mCGcfkaJlV+vAzmcHMICbhLfXi1gB0mICKxhlFj0e
  ikTRNVSRon9p96xglSxCRhIrJh0nwXE5hVwlGjb+YsRxGYRUJV4euo8WxcjB4eoQLjEsxX+EC
  WCEidnPgEr5xSwk5jw/hbYMmYBM4l5mx9C2eISt57MZ4KwtSWWLXzNPIGRbxaS9llIWmYhaZm
  FpGUBI8sqRoukosz0jJLcxMwcXUMDA11DQ2NdMyBLL7FKN0kvtVQ3OTWvpCgRKKmXWF6sV1yZ
  m5yTopeXWrKJERjQKYVsXDsYn77+oHeIUZKDSUmU944mT7wQX1J+SmVGYnFGfFFpTmrxIUYZD
  g4lCd5VrkA5waLU9NSKtMwcYHTBpCU4eJREeBvdgNK8xQWJucWZ6RCpU4yKUuK8CSAJAZBERm
  keXBssoi8xykoJ8zIyMDAI8RSkFuVmlqDKv2IU52BUEub9DjKFJzOvBG76K6DFTECLef5xgiw
  uSURISTUwTS9L/rXzx1L3uWp/mRRuvrE4/2Ni5T6LklvG6r8bLt45E7t0evU7f1vu/1l7dt6d
  tT711XIDgdN/9lycteDARnuhO2kJwdLTl1+6VL30dWpJ8t+aGS/PHftzxX77hpbHBnd1an9K7
  L8R4n98sopd5Tzv7c/tiqefipE3tHLYpGb2Nsp2R5DypdR/UesnLT6/46uX/UoFReV/bcd6DB
  l28mXrTDXqTnv/XaR5c3X+rZ4JAlNMeW/73mKd8WTtnOVhpx3lba5lXsm/9/my7S++NyvWGr+
  aoLavYfHM6z/+dTAeeq9Ym3N8lSFXo/wbD7N3Duqnfd++SbEWfXM+ZWqQAO9WtbXiMTErxSde
  WqZ4OeeqEktxRqKhFnNRcSIALwGGQWMDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-28.tower-248.messagelabs.com!1594640408!182167!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 6144 invoked from network); 13 Jul 2020 11:40:08 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-28.tower-248.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 13 Jul 2020 11:40:08 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06DBe7qR009502;
        Mon, 13 Jul 2020 12:40:08 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 05C7D20489;
        Mon, 13 Jul 2020 13:40:06 +0200 (CEST)
Subject: Re: [PATCH 2/8] scsi: target: Add tmr_notify backend function
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-3-bstroesser@ts.fujitsu.com>
 <5c163079-563c-e3e5-2a9c-478a310bd022@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <1cd113df-1140-5148-c41c-541e4d2ce1b9@ts.fujitsu.com>
Date:   Mon, 13 Jul 2020 13:40:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <5c163079-563c-e3e5-2a9c-478a310bd022@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-12 01:27, Mike Christie wrote:
> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
>> Target core is modified to call an optional backend
>> callback function if a TMR is received or commands
>> are aborted implicitly after a PR command was received.
>> The backend function takes as parameters the se_dev, the
>> type of the TMR, and the list of aborted commands.
>> If no commands were aborted, an empty list is supplied.
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> ---
>> =C2=A0 drivers/target/target_core_tmr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 16 +++++++++++++++-
>> =C2=A0 drivers/target/target_core_transport.c |=C2=A0 1 +
>> =C2=A0 include/target/target_core_backend.h=C2=A0=C2=A0 |=C2=A0 2 ++
>> =C2=A0 include/target/target_core_base.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 1 +
>> =C2=A0 4 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_tmr.c=20
>> b/drivers/target/target_core_tmr.c
>> index b65d7a0a5df1..39d93357db65 100644
>> --- a/drivers/target/target_core_tmr.c
>> +++ b/drivers/target/target_core_tmr.c
>> @@ -116,6 +116,7 @@ void core_tmr_abort_task(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct se_tmr_req *tmr,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct se_session *se_sess)
>> =C2=A0 {
>> +=C2=A0=C2=A0=C2=A0 LIST_HEAD(aborted_list);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct se_cmd *se_cmd, *next;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long flags;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool rc;
>> @@ -144,7 +145,7 @@ void core_tmr_abort_task(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rc)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 continue;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del_init(&se_cmd->sta=
te_list);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_move_tail(&se_cmd->st=
ate_list, &aborted_list);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 se_cmd->state_a=
ctive =3D false;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irq=
restore(&dev->execute_task_lock, flags);
>> @@ -157,6 +158,11 @@ void core_tmr_abort_task(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) <
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dev->transport->tmr_no=
tify)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
v->transport->tmr_notify(dev, TMR_ABORT_TASK,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 &aborted_list);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del_init(&se_cmd->sta=
te_list);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 target_put_cmd_=
and_wait(se_cmd);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk("ABORT_T=
ASK: Sending TMR_FUNCTION_COMPLETE for"
>> @@ -167,6 +173,9 @@ void core_tmr_abort_task(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&dev->execute_ta=
sk_lock, flags);
>> +=C2=A0=C2=A0=C2=A0 if (dev->transport->tmr_notify)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->transport->tmr_notify=
(dev, TMR_ABORT_TASK, &aborted_list);
>=20
> Is this needed? It seems like the backend can't do anything because=20
> there isn't enough info.
>=20
> I saw in tcmu_tmr_notify it looks when then happens we can still do=20
> queue_tmr_ring, but there would be no commands. Was that intentional?

Yes, it is intentional. I see two purposes for backend tmr notification:

1) Allow backend (userspace) to cancel long running command execution if
    possible, which then makes the core more 'responsive' to TMRs

2) Tracing. If a userspace device emulation does tracing, it would be
    good to see an ABORT_TASK in trace even if core does not find the
    aborted cmd. The reason for this e.g. can be, that userspace and tcmu
    complete a command while initiator times out and sends ABORT_TASK.
    In that case ABORT_TASK in trace is helpful, because initiator will
    not accept the command completion but start some error handling.
    Without the ABORT_TASK entry the trace would not show the reason for
    error handling.
