Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7877AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 570676113C
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351804AbhIHOQW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:16:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12684 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229600AbhIHOQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 10:16:20 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188DeHrN026126;
        Wed, 8 Sep 2021 14:15:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=EJU+Xiph3gJXm+MowLGTMLht2tYduDvpMhi/k1CGRYw=;
 b=rWb4yVCB7AIWjhAEJ2I3JfDNnkd+j4r1Bat0SAVpQ23hDoUxjfmzpLSJkESo+A/b9g0b
 U8QddaAmsgGv8hvTCCSHV6+ngHKrFqYoh9w0noYXE3KeBYkgHYt5adXsaaycWtiAU1M3
 mVyLQqVJoVbx/MYO6Rhn4IupgNTD3Ep0MyOet94cS80vieL+hcCMjvujarRcIRrnnkzl
 S7K+LLhe4DehHoFuhH0cn14PGOt9YTQl8m8kusPXhXxLUPuvbdRl71SwMebO+W2BxcnJ
 7AUYx6RnaJw+Z6lYzjlqAwTQzGIu1UPXbkwYbFDrfilI3uRt/QRgGLbuEAhBeKrI6FI/ eA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EJU+Xiph3gJXm+MowLGTMLht2tYduDvpMhi/k1CGRYw=;
 b=B3GTgqX+jo1KtkCyCkG71m9bgZueUbU3q/jzFCUdCpV+9bfv9er6HZ3oPC3uuwsNtKTI
 YcsgcYTtXaIqNpYnycDzuqmQgT2rdVEqXh4kOfDPbBs/WAtOPln/dovvKJFTTWQJPS6b
 WnWycXtLgBoFqH5cmQrOovlt36YvrstaPpAeE2yFi3ZGxTNvRb4ON0RvOHxASvfz6hxy
 BDpnNQtqOR6JpALAxdQCVZJonS7KumSr50OTgWeNt7tFIxFuGeD0gl680KO/Y0hK5tgB
 jho6aIgkRym1g9TFVf4D1aIKNPR3boi8oJ3SrRtYXBWaRmT7YDaAimmbTcVNArGX7Yih pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axd7tau15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:15:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188EAEDq121904;
        Wed, 8 Sep 2021 14:15:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3axcpnt6vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:14:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2seMwchUhgQge+cvs4W9ZZYoJdxHuO7KDo3dr0UlHlbV8v9xPOVtNQ5JqDr1aeEFCKIgJgZ0I4MmBcaFZc+q8MVtV9LtK6gPemegsBTV8SkUbnZR8NyhHUxQQ16KpZ19x5I7NkMSXwRCdTzJ3flN494zKIWF+OIZ2HPBHozR4Xccl4QYT5Hbep+mnF8zBPXvNyareQBeCBPuIxHLPAwFn7xNM4QkaejaWqmIr6B5Z/NblzJ25iXhqfOJ1b+7nO186pxChXxygXV9e0lRdy6xhheEPq2/gGyCOn9P3NcyNJv4Wx6ZA1owihLKSU6WIhs7qh0lQ4tiwaA2U4LjYtFZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EJU+Xiph3gJXm+MowLGTMLht2tYduDvpMhi/k1CGRYw=;
 b=LTvRdXAqKpCt/yB9HjJQDe3Sh8l/Y54ZgUeAcy4RJ0F+rUG2SkgnPgMByy1ME3oEDN/pktpnpY4k3OZV6XdFfpJhxFu8MrPRwm2POrVrert6HUv2PS6HFADKlhjSlPyJiLH0+HrUtKq8UJstu7VpfE+SXyHpEmq8LOYA+wgzdS0nRyVaY0CZuXb0e5SxT6EwRSmGw2fyoKmn4ZWPqZjJRhbcvmBuSeNDzwEAaLR+a/7mLK+DBCUXXCNsBk2aTvRil5iwx3Qhz/pHtj3OSzuN/DHn1ASy2PySra6muOsr1cmd7caGC7Jj9dyQMwlivRbQENiWwS4kO/uq04085Vg7zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJU+Xiph3gJXm+MowLGTMLht2tYduDvpMhi/k1CGRYw=;
 b=o9s1u6HBDdZtNVNEPMK2Y2qFkEJabU1HFgfhGyr10KHhy3hmO5odHcGEdayy7Ay5oMVUjyee1jB3zz8s+X3PhB6rE22vVk8eL+Bh+WOK/Pva8FSVMH01Ms4cbUBkIeD5Yf5rUDN2t+FAHGHJRexLMnZCs/2Ha+7nDk27mmTxHac=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2573.namprd10.prod.outlook.com (2603:10b6:805:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 14:14:56 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 14:14:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 08/10] qla2xxx: Move heart beat handling from dpc thread
 to workqueue
