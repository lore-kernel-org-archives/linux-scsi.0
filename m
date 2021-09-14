Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380C8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23887610A6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbhINDqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8400 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239394AbhINDpy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:54 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18E37AIC020204;
        Tue, 14 Sep 2021 03:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=AwhLTsUdZL+D4ePOW7KgcbiTkazpnqkEQ34RXUHTgYc=;
 b=DpQJKFkiHyM2eqqzUPMrc8ye0GfxleEbhXceSO37iH7dXpMyqMpXM+YmXTik/QRQG3Ij
 nfA2VXHMNWI6Sb30pm/CzQ/NDyY3kpL4HlaH2zPHTwk7kCRJVx/HNuGsZdSIQ7USSdgY
 hvTaWvA+b7ATyi4FavcAJAnQegB/spCbh205vOFAwJBmwYLagcklO9GXkP6cCoFko4w5
 P5Mvs30az492FLohWhbGX4Di43VAqnnoaTaOwgIwvl3kyQjSBn69TgwGW1w6g99O4za/
 MXT1JhnU65dwYOpkS8YjS8id3xzjM46gnNPtg8Zqy/xXQ38IZmRQ3RsUJU4drTxi/nY1 QQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AwhLTsUdZL+D4ePOW7KgcbiTkazpnqkEQ34RXUHTgYc=;
 b=jhlcMU/lHbpWTCnPMdqGR66TzMREK/RbiQlsfODvCbWbJNUL9ajWCdpqr3n/a+ZSlq7V
 3yMCNfDmmUk1BNyTeiIhcSXLfLJRDXrWvb/hKcGppuejaLCned3UdwYPGUpyuFZ6RWgb
 IyLRjdVTjhRKtcF1wx3xwD6UqX77r27c7LeQoCUcbiqtuYXWLCnghnEh3TYKRllonw/Q
 25xbNAlnvz5XqbPNiZVN/G///fgs+Sk2BSetBCJ2+fn4RyvaKT0JZE4X3SG/LsD+tQx3
 G+wS05jhWXNfZUM4Ht+i4gz0qe/pMNWEHKX9VMDVoAiMWJBxtydsJw+FGRpSyqjTSzg/ sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2kj5r2eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f6LE097717;
        Tue, 14 Sep 2021 03:44:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3b0hjuesv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDIBLliwPzmo6WDkIYrR0f1mei0FQEdrxG/znIMUmmtFlXaDxprwf8UshijK98ylC6C4O6v+Gt9xR9EsXkiG+SnouZ9lnu0AUfYJ8k+acUB1LbNl+OAr9Yfm5qe4N46psetwr9dkJuwNriVI1XjpoN+gb6erhQ9VUxaJFJAY6rvjWL2GNxRktzATCjJMm2OG6nBYUDbup1/WEq1v70K2F6KwXlA1yIgzNHX84tgjmDNZ8yeRyaw6SIgCQp4ipUPPUexUT5nWM5Yfmwb5mTSOZKZzih2watqzhcRU06lskazVx7qtqWfS08gkvTu0tQJsZFe5NwhLQWLdiH+SQl9slQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AwhLTsUdZL+D4ePOW7KgcbiTkazpnqkEQ34RXUHTgYc=;
 b=jmRXutgmt5R2fqOb9zI6BeWprjLcCHdDW9lZTyFx2hBv3r0GMG/fBHk/w6Tx9BLc4G3tUriuBQTXz7699hen8qGMiKgWhzmEmGoZYD2/19MIU2Hzzw+8yy6YkqvqqxC1VKOSbV8s/qjs/d/NyE/cOtmykfQYS9cauNk0EHu93xcUOJq6o1o6LSTPY9qMxB6kpcRpIZ6E0cNgps0gVc/lKpw8w7tqTeURX5iXHZNfyrKJEbk8HL4rqm0HckM/NCnAglsway+n5PnPWZFfvOzCTINYODnjc+wwkiTxrCYc3gso71j8LO0dkT7Ru75kiCjsymIKgkns6DP3NOj+zW+5nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwhLTsUdZL+D4ePOW7KgcbiTkazpnqkEQ34RXUHTgYc=;
 b=JeBksdBvAqYWL0Z+mpkXN1U+Xqu4tepK2XZgzKcx17scW1Y2cN7pufJotypzoh18KJi0IqRWKeD++nUe+yEVD8AvroriLsTLyHtp+Rq8Fn95/Gk7tclqxGGvM7wJUgFDrY1zg4po6NTygiJs9wWEme0QQ6ioTx5S7koc7lfiK3U=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 03:44:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Baokun Li <libaokun1@huawei.com>, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, cleech@redhat.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        lduncan@suse.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        patchwork@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH -next] scsi: iscsi: Adjuest iface sysfs attr detection
