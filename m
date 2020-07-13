Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF008C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6758820738
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="iFgEYllp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgGMLkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 07:40:02 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.66]:26131 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgGMLkB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 07:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594640398; i=@ts.fujitsu.com;
        bh=f4srhP4U9GABtp1CD62zzExbCAkNU1XzTZIhEJIl6qI=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=iFgEYllpIjwaSE/5ZBwAGTugFQ3XZ/mREOgEO3bQtsDwoDNTl2dcH7ac8WQBF0T9U
         85utjhIACA5/LZkQLdJYLJBi02thHr9goNrc5roXHH/C6yX4XN+pO2rhHxyaSrU5Mu
         BqeCe3nuJGPDuF6NBnUYWG5p7vUxb59NA4nQRpAHdBOjiLhK++2ZL4HK53jR1naTmI
         u8+jJSatOjG11Td54LDNRAHMWQ047+sumddruedpk/jmeznvvBcnF7d5m7Zo1Xh32C
         F+oJl29BnSNllBIiUoQAlc/QfgVUsf8zAspYhoGa04nUCXYFGP53qDevdlPA9nSDym
         DfbwAvkfOJqfw==
Received: from [100.112.197.40] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-west-1.aws.symcld.net id D7/97-29177-E084C0F5; Mon, 13 Jul 2020 11:39:58 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRWlGSWpSXmKPExsViZ8MRqsvnwRN
  vcPsTr0X39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE1Y92FJsaC
  h9IV5+/eZWtg/CjRxcjFISQwmVGi53QDK4TTzyjx5vtRxi5GTg5hAWeJOdves4EkRATWMEose
  r2UCaJqKaNEU/c5dpAqNgEDiRWT7rOA2LwCjhK3uzeDxVkEVCX2PnsMNImDQ1QgXOLZCn+IEk
  GJkzOfgJVzCthJTPm6hQ3EZhYwk5i3+SEzhC0ucevJfCYIW1ti2cLXzBMY+WYhaZ+FpGUWkpZ
  ZSFoWMLKsYrRIKspMzyjJTczM0TU0MNA1NDTSNbQ01zU0NtdLrNJN0kst1S1PLS7RNdRLLC/W
  K67MTc5J0ctLLdnECAzolIKjnTsYf736oHeIUZKDSUmU944mT7wQX1J+SmVGYnFGfFFpTmrxI
  UYZDg4lCd5VrkA5waLU9NSKtMwcYHTBpCU4eJREeBvdgNK8xQWJucWZ6RCpU4yKUuK8CSAJAZ
  BERmkeXBssoi8xykoJ8zIyMDAI8RSkFuVmlqDKv2IU52BUEubtAdnOk5lXAjf9FdBiJqDFPP8
  4QRaXJCKkpBqYGPlMd2jb5Ks9fSwlW/8256D1g488KeWuVQ0ZlboeiluUZY5MXCr6r5/dtfnU
  xuO33ZmLZkUanlj0aU605f4N++ZVm366t6nh88TnfHFs5anT3CYKx6rLflF8/SPi3ZG2ioUTF
  d037NjEvXpL0JHDO/y/bI543bq5l+fEtI9v7aME6ycc7l4c93t/8ZS2TZOvr4kPX2FTJ1HgLL
  jaYqGBxJGU2vTUNWfsDi+XUT5quvn0+rnf5+7oNZ2/QHHy+pfOrxeEbAz/dJUx9K9Zy9SMwpU
  77/bt6elr12u+sNhPzL+XS+uD+/T6FxpCjq36c3bPzvylV+94r+0vc/x2th9X152eKjZtce+t
  PgsH1ujtb5VYijMSDbWYi4oTAf5fPmRjAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-27.tower-287.messagelabs.com!1594640397!1066295!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 18987 invoked from network); 13 Jul 2020 11:39:58 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-27.tower-287.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 13 Jul 2020 11:39:58 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06DBdpEX025726;
        Mon, 13 Jul 2020 12:39:51 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 28EBF20489;
        Mon, 13 Jul 2020 13:39:47 +0200 (CEST)
Subject: Re: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
 <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <0f660dc9-40ee-75a4-2924-761769d9cd38@ts.fujitsu.com>
Date:   Mon, 13 Jul 2020 13:39:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-12 02:49, Mike Christie wrote:
> On 7/10/20 5:48 AM, Bodo Stroesser wrote:

...

>> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk("ABORT_T=
ASK: Found referenced %s task_tag: %llu\n",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 se_cmd->se_tfo->fabric_name, ref_tag);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!__target_check_io_sta=
te(se_cmd, se_sess,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dev->dev_attrib.emulate_tas))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irqsave(&se_sess=
->sess_cmd_lock, flags);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D __target_check_io_s=
tate(se_cmd, se_sess, 0);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&se=
_sess->sess_cmd_lock, flags);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rc)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 continue;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&se=
_sess->sess_cmd_lock, flags);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del_init(&se_cmd->sta=
te_list);
>=20
> Do we only want to do this if in the next patch tmr_notify can=20
> successfully accept the tmr?

This change does not modify behavior of the core. Please see how
core_tmr_drain_state_list() uses state_list to queue commands after
successfully calling __target_check_io_state() for later call of=20
target_put_cmd_and_wait().

This patch just unifies ABORT_TASK and LUN_RESET handling such,
that in next patch we can call tmr_notify handler with a list of
aborted commands in both cases. The list uses the state_list list_head
in the se_cmd.

>=20
> If tmr_notify can't allocate memory for the abort case, we would delete=
=20
> it from the list. Later the initiator would send a LUN_RESET but=20
> core_tmr_drain_state_list won't see it and pass it to the tmr_notify ca=
ll.
>=20

tmr_notify handler will not and must not modify the list of aborted
cmds. So if backend just does nothing for whatever reason we will end
up with the "old" behavior of the core as it was before the change.

The general idea is to send info about received TMRs together with the
list of aborted commands to the backend, to allow TMR tracing and
canceling of aborted commands. But backend must not interfere with TMR
processing in core.

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 se_cmd->state_active =3D f=
alse;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&de=
v->execute_task_lock, flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Ensure =
that this ABORT request is visible to the LU RESET
>> @@ -159,7 +165,7 @@ void core_tmr_abort_task(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_long_inc=
(&dev->aborts_complete);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&se_sess->sess_cmd_lock, fl=
ags);
>> +=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&dev->execute_task_lock, fl=
ags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk("ABORT_TASK: Sending TMR_TASK_DO=
ES_NOT_EXIST for ref_tag:=20
>> %lld\n",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 tmr->ref_task_tag);
>>
>=20
