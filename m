Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B43C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D376147E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhEKD2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:28:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhEKD2A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:28:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3EMxx071736;
        Tue, 11 May 2021 03:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WAzyhPDjjTbw0aDd0AmQLG9YEdmmv0rvfvLqINRis8o=;
 b=BVnRuh2Mnggboxy6PhBuNd/8L3LBodkSkjMNmEmXOgQAr6LkyKUaDyK1QvWFKcoXfn9r
 mixfWoNxPmtQs9pVXpXzqUPxmYvo0wgHeRpxAPrBIsLwFnjcYfKCy8/Z2MUP3PYDkZI8
 VC8CgZp7NonGqrZVdmq7PgycVmRpRrZhXj5bQLF2tmKpfKw2QjfGHaCZzyhCe1q2z8HO
 rnM++sfueUpxiI75Y8Rt9xr2lDz2KPiYfYWMVI6zf62vAsLyjGrq1KZQJPy8bFlSAkL5
 VDpBc1EOJd3YV1ZfwCu60WtzlH81WGrj2wKeIg9uHR7Gtu5G38JN1e72qJ70HPjMe5im LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38e285cgda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3FvE8152680;
        Tue, 11 May 2021 03:25:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3020.oracle.com with ESMTP id 38fh3w1u2k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnqZMEfhF6HhOwNJzb02Nty8aHx0wl/yYxGKZIKiMabS2UFL+WyDAUUg0Jqi0L4k1g74mC362GZM8q4BXw4qPKzh8GUpiq7OGgMDCbhejLLQoUsUot9ciZHTcRKkWF/gUQPGUQQ/Ruw4YguMpkXxTcLm9eV1tsyNl8rt8QDL/PVtLRYCOe6chBX4IglMgmS10qLCReht4HL9CsqXAXWW835cm0L2x70FrmOMVWk4Ynkn3CTmqFIw1n+7uu2yPL/rn6viqrDy4XZ8E0xSQ+nX2NDntQj8L9hR25jLLgqE3jztK2VDCJPhuzmsPeiodZVjFHd8GHaJXkorAvHWxvGZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAzyhPDjjTbw0aDd0AmQLG9YEdmmv0rvfvLqINRis8o=;
 b=Nqse3F/ChDmB0KJibLbGU1+vr70WBehbFtskYuxIWNzbvKzQCewKK+5vfoI5n2Yo7mSAp/8agOV2uXG1Lf0ClCLvVryE2OPvdd2mUnP4Xzm9ap1Bo+0+DvotaPVz77wh+h4HIa35OJTS/wfyAEWQTsQoFrK/kuXdrGg42Ku6WxJBztMv+Vg+ZWEVAqVMVxJ3AFQu7LnHWrUmqzKUEzUQ6Pc+x04CpCkDoXWGwMIYR9DCySPvY4WEYIOHQ0llehTd457WqMxE7v1ahswCdiCmSKtmXtCWdbNvDVrmtIbo2DJzkYMEFNxtif4dIefKB7uDDjSiCpml6NxqNthO1Jd+0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAzyhPDjjTbw0aDd0AmQLG9YEdmmv0rvfvLqINRis8o=;
 b=mDn7nhv1v7kQI64iNRkinr7yOFFh5gVChZ5/8s37gJS8tIUobubeovOjlE8qXgfwfeG9soyTv2WefW50ksx4TDJKlQUWlmZTkNBNbZ/X52R6jVQZgr3XttvCt3IXuG4ERuMzvob4P/IDn27M2dym4aoiY49d3GfCKT10NEpMMF4=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     GR-QLogic-Storage-Upstream@marvell.com,
        Manish Rangankar <mrangankar@marvell.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, kael_w@yeah.net