Date:   Mon, 13 Sep 2021 23:43:53 -0400
Message-Id: <163159094718.20733.7684132037831496520.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210901085336.2264295-1-libaokun1@huawei.com>
References: <20210901085336.2264295-1-libaokun1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 497b719c-bbe6-400c-74a2-08d97731eccc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4725DDB70F30141FF5CCFF258EDA9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKYq5sTBVLOmw3W/Piw6Y5R62LEmgX+SW7KCGXedffsubm6pEzyidVoYmoDDSjm16vuWcx8qxhA0HwIJfqe2svjXQP2AZ48vAzYFls8yqX9B/+nWNLgsdQHrKhlAC49AAPgFl1bdBfEki5XLe+eYxDrLEHxAMIZGoWqWuLaGyNtgd2vD5Vo+noIygSR7Mz4ACdSQGWHYNHgoU7FawZ0GYDyniWjsazlTNKQ/SJ7Bga9TiCngcjkT2o1w9+qNdhttutv2dUBpiqjjNuMmYlMXAZ4e8i0JZp62hSUbzMCeMmUuP1h+GCUZBwSvLNJ6BcpbhtDTslStJhtKZ7Msi4Qtuu56C6gw9k56gE8kO1tCDBVAIix8W5Ay5EwxnKX3jS1e0/YrLwtXzWVW18ovORsHAmsf1N2sp5W+qyaPeF8pcq6X46UloOVGO3PuYOdFosUluLQ2UblWrQz1naI/b/BAyUdGTG6ZXIyeNmPval+WmH41R3HpLX2pi5zHH/Ndip/uQ6U0LJUFetDBC4AbFwujhGTDYNDS3cCgxA2EDaNP425ou5F+UmdMTEGX8mB6vwtLd8uvZG/feEM0fhnLhFjba4EmLIk76c1DPY7QfAziFdrMC0ML7j+0qb0X5ZhYjCnJLHi1tljHlysSx3ZqkH3+c4+nRmBqVxI42J0wRCNzwIsoJZhe0MeJGA36oHRm3LedSIAg7XkDv0pvJhVG9jftNkQHwtcgm/UrovuwsRCxFDpGCYVuusZSwYFnogBCdma5xFbhjngRjDA4NUvDl1wfeQuMvwiNvPyz6aaDXe1+wJY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(966005)(186003)(38100700002)(38350700002)(66476007)(86362001)(26005)(66556008)(83380400001)(52116002)(6486002)(8936002)(66946007)(6666004)(8676002)(36756003)(4326008)(5660300002)(316002)(7696005)(2616005)(2906002)(956004)(4744005)(103116003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFovYzFpM2FxeElCRHVINlVXdVd1WUVOclMyMmJ6Sjc4a2orWmNIWHlQcWRr?=
 =?utf-8?B?V2lZNUFVdTdIaGgyT1hRMWsvdTJlOEVaZEpPY3c5bENiMFpuREdaMUsvdWN2?=
 =?utf-8?B?WjQrdXpWV1FqamxjRmpNL3VRdVVYUnB3SG02dEJzb05ybmhXM1FWM01QY0hS?=
 =?utf-8?B?NFFUeVRkR1BYVG9UVFBQaFVUT2lJUlJpT3l1dzJRQi9lN3lYYTVhK25xWXd5?=
 =?utf-8?B?MWo3MitoYUlHLzEvY2hZM0szdVd5RXBCVGptRTZtOG1OeVRHTUxZZnJPQ3RP?=
 =?utf-8?B?aGEwSUpuT0hFUFEwcTBxVEJaZFRZOU8zQjBpTCtUU25TWFhURWZvdjJhcHNV?=
 =?utf-8?B?MlplOWpZeW0xVTQ4WUZkY1JsaE0yS016ZmN0YW5jWEZTbmg1VzJPc2VSNzJy?=
 =?utf-8?B?OTM3UmlnTFExdzBTVEhLc1dqaXRXNGtraGRabitVZTd6dEFQaUhLOEpTUUk4?=
 =?utf-8?B?dXl3Vld5QlBMdXIvY2JxN3VXU2JxQXlDOTByazhNUVF1b1JjY2liR0ZDYVNj?=
 =?utf-8?B?dEQwa1VsZ2FqVENiNkJqdWFWTDIzbjcyVnhCS2dXREpjcGpPa0pFMlRWL0d5?=
 =?utf-8?B?eFJ4U3liRGxzWUo3Ui9PWjlBQVhBYWZKWC9mdmwvWnpKMXF2dVdpNmlIa3hE?=
 =?utf-8?B?YW56bUpEOTk0ZFJOa1NWQUtFL2pFRk1iQ0xlSmxVWmY4TGdzQjdOUjlHQWtF?=
 =?utf-8?B?ZGhVOUNPd3d6cnJUMDFNTXZ5bDRxdHRYWWx1VWR1ZkJQWFNYcWhiTktvSjVj?=
 =?utf-8?B?d2dGWStpY0xiQnR2N09TbGhZT3F4Y3hPb3R2bk95bTFQQk5WTTY0UTFYaHRz?=
 =?utf-8?B?Rm45WEhPaDdiU2hBbWRCdTBqSHhtY3NqQTR5d3c1ejRYVGpWNjVNVThNQVc5?=
 =?utf-8?B?MHhlTTU0VHpvbW0vbkJ2K0ZJblo1NnJNcmo5R0lsNG8yMWljZFdna3dodDgv?=
 =?utf-8?B?S1U4MGY1b29ZMHdxbnMzU21uU0VJdnNvd0FyY25rMDlTYk5GV3pTOG9pbnVN?=
 =?utf-8?B?bmpCWUZNYzlFQmRIQzdnSWNDYTdzUFJJbkRCdzAraXgvYUE3NmJpQjR2ekE1?=
 =?utf-8?B?OUJRckVxSE10NXdQUFFoMTBMbENQRXg5Wm9UNlNWYmE3eE50LzVaOWVNT3p0?=
 =?utf-8?B?bkhyR2piUUNLbk1heFlsTm12aXMzOWtZUHJZd1Y4bFZzMUhZQ3B6b1FBL0ND?=
 =?utf-8?B?Qm9nLzZHa3NLNitacFRYQzJEVXVxS01JYnpJNVBBQjgxak9zczc1KzlEWk9v?=
 =?utf-8?B?NDJBenVOTGxQalRkaHRNdldvWE9PNDEvL0h2c3NvU2xrRXZVbThMUmFkRmJM?=
 =?utf-8?B?Z1V3Q05IM2UxbzZRc0xJWW0xVXMwakt6cEhKNEtsUTZMODgxbVgyOU5mb0w1?=
 =?utf-8?B?ZlRrNTdzdUxzZ1djRy9NNTlrZUcxMmdmWFV6RG9IOHNuMmVMWm5wakliMmhS?=
 =?utf-8?B?RzI4NGF5UjZhRENHT3YvRDhoTlNRcW9qZVQxS1ZsUkhreFhSc3ZXNStsSCtD?=
 =?utf-8?B?Mkw0L0lSbHhQcWZkMnRocE81Qk94WGU0TmNFLzBHZjZzVGVjbDVKNVh3Z1Zo?=
 =?utf-8?B?eHNJNElJK0hqUXA3MVlRa0RVY0dIelYwR2VoZDFIZWZ1NlFZb3ZRaUx2TWdy?=
 =?utf-8?B?UlVrK3UvZ05YNE1QRzErSzZZRGFwd1VmMmRhckNMejBFRVRkM2dKRThMZEFo?=
 =?utf-8?B?UEtXbzgwUEkxdExmREFrVWUwMk1mdGZaQ2FsU3E1d0o4aVZ5MzVvTndzb1ZZ?=
 =?utf-8?Q?yH2Is6tLBelezt5IydPODujW3HA8R8AguqJt1Mm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 497b719c-bbe6-400c-74a2-08d97731eccc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:16.1462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xkyjRR+rNTJ1cXOjgYNsJZKrKdJnGcWChPGK3bKjkfzAulVN0ZVRtJwV+JpmDOi7MmRG7R2NDd25kQ2lCdKMMsyHiOSmuzsdsywHV9JWIhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: r1hsXpy_uYlfeuXJGeXuxKlJGUUkozy_
X-Proofpoint-GUID: r1hsXpy_uYlfeuXJGeXuxKlJGUUkozy_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 1 Sep 2021 16:53:36 +0800, Baokun Li wrote:

> ISCSI_NET_PARAM_IFACE_ENABLE belongs to enum iscsi_net_param instead of
> iscsi_iface_param，so move it to ISCSI_NET_PARAM. Otherwise, when we call
> into the driver we might not match and return that we don't want attr
> visible in sysfs. Found in code review.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: iscsi: Adjuest iface sysfs attr detection
      https://git.kernel.org/mkp/scsi/c/4e2855082925

-- 
Martin K. Petersen	Oracle Linux Engineering
