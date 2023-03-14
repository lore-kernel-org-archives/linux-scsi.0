Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549E8C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 01:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCNBAw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 21:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCNBAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 21:00:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7460C6C192
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 18:00:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32E0i4K3005037;
        Tue, 14 Mar 2023 01:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RbT2dPRWxhkpvwP3VrCoAsLAaCqftN9+xALe+rZn7mk=;
 b=N35rWrykyoFds1/1nVhpGvGvt+oUsbrFqdCS6QFB8lnkrYaD31UswyUM03zSnUYukj1I
 a1JHkRo1NZ5X3qNOSF4Q0q9qvSwm64VG0lcceGe+Kk8lcqlnlGNs4CB6/S49joW8Lvzy
 8e3ZFIR0u/ofC0YsFijNO1xvjVlrSD6CuOo+C01N3WQF/sY6dBZVsNzfbQck2WLghI3u
 rf7f83/V9WVdWj8y4fyYnQbiPAmqBUfapENv1ObYggOvWmyvOL4cmq2Z5T/F14fFiWJR
 QSYvtlSyxVxlJIqxKBWwPzuG2DBwpL26DM/JKH4b5IrpR/1hSwwKJlylFGRjfrmG0eJe cw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8g81de1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 01:00:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32E02pXu008107;
        Tue, 14 Mar 2023 01:00:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g3c6qyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 01:00:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Evn4Umh0eGosH3Rg2oQ6QaBWjFVLJTfVh2RYsYMLLYJuNSAnN8jHdo2LL1NcN4k/Okez87GdAtthSHPEwwZloEkPSqrxshoYmPUlSfHzgac/I9uYc63eZSBmRmOIRRDXmPzqYrR/zdzMLrpZBIzoDCeHYuNP/SD9RkFdL6CgBDrIr1dQ0EpfZ5EOJZND81SSdafTDaTRXEIzS4uSxxLlgjdu0NXCdtRz6hNdznwiUznhu0DK9WfqWjtiBpYbbIEAB/Cje+nWZsFzm9J6UAVJdQKORpTwQ+vH6mITR8zehDSVUzykpKqmcq6jupQZvv5HLXKlOxvcTp+yr0MWbzTlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbT2dPRWxhkpvwP3VrCoAsLAaCqftN9+xALe+rZn7mk=;
 b=Zz5OjTSGYV8rxXxw1pVStP8kN8jJK/VKtHwuoEjRTryNowsfioqHu2VLdamGEBeAoo9ek3LafUUwUzcs6cPy1uvoBB5vCStZPpPOur+szOOpLeBf3KxgGAoanEWbFrBFKCyeFTreyJoydTYJEjzJ8gymlDiCyhSR1uSJHV8q9bwlzrfwzdGk0IxPlYhEAfIQrRLP3v6rgmIsxGAGiUxnQC/HSVeMBzkurtjFOt9vibYpZOrH//LofCy/mm3KsQqRHp/SS4pKO7RVVQTm/C37JaoidID+39ov8r/HTPrIR+XmYe6wRw6LzbCJYx7flrQhUON4mUxw9v1rmCTSn4x8kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbT2dPRWxhkpvwP3VrCoAsLAaCqftN9+xALe+rZn7mk=;
 b=bHOGSNbKHgnOwXJZUW3/X0geT7netEKhZMzt7h5/zJhK+Jzq0rlS/W6Mb0guTVXIeW6QfPivdhbhHuOWpe2BNkYmXLs4nvszkzKdb7rMxxdO+gPwsuhPcz7jXcTTCZwgy/gnvGS71BdeWtRVMpdjqDn/rC+1gkxlWFfz+zwa/Tw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SJ0PR10MB5599.namprd10.prod.outlook.com (2603:10b6:a03:3dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 01:00:39 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::3c4d:2182:8a44:31b4]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::3c4d:2182:8a44:31b4%7]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 01:00:38 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH 1/2] qla2xxx: perform lockless command completion in abort
 path
Thread-Topic: [PATCH 1/2] qla2xxx: perform lockless command completion in
 abort path
Thread-Index: AQHZVWWJlXvuq+NHQ0SQSuT2X3Ofyq75dfAA
Date:   Tue, 14 Mar 2023 01:00:38 +0000
Message-ID: <E4A1F304-5F2E-4E3E-ACA9-B434A41B6E93@oracle.com>
References: <20230313043711.13500-1-njavali@marvell.com>
 <20230313043711.13500-2-njavali@marvell.com>
