Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B457DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9523D6103E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhIODXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:23:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11868 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229758AbhIODXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:23:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F2Swtc032082;
        Wed, 15 Sep 2021 03:21:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/46Ifeegt0XY2dLNJXiEShwRZpp6xgkzTAixnSCdqEc=;
 b=EBbsrMg3ppQJ0WxqyCYXtmtiU1cI6JY7ZSe4ZFNQojzIRNNeXNHeyyEqq8YFpcFqOjrO
 yMITraryrfbzt09KNb0dasT2F/WdSqTqFiBScWFNIcUzJjAD1W9LJi+17VJnNgaA/FBk
 kBZ3HVSsS2zIysdlzbI7aqoiQuygVXmfiUyfQ2EVnMjitmkSWUEWR6jHpYQdkOG7BWO+
 HDBrRcvyBDqYtPoSBEmughqupNex9FmLgzg/ex1hIurFOcXoz7ITb9tNgxQsWe0OvQ5J
 R4+FozGQZkGNG3nxN/6/FJzktZuKLyT45G73AEWwlPRzM0wYQ3q/5h65VPL3rdTeR1wg jQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/46Ifeegt0XY2dLNJXiEShwRZpp6xgkzTAixnSCdqEc=;
 b=yvBuAYdFk/BZvpZmbrgctpcg/7ftvco7Y9ZTcj+uygM9iBkdr8ZuJcVQ4ipx8u119ie4
 HR8vvEwa603Hu3u0pX3TOHTxbxXAbLGuA0fPuO3yCOtcQvtH35KIJspjKYFN0bcYIjy2
 HpKRz/CIiZQra4Mjg78e+9Dxb8y7lg6YvRtyVPUAV7l8k8ELpxdOqJMidhwqNY93XgjL
 QEU9yf/EYHZpKEjcLoF+aTU/Ss0/bTdwqjoOL4uvP4pTG8/BUnElnmSU2LnAgW8OG7ij
 jnKoVbPkxQaSs/lEPOa/qGZfW25J/+Vwc6fW+IHrTMMl5MjtZsOZcWpdhRSJ7KeNrVvd Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p3mkhfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:21:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F3FAs5070783;
        Wed, 15 Sep 2021 03:21:31 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by userp3030.oracle.com with ESMTP id 3b0hjw1hng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:21:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6bBglr3myjJwYjmksXkK6edcUbGwWW1O6g4J/FFY1gPef1DQ31p+/FeWzy51Xs4iXYIHyy/rTHlAwbMMbDsQ3YLdbZwpquQ4NAxxJw7vv5T54QNFqo17ewLf7zvEJKqDC8/HLA3fYrmxtYobf4RbsWrznciNpn5hmljzEw3IZI3zqG2DMUphlHOujdDFFhuPz4jd45tt/4XfLipnM3yqiqDfzLyzE+sZR9DNckWHeeZbUdYNrQq/qqEI/0hYokVg4nZ4KHwqNT2jRM1LaGeYPC0V+tegbMpmmkJVs3M/Hw/A4xOpMIiC2KpTrVwAXIq2sWdrFxfXWWGcT5wbm0/Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/46Ifeegt0XY2dLNJXiEShwRZpp6xgkzTAixnSCdqEc=;
 b=dF6KG3GuVORTvGdyD/qHoeOLS6s6HVv0CsxOpw84fC7uclU1FyUQGq91xjkEKUL8HYtgVt6thsLsFzcp3f7ttNMK+w1dwpIvZVk40aznHCzE6gbSuG0JqUty+qFyP4YxAwX9bHYeMf3gmz4gMF1rL+YFw4jISyxqRdFs7EI31EgnsAT1/ub7uDWoYYZGDGlm6sCnrXHMxGv1cPRXs0U+3xcbcupt7Zc041Gfb5GfLoMPfj7jCsNQRystGWABaWi3hqt+GdK/ShsFxmrvjhK4504lt66QEUC3hEFWtNrsQ+J7VvNYUKoQQWOqR+TFnppl8wwx72tUYmzmst/APv0cqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/46Ifeegt0XY2dLNJXiEShwRZpp6xgkzTAixnSCdqEc=;
 b=mUmEqYzKgTrBbNrr4gsfXYybxuOO0htV1/ZqzBFm5BYlG6+3E9duPBqC2uB+xypZWziiC+a8YuW4oLmnK9WHJVjKom4FoqYwq4EDkd/pjB9WN6uiVeWmppCd70hIRFkcUbLfiIpvLaWZZOG3ZMadTJ10vqlspoOq6jn5o36G0C8=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5435.namprd10.prod.outlook.com (2603:10b6:510:ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Wed, 15 Sep
 2021 03:21:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 03:21:30 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: [PATCH 0/4] scsi: remove last references to scsi_cmnd.tag
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dfiwmky.fsf@ca-mkp.ca.oracle.com>
References: <20210819084007.79233-1-hare@suse.de>
        <ef629eef-fe55-2c8b-2825-67c43e4f4cd8@huawei.com>
Date:   Tue, 14 Sep 2021 23:21:27 -0400
In-Reply-To: <ef629eef-fe55-2c8b-2825-67c43e4f4cd8@huawei.com> (John Garry's
        message of "Mon, 13 Sep 2021 10:25:27 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:802:20::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SN1PR12CA0057.namprd12.prod.outlook.com (2603:10b6:802:20::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 03:21:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cbaf747-377f-44c9-e96c-08d977f7e918
X-MS-TrafficTypeDiagnostic: PH0PR10MB5435:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54351A502E5ABBF3E9190A288EDB9@PH0PR10MB5435.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkYaX8eMVL9/qInCy0awm6UWJjCWgW9ofYPF1+BzRdVPIWCAWzAcO94vD3+1g2GsA7/BURx2gLiNzxZ51Dgw05t2ljVPz0H9sNnLpxyKXYOSGJ/+YDGj+c2soenx3Vy6N+3Guo9PV8/l5y7JWvZykxiQwMZtpaFEbMfixnkRHRWxH1k2oAtHUYTjgWo/pr215zgAfNRXHTPFZcsAqeDQBZEnt1Ud+YdP2VQuA743VrZul5hr/Mg5O7odhONa4HhPjy8AWRjlPI9W+OMbNO/P0v/g7+nrCNuADOzkGIhyaF/NX3EUhnhDPqyKpLwEkhnManu3tPgEENsEqiDziGAB+ut0ySsvcv+Vo/NavFg94QufdfexlDa8QzZ7/singcrT/DJKiwlvsilSICcncwXugOXiE5v6upxBLyM92XJOz/7Xvn0B+f3TnGKFJFrTiSexOV4Czt8IzyUA2QSOx16rseDvrI/pe7TIBI+XzyC8blyge6o4Kf6p6dHGZhVMdEF1Fv5S+1tLlAQUwBCVV6OcFFTnq03TzR3hjAxnS1TzDLvysZ3TClUP5nWQ5lv8t8UQ4VKNI6L7lsLTEByJw/fzGiRaL+zz8pUe2mkYvpKqpCPaEJv4JjKKC8mM1HH12KBUaKGlnwJV69ohc8AkIBOXzD4N1E6pAcc3rBPhtfIqjQZgxOUcUBGCD7FMKcyBgK/2i3PrfkczrIAqwJxNS9QpGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(346002)(396003)(376002)(55016002)(186003)(54906003)(956004)(8936002)(2906002)(316002)(6916009)(478600001)(26005)(36916002)(7696005)(52116002)(66946007)(66556008)(66476007)(558084003)(38350700002)(38100700002)(5660300002)(4326008)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2mqqJHHLtPIGMovh/uwlyZtIcwm3tleXP7SjJpmeRQeLgAGzdtYJEp50sdRf?=
 =?us-ascii?Q?cGDM+dLRB24VSajGGTI0HtO6Nw1t7A7+G4cn2k6shAy4l0ydlyBIn/o2frTS?=
 =?us-ascii?Q?KU4cyeFLHbldjxysyBDdWDNOiA2zvhmDT0sz0urdNx4+dmpKjxydXObyc6+v?=
 =?us-ascii?Q?TqRo9GWECGi5i6g1R5mKwoTQEQpz6VIK+cUfeIaZmYzQibcER8+VVNJRsy5M?=
 =?us-ascii?Q?rTEsMK0Ji7lZDINAbrzC6tvHxlY50kGQbZ7qufEzJXJQS/hs43u/gEo7Vuwv?=
 =?us-ascii?Q?R5FzRqnj9ooX8IzBhhYzDpvgn5MR0lZQ3pyby2MyS//0gDgiag1r+3dYlLfI?=
 =?us-ascii?Q?02eI894agTIapegkfqxdYTFX1R3UPPh4roeUpMb+ugoE4p0tSJhRsyzd7YfR?=
 =?us-ascii?Q?72qU9R/MkszfrS9JDP2x+pZbc/8U3E1jw/r5hKJ9yQLLCYOJjo3X9660ac30?=
 =?us-ascii?Q?rcW8XfmGYCJk0k5AcxiAbairQhHkzWcABguYn4UTJjZ+EJSPuHZP1vTsADvG?=
 =?us-ascii?Q?pLuGz/QjUNVfHDz4XGYm2dyklbHVnhem0353jKWwDXmBujiAptgh0t+hAinu?=
 =?us-ascii?Q?yEdd7HPjQhvU0LckLUJSLWhaYsjgT18dGEqbMpkkm5CXwySG8L4bWxJLDwzR?=
 =?us-ascii?Q?BjF7Z44SxD4w1VXD0KBV8FvktH1s20bQGDfkTQKiQ/wVR9trIiTW0lpfFZZH?=
 =?us-ascii?Q?PpTZUM/8dYvNzurRr+yvnzT94q/iQCTjF4OJk+EevLLb9fJJ6spV+BnrMoZi?=
 =?us-ascii?Q?rQbSMggvfAMu3VTjmzDn5pnHJPO5CLEc2rXgWNWj7BcYp/ECenbutIz7B8d+?=
 =?us-ascii?Q?l6FSHrw7ilkUYO2BwNKwgkhe+Fd5sd7lQg96E1EbIK3yaSAiPb/5u1Mq38m5?=
 =?us-ascii?Q?7ySGdQgI7KqIIZfdQ8w/ZFINwa1i6/Jwl0VX6z41sU818pXFwCWFZ/lS7iN0?=
 =?us-ascii?Q?NUJrOCj/1ucOHOHZZSbOHYyVEjs79smD+aTTf3pdkWkPxXUl4YMqT/gyRKrw?=
 =?us-ascii?Q?j42Q1/asAFjHmcQf7Dpy3VghwOH8w4tpcyNKgFHGPkmm5sqTTGlJTBwq1NGv?=
 =?us-ascii?Q?KEVjiv3bPMHIMrRAsZnyukr3N9GWp4TZ6XYI9N9giia7yVk8oUOVj13f50da?=
 =?us-ascii?Q?UfxECH9bhVTKSrpgESMIAyK6CkJIDFK+Zrd+IyBvbrULnKKg0NheW3SPN87C?=
 =?us-ascii?Q?0G0BSXF/H7HZdeEPUdrKqs6ugOKCZE6mMfwmNxFGFxSBrsAobKUBCheUb+sL?=
 =?us-ascii?Q?OMfyNvTH+m3CTi72Vq9lYKKTvdROZvDT7DHySA6r0R3il52ryLAJo8r+nrBw?=
 =?us-ascii?Q?Qig+U84s6uIcudXVU2VF4Vmk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cbaf747-377f-44c9-e96c-08d977f7e918
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 03:21:30.1853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTW7UQB0Di35TtQl4Q7tB+SOOIZwUg1ZsyzWtVPrS9heoR8Fug7P+n4QaMxehfY074mwnwWFIuZUptfZaOH/c6EEDzpIXTjF1SDvnhIQ3lM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5435
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=849 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109150019
X-Proofpoint-GUID: uhSfnUbqR65GvxBtWB-J3zT2xGEF8eP8
X-Proofpoint-ORIG-GUID: uhSfnUbqR65GvxBtWB-J3zT2xGEF8eP8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> The arm rpc_defconfig build is now broken on mainline.
>
> I suggest resending this series, please.

Yes, please!

-- 
Martin K. Petersen	Oracle Linux Engineering