Subject: Re: [PATCH] scsi: qla4xxx: Simplify judgement condition
Date:   Mon, 10 May 2021 23:25:32 -0400
Message-Id: <162070348784.27567.5562539253052404579.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210414121726.12503-1-wanjiabing@vivo.com>
References: <20210414121726.12503-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 343ba65a-4921-4c7f-cb95-08d9142c78bc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440896A17DBB10AF3AC0A85C8E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hBYpjd+/3H0PmrG29oiqL63y6ofsZoiSkbsbM88Au6Ic16fcvSVCD5esWWfNAh+oaF4z7R43jwtJsyH9ctnJTrGAtZp27arVIxSRTobSBQ3k3Y2OVRateMx+Uq6j8prt8DmZfDMtKS5mqxyylLO5NJLYxTNfnDp8ET4p+kdTDVTkadv774iKW+fnodlapWZ+A0yLMrOl8MnIqO1w6wUiaOE1rRbL2La9hyqoTJx3J0QxQe2uspLbFrzscko2lopAjdBe0/Wmb+TdgarH/d4aDJFfp7FvXNo2MRBNm+VoQ1JF5/InkyXIzouvUy8mMGFF5upYrVK0QnAU4ipPn+4312d2Mm4rqibQttaT6Mn80lqRCJr1L6qU8bN47WwVEtu6gGzhST3Wv34Fi3fGoF8KuGEc8W6rAxpqyNd4gUERSyrL7NhibOx8gPRGXLoubNd0rN3Ch29m2hOK3RkA4YaP3TEJQhLrDs0z9k1AVTnQA4uk+bj81KDr7UG/dbluAG4SDp90xv4t1LNpU2olfYh7Zg3Pg7ACswfp6jMZb0ogJgzhabEIjloNgQA2kWTMpvP/ZnYJlIcuIe6SJtpF+T9yDDtKRAJbBy95QUDt7CluDqfojozc2mwVLaHinpOumAPqMnnxQV7OAMsSHaOmRXdW8jCgFCgi2slcAFAsiMkXAVm0rOJfayzNqFRrhY2+Vqsrgtuy2S9plG9iYT+rcq7pRvqABFvHcMgc1ws7kVimU2ctCn4zAi617P35KLJOSu7/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(5660300002)(66476007)(16526019)(110136005)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(83380400001)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(8676002)(86362001)(52116002)(7696005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K2ZmMXRveWFNR0NzT3lGOTNZY3NpdGtzaERMZEthcDE0RFdXVy93UVg5SjVP?=
 =?utf-8?B?dGdKTnIvZzdwTUxKNmtDN2ZtcFAzVVdGR2g5aitzVWFNYWQrMDRuQVd5NjBM?=
 =?utf-8?B?ZWRlQ0hLR2Jsa1F0UzIvSDNnMmZEQzJ3RHpsek9lRUJoeXpBaGV3TENUMHRM?=
 =?utf-8?B?eGdHb2hsVzFwaFNEc0VuTkJDR3lOdGtvNW1UZHJnOUYrdklhN2h5Q0xpbFc2?=
 =?utf-8?B?Nkoxcys3aW9EcVEyU0VQbVhTK1Fwb3VXRlJ6NUcxaFlma2Y3WmxpditZeGJs?=
 =?utf-8?B?ZmIvcUY3QVpGdmlocEpiYU5LcWJ5cFZTaXJxdWxYOFp0djB5bjhyb3NmcEx4?=
 =?utf-8?B?N2ZwYUJNU3R0OGgydTBHOHoyaGFFN1piN1lPNTZRaHdsemdxa1pnT2xNNktV?=
 =?utf-8?B?eWd0dWhSM1AyWXVPd0YrbDBGZHBTT1QvVzNtb0I1SEpiZGR6M2UxeGJmdFNP?=
 =?utf-8?B?Z2lNWUtPM29SRVcvOG94VTVCcFIxRzVmb1FKaDBJNFlENWozbk1BemNXbW1N?=
 =?utf-8?B?S3I3c2gva0NUWm9xc2VaRm50blNGNE52TEcvOXN0by9YVEJtUjhONmY5Y1FW?=
 =?utf-8?B?MHRkVmxWUWlGanRxNVdrZUFHZHpjUVhmanlYVHpXM3lYRDhnQ2VJV052K0R6?=
 =?utf-8?B?UjFGd3Q5ZllBYkNXVDVmdjV5SSs3VS9FQWZhMlRYcU9vMlZnakhGTG5VN0J0?=
 =?utf-8?B?MHNZaUU0bytFZ0VCbElkQm9PUWdWSnAyQWFEWG5reis2V3hUZnhCT0dWNkUr?=
 =?utf-8?B?bnlhS2M3QWhiT1BJTjlITXVianJFWjRtcThUNU9BQno2Q3gzNDFEKzlUM2tr?=
 =?utf-8?B?MldmdjVkS05lK2REbnFKa3dtWmJXMUpMeDdxQjZBOUt0dVc2T3pvQmtqR01p?=
 =?utf-8?B?dXoxVktwYzZIQTBVZmFaVzlyUlhwb3ZYMVJBb1hqV29USkZ0NTE3L2pYRU0w?=
 =?utf-8?B?NnpTZGpNVnh3a3pFaVlyYk8vRmd4aUNSNEdsVnFheHFKL1QvQlZMckpybFNJ?=
 =?utf-8?B?NkE1TVp2UytORE15UGZsV1V1alhjWTVpWkN3MDVnKytQbktRdDFXV2tDdlFr?=
 =?utf-8?B?ejhqYVVtd1pCQVViL3IxUVUwU1JzVGVIbFVyVmVmV0FYV3QzMmVyU1VqOTZn?=
 =?utf-8?B?OW05TXB3SGRsRjlhc3AybFZqTU11bTRXOTlaY0ZFTTJXc3NZN0dkZ1NYbGNr?=
 =?utf-8?B?ckU3U3NaWkdqbXVUQ1dGb0I4RnlLTlA5ZnIyUFJiTDAwTi9pRStCRy8yQzNU?=
 =?utf-8?B?cldXZFZPWGdCamJpUnRwbFNaRUoxRWtWWFZjeHNxa3ZpNnl5K0pHNnlaQ2py?=
 =?utf-8?B?dnFtdndVNWR6VHFrQ1hBZEZWT2tmTlZ2aHltQ01zWDZUbFhKT01YUnlHVGtt?=
 =?utf-8?B?RXJBcGZ1My9EaFN1Q09HbVh6Rm9LMTBIVGw4MXVCNnk0YWU4UlZyNThKS3VK?=
 =?utf-8?B?UHBPQ1UzZVRTYUYzdEZEdEU2RzVjQnoweEkzMUhuMzZFZy9lbDZadGg5RGpm?=
 =?utf-8?B?ZGZiZTFWaXk3NnlpT1cvTEdQWWlTUkFtQUllYThTaEQ0UEZkd2lBcmU4SXJ1?=
 =?utf-8?B?Mkp4b3NIMnd6azc1cXp1QlQxTUFXaU5XdkE5aWhCWWpXT0hEcm5ZMU9lVmZV?=
 =?utf-8?B?NUd3NlBNcXBBbFlESXYwVlNDcWtickdlcXU2aDVlL3BRMjhoR25tWXJrVFBz?=
 =?utf-8?B?V1Q5bmZSRG1mM3JMdlFUL1RQQ1M1T2ZMZHhYOEtKbE1EOXJ3cDJnQ1Fka21v?=
 =?utf-8?Q?EsK6g3rYvTLWUgvnAcafhr6f+0KlhAtUtjQjUP2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 343ba65a-4921-4c7f-cb95-08d9142c78bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:48.8113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exT25bomnaLpdB9V3f3MMqk9RJgTVBeuZYao7kI2o0ojQQYMG5a08bViUwaU0NyAAt6ql6c4j/QfR/v8YRj3FllpDRNm1mT9C3+bTj8hkDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: Uzqx8gIpNY7dugQ9OR3GapA9Ev5Se66F
X-Proofpoint-ORIG-GUID: Uzqx8gIpNY7dugQ9OR3GapA9Ev5Se66F
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Apr 2021 20:17:26 +0800, Wan Jiabing wrote:

> Fix the following coccicheck warning:
> 
> ./drivers/scsi/qla4xxx/ql4_83xx.c:475:23-25: WARNING !A || A && B is
> equivalent to !A || B

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: qla4xxx: Simplify judgement condition
      https://git.kernel.org/mkp/scsi/c/ed26297d14b7

-- 
Martin K. Petersen	Oracle Linux Engineering
