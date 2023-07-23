Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FB3C001DE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 20:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjGWUI5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 16:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjGWUI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 16:08:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DD7E43
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 13:08:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NJaZIj007731;
        Sun, 23 Jul 2023 20:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=lYlAf4A0iROLnHDES+plbW39osSDT3oQ1JnFbXUM22A=;
 b=VvHA0ZRoxXfyyeuAryilATMw1kcTNIJeSX8jmcn/lE+TG0K+wxR7NJ7K9zmHYv1cstJU
 FB7xWdE2Pkff+iPfPTwlpwaLP73Dkh53rUnKAuTDH3CuSB0ZAaSrLV1kayowcrfX/fqw
 sPONudiywQV3Gt92GlKsKeVgu7q1otANffnakJzsBHU9ByvGanP+MzMB2VP39ppXEs6F
 V227Qpxqc1uHnjFuVmm5aoSt19V9HUfGHokzRp7fdze9mTtVBEllbKFDFIRXUDVG4lDW
 SILFV0glI95IoDs4I1pGAi6bxD4pJu68QY+DJd5UwLQI75cIF5QxozEKB1FdWn0WWPjS PQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s06qtsgaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 20:08:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36NK1LYj029100;
        Sun, 23 Jul 2023 20:08:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j8xr7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 20:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOwwf+ulGz7jHjUgM/HrrJhl7fMm1aqD9QgPB1+inBVu+kmcK65LmMSRKSXPhmGPi7CuKz8gVi7UZsFdfSc9WyW6bJUK87aui6Xu8Y/U3EQWZvGJtp7cFDkHjYQu48iOycB70Tg9M86xrwv4ZCU73gM4PtGLrvLrqnHRXf2xn23Tfc9IV6v1tZXmxLuWS3H/oAz/jPety9qH4oFl4xtX5VSQRVt2JS947GKO0ChKykVwqtT0jbTz3g2YvFd/Wz6Y8xpK6I7JDaemQMWrUv28wMm8GEKhN2N6a0p0qJxsQPKgVj7u9g1cZwlffXn2vlqd9eyhOi+mh7y6OVThn8RlEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYlAf4A0iROLnHDES+plbW39osSDT3oQ1JnFbXUM22A=;
 b=fKkudsOVqCW3co3ntxm4N+KT3or0nZhirorSWmDkpPldlKqyjG1OmkOY2XM4wjBTrP2ZbYPEw6/SlfpDine5kGdPo/vOzg/ls91HmnpTKOqfzs9GrJUoGSa07UQTt8RGpya9dYjljYNG+P/4pxHeENOlShSJtojp2vshh2NUuO2jXBQBgaXFyrbgdnF5xgDB0i4b0Jx3NaCww4j++HbSToZ2zyY4okfnTLH1CD9zl9YlEAn6DlbPuHz37B87Ez9WXfdSVaC3veS/zTPqHeLCrH6E1TRMsw2o7p3+PUXuue4Qfcq0jeSX3oj3KGJ/0INP4Fr8/va/iSGbgr6uDjzN4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYlAf4A0iROLnHDES+plbW39osSDT3oQ1JnFbXUM22A=;
 b=wHODeIMpksrJGvM31qgCWsjJufgbuo3kHjeui0lznj5Vobe3PCylRj2pAhoMYVWPFi6TTe6kwiz3nNLiFs3VMyMzOuE97fHAtk8c/KSwUNJTrTCbC0mi/pxHDjjeEwFdVFw6jBYojxDbw1UG8EVlCXmOkoqxw52n6PAylRIiO8s=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CH2PR10MB4232.namprd10.prod.outlook.com (2603:10b6:610:a4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Sun, 23 Jul
 2023 20:08:48 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536%7]) with mapi id 15.20.6609.030; Sun, 23 Jul 2023
 20:08:48 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
        chandrakanth.patil@broadcom.com
Subject: Re: [PATCH 4/6] mpi3mr: WriteSame implementation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1351e5rau.fsf@ca-mkp.ca.oracle.com>
References: <20230712115955.6312-1-ranjan.kumar@broadcom.com>
        <20230712115955.6312-5-ranjan.kumar@broadcom.com>
