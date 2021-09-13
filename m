Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B98C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 14:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241C060F6D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 14:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345307AbhIMPAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:00:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7450 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344709AbhIMO6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 10:58:47 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESvBH024793;
        Mon, 13 Sep 2021 14:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=X0BqBGguH1dx8COvHFs0/wHmVxXCtuiMyCnpB1rBTNI=;
 b=DIvBuHIz10fL5vmkj54xMSXO1aqM01myTo0Oy+oGvKn0TVE62bXJGKR/IAzMjpkAJqZM
 0WmA6IAZf22rqWfGsH9WWjh5OaD73ulmxvdm6eAuRvFweFc3YThfT4b/EjGDqcANzf0J
 eZIEGLg8+1pqKxeqVkMEuLwYqRpilgEZxBDRCyIvHABggw54N3C/Udm0wNHxJ9Jsq7Mm
 yYONuvuBMDSY6MtPSCI4G8aUGbOaXk4e1rTKM+Y9Iwz3CUG2vL4RJKwZ1OBm8Rpiz+mC
 E5F5XuL0iagdVo1oBPxQEboQZXIo5u+oV5gUWYvcbkCe0UotLQGffQs9peIh6NxE5mQc aA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=X0BqBGguH1dx8COvHFs0/wHmVxXCtuiMyCnpB1rBTNI=;
 b=Azr+CXGGwVpxJ7Fka92zaAR97hEjwWJ0RWc/N8rd1LMT6C7I68b2yU27iZDxPxyW6hLR
 zx4vqJZSYldhroJYBJncFsvzB+QryNRdOw8xwGIrOczQhsZEi12qngt8J9MVaS5dejAX
 0oEPi4MD3nRzG6uNcRKCxQo8tnaQTD6mgrKpLdjt3vQl71rC9Z77/SSFWkSoCcugQz5p
 AVjm5HMiW2WtgSPMMB6J1p0YZLEqnNw/CavVXQhMEzZDw6GHBQ2aYHr4vGiXukyhDrmt
 I9OC2UcREaXWIbQoQoA3O5wM5SuO1GuT2QPyFbHrgL1jjnPg/9mUj86OcA6iXbkuLAm4 Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka92ufg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 14:57:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEuJQ2010025;
        Mon, 13 Sep 2021 14:57:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 3b0m94ttyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 14:57:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xko1HD/8i3aXS6xGGzPoHP16VSYKSf+FwqV2+T3MT2+nHQgR9HGGd8PcEh1BjXH2m15cv/mF1fZk0UMEJFxAJOUBwinL6tHUDDfA8681Uu8/F+lYOdJs7tHpRr4VtMmXIoB5fGAIeZkm73xwTUzuQHp5rGzcCspPteNEcyjkemIuuIYitavk1SH3085vn3p15hvKXym828EUvwynNVGP7XWeGLr+ZaciYYlujmTm17hl4LLBRkszn9TiOG9Pby6G+DDNSqQcfPafZtnavbgc0MsYZ/J/YImmhWDR4JksSjC1AzH6nY1Qw6oma8S9JOAODY3bngmEgvGrCsLe7y9uUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=X0BqBGguH1dx8COvHFs0/wHmVxXCtuiMyCnpB1rBTNI=;
 b=WSdZywiCizDICH2T5cu9nwspvBQbz8mZKWQ5N7/25ai/a6XIjJhfzbD3HLH3GdMsf4CpToZ9thTgbLbygYRywQFyKfEjaQGbUO30+ho6J8MTkiR8xUQ5Almg5GhAWOKIkSfpFnMWXoU9Rw8bTHbAxcbpOTwxUHhuicmzeUfggx1Pn/E4F5+M2byoEFB9jbibyMQ15QvPjBEAAUY0HoLCltk3V/Dca+bx/F/8znUtzwcpGgA+51pQTXeUHUBI0eDhbTFpvNwI329AF4Tmh+GYWAumrDnCWjGiIQpkt7O1Y1xLWF+WS07evP2AK5GCk78YTTKytuxV9XjF5q++PMLNMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0BqBGguH1dx8COvHFs0/wHmVxXCtuiMyCnpB1rBTNI=;
 b=Fb6saOfc3XAd5HSMU6CJjTRmYbIzw1s+je93mr/fNf4/Ir9FoAugzWv0BI0A+HtDRIjNnDw+Sn68zhhWZBq1hp1OKCwAJkEUW3WZvPT9W0qy5ayRah9YEnr17An2nKRCyFUHomEvIBm3x5JSaFnx2cCJyNnEInZ3/7MWuUpSzGM=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 14:57:21 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::f5e3:a62d:908c:e976]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::f5e3:a62d:908c:e976%7]) with mapi id 15.20.4500.016; Mon, 13 Sep 2021
 14:57:21 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Muneendra Kumar <muneendra.kumar@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        James Smart <jsmart2021@gmail.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [PATCH scsi:fc] Update documentation of sysfs nodes for appid
