Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE849C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 02:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8833360F58
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 02:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhJKCsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 22:48:25 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:23198 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233513AbhJKCsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Oct 2021 22:48:25 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B2kK1J021646;
        Sun, 10 Oct 2021 19:46:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=hGM+Xcsqp4gw0y4pTg4ppd8lkU8i3H1xAqK05cWWoiU=;
 b=mEUTshs0/dHLJxb8OE41hIqRS7T1EpmX+vfdJc+8lljlCTYzXe6nkhPVFJtxgaquv8V2
 5g0QRvbgtpA2/L6U1HdXt58VAyTiqUxrJcdn6bYacxJf0uCiKredXjLkwBpxYAe1NTB3
 qwTfY6waLKxbFeCnEPlqqsWX9cGcUDSV7jDwTfs4yAPX1W7Ob3WknSQrG3r+pwGO5iRJ
 v6Y8WV4JWzQVZ0Ky4JSweiu49jk6Wp8ANAF9XtcDhmCWs/eqR/qqmeMBA5rUP4RIQMXv
 GdgF2kwy5CplzahaBH1vhR/td7gAIwsXbT0FRro6B+0QYLCzVOHWHNh3HRxwFUWnsFVy 4w== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bkyue0bvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Oct 2021 19:46:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSl+o4TIzQpgv/8uf039VLHDVumuI7urMYIQIDmrp+5SnDhiuaju7newRl3Rz2Hrj8RF8zKoJqSv1o2VV2EErkx5vUJekq1FJfUbDd3QD3Tqv9VwG1gy6ULuu4RIz64GJujDBEWMslurfPl+i08AVQY4ljBdg0Sjpq5+yGMgFwXLMnBnD5C+BkKx+D8dpN51pR2/ED7ftVU/wwjTluwMPKQ6mJKwYWlMpsN4Osq1DOjZHnP7ooUssA9p5AfSrRklyhF6i0lHs0gqi5XOeyAiy4ogFW0Y4Zt6UKdjMwLsnlO0a+yvDztH3oq+3qYeLU55UnCi7kE+//1jAKW3mCCtUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGM+Xcsqp4gw0y4pTg4ppd8lkU8i3H1xAqK05cWWoiU=;
 b=n0qrp0AfiuAuWe1L2DGXsSdUAR4ZRb4DXyJA9DCjM71tlJaKawgBPLoDmArXb3hW3h+T6NPM1hFUFrsH0W1M3Jw8CvSYVradM2tV1aab8m0AnFacdINtXIQd+semq9FrEQXQDzHZk5u3bFGxv0syDAOc83vudZTGq8mKOuZPe5Q4bH0JtYB+q0zkst61uoPodp6tmoQ3cFfxLYrI1FwmPE6PUzWtgu2uInZxoxIdN46zeA+z1XTUhP1h4366WI3VcsYkd7XT5YpIxA1J89jXEXeseoOiZ1CpRKKUK6KR6+5HHtD/olUs/TYogINUpe5RDkPgEiDU59imM9NJGOdp4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB2747.namprd11.prod.outlook.com (20.176.99.22) by
 DM4PR11MB5501.namprd11.prod.outlook.com (13.101.61.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Mon, 11 Oct 2021 02:46:18 +0000
Received: from DM6PR11MB2747.namprd11.prod.outlook.com
 ([fe80::b431:e0f0:891a:f6ec]) by DM6PR11MB2747.namprd11.prod.outlook.com
 ([fe80::b431:e0f0:891a:f6ec%7]) with mapi id 15.20.4587.025; Mon, 11 Oct 2021
 02:46:18 +0000
From:   Jiping Ma <jiping.ma2@windriver.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        scott.benesh@microchip.com, don.brace@microchip.com,
        scott.teel@microchip.com, kevin.barnett@microchip.com,
        Murthy.Bhat@microchip.com, jiping.ma2@windriver.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yue.tao@windriver.com
Subject: [PATCH] scsi: smartpqi: Enable sas_address sys fs for SATA device type.
Date:   Sun, 10 Oct 2021 19:46:11 -0700
Message-Id: <20211011024611.152626-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::22) To DM6PR11MB2747.namprd11.prod.outlook.com
 (2603:10b6:5:c6::22)
