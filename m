Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E3DC49361
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 03:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B60FC611CD
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 03:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbhFSDjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 23:39:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58440 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232515AbhFSDjD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 23:39:03 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J3amb3006873;
        Sat, 19 Jun 2021 03:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JRE88r3w2+yBlQI2WsGHrHkBwSimAmtj74rvSybfTCU=;
 b=pERX7VWaXaY2I8kGdGVCxGQ3xx+Rlz9NaFtwho1tOlrLYEdhG//yQ0gjVS2MdAkC1uSg
 I22dZ1AaJYewBRPXUZvikZ/OD6MOyUxeXNWicDhhOLPjZ0VanqO5io7KMy714q4ZjcoA
 amdIhdZf2nJ5alLyPOQDJfu7OSBc1WgZexCWlhIJGAg7OK334lHWW/yG7TWoVEcjgWQX
 wp03HcSH2QKUlYSgThWdYs91DwDsQdPPSstpNv+frJiELjnTXRettgIne02E2iP5KAAr
 K+rqmr2iz2EafzdyOWdqygFum3OlwOJWwrzSW0vbQTI5+XI22yVlovZOzFcBMpuC9xA1 kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39976001w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 03:36:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J3ZPKB105828;
        Sat, 19 Jun 2021 03:36:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3996ma2n1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 03:36:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaVnODUVMOHDbFInQ2QmMDpbWXKObd9RZ64AESGtYS5rXvoh0Gs9BeUu6ZCNl1dus9weNPRGDFjlhNZq5xCAjmCz8VhQZabN9Kq2yEOYYs193jFPNX4kL1ah9PK7bxuLm2Zwi02gx5b/doqgZwk1ghMKPp34ErjusokI+5XIHQxdfUJqpwRHKRvEtp9fNp/1hlL9atW0o6LTAA2x9v2Hpz4D6Hl+NFMw1nOxgoMcXetzLkkg5DFqVp8RyfK+f7F0KhCrM/Ab/il6bvzKjtS6A7DnB4DR2tp310cvf+dsWgM8QpxOWgEyeIy4NIfHn5LfhULO1FWDB5jCkqZJUWA4ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRE88r3w2+yBlQI2WsGHrHkBwSimAmtj74rvSybfTCU=;
 b=Mx+5QqOC8kLMxwpej+dPFBzhW6ppdpOkxhUyRUowNy8SASduFOZI7x/O+GEpZmuunLdw1C3aZZL2lXlfX4lS7lpFZ0SmOkwLmxt0RkQCVfNYmfcJhMw0QwZwc1oUofXZ4FTHsvyiKXVR3QerYEZw2J208P2dzRf2ytMZD72Grhrd/DywarcAJuU5nN/EL65yIhC/CM9l5QP5x0dzfF6m1PRG3WUGIyseryOX7d1f8KtzAdbO7KS43OknnSF05LmPsTS8ZJMZaV4RmiPmMYEx0OJizh0hSqEtk4l9l4bWtY7Xb1xsPnHL7UTho/BJ4tOStxRUME6YpLaoJ4qlPi3POw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRE88r3w2+yBlQI2WsGHrHkBwSimAmtj74rvSybfTCU=;
 b=iBwLBLYSrhkhqV98Kj3MFOYY4MYX8g/7jPwlfQER+Tmx2Y+EZC37caEXSZdqhMZUuBpQ3BSk0S9Sdm5ZPy8RVCdyBFwrNN/++bDLOK3wb4nMnK9mkO6bkrb0ng88TQYXAy+FclZCcFTOrNvrTQEm4/kG5Ln57de9h9/CfEiOmtw=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4485.namprd10.prod.outlook.com (2603:10b6:510:41::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Sat, 19 Jun
 2021 03:36:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 03:36:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     axboe@kernel.dk, jejb@linux.ibm.com,
        ManYi Li <limanyi@uniontech.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sr: Fix get the error media event code
Date:   Fri, 18 Jun 2021 23:36:34 -0400
Message-Id: <162407372768.31217.11025698569858516250.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210611094402.23884-1-limanyi@uniontech.com>
References: <20210611094402.23884-1-limanyi@uniontech.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0157.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0157.namprd11.prod.outlook.com (2603:10b6:806:1bb::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 03:36:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b49a13b-0669-472e-31fe-08d932d37162
X-MS-TrafficTypeDiagnostic: PH0PR10MB4485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4485005D3DF16F3249968EFF8E0C9@PH0PR10MB4485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iYZa7ee0k4zJZ3hcTSei7wz0ue0AslIHzXP5uq98cr2vy5ZrWwm0cDvda/hFavkdaPpjd8QIqz9e2n00e/0PeWNKucC++5rtxkguVSY/OhJi9MoczWNDSeJihKZIdJI8kjLOECpvR6fHf3tLEEEb4CdEzpLM0gwvAuJS2Gc/WrG3SjP6PFALmXkRrZpSuIqXk2c8Et2CsvL7euAJF1eOtSgDCum/PnTXZIEPOYuJHVsLu5AEV9zqlcGOJcWucogn1Ib0VHrycKB1OmPuTQcMBuNJsJcHHr/sRVzdOqqXOlnBB4fh1R4XNknD4S3duRTIeqb1d0q8i23zlvisthZjCTp58peRy2YHPuMocmyG690lkev2Lp6I4TTY7epYkNKAuRf728deiyLDJvHD3B6+4v++jaI5aEvpXng9FwFV08ZWvOUy3dJRIS/XuNTCAxlnbvVk1opKqgfL2Xaz1VkcvC3EvT9wZeZRY/4q1/M+CvFC5L8rk4xQl1O2sGetbLUAgAAYbHG1SI9KPTUpfh7nPHrU/YRTC8B06Lq3vJB0zSxGRfedR/qsB9ajBr7bE/1GKQLqcIyVohBVSOoXPVzMsjOnlGk6ro5LhWUHcgVIJoNA2Td9TmgLG22OXgmsM7/Cn7BdP7G7sSxugNADFP8qMlhLAUdnee3FRpvjyeemy4Nd+SrKLvn4eb+CCSzpyJW/JGklHWUIMimp5G2i1xhmOUrxIbknjXg0jDUYU6lGjOe/4knJfr+awbeDLsnFXRhhQ0OCZjYHx/5g4LTH4TTrC7kEcaoMi5pXSlliaCjbJYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(36756003)(966005)(26005)(186003)(8676002)(478600001)(6916009)(38100700002)(83380400001)(4744005)(5660300002)(8936002)(7696005)(103116003)(4326008)(66476007)(16526019)(38350700002)(2616005)(66946007)(52116002)(86362001)(2906002)(66556008)(6486002)(316002)(956004)(15583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RU5ySmF0bG1ZYlF2MTJDdTVrZGk2T094K0ZIbzQybGxKL01hL3k4MURpb096?=
 =?utf-8?B?cFhCSWs3KzRKdHlVWTNKdkpOblh0OWtmaU5UZCtzbW5tZGFtNG9teDNjQ1h6?=
 =?utf-8?B?ejcwcUVtalNJZDNlOGNXSTRrZVMwY1dqSGFlZFgzeTdGd2lNcmZxcUFpSGNl?=
 =?utf-8?B?L1hscVB3SVA5N1hxdW5JblRKNzU1SnhHTnY5WXFkMDBmQVZWeTZlSkp5KzR5?=
 =?utf-8?B?bTE3dy8rVU8vRzQrYVRjTzFIR3E3SVptMnk2VXNGNUtoWXZvak5aU3VmdnMw?=
 =?utf-8?B?bFpEVFRnQmRUYmdNdjRycTlYaE1GQ29PcURtOE16WlYrTHI0SHdRZVZSNGgv?=
 =?utf-8?B?WGZoYTdyT1NUY25HeDZqOGRLekxIR0ZhOEpMVXRieVlYSHY5b3FvM2pYZXVU?=
 =?utf-8?B?c0tQNCtHdksyVThDV0EwQ0ZUNmtibW9hTDNWRkhkeTdYYW9RaUZRK2tlNmYz?=
 =?utf-8?B?K0YyeVJzMGJzYnBHZXpibXNKanZNcDlkN0dVTVBiclFXWitKQm1vNUswc2ZU?=
 =?utf-8?B?eWRiRzg3UE9TUmFEa0dQcVZEc051am1ncnpUbHhVWjNLK3VZZkhMVVZ5eFFk?=
 =?utf-8?B?RUszUS9YTUdVRDVyeDZUS21GeHdDbHZ1VEI3NGxFbTBRU0VWdTQ5R1RvWDdv?=
 =?utf-8?B?WG5zcWh0KzF2bGU4T2QrUG5VVitvbGpKR1NpZ25la1d5RjhBWWxPYTUxaUp6?=
 =?utf-8?B?NnMrQU9nVDJtQmRxek1ZbFVLaXQ4UkNHTlNGMXp0ZzBNczJxLy9GbEllN0E0?=
 =?utf-8?B?V2FTR01kQWtvcEdobGxTMzRsdytwZGVoclltMVh4VThidEx2MmFBbXBqRVBl?=
 =?utf-8?B?SUhvQ09HdjkyQnBTNkVNVyttd1RnbWJPL2QxQStxaTVsNURwOG5CaUF5Rk4y?=
 =?utf-8?B?ZFN0TGZ3UlRLNDU0b3F4VnZLM0dCbGZ4a3hqT015V0NiUng3OG8ybXdxRnE0?=
 =?utf-8?B?b0hXR2pkN2VsbHExV0xwaVoxMmFPYzJ3WUM4VXhBR0lUTVJ1Yk1vSTByZ25Y?=
 =?utf-8?B?ME1KdFVqTzJib3VvQzVFcmRNREtRQTRVeXlKSWVoNlNORmY3dE1jSUI4dHV5?=
 =?utf-8?B?bUJxWnQ2enVhY2M2bks0VGdrV2V4bGF1Vy9JWTROdytjQlA2ajhpQitaMUJm?=
 =?utf-8?B?TmlsTUJxa1VSQ2VONjltaUlhb1RQY0MxSTdETnIzMmYzb0JTZWNZK2ErcWpI?=
 =?utf-8?B?NDdSZGxDQlN4Wk1YcUlmdE1GaXR3VFJSd3V6ZW8yc1pqWGRDR292bVVVMFRM?=
 =?utf-8?B?N1R0bHJvSS9zRHY3TFdjY1NrVDZvMUZPSUVqampkS3pMZkdQTGlzcys3Ymt2?=
 =?utf-8?B?T2h1T3hTSm1Sa2lENmFMeGppeVluNUNkZ3M1QlluL3d3Z3d0T0R5YmU0U3dJ?=
 =?utf-8?B?VDhHd1BUd2pDSWVqSVFDUHpIODFHOUpjWmJTM1Zkd1UzMzdicDI1Qi8rM1l5?=
 =?utf-8?B?YlRBaENjdW95MEJlenE0ZThkVXpadk1QQ3g4MDlzR05RN2VNdDRybHg4R2ZQ?=
 =?utf-8?B?VnlmTFV5bXZDR1IzUnhMYWsrOURjWkZDMXJJdkk1dVNoOGM4ZU1RU2MwSWdQ?=
 =?utf-8?B?MkdUK0NNRktMZnlBV2JMcVBQeE12bVBzYlJ3Q3JXWkN0Sk9HZWVFQ2x4SVZ0?=
 =?utf-8?B?dEtDaG53MGgyVFJublZiMWRJbWorQld4SU5KdmUwbG93U2hrMnpHSkNYUzUx?=
 =?utf-8?B?bFpCNkVYT3JMU3dkZ2FyUHF6blRqSGpqU0t3OGRFK3RGNW1qSENqSGxVazdz?=
 =?utf-8?Q?9OwWmr6CWjaw6CJWyVgKPw0Sm6GHzrrnKdrv+Xm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b49a13b-0669-472e-31fe-08d932d37162
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 03:36:37.2908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mAukxIajZGnEfSLKrw/DToehC7Tk+ePkRJ6bchZ76twEigTSluATimg8Kwksk/+A5OdE4cTub+QC/CanODLKGVu9vDiPHI0vcIphzTDskY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190018
X-Proofpoint-ORIG-GUID: jrKWxP9zR37M7PCeC41dKt-tuvYAP2rl
X-Proofpoint-GUID: jrKWxP9zR37M7PCeC41dKt-tuvYAP2rl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Jun 2021 17:44:02 +0800, ManYi Li wrote:

> Eject the specified slot or media through a mechanical switch on the Drive,
> med->media_event_code is 3 not 1 in the sr_get_events().
> 
> If disk_flush_events() and sr_block_open() are called,
> clearing is 1 or 3 in the sr_check_events(),then it report
> DISK_EVENT_MEDIA_CHANGE not DISK_EVENT_EJECT_REQUEST.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] sr: Fix get the error media event code
      https://git.kernel.org/mkp/scsi/c/7dd753ca59d6

-- 
Martin K. Petersen	Oracle Linux Engineering
