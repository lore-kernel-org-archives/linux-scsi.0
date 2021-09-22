Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4A3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B18CE611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhIVEqe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:46:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64260 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhIVEqd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:33 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1nCZV013119;
        Wed, 22 Sep 2021 04:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BtC2NF02esGBg4tNlX/CC+TSWsNEM8exH9H8Krb+DEQ=;
 b=dJy/+gg8tx0FzhwWg9Iz9Rx64ITKgarDgGwHs/EL4s5QjFKdJxwaRjitTk3sJzMnQ/RV
 0P8J32SOB4NGzO/5+OJpAOprGOTGBepkK8UrgC/haVH56/4MoEu1rrt1OyxsIByUc0Xt
 L2dQHAA7ESqUWM7qjV/M8ErSymM9zRB5svMY7V3bhddjDpBzPgLGO184taY0QpLeJmb0
 OnSN4MoBxqRf/m+DdfAcrBxB+cPXAk0gxvA1ynzXW0pnoJRRA58ZPxNjxoLmpeYRPOmf
 TTdsJoqqWlFHNzJz5WMxUrsz2pJAsEvkT661f14xrNHWFLopcuq08tToku0uxuORVXmJ wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4qhc6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4iwBo195776;
        Wed, 22 Sep 2021 04:45:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3b7q5bks3v-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0h2Pm7iBRPll33c7dllmLI31C1BC6qgvXWimOS+m2dmNVtio2C/aEVerACw2x9S1MPI6+MGu04zQ0HILfKcJzxRxBvgHx5aZsqD4zIQ4TTtchsShy9tLADW14let99YfdCJ9zGkT/c4FK3zXRYEVwg70BnChGKQFloQXwsS8P10HISwbvbaCzXT8TMTCNojUW+sRG5nlEaaw6dqMW2r/93AAEDr/dXeBeew/dhvwCwSmRyPtjwRd2wIKITUaMAvNNof+NO/Pb5PlmjUmpXiSEjmVsJEMtYLtkWA7JEF4jl9CRZcbbH/V9ibeD/Up2GBcD2DS5BIwk+gRV2ZaUWMVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BtC2NF02esGBg4tNlX/CC+TSWsNEM8exH9H8Krb+DEQ=;
 b=dTDtj7dbJqrnRIx/xnnOeBfOWXpUONeHwM+hOourT5WnKuDEG5vnK+cV1oqcPgpfQi9+iw9PmQk/H577pOeRTYAAPptlsJfziN03mZRClNy1CaZxdeWq6ks04TF367av+PT27q827+x1FLCwSrDNwYlUoFU2DZvRwWuZOkI4B+1W41dzoXSe4caOtS7gnhVfT1ncTZTgW21bN6mmFXieN94mRIGwIuAP1hk77Wsqes7spXHtLHJI0dcIwhUkLRStHinuawcSn6Ah/mOTOAdfkSg0BfMBjSt2o3GPSgXnKasW1ujLrG9U6rVVC3vEKoF7+Vy2aLviwJMki4tLZWBmeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtC2NF02esGBg4tNlX/CC+TSWsNEM8exH9H8Krb+DEQ=;
 b=DucRzCd0cxxmUX704kQbhGEDnNJx+76T7c6gX3sloPda0bdEQMsDaRJlho8FaXc6GpbacW6WTiFFgxEPvyyVilWyX6/5SnR4CKntcODLhLFUceLjpDJIlOdDBhKGUPRaeNCZs05IQR6QezAGgHgtctj9482Q5iMJO2ctY0W1QTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:45:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux@yadro.com
