Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D584CC001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 19:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjGMT2j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjGMT2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 15:28:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671632680
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:28:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DJHKhJ025290;
        Thu, 13 Jul 2023 19:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=rbPtGYia7b7g5TeHEdKENSd7zv2EGPTNn73JScn+0zo=;
 b=mT+u/fcQNQmswlTdvV2R9xxgSqIgbKszd1pnAfBjKESS6zj8AGtoYJU1eBi/QPwxtOC9
 mwzqPH9l/TEkwZ4985he0p5Q7jf1bvw/mxkzm+2JvlFroTvyLohWPh2wUnR1tD/qFgcZ
 n/gBpF2nrAVeGpjcn6Vjvug0qcVTLVKwKsftrNI4287RP+K14TssFLrYAm7TRSEXg2lZ
 KZTlDW7Q//aYMjZbcAQkgm77DZnefPBpnBasox2D46Y3Tos/yvXh5kKb3fJBSA/zFWOU
 KoUefJuLPYDcxSpXA1hcCMo3ZzCstddbDm2NSpf7qufqnej16+RPxA78omei0ZauMvQr cA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtq9t80p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:28:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DIng7q003273;
        Thu, 13 Jul 2023 19:28:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvxsdt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:28:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goo0ZiKm910yP5K/lGxzze9OLvgQPZXlE0nOvAE9Khc5rqompFDKdPj9bIxs2kYFAxbNWEihYpLJTsyaWieK+XWynfctLsjdX0z1ZKydvTsHZ0sTWKO2A2OSJH/NuqvSWT/jtAjMujjsopPomgYFISjpNDdQihRFV1UEOkUXNhZJfXBP7Cx7Iy9KcBtk9kQDHlO02gpeBfey7tfx/ZxhWhUR/Ylkpq5dvUGYkd7Fyr1zS+gyfCs3UjINjZO/Kq+UJ05HeOQmebb0/NSRpp8g3mat9RTOmLjPz4uPaQLhR9Rn66wTYsI77HzzvYeio1oI+tha+LTOg5cboS1xOTHUhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbPtGYia7b7g5TeHEdKENSd7zv2EGPTNn73JScn+0zo=;
 b=oJ0ygzC5bRLhCZJhpAlIuHk8V/fXuW4OswP25K6TKyFHNQGzP06JKyWCUQ3M7RVFC1lNjFMMf4hJRBHZUpW7K/wZZqauUXzN+G6nHx0ztff/leFk2E9OWV4OdEfOV5adMF2ScMfiS/5Rh3UOjLT5rIc2P7VWLhtkg8s1nG+x1N4L06ZUeEmLzqh4fN6Gq0VVtZCc2RJBC7p1xIwSkrglty2ok9pUlTnlBAwVqPmvR8ReYRKu2VH+JIbWoFj9sppAhMxYEzazD64q0fzYQCHDeu37Umfns/M1vSyl+m+U6EkkyNp094PNlm4cuZjp/AgDU2Ejw1aM9IYl9O4xQrhEcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbPtGYia7b7g5TeHEdKENSd7zv2EGPTNn73JScn+0zo=;
 b=yA+lWc3Qm7Tds8u1RzUkw5fFCPIcAFegr0nrSgazVas9zaqjrPCEzMsFCl0g9OMSvpoPFX81fUhizEnW2S8ECYRbhERz6T9ytgtVuy7DDHjCBrBN5eO8Q05VyY9dmK+XkxejK5GhMW61boJSKRf4dkSgH4aHEfk4CYH2THjvc08=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB4936.namprd10.prod.outlook.com (2603:10b6:408:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 19:28:30 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 19:28:30 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 06/10] qla2xxx: Fix session hang in gnl
