Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20F5C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 03:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC67A20707
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 03:18:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pkwRjUjj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIBDSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 23:18:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45754 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBDSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 23:18:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0823A767112870;
        Wed, 2 Sep 2020 03:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=G+5966owiAg86IIpCS294ZtfjahT/X8PWQHsoOn/A4o=;
 b=pkwRjUjjIRsLSAqWfQda3cFlCXdPyinEivkPoiLZCWPgkr0X8nvFhSop9juFd1m/FbmH
 MUS+W8SEV0z8+bPku3xOPPc6Ic5kYMGN1xm8vSpqWhNhIyTvK+J1qxxQrOvQdbIFap7e
 Dx0MbbpjLXJ6xWDOB1+8VhpalHGCw1kb1YAiUB5DiRoEohDHaft9ZGPe9ci0ZFh8cpEg
 TICJDjagoJepTRd2nhSIiV+Sde/Uk5d/0ovaXElleOhUUa3tbx+gS2zgG5heJyno9NTS
 yfcStMLUXsJONPZrv0a6atwYE25AYLxPYPpywspMqy4s1Jjs+Dqcd/N1Q5tJCSSc4JOD xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 337eym7uhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 03:17:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08239iS3007735;
        Wed, 2 Sep 2020 03:17:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3380xxs00x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 03:17:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0823HqpS008630;
        Wed, 2 Sep 2020 03:17:52 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 20:17:52 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <20200813002142.13820-1-ddiss@suse.de>
Date:   Tue, 1 Sep 2020 22:17:51 -0500
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2155E745-0E65-441B-93AF-7B4C0A53F5F4@oracle.com>
References: <20200813002142.13820-1-ddiss@suse.de>
To:     David Disseldorp <ddiss@suse.de>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 12, 2020, at 7:21 PM, David Disseldorp <ddiss@suse.de> wrote:
>=20
> LIO's XCOPY implementation currently only accepts IEEE NAA 0x83 type
> device descriptors for copy source and destination IDs. These IDs are
> automatically generated by spc_parse_naa_6h_vendor_specific() using
> *only* hexadecimal characters present in the user-configured
> vpd_unit_serial string, and advertised in the Device ID Page INQUIRY
> response.
>=20
> spc_parse_naa_6h_vendor_specific() mapping can quite easily result in
> two devices with differing vpd_unit_serial strings sharing the same =
NAA
> ID. E.g.
> LUN0
> -> backstore device=3D/dev/sda, vpd_unit_serial=3Dunitserialfirst
> LUN1
> -> backstore device=3D/dev/sdb, vpd_unit_serial=3Dunitserialforth
>=20
> In this case, both LUNs would advertise an NAA ID of:
> 0x01405eaf0000000000000000...
> Where 0x01405 corresponds to the OpenFabrics IEEE Company ID and 0xeaf
> are hex characters taken from vpd_unit_serial.
>=20
> With the above example, an initiator wishing to copy data from LUN0 to
> LUN1 may issue an XCOPY request with a copy source and copy dest set
> to 0x01405eaf... and observe that (despite XCOPY success), no data has
> moved from LUN0 to LUN1. Instead LIO has processed the request using
> LUN0 as source and destination.
>=20
> This change sees LIO fail XCOPY requests if the copy source or
> destination correspond to a non-unique NAA identifier.
>=20
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> drivers/target/target_core_xcopy.c | 23 +++++++++++++++++------
> 1 file changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/target/target_core_xcopy.c =
b/drivers/target/target_core_xcopy.c
> index 44e15d7fb2f0..3ce5da4b3e81 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -68,8 +68,14 @@ static int =
target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
> 	if (rc !=3D 0)
> 		return 0;
>=20
> -	info->found_dev =3D se_dev;
> 	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
> +	if (info->found_dev) {
> +		pr_warn("XCOPY 0xe4 descriptor conflict for se_dev %p =
and %p\n",
> +			info->found_dev, se_dev);
> +		=
target_undepend_item(&info->found_dev->dev_group.cg_item);
> +		return -ENOTUNIQ;
> +	}
> +	info->found_dev =3D se_dev;

Was it valid to copy to/from the same LUN? You would copy from/to =
different src/destinations on that LUN. Would your patch break that?

