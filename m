Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268CEC4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 14:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB9B32224F
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 14:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XrZ3kzwb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408023AbgJTOYP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 10:24:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38888 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407966AbgJTOYP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 10:24:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KEMXnY192889;
        Tue, 20 Oct 2020 14:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=XCxpT3/55zfOnXEAsI5QFKk3Ua4GQdCQ3brgF1YgZH0=;
 b=XrZ3kzwb2tHMT4ffHATIOWc+Z2+bFeEH+p1l/wtCpw3jzITpEhSQOijNJV0gFjnvwsWu
 tICfL8e+rCN0HoG5VKJDYcMvoWYN3Ki+7qztP5zk8fZzA8rgNhBJADiszG4frJFjAwHk
 a70zb5giorTs+Me0JMKbKfgGILwW0+v5CRRNuqYsi01KkgnwlYxlBMZOjXI4FvFGhn/s
 4ML8EbFIn7NXuGLPOrP3Lqf1mi9+bl0fJdun2IJMrI8GBSI/FG9ZgXeO/0k6J2gy2Wcf
 qugda/DVdTznUsVJN0FJiJRno5N92edGFhBhbPNATbR2JhGWplkdftFkfQZ8SfNQI6oR 0Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4auhj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 14:24:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KEKuhv193601;
        Tue, 20 Oct 2020 14:24:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348ahwapuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 14:24:12 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09KEOBUA000305;
        Tue, 20 Oct 2020 14:24:11 GMT
Received: from dhcp-10-154-104-53.vpn.oracle.com (/10.154.104.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Oct 2020 07:24:11 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [EXT] [PATCH 2/4] include:scsi:fc: FDMI enhancement
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <SN1PR18MB23014AC47337DC3867BAF20FC71F0@SN1PR18MB2301.namprd18.prod.outlook.com>
Date:   Tue, 20 Oct 2020 09:24:10 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <058A7A09-39DF-422E-8792-82FCD8CEFB9C@oracle.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
 <20201009093631.4182-3-jhasan@marvell.com>
 <7207E967-5713-4F67-8F06-7EA25C206F84@oracle.com>
 <SN1PR18MB23014AC47337DC3867BAF20FC71F0@SN1PR18MB2301.namprd18.prod.outlook.com>
To:     Javed Hasan <jhasan@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 20, 2020, at 2:19 AM, Javed Hasan <jhasan@marvell.com> wrote:
>=20
> <JH> In libfc we do have logic to split FCP commands but not for CT =
commands.
>         If I am adding all attributes of RHBA then total length is =
going upto 2750(approx),
>         Which is far more than 2048 and that is causing problem.=20
>         Practically all version/names get covered with in 100 bytes.

following length fields that are being added by this patch will never =
exceed 64 bytes IIRC.

+#define FC_FDMI_HBA_ATTR_MODEL_LEN		100
+#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN	100
+#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	100
+#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	100
+#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	100
+#define FC_FDMI_HBA_ATTR_FIRMWAREVERSIO_LEN	100

OSNAME will need 128 bytes =20

+#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	100

I would like to see more realistic numbers for these length than just =
arbitrary 100 bytes.=20

--
Himanshu Madhani	 Oracle Linux Engineering