Thread-Topic: [PATCH 06/10] qla2xxx: Fix session hang in gnl
Thread-Index: AQHZtKBMvCGgZ0HnPUuJTkadYo6XSK+4FxqA
Date:   Thu, 13 Jul 2023 19:28:30 +0000
Message-ID: <BA7F4EF5-ACEE-4C33-80DC-863AF287CC57@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-7-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BN0PR10MB4936:EE_
x-ms-office365-filtering-correlation-id: a119c6c3-6bc3-49a2-1bba-08db83d75710
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gp1MVvea5WEietZo0YabvQYt6WXiQvP23EAhRoz2grRfwjafHgddYXHzb4f6k5YPxIyqBpvgaSbbk3VuyFB6MPmsa+n6fBqN3bdtEMMvEElXi915Mymkbm4L1eRFitUAi2U7NwfWthpGG3zxQKkBD6oDP5OnDeMBi5uQI3eZ/r0flGKPmLJ21KGziQVKD+oYl7EgE98C8KDTPhOAaPPnoeJ3+nWD1Nqp/hbKNgQ3tMlf4qP/lzvzVKm94GLmDcFtlRIXqvKqvgGHLI3ICTUJbWXI9SxPTC7O7GzfvSpWl5cwTw3kTGOS9xXTroBfgw32ZryOePktOsSTEaEY8yvxdYhAvdVXhj6RC5ZxgWUWEHzB8rT0YhUw7otqPFOkw/EHdoBQKJVvf4R4su53BpyA30cuhZz/8pl2UnXQm/1LazvLQpWc8YlTkZqOYRkCb+Z1Au6XNk8BY8LbrApZ12kk434ayZpRQrRvPhnZCT4wuHt03Ysz2x1ZW2+vM8yz1ju4Ia+f0KQzWcV4QkZ05S0L75JS1SdLoSrbVlIUbiJzFeV2LCI8hW9H+g7M63KdMaouiu4RkKCLRFunfxdveetrEe3Vb9nx7/nsCi/94B20EKKX6OTdvDa0riAZmIa1yhiq/g48L3hCzTd6B9iXmXGLEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199021)(316002)(54906003)(91956017)(71200400001)(186003)(6916009)(66946007)(4326008)(6486002)(76116006)(66446008)(66556008)(66476007)(64756008)(478600001)(41300700001)(6512007)(8676002)(8936002)(53546011)(6506007)(86362001)(26005)(44832011)(5660300002)(33656002)(83380400001)(122000001)(38070700005)(2616005)(36756003)(2906002)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGpVcnBudmk1TWRtZURwNUN4UHNoV2Jua2hheTVubHgvTXJQc2t4TmF2eWY1?=
 =?utf-8?B?WWxicXNYeGlCeHAzaVpscFBxRXpkUkJiWXA3Q1JFZkErK0p2ejEzK1lqamlm?=
 =?utf-8?B?NThTU2Zoa3A1WjduREQ0WXJ3TFZnaHk5WHZLYkYwcWtabFhYYlJIRjVkNmZr?=
 =?utf-8?B?ajNiUEhlZkc4dzRrMEdVTHBBbVNPQTlRT3BWT3gzWHIwS0h5WlZSamNOVW9D?=
 =?utf-8?B?TnRjL29PdjJGM0N4Njhnckt3TkpEWTgzK0kxeWs1QXRqY1FiYWpxdlpwbUg4?=
 =?utf-8?B?aEpyWkI5cmRMby9YOHYyUlpXcEdPMVdRRlYweElScTlDUk54MUpNNmNWTmJp?=
 =?utf-8?B?RXNxVzJVTTUrakdBbElQUC8vYlhueWNQSEpGeFZVQlJ4T1lUZlNYQjRsWjFq?=
 =?utf-8?B?K1hkQ2ZMaFVBVzRzKytmSHlVUSt4eUEwbU15a0pwRlhlMWtET2JvdTVSQm1Y?=
 =?utf-8?B?aU5BdktDMjI3ZTFwMWgwbzljSGtTZXoxUnoxNk1XTVRBajdoS3V0dkxxRUp1?=
 =?utf-8?B?RVlLRXFMVitpVFl5dW9kS1ZLT3lRVUdkc2JXekRLY2o5cHNuTXlndTdSc2RV?=
 =?utf-8?B?RjRaYm1uakRoNmxDZWtBZDdvcDFUVVlLbkVNM3BLbW9KNXl0WlF3TW1rVXZu?=
 =?utf-8?B?azRIZVNycDFCbkNyS0ZXVW1VTjU4aEFHTmRvUjZ1aTN1L05hRk9GTmVUcVl0?=
 =?utf-8?B?VXBvSktBcXRNY0FhMkY2SC83WkZmcXhBbVFWTmwwY2IzK2draFMydGJSSFV0?=
 =?utf-8?B?ZUtqVzhnMWRheEd0cTdxaUFMOUNrR1E2VjlNQWlJR3l1Sk52RFArY3dxNC9k?=
 =?utf-8?B?ODl6MDQwQlcrNWFDOU5hOFlnai9mYlhzTEZrbjdKSUhHaGhLZkM1S1lvODdX?=
 =?utf-8?B?TzZXTGRsQnd4VnJUZHh5NlVQSFdtM1dKUWJrZFl5cGJReGpxNzhzRC81alFR?=
 =?utf-8?B?dGpKM0tLVUVYMVVnN2w1TUg3UGNkeWpGSG1jdmx5K2hLR0V3VUFNS21BaU81?=
 =?utf-8?B?Yit5SVdpck9FZDVabEN1cHJLQlBBazlKZS9UQWtNS0gzWnlyT0wxazBiSThq?=
 =?utf-8?B?Rkx2OTlMK3U2UnVzRUVkbHhsdXNxdDNlQWtiNzNYOTZnbWhpTE9OMVFReXFQ?=
 =?utf-8?B?R0hGSkQ0a3ZML00vdWdhVnB3M2NmanpKWHJZS1NsRGJpQTh1SVpxRTcvSG9j?=
 =?utf-8?B?dVlXS2JrUENFbVIxcTY5R3pNRG9HNWtVRWRHUWExd0RuWHZFdElORmMrREZk?=
 =?utf-8?B?T1lvRkZGUmhhSUpnZE45Q0xHdTN5QjFmS0Q2QVVyZzNJdlVNa0IyUWF1Zkdz?=
 =?utf-8?B?N2hKdTlDTEF6TVVFWnZDZmQwa1JFRUFqWCtRUjdJTnl1alh4Q0NnWEgzQ3JF?=
 =?utf-8?B?ZEhuTFVXbkVFNWNaSnJZSXZGT3ZrUnllWEk3amg2c2t0aFN0M1hvUXcvSlls?=
 =?utf-8?B?SG1GSVpmR3Z5c1ZidXpONk05ejBQbmhPSjQ3MjVGSlNFYXhnMmJ1dnVNTHVE?=
 =?utf-8?B?N2dwS2VBZ0NERXNBTEQwOEt1aHR0eDhZSTVGdUZHbHViamdNSjFjTEZvZjMz?=
 =?utf-8?B?RGYvSVBMWU9reGdOOW9JNWgzOGsrOWExekJqUWNVdU5ObTVaL3hjMTgwK3dP?=
 =?utf-8?B?VzVTN2VqRFJ6ak9TR1FCc2xpRVdWWFJjUEtEcXFIckZHZFJWWWsyUDJjZ1lN?=
 =?utf-8?B?WVRQNDlMRnpWOFlKbi9ncVllS2pCSGtFZU5VaHMrNjRNQk01MzVTK0tScHdY?=
 =?utf-8?B?azlkaUtjdVZuMFZiOWtuNFppYzBGbWJZc1luaUxva2hob1hrZVhiNWFGUHVR?=
 =?utf-8?B?M1lJYnlvdmRyZ0FPcXR5c3JzUkU3RUdDeEIzd1lzN1d5UjNBcGdmcC9CZUY5?=
 =?utf-8?B?QTF2aGlBamtBOTdNY0VFTlVhZmVQRkhPa2ZsWU0xOFFRZ3dscmNaT1cvVStw?=
 =?utf-8?B?M0tuamZHUDZjKzh5TldWVUNCaGsvb0xaUjJsU2h6OVl2b2wzOGg3ejJNZ1do?=
 =?utf-8?B?aUxMc3lOMllRcWF6U3dVWnFyYW10ZFhBNkpoSnFoeElwMXU0WVhhOFY1Z3c0?=
 =?utf-8?B?UXhZVmdhYkJmV21WZUI2dmN2MEN0SURmdHR0dTdER3U2eE01aFpyaFpIZXNu?=
 =?utf-8?B?YTczMWs0ejI2Q3VFTytqNWNDS3lJM0NOVUF1MTNibDBhWEdTam9ZMFU5YjJG?=
 =?utf-8?Q?DngqOvNf0cavmDT1FeEwev4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <425C5F61E6E9494189663A2DD22BC5AA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VCbaJnXhkV/Ua5zSPtU2aSefW65Cwzu9nhXNpD98yfRwifAiO48Z28ueLK3vTSPA2hgFNZU8fmcqRCKRdm8AHn4Fs5Yr3lMC3zHoqV9EztjmEl+BLHq1AtqX8uNniXmWfMeq5rK590wKl94ypIK5bVU8nV5INuHe5xpZ0CySd74mbYQOrLEiNJcy5PI9cMj3UXdzshlGNe7rcYytQiZnnXhM2rsJyqZhnvXE11lTsKI6nPEZ2TcfM3hosRSKgAQiDi0wdEoHGmr4dHtw+92ioaHgLFeNbZ+wmJKFfIBkN0TqNi/AnVxc+zNEa/nTsEfwaIgLufGK0Bg3KMsK/Og5ncFPl9za6jnjlPVLjc7bLZFuN1ogyOcftfmFng5hdU0PBYTRUPPWe+gl9ZtrCw++bo502vxGe4oNY/XMcCtXN0ix6P0pYJLNk2LAc36vtOxjQx12DmB6CYma4iF8MtA0bmtnHYFo0PsLA0/NH/NvjF23gip47ME2Uaqnxq5fmeTbzipuCtbzdxdl4OlSFOMUdvlm1sRu/eZ/QoTZZVa+0beku0NpEo7aYDE/n5f7sId3n7SOyCpoZmZ0pzHErQHeMemmjlU8lWpCz3fLj0RDfTLk0XJnoVezK0CzAI67+L31CWG9X+UjnA+RsXxUVLOuYdEFiCtojVdd4LCMUeSjRNTcC5NzbRi1kffNOIJLuOX+2Tk8gZoqgeE/qSde1DKNy+0RxWtBIMnLSUKyiFEVl2cm339jDG4zJKCftW5R4yeDVfhckMswEY/80tYP/W6plDZdJGE72LU7SH8RCTpZPq4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a119c6c3-6bc3-49a2-1bba-08db83d75710
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 19:28:30.4871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gfcWSaEFhgDWUMZWgl/8k4IjWDFYIaqWld60nIWYISZCOC2zd1Zh/Fnn4kYpTG3la4CToYqaa/h4v2M3onhGchNyFWUNwURpnD1K7dneb+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_08,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307130172
X-Proofpoint-ORIG-GUID: 9vKfxEswfx6bCntjd67JkOqdnf4KSw6h
X-Proofpoint-GUID: 9vKfxEswfx6bCntjd67JkOqdnf4KSw6h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gSnVsIDEyLCAyMDIzLCBhdCAyOjA1IEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IENvbm5lY3Rpb24gZG9lcyBub3QgcmVzdW1lIGFmdGVyIGEgaG9zdCBy
ZXNldCAvDQo+IGNoaXAgcmVzZXQuIFRoZSBjYXVzZSBvZiB0aGUgYmxvY2thZ2UgaXMgZHVlIHRv
IHRoZSBGQ0ZfQVNZTkNfQUNUSVZFDQo+IGxlZnQgb24uIFRoZSBnbmwgY29tbWFuZCB3YXMgaW50
ZXJydXB0ZWQgYnkgdGhlIGNoaXAgcmVzZXQuIE9uDQo+IGV4aXRpbmcgdGhlIGNvbW1hbmQsIHRo
aXMgZmxhZyBzaG91bGQgYmUgdHVybiBvZmYgdG8gYWxsb3cgcmVsb2dpbg0KPiB0byByZW9jY3Vy
LiBDbGVhciB0aGlzIGZsYWcgdG8gcHJldmVudCBibG9ja2FnZS4NCj4gDQo+IENjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQo+IEZpeGVzOiAxN2U2NDY0OGFhNDcgKOKAnHNjc2k6IHFsYTJ4eHg6
IENvcnJlY3QgZmNwb3J0IGZsYWdzIGhhbmRsaW5n4oCdKQ0KPiBTaWduZWQtb2ZmLWJ5OiBRdWlu
biBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pbGVzaCBKYXZh
bGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+IC0tLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfaW5pdC5jIHwgNSArKystLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9pbml0LmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQo+IGluZGV4IDcyNTgw
NmNhOTU3Mi4uMDZjNGU1MjE1Nzg5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfaW5pdC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4g
QEAgLTExNDEsNyArMTE0MSw3IEBAIGludCBxbGEyNHh4X2FzeW5jX2dubChzdHJ1Y3Qgc2NzaV9x
bGFfaG9zdCAqdmhhLCBmY19wb3J0X3QgKmZjcG9ydCkNCj4gdTE2ICptYjsNCj4gDQo+IGlmICgh
dmhhLT5mbGFncy5vbmxpbmUgfHwgKGZjcG9ydC0+ZmxhZ3MgJiBGQ0ZfQVNZTkNfU0VOVCkpDQo+
IC0gcmV0dXJuIHJ2YWw7DQo+ICsgZ290byBkb25lOw0KPiANCj4gcWxfZGJnKHFsX2RiZ19kaXNj
LCB2aGEsIDB4MjBkOSwNCj4gICAgIkFzeW5jLWdubGlzdCBXV1BOICU4cGhDIFxuIiwgZmNwb3J0
LT5wb3J0X25hbWUpOw0KPiBAQCAtMTE5NSw4ICsxMTk1LDkgQEAgaW50IHFsYTI0eHhfYXN5bmNf
Z25sKHN0cnVjdCBzY3NpX3FsYV9ob3N0ICp2aGEsIGZjX3BvcnRfdCAqZmNwb3J0KQ0KPiBkb25l
X2ZyZWVfc3A6DQo+IC8qIHJlZjogSU5JVCAqLw0KPiBrcmVmX3B1dCgmc3AtPmNtZF9rcmVmLCBx
bGEyeDAwX3NwX3JlbGVhc2UpOw0KPiArIGZjcG9ydC0+ZmxhZ3MgJj0gfihGQ0ZfQVNZTkNfU0VO
VCk7DQo+IGRvbmU6DQo+IC0gZmNwb3J0LT5mbGFncyAmPSB+KEZDRl9BU1lOQ19BQ1RJVkUgfCBG
Q0ZfQVNZTkNfU0VOVCk7DQo+ICsgZmNwb3J0LT5mbGFncyAmPSB+KEZDRl9BU1lOQ19BQ1RJVkUp
Ow0KPiByZXR1cm4gcnZhbDsNCj4gfQ0KPiANCj4gLS0gDQo+IDIuMjMuMQ0KPiANCg0KUmV2aWV3
ZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhpbWFuc2h1Lm1hZGhhbmlAb3JhY2xlLmNvbT4NCg0K
LS0gDQpIaW1hbnNodSBNYWRoYW5pIE9yYWNsZSBMaW51eCBFbmdpbmVlcmluZw0KDQo=