Thread-Topic: [PATCH 08/10] qla2xxx: Move heart beat handling from dpc thread
 to workqueue
Thread-Index: AQHXpINxFoCh9zdu1ECHQwLCvp6qfquaLsMA
Date:   Wed, 8 Sep 2021 14:14:55 +0000
Message-ID: <CDA4E5FA-6090-4234-8126-FFBC19F29195@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-9-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ff8bd97-0a28-478c-3b0a-08d972d30894
x-ms-traffictypediagnostic: SN6PR10MB2573:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2573C0EBB7389BBC05210E7BE6D49@SN6PR10MB2573.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OSJnumNLc18z93bqulP3OKqNbWxjhB3D8r0aCZ0kECcCb1rZ/4C7IKAIPhn40GENwayshilAZhZoXxFP4e/2jB52LtFgn/e8WA0GUMdBLqSXp4rwKTGpcVpBtuGN5hMmINhtWBM5dO1uznqM1uKwrTYdgPXRchzYxut0bePxtpRDMlB9GSvX5LhZRb5O4zmC3L0HOkUAeOCXkf01O/lbZYkzqf1OSl3lnDoqaSkcsDc/GNJbvAyTWv+wrG0EH9bV/79o6Xcf8nOFy7Xr4LWrnNFcsLNviAeNNGrnFfX3OnQf17KyiUaWx5h7K1nw059gSFFpxQu1/LOjICy9wgVmkbXADhMgcMnheigX/IGls4T10LOQhIqb2RM3uGOayCAVQwXe8B5cpAjB3CSBdl9rNMbY9CaDiZFj0mLBlwW8L/h9xb3BywaGmDbI/XdhuMqscYxFJRioTuNxA2cJxln07wU8dT8XvovJiyHfhdfrbTT6oTxvuxKYXNHMoQA3fIeYFwIRwjpkV1o6vd5IN+URddNf3gDSvcB7vZCthER2LSQVvJhPWZWa221nKyJ474varqJKMRtKFU8x6iK7iZy1qErlWXk4kh+mguz0K0YNdY2KAWbvlOeXZ1vGUL0Y5DJks2UeKzCrCSmCdrfLyHFHwdlj7g4zzSDlNlXQAplxEfWT3SwVi8/ANiAxxL6Ruv9OgiHVtiVQO5mxk9K7ryV1UbNyYhsTbqBaclR0hViBRWH+0tRorjiXcJ15yfQUeOnv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39860400002)(366004)(86362001)(6916009)(316002)(186003)(66446008)(6486002)(5660300002)(8936002)(33656002)(4326008)(64756008)(478600001)(36756003)(71200400001)(44832011)(38070700005)(8676002)(38100700002)(6506007)(2906002)(53546011)(76116006)(26005)(122000001)(6512007)(54906003)(66556008)(66946007)(66476007)(2616005)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjFKMnFYbDNQZTdOQmJ3OWp3Q3BFMThBNjhOWDM1bjNDOCtJeVdjOGd6K1ZF?=
 =?utf-8?B?WXJJUUFzbjJSTUQ4ZWsvMUZVMG1uUmJUckF0ZjJBSWxUSnIrTEhiNmczNk1T?=
 =?utf-8?B?TEI4bHRCcml0d1NxdE00K3piaHFHeHE5Z0s3bHM4YWVhMkg1QUFHUTZnRWRM?=
 =?utf-8?B?MFlRSzNJNFMvMXU0T1NaVFp4dVlHYk9TeGhMcVZ3NS96MWpIZUl1ZklselM2?=
 =?utf-8?B?YXd0UGJPcnpoN2FqQWhwc2hITUhLWFRGMW1kTU12OHNVRllMa3hDN2JEdjIv?=
 =?utf-8?B?aVM0eUt2dmtNQUZTeXhkWkFET0RndHpNS0xYQTY2YzA3TVBES2tReXh5azhp?=
 =?utf-8?B?ZXdyR3FDbWtFNjNSaU9ZVGZIbVFQNDAzSzd3VldGejZxM0FBNEtWbXM3N2tQ?=
 =?utf-8?B?S0RLZkZ2ZVgveGxvaHh2bzM0YmVGK25SMjljNTdndElqS0VHTUVjbGswamRn?=
 =?utf-8?B?K0lIcFhrcnFLRWRCWS9lTGRIWXZZOE1WMlNsVkFNRHVPUnc2M1lMU1ZwM2lD?=
 =?utf-8?B?REhkNlN3bmt0ZnZEUEE5L1VnYy9BaUtkcTd6N0ExN0ZQdHRqL0lkSUxVOFhu?=
 =?utf-8?B?MnRQK1cyOHlIVGVGNWFCZXZFcTlDczVZdnE1dG9lbG5YaytNY0VhQndySWhV?=
 =?utf-8?B?YnZ1QysrNkhCRXEzVTdFblVBSnZCMUttOXNRZlFRalM0cytkb2VheXhIR25i?=
 =?utf-8?B?WkcrQkNkZzVMam5MSDR0RXR3RTNDTUdlVU9YTkN3cFN0MGJBQjBnRDRjcWVG?=
 =?utf-8?B?b2haaUpRakx5eVhuRHN3OS9YWG1QQ1JmVmxZZXZHUm5jVzE1UkZwNzVpQlFo?=
 =?utf-8?B?Sk9vNDRhL3JWMXo0OEZkamxaSlYyVjN3eHJadkJESEVWbEpvMHJEWWxGeUVy?=
 =?utf-8?B?bndOcVRSNklCWEhrMmVFdXZCNzdFcjdzbVk0eWFJMVAwNm5GcW9hK1I2d0ky?=
 =?utf-8?B?L05GUld0VSt3N3FBMjlaTnV1My92bHNvRmxPYTlBekZ1TkdYTHZORGwxQ3ZE?=
 =?utf-8?B?VlBhdFZ6a1hvWmhCVGsxUGtQLzJZT2FFbVN3ajZ5Ui9mVU4rVWRKS1pEcm1z?=
 =?utf-8?B?clBVSnozSjBLVkFseDJaVm1XcDFFK21Pb2FpbkpmaHJPMmZIc3dRK01CSEZP?=
 =?utf-8?B?dm0vRVZIMGdCNEFsNEpVU2VodDdpa2trSmhsRnZpTDRWZWNJL1pZT2pwT2du?=
 =?utf-8?B?Ky95R1kvUlA4Sko5cGc0YnRwUUFDOGY3ZldaMVdKYTVNWVl5alhSbFljdUQx?=
 =?utf-8?B?ZTVsVFJHTGJhaldRNzZLWTFOV1Y2UjVZS3pNZExFWVRBbERVN1hCTmZoUWEw?=
 =?utf-8?B?ZWtMM2F5OElYcjRQQ3cwS2xxTnJDVXFTNEhNYnM1QjRPUHF2NGU2THpPQSt0?=
 =?utf-8?B?ditnU2lRNnNkaXZWNDlOSWRnK1owZEc5SU1IY1M0L1J0SVZGNG9TQk92S3ZS?=
 =?utf-8?B?aGVRZ055OVJyb0RsL3ozZld3VWViNHRDSHVmVVUzSHptR2xpdVJhdFlGa3ZN?=
 =?utf-8?B?Z3FLRVI1T2I4dkEwcXRpb1NMakdMbmVXalJxblFkTCtMd28rejh6dDFGYmhE?=
 =?utf-8?B?Tm1qaFJmN2VnVHFWRnlYWXpkRlFsSmJVYUtRWTd0VmQwM0pLMjhkWThjaVhM?=
 =?utf-8?B?Rjl4T0Z5ZjdiRlVFeFl2WmZEK3BOa2EzQ2F6Yy9XTkNuQUJwOHlsQnpDTkp5?=
 =?utf-8?B?TFNLcm4wV3RPblJTUlJjaFpsRUpxT1UzR0JvMUNWMkJmTEw5eXlWOERHWmpw?=
 =?utf-8?B?aFg1ZGE4T2tYU3pmYW5Lck0yayt5WkhZZ3VBNk5TRloyZnhnand6OGJoWDdT?=
 =?utf-8?B?T1dCVmg3TXBWSmJjWXZDZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC7D78DA05E9CD4F9CC0A9368BBBA348@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff8bd97-0a28-478c-3b0a-08d972d30894
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 14:14:55.5974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cCjF505f9aqc5rNZl1FYjJy/Xf2iNPxQfPVolvYwfz3tEQIrxgKDIjKB2Ix3jjBaAfu8qbfPYtq+nlf+J+MFNoSBalnhUwhwNVJ4IG+Lm+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2573
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080091
X-Proofpoint-GUID: xVVn_pWToEhYEtoBh1Z0TqUEmYb4eFxa
X-Proofpoint-ORIG-GUID: xVVn_pWToEhYEtoBh1Z0TqUEmYb4eFxa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gU2VwIDgsIDIwMjEsIGF0IDI6MjggQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogTWFuaXNoIFJhbmdhbmthciA8bXJhbmdh
bmthckBtYXJ2ZWxsLmNvbT4NCj4gDQo+IERQQyB0aHJlYWQgZ2V0cyByZXN0cmljdGVkIGR1ZSB0
byBhIG5vLW9wIG1haWxib3gsIHdoaWNoIGlzIGEgYmxvY2tpbmcgY2FsbA0KPiBhbmQgaGFzIGEg
aGlnaCBleGVjdXRpb24gZnJlcXVlbmN5LiBUbyBmcmVlIHVwIHRoZSBEUEMgdGhyZWFkIHdlIG1v
dmUgbm8tb3ANCj4gaGFuZGxpbmcgdG8gdGhlIHdvcmtxdWV1ZS4gQWxzbywgbW9kaWZpZWQgcWxh
X2RvX2hiIHRvIHNlbmQgbm8tb3AgTUJDIGlmDQo+IHdlIGRvbuKAmXQgaGF2ZSBhbnkgYWN0aXZl
IGludGVycnVwdHMsIGJ1dCB0aGVyZSBhcmUgc3RpbGwgSU9zIG91dHN0YW5kaW5nDQo+IHdpdGgg
ZmlybXdhcmUuDQo+IA0KPiBGaXhlczogZDk0ZDgxNThlMTg0ICgic2NzaTogcWxhMnh4eDogQWRk
IGhlYXJ0YmVhdCBjaGVjayIpDQoNCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQoNCj4gU2ln
bmVkLW9mZi1ieTogTWFuaXNoIFJhbmdhbmthciA8bXJhbmdhbmthckBtYXJ2ZWxsLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogTmlsZXNoIEphdmFsaSA8bmphdmFsaUBtYXJ2ZWxsLmNvbT4NCj4gLS0t
DQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaCAgfCAgNCArLQ0KPiBkcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfaW5pdC5jIHwgIDIgKw0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
b3MuYyAgIHwgNzQgKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tDQo+IDMgZmlsZXMg
Y2hhbmdlZCwgMzggaW5zZXJ0aW9ucygrKSwgNDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RlZi5oIGIvZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2RlZi5oDQo+IGluZGV4IGJlMmViNzVlZTFhMy4uZDZlMTMxYmYxODI0IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZGVmLmgNCj4gKysrIGIvZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX2RlZi5oDQo+IEBAIC0zNzUwLDYgKzM3NTAsNyBAQCBzdHJ1Y3QgcWxh
X3FwYWlyIHsNCj4gCXN0cnVjdCBxbGFfZndfcmVzb3VyY2VzIGZ3cmVzIF9fX19jYWNoZWxpbmVf
YWxpZ25lZDsNCj4gCXUzMgljbWRfY250Ow0KPiAJdTMyCWNtZF9jb21wbGV0aW9uX2NudDsNCj4g
Kwl1MzIJcHJldl9jb21wbGV0aW9uX2NudDsNCj4gfTsNCj4gDQo+IC8qIFBsYWNlIGhvbGRlciBm
b3IgRlcgYnVmZmVyIHBhcmFtZXRlcnMgKi8NCj4gQEAgLTQ2MDcsNiArNDYwOCw3IEBAIHN0cnVj
dCBxbGFfaHdfZGF0YSB7DQo+IAlzdHJ1Y3QgcWxhX2NoaXBfc3RhdGVfODR4eCAqY3M4NHh4Ow0K
PiAJc3RydWN0IGlzcF9vcGVyYXRpb25zICppc3Bfb3BzOw0KPiAJc3RydWN0IHdvcmtxdWV1ZV9z
dHJ1Y3QgKndxOw0KPiArCXN0cnVjdCB3b3JrX3N0cnVjdCBoYl93b3JrOw0KDQpVc2UgaGVhcnRi
ZWF0X3dvcmsgKHdoaWNoIGlzIG5vdCBhd2Z1bGx5IGxvbmcgYW5kIHJlYWRzIGJldHRlci4NCg0K
PiAJc3RydWN0IHFsZmNfZncgZndfYnVmOw0KPiANCj4gCS8qIEZDUF9DTU5EIHByaW9yaXR5IHN1
cHBvcnQgKi8NCj4gQEAgLTQ3MDgsNyArNDcxMCw2IEBAIHN0cnVjdCBxbGFfaHdfZGF0YSB7DQo+
IA0KPiAJc3RydWN0IHFsYV9od19kYXRhX3N0YXQgc3RhdDsNCj4gCXBjaV9lcnJvcl9zdGF0ZV90
IHBjaV9lcnJvcl9zdGF0ZTsNCj4gLQl1NjQgcHJldl9jbWRfY250Ow0KPiAJc3RydWN0IGRtYV9w
b29sICpwdXJleF9kbWFfcG9vbDsNCj4gCXN0cnVjdCBidHJlZV9oZWFkMzIgaG9zdF9tYXA7DQo+
IA0KPiBAQCAtNDg1NCw3ICs0ODU1LDYgQEAgdHlwZWRlZiBzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCB7
DQo+ICNkZWZpbmUgU0VUX1pJT19USFJFU0hPTERfTkVFREVEIDMyDQo+ICNkZWZpbmUgSVNQX0FC
T1JUX1RPX1JPTQkzMw0KPiAjZGVmaW5lIFZQT1JUX0RFTEVURQkJMzQNCj4gLSNkZWZpbmUgSEVB
UlRCRUFUX0NISwkJMzgNCj4gDQo+ICNkZWZpbmUgUFJPQ0VTU19QVVJFWF9JT0NCCTYzDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyBiL2RyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gaW5kZXggYzZiM2QwZTc0ODllLi5hOWE0MjQzY2Ix
NWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gKysr
IGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiBAQCAtNzAyNSwxMiArNzAyNSwx
NCBAQCBxbGEyeDAwX2Fib3J0X2lzcF9jbGVhbnVwKHNjc2lfcWxhX2hvc3RfdCAqdmhhKQ0KPiAJ
aGEtPmNoaXBfcmVzZXQrKzsNCj4gCWhhLT5iYXNlX3FwYWlyLT5jaGlwX3Jlc2V0ID0gaGEtPmNo
aXBfcmVzZXQ7DQo+IAloYS0+YmFzZV9xcGFpci0+Y21kX2NudCA9IGhhLT5iYXNlX3FwYWlyLT5j
bWRfY29tcGxldGlvbl9jbnQgPSAwOw0KPiArCWhhLT5iYXNlX3FwYWlyLT5wcmV2X2NvbXBsZXRp
b25fY250ID0gMDsNCj4gCWZvciAoaSA9IDA7IGkgPCBoYS0+bWF4X3FwYWlyczsgaSsrKSB7DQo+
IAkJaWYgKGhhLT5xdWV1ZV9wYWlyX21hcFtpXSkgew0KPiAJCQloYS0+cXVldWVfcGFpcl9tYXBb
aV0tPmNoaXBfcmVzZXQgPQ0KPiAJCQkJaGEtPmJhc2VfcXBhaXItPmNoaXBfcmVzZXQ7DQo+IAkJ
CWhhLT5xdWV1ZV9wYWlyX21hcFtpXS0+Y21kX2NudCA9DQo+IAkJCSAgICBoYS0+cXVldWVfcGFp
cl9tYXBbaV0tPmNtZF9jb21wbGV0aW9uX2NudCA9IDA7DQo+ICsJCQloYS0+YmFzZV9xcGFpci0+
cHJldl9jb21wbGV0aW9uX2NudCA9IDA7DQo+IAkJfQ0KPiAJfQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X29zLmMNCj4gaW5kZXggYTFlODYxZWNmYzAxLi4wNDU0Zjc5YTgwNDcgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9vcy5jDQo+IEBAIC0yNzk0LDYgKzI3OTQsMTYgQEAgcWxhMnh4eF9zY2FuX2Zpbmlz
aGVkKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LCB1bnNpZ25lZCBsb25nIHRpbWUpDQo+IAlyZXR1
cm4gYXRvbWljX3JlYWQoJnZoYS0+bG9vcF9zdGF0ZSkgPT0gTE9PUF9SRUFEWTsNCj4gfQ0KPiAN
Cj4gK3N0YXRpYyB2b2lkIHFsYV9oYl93b3JrX2ZuKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykN
Cg0KICAgICAgICAgICAgICBeXl5eXl5eXl5eXl5eXg0KVXNlIHFsYV9oZWFydGJlYXRfd29ya19m
biBmb3IgYmV0dGVyIHJlYWRhYmlsaXR5IA0KDQo+ICt7DQo+ICsJc3RydWN0IHFsYV9od19kYXRh
ICpoYSA9IGNvbnRhaW5lcl9vZih3b3JrLA0KPiArCQlzdHJ1Y3QgcWxhX2h3X2RhdGEsIGhiX3dv
cmspOw0KPiArCXN0cnVjdCBzY3NpX3FsYV9ob3N0ICpiYXNlX3ZoYSA9IHBjaV9nZXRfZHJ2ZGF0
YShoYS0+cGRldik7DQo+ICsNCj4gKwlpZiAoIWhhLT5mbGFncy5tYm94X2J1c3kgJiYgYmFzZV92
aGEtPmZsYWdzLmluaXRfZG9uZSkNCj4gKwkJcWxhX25vX29wX21iKGJhc2VfdmhhKTsNCj4gK30N
Cj4gKw0KPiBzdGF0aWMgdm9pZCBxbGEyeDAwX2lvY2Jfd29ya19mbihzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspDQo+IHsNCj4gCXN0cnVjdCBzY3NpX3FsYV9ob3N0ICp2aGEgPSBjb250YWluZXJf
b2Yod29yaywNCj4gQEAgLTMyMzIsNiArMzI0Miw3IEBAIHFsYTJ4MDBfcHJvYmVfb25lKHN0cnVj
dCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpDQo+IAkgICAg
aG9zdC0+dHJhbnNwb3J0dCwgc2h0LT52ZW5kb3JfaWQpOw0KPiANCj4gCUlOSVRfV09SSygmYmFz
ZV92aGEtPmlvY2Jfd29yaywgcWxhMngwMF9pb2NiX3dvcmtfZm4pOw0KPiArCUlOSVRfV09SSygm
aGEtPmhiX3dvcmssIHFsYV9oYl93b3JrX2ZuKTsNCj4gDQo+IAkvKiBTZXQgdXAgdGhlIGlycXMg
Ki8NCj4gCXJldCA9IHFsYTJ4MDBfcmVxdWVzdF9pcnFzKGhhLCByc3ApOw0KPiBAQCAtNzExOCwx
NyArNzEyOSw2IEBAIHFsYTJ4MDBfZG9fZHBjKHZvaWQgKmRhdGEpDQo+IAkJCXFsYTJ4MDBfbGlw
X3Jlc2V0KGJhc2VfdmhhKTsNCj4gCQl9DQo+IA0KPiAtCQlpZiAodGVzdF9iaXQoSEVBUlRCRUFU
X0NISywgJmJhc2VfdmhhLT5kcGNfZmxhZ3MpKSB7DQo+IC0JCQkvKg0KPiAtCQkJICogaWYgdGhl
cmUgaXMgYSBtYiBpbiBwcm9ncmVzcyB0aGVuIHRoYXQncw0KPiAtCQkJICogZW5vdWdoIG9mIGEg
Y2hlY2sgdG8gc2VlIGlmIGZ3IGlzIHN0aWxsIHRpY2tpbmcuDQo+IC0JCQkgKi8NCj4gLQkJCWlm
ICghaGEtPmZsYWdzLm1ib3hfYnVzeSAmJiBiYXNlX3ZoYS0+ZmxhZ3MuaW5pdF9kb25lKQ0KPiAt
CQkJCXFsYV9ub19vcF9tYihiYXNlX3ZoYSk7DQo+IC0NCj4gLQkJCWNsZWFyX2JpdChIRUFSVEJF
QVRfQ0hLLCAmYmFzZV92aGEtPmRwY19mbGFncyk7DQo+IC0JCX0NCj4gLQ0KPiAJCWhhLT5kcGNf
YWN0aXZlID0gMDsNCj4gZW5kX2xvb3A6DQo+IAkJc2V0X2N1cnJlbnRfc3RhdGUoVEFTS19JTlRF
UlJVUFRJQkxFKTsNCj4gQEAgLTcxODcsNTcgKzcxODcsNTEgQEAgcWxhMngwMF9yc3RfYWVuKHNj
c2lfcWxhX2hvc3RfdCAqdmhhKQ0KPiANCj4gc3RhdGljIGJvb2wgcWxhX2RvX2hlYXJ0YmVhdChz
dHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqdmhhKQ0KPiB7DQo+IC0JdTY0IGNtZF9jbnQsIHByZXZfY21k
X2NudDsNCj4gLQlib29sIGRvX2hiID0gZmFsc2U7DQo+IAlzdHJ1Y3QgcWxhX2h3X2RhdGEgKmhh
ID0gdmhhLT5odzsNCj4gLQlpbnQgaTsNCj4gKwl1MzIgY21wbF9jbnQ7DQo+ICsJdTE2IGk7DQo+
ICsJYm9vbCBkb19oYiA9IGZhbHNlOw0KPiANCg0KdXNlIGRvX2hlYXJ0YmVhdCB3aGljaCBpcyBz
ZWxmLWV4cGxhbmF0b3J5IGFuZCByZWFkcyBiZXR0ZXINCg0KPiAtCS8qIGlmIGNtZHMgYXJlIHN0
aWxsIHBlbmRpbmcgZG93biBpbiBmdywgdGhlbiBkbyBoYiAqLw0KPiAtCWlmIChoYS0+YmFzZV9x
cGFpci0+Y21kX2NudCAhPSBoYS0+YmFzZV9xcGFpci0+Y21kX2NvbXBsZXRpb25fY250KSB7DQo+
ICsJLyoNCj4gKwkgKiBBbGxvdyBkb19oYiBvbmx5IGlmIHdlIGRvbuKAmXQgaGF2ZSBhbnkgYWN0
aXZlIGludGVycnVwdHMsDQo+ICsJICogYnV0IHRoZXJlIGFyZSBzdGlsbCBJT3Mgb3V0c3RhbmRp
bmcgd2l0aCBmaXJtd2FyZS4NCj4gKwkgKi8NCj4gKwljbXBsX2NudCA9IGhhLT5iYXNlX3FwYWly
LT5jbWRfY29tcGxldGlvbl9jbnQ7DQo+ICsJaWYgKGNtcGxfY250ID09IGhhLT5iYXNlX3FwYWly
LT5wcmV2X2NvbXBsZXRpb25fY250ICYmDQo+ICsJICAgIGNtcGxfY250ICE9IGhhLT5iYXNlX3Fw
YWlyLT5jbWRfY250KSB7DQo+IAkJZG9faGIgPSB0cnVlOw0KPiAJCWdvdG8gc2tpcDsNCj4gCX0N
Cj4gKwloYS0+YmFzZV9xcGFpci0+cHJldl9jb21wbGV0aW9uX2NudCA9IGNtcGxfY250Ow0KPiAN
Cj4gCWZvciAoaSA9IDA7IGkgPCBoYS0+bWF4X3FwYWlyczsgaSsrKSB7DQo+IC0JCWlmIChoYS0+
cXVldWVfcGFpcl9tYXBbaV0gJiYNCj4gLQkJICAgIGhhLT5xdWV1ZV9wYWlyX21hcFtpXS0+Y21k
X2NudCAhPQ0KPiAtCQkgICAgaGEtPnF1ZXVlX3BhaXJfbWFwW2ldLT5jbWRfY29tcGxldGlvbl9j
bnQpIHsNCj4gLQkJCWRvX2hiID0gdHJ1ZTsNCj4gLQkJCWJyZWFrOw0KPiArCQlpZiAoaGEtPnF1
ZXVlX3BhaXJfbWFwW2ldKSB7DQo+ICsJCQljbXBsX2NudCA9IGhhLT5xdWV1ZV9wYWlyX21hcFtp
XS0+Y21kX2NvbXBsZXRpb25fY250Ow0KPiArCQkJaWYgKGNtcGxfY250ID09IGhhLT5xdWV1ZV9w
YWlyX21hcFtpXS0+cHJldl9jb21wbGV0aW9uX2NudCAmJg0KPiArCQkJICAgIGNtcGxfY250ICE9
IGhhLT5xdWV1ZV9wYWlyX21hcFtpXS0+Y21kX2NudCkgew0KPiArCQkJCWRvX2hiID0gdHJ1ZTsN
Cj4gKwkJCQlicmVhazsNCj4gKwkJCX0NCj4gKwkJCWhhLT5xdWV1ZV9wYWlyX21hcFtpXS0+cHJl
dl9jb21wbGV0aW9uX2NudCA9IGNtcGxfY250Ow0KPiAJCX0NCj4gCX0NCj4gDQo+IHNraXA6DQo+
IC0JcHJldl9jbWRfY250ID0gaGEtPnByZXZfY21kX2NudDsNCj4gLQljbWRfY250ID0gaGEtPmJh
c2VfcXBhaXItPmNtZF9jbnQ7DQo+IC0JZm9yIChpID0gMDsgaSA8IGhhLT5tYXhfcXBhaXJzOyBp
KyspIHsNCj4gLQkJaWYgKGhhLT5xdWV1ZV9wYWlyX21hcFtpXSkNCj4gLQkJCWNtZF9jbnQgKz0g
aGEtPnF1ZXVlX3BhaXJfbWFwW2ldLT5jbWRfY250Ow0KPiAtCX0NCj4gLQloYS0+cHJldl9jbWRf
Y250ID0gY21kX2NudDsNCj4gLQ0KPiAtCWlmICghZG9faGIgJiYgKChjbWRfY250IC0gcHJldl9j
bWRfY250KSA+IDUwKSkNCj4gLQkJLyoNCj4gLQkJICogSU9zIGFyZSBjb21wbGV0aW5nIGJlZm9y
ZSBwZXJpb2RpYyBoYiBjaGVjay4NCj4gLQkJICogSU9zIHNlZW1zIHRvIGJlIHJ1bm5pbmcsIGRv
IGhiIGZvciBzYW5pdHkgY2hlY2suDQo+IC0JCSAqLw0KPiAtCQlkb19oYiA9IHRydWU7DQo+IC0N
Cj4gCXJldHVybiBkb19oYjsNCj4gfQ0KPiANCj4gc3RhdGljIHZvaWQgcWxhX2hlYXJ0X2JlYXQo
c3RydWN0IHNjc2lfcWxhX2hvc3QgKnZoYSkNCj4gew0KPiArCXN0cnVjdCBxbGFfaHdfZGF0YSAq
aGEgPSB2aGEtPmh3Ow0KPiArDQo+IAlpZiAodmhhLT52cF9pZHgpDQo+IAkJcmV0dXJuOw0KPiAN
Cj4gCWlmICh2aGEtPmh3LT5mbGFncy5lZWhfYnVzeSB8fCBxbGEyeDAwX2NoaXBfaXNfZG93bih2
aGEpKQ0KPiAJCXJldHVybjsNCj4gDQo+IC0JaWYgKHFsYV9kb19oZWFydGJlYXQodmhhKSkgew0K
PiAtCQlzZXRfYml0KEhFQVJUQkVBVF9DSEssICZ2aGEtPmRwY19mbGFncyk7DQo+IC0JCXFsYTJ4
eHhfd2FrZV9kcGModmhhKTsNCj4gLQl9DQo+ICsJaWYgKHFsYV9kb19oZWFydGJlYXQodmhhKSkN
Cj4gKwkJcXVldWVfd29yayhoYS0+d3EsICZoYS0+aGJfd29yayk7DQo+IH0NCj4gDQo+IC8qKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKg0KPiAtLSANCj4gMi4xOS4wLnJjMA0KPiANCg0KLS0NCkhpbWFuc2h1IE1h
ZGhhbmkJIE9yYWNsZSBMaW51eCBFbmdpbmVlcmluZw0KDQo=
