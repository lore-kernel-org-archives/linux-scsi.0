Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CFBC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 20:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FEE72078B
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 20:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fmURDM/3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgEUUi2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 16:38:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42566 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUUi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 16:38:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LKbvag110410;
        Thu, 21 May 2020 20:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : sender : to : cc : subject : references :
 in-reply-to : content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=D1Z9zo7088BokUCqM7S+dmfjR7IYF3FR/+2WLcO3RSw=;
 b=fmURDM/3RvkbR20bPstrKAErIvNK9HTAHAEaNqml2rGC8Hw3HOWJZbJ+OzkBMBwpAgFV
 6fBIPxh8cKMZnzpkZzYBUNhwfEhBLEuDtk2+pCKQvL8rcxj02R3tFpxLYGy3u3IQyUhv
 Enrzp1CxsYud8FzwyHUCu41DtOb5LhSRyXSmP6Tn69ZDASLfyK2rgydjwiMXpOvFp92L
 Itqh6ihbjrOlmnoywKAS8gPir6+Lr6Rp07ULraps1cOkJXHbeN9kbpZ2mxxofivB/5mF
 9FW7xibVnL1gHmWJ9qWucpbcfzeT5GWY/3ikdSP83USjpS7tIx6jsmO9iUPFcIoZ76X8 eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284man0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 20:38:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LKTGRp166724;
        Thu, 21 May 2020 20:38:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3150233qke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 20:38:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LKcNVl016907;
        Thu, 21 May 2020 20:38:23 GMT
MIME-Version: 1.0
Message-ID: <a5497b1c-0f60-4b94-bc3c-f3ac29eddefe@default>
Date:   Thu, 21 May 2020 13:38:21 -0700 (PDT)
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     Mike Christie <mchristi@redhat.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shirley Ma <shirley.ma@oracle.com>, ssudhakarp@gmail.com
Subject: RE: [PATCH 3/3] target: rename target_setup_cmd_from_cdb() to
 target_parse_cdb()
References: <1590082959-1034-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <8cde32d4-eef3-ec4c-9a0e-54c896e90ccc@redhat.com>
In-Reply-To: <8cde32d4-eef3-ec4c-9a0e-54c896e90ccc@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.9.1  (1003210) [OL
 15.0.5215.0 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005210152
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Maybe the naming would be nicer if we did:
>=20
> target_init_cmd_cdb
> and
> target_parse_cmd_cdb
>=20
> This would match each other's pattern and also match the style of the
> other cmd related function naming where its "target or transport"
> prefix, verb, cmd then optionally something extra.
>=20
> Or maybe:
>=20
> target_cmd_init_cdb
> and
> target_cmd_parse_cdb
>=20
> so they at least match each other and you get an idea they pair together.
>=20
> Just a suggestion and not a requirement, because I'm pretty bad at
> naming, so I have no idea if its better or not.
>=20

Thank you Mike, Nice suggestion. I will incorporate the name change and sen=
d out another patch shortly.

Thanks
Sudhakar
