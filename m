Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C6EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 11:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353986AbiASLDC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 06:03:02 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18574 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353989AbiASLC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jan 2022 06:02:58 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20J9WPDO012923;
        Wed, 19 Jan 2022 11:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=OnvMn4zEno5y9qYQtilcn0XNyocVRQ/T+5R054/HVbs=;
 b=byLNwF/FkLRJnJxwHR3bFSzfSiddbMi0Cj1M6XEa7GtHaI7SB3iQnkaXL7T9PCa85nOi
 L0jfCuADXtRXhWsLbGVeL5DYsK7ICnwAwNfaGltlYVQBmQSQIXXObk20u3kb6/kkwodi
 3RygSQDSb35rSfAR0yfskgnV+KGQ3fbb+jrMVG+TN/Z/3DMcO6lPkU0yKvR9GaS4+dOj
 T+EnY711Zj6rEigrQ2DBEwkjqbk8VoLA68RxeSKuiyRM+bZ269LU36l01NxQxb1BsON2
 4N6U0FiB4Nf/DXFJnTyTftVS7F73Lir0QvfsPTBaYZYBuG7n88N3Q3kxrfdIXxbb0Lnb Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4q4v0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 11:02:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JB0bDq070396;
        Wed, 19 Jan 2022 11:02:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by userp3030.oracle.com with ESMTP id 3dkkd039eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 11:02:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cV2AfT5Zyk+KxYUUz0scekXhhjKxxOhp3aDlnClIA5bCYfFP5XEKjklG9ftUykaR7qiTcbX+bmlZ9nLSCeVG4uRYinc0FwKyubLKXcf31uo7+/dkfs35FeWlDM2c2p224BzbjyB+2JhQFGeoUOnF+S2shEHLBLJgiGfDgGPtaofcoKOXqkex9TCpGH5j+ucnN4lra7JN1TmamPiEtDT1/UI6obiqnj1xR1753aXKnC06FoO+Wkgnte+O12b5oG5WgdMOqDoypeiBy8x/JYzQU3ZBtU6k7GmD3n8gPxAOQRUkM68GMAenHAeHtsPA0V2v+8kjb5wuI50uOAuhpxOsjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnvMn4zEno5y9qYQtilcn0XNyocVRQ/T+5R054/HVbs=;
 b=Lgf+ybSCjS6EbeDWxoBbXzYcPFNRtvt0uRgheeOddwdptBDI19xtEHqyvM8q4a3eYBLz8wlKYj+wQmOUC68Tkt7cZhixKuoUu6oG+gBAOt9cCM0/RmlHObhDEvWvV1mlY1/fKOjStihgnce3sUnl2n6J/zUKQ7VGqzgl445FWb+VUspDkhkFyqyv9ro2+jAW4Oj5h0+3K/lwlSUN7fbzDd/m/iYpb56E87xMaHBpBM4KHDnqYl2B+Di4mugs33YGzMdXdqAw8RhWAfQC4K7n0FGRzfWa4jihIqDjiHm1Ccnf+yYKfLXt//hL20AI76eFJDACuE1k/8WifKAqQv/7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnvMn4zEno5y9qYQtilcn0XNyocVRQ/T+5R054/HVbs=;
 b=Gw7lOhyEJYImuiCfm+EiNRqR1vfBVx+guVMczTMAbl6NNm2bTnw84OKBV5DSzF58MgrS8RlEvd5oNIYD1eUntWs7deHwxf1M4WbY5j/RJUvEyl+3r7Uxx4QOPNcPz38CM1VC+2uvegmkG5sDGTu+INsNxB7mMEsK2x7vNL8P4SE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BYAPR10MB2599.namprd10.prod.outlook.com
 (2603:10b6:a02:b2::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Wed, 19 Jan
 2022 11:02:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96%6]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 11:02:52 +0000
