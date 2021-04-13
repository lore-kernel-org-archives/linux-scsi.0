Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C452DC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3D9E61221
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344723AbhDMFtB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56934 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344698AbhDMFsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:48:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jUPc010011;
        Tue, 13 Apr 2021 05:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MbI32z/R9tLyRQ7aTsEMsQ0WX0hdiZ/FUXqskqL7DdA=;
 b=bQkehlL1ouGGJIQGEil9WfZC1/53i4N8nj+SwFJRyaluFa1THlo82LRADuDPahR2V499
 XKJP7SRf7XcpGJsE97Wr7kC+ymB9I6fvSSwnCwNZGVUkEb17ncteqjPRIQWEK2u5+dsv
 Z/HRl4jsSmWd6a2dfrxClVVyjY+vkLZ3O5ZBDttc4brjG3Mz1HZkcBG48Tr74Npl0Rwx
 /KCTwF2gFkv87Omj0e44iiT/KS+wClJ5El6rOL+Yx7tBuX4ZXj08DjaRRlLtEWLg/5Tk
 cboUTbXSFo4QNal6IQgsvrm2s507LHN6hY5ewproYozBac2S2b4tk5d8dJd96uAHrYI/ 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbdxh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jRp4090754;
        Tue, 13 Apr 2021 05:48:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 37unsrxcbe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3cPvStpktpOxEIAHl2kIO5f9ssKYhc/yOYUux0jjeZsocdOj5AuMl/09itYfoeXdlRhjE6nGpAYC6Fn0y7Okdad2nU4ZQpaz8i42sIj0j2qEiaqW24wQllLGWeVUMSgTCqaVMEGhPvwftYLsRyU2Ow44oFeAO7UAF37aKdb9XkYSvenEQRnBOryA0l7XBU0gr+bPYWq0+XGpdWTMGylbqG40kPWhaozfTOjT1I0e6RjGKn1wg9LJbkTHR1pmva7mys35h8TvDqg6S6C/4QaT+YtnCf7W6PKHICYbTSU8SRbcd7Ab67zdLJ11H4ZXqVtxaXzZZSFWqp+TgHOPBTA5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbI32z/R9tLyRQ7aTsEMsQ0WX0hdiZ/FUXqskqL7DdA=;
 b=hsHa+yAakF7DEinFr0kwqJc2WXqkig/a6K+8L8Wn1QYOFKKn7YoB/vJkj/24zt2q+d4XaNKF+t0+A9TVJ6K9wyRdPlWpA/v2YOtMRf/7Z6XMo/jaAoFeD/+V9stcmdjJQcY1+lsEAW+zMzw+SorLs3iDIzDpw9KMjgaGzlXaL5LlceCGEgOVcyUetc61ehxQ8ZTUNVZDHG1Y9w2+3px1caJ2CITpkiIEuf3GAkDjtIpQIAOcXDH7+ceIKku3yCMsDb7luIws5N7AtHCyUBoEtHk2KAXwl/ZXDKnHFpyoDx3dOlPjl8oT0+rW7VDiNDEFUw3rLhu5oyyQP/r4nJtNeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbI32z/R9tLyRQ7aTsEMsQ0WX0hdiZ/FUXqskqL7DdA=;
 b=ITfL5bZXi0JF0M5GfSTtv6Hbs24a4sSbtuHgzAtYKZo9NzIGEU2oXhd9H9rS7czWTzSR8ekd418rVv3R+lhWtynyw1ZAIosXjnaDzpG+t1DzLzI9zXC1TprCaAdrpmalGdVdRGIYa85N2onvFN9RuCJwSUKwIVjS/Oi8s81RLbQ=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: Fix out-of-bounds warnings in ufshcd_exec_raw_upiu_cmd