Thread-Topic: [PATCH scsi:fc] Update documentation of sysfs nodes for appid
Thread-Index: AQHXqHxtag4u2xPIrUyTSzgX6p6VOauiDlQA
Date:   Mon, 13 Sep 2021 14:57:21 +0000
Message-ID: <45595BCD-9F9D-40B3-853A-E7C744168DD0@oracle.com>
References: <20210913015853.2086512-1-muneendra.kumar@broadcom.com>
In-Reply-To: <20210913015853.2086512-1-muneendra.kumar@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2aa71078-ac92-40b5-a349-08d976c6c9d3
x-ms-traffictypediagnostic: BLAPR10MB5204:
x-microsoft-antispam-prvs: <BLAPR10MB5204571C515D0365765E0AB6E6D99@BLAPR10MB5204.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKrOl1MvkEAZQ6PBEEFOsCcypdpR49MUVYkagVfaQjbgsvVoqD+o5SAywgxMHZgFjerjpbSrAFvJLIAlIcXiSdNPnPdQ0wauz+ToRulji6j/AyJRkhwfCtRF3sw6AgdAdIZ4qEggQPgi7oAIXsy1v0AKYv3OL2xCFWaETu0GDaceVJ2QF4ew4X83LjpYNtcw4iVvGxSAG/hCK+4PDjE/tGygRYamfTPie7dydc5mjEYE9ydQPTH1YdEAEQ9s1VtzpRjgPAvWc1oceJ3aIXzgxX0Xq0NinpGNQgBomoLKJCtVf3BI+AN0UwdjKvDOgO3OQhpPCgvdvMc3d9+xpjXYWJD2stCx1puI0GI4pxm6yuPq1Ddj4d0i8Roham4dVrZU+LyJJSXnNk/6yq4tQqDX5XtcYf0hcktxBG1KEpURCtGNdpPGVK43JdDqzdq6l2ttyQcnttpvdPMhXct8JkGmQktcRqcwuEOD/0EOMQEEOEv+a0pwQVxH46oGyCA+Ad6TveNUdWC5eY6P+HFJuZqw8YybX4ZiNWGWJ/CWS6ojIQRIkmz+aoZUVsL4afs9+G847sAI8q25wptzRr+K4KC0H12yu2gURNJX6UtwSsFx3dKpvjYVLwCX8HWGm8q0oy2AUSul19Fga55FUJnkiw9gzZCqJMj5LoCUH+XOB+4dreh1LboG2o68t5DC4j16Z2KOvJSdkVmrCa+L9DjWJRqkG8FrryHIzAFT53XTC2YVc8GWgfPWNP/XDvMwYa1J+A3r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(396003)(346002)(86362001)(316002)(53546011)(6512007)(6486002)(5660300002)(2616005)(478600001)(15650500001)(36756003)(83380400001)(71200400001)(76116006)(91956017)(26005)(2906002)(122000001)(38070700005)(38100700002)(66446008)(64756008)(66556008)(44832011)(6916009)(8676002)(54906003)(6506007)(186003)(66476007)(8936002)(4326008)(33656002)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4qFt8WMsaH+Uio4uKdFNwAzzjJZrN9isHlgGdWXtKfnNE16LUysDlRxU0/U8?=
 =?us-ascii?Q?QW8Xpy2xyqkzXjVaI5i5QvJG163tLaD5qBbPX9IFK6WKgPEJ0ZON8oIvfJ0A?=
 =?us-ascii?Q?k2HrGHegQr7V+IbkUNoJ8mTB81tBRdw0au/jjEtYlck0nL282xblV1gG5BZn?=
 =?us-ascii?Q?P4CzEj9vhLVEENNosZrnKcnE87nW/mavbHandkrFiOSp06GLRev2ev6tMe6h?=
 =?us-ascii?Q?I9RPhKzTRjl3yBMWKeAmaGRz6ItmGJR6HdIjezJbTVSiKIXIVVutodr4Z7Rs?=
 =?us-ascii?Q?6FB6VWAEscxA+NxWBTxrku3Z/HnZ+DoQy8LMIm8lZBL68K8NKRW/PzWWV1NY?=
 =?us-ascii?Q?j5sXVvjc+aE+SAuioFaSG54S52RQPsItizi8apsVMrh28FyH3lYaJih07a2e?=
 =?us-ascii?Q?EQrW9Muc1y3b/YQxWWiu65YD1FUPQZIuE9bK3x7OOlCmZe37PIdeDRyZwF+O?=
 =?us-ascii?Q?Byx9PptqSIaeh80m1wz3XiyG/PGlHqb+hsXrWrbFypmbcsKsDkI+GbvJ75QC?=
 =?us-ascii?Q?cIWl/fY5tPi7dPgJxfaEVVyJc+orkrCWwIBd9SKtkwavse9AZ8j+YC/VIIrW?=
 =?us-ascii?Q?wUnqbA58XBaXzzLT5o++oIzq5qELQ1o7vFT13O1Z7NBMl6v0W6mo8sLxH/Ao?=
 =?us-ascii?Q?CIGt9wjYpMSVNwXbh4YT5d/NI5VwWHGbyA4A7sEqIhaog38YtNuSVcs11Zi3?=
 =?us-ascii?Q?C9KTep6RZ/UMNLOWviHYKeg4tggG0jpqhJNUUsQasFl7BtXIwfZirGLyXPTP?=
 =?us-ascii?Q?xvRaJfAp3DjFIUaOJzfoSf00qplvXMz51GAiWUMfkZg21Wd11nsFJlDX6qSW?=
 =?us-ascii?Q?wDOFilEjs3iqLWCaMdhXXoZV5mY9WB4TIhfFmQCz0gRZDNi9mY8N5GVFmeSa?=
 =?us-ascii?Q?+WVPN663K1FRul5LJdwZ2MhKh9+FkCC/bZAK6kVztygmsfsgP0h5eI6HAv7R?=
 =?us-ascii?Q?/onlfhQJzr0rh63bp9lzS1CCuVPsQi1paJvXbF3LGFxM05DmLpGbIxGhxsBD?=
 =?us-ascii?Q?b8upGmAlZ1Z4/dJbsM19ZzUAaVjpbswhqVog2vfzCFswfhepDqdoPw5us471?=
 =?us-ascii?Q?rWWPZXEzfLOLP+xSAJnMd5Sf3Puqt5XJwoV4W2FNXE4CIosNrzGN33j2SZar?=
 =?us-ascii?Q?pcRSfN9idDKG1XrQFi/gduIMSwxmt9Bg5y03/ZOSrQRnj3j3LjHDnkytlQI/?=
 =?us-ascii?Q?mVNzMeqmuVwkZIHRHF9S6C834vJ+Oy84MQ2/pmdr5H14DlaFcyBMnO6vkKik?=
 =?us-ascii?Q?tXfTRuhHCQzYaAgL3R2adTsbLgqP80nueRMH/VqhLbpoVPuSesNe/rmtYfR3?=
 =?us-ascii?Q?TGW0YP9T4QTJLLlT32vcYHv8l3kTAu7h+vfe+gJK500F1g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E22EF9B9C5CD247BB5EA8B631BEEF61@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa71078-ac92-40b5-a349-08d976c6c9d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 14:57:21.0538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 561Ay+NZIrIpfIMzXVZnafOjHg+REeH0AyUQubpPF9agoyK5AMvtifPtwMjBFengYDVmb+jrUEiHs4W/PQmDFG0RAetSE+qLCuShI2Ac6Hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130099