Date:   Wed, 19 Jan 2022 14:02:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Don.Brace@microchip.com
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [bug report] scsi: smartpqi: Update device removal management
Message-ID: <20220119110233.GA1978@kadam>
References: <20211210141851.GA18906@kili>
 <SN6PR11MB28480A37EF56FEABD76481CAE1719@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR11MB28480A37EF56FEABD76481CAE1719@SN6PR11MB2848.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0001.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9433b13-3f06-41c4-0a6c-08d9db3b3cd3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2599:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2599BED08E9493C9BCB033DD8E599@BYAPR10MB2599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A44JVId6giYLeXUh0eKIgWaL5MIZkLLCDzYLTN47bW07izXnmR6/jLJR8ksDGansOo8uhC11bsy8jYxy7EXeKAGRTbsiSbKCcYi7XDzOaZttmLCuxRU1Fj8029twsVvVEXYszxvU29d2PP/2l3XgswH9NVb4XXuZAejlLWPu/laEqLUaXCLQrT0LRPcFY9uAWX33Q+woQlGbdG1lg/azHgNe4vNeTsA+A7dR1lHFWMKa+0Lr3tt7nzngz6P6NFB/C0Z6NJq6KvvfJwrZAySqYx0jyBReOj9SoI8fbkIaoGl/MwgXchtzxzL0eIzt/X6ezuCL2WC2ASVyN2fEvOXQP598ZvsqERb7zHPFbI0heZgLZj40fSV3ihPXbVzpN3pE1M171e4tmtA6Qrb0Y98JAWoSZ6XxK0ap5wbhnxAk8sLZBP9IWI63KuAd9DrveI7SPyEdD7vb5EiiFtVnLkumj9gOCb7xl7+AjYj+Qax7KcIhazxLxHcyBLWFy7kBq+GeTLhtNfrhwFD6czOuv1Uaa7TT68cHpVEe5wpweN+oXzHewmR3TtUshZ8NDRChM2hiud8HRLuFqwxhtYlEMprTtbWz4tFyFnzmDL1zZ99s++wHMl92heb4X7lWasehBdRaBClpQ/E5lkmyBlsJb05vZazGgEw/t7FZnKIflczyI7vqNVoiDOS+zfZaXNQdvV/LGNI9d/9VX3bdF/MMBno1nA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(6486002)(52116002)(38350700002)(66556008)(2906002)(186003)(6506007)(66476007)(316002)(6512007)(44832011)(6916009)(9686003)(6666004)(66946007)(508600001)(5660300002)(8936002)(15650500001)(38100700002)(4326008)(1076003)(33656002)(83380400001)(86362001)(26005)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qg5dy8dLpyILwOAjX8sgji6u2StkaJi97pUaSgrQo6LX4aQ0aRO+bimF7agP?=
 =?us-ascii?Q?5jM2Xhg9QFi6ItdhJUWLML/xuQ4YtNHb3ujfr2/xWFB+u+r/70TnktRgbUHG?=
 =?us-ascii?Q?ZpTRjDyjRVYjvnEH9jy/hjVJ/kciIOppcma8shlkwoeKcedS6F1zzVXDdpOm?=
 =?us-ascii?Q?SOL8x46S5+YyyHHxTD0CTtsVCZKn+u7YvOL33+zq5uk9daJKnyeINTjJJ5b8?=
 =?us-ascii?Q?hogAL90wKxuJ2Yv93Nc7uGBCEJ6db71fBWXnYX1DO9CwboYS/eoPuz8dr9kj?=
 =?us-ascii?Q?TfFwJ1lXNErjlnuy65J6OD7msg3BhabKOuhBhgkUnFAhRXbC+VOglerbtrGf?=
 =?us-ascii?Q?zO5LnnXza/NiZ00c6E+tOE9leddvyRHXeDTA8Q6OzkGrnvSqnT9J9ei25JUH?=
 =?us-ascii?Q?ZPxbcVTlkd9ptB9eVpJYc0C9kMI8kj2m8OkfuPeo/qCfVdfRBoGpDw8mkflC?=
 =?us-ascii?Q?YMRJ0i+e/iRIFiDIg0aJUXyzJAkQXxu5kahZQFu7gGgcGLuNLiYGFszrwMyg?=
 =?us-ascii?Q?OUhGgQVLMootHBJsQEFhJtzlQnG1nYaxgxZKkzb1vQTLN1tpG9PoULbK0l5c?=
 =?us-ascii?Q?2mTg+WGexW52MG208slHDaR31/iG/OjAv739maqiG/oHS8VifLiwsixlEgkW?=
 =?us-ascii?Q?1XWdpX85MN0dm/571w0kKjtkq4pnxFSa4sDBvvx9zEchgcKW7foJPNk6dInJ?=
 =?us-ascii?Q?J+wpvgmfiw9H8BMYuQnnTF/nVwXA3VRgeOa4TcPZzbWcE4CHjq+i0VjeNsMH?=
 =?us-ascii?Q?eYaKzwXei9U/4MA2FxLGN8um7/abhlJBs/FABjYSprx9QKkbOjZHJ2LmwePD?=
 =?us-ascii?Q?8NI60rMh7/qrk+zIosRyN6RjnIgXgkinxOoRCsnjdL4s1uIz9F7s8Mp5USHD?=
 =?us-ascii?Q?qjThTlntgMUNJX+tbk/iXHeuZIM1k0qipg3hSX4qf4De4tEP340hWgSF/0MQ?=
 =?us-ascii?Q?GWrvcwM4Y4MFFtEPEtZKj/B1fB1ZS2vmLPS6U8orv4T0diArUNLt88PI9iO0?=
 =?us-ascii?Q?AgrLVsUv9mxZENRnXgrztc9az3Uhm0L2BkyVv0Tk4OrrgYbKdtBzNfQLKDEu?=
 =?us-ascii?Q?MsFAbA0yQLxg9kfdFSjibzQCl5BToly/Cqk+V+sE6+pSSgBoxiGV//8lwW5i?=
 =?us-ascii?Q?mZm7C0YbK6tQBuM9dfRnrnCT3A1CEQ4CBT7Fr2JS0sc2fLshYlbrLSQthxzw?=
 =?us-ascii?Q?ySr64J3SgnUFIY8FeIB0anQxqt7YlNL2ADD4vQ7/iEceJSwUp07CtnVlSrXX?=
 =?us-ascii?Q?t6AfGUcLAesHK3EwKpAkKXGu/F+2FBRe2s0GiFwLQGaIH/n804NieWfeeFpu?=
 =?us-ascii?Q?jHS9cswGlvTKxqPkBjkSUlv/ajznevC0MROzh5MFUhduQjkyoqneje9ldH33?=
 =?us-ascii?Q?qoj/oDLzmLOmLy+VAuVqEDbxr1U8iWAwRhU7D6v/rgIEyFfXaAcf3hqN0bk/?=
 =?us-ascii?Q?CSoCrrJLWNbcj+iz2glu5CJBv6agnxuOFyxjRqN5htFvdpUfkCD34d1sWbP8?=
 =?us-ascii?Q?OrQgWIocLcFb0IoUvRbFbMa1N+GHxCJtXdlHUN8aTF4XMsbA2BQaXIyJd5RB?=
 =?us-ascii?Q?GqDyqJav2ZAcPh82BNsCGdYF8uDyIEvnD1tNQN0xGw05JGU6TvxxH7eG/9xv?=
 =?us-ascii?Q?9oDBUV0bI/ra1XK2k8hzoQqOKiCDZ/2+HWij0p8XLs1t1sYdTcPHFc5tL6ob?=
 =?us-ascii?Q?TiQZXFuLznUh9Tddeu8AnzMaHaI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9433b13-3f06-41c4-0a6c-08d9db3b3cd3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 11:02:52.2777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsVhifr+qR9ne7tkjRM2/bwc1+EtYkC8KQFWyvl6BFFBUoxIXiVJV0PGDZEA2iWz/OjOjw8YekJcJSMatPI85b+NNYa/eMpm5+UsDYZLy9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2599
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190061
X-Proofpoint-GUID: ePRr18ELP9UgqsqIyu3FU0s63sqdchRs
X-Proofpoint-ORIG-GUID: ePRr18ELP9UgqsqIyu3FU0s63sqdchRs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Whatever happened with this?

