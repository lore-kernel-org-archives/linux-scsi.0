Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E59C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 23:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7E521D6C
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 23:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vuf8+iPx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgFSX1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 19:27:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbgFSX1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 19:27:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JNRVdF012251;
        Fri, 19 Jun 2020 23:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=P0Hz1RuNayOFF/iE1D8g2zB1Oxt50p40/igL1mmxIBc=;
 b=Vuf8+iPxQtT0LLZxLnc0A6Zo3Jv3YHJ4kpkSSuGRR3ZsKjXWhlZKnlNKq9E0TzZ7QRTj
 8JJFJBkz2L5bk+0F3H7eWWtVxo+7O0/gptwUqH2E2HyfVH16pfRvBPrc2j8snYCA8YFs
 tAQOODlTPZl7RIjFQBzJ2iNJHlCM/ZGxmruZY/38JZ6sClsFGBbeqWNzpSgDon4R/zbe
 49cotgPdO2CJdxRVnMA0t7slSOzSrk7ckRuuabwoxzP9VK1ws2c+NS9c2VeDUfUa5c96
 JylUUYN7aHNgYtmsbk5kEfm75j9Q+/niIy6DkGc7ow1D7RfT7JweayDqw8DKR1vfw5cy kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31qecm7n7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 23:27:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JNNS8P120059;
        Fri, 19 Jun 2020 23:27:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31q66ws0vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 23:27:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05JNRTmb006032;
        Fri, 19 Jun 2020 23:27:29 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 16:27:28 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] scsi: target: tcmu: Remove unnecessary bit
 TCMU_CMD_BIT_INFLIGHT
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
Date:   Fri, 19 Jun 2020 18:27:27 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <526E97E2-5116-4100-A96D-46B6C790B7F1@oracle.com>
References: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 malwarescore=0
 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190164
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 19, 2020, at 12:38 PM, Bodo Stroesser =
<bstroesser@ts.fujitsu.com> wrote:
>=20
> Since
> commit 61fb24822166 ("scsi: target: tcmu: Userspace must not complete
> queued commands")
> tcmu_cmd bit TCMU_CMD_BIT_INFLIGHT is set but never checked.
> So we can remove it safely.
>=20
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
> drivers/target/target_core_user.c | 2 --
> 1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/target/target_core_user.c =
b/drivers/target/target_core_user.c
> index 560bfec933bc..b38da27e033f 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -181,7 +181,6 @@ struct tcmu_cmd {
> 	unsigned long deadline;
>=20
> #define TCMU_CMD_BIT_EXPIRED 0
> -#define TCMU_CMD_BIT_INFLIGHT 1
> 	unsigned long flags;
> };
> /*
> @@ -1078,7 +1077,6 @@ static int queue_cmd_ring(struct tcmu_cmd =
*tcmu_cmd, sense_reason_t *scsi_err)
> 	tcmu_flush_dcache_range(mb, sizeof(*mb));
>=20
> 	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
> -	set_bit(TCMU_CMD_BIT_INFLIGHT, &tcmu_cmd->flags);
>=20
> 	/* TODO: only if FLUSH and FUA? */
> 	uio_event_notify(&udev->uio_info);

Acked-by: Mike Christie <michael.crhsitie@oracle.com>