X-Proofpoint-GUID: 67yQe2Rh9AotUvj6uKyjW4NzLuZqeah6
X-Proofpoint-ORIG-GUID: 67yQe2Rh9AotUvj6uKyjW4NzLuZqeah6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 12, 2021, at 8:58 PM, Muneendra Kumar <muneendra.kumar@broadcom.co=
m> wrote:
>=20
> From: Muneendra <muneendra.kumar@broadcom.com>
>=20
> Update documentation for sysfs node within
> /sys/class/fc/fc_udev_device/
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
> Documentation/ABI/testing/sysfs-class-fc | 27 ++++++++++++++++++++++++
> 1 file changed, 27 insertions(+)
> create mode 100644 Documentation/ABI/testing/sysfs-class-fc
>=20
> diff --git a/Documentation/ABI/testing/sysfs-class-fc b/Documentation/ABI=
/testing/sysfs-class-fc
> new file mode 100644
> index 000000000000..3057a6d3b8cf
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fc
> @@ -0,0 +1,27 @@
> +What:		/sys/class/fc/fc_udev_device/appid_store
> +Date:		Aug 2021
> +Contact:	Muneendra Kumar <muneendra.kumar@broadconm.com>
> +Description:
> +		This interface allows an admin to set an FC application
> +		identifier in the blkcg associated with a cgroup id. The
> +		identifier is typically a UUID that is associated with
> +		an application or logical entity such as a virtual
> +		machine or container group. The application or logical
> +		entity utilizes a block device via the cgroup id.
> +		FC adapter drivers may query the identifier and tag FC
> +		traffic based on the identifier. FC host and FC fabric
> +		entities can utilize the application id and FC traffic
> +		tag to identify traffic sources.
> +
> +		The interface expects a string "<cgroupid>:<appid>" where:
> +		<cgroupid> is inode of the cgroup in hexadecimal
> +		<appid> is user provided string upto 128 characters
> +		in length.
> +
> +		If an appid_store is done for a cgroup id that already
> +		has an appid set, the new value will override the
> +		previous value.
> +
> +		If an admin wants to remove an FC application identifier
> +		from a cgroup, an appid_store should be done with the
> +		following string: "<cgroupid>:"
> --=20
> 2.26.2
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

