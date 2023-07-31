Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9ED8C001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 18:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjGaSPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 14:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjGaSPC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 14:15:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C41173B
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 11:15:02 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTnHN001889;
        Mon, 31 Jul 2023 18:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=CXDd0oRRxxyB6CCHhSp5Mj8+hoX6HMhk2NnoXwWou5Q=;
 b=c9qYYONjEmmbT8R+MN86IlHaKTQbcJVk2fhVftqj2yV1KBvwMAgifmxpgJZqnWvl8lMG
 y7A+d6GWz5+V+foz9d22Yij12EcINyskfQ2/V+cIV1ppgeShvjzXZ/O74lFUndKoHwsQ
 FI9cV/QXOI/Jd2Yot/VOuX/xDi5N/UOFOggxz1iMGyrr97iyc1VTZvKF7ejc+V+49Gyk
 GXmX/Tso67Je6nOnwRHKLzKL0QDeqM/AM9Y0H9qc3W0EWb2s9V1R+TaapfjYhXxMeOWk
 bazepJuv+PMNAfGnCPsdyXTpklMOYRUmkh391Ltdd+AzFFPBlGTMElaM1xGsYwdxjSyB Bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4spc38vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 18:14:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VHBAJC037971;
        Mon, 31 Jul 2023 18:14:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7bgrka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 18:14:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XryN3Lh2xp3oTiwGGm5JhHLKMSRyVCcXkW152pwoVdUcIoYkcu4/Csl1yXYPiTYDLBNk4uCJcjSiWY3Yg9sJZKfvpKZ8VVSurPevGq8oTKZukcaGLj8afDVW78ygXwFB8GJJvJNeBpeqz9ckKG3rr67daVycj/YNJvbrQabcXulBcklQqitJh6+v1fqmN7PUGFUxL3pm95dhkKcqUsFBDDsjNixNJr9uHxiQt6KsKoONim6zE+8bXa+U4OH26N3nUUm6HlWWVDJyDibmSP/gNWa764RW8jEEu1tsLTFbHCTJUcoFA9oVMgJzgci2V3iIQyKNQpyZNHxIQ8D5zHIOxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXDd0oRRxxyB6CCHhSp5Mj8+hoX6HMhk2NnoXwWou5Q=;
 b=DMFZjlW2lgepSmpzlPESWuBF7J+a2eMGMUpPRfdEM4Mhot7Ao6Ld9iDw+MTWXpkfTytAk+TsWvMOsgQArE9ZIotVr/bkRWegnoPTL9eSLmvOoeFTpSRSIYry6XNQhahfiZ+6WA/gu3Qllvs9/dXDb3dClGv/WWpzNAQP21xZjreZz79T5rYjx7IIcfc/04kTjHKr9TU+21/FMcCG4Az8M2RfBXHE1lvzcFQ8wD4PsMYqvRZUyuBNFFvQ6dfbeNb4tWwOI0t9tfBrwtnzr2VRIW4NMVhqekW+ti2B2CH9N7lA6jlG8gwM7H4xVmRbEtg9Wbbxtf5+t6kkFQLiK0PsRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXDd0oRRxxyB6CCHhSp5Mj8+hoX6HMhk2NnoXwWou5Q=;
 b=tIyD28LJUXOnfuE9koom3UWx3/7XsQ1O/GyAvBX42TIhm9Xs53cd0AC2v6ThEzh2n6C2o0zwTIojnoE0ajCqJj5sDq9X5lkTgTU9tlcLF9vQGKAdDnP/X8/9e5UptKCoDr0HNSBvd+VKhrPMn+qXNC24kAPl7STBg2tyxs6A1vQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by MN2PR10MB4367.namprd10.prod.outlook.com (2603:10b6:208:1d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Mon, 31 Jul
 2023 18:14:50 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 18:14:50 +0000
Message-ID: <018cba06-87d6-59ec-072a-3e59b620577f@oracle.com>
Date:   Mon, 31 Jul 2023 13:14:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.1
Subject: Re: [PATCH v10 22/33] scsi: sd: Fix scsi_mode_sense caller's sshdr
 use
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-23-michael.christie@oracle.com>
 <ac3613ea-9969-b0a2-b3c5-0e13141f22c5@oracle.com>
From:   michael.christie@oracle.com
In-Reply-To: <ac3613ea-9969-b0a2-b3c5-0e13141f22c5@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:610:33::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|MN2PR10MB4367:EE_
X-MS-Office365-Filtering-Correlation-Id: a6363075-9505-4202-3fe9-08db91f207b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QkOovfBBJrFgKPuYwXCO4K07ODmzPhJSX7bFJhB0rKhsevUO15jv+eJIg1933KTNROLY4S9uFWd5LbyU5PdHO2OX2tRX5X0e09SodjE4SlKTmcQqkrg/vkqawXWcbk/Rw2CGu65ZPpYnf8g5VSeJR6SP3rpQS7+DO2R6by7ZwE3NREnBxUt1P42sDgAuyWiA8CSry9T9N/ooyh5TWKFAkxVkMFq3YCqg8EZnt6GShyoqpp+HZdQKyioYmG0iVE4vZCwg25sMxwiqwRvUxGs5U70OVUtJZWXG6MimiAsijqhuPzgoCiBAiUdW5qY9vHQ2sa2DgdRfZ1CfGcoB6qHWsg5I91esCkKsiKPgNltuGx8/yXF/RN/4AGIAlZFhjVbatXLl1U/BCTBzSY3h+jMbqP21pUuPm0tEahVJ442x2CaYq39Rsjiiv/Ls/HbTHTBMYc5HmNhg1tn+tRrPlyyZBGx53dL3O9F8HPVheSMMp8dmNvKeVLYqFJK2UdojZI8l8iuc4LTvvZQq8BEdinTiBBPLiTvvVVY6QP1AuAERfIGDqtkFITIctc5Nvq2Z2OnwVlqRPr5mW1MIcZ83Xo+4RQHMI3mnvd/gXOYrpJzFKbkACAJe4/fpqwzBzTmQa56n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(31686004)(2616005)(5660300002)(36756003)(4744005)(31696002)(38100700002)(2906002)(478600001)(83380400001)(26005)(316002)(186003)(8676002)(6506007)(53546011)(8936002)(9686003)(6512007)(41300700001)(6666004)(6486002)(86362001)(66946007)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0o2Q0hQYm1NaFhlWitLbm9XQXp0eGVpSURDTkVyV3k3aEZPSzdqSE90b3dO?=
 =?utf-8?B?VCtPelJ6alFrS25NbHNYV081Z2JnK3dtc1lUQ1laQ2lNUmM3aFZtVzE4QWFO?=
 =?utf-8?B?dXc5dG5tZGRaN3NROGNKcUhQa0IwejRJMVFHdEMra254dURRTmJNRG9LNzdL?=
 =?utf-8?B?V0RvRzlXbjZpUmszSWFoQ3M1RWNVY3JOeFN2Z0RPYks1Q3BIcDVBSGRwV3VX?=
 =?utf-8?B?OEUwWlNxcVRvL1lSd2hkbjlZNm9lOFNRQVQzZkVRaFltSk1GcUMyUHg2dGxa?=
 =?utf-8?B?NjFjRDVDdmw3MXViWGduWm1jelNVMlJRaWlqYVo3bkJkaVdwY29ha0t1dlg3?=
 =?utf-8?B?NGM5Tzh2dDJnd1dxUHZDc3MxRnNBMTIvbTdlS0hsU2VOZ2p6bnRLUG1EOVUv?=
 =?utf-8?B?MWV5Ulhmbm5pNk52bm9xTWwxTnVvQU5OZG1ON1dqTk9DQ1FZdU5SelByb3No?=
 =?utf-8?B?eTNLODEzaWtEYjNXYlZ1SDVBaVRrOHE5WUtaRURLTWhneG1iSi9yaHhnK0x6?=
 =?utf-8?B?aE5DWHNxNnBDUHg2NnI4bjhSMUxUN0tEVmFFZVBWb3ZNTWphVEVVZVdNa0Ft?=
 =?utf-8?B?ajQ5NEYySzV5YmVjRWU3dDJueUcrMlkxWm9hMS9wbVFqdWxRUzA3VTRzNDcr?=
 =?utf-8?B?bi9yYnpFamVsVmJaODNkNnYzcCtlUmt3ZklGOFA4a011U2h5OEh4aFY2SGhn?=
 =?utf-8?B?a3NCcmIyYTA0SHc2em5FU3ZXc2xOc3hNYTlaMWtZb1E4OU1NMVZvcDdETHl0?=
 =?utf-8?B?NHBld3Awb3I2eVd6d25wZTF0Q0VKVDJYZVV6V1MvNGZFMGdSZDl2NnpBWkhR?=
 =?utf-8?B?OW80a28zeWJiV08zdnBGK3pIN1Z2dEZ3UnBIOGJIQXhncHorRTJDRVBnS3FP?=
 =?utf-8?B?S1pQblFpMHYrVEFsYzJrM1RGU2VRbERlTGsrRDZtTzlJdUQxT1h4c255Wjdv?=
 =?utf-8?B?V1pSbDJmTlhlWWNiWUNLeW1iZ1hSc2tsSGtwS3IwZEhpMVZnY0FQTHhETWw0?=
 =?utf-8?B?cnFFOUtiVmpybnJ5V3JPaERXVEZRT01XSEJua1BiUGtBTldZdWxpUysvVkhO?=
 =?utf-8?B?WEJzd3RFT0ozUlVzL29KbCtwZFYvcFdhVTA3VmxxbzNhUzBlWmFrRGJUNWpi?=
 =?utf-8?B?ZXVYK3dkcFpId2pHSGI3MVViV0VwME4wTlhVSDFLd0FuM0JoblBMQVJPZjZq?=
 =?utf-8?B?RXNMV25CckI3TkxxMFFjZFR0WHNvMEc5aDBJV2U1dVhQaVFGdjNVS1JuYzhG?=
 =?utf-8?B?bG1sUEQ2T0N0QVdGZEpiOEQ5K0lweUdleEExK1dhQVhJWXFMUGlWUSsyK1FD?=
 =?utf-8?B?blNpRFRFMXB6aW96ZEd6WUZzQXI1b2hyRTJhNzIrU0ZjdTc2RkVFbTlhZURL?=
 =?utf-8?B?eFRPQWdmbDZLdXpmNDRSSzFZdklyWnhibnA3bm4wMEY5emsrQXB1dC9zZUZn?=
 =?utf-8?B?T3d1aEtrUjlXblY0VW1jY2pYLzNWOFVaQmdPYnkyTHhWbUNJTC9vdTM1RFRG?=
 =?utf-8?B?aTNIdVVhM2NvbmFWdmhQOW1kSTBhbThEWkVqK0tBU1l4ZVFIdTg2TmptSHZ5?=
 =?utf-8?B?YXl1Y0pZOFUyVUc4eGpUY0p3ZUo5eGo4RFYycHc0YW9Xd3crclNFRUNIdnBw?=
 =?utf-8?B?a0RjM2tEY1JpQjNRemo3Ui9NaFgrYVNrYUpyWGpTN1pZaC9hMHBPQmpKZXdE?=
 =?utf-8?B?NHlRNTNmR2FvbGFlYk1tSDNqUnRqYlRXVmlURVZxNkZFSkhoQ0VkZFJPZmxm?=
 =?utf-8?B?bXc0cnRzeUxFanlxc3orT3VnNnJCWU1LQW1kTXNTc2swV2FXa3RFeURqNTNK?=
 =?utf-8?B?cVZqVXVTMnFYM2ZQaEp4Tk1lY2s3dE5zNGpoUDNzcnAzSVBjdzJDclMrSzh1?=
 =?utf-8?B?bjNjd2FNR2RBMWNoeTFObkdNbWVvdFNpeHZmMlBrMW5wcklhWlBwZFlIeWpn?=
 =?utf-8?B?QXY2cTY5eFVyT3JySXFmNGlHVkJtUC9OdVhqME8rYXFhbndpRDVCeUt5RVh2?=
 =?utf-8?B?SllzYzRxWlFmZHN4M2hhQjB6SkpOOGZGazkyOEhQZGl4ZWk0Z0VpbmNRYXpN?=
 =?utf-8?B?L25rS1NJYW9pSlE0ODlFR1pvSkdlaEFjVjBvSGUwczRveXk0SmtCSWFBWnBU?=
 =?utf-8?B?YlVPalAyemZNT1pVOEFYNkI4czFMSHV4Sms1MzJ2U1YrNXU3czRXZER0Z1Vm?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cDQZEUHchO+Q+V/5c+fjZ8RKnrbze+L/CJbvR5dLODSwBkFNrOGVztaoL/3zBt75QQa9/oN1z5iv82yKAaAhBZtHfdKXy6D7JcgEAlOewWQ+HUx/U9Knir0GT/QEnk2PvWzwl6b4ukShCz5U1j25DpXz3wPdQdRAKBicJiUJMqsETrPD7MJhZfxHLPGzAKeUb9KKHXus6+c0XFI0pdXb2+tGDxRCczBsTFgyQiK1cJgLECmXTLiC5L7M7CwVU7sKaarPA1BpD1rhU5ycp28CT7Jzh/Gxke5Of4ipmmIHX1VuX808YG/NOe9r5chg4twzZ3FNHC8vaIUKV3R4Du6ey9CDuYj9NF7k4m8/cjWaFLL0GsnXbCqo6NCFBDGKjOlPlSbKnnElNuh/2IJDnrFexD6A4cuj8C2gaJi6dhP2giyO6Zt4zD2SIgU9s5TOPFMeYJnjj+rYhMrqWbr5/Enp56qOg19/wL4fVMYo+ZIzE1yCR3dbSjABQQG9gXfhy1WE0JvdhipzIi4yljyILOsg7+nj0m1nwoB0h4GjZ1lfXVRQmVqMHqu1t/e38dnQrXKQV+MCg+wmL32pdWNSRhTs2kZwdnPj5ddmtvlIY4lmcu5u7Zr6WUMqu1DSAjpGk5j12uaBTFeXARhwZTxr3+XkGgNVPd6SP+XHbsMDxOhwpRZZ9r83IWY4YAa8P5HonxNzyt6eD/esG+o41kjY3nNnW4PhB0L7FUvP/BDSkgv+8xL+Qu3JbXhXVAcWrRBA55a+70sjDeX41oYuJVgaJxEkeMKpl3bFDrP6TqaOCfFuyI0yuifnQcaydDcuvGY9fWxfXfQaa7WH+BFXmSkIPg1Yi6O6iLa5nwV5wJ6euvtis9sstg9vSx3R7yp8duVEORHE
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6363075-9505-4202-3fe9-08db91f207b7
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 18:14:50.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMocA82N6h3Y5PBDdjZfcPZz1l6BedeC9fWwAA/PXDxSqeipA0wN1uFw02tmM20CbJDGO/+2k9CsvoWS2WPJpMnng1llbNg+Vx5wQNQXHok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4367
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_12,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307310165
X-Proofpoint-ORIG-GUID: futzWOr7C4aRshrBuxO4YiFGFqv2WL16
X-Proofpoint-GUID: futzWOr7C4aRshrBuxO4YiFGFqv2WL16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/23 2:57 AM, John Garry wrote:
> On 14/07/2023 22:34, Mike Christie wrote:
>> The sshdr passed into scsi_execute_cmd is only initialized if
>> scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
>> good statuses like check conditions to -EIO. This has scsi_mode_sense
>> callers that were possibly accessing an uninitialized sshdrs to only
>> access it if we got -EIO.
>>
> 
> sd_read_cache_type() -> sd_do_mode_sense() -> scsi_execute_cmd() may never return -EIO without getting as far as init'ing the sshdr, right?
> 

Sorry for the late reply. I'm in and out of vacations.

That's correct.

