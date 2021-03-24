Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC1CC433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFDF461A09
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhCXPxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:53:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbhCXPxT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 11:53:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFYEPT106186;
        Wed, 24 Mar 2021 15:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FdFEYIQXqiFsf/G2EfdkD8sAgQWaNGrkRQIOAo4n8OY=;
 b=KbrGYJ0T8O3/NOVgtRUd/1Tzo01vnnQFl2jlAWJmY/6DCdogwT4IctgT7tkTdhZT0bwi
 DgzcszdPJ7Gjy2cFSWrj0P9u5rfAY2fYBc7JJOjHQZglVxMMUJYxKRx9mBvz2p+40Piw
 D0R6tdNpcPffHBJp1cBRdzQPYFT+etwljWQKhBhOMhWT7zzoViealYEeR1EGHikbst1r
 DdSkVSFCdGVqGu8d5jfwsv0uQJUagUiuExhJbESZ2Ve6iyHKkPlClUyfrF9U2QM+qcYe
 MXt2lKtQUNokBAhHmvnZS96eZ8qiDNlNuzM2Pemb4tyI0q4GDUM25gQSLh3ll3oI2Pb7 GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37d9pn374m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:53:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFaDJ8019468;
        Wed, 24 Mar 2021 15:53:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 37dtttfq7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:53:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUBGygB+2Cc/2MzQWs3hUH19NrENT1kzIv5yv/7uHYgeURMPctL80ZvChwv39GKBq6UZiM0npO3zYm9eAvI2fztuNfQE/NituTwQaLoOAuj+gBe6q6Q7Xdbj7kWu3DUgkaklC50ZRVYBUhGdIhWRep1ZLQ7i7F9XfhHVZDJVCV5HDpY9GN+bZ/QnzWKpO6e1g2PwKgCjnaJ/Cs+U+skuqiurhp9DH8JfwMbvIdhO4AfnAVIyalQWnix1zslK+nkVnT3bmCmD8t0MqXLptwZl+FGM67kfcPKHQmQbUgAG137G+Trjbwe6t+puTLEj62Qc67ujkA9yimT8uvvkYQlBRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdFEYIQXqiFsf/G2EfdkD8sAgQWaNGrkRQIOAo4n8OY=;
 b=datgaRNRnOLhicjG+4dV5ipXu0lHMkxv+wcw6dMVSh/H5qieJKogiaHH+kb9wIH1xE8ABIX60HpeApCGmpd5+kndj2XLLmgppbbVyM/h7SqhcavMrtDMpihRDw6qOHOzmQDYVDV8zO/P3jc/z5H1gAaBA/2g1wGshC7VhFGpJDliQWzY94Z0aHQWi0GME74Km19MNHdiXPT6Mfkx5B9slZT3OrpWU722phFltS+hOypnZo4yFWdMKTGYZGmU89HwYFxs4R7fez2sG5GqHXAO5yWIDpoqRDYHGqlVR7FhBJ9QuOWBsZBsgkmWazkhqEoOuTh5FT3aJnRiMHTMLJkUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdFEYIQXqiFsf/G2EfdkD8sAgQWaNGrkRQIOAo4n8OY=;
 b=Uf2H/K52imZgkMs3JJz0igd0hs4AnJEiXA14682bhY7+PZEN8V+cYcuaLM0A1e/72xOFz5TzNjQFR0uCHfYGE5QEG3fFCCO9vn1NxSKUNaI5OReSGI5fbTTq816BAYwG+nxK4eJdjB7syYvN+b95oy4ov10y4RgYS2jgj+9kSBk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4604.namprd10.prod.outlook.com (2603:10b6:806:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 15:53:13 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 15:53:12 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 03/11] qla2xxx: fix stuck session
Thread-Topic: [PATCH 03/11] qla2xxx: fix stuck session
Thread-Index: AQHXH59eHd5CtoHkrUakRJF4FqUzAqqRxLoAgAGHmoA=
Date:   Wed, 24 Mar 2021 15:53:11 +0000
Message-ID: <97BE89B8-9B44-4AAB-AF5F-62E7E3A6D622@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-4-njavali@marvell.com>
 <bd9dd526-776b-87a4-9b81-634ce687e393@acm.org>
