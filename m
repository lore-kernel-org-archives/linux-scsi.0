Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026E5C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 22:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D756860C3F
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 22:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhEOWQ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 18:16:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbhEOWQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2021 18:16:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FMEu8B014724;
        Sat, 15 May 2021 22:14:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jno0BAYCKUT4mxkPb/aTRjpQ1UvKOpm6rYttYNfmQpw=;
 b=T24UdE7M8H5xT2RCCyDxKhrK8TpeOJuojHk5G9Bt3KM5xK4r6AM/nRBcPhtlwJ/G8ll/
 8SL0EIH3ieE9t3OExMXOVa/IdfadGKBMIsIqNJGmK3TxZIUnPo4nnXnTPNfHxAnQSMvs
 2qtz+MBmeBgBj0zZ80H3qZMvpFwu5lTW99+xYGuBbG3HVtOvXPtpJzLxPWJV8jG87MTb
 nPF07jcBu6oHLt2bOBGy35zrOfAx51CMLyW7xGAugqUmSdJi9XxRGOTPlVojBXxxy/F0
 s4h8af1diNwWkvs5Kmh/wdRLtu3oxtYnTw+g0kRWPg1ODHcQbGw32yLZQ8VgqkqFjOjA wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38j6xn8pny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 22:14:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FM6Y8B033122;
        Sat, 15 May 2021 22:14:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 38j5mjqnef-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 22:14:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnySyiep2j/oOE5gjzDuN0K+/bDYvpvbKckGB4N4A2YYGan7bZTEvIU+vh3GI5H/ph0WHtP/PAcbxj21kX99003q4LFXn2qMStAIdU1J4yK3mya6eeu4knud/nJvK0QyE4rOa7uqQIHuiwT0tknFSQUPLH7lDakPWYjzs+9pIaDWEWi+ct4KXyMXnjmr4noK1ql27eQZYBFjvVWyJvqV20P37hn3nwGKGcobFXDBakwiTY8t614VH2HBgFJ2TUGGCM4srYld5VR5UzTKeugZXGXAAN88Nvlgobt2cMI+sj1u1NzQzibqDAOLahfSxZI2x7vVvZsXH2Me0PgPExmlEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jno0BAYCKUT4mxkPb/aTRjpQ1UvKOpm6rYttYNfmQpw=;
 b=O17V6uVHBz8SHE40RYvF8QTsvsbUdf+nE+Qa+kLg0FQS9zwsG2JNz0KEXAibElTS9FIxLq/Vi0MdB4lwkAWnLjs67yGQg9nmELvgLk8rpDrMsw0SiahrLyLMwcB5JrjwsIrmf3shPEpdLpfG2JqvW4WjvWUv9qM7Y8HkWRIKHio5T/GYtu+WNZlWH9gCTi4hfEy2NbyoR6oG4FtXi3Eqcj3Ozpy9och2ScimsUfv1ucJrgZN2ChTSbgR0jweDBMFZ7QahsGtqMaSigno5+GETyhcsomRemya7Ni8AWpgtQWSjNDZRIsw/hZyAg6fYKjV3ytPfd5FHnD3QH+T84GO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jno0BAYCKUT4mxkPb/aTRjpQ1UvKOpm6rYttYNfmQpw=;
 b=h3sfqi+g6COcSVnpHnbCOlqQuaG+bzvmLY6g2ad7287+bZarBScZp/EgxhSTLzHECcKXByRFufB/P6WZ5cR+EC6YWtFocItQ+DXSJkE46JymgJtK/Ds0SYclndKjDs+B1cOb6K0nRh80T/TW/M6Jp+utM1VCxAJZw30K39dcxeI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4583.namprd10.prod.outlook.com (2603:10b6:510:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 22:14:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.031; Sat, 15 May 2021
 22:14:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, ajish.koshy@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Viswas.G@microchip.com, Vasanthalakshmi.Tharmarajan@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Ashokkumar.N@microchip.com, Ruksar.devadi@microchip.com
Subject: Re: [PATCH 1/1] pm80xx: fix drive missing during rmmod & insmod in loop.
Date:   Sat, 15 May 2021 18:14:40 -0400
Message-Id: <162111686571.18985.4561845975180043023.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505120103.24497-1-ajish.koshy@microchip.com>
References: <20210505120103.24497-1-ajish.koshy@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:805:de::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR05CA0011.namprd05.prod.outlook.com (2603:10b6:805:de::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 22:14:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78b788ab-4e55-46f5-968b-08d917eed8de
X-MS-TrafficTypeDiagnostic: PH0PR10MB4583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4583718EDF0A57D407BC365A8E2F9@PH0PR10MB4583.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TYzCymyNn4Yyk87n8tmkZRO0CXzlu3wG3mgdQuHcm9zQt6HSRpduy3iN4vpla8dRw1s1FbH2oWfE9rlGEz3cguC2zybMZwnoeTpAMy6/gEvNCZh/wxv6ukKJjoKkHXOhiiVsaYolG48WDn49k8BZzJ5G4geU7bAs/uGOIMmwZ7+3hfW4xgPt/Dwsy7JzZNNCDuGfcYyvJRBHMtjXO1M1/xtARMAPBWWmFDl+mcVnJykXCPN9nxCQSDBRGaLaDZ6NOxEbje3VLe1xZaNvv/HRekRMdb4GuSXJ/EUAzTmvV3Hs70Uap+jl7Fl2ZEXcqyZaSJaqIEcvf7HlZP17T3hpbaE1MmuZrdbJvT97NArOlpDCTIgf00Z4PzXRXvIdsh28B/nE7XaIJIgz/4Pks6dDsH9YteNHS4ti1M90lFGP04Y+PX6Oh8EO9uL8njjTCHyormkC18JPGCcMJy5C38iTGboh81V8QRJR0zeUEiP1KrFwDPEgGr1f/2o4PIfjxIQ7RK41Ob1K6BGKvxFIh0wYH+cCRHW3k6Rz6WDXJ9UJPmucARs82l17oSX1HS0K5tDMoC0kjne7hbZDNJwECSKCZpBlo5ZN8M7DhXkgB2zKcQMB14Du1Th/adpmq2M6luXYlpARdT7XhsQvOdfwKiuU+iKkUMI2VEHzXcVcgjAkR+zugiEYvvsQSwsjUUy/gWPphBaUwafZhnkNVHKYlIKFi1a8Fh+73DzQJqU8z1hEj69ilftLaTLQGkf3dO9H9BKb6nfjYiMO1PF/V8/sKlo0tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(136003)(346002)(366004)(8936002)(2906002)(478600001)(7696005)(66556008)(36756003)(966005)(66476007)(4744005)(8676002)(5660300002)(4326008)(38100700002)(54906003)(316002)(6666004)(956004)(2616005)(186003)(16526019)(66946007)(26005)(38350700002)(86362001)(6486002)(103116003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VTIrZG5kSDdSbDZnQ3FOQXA0UVJLbGlTRzdsV3Zmd28ySExxbU94M3FlWDF1?=
 =?utf-8?B?cHVIUjZqRDV5Y29pd1V4VU1pMnUrdnNkcUVaeS9TTTYzdmxnTmljdHAvZmVF?=
 =?utf-8?B?ZnhZaE5GRm55Skx0cDFGN1hWY3RiZ3BDbUd0YjM3ajAzb3hYNHJpbEtDZ2Z1?=
 =?utf-8?B?eE0rbW9vUHFuWTB5SERCZWM5SU5obThJcS84RVhXeVRSSWlUaDVrdytNaXhT?=
 =?utf-8?B?d1JFdE1sUFp5TkNzRDF2MGx0YTFYMXZTY2ZmL2U4SzhVZ0svZWJ5eG9COGgy?=
 =?utf-8?B?TlB3VG5EckpjcCt3bk5qWFVDMlczTmpmL1hKb0dyK1l4alpXQ2hWajRWQ1h0?=
 =?utf-8?B?VGxUc2NWMzREUFJFdXNzOGxFaHBOMllCRnNMZTU0SjIwVit5bytUcThkUzNU?=
 =?utf-8?B?TUFwMUVoSVJMR2w4dllHRE84cDZZZmd3dEZiWXNkT0dSUnFySnJLYWI0SnJq?=
 =?utf-8?B?NlFTdk5aQmRXOXhaUFNrNWVZVDl4ZjYxQWYrWThZd2FyVmdybVIvODYzU0hr?=
 =?utf-8?B?b0djbGZubFdVT2dLWGdyTEVQU1lzQkpRQlE1cG1zNmpTTVVoM2FRTjhJcGdO?=
 =?utf-8?B?NHV4Yktqdm9zZXN5NFg2djZWMHNWMDhrWUpxN3pUUWY5bXhrTkdEVm5wVWRo?=
 =?utf-8?B?Q0x2RmJ2K1VEWXkwOHVHMGdNRDl3MjAydnpqQVlPaFIrQzFBQ0JFb1dVbjZD?=
 =?utf-8?B?U1BNYkRuN21ET0hRaUhCT0ZlUXI4OGI5SmZaQUpjQ1lsQmh6dGx4YlBVcnEz?=
 =?utf-8?B?MGdTLzdiUFM4ejR6ZzgwaWlXdlRvRUpaeEdCM1ovSnR2ZjdxOHJNRmdMNFVp?=
 =?utf-8?B?dXRQUmpPbWJ6T0xGSVRUaFF5dmNxY0tVelppZk5QRm9WV0ozYlVKMzBOS1NX?=
 =?utf-8?B?a3VLK05aM1JJeTl4S3l5THBwZENhQk5YRG9LSDgxVm1qKzk2dGRhOHBYRHhV?=
 =?utf-8?B?eGs2MkZ0NXVxdUMxdkJmMnNUZkpkTEZKZmp0aGhxYit6U0Y3ajU4cWMzYjJp?=
 =?utf-8?B?RWw1UzAxYzZxOWxRL0hzMFRNNTVzbkZvb3l6bkJEQjA4b0o4NEZnazA0UW5z?=
 =?utf-8?B?OTI0dERKY0NLVU9tYk1RaWliSlBlRVdMdzY2QjREdTlPdCtyMUZkdDV1WE0y?=
 =?utf-8?B?RnhQQk5CNXZobDZQd2YxMWNvQXlqVTVpQVN1VEo2azlFSHdiNVNFSDNSbVdQ?=
 =?utf-8?B?cUN4MFNDYmZBRkcrbkdKeGxVaXV6U3F4bWZja0prTnFxYTVXKzVkaTFQaWZn?=
 =?utf-8?B?MkY1UlhCdjFaVklvU3oxNUx2ak9nZmVKRWx3Nnh2S3ZSMmFiRmR4ajRueWt5?=
 =?utf-8?B?SUJmTFh3MERFS0gwNyswMUExYzNhbnpyTXZQVmUvS3V3ZTBCZkFnSzVnWTB5?=
 =?utf-8?B?TDNIU0kwMi8rQXhlc1JKUjZrY3R3c2ExaWpHa2tJM3FTQy8xaXNLbE1Cc25N?=
 =?utf-8?B?Yi9Vck10VGNzdmZlblRsNHJveFJIRCtDRjQ0SnY3dlU0S1FLV2JDRER3blo1?=
 =?utf-8?B?S0VpWXRiSjE1bWNZNkcrc1JXR2g1T1V1YlF4RlVETkpjUTdSN3pRME1DeWhQ?=
 =?utf-8?B?WDhHZGlhbEpBOGkvWUxlbEt4UWFPN20ydmY1ZEJHSGFmV1YvdkF2T1NuVHhj?=
 =?utf-8?B?YWM4K2JKUHhwWElYa2lQdVFLRTZaWGVQTnZCMzFGbEVlVEtjL2ErS3N0LzBv?=
 =?utf-8?B?TlF1ZUpMK2hrNFJMS2NjNFg3a3I2djMzdEhjUnNlUjBIODZDdmxGVFQ5MEFZ?=
 =?utf-8?Q?+3ZjPkMWTUIjdhXYbsaKD8QTdSxPWX76iW5vgfS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b788ab-4e55-46f5-968b-08d917eed8de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 22:14:45.9330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4531a+KnURf1h2kpt6Wbw28shL9Pv4mHDv24k8ia7BU3caF82WeX9C4ID6mNQeWr4Ec9jQ9mYvJOyZqP5yKl1uiPhXCVhK1cL+Wlh6Ib3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4583
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=979
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150169
X-Proofpoint-GUID: ki24IjiuPJ3GxSSfmf8URb-60jUiXwlw
X-Proofpoint-ORIG-GUID: ki24IjiuPJ3GxSSfmf8URb-60jUiXwlw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150170
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 5 May 2021 17:31:03 +0530, ajish.koshy@microchip.com wrote:

> Most of the time when driver is loaded after rmmod, during drive
> discovery few drives are not showing up in lsscsi command. Here
> sata drives are directly attached to the controller connected phys.
> During device discovery, following identify command (qc timeout
> (cmd 0xec)) is getting timedout during revalidation. This will trigger
> abort from host side and controller successfully aborts the command
> and returns success. Post this successful abort response ATA library
> decides to mark the disk as NODEV.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] pm80xx: fix drive missing during rmmod & insmod in loop.
      https://git.kernel.org/mkp/scsi/c/d1acd81bd6eb

-- 
Martin K. Petersen	Oracle Linux Engineering
