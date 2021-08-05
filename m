Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC0AC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D538060F14
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhHEPxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:53:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51006 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242536AbhHEPxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:53:16 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175Fl1qH025453;
        Thu, 5 Aug 2021 15:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Tq/VHzwHCq/aUp8aEzKugAn++ukZjtShi4D/Q/Hbzys=;
 b=HRTAfaBlNqSTsq9Y0GaotVMpwXKWHkb6BwjTW/cJVtSlExoXa/7DvFwPqWkxWTkFBuRL
 CtEx4ApxUxgaRQpvBTJ5Wa3lf3aQPp4TiwW3y7Hk5WDadNSrezfva+gCRQE/tF5EO90v
 1U/izW2gNQEtYUvprKkBF24HyL4SV9NKsjC0z8dTVNRw4jJiQAAPdjwD54GWQQ+fNewY
 bOBAlipeZRCZbZvmZ/+po5kmIgIzI1gUzA+yYTe8Ps3xpzHorVIUbs75d/NSHad6IizW
 AFDbjMz8TO8N9rYPHg8c8VvkHrEYxHmgsZV1R30aTmgKdnCluw3HK3Yy2LFGt0pUn5tT jw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Tq/VHzwHCq/aUp8aEzKugAn++ukZjtShi4D/Q/Hbzys=;
 b=RUZurtM3iM4IbdVVkcbElHqD1Dss1U7CWLard+hYpE0B2C5H1nDD/raRZMpRkSOY4yrH
 H4bHBuCpCJpdMHPVgfcwXDhfzDcx5bP25xu7ZS+DstWXucGK/5UWjG98gG0gAKkl6W8Z
 LxObbEyq7b1meqtoEJhr2CoWuKFOvfaAiE3+1jAIdjdmSyyNhbDLqS/Q4NJfRVfCYKPA
 vQRk2q3VypWYnT7GeD38OkCG+Rbv5Xya2jpTogwpG2QjhUZD1bTvVfIzh9Ex1+rTI595
 DMdMFPVg+Volr3YBHyjRuwvF1mjo22fAJGrbtvem7YqfdfboAcChbSD1YV0RcooGlTkg fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7hxpmfw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:53:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FjamH023216;
        Thu, 5 Aug 2021 15:52:58 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by userp3030.oracle.com with ESMTP id 3a4un40nf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:52:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2CAxuXssx5c8vbHTCICwKpNvEJjNk66fii/J+GjBvvnl+LYsYtlKTdC+9wWUGZ+Q/7gaBmt/VaVBCeOmCJLxI3FVj2M9onLypInRcnvvNnNxhYvDsC65tBdkKONKHwnH3AqjoGne+XFRoOBb/VbgSY/dRS17RCahwITjf7s5ZlXOhZ87nTwh/lsUgClKuYnNiomy/X5H4GD6IfN7oOTg1pwoEK9EgGK2FbZQ0EIYPt0zguuadbZxAN1YeuM+sAqLsq3CP0jzAHZ5WeCeKjA2HU1zpm1MxsUL/LZhB0vlgRj9SXuMrIRaHE2/XN/ajJm5qgYpwBMhsa0+FSJ6pBMnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tq/VHzwHCq/aUp8aEzKugAn++ukZjtShi4D/Q/Hbzys=;
 b=mMUqdWHAeu6G3WBWRKRDoKOI5sUhhQWvXJXz+udG/F4o/8zjsja0yvBG7bgHr/vrWbtE5VfXMGBXAqncERCBw8PUdttMdCEvNeZrPEsKyGaPH/O2ZH2TKTye6UAIXok5vVfwZpnwNm8MJarzRrQliUZGiBgozIxOZbkES6xrjlvNy6iR10uSYHlDkckg+oLU1PQChkulekWtuSg/B4Fpx/tyWQPgWuHLx0h/X8dZGCT6izs4n/57cWkXabUc56L40UhWJqi7JLZMdRgSXiwt5JOigES4H6A8bS1pN6BX08ShNWrzwpcdHqFr1mP+YPtwNWHIFufaiy48D5wZEUsoUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tq/VHzwHCq/aUp8aEzKugAn++ukZjtShi4D/Q/Hbzys=;
 b=LTxN8yzGXr/He09tz7iVUpZkrZAP+gZ8XRhMb9gfq8BwF1QK3RiL3n+0bXRL+c3dF2oZoaw2wNakq2YSnW9vYTBCCjO3kkv89vVuRRkxHtWzVd9qoUHSUT08FBYrENWeTQcaYnZpyQNLuOCM4X29k30NV9tHXXg+ipNQLhL77Os=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Thu, 5 Aug
 2021 15:52:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:52:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 11/14] qla2xxx: Changes to support kdump kernel