Date:   Sun, 23 Jul 2023 16:08:47 -0400
In-Reply-To: <20230712115955.6312-5-ranjan.kumar@broadcom.com> (Ranjan Kumar's
        message of "Wed, 12 Jul 2023 17:29:53 +0530")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: DM6PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:5:15b::27) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|CH2PR10MB4232:EE_
X-MS-Office365-Filtering-Correlation-Id: dcf95d7f-3f16-4cb2-7dec-08db8bb8a094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMhfp/LFyz3F7jOfJ5KA1NVhUCRbiqRR0C5KcHMwFvyI6UtlunFD1pZcAh9H+DMbIuc2mOq63LFGG4nkLFxEFCCYtBAOtP59tgNRPqLAsVzpa5jNhaXQg3SkH4uE/XzJO7yi5Ik+ksZ/OvCpT7JEzh3Iiaz5EOrP0FIMvfx7Ly3C4QFedTndRzIXG3UngvQaIqd1nsHZqMvo1bNODGPGmk41OgsJk93lmV0aByuaxPkbyu9l3yJmfk/fmh0vNQRs4tKBtdnir/+Kv3Vpmhgkgd5bkHcMZ31BniXXYejQv1L92Q1SsZJWv/vL5+LqT1d2k7MzgvZclwYStloUkS1DGnVNlfCKRuPDmIrqbHoeA2RIEsdITy2NxQBRbUwoDGta3WuQy+oeiRnSQS7FWBDm8dLquymya5bs+Ag76sivLPk9KudJ1raL3IrAIAEPliJwT8dDqgN+Bw87kdytAaGvYIIANmiAhwgBN8U414kL4NpCwFRZkaeZgHThqOJTzgWQ/CM3MgkOhHI/kV8J24WSUpGaJQpnNSniH16YQebpnjOgFYgfLGXcq4VGISiZd2ctdc8MWvhEuhFvnB0Dla41aCkj/u46/gy8IyeZmmt6Aas=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199021)(38100700002)(6916009)(83380400001)(8936002)(8676002)(5660300002)(478600001)(316002)(66556008)(66476007)(4326008)(66946007)(41300700001)(26005)(186003)(6506007)(6486002)(6512007)(36916002)(4744005)(2906002)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnZJQUVUZnNVT0RHdkxiQ01XblNhVC9mSStnRmlOMXZtTFFobkdSYlhrVlJq?=
 =?utf-8?B?UXJuVnJzNXZ2TGJjcyt1MzNFRytITHplRzcwQkYvQ2FkTFFZUWg1QndqK0hX?=
 =?utf-8?B?NlJBd1p2SWZQaEhSanVrOUJ0SkZPbGk4b01qNnRIb1EwN0FxeG1xNXlxRyta?=
 =?utf-8?B?Szl3Z0FCV2x3dmYwVGU5aTRYS0NMQmlxbVdkTVJLaTFvY3dESzdySU9DWTlK?=
 =?utf-8?B?ZExhbHVyZFppSGZ2bW0xbnl3Rk5uOXBqczBnNzA1T28rMHdUQ1NsbTEzUWF4?=
 =?utf-8?B?OGFVT0d4Y1JtNDdZdXBMVTUvWjRsV0pMNkxrV2hpeXJseEMzdVFzbHYwRVpR?=
 =?utf-8?B?eTR4MHpGZWJDMjBBMWxsdU1HZThyMDN4cjcxZkxyYURDa3VJbGY1RnBuZ1hF?=
 =?utf-8?B?eXdVZFZyUVdhSHY4K0I1b0JmMitGNkpXSHhWUjJsczFkWXJNYUErSFcydU1Z?=
 =?utf-8?B?TzYyZUFyMDdvR3FLayttM1NCM1VLV0VTbU9GOW41bit5cjBNczMrK21Hcll0?=
 =?utf-8?B?RWpya1VJT2F0VzlsbFlFdjZUWkNjbFd4WS9EWjljR0s0YXp2eVlXc05CaGxG?=
 =?utf-8?B?ZFZtU2R3RGt2MmVtR3krcURUNGZ5eElEdlk3Z2JpMXBrYllLZUFQWDVTVUxq?=
 =?utf-8?B?cDBodlBtaTlpS3BlM3RhenZISU55bGlnRko2WktlVG9PVGlra3BLK01KZ0Zo?=
 =?utf-8?B?dnBZVWlkYUdQUEMzNGJxeEh3ZDViVWhoVzBxNzdwa2Y5Sk5ydld1QndKbVNH?=
 =?utf-8?B?bkRKZWV2SzlSbnFPeGdUUHpkcFZCT2dQSDhqdHRiYnZUTUsrVkhwcDYvRUZx?=
 =?utf-8?B?c3FKYXIrdERKMU1FazduTG9UcjY0SktVNnhKK0hEd2VSLzlNdDRPcVBXNXJj?=
 =?utf-8?B?YVUzblBFWG8rUlZRNmFxOEdNVzErWHMybGcxVnplbFYvbW9kQTM5UDlKNFJF?=
 =?utf-8?B?WTZ4Uzh1czExdVZYbEIyb09XRFF1OGJMMXljaFJxbjlxeDlHRUN4SDZvZXU4?=
 =?utf-8?B?NjhBMzdiallBRkJ6TWIrNWN1YVFyckk3eEtBb1lkNmNCaWQzYVRGaUJGZHpG?=
 =?utf-8?B?TlhZVW92UlFKaWVtS1ZYak1SbzlNMFQ5d1RBN1pUNmU0dEZoamc3VnNKaFBB?=
 =?utf-8?B?WGl6eWs4TEFCdjlRNS9OZzZqK2l5dFExRlIrQUtOSHhnRk55ejZENE9qS3BZ?=
 =?utf-8?B?cE1UMjdVSmVXa25EVFhnYkZmWElTK29lYXJENElCNk1NNjNhQTFrN0o0bi9r?=
 =?utf-8?B?eGxHZmdyRVZqeDcrdExXR0lrUXhvUlk2TVJxbXdtdWNBcGZoZnBieVAvTWhi?=
 =?utf-8?B?SmkyTUtEeWxqcTV4dkJBWmJvZnZaRHJDZFRqdjhXTTRKdHE5MWdtR3VTNzhT?=
 =?utf-8?B?N3hRckxzTGR3Mm9KaHhJS0pwZE9sTldxaHZWdStaVFFrNkNKVWtDVzNVTWda?=
 =?utf-8?B?WG9jc2tjS0xza2d3RE5TOE9OQW5lVUQ1WEpYRVo4MFpKa1JMeU5kZVZiQ09t?=
 =?utf-8?B?LzgybFhxbTgyQ01GL1pmdGFqZkkwektiRDVMMTlxK2xkSHVqZCtnRXpxMTdp?=
 =?utf-8?B?L1FSWlNnSmFNb1dOZS9wRXk0aGF5eU9NNWlSSTRGUkFjSXpYQ2orWld1S1Zt?=
 =?utf-8?B?OC9jalczT1hrb1FsS0htazhuQ3c3ejRESng5bEdyNEZhYnB2djkrR1NBRUVz?=
 =?utf-8?B?NEM4MDNzRGxCSGJJMjcvUlc4emJTOC9WclFWdW5UVXFNTDAzS2FWZzkwRnc2?=
 =?utf-8?B?cXR1Q0RQOGdmWE1Sa250T29sQ2pQSXVYZDV1SjFRT29XMjR5TW1Ha1BjSTdP?=
 =?utf-8?B?MStjdE5INjV2TFZOTDUzQzFGQWhJZm9jVDJPb1hLamt5YXpIbkw1TmtBdVFC?=
 =?utf-8?B?OXVBNWJad05abkc2M2hEbkxVT0V0VHZuZ011OGJLanFRMjlYMVdYdmpnZnNO?=
 =?utf-8?B?Z0FKMlBHMVl4SzdRNlh6WHQrZU43dU9Sc2pLZzJGOFJlcklKY1QyRzczSjkw?=
 =?utf-8?B?LzhJajFUd1ZKTmxRWmNKWTBzcWpxbmQvYVNYVkErNklDZmtoWHJaRG03K2Jz?=
 =?utf-8?B?ZHQ4TC9yYS9rek1HUmxkN2phdEdSY3dUNUxvbGphTlAyRVFkSHk3NFcwNGdH?=
 =?utf-8?B?V3VaSlBDVGVOVnczaTBFeXVlQTNhbTNyV3Y2UzNnbXlFcy9QaW9WSlJKc2xT?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gdtcBBzD189FeCxmNZYUTap5Ou3IL5zJwWiDmdDpfOudYiN8t5bgbhEe6RG2HCEt7jZ0QX+hLLillhlW/TvgUvnvYhLvl7IJaCIsY2+74Y/Pchmb2uK3T3twqhkGE6gSyV9+gjRWi++BgXVK5q8wR4CVLs55bw09oFuY6/n/YgfKFW+6487DL9H9o/fetAUpjxzTIOzsdS45JtLw4QT16uDVGIZSumRmwkVY4OvoDxnozEvCdzEQnrlnbOixtumsCAGVSabWQa3DCcQTegaGn0IOmIt31LQOGsls+G8+aH5i6fRn4ERl0jaaQ/pDR+zKgvrdLAVuNQBUukt7Oe4rJc4HsAL2rtMj/fWq/VRPqBl28sNA2L5U6U4n1L6ufPMkrH4U7xF29dvpgbSCjReO0ErA7pr4aPoViV3Ku96htiPnuI/iyWvj+Y52QWjscuSJw3UjrX2mXDmT3C7PunFs3raZ26XmcYOPDWFppRQusrj/nxu1s9KxSB4SuESbitg0HmAr2bGfzxTmL4UvIJg5IffuAp6fqumE2j2x+GBSE7qQuvEmNJPzoMK7n8CuVhxuNt07lHSo20wO5MRUIVxtjfv8KLtq9L+uOZhhGYOwvp6zGanLsht1R8NjhV6toxwpuwYGDPm6ZU16Ra5TI9EA3P7nGlhogKSg48cNWnHKkIQhpvmIeuM5+kQ/aT2uUYtIYOquPh+Pm9J/C0fAGrLQ+mQrbLWIZqqdZAh5fJB+hKEalvYIMLtHNl7UuExljG3ZvUBVrweQyFDWul1+ltqBvpI/Ncn8eYiJ2QiZR5bChjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf95d7f-3f16-4cb2-7dec-08db8bb8a094
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2023 20:08:48.8758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9aGR2e6rMkP7mvor9vr0BtxhrN9c5cuLylOn7wwPywbGMRh774kI2a3drFHJpfTclxDA1udS7m/hZIwUXekJZwpVwYCkKt8Oe+gaDfHgck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4232
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-23_08,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307230189
X-Proofpoint-ORIG-GUID: 05yTz2VImUXTSB6xmtTcFDv6mIvRlDY7
X-Proofpoint-GUID: 05yTz2VImUXTSB6xmtTcFDv6mIvRlDY7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan,

> The driver is enhanced to divert the writesame commands that
> are issued with unmap=3D1 and NDOB=3D1 and with the transfer length
> greater than the max writesame length specified by the firmware
> for the particular drive to the firmware.

drivers/scsi/mpi3mr/mpi3mr_os.c: In function =E2=80=98mpi3mr_target_alloc=
=E2=80=99:
drivers/scsi/mpi3mr/mpi3mr_os.c:4527:17: error: this =E2=80=98if=E2=80=99 c=
lause does not guard... [-Werror=3Dmisleading-indentation]
 4527 |                 if ((tgt_dev->dev_type =3D=3D MPI3_DEVICE_DEVFORM_P=
CIE) &&
      |                 ^~
drivers/scsi/mpi3mr/mpi3mr_os.c:4535:25: note: ...this statement, but the l=
atter is misleadingly indented as if it were guarded by the =E2=80=98if=E2=
=80=99
 4535 |                         scsi_tgt_priv_data->io_throttle_enabled =3D=
 tgt_dev->io_throttle_enabled;
      |                         ^~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

--=20
Martin K. Petersen	Oracle Linux Engineering
