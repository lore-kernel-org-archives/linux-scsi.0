Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D96FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 23:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C9920663
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 23:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DKRIvV4K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgFBXB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:01:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbgFBXB7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 19:01:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MwLO2067611;
        Tue, 2 Jun 2020 23:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : sender : to : cc : subject : references :
 in-reply-to : content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/i8GX+iY4Wnm4fsJFSfTAcD+37F2OWJWWxhbKj5mH5s=;
 b=DKRIvV4KKdi5ltbq6yTxWjGoV0jI4CfCUIX7Wxb219DeQ5DDzemrVFt+4mDD5IrFjyIm
 UOY5/Ya2/5ZEYVZM3rs0AOdOLWwpTX7cc0/LivkCj+QnDdH1dh0BztOqUlnQStL58RJd
 WfBIgpxlT7v6QKJ7VR5KfxB3DcJeCla6zdtZCA0BFZyWOmh0WmoGdaX4y8uBtOE73hfl
 yrTbm+P0v2U6cggKeRFEkCCcvgIm+7htu+CtDb4k/TE3UJI2lGTz2jWjYPFp0vThqfgV
 CFkhX6F9pLZsH0iGLg1NX9hPSbt5EZxhknl9I7sd+JtajBLhxMYT2lUUhsdQ8YrAsz9I nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31dkrukfkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 23:01:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Ms15Y144366;
        Tue, 2 Jun 2020 23:01:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31dju28e2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 23:01:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052N1vho003803;
        Tue, 2 Jun 2020 23:01:57 GMT
MIME-Version: 1.0
Message-ID: <b88dd350-16d6-4551-9602-03368e639642@default>
Date:   Tue, 2 Jun 2020 16:01:56 -0700 (PDT)
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     Michael Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shirley Ma <shirley.ma@oracle.com>
Subject: RE: [PATCH v3 2/3] target: fix NULL pointer dereference
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
 <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
In-Reply-To: <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.9.1  (1003210) [OL
 15.0.5215.0 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020160
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Maybe move this to after target_get_sess_cmd().
>=20
> I moved it before target_get_sess_cmd() because if target_get_sess_cmd() =
fails
> then we have NULL pointer dereference issue again. For instance, the sequ=
ence
>   vhost_scsi_submission_work
>      target_submit_cmd_map_sgls
>        target_get_sess_cmd() -- Suppose this fails
>      transport_send_check_condition_and_sense
>         trace_target_cmd_complete -- NULL ptr derefence.
>=20
> Still thinking how to address both these issues together.

Also, noticed that not all callers of target_get_sess_cmd() check for retur=
n value.( iscsit_setup_scsi_cmd() and iscsit_handle_task_mgt_cmd()). Could =
this cause problems?

-Sudhakar

