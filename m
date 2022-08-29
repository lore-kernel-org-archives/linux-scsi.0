Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2369ECAAD4
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 19:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiH2TZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 15:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiH2TZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 15:25:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF7880F6A
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 12:25:38 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TIhcS9022364;
        Mon, 29 Aug 2022 19:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=/jaMs8c8tJchCmfyOL3bv4dicautVbQSSvCIJtQ9HLA=;
 b=1Cxejm6vu2nA0bq/YEn0KaBkGij5tmXLzp59i9uhtlSywC5FCHrqCoYWxOYaUfW4Lcwv
 B7qh6QNp7AdGekrKTgBPtCOdVeP7i9izFkmFCmWUv/tCPW+JsC1KMKZomfwMUF7r4qsH
 dQdOOBO/9PTB+4R1yPDyjLgNnZE3YKxngTORbtSpb7wzw4LM3NVVJTUsINbRYMdksHOM
 1wa7e/+6Ip1ph5nCZOSiJjdNe0uaWk5Y0RYzvnaZCOHAoILx7CkHdqSa9JpJSQYjwOhu
 FsKK+wP2ad9HAejWtldELd6Z3X+5M8w1mUp2/2GL+fcA6yDWgSoMsGzlfo+3M5/rDq70 Lw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7a224c8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 19:25:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TIVGRM038254;
        Mon, 29 Aug 2022 19:25:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q93xec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 19:25:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcq0iVJiRpmyQyfK8jgFDH4cz+kZgQxUXz/0rXojYBo6XWCt6nuBCEPVb6+aFs8rm76ZtPDtWoJsvb0U+kc3ocmnUhMkz/oma8fKZgD7LcB3fqXloGTVkanYRc7v15eE9kq4P246g1PNOQDU8+IRQJNOAXCOKnVp6Dxn7X2n4SlggUVLrCfWd/rbbvbjhs8fu1U+SeWKdX9RUWrVncz3e4scrNTBlDeNHu4qXzr+/B7TTi0h716sFLycsL25BP+W4qzqA5hsOag+A5dIOtV1/haw/aVkX4ZSDef5de+/q0C39UKYBflTHGFqRru9NaQ090Gw3vDx9hqfaiWsDyA23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jaMs8c8tJchCmfyOL3bv4dicautVbQSSvCIJtQ9HLA=;
 b=QFcFogi2n11gIE2RiEw7F3xT1OpQtm9e7Hr6HiJf6matBJX/W61Yl4Ry6SE3yUfZgkPEic+yNVTfl4WtvhOJrU1X6bIfP2sB4smoi6jiamMua22Dx3+Nw2WlqX+Lse92xibIwDPGA/QxAZ71h6soEaT3CU1WEPS/ty/X6MLn6lckCg0eD/2SNy+bTy84W7WsOPaIXAxWK8fMAECIcwHBNYW9wjWLrTEhYrcHUsobifIfiznGfeV/AqA6jhw8Nc1ASuD5J3yHl/QCpRRGH/xkHYTPLRZ3nIivk/j1aNdc24iJysolXgXIGurSvN2PRgEDFHRmGniuszzkbwwKQYRH4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jaMs8c8tJchCmfyOL3bv4dicautVbQSSvCIJtQ9HLA=;
 b=0UUP7d0fAWR5YYddgzExbgPgIehGqSk6BVm9hPIb1hy7Zw04VUV6NcGKtbK6beFxWdxXo30QQowD7Cj+1c8KFpPf3LaxYRqRuE6AJhyArelRCcqLIUjM1qcAyARjgobiumddV6C8qCnn/Jhpo/wTGtnbkgUNp9TINYy2CadpFnQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB1980.namprd10.prod.outlook.com (2603:10b6:3:109::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Mon, 29 Aug
 2022 19:25:34 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 19:25:34 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Arun Easi <aeasi@marvell.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
Thread-Topic: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
Thread-Index: AQHYuTZTuG7nZCJ7MkyaI5tU+DlS863GFUiAgAAJq4CAACjYAA==
Date:   Mon, 29 Aug 2022 19:25:34 +0000
Message-ID: <AFBD250B-7F4D-4C63-B05E-E534F9BC5805@oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-6-njavali@marvell.com>
 <773B9D53-D043-42D9-B830-694A3E21A222@oracle.com>
 <ad348f6e-fec6-1ce5-eed5-621f84a5e580@marvell.com>
In-Reply-To: <ad348f6e-fec6-1ce5-eed5-621f84a5e580@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23293e9b-5e8b-489a-8110-08da89f43ed3
x-ms-traffictypediagnostic: DM5PR10MB1980:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V8woNaspmk1bRPGPvnlrAjhZc3SyuEL76fSsfiYdVyAijff3koTgr2Pxv06lmJwU7z4mKsNKRuqtUhbXoyDYlBxc0MQ8a1BANiRguGLf70gL4/W5K95U76+E+ntwBRO30wLTgSQ8gMlvKAgeFe2ae88gRCvc8ql2fK+M5rBnMAUAwWkmZPSxWiEIXvZ5NG1NKKyaifuvE52lJBG/9sPr9761xnu32Qwtf/DcJZ1r+VQZ6lmsUXhgZ9p7lxORJKLwO6TpBhpGJi2TLMTOGJ1O9WiuOcv6/eYHqd3sB22159SQgkxrgGQs4s7hkXK19VG4ka58SIF4NEacysV54a0BbK8T70VCrIb32c4D7gg/JwqIRmPtHry0zZx2SHRvVJeAVsi0p7xWGBxS9xW9SYE9SwkWfUf7wXxLO/cEG8rKEgBblO1wkYhE1Vh1DGIw+K5XXM8lOUyCLPI2Kib3kP/M0ptXOaKkuyT2+umejS+7zJzXWG3J9IypYEeE/8HPon5xiYxJDZXrDnSqqxAOnLgTpVc16OnhX2PW8UCAwlOjPvO2KJickM8sgJeQLltnyno5Xs1CNvmTmWIgAEUnarumKwQAe3Buiz3e4DMPp7KFRkf2u8GgjNgDMFy7P289jUDrT727FhZCfrRToZYzLDowcVeryZy+vMzXWsRx7kNRtJxb9BqQG1+63nnatqONueYa28PJvxI6xuAYRkIy9zSzAHXNjIOo9jNTZpveYVVEJkFddmC9zvhtyio8iPNciUKdl06lkrBVpLCgCOIYo19uzJoexlEwF+Md3aw+brkwo8g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(376002)(396003)(39860400002)(136003)(6512007)(38070700005)(26005)(122000001)(316002)(36756003)(71200400001)(54906003)(6916009)(38100700002)(2906002)(6506007)(8676002)(6486002)(8936002)(44832011)(66946007)(76116006)(66446008)(91956017)(53546011)(41300700001)(64756008)(33656002)(186003)(83380400001)(66476007)(86362001)(5660300002)(4326008)(478600001)(66556008)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWZwd0hudUNwOERNU0k0eDg3V1BoL2lmckZVWC9vRnMvaENlSjZYc3Mwcytp?=
 =?utf-8?B?RHQyR090RHFSWVRuV0ZsZ3JZeE11RHI2QW52OElIQ2xhY29tYnZvMnNPR05a?=
 =?utf-8?B?TzRhVUJTbGgxQUtHcmRFdVN4Yzd2OVpwUkFkYXg4dEh5dHY3ZVA0Nzk3SjA3?=
 =?utf-8?B?aEpMWHB4TVBxMVZFNHJHaEdBUjJLVkkzTkp1U1J5c2YvUjk2S2dxeWtqSFpS?=
 =?utf-8?B?RU5FQXRpR0xVOUhYQ2F1dTBCQWEzZXBhNEk4WlhrclFPaUdkMlJtNWcwWnY4?=
 =?utf-8?B?YlhtVDZhVFhzczlMdHBTMFJHY25rTUdYM3dBZFZZZ3AwUk0zaGJFeWNEV0Mx?=
 =?utf-8?B?eCtWajJVSFAxb0RIUG1xUUZTQ1p0a1I3emZGbFphNHJldTVzcHF3cXkvZ3l5?=
 =?utf-8?B?bW9LRHhvR3NveWw1RWorVHBQQ3BLdXdYdUpJMFNubFhnTlVKclVEQTAxZTVz?=
 =?utf-8?B?eGtYWWFWWFppM3RBaXZiWlpRSG1QSEJRMG5hSEFGQk5tRXB2WTg1ay9LQmxp?=
 =?utf-8?B?NmZ0bWNJSG13cDIzZk1lRG5RSjNvQnFpV0RuK0g5TEFuSERBTDVBdm1PK1hB?=
 =?utf-8?B?U3M5SzRIcTg2VGxodDhzOW10VER0Nk5UR01sM2xuS1lVWVZobkF4K3g0UWQ3?=
 =?utf-8?B?MStOUG0vQ0RpbXdtKzdwdnJ4UmZBMkxhVm1QVW56M3VOWmVxeDdVNmg2VnVC?=
 =?utf-8?B?TGtnZDhvMWZadTFTOFdpMng4cFFLQW9hWUVRUjNoaHJuM1Zub1E5R05qWkFG?=
 =?utf-8?B?WFhVZVVvOXF0ZGdvTHlScEZpRTJjWmJ5L3hFWGE1bmNocnZVQ2ZyWWlKTTF0?=
 =?utf-8?B?Zi9JdXNrSVVYNGtyWFZIRjZpclFzNXhOU1ZWbUhaVUlwa2U0ekk1c2hXSk8r?=
 =?utf-8?B?cUFqWStEZFdvcHkyckViZE42Mm5jUytPQ0ZUSkV4cFVUMmppVEpBQ3pqS0FE?=
 =?utf-8?B?YlBJeVVXMjUzNkJ0TkcyMUVzaTdma3laZGJGOHhmQURnSDBqUUtDY01UaEEz?=
 =?utf-8?B?Sm1UcVN2Y2R6Qy9ST3JFY3FJYnAvbUk2YW5HdHk3c3ZjMVYwVWNIYnlKSWdZ?=
 =?utf-8?B?K0lydU41V0JRUUZGelcreU1mQ3ZyNmZVVXRwWlM4Uld1NmQrYmgxTDBPRVda?=
 =?utf-8?B?eW1DLy9XRHZKUS9rWVNLK1BBMUVoQVF0VHRWWkVDNjVUK1I4TVUzYm1MWUJu?=
 =?utf-8?B?L21Dc0Z3OGVmQkhidW1oNDZiVmJvYktzODVCZ2ROQ2pLeVNWOFF6WUZra2pN?=
 =?utf-8?B?YVJzVkZrUzhtZHVteThCODNDZnhtQS9TeXVMajVsaFZVR3puWGgxclZHU2Ev?=
 =?utf-8?B?SzF6b1JPcFhycWtxZ0lKU1RGY2lWWXl4YXg1d0Rza1dNNjZlL2dnL3QyKyt6?=
 =?utf-8?B?TCtPNlNycFdaNFNtZU9EL2plMG5sV2gxL3g0U3llTUc4TFpodFlnRkcyM0l5?=
 =?utf-8?B?Z2tqdGs3N1AwS3NZNmlsSlhmQmRBcWUreGpKUWdKb1ZRcGNGTktmYXNQLzU3?=
 =?utf-8?B?c0REWjdXc1FheDhjQy9OajBwREtncFBoV1NtVnA0dE1PWXlzd2g5TDhacFNm?=
 =?utf-8?B?RDlEOXJMbjdkbG4wNU1MNDI5NUZsRitOc1A4ZGtkbUJIbXk2UHJEb2pYL1d2?=
 =?utf-8?B?MEo4SXRZN2hMUVB4UmxVbThPL0F2UTU0YmFXaHFFcVE3a2Y4MXBLcWk5RHV1?=
 =?utf-8?B?L2l1d05RNUphcFRwY1FTQ2o4WGpoL3NlMlNuTHI1d0F0Y1gyUHVLVUR0OTlv?=
 =?utf-8?B?UDN2cTJxS05QelRzUEFvTDhtNXcrdjllU2dnV3c0YUNWS2hLamw1YnlJa2lH?=
 =?utf-8?B?ZnRaN3QzY2F5ZzAvZjZPUHdrTGJRcFh4VFlpYnFwdUhiTGF6QURUSW5JOXlr?=
 =?utf-8?B?RkIvbXp4SUh4OTZaNjJhUGplcFhveGV6L2F1Q1BGOVJYcW5hekVac0xzRjBS?=
 =?utf-8?B?aysrVVRKWkdSWi9qRStZM0dRNklWNytQUFdPdlVkMkhvaWRuOTBpWjI1YmdF?=
 =?utf-8?B?cFpXTkk1UjVLM0c2SHZMRlRpajJwYVZpMFErSjRYN05oSkN3VzM1bFo2dEpr?=
 =?utf-8?B?SXRmVlNRODNKSXRyR3JnL2pZWHQrL292dndQMGVBT2p2RUUrdEhXblFhWjM3?=
 =?utf-8?B?SWIzMU9RNTJYTnBjblhSaFVvN25NZGVFN0l1Rk00amhMdnRBaEpRTzhBaWFm?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A613F7B389CB24EB12AF366E64826F0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23293e9b-5e8b-489a-8110-08da89f43ed3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 19:25:34.5108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rzc/2vi3iom6tCn2vGJg4rEU+9SA15nJfO4axBo1/waH8XL9KmiqB8w84POWnhQgzps0J6FGfJzvcZ+KUnxPxD4MHmwc1Yy5vnIienNkKaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1980
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_09,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290090
X-Proofpoint-GUID: CWYb340BQ1n1jqPdHhPcltYKsz81WJHg
X-Proofpoint-ORIG-GUID: CWYb340BQ1n1jqPdHhPcltYKsz81WJHg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gQXVnIDI5LCAyMDIyLCBhdCA5OjU5IEFNLCBBcnVuIEVhc2kgPGFlYXNpQG1hcnZl
bGwuY29tPiB3cm90ZToNCj4gDQo+IFRoYW5rcyBmb3IgcmV2aWV3aW5nIHRoZSBjb2RlLCBIaW1h
bnNodS4gUmVzcG9uc2UgaW5saW5lLi4NCj4gDQo+IE9uIE1vbiwgMjkgQXVnIDIwMjIsIDk6MjRh
bSwgSGltYW5zaHUgTWFkaGFuaSB3cm90ZToNCj4gDQo+PiBTbWFsbCBuaXRzDQo+PiANCj4+PiBP
biBBdWcgMjYsIDIwMjIsIGF0IDM6MjUgQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVs
bC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IEZyb206IEFydW4gRWFzaSA8YWVhc2lAbWFydmVsbC5j
b20+DQo+Pj4gDQo+Pj4gT2xkZXIgdHJhY2luZyBvZiBkcml2ZXIgbWVzc2FnZXMgd2FzIHRvOg0K
Pj4+ICAgLSBsb2cgb25seSBkZWJ1ZyBtZXNzYWdlcyB0byBrZXJuZWwgbWFpbiB0cmFjZSBidWZm
ZXIgQU5EDQo+Pj4gICAtIGxvZyBvbmx5IGlmIGV4dGVuZGVkIGxvZ2dpbmcgYml0cyBjb3JyZXNw
b25kaW5nIHRvIHRoaXMNCj4+PiAgICAgbWVzc2FnZSBpcyBvZmYNCj4+PiANCj4+PiBUaGlzIGhh
cyBiZWVuIG1vZGlmaWVkIGFuZCBleHRlbmRlZCBhcyBmb2xsb3dzOg0KPj4+ICAgLSBUcmFjaW5n
IGlzIG5vdyBjb250cm9sbGVkIHZpYSBxbDJ4ZXh0ZW5kZWRfZXJyb3JfbG9nZ2luZ19rdHJhY2UN
Cj4+PiAgICAgbW9kdWxlIHBhcmFtZXRlci4gQml0IHVzYWdlcyBzYW1lIGFzIHFsMnhleHRlbmRl
ZF9lcnJvcl9sb2dnaW5nLg0KPj4+ICAgLSBUcmFjaW5nIHVzZXMgInFsYTJ4eHgiIHRyYWNlIGlu
c3RhbmNlLCB1bmxlc3MgaW5zdGFuY2UgY3JlYXRpb24NCj4+PiAgICAgaGF2ZSBpc3N1ZXMuDQo+
Pj4gICAtIFRyYWNpbmcgaXMgZW5hYmxlZCAoY29tcGlsZSB0aW1lIHR1bmFibGUpLg0KPj4+ICAg
LSBBbGwgZHJpdmVyIG1lc3NhZ2VzLCBpbmNsdWRlIGRlYnVnIGFuZCBsb2cgbWVzc2FnZXMgYXJl
IG5vdyB0cmFjZWQNCj4+PiAgICAgaW4ga2VybmVsIHRyYWNlIGJ1ZmZlci4NCj4+PiANCj4+PiBU
cmFjZSBtZXNzYWdlcyBjYW4gYmUgdmlld2VkIGJ5IGxvb2tpbmcgYXQgdGhlIHFsYTJ4eHggaW5z
dGFuY2UgYXQ6DQo+Pj4gICAvc3lzL2tlcm5lbC90cmFjaW5nL2luc3RhbmNlcy9xbGEyeHh4L3Ry
YWNlDQo+Pj4gDQo+PiBeXl5eXl5eXg0KPj4gVGhpcyBzaG91bGQgYmUgL3N5cy9rZXJuZWwvZGVi
dWcvdHJhY2luZy9pbnN0YW5jZXMvcWxhMnh4eC90cmFjZQ0KPj4gDQo+IA0KPiBXaXRoIHRyYWNl
ZnMsIHRoZSBsb2NhdGlvbiBpcyBtb3ZlZCB0bzoNCj4gCS9zeXMva2VybmVsL3RyYWNpbmcNCj4g
DQo+IC4ud2l0aCBvbGQgbG9jYXRpb24gcHJlc2VydmVkLg0KPiANCg0KT2theSBnb3QgaXQuLi4g
SSB0aGluayBJIGdvdCB0cmlwcGVkIGJ5IHRoZSBudWFuY2Ugb2YgdHJhY2VmcyB0byBiZSBtb3Vu
dGVkIHRvIHNlZSBhIG5ldyB0cmFjaW5nIGRpcmVjdG9yeSB0byBiZSBwb3B1bGF0ZWQuDQoNCkhl
cmXigJlzIHdoYXQgSSBoYWQgc2VlbiBvbiBteSA2LjAuMC1yYzErIGtlcm5lbCwNCg0KSSBjb3Vs
ZCBub3QgbG9jYXRlIGl0IGF0IC9zeXMva2VybmVsL3RyYWNpbmcgaW5zdGVhZCBvbGQgbG9jYXRp
b24gd2hpY2ggbWFrZXMgc2Vuc2UgZnJvbSB0aGUgRG9jdW1lbnRhdGlvbg0KDQpyb290QHRhdG9v
bmllfjYuMC4wLXJjMSs6LyMgbHMgLWwgL3N5cy9rZXJuZWwvdHJhY2luZy8NCnRvdGFsIDANCnJv
b3RAdGF0b29uaWV+Ni4wLjAtcmMxKzovIyBscyAtbCAvc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5n
L2luc3RhbmNlcy9xbGEyeHh4L3RyYWNlDQotcnctci0tLS0tIDEgcm9vdCByb290IDAgQXVnIDI5
IDA4OjU0IC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmcvaW5zdGFuY2VzL3FsYTJ4eHgvdHJhY2UN
Cg0KbWF5YmUgeW91IGNhbiBhZGQgYSBjb21tZW50IGluZGljYXRpbmcgdHJhY2VmcyBzaG91bGQg
YmUgbW91bnRlZCB0byBzZWUgdHJhY2VzIGF0IA0KL3N5cy9rZXJuZWwvdHJhY2luZy4NCg0KRllJ
Li4geW91IGNhbiBhbHNvIGFkZCANCg0KVGVzdGVkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1h
bnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQoNCg0KPiBSZWdhcmRzLA0KPiAtQXJ1bg0KPiBQUzog
IyBncmVwIC1BIDEwICdeVGhlIEZpbGUgU3lzdGVtJyBEb2N1bWVudGF0aW9uL3RyYWNlL2Z0cmFj
ZS5yc3QNCg0KLS0gDQpIaW1hbnNodSBNYWRoYW5pCU9yYWNsZSBMaW51eCBFbmdpbmVlcmluZw0K
DQo=