MIME-Version: 1.0
Received: from ala-lpggp3.wrs.com (147.11.105.124) by SJ0PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:33a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 02:46:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3158f7e-7b24-478a-ef45-08d98c614d17
X-MS-TrafficTypeDiagnostic: DM4PR11MB5501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR11MB55010E9C0655021A1463E689D8B59@DM4PR11MB5501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fywWYB5NqAnfpeovatqX8ZA14vp/IU2gjvBOeDnm6zrmpMITda5PQ6qMfDbrWBMyA9gLqt3Ayx2ktBPlx/KpaQnAu5rsEvQSUmY4+tqdyMAwv6S8Qz8L/JOrh283w5AwF7qhT9Y5AQmS+GecWcnZLzR1+y/K61+Nuv0UEdjAOoPEUV43fypuMpG5zlCYTzbbTArjwkjQnZmbOgiVMCZCSSeedA0W/is6+JtjcfvNpogMp6kRa83Jxh3iobQBFhIzQLYyKKPeiAY7m/zWbky8/d8Eo44OtYFrT/nIVCP3SkH2A4CqR6KogEIKUymD2gIx6YdKjNr/UKUR4iKdAqq5LhfLSmOBWKUJ4aPmH6p72vu9cjEEzj6e4i4igmMwixxwUAUBojvUKUx45gjJkobeNpbepODhxnCdRtcLxq+sHjxAvyrEmQdMKJh5duhinNtZrVY6JPFaCc0A4LvEVAvUBJ3bYhugZqyXcZ+MWpKq2jcM0LuObH1aB43yzyUxxDw5lkC+lHKMrnljzm7gHEBRxs11wxuFLv2eJ/IYKBdQp4OMAE93NR/5xT22/iD+QiuIZtBHLkMtk4gSOHEFzC5m5bkfgNkHUa+HkZ9uMMtNmUcQjKTjwmNkv1/AXwfyQzRxB1BiLzT9FULB9VwMmw/iwpXFct5bvxNgBqZ1ISicVFqRKbs2Ujg54slLC7bJ2eTNK7PiQKc1g8PquISmz24b+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2747.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(316002)(8676002)(38100700002)(66556008)(6506007)(26005)(1076003)(36756003)(4326008)(66476007)(186003)(8936002)(5660300002)(2616005)(956004)(6486002)(38350700002)(2906002)(6666004)(86362001)(66946007)(52116002)(107886003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v8fgzsFnMg0GRb+NGlkYkFYf+8BSWrpzNhgO6RlPNG79LmjITjV5HhJs8BNM?=
 =?us-ascii?Q?djszJYhmuoMG2VzD1VkiOGSKcfa7SfJLRnPDyS572RpyWh0D5N3Ch5uXIRSx?=
 =?us-ascii?Q?I8Tv6o8JZA3bPxkYPPo+YfulcwuerVbF+2Cxsi/MtRSw8IFyL9BdOBd8fzqb?=
 =?us-ascii?Q?ZZZoZWdxtb2S3LxRlVwrdW4JKajvCyyqbtqE5LE7/R3tpYChQn30IshroQhn?=
 =?us-ascii?Q?Lju8kisPmVnNuXwqBihd+WK991O1IeRtg9vo5IE/muNeRnhrJirIYH6K3xGl?=
 =?us-ascii?Q?ABFvPBXDU6zaONErqIyiOX4kngFzI1SbTZ91g0xl6PzZRCe7+VhfqJkfBDTr?=
 =?us-ascii?Q?ZWjYASv0fKhrmmSwfuHLMVOqgYcDWwojwvZHfXOdR6ir4BdEo5RW9QLJ4UyB?=
 =?us-ascii?Q?iAAYhbiJr8zpFfqyafPDfbKYG6UvkK2U33PcEUxDp6oWtPoPfRC6eBfaLQPt?=
 =?us-ascii?Q?u3spK1dHfPteaTpw0k052wTwHT2NcoTy8ub//8PwqnregwnBq34be8r/jWTd?=
 =?us-ascii?Q?oIcFircVx2taLcbaIBFSXl87ZF//dgQzSEPusSFl7ZiltBVTjabTlm/+Qn71?=
 =?us-ascii?Q?xGPyNCPIc7ztOBAwWw+U6IHe7xoS4dQ0MXiNWsSUkYCwl8NpRqCZWYIy2/rT?=
 =?us-ascii?Q?LTim1sL+zfhURAUm6ytrsDUUF3XagyjaPzJnM1mAvGFaB7khVazVsBddSbv0?=
 =?us-ascii?Q?CPboYUbBF9CNCnGXE7DxsFxaaOE4LSyB/LhDvlRKt92W+JswxPp5aXjerN5d?=
 =?us-ascii?Q?NdkApixgdFLYX+iWx7bOJj7EV6ds5txuU4Jyuu0UDzxgQ92G3MS564dO9s/x?=
 =?us-ascii?Q?w+e0TNnIWvNpTPPn2zehFGKwPCA5R7MfOOcDAqsW/9JzD5Uj/UeRkEYpkx9H?=
 =?us-ascii?Q?4BnwurWbIGOleXObcjgrcH1jBWF/9zhhYlFOMSoQjkKyV+uLUfQUKN28vNYt?=
 =?us-ascii?Q?zieicH5uU8+GSfF2Fkvnu7i8YzLwuj9WrxLBW87kYo+rP8ptYsjY3KogGHkN?=
 =?us-ascii?Q?Qj7P7tI24w/s/zhCpOR0AdbftlWEVoN7NRcUDjyoW910ZFciN5WNl5Sjw+QP?=
 =?us-ascii?Q?0xukoErjNFipOpqqNgI8WTmpAujW9FsLSbmfBQ2gjxlhh5VKJSNb23LoxYhH?=
 =?us-ascii?Q?u6DMAHROpydGlOWQQU4llnAMdVLKqofmWtaUmtncSX/dwUPGkylKZvnxGuLM?=
 =?us-ascii?Q?k3QZHQS1I2WjAGNwGkHu8p/mgI1FcX4Alfyhw0wNPtGs3W5EFJGPItD2CT6p?=
 =?us-ascii?Q?N4vNu0Wz2jl8Xf8I8uz4pIycm2eiC+ToiGqlwiX3oBWvT0Nizc2Tp6GMVin/?=
 =?us-ascii?Q?9h6RLKij7jDyyj45D6FISHRr?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3158f7e-7b24-478a-ef45-08d98c614d17
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2747.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 02:46:18.5474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmYSeXbTMGBtzmof+kswoxoIpbxjyP1ZPQJx0pkLfv8mcFIsvR8AJgHeQ1NOHi8my8PEay8GhfovjR/QwSyQFFi8lFXM15qAe89cnVac5yI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5501
X-Proofpoint-ORIG-GUID: 7dN6nTa8kYmIsTIIQE_c8sbKTwYWeCtS
X-Proofpoint-GUID: 7dN6nTa8kYmIsTIIQE_c8sbKTwYWeCtS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-10_07,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=986
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current version:
/sys/devices/pci0000:36/0000:36:02.0/0000:3b:00.0/host0/scsi_host/host0$
find -name sas_address -print -exec cat {} \;
./port-0:3/end_device-0:3/sas_device/end_device-0:3/sas_address
0x0000000000000000
./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address
cat: ./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address:
No such device
./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address
cat: ./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address:
No such device
./port-0:1/end_device-0:1/sas_device/end_device-0:1/sas_address
0x0000000000000000
./port-0:4/end_device-0:4/sas_device/end_device-0:4/sas_address
0x0000000000000000
./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address
cat: ./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address:
No such device
./port-0:2/end_device-0:2/sas_device/end_device-0:2/sas_address
0x0000000000000000
./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address
cat: ./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address:
No such device

After patch applied:
/sys/devices/pci0000:36/0000:36:02.0/0000:3b:00.0/host0/scsi_host/host0$
find -name sas_address -print -exec cat {} \;
./port-0:3/end_device-0:3/sas_device/end_device-0:3/sas_address
0x31402ec001d92985
./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address
0x31402ec001d92985
./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address
0x31402ec001d92983
./port-0:1/end_device-0:1/sas_device/end_device-0:1/sas_address
0x31402ec001d92983
./port-0:4/end_device-0:4/sas_device/end_device-0:4/sas_address
0x31402ec001d92986
./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address
0x31402ec001d92986
./port-0:2/end_device-0:2/sas_device/end_device-0:2/sas_address
0x31402ec001d92984
./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address
0x31402ec001d92984

Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ecb2af3f43ca..df16e0a27a41 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2101,6 +2101,7 @@ static inline void pqi_mask_device(u8 *scsi3addr)
 static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
 {
 	switch (device->device_type) {
+	case SA_DEVICE_TYPE_SATA:
 	case SA_DEVICE_TYPE_SAS:
 	case SA_DEVICE_TYPE_EXPANDER_SMP:
 	case SA_DEVICE_TYPE_SES:
-- 
2.31.1

