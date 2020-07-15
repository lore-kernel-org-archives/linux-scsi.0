Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4390EC433F7
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 15:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AF2F20658
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 15:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="pMCZBLD6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgGOPIX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 11:08:23 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.116]:11028 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728258AbgGOPIX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jul 2020 11:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594825699; i=@ts.fujitsu.com;
        bh=+aWXyOKNNKHS06EuFEiaWqOjbis73NHLsKzghyqTnyY=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=pMCZBLD61SuzNdopXsJ2LTXwPxTPswOO281mCNsLrT5vbFLEY5beO6KiBP7Q6zTnc
         WsnGaIndgkQHoIM5IlUAeKTShMagixmysC2ZZeaICXbyY5bHEv8pVudUlukKsaSerE
         R32tmSbnt4/dZHOam6h+v7GaKuj0xF9/jKfzt49jzNB1eqI8KQcEU2KdPdbK5Jwuaj
         77UmTyXrTBbTSW+XadQ9hienajg8d6UKxcUKPGZWDcvgPoAldQf1smEsqt8i4NgcME
         yMyySyzTNyXA5EBDZ95LRiRj2j4RAJ47DtqoUR7LkhALVa2kbF7Nxkmk33VspAuyBm
         sMmpj1Pm81b8Q==
Received: from [100.113.4.243] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-b.eu-central-1.aws.symcld.net id 02/53-08547-2EB1F0F5; Wed, 15 Jul 2020 15:08:18 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRWlGSWpSXmKPExsViZ8MxVfeRNH+
  8wZH7mhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjGPv97MW
  9CpWbNnQzt7A+Fe6i5GLQ0hgMqPEijlH2CGcfkaJswc3sXUxcnIIC3hJrPk7hw0kISKwhlFi0
  eulTFBVTBLLLt0Bq2ITMJBYMek+C4jNK+AoMWtJB5DNwcEioCox45YsiCkqEC7xbIU/RIWgxM
  mZT8CqOQXsJDZN+MYKYjMLmEnM2/yQGcIWl7j1ZD4ThK0tsWzha+YJjHyzkLTPQtIyC0nLLCQ
  tCxhZVjFaJhVlpmeU5CZm5ugaGhjoGhoa65rrGhoZ6iVW6SbppZbqJqfmlRQlAmX1EsuL9Yor
  c5NzUvTyUks2MQIDOqWQvXIH49o3H/QOMUpyMCmJ8kYw88cL8SXlp1RmJBZnxBeV5qQWH2KU4
  eBQkuDdLQmUEyxKTU+tSMvMAUYXTFqCg0dJhPc4SJq3uCAxtzgzHSJ1ilFRSpx3jRRQQgAkkV
  GaB9cGi+hLjLJSwryMDAwMQjwFqUW5mSWo8q8YxTkYlYR5q0Gm8GTmlcBNfwW0mAlo8cbPvCC
  LSxIRUlINTIu6dANdKoqf/4/RyxO51PivRu2yask2l2WPLZ2WnDnt/njqtPtZhvJBEqe+tr/e
  bZ0vOjul2CBIx+Kch2ka+5bVTMvSDXlubxM4M+18MVfk413PLh7O2+x55V3H/hDrQv9GYHytt
  9c6edj9UErWkvmqr/xPf60+KvFmXeZEweqYd8Vsyi/dLY9fSf4f8GjzsSmb1Wav14gOUFTXmL
  +vXsdp2nkO5Zy5F96sN1l6stHNUTu25OMNx51Kt4/ILny0VijpgsqPf1syvDZrflj6weg6Q0J
  Ryao8+Wf8Xg/jfFuzjr2RSq2Zf2ju/4U/WdceqKs59VqPfdsDu7XvNj94JfXW8bly5KYCV/em
  U0bzcpRYijMSDbWYi4oTAaCdcrhjAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-18.tower-238.messagelabs.com!1594825698!646500!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 26417 invoked from network); 15 Jul 2020 15:08:18 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-18.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 15 Jul 2020 15:08:18 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06FF8C9Q032372;
        Wed, 15 Jul 2020 16:08:12 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 01E1820375;
        Wed, 15 Jul 2020 17:08:11 +0200 (CEST)
Subject: Re: [PATCH 7/8] scsi: target: tcmu: Implement tmr_notify callback
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
 <24d9afb0-3ea9-e83b-acf0-b44f04583a6e@oracle.com>
 <b8bb9898-6ff8-2ffb-47d6-d96534c6d315@ts.fujitsu.com>
 <a32b8b9e-c993-6709-b71e-3fbf80d0bdf3@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <53776e18-675a-3eea-4be8-703433a247dd@ts.fujitsu.com>
