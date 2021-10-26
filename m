Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BC2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 17:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0758A6103C
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 17:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbhJZRXD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 13:23:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13730 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236503AbhJZRXC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 13:23:02 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QH9Yca030702;
        Tue, 26 Oct 2021 17:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nRcFgiloJzi+oTPJ3Nh/GFhHaiqJibeGJtFfY2guZ90=;
 b=isjdpgTpzDfjdsDCXsI87/hLw5D0aQKJD8G5kCvL6PUbte7cybD3lNKNZW63fSNmcgh0
 PMk0n5F+Bv/ItdZ89lm3ULmAl1nQGUusGBACUVAy/asfznGgkxNcmchxkj7CpsGL2zoY
 EqqWnGUs7T4NB8/vQezQ1y1rKdCOiRteGzWnJAKIrFq7dUZdrfwbtaJV+/NpA6bCaZn7
 AhWrCmdkW8mBiUGsgQrfOj4qg30aNDPpt4ET5J51sdOR5L3LVkC2Bnfq978DGhMR2KG3
 JfgGbo2U+piy0KuZ2/zNlUrZHmiaKREgsPr54Rzvyevft8073H/Wx4O6RiKRQ0PqxKM9 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fhwyft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 17:20:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QHFwTf104188;
        Tue, 26 Oct 2021 17:20:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3bx4h0wpxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 17:20:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+4jzYUitVnb2B+sO1dUXIa6Bt5AVB4oS+RoJ2loDIo6OfrLhDBVJEK/LQvaZw3JN7GzOeEkY1rEu57QyAYL4D+CcJYZLYdvmdeX9K7DMmFN464kiBRw7bugkLEos8jWCCAkchQo3JtUxvrg8M4W8qSVGjh6W30w/tJmH9GziWfwrjO7Jo2HxwNZYuyEiQCpq+w9AUhlRE5BySpunYEQlY6omux+kVWkc9E9Fm7QrhEdhGkm/g59Psb/O95lKatRGo+iH/Og9Tglt9lnFjp5IbLJnwhkGzxAsISbxnqb28QJTESeET/HRk5O+yBLNs6gTTlbpz7B7MSrNvhaC1SzgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRcFgiloJzi+oTPJ3Nh/GFhHaiqJibeGJtFfY2guZ90=;
 b=VHFwCguD9zfaNYnLPA3PBg7YZm2TISucWqGUiZ8XZW1q3q5LSiQ+Wa0o2AYHTGGu4AyxUfVHmHTn+Xq+in8KRShasExeh/bthO5NjJT44Z82Xfxh7+0/ZtGG0qK7XMecx3MnYdvfvtZeoI5fLrefIZX+5syk3ijFR9M/xNTcbwVEmKFCIhNd3fC1L9BcrzwoRkActbiYzmEN8kASxH7KqoceXdZwqmkwViDTbBDh86S6MXiQb6W6U8vIWYW2IWkQ+CELOPSWuT+RJbZvS5G8GuBQtW2Mkxya8LXiqsNJaZU8SHoce+2OdgsFrvF9V38oN8cBDylwz03VzD36K/SjBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRcFgiloJzi+oTPJ3Nh/GFhHaiqJibeGJtFfY2guZ90=;
 b=lucHwU57cgQ3W209HaO8z70tz56tdzTbA0aVwn5HKqKphOd1S0o5v933vowMq0Hl8Z9SrZdgcIEmJSbL33o8XpQoejwbSe5RmToV291kKxCmJa35DnoSSHcLwZ/3Lsz7wAq+gmJgPzphtt+pRxcYvLeEEABFl2Hfu7zhcYzdwKE=
Received: from BYAPR10MB2934.namprd10.prod.outlook.com (2603:10b6:a03:85::22)
 by BYAPR10MB2983.namprd10.prod.outlook.com (2603:10b6:a03:83::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 17:20:23 +0000
Received: from BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::ade0:1aaa:96e9:4392]) by BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::ade0:1aaa:96e9:4392%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 17:20:23 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v3 04/13] qla2xxx: edif: fix app start fail
Thread-Topic: [PATCH v3 04/13] qla2xxx: edif: fix app start fail
Thread-Index: AQHXymBCZjnf2ca7Pkax4F6O2e1Hs6vlhsIA
Date:   Tue, 26 Oct 2021 17:20:23 +0000
Message-ID: <09455F93-1BBB-4CD9-B9E1-CD1956DB33AC@oracle.com>
References: <20211026115412.27691-1-njavali@marvell.com>
 <20211026115412.27691-5-njavali@marvell.com>
