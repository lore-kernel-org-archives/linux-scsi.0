Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91B0C47094
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 01:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7805D60FE4
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 01:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhFHBso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 21:48:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40274 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFHBsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 21:48:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1581idRM134477;
        Tue, 8 Jun 2021 01:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=o3eGuuVbycnAGwm02fAWon7wJjFI65PgUpAFgmX4VEU=;
 b=L8PrYDbG9F7zt8+WYNOXEOirzBEmDrsQDsyWetV1lWQzYDpmcNh+cJZBjjo6iwU7cINe
 hYb70PWef9J0svvoV9g98gKvgZM7t+Zx342/8OxPfYT+IA3OFzljemaH3ALc22AtaZvI
 niuBpnKb0AL01s3eLIVO2//sVQFkVrl4vhPCaVDA0P/S0/OPo++zKTWcZ48wONC760PD
 kr3Fk2pQ2U3uaun3E3r1M/Ys5GbsQr/MeD81P0XRcuDSV6CETygz7gQDIPQpBEXOK/D/
 ITGEBh7lcy23Hz5T7DL/WonU2yzv5aQ/uy/xR3C7/Qqp9ayUGx+CW9AUcmPALcRl+nk0 YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3914quk0g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 01:46:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1581ipnf120977;
        Tue, 8 Jun 2021 01:46:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 38yyaagxey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 01:46:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqN8YHH8PUs0CE9m9yZHcyuNpNaP7eWE0EkeCI1+/LTQICAM1ODy2YpZpCHM/JfT5/nOhkfr40Pr6f6p+ppQJmrcTaicTxed3v1wPZQ/6Elm1wRIsIIEiWJ1ka1nlIU1puepW4AxRHYPGuPxRK2NAamle7t7dVcUAYlUr/bsQkBOXomS0jUcbRDmzkCcRymVu/7YxO6t6zmTs2/mgMScuv1h96wd9M0Z+VfDWH/y2FM6WM+/ZZkDK0J17wBEx2UeaIHkjwo+lX062fihSQr0U4acNH2TY4sHvJpfxPIybit8OUolIq2dwm6OSRW0eO9jhFEJirM/TVaOQtIfdD3p+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3eGuuVbycnAGwm02fAWon7wJjFI65PgUpAFgmX4VEU=;
 b=Co1ouUebjI03QRk1lSC7o24c/tsWn11CV1VeIza67FD2nNATxppI94ILYjUJ7Te8jHBo2ntcJC0MxqvXHPQdzrqeAZGcy6px5HKzIRp3vDrHKhVNnPRby357Ig8Rsk8OTn0+G8ssWtu08c+bMLv9buLYZSdzvD2hJxzo6wZMecYDPSQFwyZXTuSZs0EKDUDSvfIKw3KfQVBI4UBYhlXmgRd4GPxTAHiBFGh5poMqkG9/pi0nnl5o9coYGlGlURJhir/a89Z7KFx+3/3V13xAXTQgV7HhCHEIHflzXcqn4zkFkUEB7sWPA9d4tv0jVcgt67VVSSaSsVOHeSB+JLjF1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3eGuuVbycnAGwm02fAWon7wJjFI65PgUpAFgmX4VEU=;
 b=A0zzBJpiEAZ70ABSbA3mYhLKCRfgPlifAnmCV15UWwh6/YVM56GpcTSR5mSCpquGXg7PucYS1z1Nsie20ZpgmAjDTO/O28F0TrO9CrhRzZw7PP9QLyLkU+4jAoIByY5BhbXH5Ba3eL5hIXGmnRU34jbkoa0noDn7raZAJbKkBTw=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4599.namprd10.prod.outlook.com (2603:10b6:510:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 01:46:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 01:46:44 +0000
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Remove irrelevant reference to non-existing doc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dj5ku11.fsf@ca-mkp.ca.oracle.com>
References: <20210603122209.635799-1-avri.altman@wdc.com>
Date:   Mon, 07 Jun 2021 21:46:41 -0400
In-Reply-To: <20210603122209.635799-1-avri.altman@wdc.com> (Avri Altman's
        message of "Thu, 3 Jun 2021 15:22:09 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:806:d0::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0042.namprd11.prod.outlook.com (2603:10b6:806:d0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 01:46:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 004669b6-bff2-4f70-09b2-08d92a1f4570
X-MS-TrafficTypeDiagnostic: PH0PR10MB4599:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4599543742A53B7AE0B953B98E379@PH0PR10MB4599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwhD37sLFmvhudgX5qni5UVF9+gbd7jXv0p2y8TIeruGaz6N5KGzNyZXj55pvo39xWouGctvgKgtzRYnCBspDL1ZX8sFBYpGWKy7ZqhJrpqbsSXRPxE7AWfvPT7xqTDcQpz7Ohjc8x5WMG75NIgYhF8d3qgtXUCZtMntyJnpWGK1Z2cVReIdUt7npJgu6WDx7vAeEdRyPTqNNfhByrrj0qEtbcwizvGXOFvCv4V+bbp0OYhPklD0M/aSeje8roEIHB3q0D1/0fpaDk7Qd6MZbExAHCFUeyBK8rom1Kx/iT9qwE/PvN2JzLCRMlmx52t0HzUXWfhHcZM5DkoJ1l4LG8OYyes643PaW123CeW1nAie153EeBie/+yodEmKHezEXykNfNB3x+/MFXklWnHuTfbTrN9le9NVWZEPl/Hb64ohQUrOkeEj3Wr8+/1nu+nuuk4SD+N/MlNIFP8w9zHKigw6yIiheJRzxgleXu9SXbgAq9Wvt0m58B+0lAdmecJadkBU4wyamOyAtn5xTB+xT4EEbYlMLJH0CVKUNFyBCsBFsn9SsAX7uDCpUBIZHnhbCBYOZ1eQ9zchQaGjGH5wHg/KXXRVLyX8eFBYGG9vV42itXm9bNTm/McVhfT7tY+M1PbAVWld/DDtRT55ldsM0h7xIqYPcagF0dNx/M8g7R4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(4326008)(55016002)(8936002)(54906003)(66556008)(66476007)(16526019)(66946007)(38100700002)(86362001)(558084003)(26005)(7696005)(8676002)(6916009)(36916002)(478600001)(5660300002)(956004)(2906002)(52116002)(83380400001)(6666004)(316002)(38350700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4KOuw8QazZYP+CkKOzRrD6/Zbnc+xZbtW/dkWo3ROrDdTJi4Mx40yUpULX34?=
 =?us-ascii?Q?RxMkgpJ0zL5dfoK+EESwNxz6PP8trGONkOSA6RuRiBEuPyPfvfWGO723Pn3b?=
 =?us-ascii?Q?USPJ8Oq9j/YtB/iJzQFmF/dIqhOvfVNPOHHO56VTk9JwiKQUebmUv98Zo8x6?=
 =?us-ascii?Q?eaIdQnpTonPteqAlQjrX7uCNA6KMGaNlSESi798xqxb+Vr3sKiJFJLvcULQQ?=
 =?us-ascii?Q?3OoXktWcCGKV6Q3R3gMtButxBAfbMZB7OJcoLvfl6QSjJIdN2s0TrqDXjNwC?=
 =?us-ascii?Q?tEtgppFdDRA7KBFs/vs3akaA6cmU91aBujFvfcve7MjUbNqM0/TJw3pZbfuh?=
 =?us-ascii?Q?ZY2EJzN6wfDTm6/SzdAZg9wRGnjAF3V7Ls8u/XVfLiubYijQfGV40BY5fkbJ?=
 =?us-ascii?Q?6Eaq/ALzlKCsdW7dly3VT+9DOFrjgoG1SsmuAYrVmLzFMuguHpRw1CjRCJuY?=
 =?us-ascii?Q?q0i/yv0ZC8D9fipP78bRyaRJ8ZKHHi20tNWbWJwUtFUsrgVeiAc6L96+4gPQ?=
 =?us-ascii?Q?yl+BGCGwTu4/80QuhrCPwrexTSMui9a63FmQqqg+4YkI9eZuggtlsaGod8Xj?=
 =?us-ascii?Q?U5Z0L/TdDGy1M9mO8U/1E3MAH+A+tL7RHia5hLGZOZ3c69I8jlImjrf9AUku?=
 =?us-ascii?Q?KIu2f91/noeWN20eLI4OGdxAFx5RRXHkAPJlrj/Nk2gCl9LYJdWk4752vcSn?=
 =?us-ascii?Q?CjwjAk5KolC7/d4htHbplMQTmWfaR1HaEp97HI1VDMLx3h9h++7Ux4W12vVl?=
 =?us-ascii?Q?1+ye9tw6WtvkuwBWGuK/onflqKnPT1eJm7njsVM4PuxKucbnZjL12XEVtpoJ?=
 =?us-ascii?Q?uiXhpGDNo5sbyw5KHFvA+8XXh+IuOMVSBglc95NVbeObo3OdmNcyW5MluR7P?=
 =?us-ascii?Q?yuSO7XatD1Ic7rK9tgh/+/19I+UktMqWt/vOykJe+iIz2iAxkdos4qCR7oZu?=
 =?us-ascii?Q?DiQALUg/e9S8fN1tfIs0pyuMQspEAydtXC7B5thVhaYEToV9O1Dwknt858YM?=
 =?us-ascii?Q?0F+bNUkFfnB2hPPMQGRPEg0RM0q0igYyP5G+EjqZMooxteeSjnBjoIxNvteg?=
 =?us-ascii?Q?B8pPEcz+G28qPpBNkcMTgcPkYN/aIhu5YoLCkKLXHsEIcV2WmgrwDvyVRBuk?=
 =?us-ascii?Q?oaEzS2Rz/34g1u5DgPZkLGwMtprSaGxR4uukvr+V2q1QPKN6U6lkV7/U5J51?=
 =?us-ascii?Q?YDIWX8+SlqcnldbLZNMgYNofY742R71XrXPdUjpjZvfQx3IoqbEuod+7kpHO?=
 =?us-ascii?Q?/ND5P+Ny48EehrY2XD7lOTuuvEBGOigBKujEYzztwJESnMcOGDc4P9DknRLR?=
 =?us-ascii?Q?iMrD+WuzpGkuk/Bh5mwlAfDN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004669b6-bff2-4f70-09b2-08d92a1f4570
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 01:46:44.8711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c59OnGFLohkcA/P5yJ6gUWKYsbtn6zWGCJwA2yGTixhk+Atki//mxDuExc/rykoKrNlC/VLBUrn1CIF/xLDqxM8cr31Qj24FxdpnwW2H+bI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4599
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=830 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080009
X-Proofpoint-ORIG-GUID: dZ8ARYE9otome6p-DRYcE_GeyCZyBH0J
X-Proofpoint-GUID: dZ8ARYE9otome6p-DRYcE_GeyCZyBH0J
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080009
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> Remove all references to the description of
> __ufshcd_wl_{suspend,resume} as no such description exist.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
