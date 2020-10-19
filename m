Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F74BC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 16:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD9E52225F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 16:11:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZYkHezS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgJSQLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:11:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730364AbgJSQLE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 12:11:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JGA7jo126106;
        Mon, 19 Oct 2020 16:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=KXxPK0aRVUZQbopw1EVZgGlj1CDSCUcsJ5ShTzUI//U=;
 b=ZYkHezS8rtJV0I4laSJYfU5OOmcNyAsTaWpw8V7EEbkeRhbOq6cugIqryhBGBugOS40y
 DDMgObHAHkSOz7w+Bqwu7V0dBOUwQhS+w4iTdrZZGrz/BX1u6abc63DmdLa95d+LFp03
 xhgdZE6BbwGqKtv/PjS1gM0FurUM5hvfNMu9Z5tHlapiicDL3gcMDe+GAOVN8g5eJP57
 bE3Xtlqw3wNq2/5imiW+Dx2CHdjZeph6uwLIPwo/md+fNiPuMFmP74rmFiPXZgrbeg8E
 ji70nmCC7ArLCt4QGIliZD91qM2wDMXnlMA2Yza5d/eZEPIkQ+ZQiEnu9xH9Gx+YJAfA qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 347s8mpbkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 16:10:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JG9X4S108465;
        Mon, 19 Oct 2020 16:10:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 348agwav66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 16:10:55 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09JGAre2006498;
        Mon, 19 Oct 2020 16:10:53 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 09:10:52 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
Date:   Mon, 19 Oct 2020 11:10:51 -0500
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 19, 2020, at 5:47 AM, Muneendra Kumar M =
<muneendra.kumar@broadcom.com> wrote:
>=20
> Hi Mike,
> Thanks for the review.
>=20
>>> +fc_remote_port_chkready(struct fc_rport *rport, struct scsi_cmnd
>>> +*cmd)
>>> {
>>> 	int result;
>>>=20
>>> 	switch (rport->port_state) {
>>> 	case FC_PORTSTATE_ONLINE:
>>> +	case FC_PORTSTATE_MARGINAL:
>>> 		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
>>> 			result =3D 0;
>>> 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
>>>  			result =3D DID_IMM_RETRY << 16;
>>>  		else
>>>  			result =3D DID_NO_CONNECT << 16;
>>> +
>>> +		if (cmd)
>>> +			fc_rport_chkmarginal_set_noretries(rport, cmd);
>=20
>> I was just wondering why don't you do drop all the =
SCMD_NORETRIES_ABORT
>> code and then in this function when you check for the marginal state =
do:
>=20
>> result =3D DID_TRANSPORT_MARGINAL;
>=20
> ?
> [Muneendra] Correct me if my understanding is correct?
> You mean to say ,if the SCMD_NORETRIES_ABORT is set end up failing the =
IO
> with DID_TRANSPORT_MARGINAL instead of retry?

Sort of. I was saying to just drop the SCMD_NORETRIES_ABORT related code
and when you detect the port state here fail the IO.

> I assume that your below point 3 talks the same.
> Let me know if this is correct.
>=20
>> So you would do:
>=20
>> 1. Userspace calls in scsi_transport_fc and sets the port state to
>> marginal.
> 2. New commands would see the above check and complete the command =
with
> DID_TRANSPORT_MARGINAL.
> [Muneendra]Correct me if my understanding is right.
> You mean to say if the port_state is set to marginal return all the =
new
> commands with DID_TRANSPORT_MARGINAL  (without checking
> SCMD_NORETRIES_ABORT)?

Yes.

>=20
> If yes then below are my concerns
> In marginal state  what we want is the ios to be attempted at least =
once .
>=20
> In marginal state we cannot drop all the commands as one of the =
concern we
> have is if a target is non-mpio based targets then we will be dropping =
it
> without any attempt.
> With this we will be even dropping the TUR commands also which =
unnecessarily
> lead to error handling.
>=20

I=E2=80=99m a little confused. In the 0/17 email you wrote:

-----

This feature is intended to be used when the device is part of a =
multipath
environment. When the service detects the poor connectivity, the =
multipath
path can be placed in a marginal path group and ignored further io
operations.

After placing a path in the marginal path group,the daemon sets the
port_state to Marginal which sets bit in scmd->state for all the

=E2=80=94=E2=80=94

So it sounded like this is would only be used for mpio enabled paths.

Is this the daemon you mention in the 0/17 email:

https://github.com/brocade/bsn-fc-txptd

?

I might be completely misunderstanding you though. If the above link
is for your daemon then going off the 0/17 email and the GitHub README =
it
sounds like you are doing:

1. bsn-fc-txptd gets ELS, and moves affected paths to new marginal path =
group.
2. The non-marginal paths stay in the active path group and are =
continued to
be used like normal.
3. The paths in the marginal path group are not used until we get link =
up
or another ELS that indicates the paths are ok.

For these outstanding IOs on marginal paths, it sounds like you are =
flushing
the existing IO on them.mOnce they complete they will be in the marginal =
group
and not be used until #3.

So it=E2=80=99s not clear to me if you know the path is not optimal and =
might hit
a timeout, and you are not going to use it once the existing IO =
completes why
even try to send it? I mean in this setup, new commands that are =
entering
the dm-multipath layer will not be sent to these marginal paths right?

Also for the TUR comment, what TUR do you mean exactly? =46rom the SCSI =
EH?
=20