In-Reply-To: <20211026115412.27691-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fde88c2-5cd6-406d-4129-08d998a4e523
x-ms-traffictypediagnostic: BYAPR10MB2983:
x-microsoft-antispam-prvs: <BYAPR10MB2983D0381266C818913C84E8E6849@BYAPR10MB2983.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:209;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tn0tAFAw8e0OIzaPOpyyUmbU6scrpow2CtdCuki56CT+EmP8mG1e8eNLbRuanBMkHhIFzR0P72DpOjrRUR4QDF95oPv1HqpNjYkl3HEVcfyRju57oFinqDLTDQ4RwrNIVpETtAyL/y3RYMvaToEwiiGFri4Zl+8fzJRVzZ0PoxURH5R1SP6lavUXJ4cq8cWI59yEfH+/9Tn81swek1FiHPV0wkmrdigi1GNGAutqUwbzRUUsOTpoRsrAKEAYGD6VFe+3DC8uY3arqtNirgfL8OlGQNjZ5NIMV1QrBWHurn1J/VfEyXA8d/Wh5es3tRS7gT5fcHGfFiXY1slOynNRFAbVPZ3TnktOMKSlBRsOMiEhJhoc5BfBZTelemtQvJwj+NAaXBgwYyznVz62mJe84tP3chhVDntpNRwHTlTlaGzdlNLMh+v0vMTc/x36snt0Dl9yh6ZQgTNdH1XPG38FuZPYM6OLv4LPuLtQES2zL1On9CZi1ps9m0DT3+Wq4WBdzWFyB/kD8xEpL/k8d37Dq3jLI7GNhfbfOXJWxhIXP+5XGN3ufN3pBhJK7Py8+DDR5xSGCMZWecqsy7f0O55uLRZIwnd0eX641FYihfZUp81Yc9tURBlGyIZgtVKXv0d6U6nK3fNC1nTX2b2lm70JeU/sS0KI9x9gCGSiKGkoygVluH2uNJxyXwq4yB2aQJjB4v8GNHRBQGMily08tAGtrF97V0TQHLhgzfom7pCoKp9W8yvak3XqWEoFowqs5Q3Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2934.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66446008)(53546011)(66946007)(66476007)(6916009)(64756008)(76116006)(4326008)(6512007)(5660300002)(8676002)(6506007)(36756003)(91956017)(44832011)(38070700005)(86362001)(508600001)(26005)(8936002)(33656002)(83380400001)(2906002)(186003)(71200400001)(54906003)(316002)(2616005)(6486002)(122000001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WksyQTI0S3AzelRydXYyYmUvdDZNUlp2V1F5aHoweXRqbkFaTnRXaXF6TTVO?=
 =?utf-8?B?aFlLdlluSTgwQnBZRGoveHkwTUl0RFlXQTNERGtUZkpJL0xWTkJmQTY5M1hG?=
 =?utf-8?B?S1NCVG4xQ1lQVHlKVjZvTUxJNisxQWEybjBJRm5JeUR1bUZEQ2VWdy9DcEtB?=
 =?utf-8?B?eUNqOExtblFKdUJJZW5ISXBIYkJvQmpBdEl5VTNHZlpLcEc4MWkrQ3I0L0V3?=
 =?utf-8?B?UGFubzAzVGhBYnExN25oUU1WL1Z0ZWhRYmQ4ZndodDY5dDRIQy9NNnQvSStB?=
 =?utf-8?B?RlVBWmZtR0Q5QzcrZE5vd3NyRzc3dXRNVlJxczlYWkNkTGlyUkZvSUt2Smt0?=
 =?utf-8?B?R3V0eEY4SDhJNTNndW14Yk5TTktKY3pabVhac09nWWwxSHpUL1pnRFlacDdE?=
 =?utf-8?B?MVRvWmlmNkRoSjFPNEVLR2ZGMU1CcHlNNjkzMHNWV25hR3NLNmNBQVRUU0dh?=
 =?utf-8?B?Z0VYRlcyQWh4UHgxNW0vVkdXMGFNWFJmK25HbjJ4OEZCSXk4VGU4dk9mV3lh?=
 =?utf-8?B?TDQ1cWQvNVQwTEtuT2J4eWtRL0NiRHBKT2tDRzh5OUh5QVNlYlduTTdabTJK?=
 =?utf-8?B?ZjU5cGhFL0NVUWZJSzVXdjE0TEF2cnhZREVLOEErRzAyQitXLzgyOElGdDJP?=
 =?utf-8?B?RjBBMjhTc2I1K05KL25JVGFiMFhnUzVVVTNiRG01ZEUyazRYbHdWZDJVZnBT?=
 =?utf-8?B?NmhJRVhUVFE4V28vWjlobVlwMFJ3NGJVSEc5UEV5eml0bHJNTVRnQXo0M3RD?=
 =?utf-8?B?aUxBa0VoTndndUVranVuMENkZWcyZVovUGhESzZ6U09HYlJkMHNlVCtkRFhz?=
 =?utf-8?B?dWNNZkMxVG4rM1hVNXRCMDlnR045QnIrVkdFYU9NaEh4L0tvUkRuYVBUdW90?=
 =?utf-8?B?Qm02T1hrTFlpVVRBRXZ1NHFtTjJxQnRMVGZzeGtTbUdsNCtuYkJERjBIV0Rr?=
 =?utf-8?B?MVl2Tm44UVdkcHowcVhZR1NzQnpPcEhJekRtN29OTnBnSnJNcEJIZW90dldR?=
 =?utf-8?B?MVNkMzNnWFkrUXp1U0tzMlJoRHhsNmluMHNPNjZ0M0s0czI4ckZ4NXdrN0hj?=
 =?utf-8?B?SUNSZkxRU3VOM09KeHF1MXRnU05ncU5mQTZBMXBrTUVQdkpRN3o4NEZsTlJS?=
 =?utf-8?B?YVhCTUtKbDQycmRhN1c5N0NrTU01MVlscXhBNUhoRzkyL2NUcFpPYUVLQjRF?=
 =?utf-8?B?SnJsWU5ZNEhRQURhcGJDWFE5MXlEWlJTL25UUk94SEFSMk5FUUZGbGFBL2VE?=
 =?utf-8?B?azI3cEE2cDVjektuNEJ4WlMyb1JiQnlVVkpQUktEYnlNZC92L1FpMnRkQTJ1?=
 =?utf-8?B?Q1lxTU1EZkNTLytXSXp3OHAybWp1ZmV4QmxWcEtRVlJjck1KRWUwRzBoK3JL?=
 =?utf-8?B?N2hPZFptdG0rTENZY1NVWlBRMXMxOXBqeXhNb3Nta2FGMVQyL1pLVnI3QUt3?=
 =?utf-8?B?VzJkMGhwVE5XR09RUVo5RUtHVGZQVWJ1bnhkVnlqSW9uRStDem5mMDZpRWIx?=
 =?utf-8?B?a2pzU2F2VkEvZHpVNVdlYWNsRS9Ud0hGVlA4czVUYzNwSFpmaW5PRzBtd3l4?=
 =?utf-8?B?V1JPeDExTHg4M1hleEpMZ0JJYkFHQVlBR0RLZGRnOS8zYzdML2E1OC9BN3Na?=
 =?utf-8?B?SkNTUC9leEorM251TklETTNKTU05WldwM0lkSWhVVWo1ZVpYWFMvNUdiTzZQ?=
 =?utf-8?B?STBrenUwV3Z5OWptSys4WHh6QzNxTnJtYzUwb1FrcWZpYUZwWTVVYjJGSlFK?=
 =?utf-8?B?ZTJHUXN4dHhQeldJbDAwdld3YVllaTY2eTVIRUFNTUZWOGE3eHRRbDYxZFRx?=
 =?utf-8?B?N3Z6TmUyTTYwMjl0M0QrdXh6bWZlV0NBZ3JBRjJkNHpKcjM5VVlTS1dnd2Yy?=
 =?utf-8?B?bWl5VGdxdytjOENpZWQxUWl6ZzBBVENKVTFuOEs2V0JLenpjejhwT1VtcDcr?=
 =?utf-8?B?dVdCZVFtdExQeFdpajRrM1FUay9GbEpsZDNJNjNFUTVXaWpUcFNuYnhTYWhF?=
 =?utf-8?B?dW9GZHVnNGFhSFdTNFJ4eFByYVBBL0ZHQlNMbk9mMmZPSnp1ak00Vyt4ajY3?=
 =?utf-8?B?K0JHemRVUi9rTUFncEhrQVBXY0xpNVBwanB2UjVpVlBzeXh3d1hNdjdkMXZs?=
 =?utf-8?B?eGVlTjNMemNVZ3Y0RXdaYzBIZVV6ZnR0SGtxWE5NYmhUT25uaENWL3NpUE1S?=
 =?utf-8?B?S3VGclFXb3dMZU1rTTdlUVR4QVA5eTZrbkxoaXJ1ZjBmNkx4YytBK0VtMlE2?=
 =?utf-8?Q?rzPT8xOwqM49IeesBA6+96EoDyzTVFsDIowfJEZHlE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98AF5A356A04924B801155E71DF67F83@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2934.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fde88c2-5cd6-406d-4129-08d998a4e523
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 17:20:23.5227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YLTkXEPZAB3Efo8xlUIYKRzb7Ovcc9xqLFzSTpKbRLlItnAwDa8yx7lQIMUwwW+TUDLObehz1k1fotSbOzUn9domhjEGL8x+NWUjhvH1bLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2983
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260094
X-Proofpoint-ORIG-GUID: kV0rlrz2YWJoY6jvjo8hYG46FU8Fleu0
X-Proofpoint-GUID: kV0rlrz2YWJoY6jvjo8hYG46FU8Fleu0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gT2N0IDI2LCAyMDIxLCBhdCA2OjU0IEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IE9uIGFwcCBzdGFydCwgYWxsIHNlc3Npb25zIG5lZWQgdG8gYmUgcmVz
ZXQgdG8gc2VlDQo+IGlmIHNlY3VyZSBjb25uZWN0aW9uIGNhbiBiZSBtYWRlLiBGaXggdGhlDQo+
IGJyb2tlbiBjaGVjayB3aGljaCBwcmV2ZW50cyB0aGF0IHByb2Nlc3MuDQo+IA0KPiBGaXhlczog
NGRlMDY3ZTVkZjEyICgic2NzaTogcWxhMnh4eDogZWRpZjogQWRkIE4yTiBzdXBwb3J0IGZvciBF
RElGIikNCj4gU2lnbmVkLW9mZi1ieTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiBS
ZXZpZXdlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29t
Pg0KPiAtLS0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYyB8IDUyICsrKysrKysr
KysrKysrKystLS0tLS0tLS0tLS0tLS0tLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMjYgaW5zZXJ0aW9u
cygrKSwgMjYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Fs
YTJ4eHgvcWxhX2VkaWYuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9lZGlmLmMNCj4gaW5k
ZXggYWQ3NDZjNjJmMGQ0Li42MTU1OTZiZWNiN2EgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9lZGlmLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2Vk
aWYuYw0KPiBAQCAtNTI5LDcgKzUyOSw4IEBAIHFsYV9lZGlmX2FwcF9zdGFydChzY3NpX3FsYV9o
b3N0X3QgKnZoYSwgc3RydWN0IGJzZ19qb2IgKmJzZ19qb2IpDQo+IAlzdHJ1Y3QgYXBwX3N0YXJ0
X3JlcGx5CWFwcHJlcGx5Ow0KPiAJc3RydWN0IGZjX3BvcnQgICpmY3BvcnQsICp0ZjsNCj4gDQo+
IC0JcWxfZGJnKHFsX2RiZ19lZGlmLCB2aGEsIDB4OTExZCwgIiVzIGFwcCBzdGFydFxuIiwgX19m
dW5jX18pOw0KPiArCXFsX2xvZyhxbF9sb2dfaW5mbywgdmhhLCAweDEzMTMsDQo+ICsJICAgICAg
ICJFRElGIGFwcGxpY2F0aW9uIHJlZ2lzdHJhdGlvbiB3aXRoIGRyaXZlciwgRkMgZGV2aWNlIGNv
bm5lY3Rpb25zIHdpbGwgYmUgcmUtZXN0YWJsaXNoZWQuXG4iKTsNCj4gDQo+IAlzZ19jb3B5X3Rv
X2J1ZmZlcihic2dfam9iLT5yZXF1ZXN0X3BheWxvYWQuc2dfbGlzdCwNCj4gCSAgICBic2dfam9i
LT5yZXF1ZXN0X3BheWxvYWQuc2dfY250LCAmYXBwc3RhcnQsDQo+IEBAIC01NTQsMzcgKzU1NSwz
NiBAQCBxbGFfZWRpZl9hcHBfc3RhcnQoc2NzaV9xbGFfaG9zdF90ICp2aGEsIHN0cnVjdCBic2df
am9iICpic2dfam9iKQ0KPiAJCXFsYTJ4eHhfd2FrZV9kcGModmhhKTsNCj4gCX0gZWxzZSB7DQo+
IAkJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGZjcG9ydCwgdGYsICZ2aGEtPnZwX2ZjcG9ydHMs
IGxpc3QpIHsNCj4gKwkJCXFsX2RiZyhxbF9kYmdfZWRpZiwgdmhhLCAweDIwNTgsDQo+ICsJCQkg
ICAgICAgIkZDU1AgLSBubiAlOHBoTiBwbiAlOHBoTiBwb3J0aWQ9JTA2eC5cbiIsDQo+ICsJCQkg
ICAgICAgZmNwb3J0LT5ub2RlX25hbWUsIGZjcG9ydC0+cG9ydF9uYW1lLA0KPiArCQkJICAgICAg
IGZjcG9ydC0+ZF9pZC5iMjQpOw0KPiAJCQlxbF9kYmcocWxfZGJnX2VkaWYsIHZoYSwgMHhmMDg0
LA0KPiAtCQkJICAgICAgICIlczogc2VzcyAlcCAlOHBoQyBsaWQgJSMwNHggc19pZCAlMDZ4IGxv
Z291dCAlZFxuIiwNCj4gLQkJCSAgICAgICBfX2Z1bmNfXywgZmNwb3J0LCBmY3BvcnQtPnBvcnRf
bmFtZSwNCj4gLQkJCSAgICAgICBmY3BvcnQtPmxvb3BfaWQsIGZjcG9ydC0+ZF9pZC5iMjQsDQo+
IC0JCQkgICAgICAgZmNwb3J0LT5sb2dvdXRfb25fZGVsZXRlKTsNCj4gLQ0KPiAtCQkJcWxfZGJn
KHFsX2RiZ19lZGlmLCB2aGEsIDB4ZjA4NCwNCj4gLQkJCSAgICAgICAia2VlcCAlZCBlbHNfbG9n
byAlZCBkaXNjIHN0YXRlICVkIGF1dGggc3RhdGUgJWQgc3RvcCBzdGF0ZSAlZFxuIiwNCj4gLQkJ
CSAgICAgICBmY3BvcnQtPmtlZXBfbnBvcnRfaGFuZGxlLA0KPiAtCQkJICAgICAgIGZjcG9ydC0+
c2VuZF9lbHNfbG9nbywgZmNwb3J0LT5kaXNjX3N0YXRlLA0KPiAtCQkJICAgICAgIGZjcG9ydC0+
ZWRpZi5hdXRoX3N0YXRlLCBmY3BvcnQtPmVkaWYuYXBwX3N0b3ApOw0KPiArCQkJICAgICAgICIl
czogc2Vfc2VzcyAlcCAvIHNlc3MgJXAgZnJvbSBwb3J0ICU4cGhDICINCj4gKwkJCSAgICAgICAi
bG9vcF9pZCAlIzA0eCBzX2lkICUwNnggbG9nb3V0ICVkICINCj4gKwkJCSAgICAgICAia2VlcCAl
ZCBlbHNfbG9nbyAlZCBkaXNjIHN0YXRlICVkIGF1dGggc3RhdGUgJWQiDQo+ICsJCQkgICAgICAg
InN0b3Agc3RhdGUgJWRcbuKAnSwNCg0KU2luY2UgeW91IGFyZSBtb2RpZnlpbmcgdGhpcyBkZWJ1
ZyBsb2csIHBsZWFzZSBwdXQgZXZlcnl0aGluZyBvbiBzYW1lIGxpbmUsIGRvbuKAmXQgaGF2ZSB0
byBzcGxpdCBtZXNzYWdlIGFjcm9zcyBsaW5lcy4gDQoNCj4gKwkJCSAgICAgICBfX2Z1bmNfXywg
ZmNwb3J0LT5zZV9zZXNzLCBmY3BvcnQsDQo+ICsJCQkgICAgICAgZmNwb3J0LT5wb3J0X25hbWUs
IGZjcG9ydC0+bG9vcF9pZCwNCj4gKwkJCSAgICAgICBmY3BvcnQtPmRfaWQuYjI0LCBmY3BvcnQt
PmxvZ291dF9vbl9kZWxldGUsDQo+ICsJCQkgICAgICAgZmNwb3J0LT5rZWVwX25wb3J0X2hhbmRs
ZSwgZmNwb3J0LT5zZW5kX2Vsc19sb2dvLA0KPiArCQkJICAgICAgIGZjcG9ydC0+ZGlzY19zdGF0
ZSwgZmNwb3J0LT5lZGlmLmF1dGhfc3RhdGUsDQo+ICsJCQkgICAgICAgZmNwb3J0LT5lZGlmLmFw
cF9zdG9wKTsNCj4gDQo+IAkJCWlmIChhdG9taWNfcmVhZCgmdmhhLT5sb29wX3N0YXRlKSA9PSBM
T09QX0RPV04pDQo+IAkJCQlicmVhazsNCj4gLQkJCWlmICghKGZjcG9ydC0+ZmxhZ3MgJiBGQ0Zf
RkNTUF9ERVZJQ0UpKQ0KPiAtCQkJCWNvbnRpbnVlOw0KPiANCj4gCQkJZmNwb3J0LT5lZGlmLmFw
cF9zdGFydGVkID0gMTsNCj4gLQkJCWlmIChmY3BvcnQtPmVkaWYuYXBwX3N0b3AgfHwNCj4gLQkJ
CSAgICAoZmNwb3J0LT5kaXNjX3N0YXRlICE9IERTQ19MT0dJTl9DT01QTEVURSAmJg0KPiAtCQkJ
ICAgICBmY3BvcnQtPmRpc2Nfc3RhdGUgIT0gRFNDX0xPR0lOX1BFTkQgJiYNCj4gLQkJCSAgICAg
ZmNwb3J0LT5kaXNjX3N0YXRlICE9IERTQ19ERUxFVEVEKSkgew0KPiAtCQkJCS8qIG5vIGFjdGl2
aXR5ICovDQo+IC0JCQkJZmNwb3J0LT5lZGlmLmFwcF9zdG9wID0gMDsNCj4gLQ0KPiAtCQkJCXFs
X2RiZyhxbF9kYmdfZWRpZiwgdmhhLCAweDkxMWUsDQo+IC0JCQkJICAgICAgICIlcyB3d3BuICU4
cGhDIGNhbGxpbmcgcWxhX2VkaWZfcmVzZXRfYXV0aF93YWl0XG4iLA0KPiAtCQkJCSAgICAgICBf
X2Z1bmNfXywgZmNwb3J0LT5wb3J0X25hbWUpOw0KPiAtCQkJCWZjcG9ydC0+ZWRpZi5hcHBfc2Vz
c19vbmxpbmUgPSAxOw0KPiAtCQkJCXFsYV9lZGlmX3Jlc2V0X2F1dGhfd2FpdChmY3BvcnQsIERT
Q19MT0dJTl9QRU5ELCAwKTsNCj4gLQkJCX0NCj4gKwkJCWZjcG9ydC0+bG9naW5fcmV0cnkgPSB2
aGEtPmh3LT5sb2dpbl9yZXRyeV9jb3VudDsNCj4gKw0KPiArCQkJLyogbm8gYWN0aXZpdHkgKi8N
Cj4gKwkJCWZjcG9ydC0+ZWRpZi5hcHBfc3RvcCA9IDA7DQo+ICsNCj4gKwkJCXFsX2RiZyhxbF9k
YmdfZWRpZiwgdmhhLCAweDkxMWUsDQo+ICsJCQkgICAgICAgIiVzIHd3cG4gJThwaEMgY2FsbGlu
ZyBxbGFfZWRpZl9yZXNldF9hdXRoX3dhaXRcbiIsDQo+ICsJCQkgICAgICAgX19mdW5jX18sIGZj
cG9ydC0+cG9ydF9uYW1lKTsNCj4gKwkJCWZjcG9ydC0+ZWRpZi5hcHBfc2Vzc19vbmxpbmUgPSAx
Ow0KPiArCQkJcWxhX2VkaWZfcmVzZXRfYXV0aF93YWl0KGZjcG9ydCwgRFNDX0xPR0lOX1BFTkQs
IDApOw0KPiAJCQlxbGFfZWRpZl9zYV9jdGxfaW5pdCh2aGEsIGZjcG9ydCk7DQo+IAkJfQ0KPiAJ
fQ0KPiAtLSANCj4gMi4xOS4wLnJjMA0KPiANCg0KLS0NCkhpbWFuc2h1IE1hZGhhbmkJIE9yYWNs
ZSBMaW51eCBFbmdpbmVlcmluZw0KDQo=