Date:   Wed, 15 Jul 2020 17:08:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <a32b8b9e-c993-6709-b71e-3fbf80d0bdf3@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-14 20:10, Mike Christie wrote:
> On 7/13/20 7:03 AM, Bodo Stroesser wrote:
>> On 2020-07-12 03:15, Mike Christie wrote:
>>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
>>

...

>>>> +struct tcmu_tmr_entry {
>>>> +=C2=A0=C2=A0=C2=A0 struct tcmu_cmd_entry_hdr hdr;
>>>> +
>>>> +#define TCMU_TMR_UNKNOWN=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0
>>>> +#define TCMU_TMR_ABORT_TASK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 1
>>>> +#define TCMU_TMR_ABORT_TASK_SET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 2
>>>> +#define TCMU_TMR_CLEAR_ACA=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 3
>>>> +#define TCMU_TMR_CLEAR_TASK_SET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4
>>>> +#define TCMU_TMR_LUN_RESET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 5
>>>> +#define TCMU_TMR_TARGET_WARM_RESET=C2=A0=C2=A0=C2=A0 6
>>>> +#define TCMU_TMR_TARGET_COLD_RESET=C2=A0=C2=A0=C2=A0 7
>>>> +/* Pseudo reset due to received PR OUT */
>>>> +#define TCMU_TMR_LUN_RESET_PRO=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 128
>>>> +=C2=A0=C2=A0=C2=A0 __u8 tmr_type;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 __u8 __pad1;
>>>> +=C2=A0=C2=A0=C2=A0 __u16 __pad2;
>>>> +=C2=A0=C2=A0=C2=A0 __u32 cmd_cnt;
>>>> +=C2=A0=C2=A0=C2=A0 __u64 __pad3;
>>>> +=C2=A0=C2=A0=C2=A0 __u64 __pad4;
>>>> +=C2=A0=C2=A0=C2=A0 __u16 cmd_ids[0];
>>>> +} __packed;
>>>> +
>>>
>>> Is this new request and the tmr_notify callback just supposed to=20
>>> clean up the requested commands or is it supposed to perform the=20
>>> actions of the task management function defined in the specs?
>>>
>>> The callback name makes it feel like it's just a notification, but=20
>>> the names above make it seem like we are supposed to execute the TMF=20
>>> in userspace. But if the latter, then how do we notify the kernel if=20
>>> the TMF was successful or failed?
>>
>> My plan is to have a notification only. IMHO userspace (and also tcmu
>> or another backend) must not interfere with core's TMR handling.
>> The new callback tmr_notify just allows backend to be helpful during
>> TMR handling by completing in core aborted, but in backend/userspace
>> still running commands early.
>>
>> Do you refer to the TCMU_TMR_* definitions? I just defined these names
>> because TMR_* definitions are in target_core_base.h which is not expos=
ed
>> to userspace programs. Knowing the type of TMR that aborted a command =
is
>> useful at least for userspace tracin
>=20
> I see where you are going. Makes sense to me now.
>=20
>>
>> BTW: I hope there are enough padding fields in the tcmu_tmr_entry to
>> allow additional session info later?
>=20
> Yes.
>=20
> One question on that. Were you going to use the tcmu_cmd_entry_hdr=20
> flags, or add a flag field to tcmu_tmr_entry?

The header has a flag field, tcmu_cmd_entry has not. So I didn't
give tcmu_tmr_entry a flags field.
We already use the header's uflags for the flag that tells tcmu that
user defined an explicit length for data transfer to initiator.
So, if a new flag is necessary I'd prefer to use header's kflags.

>=20
> Or will userspace just know its enabled because we would eventually add=
=20
> a add/delete session callback to the backend modules. And from the add=20
> callout, we would then notify userspace of the new session and that=20
> other commands like tcmu_tmr_entry have session info in it.
>=20

It is still not completely clear to me how you want to send session info
to userspace. I assume session id will be written into a renamed padding
field in cmd and tmr. That would be compatible to old userspace tools.
Since session IDs start at 1, new userspace can easily see that there is
a valid session ID.

If userspace finds a session id it not knows yet, it could retrieve
session info from sysFS or configFS.

But even then at least if a session is removed I think we will need a
new tcmu_XXXXX_entry type telling userspace which session ID now is
invalid.
Therefore I assume that a new attribute in configFS is needed to switch
on the per default deactivated session ID notification. Otherwise
existing userspace tools might print errors or even exit if they see an
entry type they don't know.
If userspace via configFS attribute can switch session info on and off,
there probably is no need for flags, right?