Thread-Topic: [PATCH 11/14] qla2xxx: Changes to support kdump kernel
Thread-Index: AQHXieQoAkhufLQv80mi7cDSGb0Is6tlECCA
Date:   Thu, 5 Aug 2021 15:52:55 +0000
Message-ID: <3EDB3E3C-AE24-4A0B-9336-AFBB571404EB@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-12-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-12-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0a06e36-f9d5-4471-d743-08d958291728
x-ms-traffictypediagnostic: SA2PR10MB4459:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB44593836A0DEFA74710CD70BE6F29@SA2PR10MB4459.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FNTTEgpuf1XrJMR8w21a4FS/FUIIdUarBz4Q9uXSJUEtLYtK6WU9hizbyUlA3OL13bmUJC4HC5pYL843LNjeraE37HMg3jnT9uokvV8Hn3xc/VSANTk+rmvLCiCAUA2E/8jOTfiu7DFku9WQXOW8TlB56sr7iFqwrcjBMLxu5VR2j0ucI4/PCGBHUQcR10yIB6J8E7Od8J7YoGzmR1cupQyWgjOKbRHJnqj9A1N9dOsgu7MELhEgQLhH9CmdhdqTDe/s9ZwfEcN7GvozIAzvfK8u0xLkbykszUhzd8FmUzjeaecf3u6Nk/YhvS8CcbFVUe2opFLYwqbe82z3pWb6r9jWAXpcmUZEWYSgfSSuconwTWVqIAYYLbu+0Hd8XOC32OQFwHEFsx42fJ6zDp4o9sm4hoRWUH3YUC+dgQ5sbyBaNnBviZuNbOED29ifNIrO0KNIzVqm5rsjvMacOyWJQPRU8nPRgOLFpIq/FKf7dVyAuWpPK0HyfSmFI0cn6J6FQ7tvnOtTcuk+KkAjIYoj7ZKospPWHMwdrmG5DlcZYBUQIwfY9TUBxhJg19jZx8m/SQHJ2J1GKrRP3oVQep0DDf/iruPlFqmNigUjqDIp0CyY4Mgs843IRDSR41Bj1zjRfEBJJWQwnEufUDxaqg95lsOI1W17O14m7ren8ErcWwQVFb7IU3JYuFHeBeY0fswAHSTWWW622B6um405+0pvq/FvOQ1049cj3eVrCdHV0rbxgN40aJnK87x0tgz4oja0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39860400002)(26005)(478600001)(6506007)(5660300002)(53546011)(36756003)(6916009)(2616005)(8936002)(6486002)(186003)(64756008)(86362001)(6512007)(76116006)(66476007)(44832011)(71200400001)(33656002)(66946007)(38100700002)(122000001)(66556008)(2906002)(66446008)(54906003)(316002)(4326008)(8676002)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFZ0Y0FmWWdXS3ZLTUpKVy85Y0tmMnhMZkFkSytzQjd4dFlNeTZTMWNNZ29P?=
 =?utf-8?B?Q21ya3VPajNubXl1ZktGUFpVdzR2TjBOOGcxR3ZtWVJJOVN6SWpYbXZ0N0di?=
 =?utf-8?B?V0dxQ2JlYnRaWFRFZjRIa0pDaFVsRDI0bzBBeDNTTllMQlNWQmtyd1RKWUlZ?=
 =?utf-8?B?T21oUDhNWis4Z1RXV0FzV0NkMGdsaUlkK0cyT0ZsUm1yckpJWnIyNVBTRzV4?=
 =?utf-8?B?SXlHK2JGL3R2cjhCVnFUbHFkM2pFMkFFZkRQd1pNWGYxU05FL3NabU9pek4z?=
 =?utf-8?B?c3ZrMXJrTVpvK29NMEw4SW5ZaEZ3QVpjTytSY1pNejkrMlV2TS94bUhEU3pX?=
 =?utf-8?B?NWh6TEl5RlVWRG82WjJQUWRmK2VrT1AyekJZY3VYMllpSGR3Sksyend5T3Zj?=
 =?utf-8?B?eU1jTktlalZDejQ2S2R3aGF5Z2NPR3F3a3pKSGhPZG80YWI3cE90RXhTMU5q?=
 =?utf-8?B?WlIvNDFVK2tUUjlaeFdWZ2JMM082RjZuaVVDYlFkWnlTSklQblU2Rnp5dGhD?=
 =?utf-8?B?UlF1WDRKVnBkMmdpYnQvQnZ2czVQRmw0WjkzdnlYTm4zeTNZb1lMUHVOeExj?=
 =?utf-8?B?c2FDc1NGMVUzL3BDbGV6c2NSQ3JsNElJZi8rVEk2emgxaHE5YTcwaDhhdVVK?=
 =?utf-8?B?bjV0bnpoSDYwOXFxUnd2alNkYkExaTRMblp1Ui9NRC9IRjdWREJFV0R5dXYz?=
 =?utf-8?B?Rkg3Q3U0d25ZMkJmTXc0S3lOTnVHb1ZDMG9QV2x6a08zakRTa0xYV1BLOHh3?=
 =?utf-8?B?UHVkeUFzQm9WaTMzYlZVc3FpZ2JCNWk3SnlYTXM2M2UxSlhTMWp4WFZRSXor?=
 =?utf-8?B?MU1DaDliWDBDYUJ0NnkwRCtNTTBhcWlTd0xzbVcwRnRUOWFhemFLZ3l6dnpU?=
 =?utf-8?B?S1llU3RSN0RkQlg1SnhkQWFBY0x2dFBlTGpWWS9XWFJKajZPY1BDV3IxV0NX?=
 =?utf-8?B?KzRQQ29jQlpvTTRXWnA4WCtQMGhRUzlvWHpZK2NUUGRodWxPWFNqeFhDSlo2?=
 =?utf-8?B?SmRCTTJJVVZ4a0Z2ZER5MjA2MGhOV2dwS25QbGZySjZhdjBWNmMyZTBEYmor?=
 =?utf-8?B?RE8wR2dZZmNBYWk3VGkwdWJZd0oyc1JVK2NrekVnaFBJeTBJMCtMS2kycldX?=
 =?utf-8?B?dFNvOXNIb3pJdVhrOGdMRmlYOGZSbGFwNWpUK0tEVUVXQytuMWs3dlZGcm0r?=
 =?utf-8?B?THlxeERLTG82WVROS1FFaWN0V1k0NGlndlpOTTdqZzV2MUpwT3BYcnpQQzd6?=
 =?utf-8?B?dktsWWZFVHJNSUV3U1JxTXRmRWdLSFFTNnhSWGpGeWdrWmN3VC91THllaXdz?=
 =?utf-8?B?TWZuUHJlSHBIZjN1MmtnUjR2Tk1xMWxoMnBYOWE4SG9xK1Z1ejJmcExJYUt4?=
 =?utf-8?B?RGIva3ZiSVJRR1hLZ3BhbkFkRUxYaGdQaEVzVGI0M2JIVlMrNHZzMXBHTnpF?=
 =?utf-8?B?WVI2ZkJtbThSTDBMTmdFVW1RRVU3MStVSURQWGhHck9ITzJuSEk3TXdDOVg2?=
 =?utf-8?B?TkVrdktLcUs1bXdCdVNoOHZOb3FGV3doVXZTa0VmOXpKOHRiaCtUWmMzK3lt?=
 =?utf-8?B?eFdrbDI3dzZhcXdjc0NhNEdZbHR2a0ZheHVCeVNGemt6ZytiREszcW9vSWVT?=
 =?utf-8?B?YnV1eVNQdzRDUUZBYVhXR1hJRnVJdnJxc0NwclBRN1ZBUXNPZmJFR0N0anNR?=
 =?utf-8?B?MllpQkF2R3NjUEIwamdVMTN0L1E5bURuU1lwSFo5eXFER3lRNXZkN3FRd3Vm?=
 =?utf-8?B?R2d0aHNZVUs4R1phT0IxMHJORG5EcE9tTEk2YWdCU0dCMy95V1BzdUMzZytC?=
 =?utf-8?B?SE1OQkhrdDVoTkFGdmxPZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67C6D6AD00BB8F44B810034127E0AEFD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a06e36-f9d5-4471-d743-08d958291728
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:52:55.4721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ajN9VMNIZACj1SB9BUUyZBZSgJNPRDqDlbwfZ/IJdD5Rxm6n1WOhPsnS2k4ZPdJubOeYt7R7k4cvBtMbZNtTZW5vu0/qt7plwZblBGhNqFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050096
X-Proofpoint-GUID: J_Di7iKPr1MDl6omGtpsdmjOHlPPOKQN
X-Proofpoint-ORIG-GUID: J_Di7iKPr1MDl6omGtpsdmjOHlPPOKQN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gQXVnIDUsIDIwMjEsIGF0IDU6MjAgQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFw
QG1hcnZlbGwuY29tPg0KPiANCj4gRG9uJ3QgYWxsb2NhdGUgZncgZHVtcCBmb3Iga2V4ZWMga2Vy
bmVsLg0KPiBBbGxvY2F0ZSBzaW5nbGUgUSBmb3Iga2V4ZWMga2VybmVsLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFwQG1hcnZlbGwuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiAtLS0NCj4gZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMgfCA2ICsrKysrKw0KPiAxIGZpbGUgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX29zLmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYw0KPiBpbmRleCBkZjQyODQ5
ZTdjY2MuLmQ4OTlmODE0YzFhZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX29zLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMNCj4gQEAgLTE0
LDYgKzE0LDcgQEANCj4gI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4NCj4gI2luY2x1ZGUgPGxpbnV4
L2Jsay1tcS1wY2kuaD4NCj4gI2luY2x1ZGUgPGxpbnV4L3JlZmNvdW50Lmg+DQo+ICsjaW5jbHVk
ZSA8bGludXgvY3Jhc2hfZHVtcC5oPg0KPiANCj4gI2luY2x1ZGUgPHNjc2kvc2NzaV90Y3EuaD4N
Cj4gI2luY2x1ZGUgPHNjc2kvc2NzaWNhbS5oPg0KPiBAQCAtMjgzOSw2ICsyODQwLDExIEBAIHFs
YTJ4MDBfcHJvYmVfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2Rl
dmljZV9pZCAqaWQpDQo+IAkJCXJldHVybiByZXQ7DQo+IAl9DQo+IA0KPiArCWlmIChpc19rZHVt
cF9rZXJuZWwoKSkgew0KPiArCQlxbDJ4bXFzdXBwb3J0ID0gMDsNCj4gKwkJcWwyeGFsbG9jZndk
dW1wID0gMDsNCj4gKwl9DQo+ICsNCj4gCS8qIFRoaXMgbWF5IGZhaWwgYnV0IHRoYXQncyBvayAq
Lw0KPiAJcGNpX2VuYWJsZV9wY2llX2Vycm9yX3JlcG9ydGluZyhwZGV2KTsNCj4gDQo+IC0tIA0K
PiAyLjE5LjAucmMwDQo+IA0KDQpEb27igJl0IHlvdSB3YW50IHRoaXMgaW4gc3RhYmxlPyANCg0K
T3RoZXJ3aXNlIOKApg0KDQpSZXZpZXdlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUu
bWFkaGFuaUBvcmFjbGUuY29tPg0KDQotLQ0KSGltYW5zaHUgTWFkaGFuaQkgT3JhY2xlIExpbnV4
IEVuZ2luZWVyaW5nDQoNCg==
