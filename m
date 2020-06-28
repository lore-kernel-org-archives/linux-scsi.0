Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B989C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 19:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1199B206C3
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 19:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SKA0ho0L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgF1Th5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 15:37:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgF1Th5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 15:37:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05SJW2FR026997;
        Sun, 28 Jun 2020 19:37:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=8UP1J8KIvbZruRKT34GLAOGsHEsERFbjMb6TYIdgN2k=;
 b=SKA0ho0L8D64ZCt+/uCdE3qnGdjpYSs0TM3MQkkSZnON0thQItuoIxru3npGbpfSSRtg
 LyFL6N2N06I2dezWYLzWvxDmqcGLE6vj2GJPnN3uKaOZbT07w/hSTr7OZWsZbKjbdVY4
 o5Z+5AqyOmOpZROvLyRP1vEqtoilPzexG/rk8SDhPZKIm4v/JzugSMfmO5KXhai1CKhZ
 PlViTk90N1Kdp0qSnlkaGYk7djD9dmtd4SEfk4SqqxaFVfC2z6M7o4iANQQMh3cK3Rzu
 uCfrFaz/R1lKMzGI1s6xpwg+4jvLQMC0URE89xbF0mrg3YGDtleQrI62r3/p17TkmqiK /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrmuda1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 28 Jun 2020 19:37:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05SJXc56063762;
        Sun, 28 Jun 2020 19:35:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31xg1u36q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Jun 2020 19:35:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05SJZYGd012940;
        Sun, 28 Jun 2020 19:35:34 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 28 Jun 2020 19:35:34 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] scsi: target: tcmu: Fix crash on ARM during cmd
 completion
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <93e7f9ef-566e-6949-b2c7-2e822ee49f39@acm.org>
Date:   Sun, 28 Jun 2020 14:35:32 -0500
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        JiangYu <lnsyyj@hotmail.com>,
        Daniel Meyerholt <dxm523@gmail.com>,
        Henry Willard <henry.willard@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <15C73AF2-672A-4686-A418-0C41993E8060@oracle.com>
References: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
 <93e7f9ef-566e-6949-b2c7-2e822ee49f39@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9666 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9666 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280146
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 27, 2020, at 9:31 PM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>=20
> On 2020-06-24 01:53, Bodo Stroesser wrote:
>> The fix is to use the maximum of remaining ring space and
>> sizeof(struct tcmu_cmd_entry) as the length param.
>>=20
>=20
> [ ... ]
>=20
>> +		/*
>> +		 * Flush max. up to end of cmd ring, since current entry =
might
>> +		 * be a padding that is shorter than sizeof(*entry)
>> +		 */
>> +		size_t ring_left =3D =
head_to_end(udev->cmdr_last_cleaned,
>> +					       udev->cmdr_size);
>> +		tcmu_flush_dcache_range(entry, ring_left < =
sizeof(*entry) ?
>> +					ring_left : sizeof(*entry));
>>=20
>> 		if (tcmu_hdr_get_op(entry->hdr.len_op) =3D=3D =
TCMU_OP_PAD) {
>> 			UPDATE_HEAD(udev->cmdr_last_cleaned,
>=20
> The patch description says "maximum" but the above formula calculates =
the
> minimum of "ring_left" and sizeof(*entry). Did I perhaps misread this =
patch?

Ah yeah, Bodo probably meant to write what they wrote for the comment =
above about the max up to the end of the ring and not max of space left =
and entry size.=
