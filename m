Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987D3C11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E5661D54
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhF2ESz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:18:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9850 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229480AbhF2ESw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:18:52 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T46DsW025736;
        Tue, 29 Jun 2021 04:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qkvnmGTjHWAfkz+t3fX1J0PWApEs0aPy/pNHH6gb3Ak=;
 b=rdIadwunWc3P7kDlZhxp3Zne3ixwZCEtMZKt/4JSaoQy/j39PFvPNWG/uvUwdBInZ0qz
 fhPjlhjZnELXExgr186V1cN99PZAxwo/Owqm9s2ONK8VL5xGPj7yP2m5IUauHo4bsi9a
 7jINrQzVf+JuvvTw1ilp5mqyZBVWOdi+77k4jtY58SQyVq4JUqpjsf/0G7s0gDsKh0sz
 WCduyXn8v843Wfu2Y+zODUKZpzIxZANhJ9Cnz9PAuCU2RhJafv96gr50p0FnwB5YMC7C
 rYf7Hegn1b3Qir7JHi1xyAkc2CTF2XVAKA2h7y2Cs6sTnU5DyZqtgA4XbGjIL/HwJL0B qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f7uu2d58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49o1V150565;
        Tue, 29 Jun 2021 04:10:19 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 39dv24tfcp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebu3PIp0WOLm6CviFMiFWz1T2yCyuNHkeOhZVbOKF+pmsjRj6RbR50STcauB0lWWbaYlI84Z5/jf7XFFPlioaeXCN3+7W9JL3hRPWX9xspn9R5+jVO9TB5d5hR/B+mge9ArO7R8g+miR8pYG2/wNjdmBSTOBPhzbD0IeKmLkPDrKbKbYfzHYXcSaZ4Az+pxwCOtPUUGiyG2Ii62YEvRraYvd3N6By8t105tbV7L28P0Gzpvmhfume6xHj0VrJhrascFhR0q3mVxRO2uaDXMRS+Lv+5eT6mnvuqKA/67SAjR5tdaW1orAJ8gWUq3KvveGfGz+bRZPiZ5nyyTJeBf4hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkvnmGTjHWAfkz+t3fX1J0PWApEs0aPy/pNHH6gb3Ak=;
 b=a0kZoiECCleLscvj+CY2t0es6yw3J6f+a3XhsGL8l3aVwURgQXTPbIf+72ZPiqhueZOFUQM6yH9+0JpdilnMGs6YHslJFC1rBbKeIqMiNxtgebNHbzoZKuOHVZrybT7fJS1mYTD/SFWyyZU4/sRTkhKAS19i+bWfEl2ZJ4eDt+C0TscMeHu+W8jbmcI912ZL2MZU+G0dV1WXZ1NIBmzx/hkDGZZJL1br5LNQ9u68UXUiJCH72PN8zPtFpHTn95JhH4n3pzgUpFPUi5X9peAYyZjLDNGyfbQLtnZd11b4+ZiD6uOPdYVMuGE2cSMc6yFfDd9Lta1gOICyVJNT8OctrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkvnmGTjHWAfkz+t3fX1J0PWApEs0aPy/pNHH6gb3Ak=;
 b=zHNRxSHpQy1vZIBREaaopVX2nmkdOcOeTJgS7I8W9CFHhB4Ed0NdM+jFFeyPDjD9N5sRhfIr6j8A8j8lEet7oo8mbqkmO4x6OxckA6z2tImUw6ZXy3WPe51fWFX0gbgIf/HOzKCLcPIxO0Prz1SDAhAvY35/ADoOSF3wIsUqWnk=
Authentication-Results: Parallels.com; dkim=none (message not signed)
 header.d=none;Parallels.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 04:10:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     JBottomley@Parallels.com, jejb@linux.ibm.com, jayamohank@gmail.com,
        jitendra.bhivare@broadcom.com, subbu.seetharaman@broadcom.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        ketan.mukadam@broadcom.com, minhduc.tran@emulex.com,
        sony.john-n@emulex.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: be2iscsi: Fix an error handling path in 'beiscsi_dev_probe()'