Subject: Re: [PATCH] scsi: qla2xxx: restore initiator in dual mode
Date:   Wed, 22 Sep 2021 00:44:48 -0400
Message-Id: <163228551952.26896.3309603371017614729.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210915153239.8035-1-d.bogdanov@yadro.com>
References: <20210915153239.8035-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:45:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cded86d-289d-496c-7cf1-08d97d83bcc2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB451865A0F265352576C556FC8EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/t0rZP29j+lJOtW4HFyPcpWN7PnGxO1xFt/FLjjN9SiWFIVWKPRF/7ATQAHKdiQnQGw5UNtpb2O6SO34qQE6DgR3+Yram0c4L6MnyaUwRlW1MIVkBBVowvDmAemY7Z8NyOg3nOEuXXE6TeUqcy6EaviUy9UZRet/oyODNErotpfPqf8WfUGC7Epc2k/U+yrE0BcDczSNPgzMq5jVhto1FqxASVqytV8q42kaZDqKIHyXwoMSuDgcpRRTPtdj6NQL2CWrOxUHr2thvc+SPs0WwHQzvhwMZ4pUo6B7+YmPbCO6FOa7XOc+cbDWMQNwDiJeA73Bl74BdH8Hj56MjxJblFcvu1JAu7CkphPFUF/YBoT8vlJxgGcvRu+mE6XNvPihQUutp7eXbcHzgOj4Fq8Uqg3yVuT2xg7Sa1maGDZMvPhb6uifG6CR220/biQo/FUpkbGwRbhVR05VO+5zzphu3JzqWrsE6tZKgAXrepZqDAmyvRW40MxD+hqx8pTzXNhyyTohrLoeebJhONnLURvc4GdQ5nvNqxu7Dh0/Z7wPKVTrDoemH7OyMGNXseD11gDhXB9KQZbzk4dFQUsoKwi5tsNu2lvogDTP3S10iffLfJgL0HhteiE8RyjwtMiWj1JFpgmw4pX7URWDbCxwW+xryeqJBwA3sXOms6oyxqdaei5h2OmbjcZ7CdxbFDQ5ClaHBK9YPDR1x8kz+P4d2eyaup7Izlf/ucetkMtVhmhuDLf72dg29UQ2/oeLJjIzuAL0z9KVYPBYUvZdTukl/fFtuGk08130wj7STNplzgtyog=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(2906002)(86362001)(66476007)(83380400001)(6916009)(38100700002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(54906003)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVJ2VGtoUkQ0b0cyMC9HU0p1Vk1sdTlUancySFFoNFRRRnYzZ2xVUFJKZE9t?=
 =?utf-8?B?Z1ZYSlUxMUJablMvUGUvR09zYVYvMEpHN29sTnlOMDVhcm1mZFlJWFRXUHJs?=
 =?utf-8?B?Tlc1bTR0RUoxem4xMUFLU0duaSs1NFZVRXI2MndVN1g1ZVFMdWFHYXhkS0Er?=
 =?utf-8?B?ZTI4VW5IQzRkSERScW00b0JVQkNBZ056R0lLS3Z6S2lRWUlQc1M4M0JyV2d2?=
 =?utf-8?B?Ry9aQUdxZVdVR2FkbXROdGFaQTk3eXVDd1lhQlA0R1doaWNsVUk5V3IvRWxQ?=
 =?utf-8?B?RkJ0TFpWVHUzRFBiSUxRSnhtT1pJZ2p5OUljR290RjFMN3Z6U2I1OG5ib1Vj?=
 =?utf-8?B?bC9hQkRRYUtIZnhhUzNMWlFUM3YvUlMyN2VyV29FYVRpK1ZVR3prQXJMM05P?=
 =?utf-8?B?QVA4MlN2UkZBODNTU2EranRWMlR3LzVRdERyaG1NdWt3RGNXbjc0UHAwY01R?=
 =?utf-8?B?ek1QQjRUUlc5SXJ0SHFjcDlJUE93WXlvbFR1blh0SzNGZ0I4dnJLTFFIUEZN?=
 =?utf-8?B?OUlXc2pKeWNsSHlodGJIK1J0aUk5bmlCbC9oR2J2RGF0SmZoRjJiQkJ3MGI4?=
 =?utf-8?B?RXRiSHJOUzREaStSdHJjbDZ4NHhOTWd4S0lkZHd6UmhTOWVHRjZEWml3TGdz?=
 =?utf-8?B?eHdkb1NNL2pRRVFNbmVqbm5QVjNUOE9mTFlmRkF1cFM1bm9SMFE0QUtYZlJN?=
 =?utf-8?B?YmdYZU80Wkl1czJPQjBVY25KSzdKY1RJMEcxMkhSODFLZW9ZaHY1dDk3cWw3?=
 =?utf-8?B?TUVwY2RTTzAxbVJGdkhhRTFJeFdSRHBCZlF5dm1tZFIxcnc1cFhrNmE2aFpi?=
 =?utf-8?B?QTFkMVR3SkZXVG9jVlhpTWxxcktpOFNYMUtobnNjZnFoQnZUYUdQOGdPdzFx?=
 =?utf-8?B?QlQ3ZGRLMnlQV2hCcXZYUEVBNFI3NHg5cnM3b2kvZXpKZ3JsMys3aFNnOUlK?=
 =?utf-8?B?bC9VeXFqT1hRZnU4YkJ5SFdEU3NjMUxCM01xQjNhSFlGUUxVaVJMUWJHSnJC?=
 =?utf-8?B?NTlleit2ano3VFI2ZHhkclVMOHpiMURRa1hhUlIwKzgrUEFtUWlwRHpsbGVy?=
 =?utf-8?B?T201OXFJMWZsWmpJam0yVXozS3hxb1ZBV3pOc1QzVEZRZExkeS9zVGtzRmY1?=
 =?utf-8?B?N01CWk1DbE9YSDVQMG5MRzRhYSsyZ1BVVFFlQ01CK3k3d3JnaitRQ1FsZldS?=
 =?utf-8?B?NzhnS3FoS2NwRDVieDJEcGY2RDFtWlhWbVkydk8yNktIanVmeG9zckNMY3pS?=
 =?utf-8?B?YUtEcW5jUDBFbCtNSS81aitQd2pJMjZUTnVDMDl6azN4b3FuQ2VMNjl1UWxk?=
 =?utf-8?B?anFPTnpLS2wwTjVMczdyOVBqSjBxZzE2dUhzQlQ3dTVtNTYzYVdFcDNLMTBr?=
 =?utf-8?B?R0Fjck5LQ2ViMGN2Rmx5WHA1Ui81Rk01bU5KTUhrVHBzT3ZjcTF2UnVMR0Ev?=
 =?utf-8?B?N09jRkJ6cGtxNU5tNm45NEhUTlZTcXE2T1grNHBjblllT09VN1ROZzFtdHVz?=
 =?utf-8?B?MysxVFpieE1IOW1rVEJIcGplVTl2czM2bmFoVVRLUWNnQWFWR0pZWmtxMzhC?=
 =?utf-8?B?Uk1IV1NFeFZpdzRXZy9BWkNJemxQdC9MWUtCNmduL2IrbWVzUndXZ3lmZGRE?=
 =?utf-8?B?VFFIWlhYSGd2Q01RbjJyaFBTcDh4K1I3VkVqaW5IaUVLUEdBbjZJUWN6Q0tP?=
 =?utf-8?B?elR2VThMTmJTbGZiUGJya2JCcmMxZmlrMndCWmJoY05CSWcyNWEyY1ozNy90?=
 =?utf-8?Q?XnFzXn8QAJPteNEAexOED2JdkCAilotXdO9cBzv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cded86d-289d-496c-7cf1-08d97d83bcc2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:01.2169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7rJv6hjNyb5kpOs6QzxmJWk1W5nUg9gucP2ZC6eivWt5Cr8g+YwzytMnPRZ0w22YGKZJyLBlbuS50OJJPa7l9s2hlj8vwI2bRCJqkYSsbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=836 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-ORIG-GUID: cXNNPOri-POVGyGTdhtCfS8Xo0zsJpMk
X-Proofpoint-GUID: cXNNPOri-POVGyGTdhtCfS8Xo0zsJpMk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Sep 2021 18:32:39 +0300, Dmitry Bogdanov wrote:

> In dual mode in case of disabling the target, the whole port goes offline
> and Initiator is turned off too.
> 
> This patch fixes restoring Initiator mode after disabling Target in dual mode.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: restore initiator in dual mode
      https://git.kernel.org/mkp/scsi/c/5f8579038842

-- 
Martin K. Petersen	Oracle Linux Engineering