Date:   Tue, 13 Apr 2021 01:48:11 -0400
Message-Id: <161828336218.27813.11353387019652050203.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331224338.GA347171@embeddedor>
References: <20210331224338.GA347171@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eae0da05-cdfc-47a6-0271-08d8fe3fc112
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4614BA78F8C232FAE969108A8E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:260;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtWzUzXhayxUJnJowO/cq5m/qnvtqpvdS1DyJf6vDVHciCitG30j4GYAfXh6RORCBLrhPHHLZ6HHpR1zIkENNtlLl2Ya+8OF6is3QCwJrO6IazmOwSUnn+43gitvVkEUo+rzCg7CodNk/BlYc2gHTHavQ13vlg8cc2rM39XU88uzKoaxqoORRZDePMAFteaT5j1ETDQCT/Xfdrz6yjjz1SuT4oFgwWO2uEq9tBJXOKwz/BltC46l//0jVBZo8Hh3LLmows6Ox5bo2VSykGA9eAbk9avZsJwejp2PUkb9zsF7jxBwuCcMEcTLYBF8Nub6EBM5PC3DdWwR+xZR/2hjq3eLle1tQJqoujXwIbz/nbNOBS6Z30te4GHfDOFKweKKgyD5979uN7fkoUqT3bjA4333axX6FtmWGi73VeX7V7q6VzzjOJrMuvsfzvAv5/wjbGulAt5sM573J6ajEv6d+8GeMRAJR5f+GClc+z2w09cT8CumyXO4r3MSXdsHV/BUH0Ck0gyx+cfuStCg7KxcurtSWgTjAOYmLwvkTZjXtLCziQfgBAn2K/BfPIuf1PP/0mZrwOTkvGiKDU4X1vxEld8V1OGYwkOGfENrNMCFpvXHRMXOxOskHBjI2ut3v9dxp7Lbjjd0orFxsPLe3uVrDQCI0MAng/X+vPev9H/p6GKYLfg1WOkiYnEYmUqGVg4S7ei4xVD+wz8p2WZa2H6DLTXZvSuWh1g/fzEwEPWAK+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(83380400001)(66476007)(16526019)(38100700002)(186003)(110136005)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T0tyWG1qUmdLZWxWQ0pHL3lNY3pUaTZLaVRZVktYVjNmbnNSdS9McE4zWjI1?=
 =?utf-8?B?MDIwMUpoWVNKZGkxeldXZC9XcXNmUzhLU0dxZ3hqQ0FXTS9jNUVZejVWLzFW?=
 =?utf-8?B?ZWthRXNZRWJxbHc5dWZ0bC9paFBZS1dUMkdxMUsrY08wQ3BIZ0xST3lDT1Rn?=
 =?utf-8?B?OHdWTHF3Zit0SEFpVzU3Zy9mODg2VG5pcU9jcE9JeTZPdFJGWkI1SllIaXZo?=
 =?utf-8?B?eUJsekM3bWZ0blFreUY1M2MxaG51WHZLbG1HTU1QQlEzaEgvQXQyNlNhaytY?=
 =?utf-8?B?VDErcXloM09OWFBTZWtMUmdFWGZ2ckN3Ukp0RlVpbVJoeWYyRHZHb0RUZU1O?=
 =?utf-8?B?eXJhcGVOTkdBVWFxeTlLN256c2oxR3B1dXIyaU5rY1MvajJ6cEduUkxoMzFk?=
 =?utf-8?B?a1NPdDh4SS9KZnJxMW44Tmd5ZDYvM045SUtNMXJ5Y0dzMG4xNXlBOTg3Sk9Z?=
 =?utf-8?B?eVBYQ29TNGF1NU8rNG9EZzk0dktCK0NZWGtuSHFqTVRFNGhKV29ZOEZ5QUFJ?=
 =?utf-8?B?NWUzRXFtc3VVWHlXRVRlQW5iVkUwdzhnSkJrZkN4TWR5b1VHckdCNmNmRkhI?=
 =?utf-8?B?OXUvZ3R0SERZZXgyM3g2bm0yZkdoTThPZFN3S2ZyWldYQUVMQ2NVejFJb1ox?=
 =?utf-8?B?ZVVDVGlXT2p5bVc1dHgwNXlWZmJvWTRxOW95b0t1REJrWlA0VXFldFRzV1Qx?=
 =?utf-8?B?bjJXL1VrQ2VldmVDQnpGS3JnV1pwUXJVemJ6ZXpwcHlUL0MyTk1Wd3FmaHJ4?=
 =?utf-8?B?bVFWWG5sL2ZlUEZjUGlpb0FtYmo3ajZkbmdWaGxQSzd3YXZ1SlV6TG9UOUJp?=
 =?utf-8?B?NThQekR4U2RTVnFtTmJPVGFTdGp5NWVzQ1dnN0JNSm5JK1QzWjRERy81RHVt?=
 =?utf-8?B?ZTAzRG1oZVRjVUJ1dFh0R3ZyWnkyUkJheW9Qbjc0a2NDQ0lma3hjMUVQelBU?=
 =?utf-8?B?eWJqelhQSGhtWVY0Q3Y3akE0MWdzMUY1RnVRL3RyMTVwUzFwSHNVNlFzT1h6?=
 =?utf-8?B?Z2R3UDBKNkMzd2QvQkJaWVl3VStsR1dTTW1CUmJaaWhNTWR0d2t5MVp2NTN3?=
 =?utf-8?B?SHRrN29jMVR1bXgwWjQ1VGZaQ2NwRXJXcTE3MVU3NHVDSjFlbjZKeFNHOENx?=
 =?utf-8?B?MUJjT2Y5MFU5TnhwYzkwdGM1L2kwRmpsYVVaNG1uQUJuaWhJdUlEUTZiVkZk?=
 =?utf-8?B?TXR4SW5XeEVseGZTcWVuNzFld1FpOUtKZ2RYajZRN3NDWE1JT0lnSU9kS29C?=
 =?utf-8?B?dVdSaktZdC9QaUx4cmptMDExZUEwK1IvRVYwNmg4K2xrcnpBU01UZzFwMndZ?=
 =?utf-8?B?UTdwMzBNbTVMb1FheThxbUwyRXpSTlk4VUU2bUFBQTlGaTFwN0xJUGRCcFF3?=
 =?utf-8?B?UFFKSFVtOWtjSEkzaCtCUEd6SVdzbFF5amV2VUFhL0xsNjQvRVh5RHNONnFS?=
 =?utf-8?B?WUplWU9STHR4REdhWUYyR2Z5cTVKcERhMU1KS1dVNWdiR2IySjkrODJnNG5k?=
 =?utf-8?B?ekRMUWxRK3dqRzRjSlVlUmhuSXU5b25jR2FKZDh4a3BoNXlxNTB4dGlsNmZ0?=
 =?utf-8?B?UWFUNkNkeU9QNFhheUVZUWFFMWdMd0t0NEMxM01vYVZWdWxUUitqTTJlSjRp?=
 =?utf-8?B?NU9TNjdBdmRzMldvRFJ3TFVPNEtuSnJJajJMSTloWUxFaVBLMFNUSmpqdFlq?=
 =?utf-8?B?UDgzZzRhYnZQb3FJSkpnRXJwVHp3WmsyQ3pXM3RORGtCb2ZpSU9Va1BudnZh?=
 =?utf-8?Q?sOldkjd1RWX/TWT+rX2hiuDuZhWP5XAlVeXwDWS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eae0da05-cdfc-47a6-0271-08d8fe3fc112
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:25.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: thaNg3ItGUbvdArZnd7y/SLWjUvrQigTlv2FNqR9hA+Dg5ekE5ycZ1jKWMY21cAj/SGoCUlmfRhXQOC87joHWvtyTByUdyNIM4EO1yAWxBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-GUID: EpKCBjkMRB397tyoQIPa1PLEfYJIREEv
X-Proofpoint-ORIG-GUID: EpKCBjkMRB397tyoQIPa1PLEfYJIREEv
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 31 Mar 2021 17:43:38 -0500, Gustavo A. R. Silva wrote:

> Fix the following out-of-bounds warnings by enclosing
> some structure members into new structure objects upiu_req
> and upiu_rsp:
> 
> include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [29, 48] from the object at 'treq' is out of the bounds of referenced subobject 'req_header' with type 'struct utp_upiu_header' at offset 16 [-Warray-bounds]
> include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [61, 80] from the object at 'treq' is out of the bounds of referenced subobject 'rsp_header' with type 'struct utp_upiu_header' at offset 48 [-Warray-bounds]
> arch/m68k/include/asm/string.h:72:25: warning: '__builtin_memcpy' offset [29, 48] from the object at 'treq' is out of the bounds of referenced subobject 'req_header' with type 'struct utp_upiu_header' at offset 16 [-Warray-bounds]
> arch/m68k/include/asm/string.h:72:25: warning: '__builtin_memcpy' offset [61, 80] from the object at 'treq' is out of the bounds of referenced subobject 'rsp_header' with type 'struct utp_upiu_header' at offset 48 [-Warray-bounds]
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: ufs: Fix out-of-bounds warnings in ufshcd_exec_raw_upiu_cmd
      https://git.kernel.org/mkp/scsi/c/1352eec8c0da

-- 
Martin K. Petersen	Oracle Linux Engineering
