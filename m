Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17319C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 001846120F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhJUOXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:23:43 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36540 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhJUOXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:23:42 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LE4dBB010593;
        Thu, 21 Oct 2021 14:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8cZgj1f/2IH6hHdGFi91iwiIfa/dqz7VjYvuOp0OWJA=;
 b=jOQaTQXHej2dqucIWNy5h6oKNe6ld1aM0yEHOSnybzwMs9cufPU0DWHBtfyKRF5vBCQO
 0LKdqltUdyp9az4UoIAHiAFqLaxSnEU0+WgGawE31BFE1E7g+4He/5zqFqbZD0yl8KNe
 RusN6n5Oe2mVmnk6Ri6vXQ31J29LrNc1nTLNx14YjU4nEQJVlc9hubQvY1Ij5VrUHgLx
 1YWH9TIEJY7flAQO1h2jjFgbo5Tk3IkOprFoYszDbpCYMvyBHO3s6cFiXxsHWG4hMvGs
 04Rsh4sEMXUkE/SRA7GPfVq/yb9hz5T6mLC565iJPd7zy5U/ufYAm3dUZ05qTr0+atJU 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9y3qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:21:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEFfN6035314;
        Thu, 21 Oct 2021 14:21:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 3br8gw3psm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:21:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1XKCxFXMDF+7eYJxLSJTCRNxR45t5tIm0BMzweuVMDc2jdPytkPHrDGVvuyx3dSOjhLmZUJyKWqrLgF/mKf9leDAbBBLnreUdrckGmzk5nKnZ6puUNIltiQye5QAmr6oyIRcEt0QzywsY799YkBmSBKtAGK7Ubq4cQjdw5UBtNDFAKi3aUrhWAwKMnvKjffQFOwew1zFnqVGGTzT9/DI3SJBNoyXYWNjRdGw5tktlQiTUv8OFsxo1tno3ZtevF1Lv9hK/G4xmqV8MrzAad0Giti/e2VsdC9XPbSBFtbyKQ19Vs1eEx6aNZ6IUifSuD02GenftWG+Hp/Sjkjw2rm0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8cZgj1f/2IH6hHdGFi91iwiIfa/dqz7VjYvuOp0OWJA=;
 b=iqSjidZTmzXH90tjlVu5XAQJt5pKkMsEWYuY9gcgf9jPpXt8qtawIhqhsgPVotfIqkPi5QmVWfBQUBQlkbkmTELuR/idn71AgUtCli1awA26a5SglHsZ0z9YUQhyfAvRvN/CLZV6lShe9lKoCR6Y4FE5m3LvCbekAVlsNkQox62KbasYoGWxAzKNJMYcoWw9mfEll0scwv0PH+Hl4Nj5Ueoi0skisOFkidVujGh5rQ1R8F57SuIeGaw46v1HxggCHXf7QbM1opJV87QPM1L/zA/B0FO1HbFTDX7wNMKJKvt2/THGfm+yGkXntv15Tii64qCPkfiWsfh64JsRUH8CNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cZgj1f/2IH6hHdGFi91iwiIfa/dqz7VjYvuOp0OWJA=;
 b=cFOyytE8TniowEnm3IFXscAQijCR5HBfh5IjR0Rgk08sLyrtPVCsip9nTm7Z1z40VrGIWvdljnUogINUq3BdTDJjMYROvKC80ddICcxCKOzdvNdU7V9kgdd0NEj/Ek5bRt1dwI73BcqXwDtXJZrK+vvE3O8wWw72M5bVhGKO0Sc=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by MN2PR10MB3903.namprd10.prod.outlook.com (2603:10b6:208:181::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 14:21:04 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:21:04 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 06/13] qla2xxx: edif: flush stale events and msgs on
 session down
Thread-Topic: [PATCH v2 06/13] qla2xxx: edif: flush stale events and msgs on
 session down
