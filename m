Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEB3C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 16:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBCD6222E9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 16:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ss4SzwO8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbgJSQTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:19:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730190AbgJSQT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 12:19:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JGEw47178885;
        Mon, 19 Oct 2020 16:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=dMG+iodWtK8rRd3Qi1/hBHnO8Pu8b99TbSuHqVcnQl0=;
 b=Ss4SzwO86XOAuZw6CTDqz6pok3+Ok3mieav2J5ve6sPOQG5Y5IXRgJ0t9rE9uG4cgv90
 J3UoUrAURJWV81CwFq3am+agYxGC9ThYTx96DJFd9QMVPOUiwjVqOMTSDWQ21OiykzXW
 DzL1p9opsZtx8BqApmwOWbBAV+tEr5p5jP7Pl0TQZxtOEu7FNG0HwkhoIdWZ+PGeuGNn
 aiKstbTsW5dcU1/OlLoQmp4vW+GvI0frFOpXbFzrBZxrVScHjWroJ/Ku/8b3skQPKbqX
 tRheKvd3FL3voCMQStCKjIqsn269+EeJt9hEYdQoHOnx8fexwUGq9EFH8HVUcp4iPDt6 /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 347rjkpdha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 16:19:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JGG9Bc059859;
        Mon, 19 Oct 2020 16:19:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6m39cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 16:19:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09JGJNPO005052;
        Mon, 19 Oct 2020 16:19:23 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 09:19:23 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
Date:   Mon, 19 Oct 2020 11:19:22 -0500
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 19, 2020, at 11:10 AM, Michael Christie =
<michael.christie@oracle.com> wrote:
>=20
>=20
> So it=E2=80=99s not clear to me if you know the path is not optimal =
and might hit
> a timeout, and you are not going to use it once the existing IO =
completes why
> even try to send it? I mean in this setup, new commands that are =
entering
> the dm-multipath layer will not be sent to these marginal paths right?


Oh yeah, to be clear I meant why try to send it on the marginal path =
when you are
setting up the path groups so they are not used and only the optimal =
paths are used.
When the driver/scsi layer fails the IO then the multipath layer will =
make sure it
goes on a optimal path right so you do not have to worry about hitting a =
cmd timeout
and firing off the scsi eh.

However, one other question I had though, is are you setting up =
multipathd so the
marginal paths are used if the optimal ones were to fail (like the =
optimal paths hit a
link down, dev_loss_tmo or fast_io_fail fires, etc) or will they be =
treated
like failed paths?

So could you end up with 3 groups:

1. Active optimal paths
2. Marginal
3. failed

If the paths in 1 move to 3, then does multipathd handle it like a all =
paths down
or does multipathd switch to #2?

