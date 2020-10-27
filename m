Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F262C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 20:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A93B12224E
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 20:03:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x5j24I53"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503825AbgJ0UDh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 16:03:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45020 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411101AbgJ0UDg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 16:03:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RJwx7c040838;
        Tue, 27 Oct 2020 20:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=U9eOEiNHNi1VjcV2sq8/2t4BDxIW9LJWurDXeJw3EvU=;
 b=x5j24I53FM+CDonJ37JExqHAUKWit+lx7DZlcVZyeGYI0pyYTtOOBJ5iXZ3kh+5q0grn
 JWPorj00iViO5UZMywnOoc3hDs5Zi1SLi77Vsa9X5i2WpQX7An4bHpW/gKsLFH80ybWH
 k1Mx739WGe1ft2mJ/hqFws950BHfc1DfAj/88lZbFEdsWq0vTsQqqRkX6x/eWgfgSpZc
 YfHR8HT5RH4TMjePW1ztBVAI3kMriycNMONhdNpxEcfwF6DBj09ZdKGcm2F3L4OU1/5Y
 ElZujNca8WCXCYYaMZ/EZzE3rnRFTOtyXTKXylIn5nQfMYY4Vfdbq4bY/JF6h9cy3+wM Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm41r6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 20:03:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RK0M07076268;
        Tue, 27 Oct 2020 20:03:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1r5fpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 20:03:31 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RK3Ut2007718;
        Tue, 27 Oct 2020 20:03:30 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 13:03:29 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a
 task
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
Date:   Tue, 27 Oct 2020 15:03:28 -0500
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 27, 2020, at 12:54 PM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> On 10/27/20 8:49 AM, Maurizio Lombardi wrote:
>> Hello Mike,
>>=20
>> Dne 22. 10. 20 v 4:42 Mike Christie napsal(a):
>>> If we free the cmd from the abort path, then for your conn stop plus =
abort race case, could we do:
>>>=20
>>> 1. thread1 runs iscsit_release_commands_from_conn and sets =
CMD_T_FABRIC_STOP.
>>> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. =
It then returns from the aborted_task callout and we finish =
target_handle_abort and do:
>>>=20
>>> target_handle_abort -> transport_cmd_check_stop_to_fabric -> =
lio_check_stop_free -> target_put_sess_cmd
>>>=20
>>> The cmd is now freed.
>>> 3. thread1 now finishes iscsit_release_commands_from_conn and runs =
iscsit_free_cmd while accessing a command we just released.
>>>=20
>>>=20
>>=20
>> Thanks for the review!
>>=20
>> There are definitely some problems with task aborts and commands' =
refcounting *
>> but this is a different bug than the one this patch is trying to =
solve (a race to list_del_init());
>> unless you are saying that abort tasks should never be executed when =
the connection=20
>> is going down and we have to prevent such cases from happening at =
all.
>=20
> Yeah, I think if we prevent the race then we fix the refcount issue =
and your issue.
> Here is a patch that is only compile tested:
>=20
> =46rom 209709bcedd9a6ce6003e6bb86f3ebf547dca6af Mon Sep 17 00:00:00 =
2001
> From: Mike Christie <michael.christie@oracle.com>
> Date: Tue, 27 Oct 2020 12:30:53 -0500
> Subject: [PATCH] iscsi target: fix cmd abort vs fabric stop race
>=20
> The abort and cmd stop paths can race where:
>=20
> 1. thread1 runs iscsit_release_commands_from_conn and sets
> CMD_T_FABRIC_STOP.
> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. =
It
> then returns from the aborted_task callout and we finish
> target_handle_abort and do:
>=20
> target_handle_abort -> transport_cmd_check_stop_to_fabric ->
> lio_check_stop_free -> target_put_sess_cmd
>=20
> The cmd is now freed.
> 3. thread1 now finishes iscsit_release_commands_from_conn and runs
> iscsit_free_cmd while accessing a command we just released.
>=20
> In __target_check_io_state we check for CMD_T_FABRIC_STOP and set the
> CMD_T_ABORTED if the driver is not cleaning up the cmd because of
> a session shutdown. However, iscsit_release_commands_from_conn only
> sets the CMD_T_FABRIC_STOP and does not check to see if the abort path
> has claimed completion ownership of the command.
>=20
> This adds a check in iscsit_release_commands_from_conn so only the
> abort or fabric stop path cleanup the command.
> ---
> drivers/target/iscsi/iscsi_target.c | 13 +++++++++++--
> 1 file changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/target/iscsi/iscsi_target.c =
b/drivers/target/iscsi/iscsi_target.c
> index f77e5ee..85027d3 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -483,8 +483,7 @@ int iscsit_queue_rsp(struct iscsi_conn *conn, =
struct iscsi_cmd *cmd)
> void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd =
*cmd)
> {
> 	spin_lock_bh(&conn->cmd_lock);
> -	if (!list_empty(&cmd->i_conn_node) &&
> -	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
> +	if (!list_empty(&cmd->i_conn_node))
> 		list_del_init(&cmd->i_conn_node);
> 	spin_unlock_bh(&conn->cmd_lock);
>=20
> @@ -4088,6 +4087,16 @@ static void =
iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>=20
> 		if (se_cmd->se_tfo !=3D NULL) {
> 			spin_lock_irq(&se_cmd->t_state_lock);
> +			if (se_cmd->transport_state & CMD_T_ABORTED) {
> +				/*
> +				 * LIO's abort path owns the cleanup for =
this,
> +				 * so put it back on the list and let
> +				 * aborted_task handle it.
> +				 */
> +				list_add_tail(&cmd->i_conn_node,
> +					      &conn->conn_cmd_list);


That should have been a move from the tmp list back to the =
conn_cmd_list.


> +				continue;
> +			}
> 			se_cmd->transport_state |=3D CMD_T_FABRIC_STOP;
> 			spin_unlock_irq(&se_cmd->t_state_lock);
> 		}
> --=20
> 1.8.3.1
>=20

