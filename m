Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6CBC433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 17:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07F6F6121E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 17:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354755AbhDGRS0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 13:18:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37660 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347857AbhDGRSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2021 13:18:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137HF51Y103607;
        Wed, 7 Apr 2021 17:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=33tr++dHzjxmD24/8hMneUvQuDnlVgnhOjKQVRcelcg=;
 b=FWI6IF+7wVMHgqYK8n+zk+Cjy30S5riRhvosEY0Jd3yxZ3smQtpOnyfX6P1J+JglP/Hb
 Woy0QdsDtXDfEDEyYVReZjhGltCNtjjQ5A8KWtgxGUviUdU8MfXo1THiKVj27fiy+m86
 NOiVCk1Kr/6bqJaQOeA+geVAWW/qN1ORZsH/4zgcCXdeT9cJRXhzYUKifbL0xM7dk1TK
 yQ2wj9Udl4B/cvqQ8Q6M8pEOcHcTMArKkslcWswnpDs3kY+J8arRHXxzh+OdT5h+tmAR
 Dgjb2BMggixcxaK8S/L79JjDUyC5ilZkfZyJThOsC14iKGLwYjNUiO3LnZ00z7F3sZjx KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37rvas3bgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 17:18:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137HB8LG051391;
        Wed, 7 Apr 2021 17:18:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 37rvb05p1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 17:18:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDobSeo8X43OCLHiLjhyTivQOdvX/zCWOpGe5H82XmscEO77J2hg4zyvBj0RliO7HRTA3BCgLe8k45Dw0P/ts0TmLaTSDkX5MgrdSOVOKspkFPKZdt4IuYMrVTWQE8/RYlt46Ekkb37o715Ukx0tUnAyxkvVRtKDky2My6/NaocEZGktRI6BkrV73H7JVv5av2SSAO8rm+1pN4jLd+zNv/ea95K8aHMVjRlgJm7qLiIeGmYTinKKNI2oXlZFPlVwnk/taw7Z3uwDgty/I0+kQTw3boZbKVFny2ccGucm+qA5Ay8k/a2OTNFofhAignGG/QGHnyhZxO+Qwnd7Se+37g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33tr++dHzjxmD24/8hMneUvQuDnlVgnhOjKQVRcelcg=;
 b=cuSOe/BaXtdHa8G8zANLrqZgkKnUNQmSTZX5sX8KQcb6Adp8hBr5/qT8EUQgzomAh58/iwT6xOcbjaxIhAH06n/tlZEu/84QdDILWFSFlpmob+TQEiJLP6EM4ULNSrs5vFUeH+HMP50AfIEpFMeh9PLiO2x7mtpQfkmBZ6NRsEb+DKHIThsQGkDM7YCJH7MfFQgwughsTa10CpUQfX03zKVjsGJ+WJDugyrEPUHCzRRIfVEBgg0zO27Zlm5RROuzV9yTYS2/iYnQmmtywIpeKpTNidPWu7vfH1d4jxe72AGDXd1JLvRP4SF8gQ26h//viT+StFpzMGg9qeZOAthUtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33tr++dHzjxmD24/8hMneUvQuDnlVgnhOjKQVRcelcg=;
 b=KT42K99hWqjibrflrtqwMIgA9EG58BCKqO+gGL/+Rc7gvyaKB2YTm43Xr5nG7dfCLjh5M2jpKsrwqKzuwoOtfPAR8hfAJAlmNSIsXlJTI4MlIezz6Zw0ADdrBYdRLoIQhdNyzpe/7oyBI+FFCu5ofAr1nkym9hTaSyfjogTYJDs=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1376.namprd10.prod.outlook.com (2603:10b6:300:21::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 17:18:05 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::6091:8d07:2f26:cf44]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::6091:8d07:2f26:cf44%5]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 17:18:05 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm80xx: Fix potential infinite loop
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blaq9fyx.fsf@ca-mkp.ca.oracle.com>
References: <20210407135840.494747-1-colin.king@canonical.com>
Date:   Wed, 07 Apr 2021 13:18:02 -0400
In-Reply-To: <20210407135840.494747-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 7 Apr 2021 14:58:40 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:254::32) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0027.namprd05.prod.outlook.com (2603:10b6:a03:254::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Wed, 7 Apr 2021 17:18:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f077595f-8ea2-415f-01f8-08d8f9e91b63
X-MS-TrafficTypeDiagnostic: MWHPR10MB1376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB13765577A27F3A63BF36C4D78E759@MWHPR10MB1376.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: msj7Y4SMI3AYw4K4+LgaO4n2YwHhmATOlIXoDntbt0d/4YF3Ad1jk/aLhQFboBgYAmCxj32DrjiKPzsl6ELoBpiFG+VU3OoErg3m7Oy+gXcbSwJrNhtYjtFF7i7aPW6jLIGfGZukvgL7fk9YdvyDV+/F4JUzCNfUNsJQoXqT7S4/wFJIxs9596h2BHZLpK/OJNI6Red+wimIy4llNKEPlRcQ/57+d/hoMuxJbp1oeS9reXPQT0lRoNbM89yQZgCqdhMdtKBPgEqwZLmJiwM9kYxnB7RgVvd/IRC1Yp835sD/mqCqbnrbZhoqkQ32BzM4Pn2JN9O7anibdIGMWMht9HIUQ+DkUTuL9XurmrO9bMhTLBcRNwMXk++vXMkXFLSQrX4KrRZQr/PPr+o+UCv6e2cUoFHQAotDrBXevjGaShoFFFAmISouffoFnt7j4cwbmkVEdlQ1FXnh0OAhHd0wyMA/LdSInRJQ4CWoQhMQL9czqkmZKIvoovC8s94ADTEpaHhZFqYL37d7ecJrYjMtl4Ix/Lbw/G898VyL7oT8qmiY65c1Oku4pSWW9sifJ8TO27C6K/V5o2uRi+5rwZOGAHWiWiOgGjKgG9k6IPb4sVZna9wKKyNjICGrul6wqSaj6yKYqDBm43f96CzoMdNYQIDKojZUZUfNTyvRYHp8ILP+sUSmC7JPsZ56fO8l1Ipj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(956004)(6916009)(38350700001)(36916002)(8936002)(66946007)(8676002)(2906002)(66556008)(5660300002)(26005)(83380400001)(478600001)(86362001)(52116002)(4744005)(54906003)(7696005)(55016002)(316002)(38100700001)(186003)(6666004)(66476007)(4326008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Fs59wfLw45skekUJVFjaj3QpV75/Moznqsj145k7tnaNaF8EkDAbWo07JRl7?=
 =?us-ascii?Q?VOkPueYAccSdbttxgVXWAhn7IPFIoBgWkmiNhWM4o8pN6ulAgEdVz/wHkec3?=
 =?us-ascii?Q?3MOInHNPS9KcXW/40QevHwg1dpwjmIVy2YB2t4lehIO71I34edhApkR4QrSK?=
 =?us-ascii?Q?JQ091XVrApJkhgfNQNOTUtP3NT8ZKRUZH2NdpokcCMoHwI1nkczA0DlktUFq?=
 =?us-ascii?Q?ukmfwO76115ZXlCUmFiL1/IV9lh8jGeyxV/iAuN0CaF6bK4hKqjGa9xf9zNO?=
 =?us-ascii?Q?62oljBipt97McJ8idT92m+O3YUCfyWrSZdcnf1IS3DGlGE2Dv0i1/6n8djzt?=
 =?us-ascii?Q?ArpLHdZ1VG42785FqWs04YtvZo72eocYCzUtaOvxDSY4nkk3UHm3rajk5Zpz?=
 =?us-ascii?Q?Pp0judkxC0une/nEtNUfmpMZmbHky6QbkXPtb7JCLZaVdxl58laxFlWabvFc?=
 =?us-ascii?Q?jMjZXGgn1KtpxFJuBiafWiAu+MvIwvxoYcOrlpFqduMLkNVKw9NTPRDtcEfQ?=
 =?us-ascii?Q?k3dDdTx2eraj1SoronW+xoiz5FLxLZqVqFk3IBAVPsDZeXxAJida9kSwKCI3?=
 =?us-ascii?Q?Kn4uCYu2zQWGK2+OMtGLQ5N19TGkCPnVqIuHeXBad30zmULkUSDADguGmfiR?=
 =?us-ascii?Q?7jvwhuuUTWMJ6+9gvbdtDRh+nAKNZ7uzjrgnvniNbQ6lZZ6VLoURa14DyxwK?=
 =?us-ascii?Q?GpBXwbRPvf6tOoceeL7rFDtLCfJ5pWyPa1IhL9uQfz8KTY+2gFAkqHrqGmrj?=
 =?us-ascii?Q?En2QCj/KSCFLPDxUkbVlWGN3ja9wIaKqVLlJilFFNtatAL5kNiWXV2cxSHrO?=
 =?us-ascii?Q?fz8WSeToDnM0EpUZ8XAaGH7c+/M+4FS3MsGixwPQIwH1umFpybSynYtj5v2g?=
 =?us-ascii?Q?qdPleu6nZHPrjWrkDRLgANQQ9rmpAb1z3Xv9MvXIlXf/97es/B1YepgnD/Y7?=
 =?us-ascii?Q?MH0u8V/rmz0wRQ3lbMIEw9mamAkew+twuAZyofYy1ZuYFXTtYjpntXxYmI49?=
 =?us-ascii?Q?4AaQc7fAlsAYDiQJAedCDpkJy/M6jqd8I5XhWLufocON8VUtFJfdthmeDgKL?=
 =?us-ascii?Q?/KU8tZItDjR2Nq2Lz3cAenBSUrnUKP5e0CjM/9EQHJJjSKoz3PzGkNVaHF9C?=
 =?us-ascii?Q?ZQSyb5xRugrv19WyWkWQbE+33JK1INgcF0PQQT2NXXdZFHlHWS9UGom+iGhi?=
 =?us-ascii?Q?Oxu2F1QlURJHmWWF3G8O8eymwwxllziZN6u8NfcGDmYxT/nFejMIWSRACpkt?=
 =?us-ascii?Q?QWMVHveLNze0RE+ObwH0KXbsxuAQDAwW50Yl6rrr8XWpw0wxC1kTTvnJqfQu?=
 =?us-ascii?Q?h2H8h3qXNPDhM3nyo1xQF5sw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f077595f-8ea2-415f-01f8-08d8f9e91b63
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 17:18:05.7076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ehz4gpGLnXbvgPC6Fz4bLhup9hN105uuxnWl0rqlUiwYDQq2jS5jmzuQ/psJ0Jank3oer96FCkHj/hnDMcT7eadZBCHl1qdEB5L+o8qzfSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1376
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070117
X-Proofpoint-GUID: naKXGQRpoHDg0byGLphyVXpwsk9yRQ_P
X-Proofpoint-ORIG-GUID: naKXGQRpoHDg0byGLphyVXpwsk9yRQ_P
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Colin!

> The for-loop iterates with a u8 loop counter i and compares this with
> the loop upper limit of pm8001_ha->max_q_num which is a u32 type.
> There is a potential infinite loop if pm8001_ha->max_q_num is larger
> than the u8 loop counter. Fix this by making the loop counter the same
> type as pm8001_ha->max_q_num.

No particular objections to the patch for future-proofing. However, as
far as I can tell max_q_num is capped at 64 (PM8001_MAX_MSIX_VEC).

-- 
Martin K. Petersen	Oracle Linux Engineering
