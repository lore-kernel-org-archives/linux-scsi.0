Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18036C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 15:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A644620709
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 15:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="le697LDc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgKKPkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 10:40:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43104 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgKKPkC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 10:40:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABFTuou150237;
        Wed, 11 Nov 2020 15:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=MopS1gwampwykUMKeb9UTbpg3b/6Y2gJppNi5Is+Bdw=;
 b=le697LDcuPU+0/cBHfAK6r3f1OIN4I/Agsk8u2nsa6mNqX4dyK3mZEcqBKCIMmiv0U0H
 LnbNmfN8AVQT39BPJ6sxK21y1lWzA+bCyJN58Zt1IDjGL5BdfyYoeygsQuU51rOMdVVX
 MHAMEktAG+jI284hRlzF01CYrDgjJtUuNS6657Ll+3dbmwiuYdxknBH2tE+pbN+o8AqP
 w4/d3TpkWX5c9u4Q4Iz/PUPcQXqL9zJEynisDuK/qJKw5GHku1EPbzADLoBW6CIyZLec
 O5J2Sefd8g1NORiLUwl6qCbTelVpPd0k+6pQ1fF7GEQs3j3GcbyVCmz9rXlI/rnmdNt1 vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b1p3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 15:39:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABFVAEO135620;
        Wed, 11 Nov 2020 15:37:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp8e40y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 15:37:55 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ABFbqgq032767;
        Wed, 11 Nov 2020 15:37:52 GMT
Received: from dhcp-10-154-184-108.vpn.oracle.com (/10.154.184.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Nov 2020 07:37:52 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a
 task
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <5111dcb0-ef0d-fc11-ee1a-ae2a9b30150a@redhat.com>
Date:   Wed, 11 Nov 2020 09:37:51 -0600
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org, m.lombardi85@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D26782D-1249-4A2C-8BF9-7176D5B85F55@oracle.com>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
 <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
 <5111dcb0-ef0d-fc11-ee1a-ae2a9b30150a@redhat.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=11 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=11
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 11, 2020, at 8:58 AM, Maurizio Lombardi <mlombard@redhat.com> =
wrote:
>=20
>=20
>=20
> Dne 11. 11. 20 v 3:16 Mike Christie napsal(a):
>> Hey, I tested this out and I do not think this will happen. We will =
get stuck waiting on the TMF completion for the affected cmd/cmds.
>>=20
>> In conn_cmd_list we would have [CMD1 -> ABORT TMF]. Those cmds get =
moved to the tmp list. It might happen where CMD1's CMD_T_ABORTED bit is =
set, and iscsit_release_commands_from_conn will would put it back onto =
the conn_cmd_list. But then it will see the ABORT on the list. We will =
then wait on the ABORT in:
>>=20
>> iscsit_release_commands_from_conn -> iscsit_free_cmd -> =
transport_generic_free_cmd.
>=20
> Hi Mike,
>=20
> I'm not sure if I understood this part.
>=20
> The commands are moved to the tmp_list;
> we check for CMD_T_ABORTED and eventually move the commands from =
tmp_list back to conn_cmd_list
> because it's the abort task the one that should do the cleanup.

I=E2=80=99m not sure what you mean here. Are you saying both CMD1=E2=80=99=
s se_cmd and the ABORT=E2=80=99s se_cmd will have the CMD_T_ABORTED bit =
set and will both go through the aborted_task callout?


>=20
> iscsit_release_commands_from_conn() then scans the tmp_list and calls =
iscsit_free_cmd()... but not against
> those commands with CMD_T_ABORTED flag set because we just moved them =
back to conn_cmd_list
> and aren't linked to tmp_list anymore.
>=20
> Am I missing something?


If you have a SCSI READ/WRITE se_cmd (CMD1 in my example) and a ABORT =
se_cmd (ABORT TMF in my example) on the conn_cmd_list, then the =
ABORT=E2=80=99s se_cmd would not have the CMD_T_ABORTED bit set, right? =
If so, what sets it?

If the SCSI R/W has the CMD_T_ABORTED bit set, we move it it back to the =
conn_cmd_list and the abort code path cleans it up. But then we still =
have the ABORT=E2=80=99s se_cmd on the tmp_list. We will then call=20

transport_generic_free_cmd(wait_for_tasks=3Dtrue) -> =
__transport_wait_for_tasks(fabric_stop=3Dtrue)

And wait for the ABORT to complete, and the ABORT does not complete =
until the last ref on the command it=E2=80=99s aborting completes.

If you have a LUN RESET in the mix like:

[CMD1 -> ABORT TMF -> LUN RESET TMF]

Then CMD1 and the ABORT could have their CMD_T_ABORTED bit set. =
core_tmr_drain_tmr_list would call __target_check_io_state during the =
RESET processing. However, in this case, the LUN RESET=E2=80=99s se_cmd =
would not have the bit set, so we would end up waiting like I described =
for that to complete. In that case though the RESET waits for the cmds =
and tmfs it is cleaning up.=