In-Reply-To: <20230313043711.13500-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|SJ0PR10MB5599:EE_
x-ms-office365-filtering-correlation-id: 57cac280-4f9d-4503-cc74-08db242786d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e4TzrB/pejhj5fKgxSzVNdWFmSeQwjeM7cWEZ4WqwJxzMRIO8xSDglDQv/WkNkY/gv3Y5y2GDARvbKl8yKBJSy1YrftO9/J1JoDAp0vNNf4//d9+gx+yEp4QYPI+6HrEAVjsL7M+sEBotJmwLtgwa/Om9Hkv01T5Kja9nIvdemvjrbLRWesiGfPrJ8ZFwYP5HP14Vs8CGxBjZcS0OkYxg1KY1+du6RriM/4z4ktDKmn7w4+3Kk2tqdUz6RT8ZvBDyHsdmQh5TNKQ3sdAT9Thr5/pLXXLu84uEQ+UUTJKVXiAe5a3i/s1TyeRpaYGCzpPCaH5hZpSi+j7z8I+iRm1T1TAEQfQ1Pl24XGrmYcPTNCUfSqg8g/T9jZj7ZfCH9Pf4SJ1uwQ3iUbihyUdRjP6ZMBjH+sSL6mzcoNYFRo+no2jsO4e1JJMT8ztOD7r5VlUP4Cohag3uq1zwHB9LxFcr0P2cvgaQHEXKVc7QVdT5naMn5F8JhjIGpXWwQOudCOPolnze+WabuzOlDgDkqkG+1TNlHd3xksJx2J9hwKn+9IMa8JkMemhBxJM2OxE3aLgiDIgoo8pOx5AgUHqM4fr+v9YcnkILtOWMWiY+y2Hj8q6QTmbMC0mQO2TdueqB4C6uWm/2+rho14rLVJ+qkKJJYRoNAXrRnSgErlHHLsO/ShdQjik6fvuNWAIDAZ8LLrSz9A0ch6hhdtEK/XaF1b1+ZvW8cQeaHl/SMDZp3vQuMY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199018)(36756003)(86362001)(33656002)(6512007)(41300700001)(186003)(26005)(53546011)(6506007)(4326008)(5660300002)(2616005)(6916009)(8936002)(54906003)(316002)(71200400001)(478600001)(66946007)(66556008)(8676002)(64756008)(66476007)(76116006)(6486002)(66446008)(122000001)(38100700002)(38070700005)(83380400001)(44832011)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vPHo1xAyxxu98ze1HTRXw8QnST43xHsMp3AgRKhQkwIYSdpV8b+SAyI1zOQ5?=
 =?us-ascii?Q?1JacpozemOWDBhuwAKvgK/PqKPQ6Ks6pP/mH3GJHtxlPcZuYP1RyA7hkzEkI?=
 =?us-ascii?Q?t5mW3ewXYDukpo9N9P8uWpHcIE7mrj8eh33aLtJHS8d5UeK0SMSgyagQgtfn?=
 =?us-ascii?Q?v8XvOnYVHdZVMZEzlyjzLK2qQ3Bmo6WAszUi2HEYh1sgaKXiZk3WxeGglS0I?=
 =?us-ascii?Q?KMsNOgy7PtSH4BXTlC0T+NDgq9oGJ6alfCshSMLkICl3PG42deEvWAiTDNd7?=
 =?us-ascii?Q?FWRRSRMJRUJZ2RFCQ9g+BUlrd/RxyrQMQ1DMOEdxImV34Vy7u7UQ+GkUQPL1?=
 =?us-ascii?Q?N81bEt9U8PNXSTfbcbp8avy9l0nHFTzZeI/ozszsERkK0eAYBL8t/RccRPHu?=
 =?us-ascii?Q?6/7tmuDvEyvzXLk81oTG+ulbGbhebruKNPv03mZctUZ0msUtc7OUmuUIN8Ww?=
 =?us-ascii?Q?58Zl1IH2H1CxtCMl+tpF+X/frrm8ocBs8SC1eYfpzrvRVf+r8tYSGWdvzdjt?=
 =?us-ascii?Q?UxvH0arsI+tm4meSeSubNrA/cNHI2ix8mP0lvUIkhkt9kCsvIgg1mK4mm1uz?=
 =?us-ascii?Q?16dFpojM8Ao0iGYlNr86Uwnn6wyafL7uPA0sJC+nbjpzFm24mW/LUINs5/pl?=
 =?us-ascii?Q?wg6BuBXhiO/V3ja8CfO2R+yIVWIfTKrknnGoT+mj4+wi7d0H50+Kym0VZxEx?=
 =?us-ascii?Q?1Dc7zh84lFT8NhOJ+dSQQdtVBepGPDHcNulc1Y3VZIXEFazdXM4pzrtFph4L?=
 =?us-ascii?Q?KwlSirINH4jgvzk8zXn5al01X8OR1ueQrss5aJ3CzYMpStZcyO9fITXUhsck?=
 =?us-ascii?Q?zNxv5STC7Ox8auJrFp+wAb9oH3xMFivp89PGyFYuhxLeOmICB8MHLlVL7znE?=
 =?us-ascii?Q?OmEsrLsH2iUJmpfIPGRcdFBuxS9RdVf3neq+Adnv8lEv4WY/Ew3fO4zRH7d/?=
 =?us-ascii?Q?+JFiIoVtf9LaVUrIIbri2FUE32xl0APESLR25YZBAy58aVpFWoCRM+dyv2md?=
 =?us-ascii?Q?GRLQ9lIMrPYwXUQ91jaO3cubcX0TuBQdlrlJg6IAGok+GInp7jtXtgdEJW5A?=
 =?us-ascii?Q?cPEsw6j5Qd1e6v96qYbzEee0xCw9xc+uePHaN1HnJ+o4bFEdIhlfPwiQCQKZ?=
 =?us-ascii?Q?hVjTW+3FBea4W999zip2fAqTWX9IVW692B75yDubsy8bnujvpaSd8vk4BZxL?=
 =?us-ascii?Q?aKA1tMxH95T4ieYXuq/wk0Fqsxdv/CmeYe5v8tGq5MNYbP5bNEP1EU8BFEGd?=
 =?us-ascii?Q?o8iC3ndh3xQTnWMeyQ/rYH+gYj7NDp2x3HQRLNfABqU3pLytRhmjeCv8lBe3?=
 =?us-ascii?Q?m6Lk7v+wblPKxLKgTCFuYUP7W1kKFOyaGpp1j6oNq2fmlMv7fIrMMBFD8KoU?=
 =?us-ascii?Q?UIB+jng+B2qyyyhF1Ye3C30Hd6jMUyN7ajr4w1CF2vrNMdRD0bV0X1FJpC70?=
 =?us-ascii?Q?6Of2wyJK3/osZR8hneiTE0H5hk5/IZE98lYX37YerRykaKn9kuUKccxa6wCX?=
 =?us-ascii?Q?FtvrRB44xcXNd/Bc9+pfOLFJ2RnfpaTZGOU0Gi9d2qoacGaXcyCFjI/5QRzH?=
 =?us-ascii?Q?XMtc2gcdwNg6dnv3pdDChLynjjyy6fwB2W599j5W5OA75TqtlbL+JLtnzfCG?=
 =?us-ascii?Q?2w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EDF7D59697D65C4CB8A4F5AC3DD1A261@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IINEQq3bSEvHqXgoe/tcT2k9ycrIzcRQiQxCmuOblyRhlO32HYSkPPe9g+MaVBTYWXNATQsvByZL39Oy1Qw0v0KWmeEar6CdvpZqDClLMCe6opIhH6sU8DlyviswsR1TIfTtdvJ2EJbsHHrfwDloVZK36FB781EP4WnkeUpKpTqhoBs7s9gB9WmsACd0CIlbGfI0rMQZ49RZ0fxAFIxj57lc38tXvGImp0o/PeYxkxFfIwvYKx5BgQ4mWEvihq/TXuwr7dxELA3wD02u7/kC/zVwoQsQWkerGnUJiPG4UpdCU72+vEN8S/tkDj9RGFVn59aeZXqj5bQ6/zeKbJ0KPTAZS/dSnw3gN41M3PZyw+edR7c56KB67C9tuT0DeBCgOw7NwSkRlBKyY4W2Xl4LJBhbuBxFOcg83YmN527xdbknmZADCM7E28YS8ioN1xTn1iJjyeoNCtNvLOm0pqDHUK/y8SZ7zBUOI/hJ4/+oB64+4SlWO1T63bsLmSio4iRcQJeq2W7kK5lclen1zXFhq3Rrcbkmzwzjpqdxr8qGSo4KcYpsAm343uVvVabh5uNHZ+7EY+KyqoSXLi/BUh9Qh4nfvvYvd3euh6kxXQ7G1hmvO21xF+fZFNwLDGC61F6/ZsjMEQEyXsHon6jIX64S9LY35u7BDkUwqcSDCtAJUHenEaEjiXwslJG9LBiXOLJqevtG5mj7BQceaRhmAuEnDQTo+6h3jLD2BgtR1ldoLhBmJKkuDEL1+8w2qVx1lKjDBqF7WT84LbqBxBR0f9xdKnpvjFshbbjl/6w3iV/aeSjpbh5BRl6e2XUpdROHAI3T
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cac280-4f9d-4503-cc74-08db242786d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 01:00:38.7121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oXH9VwUfgEOjVdTdenBZdji8ZzPTLA6WNRoPq1z+KsTwngQvt9WoI7VV0m+BOfXObXs+0qpAQoiMLbkMAM6n0iMNI4DJsKAL3tX6MFbUp1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5599
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=890 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140007
X-Proofpoint-ORIG-GUID: tA7ZNYQ8agcjK24EuAPtzBEn6mmQ2n0o
X-Proofpoint-GUID: tA7ZNYQ8agcjK24EuAPtzBEn6mmQ2n0o
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 12, 2023, at 9:37 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> While adding and removing the controller, call trace was observed,
>=20
> WARNING: CPU: 3 PID: 623596 at kernel/dma/mapping.c:532 dma_free_attrs+0x=
33/0x50
> CPU: 3 PID: 623596 Comm: sh Kdump: loaded Not tainted 5.14.0-96.el9.x86_6=
4 #1
> RIP: 0010:dma_free_attrs+0x33/0x50
>=20
> Call Trace:
>   qla2x00_async_sns_sp_done+0x107/0x1b0 [qla2xxx]
>   qla2x00_abort_srb+0x8e/0x250 [qla2xxx]
>   ? ql_dbg+0x70/0x100 [qla2xxx]
>   __qla2x00_abort_all_cmds+0x108/0x190 [qla2xxx]
>   qla2x00_abort_all_cmds+0x24/0x70 [qla2xxx]
>   qla2x00_abort_isp_cleanup+0x305/0x3e0 [qla2xxx]
>   qla2x00_remove_one+0x364/0x400 [qla2xxx]
>   pci_device_remove+0x36/0xa0
>   __device_release_driver+0x17a/0x230
>   device_release_driver+0x24/0x30
>   pci_stop_bus_device+0x68/0x90
>   pci_stop_and_remove_bus_device_locked+0x16/0x30
>   remove_store+0x75/0x90
>   kernfs_fop_write_iter+0x11c/0x1b0
>   new_sync_write+0x11f/0x1b0
>   vfs_write+0x1eb/0x280
>   ksys_write+0x5f/0xe0
>   do_syscall_64+0x5c/0x80
>   ? do_user_addr_fault+0x1d8/0x680
>   ? do_syscall_64+0x69/0x80
>   ? exc_page_fault+0x62/0x140
>   ? asm_exc_page_fault+0x8/0x30
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> The command was completed in abort path during driver unload
> with a lock held causing the warning in abort path.
> Hence complete the command without any lock held.
>=20
> Reported-by: Lin Li <lilin@redhat.com>
> Tested-by: Lin Li <lilin@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 545167627e48..d2f6c0546587 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1858,6 +1858,17 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int=
 res)
> for (cnt =3D 1; cnt < req->num_outstanding_cmds; cnt++) {
> sp =3D req->outstanding_cmds[cnt];
> if (sp) {
> + /*
> + * perform lockless completion while driver unload
> + */
> + if (qla2x00_chip_is_down(vha)) {
> + req->outstanding_cmds[cnt] =3D NULL;
> + spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
> + sp->done(sp, res);
> + spin_lock_irqsave(qp->qp_lock_ptr, flags);
> + continue;
> + }
> +
> switch (sp->cmd_type) {
> case TYPE_SRB:
> qla2x00_abort_srb(qp, sp, res, &flags);
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