regards,
dan carpenter

On Fri, Dec 10, 2021 at 03:09:37PM +0000, Don.Brace@microchip.com wrote:
> 
> 
> ________________________________
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> 
> 
> Hello Don Brace,
> 
> The patch 819225b03dc7: "scsi: smartpqi: Update device removal
> management" from Sep 28, 2021, leads to the following Smatch static
> checker warning:
> 
>         drivers/scsi/scsi_sysfs.c:1463 __scsi_remove_device()
>         warn: sleeping in atomic context
> ----
> Dan,
> Thanks  for checking this.
> I have a patch to correct this. I'll be sending it up soon.
> 
> I am waiting for 1 more internal review.
> 
> Don Brace
> 
> 
> drivers/scsi/smartpqi/smartpqi_init.c
>   2510  static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   2511  {
>   2512          unsigned long flags;
>   2513          struct pqi_scsi_dev *device;
>   2514          struct pqi_scsi_dev *next;
>   2515
>   2516          spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
>                 ^^^^^^^^^^^^^^^^^^
> Takes a spinlock
> 
>   2517
>   2518          list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
>   2519                  scsi_device_list_entry) {
>   2520                  if (pqi_is_device_added(device))
>   2521                          pqi_remove_device(ctrl_info, device);
>                                 ^^^^^^^^^^^^^^^^^^
> This calls scsi_remove_device() which takes a mutex so it can sleep.
> 
>   2522                  list_del(&device->scsi_device_list_entry);
>   2523                  pqi_free_device(device);
>   2524          }
>   2525
>   2526          spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
>   2527  }
> 
> regards,
> dan carpenter