Thread-Index: AQHXxk3UsmXPSKGm6EizU2uhMBcW1KvdgSWA
Date:   Thu, 21 Oct 2021 14:21:04 +0000
Message-ID: <19D6E22B-1049-4E0D-9BC3-43CA36B5FC80@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-7-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54fd84ec-4faa-4148-bdf1-08d9949e043a
x-ms-traffictypediagnostic: MN2PR10MB3903:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR10MB3903DBCBDED86DA326250C29E6BF9@MN2PR10MB3903.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:67;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3OjFQfiTw6qD4TbkPQeENs8mInF/Ylg8jHs+VS3E2gPxJEq8N/A60sc1HhC/XKies+wIz/G2LLA9XGbOj+RgqrV6oQwjYBt4iQfsDDLYWnsOjhdRoM3u5DWvNUCiknpoQENndaUcaAWPO7J41VgLEZ8WJt9xAZd/wXXEIM78oqcjGh3p+74nWn+lMWeFGPoaXhY7oVYRN1qcXUE7qb0N/5PFwqzkwHKTdPh6h0HvNp/wCBesBKaK0g58qKnPIz0C+VlVAMNpKU4Cfu4MKxLmiivnrbG+Hcq00TapKmFYhbiQN93CsJCSctwVzqi+8WZ/y9Eo4kPudg5VYPzfGC759jSDMFhbuK0ShrOVX5d7vJd7uE0DcRFKanAw2g4ZxmeYyF+vqYDjz4hhSYUZTB5BFPuhaOuErO4EDQqRU0AztsJ1EbgdP5rrzqxv5zBVdSzKaGqv4jOltP9CPHIyFgxS8keAsEhYEAYP8GUkOFZxrpA63pHoZNHuWgtZRCSYjcs0oAmCyQYIuO+XTZ2nyqbTtQraSCj3LfhdvFWO4GG+9iSiUjbvl72YAgPq1TW60+1Ie4idJfk/CmuTo9pg3/Zxlmz+MBeG4FepdgDGq3HwKzwmUbSvRMg1BXX9ICjhfWPkdxYOZxSe6b3bDqcLzCNr1edpo1BXkAJGvS3Upxsyo/BMB6/2qsQxvmfJOq/e2ZB6qNpNBFUeZU/FygWxTS95rMx2z8cZHxT5WNPRlEz+WH6jnOMu0rwHTOjRMfv0saEc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(54906003)(91956017)(8676002)(66556008)(38070700005)(33656002)(83380400001)(66446008)(508600001)(38100700002)(36756003)(66946007)(71200400001)(8936002)(53546011)(186003)(66476007)(6486002)(26005)(316002)(5660300002)(2906002)(76116006)(4326008)(122000001)(6916009)(86362001)(64756008)(6512007)(6506007)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnRLb3A4Wm9oUG9HV2YwTkRMUERkSTBmYjZUbEpkRmVwQjBtcVpDVjJBY1l1?=
 =?utf-8?B?VDJkVHZxcWxOdkNzVmIzeVAxeWRKaFMwT1lUZmV3b2dobWdGM1lJbG9vREsw?=
 =?utf-8?B?cVZBZE1oTk8wZ1FLT2J2OGo1cUVjL0JRMnVhd1g2VE5XZEMwa3h3S081K2s0?=
 =?utf-8?B?NHdmWHNzNmR4WWFaK0kvaUNxWFA4RUttOThIVjQwNVBURGY5eUM3SjRzVkVX?=
 =?utf-8?B?QXZjamd5dXNWNlR0dkEyV1RoMVgyRlVqNlE5OUZUNmRWdy9iQis4elNvRS9t?=
 =?utf-8?B?THYzY21iZmlXajN4Z0R6UThyZVFud2xoVHlueU1HT1p3WVFDaFl1U0tWeUZr?=
 =?utf-8?B?WDlOKzhXU2V1MjBPbURwcEFmZEdpRXJqN0hxbDJpV0w5bjNhOTV1RVI5YzNL?=
 =?utf-8?B?VThtNTR1clBxbGdmVmxVSDJmWkVRVk9iSzltdmNENHY3SGF0ZVlzYjlzbTdz?=
 =?utf-8?B?RGJqbWNiY2dQVGdkUDFqUTNHT0toTVh2K2pSQk85cittMG94Wk93NWlYOGpy?=
 =?utf-8?B?UHN1WVRKUEYwejNVTjd1NFVOek1KTHZJY1dPcTZhSHZJZXZDOFN4eDN1c2hY?=
 =?utf-8?B?aW41YzlSRGJmQ0p6VEViNjN5Z3B4R1BLcEV0MXN0eU41c25OYUJjaWxMZHpv?=
 =?utf-8?B?WlpvaXNjK0hnSGZSWDFycXBLaXJaNWhrZnpENWRDamh2WURhR3Y5T2FOYXlV?=
 =?utf-8?B?NDF5Tll6RWc2eUhFVDZxLzdqcm9TODVrU2poUHdPS1d2UmEzMTZmN3NnOHE5?=
 =?utf-8?B?VFFFZkxjUURDaGwxUzJsNVVlZEZhL1FxQmNzT2FJMEwwdWIxUGFiVHdsd09B?=
 =?utf-8?B?OUZpK3I3ZmxLL2w3ZnNNcGFUTHlVbVdWRUhkdkFXWkJyd25vVDloRjBoWHhu?=
 =?utf-8?B?VEN6NW91VXNaczNybFlFZzdNamFrV1JGeVBNV1FTRFhlYTJvNDZGRHZLbGFE?=
 =?utf-8?B?cmh3OU9iYVFBNmxKdENDMHJBUXJiUDRRbEpqTGRPWVlTOWlveWNQNGhESTA1?=
 =?utf-8?B?aE9EMUVRUUVjZEdlbi8vR2hrajZFMEdqR1VJYVgwd1grMEU3eDJycTJDZmN3?=
 =?utf-8?B?dk9VNE00RVhVdXF0eUlYbGwvTHlMYlhNY3k1TDBiOTRFdkZMTzJ6REFpenNu?=
 =?utf-8?B?ZW4ya3JPYzdYNnQwVFYzZzlIbFVrUDZDSUF0d282WUZvcmo3VnRzc1R5eGxZ?=
 =?utf-8?B?N0NSWEw4WjVkYURoeVpBU2x3bjZsN2FvYVpsUHlrUlFoZ05uZ2hpR1N2ZWF5?=
 =?utf-8?B?QTNNR09XS2ErdldQb2s0cmlXZ3MvOW5PMXplSHZQVi9IUFMyd21YalFhRk1p?=
 =?utf-8?B?eFhzOVMzc2lnNnJRaFZiaE03NUc5ZkgvVFMyK1pCZGVTRmhFKzNmRGxoWVBX?=
 =?utf-8?B?QW5Na0FkWjQ0RnovcllEak8zMHp1YlNCaUx0Ly80Mjg5YVk3d0RUNzBUZU9q?=
 =?utf-8?B?RUxUNEk4dVUwaW5WZUVrN1ZtYmVWa3l6OHR3TGhyV1E0NExhdlFEa3JyV2M4?=
 =?utf-8?B?ZGZ1eGV2QkFIUEpTOE5iYWR0VzliRFpQYzY5dnROYzNzV0YxWkM0YVdGUnRJ?=
 =?utf-8?B?RzVNQ3VGQzJ5SW91L29oUnNud0ZWdEJYMllMTWFPWmtEM0duQ3JneFlSVE8r?=
 =?utf-8?B?Ri85TVFEUnFHNXRnV0dLVDE1ZGw3Skp3b2lBUUw1N3VBUDBmRlMxbUl0WVBY?=
 =?utf-8?B?ekk0eFlEUVFFNXFRMFFXTDlmRWQ4V2tjWUlhQStLVVdMcnRSR2FkTzF4U0dG?=
 =?utf-8?B?MllUVkNSZm9zdWFNQzZuN1YwTTdwTmx4RVNnRkJ6c0FyWGtORDQ1U1VBRi9Y?=
 =?utf-8?B?ZEJRTW9EYWVuYitNZlQ2dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EADD6711AA0984A8919C2DF6784244A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fd84ec-4faa-4148-bdf1-08d9949e043a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:21:04.5018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3903
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210077
X-Proofpoint-ORIG-GUID: 4Ys8VNSrfQRPo-KwXnnVFJn9_PTov_Ky
X-Proofpoint-GUID: 4Ys8VNSrfQRPo-KwXnnVFJn9_PTov_Ky
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gT2N0IDIxLCAyMDIxLCBhdCAyOjMyIEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IE9uIHNlc3Npb24gZG93biwgZHJpdmVyIHdpbGwgZmx1c2ggYWxsIHN0
YWxlIG1lc3NhZ2VzIGFuZA0KPiBkb29yYmVsbCBldmVudHMuIFRoaXMgcHJldmVudHMgYXV0aGVu
dGljYXRpb24gYXBwbGljYXRpb24NCj4gZnJvbSBoYXZpbmcgdG8gcHJvY2VzcyBzdGFsZSBkYXRh
Lg0KPiANCj4gRml4ZXM6IDRkZTA2N2U1ZGYxMiAoInNjc2k6IHFsYTJ4eHg6IGVkaWY6IEFkZCBO
Mk4gc3VwcG9ydCBmb3IgRURJRiIpDQo+IFNpZ25lZC1vZmYtYnk6IEthcnVuYWthcmEgTWVydWd1
IDxrbWVydWd1QG1hcnZlbGwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBRdWlubiBUcmFuIDxxdXRy
YW5AbWFydmVsbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+DQo+IC0tLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZWRpZi5jICAg
fCA5OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+IGRyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9nYmwuaCAgICB8ICAyICsNCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3Rhcmdl
dC5jIHwgIDEgKw0KPiAzIGZpbGVzIGNoYW5nZWQsIDEwMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYu
YyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9lZGlmLmMNCj4gaW5kZXggMzNjZGNkZjlmNTEx
Li5iNGVjYTk2NjA2N2EgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9l
ZGlmLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYw0KPiBAQCAtMTU5
NSw2ICsxNTk1LDQxIEBAIHFsYV9lbm9kZV9zdG9wKHNjc2lfcWxhX2hvc3RfdCAqdmhhKQ0KPiAJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdmhhLT5wdXJfY2luZm8ucHVyX2xvY2ssIGZsYWdzKTsN
Cj4gfQ0KPiANCj4gK3N0YXRpYyB2b2lkIHFsYV9lbm9kZV9jbGVhcihzY3NpX3FsYV9ob3N0X3Qg
KnZoYSwgcG9ydF9pZF90IHBvcnRpZCkNCj4gK3sNCj4gKwl1bnNpZ25lZCAgICBsb25nIGZsYWdz
Ow0KPiArCXN0cnVjdCBlbm9kZSAgICAqZSwgKnRtcDsNCj4gKwlzdHJ1Y3QgcHVyZXhldmVudCAg
ICpwdXJleDsNCj4gKwlMSVNUX0hFQUQoZW5vZGVfbGlzdCk7DQo+ICsNCj4gKwlpZiAodmhhLT5w
dXJfY2luZm8uZW5vZGVfZmxhZ3MgIT0gRU5PREVfQUNUSVZFKSB7DQo+ICsJCXFsX2RiZyhxbF9k
YmdfZWRpZiwgdmhhLCAweDA5MTAyLA0KPiArCQkgICAgICAgIiVzIGVub2RlIG5vdCBhY3RpdmVc
biIsIF9fZnVuY19fKTsNCj4gKwkJcmV0dXJuOw0KPiArCX0NCj4gKwlzcGluX2xvY2tfaXJxc2F2
ZSgmdmhhLT5wdXJfY2luZm8ucHVyX2xvY2ssIGZsYWdzKTsNCj4gKwlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5X3NhZmUoZSwgdG1wLCAmdmhhLT5wdXJfY2luZm8uaGVhZCwgbGlzdCkgew0KPiArCQlwdXJl
eCA9ICZlLT51LnB1cmV4aW5mbzsNCj4gKwkJaWYgKHB1cmV4LT5wdXJfaW5mby5wdXJfc2lkLmIy
NCA9PSBwb3J0aWQuYjI0KSB7DQo+ICsJCQlxbF9kYmcocWxfZGJnX2VkaWYsIHZoYSwgMHg5MTFk
LA0KPiArCQkJICAgICIlcyBmcmVlIEVMUyBzaWQ9JXguIHhjaGcgJXgsIG5iPSV4aFxu4oCdLA0K
CQkJCQkgICAgICBeXiAgDQpTaG91bGRu4oCZdCB0aGlzIGJlICUwNng/DQoJDQo+ICsJCQkgICAg
X19mdW5jX18sIHBvcnRpZC5iMjQsDQo+ICsJCQkgICAgcHVyZXgtPnB1cl9pbmZvLnB1cl9yeF94
Y2hnX2FkZHJlc3MsDQo+ICsJCQkgICAgcHVyZXgtPnB1cl9pbmZvLnB1cl9ieXRlc19yY3ZkKTsN
Cj4gKw0KPiArCQkJbGlzdF9kZWxfaW5pdCgmZS0+bGlzdCk7DQo+ICsJCQlsaXN0X2FkZF90YWls
KCZlLT5saXN0LCAmZW5vZGVfbGlzdCk7DQo+ICsJCX0NCj4gKwl9DQo+ICsNCg0KTm8gbmVlZCBm
b3IgbmV3bGluZSBhYm92ZS4NCg0KPiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnZoYS0+cHVy
X2NpbmZvLnB1cl9sb2NrLCBmbGFncyk7DQo+ICsNCj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3Nh
ZmUoZSwgdG1wLCAmZW5vZGVfbGlzdCwgbGlzdCkgew0KPiArCQlsaXN0X2RlbF9pbml0KCZlLT5s
aXN0KTsNCj4gKwkJcWxhX2Vub2RlX2ZyZWUodmhhLCBlKTsNCj4gKwl9DQo+ICt9DQo+ICsNCj4g
LyoNCj4gICogIGFsbG9jYXRlIGVub2RlIHN0cnVjdCBhbmQgcG9wdWxhdGUgYnVmZmVyDQo+ICAq
ICByZXR1cm5zOiBlbm9kZSBwb2ludGVyIHdpdGggYnVmZmVycw0KPiBAQCAtMTc5NCw2ICsxODI5
LDU5IEBAIHFsYV9lZGJfbm9kZV9mcmVlKHNjc2lfcWxhX2hvc3RfdCAqdmhhLCBzdHJ1Y3QgZWRi
X25vZGUgKm5vZGUpDQo+IAlub2RlLT5udHlwZSA9IE5fVU5ERUY7DQo+IH0NCj4gDQo+ICtzdGF0
aWMgdm9pZCBxbGFfZWRiX2NsZWFyKHNjc2lfcWxhX2hvc3RfdCAqdmhhLCBwb3J0X2lkX3QgcG9y
dGlkKQ0KPiArew0KPiArCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ICsJc3RydWN0IGVkYl9ub2Rl
ICplLCAqdG1wOw0KPiArCXBvcnRfaWRfdCBzaWQ7DQo+ICsJTElTVF9IRUFEKGVkYl9saXN0KTsN
Cj4gKw0KPiArCWlmICh2aGEtPmVfZGJlbGwuZGJfZmxhZ3MgIT0gRURCX0FDVElWRSkgew0KPiAr
CQkvKiBkb29yYmVsbCBsaXN0IG5vdCBlbmFibGVkICovDQo+ICsJCXFsX2RiZyhxbF9kYmdfZWRp
ZiwgdmhhLCAweDA5MTAyLA0KPiArCQkgICAgICAgIiVzIGRvb3JiZWxsIG5vdCBlbmFibGVkXG4i
LCBfX2Z1bmNfXyk7DQo+ICsJCXJldHVybjsNCj4gKwl9DQo+ICsNCj4gKwkvKiBncmFiIGxvY2sg
c28gbGlzdCBkb2Vzbid0IG1vdmUgKi8NCj4gKwlzcGluX2xvY2tfaXJxc2F2ZSgmdmhhLT5lX2Ri
ZWxsLmRiX2xvY2ssIGZsYWdzKTsNCj4gKw0KDQpObyBuZWVkIGZvciBuZXdsaW5lIGFib3ZlLg0K
DQo+ICsJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGUsIHRtcCwgJnZoYS0+ZV9kYmVsbC5oZWFk
LCBsaXN0KSB7DQo+ICsJCXN3aXRjaCAoZS0+bnR5cGUpIHsNCj4gKwkJY2FzZSBWTkRfQ01EX0FV
VEhfU1RBVEVfTkVFREVEOg0KPiArCQljYXNlIFZORF9DTURfQVVUSF9TVEFURV9TRVNTSU9OX1NI
VVRET1dOOg0KPiArCQkJc2lkID0gZS0+dS5wbG9naV9kaWQ7DQo+ICsJCQlicmVhazsNCj4gKwkJ
Y2FzZSBWTkRfQ01EX0FVVEhfU1RBVEVfRUxTX1JDVkQ6DQo+ICsJCQlzaWQgPSBlLT51LmVsc19z
aWQ7DQo+ICsJCQlicmVhazsNCj4gKwkJY2FzZSBWTkRfQ01EX0FVVEhfU1RBVEVfU0FVUERBVEVf
Q09NUEw6DQo+ICsJCQkvKiBhcHAgd2FudHMgdG8gc2VlIHRoaXMgICovDQo+ICsJCQljb250aW51
ZTsNCj4gKwkJZGVmYXVsdDoNCj4gKwkJCXFsX2xvZyhxbF9sb2dfd2FybiwgdmhhLCAweDA5MTAy
LA0KPiArCQkJICAgICAgICIlcyB1bmtub3duIHR5cGU6ICV4XG4iLCBfX2Z1bmNfXywgZS0+bnR5
cGUpOw0KCQkJCQkgICBeXl5eDQpQbGVhc2UgYWRkIOKAnG5vZGUgdHlwZSIgZm9yIGVhc2Ugb2Yg
cmVhZGluZyBtZXNzYWdlcyBkdXJpbmcgZGVidWdnaW5nIA0KCQkJCQkNCj4gKwkJCXNpZC5iMjQg
PSAwOw0KPiArCQkJYnJlYWs7DQo+ICsJCX0NCj4gKwkJaWYgKHNpZC5iMjQgPT0gcG9ydGlkLmIy
NCkgew0KPiArCQkJcWxfZGJnKHFsX2RiZ19lZGlmLCB2aGEsIDB4OTEwZiwNCj4gKwkJCSAgICAg
ICAiJXMgRG9vcmJlbGwgZnJlZSA6IHR5cGU9JXggJXBcbuKAnSwNCgkJCQkJXl5eXg0KUGxlYXNl
IGhhdmUgbWVhbmluZ2Z1bCBwcmludHMgZm9yIGVhc2Ugb2YgZGVidWdnaW5nIA0KDQo+ICsJCQkg
ICAgICAgX19mdW5jX18sIGUtPm50eXBlLCBlKTsNCj4gKwkJCWxpc3RfZGVsX2luaXQoJmUtPmxp
c3QpOw0KPiArCQkJbGlzdF9hZGRfdGFpbCgmZS0+bGlzdCwgJmVkYl9saXN0KTsNCj4gKwkJfQ0K
PiArCX0NCj4gKw0KDQpObyBuZWVkIGZvciBuZXdsaW5lIGFib3ZlLiANCg0KPiArCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJnZoYS0+ZV9kYmVsbC5kYl9sb2NrLCBmbGFncyk7DQo+ICsNCj4gKwls
aXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoZSwgdG1wLCAmZWRiX2xpc3QsIGxpc3QpIHsNCj4gKwkJ
cWxhX2VkYl9ub2RlX2ZyZWUodmhhLCBlKTsNCj4gKwkJbGlzdF9kZWxfaW5pdCgmZS0+bGlzdCk7
DQo+ICsJCWtmcmVlKGUpOw0KPiArCX0NCj4gK30NCj4gKw0KPiAvKiBmdW5jdGlvbiBjYWxsZWQg
d2hlbiBhcHAgaXMgc3RvcHBpbmcgKi8NCj4gDQo+IHZvaWQNCj4gQEAgLTIzODAsNyArMjQ2OCw3
IEBAIHZvaWQgcWxhMjR4eF9hdXRoX2VscyhzY3NpX3FsYV9ob3N0X3QgKnZoYSwgdm9pZCAqKnBr
dCwgc3RydWN0IHJzcF9xdWUgKipyc3ApDQo+IAlxbF9kYmcocWxfZGJnX2VkaWYsIGhvc3QsIDB4
MDkxMGMsDQo+IAkgICAgIiVzIENPTVBMRVRFIHB1cmV4LT5wdXJfaW5mby5wdXJfYnl0ZXNfcmN2
ZCA9JXhoIHM6JTA2eCAtPiBkOiUwNnggeGNoZz0leGhcbiIsDQo+IAkgICAgX19mdW5jX18sIHB1
cmV4LT5wdXJfaW5mby5wdXJfYnl0ZXNfcmN2ZCwgcHVyZXgtPnB1cl9pbmZvLnB1cl9zaWQuYjI0
LA0KPiAtCSAgICBwdXJleC0+cHVyX2luZm8ucHVyX2RpZC5iMjQsIHAtPnJ4X3hjaGdfYWRkcik7
DQo+ICsJICAgIHB1cmV4LT5wdXJfaW5mby5wdXJfZGlkLmIyNCwgcHVyZXgtPnB1cl9pbmZvLnB1
cl9yeF94Y2hnX2FkZHJlc3MpOw0KPiANCj4gCXFsYV9lZGJfZXZlbnRjcmVhdGUoaG9zdCwgVk5E
X0NNRF9BVVRIX1NUQVRFX0VMU19SQ1ZELCBzaWQsIDAsIE5VTEwpOw0KPiB9DQo+IEBAIC0zNDAz
LDMgKzM0OTEsMTIgQEAgdm9pZCBxbGFfZWRpZl9zZXNzX2Rvd24oc3RydWN0IHNjc2lfcWxhX2hv
c3QgKnZoYSwgc3RydWN0IGZjX3BvcnQgKnNlc3MpDQo+IAkJcWxhMngwMF9wb3N0X2Flbl93b3Jr
KHZoYSwgRkNIX0VWVF9QT1JUX09GRkxJTkUsIHNlc3MtPmRfaWQuYjI0KTsNCj4gCX0NCj4gfQ0K
PiArDQo+ICt2b2lkIHFsYV9lZGlmX2NsZWFyX2FwcGRhdGEoc3RydWN0IHNjc2lfcWxhX2hvc3Qg
KnZoYSwgc3RydWN0IGZjX3BvcnQgKmZjcG9ydCkNCj4gK3sNCj4gKwlpZiAoIShmY3BvcnQtPmZs
YWdzICYgRkNGX0ZDU1BfREVWSUNFKSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJcWxhX2VkYl9j
bGVhcih2aGEsIGZjcG9ydC0+ZF9pZCk7DQo+ICsJcWxhX2Vub2RlX2NsZWFyKHZoYSwgZmNwb3J0
LT5kX2lkKTsNCj4gK30NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9n
YmwuaCBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9nYmwuaA0KPiBpbmRleCA4ZmFhYTBlYzU5
NWQuLjc2Yjg5YmQyOTdkYyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2dibC5oDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9nYmwuaA0KPiBAQCAtMTQy
LDYgKzE0Miw4IEBAIHZvaWQgcWx0X2Noa19lZGlmX3J4X3NhX2RlbGV0ZV9wZW5kaW5nKHNjc2lf
cWxhX2hvc3RfdCAqdmhhLCBmY19wb3J0X3QgKmZjcG9ydCwNCj4gdm9pZCBxbGEyeDAwX3JlbGVh
c2VfYWxsX3NhZGIoc3RydWN0IHNjc2lfcWxhX2hvc3QgKnZoYSwgc3RydWN0IGZjX3BvcnQgKmZj
cG9ydCk7DQo+IGludCBxbGFfZWRpZl9wcm9jZXNzX2VscyhzY3NpX3FsYV9ob3N0X3QgKnZoYSwg
c3RydWN0IGJzZ19qb2IgKmJzZ2pvYik7DQo+IHZvaWQgcWxhX2VkaWZfc2Vzc19kb3duKHN0cnVj
dCBzY3NpX3FsYV9ob3N0ICp2aGEsIHN0cnVjdCBmY19wb3J0ICpzZXNzKTsNCj4gK3ZvaWQgcWxh
X2VkaWZfY2xlYXJfYXBwZGF0YShzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqdmhhLA0KPiArCQkJICAg
IHN0cnVjdCBmY19wb3J0ICpmY3BvcnQpOw0KPiBjb25zdCBjaGFyICpzY190b19zdHIodWludDE2
X3QgY21kKTsNCj4gDQo+IC8qDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfdGFyZ2V0LmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMNCj4gaW5kZXgg
YjM0NzhlZDliMTJlLi5lZGMzNGU2OWQ3NWIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV90YXJnZXQuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFy
Z2V0LmMNCj4gQEAgLTEwMDMsNiArMTAwMyw3IEBAIHZvaWQgcWx0X2ZyZWVfc2Vzc2lvbl9kb25l
KHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4gCQkJCQkiJXMgYnlwYXNzaW5nIHJlbGVhc2Vf
YWxsX3NhZGJcbiIsDQo+IAkJCQkJX19mdW5jX18pOw0KPiAJCQl9DQo+ICsJCQlxbGFfZWRpZl9j
bGVhcl9hcHBkYXRhKHZoYSwgc2Vzcyk7DQo+IAkJCXFsYV9lZGlmX3Nlc3NfZG93bih2aGEsIHNl
c3MpOw0KPiAJCX0NCj4gCQlxbGEyeDAwX21hcmtfZGV2aWNlX2xvc3QodmhhLCBzZXNzLCAwKTsN
Cj4gLS0gDQo+IDIuMTkuMC5yYzANCj4gDQoNCk9uY2UgeW91IGZpeCBzbWFsbCBuaXRzLCBmZWVs
IGZyZWUgdG8gYWRkDQoNClJldmlld2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5t
YWRoYW5pQG9yYWNsZS5jb20+DQoNCi0tDQpIaW1hbnNodSBNYWRoYW5pCSBPcmFjbGUgTGludXgg
RW5naW5lZXJpbmcNCg0K