Date:   Tue, 29 Jun 2021 00:10:04 -0400
Message-Id: <162493961198.16549.8268299897903445004.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <77adb02cfea7f1364e5603ecf3930d8597ae356e.1623482155.git.christophe.jaillet@wanadoo.fr>
References: <77adb02cfea7f1364e5603ecf3930d8597ae356e.1623482155.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f838b979-7767-417e-c6c7-08d93ab3ce36
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB471145801E2116FDB889174D8E029@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HjtT3JmVni7j5igR/2W9ImhO0IkvuRk5OQryY95shqyJj1AjMavtaI/NzUwq3N4KlQW2uKHU2fLGdEdAKX3aIHpaKqjhbqyfbDsvb0h9c2P8u49o0Uxcxano/FI+fgMj9+bqhJFTJ3sduQymZZT1bXoreonqJUjLDd//BBXgKzxhFDoccR+hEgPOoJ2j0aYj5EPCMxbmBA+FODJNlq2gaKfNjMeZRtUfzQ1fySLfNd0abZiuEMzMbarKxpsY3D/Ptbpz/iBQEGmF1fH+MQoSrlIGVNDRbDvWXwKj0ts4yM5U3mMB5sO+VaJ2rVCghJIHZ1P7gks+KGkRqBn2+RTS9uZTxgs3cZwEiCX9jZCHyFyGJOuR//GWdtftrusSrZyZuioQuedd9QSQ/zsRru6SqBcv+p+k1y4aMAIJ/icEvozi+6JICqENUPR27vWEttvTkKKwIlO5PCNpMFXlBz3cuXipapRdrkgvy7AVNteSENBdM9aBDSX7P4jeHjCyqHBLurrN+9ZnY683UCpfqa9e3oHvvm0jEJZz8WitqOEOKSgrg6zmbwHL/oIezu1vfWGMcenPUh8T7geL/hH7fgojWdLzYXoyI3RboMs9eyN639s1zABV/hzLAJ8qbSBaoHFreLjfcsEZlw1FrDoQJmi4Qu50K6Guq/zd0xB7UajRADEhP8M1+gtpWo73xDrJQAbYV60Qf6KiWIwM13PiTFaX/ASEnLz04EjnfguvU8NcLhsK/uT5y14Cp8dENAG8aURygGoSKNU4XHVP5SG/Fl2mIB0g4Ko7V2Sj3uxcf00oyF2HR0iu1ZvQ9wJTg1OQ5AF9TykdWbtRQ4uUQmpZfTzOBrjy3qODar7pUzwSsICfz0KDbBQd4mXLEBcyAJrYHcFr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(6666004)(316002)(6486002)(7416002)(966005)(26005)(38100700002)(38350700002)(16526019)(186003)(103116003)(4326008)(83380400001)(956004)(478600001)(5660300002)(7696005)(52116002)(2906002)(2616005)(66946007)(4744005)(8676002)(86362001)(8936002)(36756003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akRvOGRrRTlseTQxbStyUFVsY2YxVnpiUm10NlNZQURnNXVuelBCMGh1bllK?=
 =?utf-8?B?b2xoamdJeTZGWUdUeGRuWFBUVEZhMHJGZ2RFeG1LdVpLNTU4TVJlcm1FNWtY?=
 =?utf-8?B?RzBOc0RLRUc4VmdieWMxalA0TTh1R0lzRGU2Q3g1K0ZySlR0aUtCanIyV3RZ?=
 =?utf-8?B?cCtIUnlnaTBNOWhieTRLeGVERGpySTdxN3dHc0VEYThlOUtQc3VUakJkeUlF?=
 =?utf-8?B?VGxtdS9vYlAyME9HM2JaOVc3bWFhRXNNTk1kS2FGcFJhcEkwb05WRXV5bXMx?=
 =?utf-8?B?WWJBcDZwZW5Ra0xQMHcyL284anNtbkROUm9DOWFaRXN1c1BGaTlidmVKck9B?=
 =?utf-8?B?Wk5mYStDbTQ4TG00OEhmcGRieEsxOU5SK056SHo5TzRUZ1BHZndEWkpFUFcx?=
 =?utf-8?B?ZFBxK2Q1SndYS3BxK0ZaZmxMQ3gwRXpPWjJXNHNpMmV0dmtyNWQ0dTVkZ3RD?=
 =?utf-8?B?V2xaOXJsWm9jZTN3UFd1UURubjFoZFl0N2RvcDcxSkhGZzk5MDJDZlVaRWZU?=
 =?utf-8?B?eUhISHlYcWkwL2dMaG5SSWZTanVNcndpd3Y3U0o0Z08yMEpkRnpKUUNDMThT?=
 =?utf-8?B?MERvT0l0QzN2dlJCWWZBNHRpQ3FmMDdLU2ZSUlRaMW0zNk8vSVM3dkZsVDU4?=
 =?utf-8?B?VUhrSEpmMDVTTkxkMDlZb3Jja2xhaE1nU04zcGx6Y05HbW1qdG91dGttVGhQ?=
 =?utf-8?B?dTR5ZzMrL3dWTE9hZ0k4OHMvVFRZRDJVaVdqK0UrcVhSalJycjFERWJuMmxG?=
 =?utf-8?B?cTFsUUtuaU9sRGVtdVc3cm5qMmU5ZDRBTWRKZks2dVoxOFdkNmk4Rk1KMzAr?=
 =?utf-8?B?WUlYc2VNcFdWV09YeGZTTFFJTTd0STdMVDFWMUQvc1ZYTUlVWjJVenRZMjZG?=
 =?utf-8?B?M2s5a0NxNEZCcTZsMFA4eUZLT2RQMUNKNXpWbENHOVB5OFRxQmtkUWNDWlRC?=
 =?utf-8?B?SithQlF2dDdiZDNiZlV4NjVqNGJuNGZjUXlkZXBybWxFSkxlZ1luYTQ0dXJ0?=
 =?utf-8?B?bVNmZGNvdWowWmZMaElzTTAwdklKbExlVWZXRXZqWVkyUmdnbGRTTFdzQkhJ?=
 =?utf-8?B?NGpwUTdNQSsvNzh3RnVXeE5mV1gwUDlkK1k3VXNHVVZYclZrMWRjcmhHWWo1?=
 =?utf-8?B?MnVRWEZpdmM2bDdzOFZXZ0VtdnhTblFnaEo2Z1RFTkFMRFNBUys2VHhUZUQv?=
 =?utf-8?B?aHA2U2pXa0JlK2Y1M2doSFBpdUFKQVdtK1hzRmtuTXdKOWlaSC8yWHUzR1lH?=
 =?utf-8?B?UGVjYk8xS0FQY05ubHJjaHJBUHhMbTRuMGZNd1pYM3p5c1QvcCs5YmFyR2sw?=
 =?utf-8?B?SUJmMjhhQ2o5RDZtUVBvMWIzUFVDbmpxVDZNOUZDTU55YTRwbGNXMnNQSE8w?=
 =?utf-8?B?L2s2d1M5NWV2YjJIZFkyUkQzT2lSZktCYzFaN1pEZkowMU9FbHlNamtDZzN5?=
 =?utf-8?B?bHF4bTU3dUxwZG4vamZNTFNSdVdiMFN3OXRtL0NlRmdYckE4VnZpUHo0b3hr?=
 =?utf-8?B?VGJDVVZ0U3owVHVNdGgwZTU3d2JqUmgyc29XaGMwb0QzTXVqditrWm1uQlpa?=
 =?utf-8?B?bm1SVDZ5WlNPd3o5ell0VWpFb2N3eER0b2VxcHN3cnlDU3FWK2VENWkydHc5?=
 =?utf-8?B?QnB5K3ZwM2Y3cURrZG1Tb3lPV1dFL1dJdXI4VThCUG5IcUFJZXMwQnh1Tlhk?=
 =?utf-8?B?dFNJYnVlM2JMZDM0NU03SEVBazJYaS9lR29UaTFDaGhKNHlTdFl6aElzMW5M?=
 =?utf-8?Q?sI8XH3LoV1a+MQpyqpfAeWiCkpFsvgEqkah02qu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f838b979-7767-417e-c6c7-08d93ab3ce36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:18.5388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgeS63XIJMS1nIaonjU5Ln8DJVvjMgU10aa0R+7uWEU27fsqS+qQwih5WLsJNL9OyXPN6jZhw5nlW7NhkiKe4THJI6FYZ15ADRYH1ldY6pA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-ORIG-GUID: vWDB8Ac4DNRzM7kH2AvUxdZHhrmx-YOd
X-Proofpoint-GUID: vWDB8Ac4DNRzM7kH2AvUxdZHhrmx-YOd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 12 Jun 2021 09:18:34 +0200, Christophe JAILLET wrote:

> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.

Applied to 5.14/scsi-queue, thanks!

[1/2] scsi: be2iscsi: Fix an error handling path in 'beiscsi_dev_probe()'
      https://git.kernel.org/mkp/scsi/c/030e4138d11f
[2/2] scsi: be2iscsi: Fix some missing space in some messages (+some extra style issues)
      https://git.kernel.org/mkp/scsi/c/c7fa2c855e89

-- 
Martin K. Petersen	Oracle Linux Engineering