In-Reply-To: <bd9dd526-776b-87a4-9b81-634ce687e393@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cd78821-5268-4aac-3492-08d8eedcede1
x-ms-traffictypediagnostic: SA2PR10MB4604:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB460465605F3283AD3336F5C4E6639@SA2PR10MB4604.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tb4jfNkzt0W2N0Dl5DVa0BUeQuOk7DP2ZqyNB/CZTMItenIub8Nuyh4dzbzl5Lgt2UVFZbEUDWx3BwSTQTnc+l/BoK8UgiKNXqcn1us01VtnqJiH1obZltk1MSoNzOOA+oR6/4Ef+034U6Nds+eQiNdjVQ5iFUL3GJCjt6IFz8rDQ2uRBqetCaEQq6As8gjcLYSOZXS7ZC8Ifvm+/U8/LbNC4Mquxy9AlzWUCeN72sXw8TtvCBiVFZqJ/PoA0eQLeXNnRpW0hTZAJkgkJ3EB0UM49FMp3JIMNX71lvAQXh4jBCEE854yjx/9O65D0K9wFj+IiCaa0bdMmzz+pGIRAzmOq7mwMce9eeuePRNYG5skDNwNeSe+rpXa4PhJYtT410ps1dslFKAZZ+or/I7CRJnElD3cbqv5feONKfFBeDFN1LLmc13S7Nqu1jVqz5N+XCeXkX3HN/wFI79uz91Kbr666LjCm3+bPdpPgDz52dXmHj9te+wClX9DyWse92k0gQn+0bAenGW7kSWN9NWAEs5EZbJnJP17WcXnSWqA+lF10WPbe9TQhTycCx2e3tuOK4TK/AcnAN8siapGDCaEzjuE0xtbs7lrtBoGHYEwTJ5STICepWz5oFFu/oGKO76Y57anyEdfsWcBE4vh/glXBc0e5ERWvxiv6xJjtYCyx0TuGj/XcFvUwOKTpqQG4e0k
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(396003)(39860400002)(478600001)(6506007)(6486002)(53546011)(186003)(26005)(54906003)(4326008)(316002)(2906002)(6916009)(6512007)(44832011)(71200400001)(33656002)(2616005)(4744005)(66446008)(76116006)(64756008)(66476007)(66556008)(86362001)(36756003)(5660300002)(38100700001)(83380400001)(66946007)(8676002)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GGY3EPLne/XJL2ZcemEaEletv5Cb2ivFE7UWW7NB28frL/OZeLiRkwIAWd9N?=
 =?us-ascii?Q?7HOwfozy7KGNZ7aAAd7QjElTW4j6qIx+ab4gHYbayIJkLqGjfzcJfw91HzBB?=
 =?us-ascii?Q?zxEucRuiSaRLgr213hCguYhZpD0mwf1PZc4n3RPGWRtQIvR1V2/w75R9juW0?=
 =?us-ascii?Q?6AHC8h5GeDCEnBj3ruRK7uM9JLWWoKVN2jMDEf6A9yO4+7K8HPIikIkxsNkO?=
 =?us-ascii?Q?iqVmIPE1jk2gx2GhpEkxMSIzKEAs2adsQbQVMpuvqirWtqOHhEl3ygQb0bbC?=
 =?us-ascii?Q?+km/cIyuBOItTdc7cyj7k87Vq1LiX+7LBo4GLZqGiHTQnDo36NvMWb0Q4K9E?=
 =?us-ascii?Q?k+LBDFe5FeoDf0y1S+3Cri9S1LHdJAwIGfS1EqhotG8THuu8pfVnI1pmxh9P?=
 =?us-ascii?Q?OTL/a1vddTqba8cyxZlAIasJj5oR5tHUQZTU20zE4yiypxXE6xHPnXgLwztF?=
 =?us-ascii?Q?oX3QEdQv+vDYblSEukBPkWLpSk6SH0YX1YVMwTyaelcTzC3p7GTTxQzCzh6y?=
 =?us-ascii?Q?bBXKdFuGTe44AbjEOEGqxvCMIhJIn6+ITH5JMn3q0SfEb6dIxdOOlvYddxpp?=
 =?us-ascii?Q?MpLqu2cANoDfr+55dz8xnmt+3DB1EeFCYPZSFt95pOuMgHPjFZjXh9mt9Rs8?=
 =?us-ascii?Q?f9mxOBwQBlrQfilwQavdbniHgNydMMK5SR0/XfAuqkttmpiapOq9uRShO09L?=
 =?us-ascii?Q?dtvLwcoKSSogGwG5JVpajxBwMsNFGEaz7qy6tyjSelHFfVqSKyeZjwdXAUIM?=
 =?us-ascii?Q?9RD5c7V0JhxdO0IY0L9rw38gju+mJYuToeQJ795Wq22I7NP4zEhL7sggcG8N?=
 =?us-ascii?Q?gm3eHa14Ar9wmrrfE2+0G6uTvbYWcOtBvJABGYitCZGUFBcu2OBbZhkmb/Dz?=
 =?us-ascii?Q?J+g4b8zq0ScXQEPlTXAUb5p3Bb/a9ZN2G51mJhq21XiXbMRmadjGJp3ltFeq?=
 =?us-ascii?Q?2f58FUqvo//EUjY4aRxS6H/JEJ3KLlJn4dTam8vM59KHu/rfVS4LHbyBOrO2?=
 =?us-ascii?Q?9zMbBH99ynJgF7PbFN8mWVLHKEZHMYo4z+seWP/eyGHid8nfOt7ptwl2xw8n?=
 =?us-ascii?Q?Hv/kMoXV79XbUT+WEE9KI5iR1yDXpIUfN5BN03KQaZNgIfkmNgAWmdkbWKkj?=
 =?us-ascii?Q?Z8/zzMt12H2AGfqWeEd92XS1EbyKh0BrwBiLr/chRZKna0VTLgXssz1tfESi?=
 =?us-ascii?Q?Yd68VliWdkFY8iEUC0hjBtib8+BOxQAkGlItec6fDjSqTNVaF/Ug9qB1mzSb?=
 =?us-ascii?Q?XKD8V7y06Ro+S4j5ryv/7E7Co9q7SWHa3o5k5QkgcxsETxam24LUy8YUmmg5?=
 =?us-ascii?Q?9mp+0c3IbMyrakgsQemif2EQ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DBC260AE81183343AE56B5CD87CBFB2E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd78821-5268-4aac-3492-08d8eedcede1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 15:53:12.3290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdyV2VGsDUB0xx5pmxzlCUXXjNP+yJkHHqadCYtpT4CpiJhXjriQG5vKb3L1S2Jh+iVwD6MNWPI9P/HgkD5xQ8lIXOW3iKcLiDj7fh8XKoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4604
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 23, 2021, at 11:31 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 3/22/21 9:42 PM, Nilesh Javali wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/ql=
a_target.c
>> index c48daf52725d..fa8c4dae8dce 100644
>> --- a/drivers/scsi/qla2xxx/qla_target.c
>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>> @@ -1029,7 +1029,7 @@ void qlt_free_session_done(struct work_struct *wor=
k)
>> 			}
>> 			msleep(100);
>> 			cnt++;
>> -			if (cnt > 200)
>> +			if (cnt > 230)
>> 				break;
>> 		}
>=20
> One magic constant is changed into another magic constant and that is
> sufficient to fix a bug? Please add a comment that explains the meaning
> of that constant.
>=20

Agree with Bart here.=20

How did you come up with this new count value?  Some more details (either i=
n commit message or actual comment in code) would definitely help understan=
d. If you have some log message snippet or stack trace add that to commit m=
essage.

> Thanks,
>=20
> Bart.
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

