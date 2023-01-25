Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29E5C54E94
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 00:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjAYACW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 19:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjAYACU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 19:02:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9AC23336
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 16:02:17 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKtN63025718;
        Wed, 25 Jan 2023 00:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : date : content-type : mime-version; s=corp-2022-7-12;
 bh=roLVC0xkSdebQ5gvxd8icunYyh+s4hQZfJAaC0ancaM=;
 b=LSrDqTaJvYtOnsE2PG1MxkPur9rJuV25QfYRwWbA6kVUjskMQLu4ki9vSKMKVUUUSxnq
 AfKIUw9SYILSrlWcxd8wxc66EMhhlOhRYU1biP43gDCnjowRkIrLkMBE3bmuqPEGILWC
 GtjtAhKR21D1IFNKOo6F9SGNsOuUbgEvYEDcwqp+UpD+gzJCqcV3uOk3Wu/EzMbrRVhB
 SE4bigy0cvktK4XzF9fKhm/Z4sIFGPKTUNATy6uRrLa24y+doGQgoeIrjFqe0EZge0pp
 AOz6A0Z0+W11pLBedBaYHpYJ2iZa+viEQIYs+nx4XgDv4vrd0l08dYE0o6uqqgZpzDEA 4w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u2xv32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 00:02:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OMWkGg021040;
        Wed, 25 Jan 2023 00:02:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gch5yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 00:02:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDccZB1reki3mX3LUdd3g/PQ9Nn56hvq8+z/AzAtV0+UvlhoVOBK1xYa21emxfyjTV4vQUwTzrr9xQvCf58Qo7YlEf2fP1WHfGYUj2YqzBSboC4p0fJmgcGPPLkhesQMjdeKFgRM/cA2f5lJ8j7yxGzMcjC6mUkUE69HcHIQrpyH09xALCnsdOl1VL83wGI8WWnDcNYe//6HKlVujSNY/UBtzvUsKcDDmdj9gN4wapLIaCrkJcjzpoiuEIgT9q8O6+EESPmwldfzvK2KlQRUO4SOEOvKRbM0799GQvHDY647NyoUDkYkWfqXMj0KV2rr96rjWUttniR1a0Knwos2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roLVC0xkSdebQ5gvxd8icunYyh+s4hQZfJAaC0ancaM=;
 b=JvKLOgtUJH3YeDxtZUizF30Fwj6TdoITTNElsIcY3kDw6t8efbgB+qDXH0du928NZz6D3bY6F19RtodeItmMoosUNWIDZ7pujaZssT2qKCDi82YgLPfELfrYhTar9cVFBriV6psWsVyBAPjo/9+b0VpqRMRiFbXy/Y7P+i2AZM0Wh8BUlCI8T6D3NOjcRjUsWp49hhAtV/VqEiloTqSYbgSTlmWO3/4YQN/y+nwwA/MfEx+rPtUyNuyzg5/I5Cpv3UP6xOOOnzGZvU7UDpbxMksNJKFKvTYdX1Z+q7/RjBrvyvOBrPQtCspX1VD5fbMz1Cbu1kr24S85RSgotFK1Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roLVC0xkSdebQ5gvxd8icunYyh+s4hQZfJAaC0ancaM=;
 b=p0f9ienzSdoDfxETtNsBAFtOfUezhSOSB4Uxkoqk6iSV/At6nDpmPhBpf1Dds73tzLyQdO93hLogR53N2RAAFK9k7FQllK+sQyFu1rljCIk8GQ2VklV/OItTpLXFoCEQCWT3AvfnZZ/sqVqmTA7216otz053qwyr1g9CPLLDSvg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6410.namprd10.prod.outlook.com (2603:10b6:510:1c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Wed, 25 Jan
 2023 00:02:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6043.017; Wed, 25 Jan 2023
 00:02:01 +0000
To:     linux-scsi@vger.kernel.org, Li Zhong <lizhongfs@gmail.com>
Cc:     Wenchao Hao <haowenchao@huawei.com>,
        Andrey Melnikov <temnota.am@gmail.com>,
        Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Subject: The PQ=1 saga
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Message-ID: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
Date:   Tue, 24 Jan 2023 19:01:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::48) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6410:EE_
X-MS-Office365-Filtering-Correlation-Id: 095077e8-3e45-418c-cc5d-08dafe67623d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qpF89o99b/si9lM1YCGJcKdiJeKJVcbGFnchwOeQsb0tKx3SNPe0g0fZTOjygJsMzKt6PoQCU3fzuZMJ/rExp1Jht2xqHVPksZ91pG8jSv85SfpjBEa+0jGDAiuumS4Az0316SXVZR2HoAcm7umAKW9QqB3xP7WNGrTyMuTbtUC2Aq9GcHEOVmaD2YWMb60BkrhihLv7/LdaZPCkkm4qUQieQSPC3umLjNgpQvdNuPpxshcOJh9iQTt/K7ja4vHbMyJ8MxBmT8/Km34dIaxuyUYGCrvAR5Xn/yVFqImEVbiacSnvIwDNXHUiY5psYTFufvH4dnARbncQ841s2+qX4wGGzjjGJc9tQFhzWc275wBQdahdT+wzGgMs5L9FeebPy7jhpxL+uFRelXGwU0cqYwhl2sa+ldMk2uNHLcLCyYizXKNI96buKDCcSFqU0BmN5XDUSr7z+Sp0wyvGpD7E2DPMCcQztikRDhUg2FQstEhhQ0A3LWyfP8d4iaku1vvGbu+vCepRKVKrGjLtmSjyZM9S81fmhamsmv2Dfnr/SQc9uR/yno+sV/RJ4SVsuQGZLOrt9WdERpgaP3zcECUAZ4tlFyZ1joztsKE4sPye/k1S//CiZLanOJtyglKb7bitnkY6gw1zAtNrNQ7eCM65g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199018)(4326008)(66946007)(66556008)(6916009)(8676002)(316002)(54906003)(66476007)(38100700002)(26005)(86362001)(8936002)(41300700001)(2906002)(5660300002)(6666004)(83380400001)(6486002)(478600001)(186003)(6512007)(36916002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1yXPvEtu5Ge++T5tysx4c3i3Ex8ddCfAwEuAdkR+/oAoqgP8lEzS+fexIGjf?=
 =?us-ascii?Q?61fN5cENFdWBp9CaEbtpDsnaONmTbz/nA7wQsZT+cSiYkXCkH4ADnQO/rasB?=
 =?us-ascii?Q?WqB+iq+7UHICDrq6rOs8SYZiYUS32YEXZ/6ipB6M4xB+z3xrT+D7BMDuPLwk?=
 =?us-ascii?Q?vnsnjDcU+VdGjDRS63pI7Si10YfN0b2eI/+yx0F58XLyx11lqw/GgDSgy17F?=
 =?us-ascii?Q?6520JutWg75ziWbEAuRZ/+2n6wFNByNDn94QGHDQ0Q9eUEgyFaS4kRu0YGll?=
 =?us-ascii?Q?vHTWUlM4tJTeT5magGltA/9aE+IV2cDZHYqrlO3PDp+7QX/BDsMsXZGf7tD+?=
 =?us-ascii?Q?MJ2U1IVuz+ycyWYMR/d/SDHfd5ZmgE633zv9wopkU5IBaaO9wS5BVBQ3W1/C?=
 =?us-ascii?Q?oywtW98Cd11ALBgWqy1JTnDKRbDpjwu0gR/si9pA0xy/Jp31ecrDjYbd4wue?=
 =?us-ascii?Q?/a1/tksKxsI6eZUPToyamAEJCP1YLtlKxfgr1494L7htK2/MihzOAv/IqMF5?=
 =?us-ascii?Q?A5j0rIqw8+o6TK96QP3VcOdL66UPPJZpavQ0KcgwOzzyx/eTH1Gn0um7jlpu?=
 =?us-ascii?Q?EcWdMpg46MrMhylrEVCO+bvTNXARQvJXl8n9ImWGzm8OpNT8iru920ak2r7O?=
 =?us-ascii?Q?5d1FoTZzxcfSEZ0wNfM5IAC+cmUXXB7Ffmm3PLMprDtTJKtsaX+0idvRN7FR?=
 =?us-ascii?Q?wdb7znbXBKMwbz3c/lPAbdp1jHDN71PzQlwuCgJSSgNjnWehYs6rI+jC9Zk4?=
 =?us-ascii?Q?ifLfEm+XMmeEROpkqYLLkuS0s7uQ6vF5AQLO8y6b11tiorvcR60/zkVn7tLA?=
 =?us-ascii?Q?5NiGOYNZD0d3nwzRWVtNRVpOpWlYvsfCaCaTN4jTxsDWfVNuDzSdfSPU8enJ?=
 =?us-ascii?Q?yhA9xg2tft9izlgqKZvSCM3nF8BlI6LKSaGFqUyvxkE/mtJWS5ZH52TIKRHI?=
 =?us-ascii?Q?n5/7MuU/II4hr/2GKk7rbwNcwIU9x/4EkJEFSWmeXeP62jnT6oeUmeOyFSl1?=
 =?us-ascii?Q?9lBD6cjp/6bxR4ohDkW9vROKby0ddbkXyeUaQgIPiwCnbh9LemwBxj/g1yUF?=
 =?us-ascii?Q?leuTH6cMs/I5LrMUlR3mGPAv5oJJ65RixaxClTwAtDOvCkoqXfg/uHdpUxmb?=
 =?us-ascii?Q?i5NHRkAbBZJfI9rMrhJ46bZhRwHyJVSPkAsGdEg3mwuXTDN37mopkkPvIypT?=
 =?us-ascii?Q?Hxj0vKEQQwxV8TbSaMthpoC1+3JEGhxLUdAOR1MDBFbjkfd/KfUwEvQ0VOyT?=
 =?us-ascii?Q?/A4j4GGdticDA9AIeFTHnfiUWEAwyWcfkoxTXnxmdvZkSS2bcC67dlYSR3Ef?=
 =?us-ascii?Q?9ybISp5hDQCWtGUx8sjCIQjKb0KRf5okYpNmSXHQv0JYxlF65tUUdSoYWDIS?=
 =?us-ascii?Q?X59Zc5gUTTY1pyWk/vT/+lWlS0nALe7GYkEzkWRfu0cTDjqXrocEqYCfACjW?=
 =?us-ascii?Q?E45HUP+Ou5AeJgw3KwFOuEdYXuKw1G+r1KL6uF6ufX1VqpXdpSwi/c9nwBcQ?=
 =?us-ascii?Q?kYbbnF+GCakIk+ErTLZgrjIL3NTOMS4Zdle+lnfJy5gF67/Nt+VHM3Ycan/S?=
 =?us-ascii?Q?L7AJZN5KWS3MkRZC8LtBz7/FdCPeLEANCuqaGmIAO/jWSazzuEauCpdQ7Jf1?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 66icTbs9y93FhOidFGjNHQI9ggnOvQlQ2Za63EVNMTQB5BJxY9ekHV1AAEZ5xvJN8uLX4w1X66nTPbw18irnHW0R4QziS5lrtqtfcz50SRaKZAhTypUTh8+oPlJlfeHbSkhY8SHOQSq2Bz+oMYTdq3CuuXv3j34yKMCNPcovjZICD3Dp4P0g6Ss7yc2JX+dYTTq0UGAY3tGzAWv4c6Qqvb68uEon/wMRSJijG6fuScPCYXMx3AxIJP2SZ2zaiSiEdBqcKC9oxd1/0GQ5sJv3sf1gzQwJRhjYthwpzUcJzbGdmX1wB+nuiXZFkAbINT873bB91B+gKfhPCV4NlE/1ZXXo2k3KTjaVzeYay0ORcj+YRI4PoqF+ubvs3TanSqcLnuf7XtSk/ns3FzXx8QGJr77VrYHHujtCVAb9QLRxR1bEXC6Tci3933AIl6LA6awqejN7Sncx+ZWFu4q3ovGKTJrYsXU5QOamJZzV/pxVQ/rO967hDRva6N4uksWZrAW8+JV5W4597PbWtgGDyoaA+Seupfoszh1cMzpqCcpNHY9YfKUnuu+wKyJom+8JjUNqyAwooTFIPAqnX0/8VArSLHAFDHFmEWB/9OhixI0CsJIe9nSoUFuoCq09H84flPkU3ttMBxLOgcGQLp+tp3JWvLEwU1b8VkuabysEUnMoTEglLZzY2o7o03rPPJtaB1ym+EHRk56zAUS02Q997N1+4ZZmc8IxS48lAqT/xTuIh/mlVHMaFCdAbf1mRc2uzznuge4VTWyjax8yZxt3PWjaLyEOQK0MiB7m0esMyubObMkSOnk8vTPt+dsm/70cEDcr9KOn9kDUFPvP+ui7PqOctZyZPtkzs3SCPpM1x+U8nnzN6iy6Hr5ptOZ2ssrP7F05FLXavB3+nbN57fiS6QpY3Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 095077e8-3e45-418c-cc5d-08dafe67623d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 00:02:01.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KBhiXMYzk7ulgDr4eaLP7HauN865eQld8GYHHBNVzm6rhDJh8ETShNTKhC3BPA6vTXCmq1wq0zwa/TTMUmnAY2W82kjLdy7mpzqeN951IQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6410
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_17,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=781 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240221
X-Proofpoint-GUID: EDwZCiYta3oUR66-2QtvGOMqWC7DZb9O
X-Proofpoint-ORIG-GUID: EDwZCiYta3oUR66-2QtvGOMqWC7DZb9O
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


I would like to revert commit 948e922fc446 ("scsi: core: map PQ=1,
PDT=other values to SCSI_SCAN_TARGET_PRESENT").

I have been spending quite a bit of time digging through old SCSI and
controller specs. As far as I can tell the original Linux behavior was
correct. Recent SPC specs are very abstract in this department resulting
in unfortunate ambiguity. But originally PQ=1 meant "LUN supports this
peripheral device type but no physical device is currently connected".

Based on this original definition, PQ=1 has been widely used throughout
the industry as a means to avoid associating an ULD driver with a
device. The LUN is accessible (primary commands, etc.) but no media is
present (no physical device connected).

Our original algorithm, which I would like to reinstate, is essentially
the following (in slightly unrolled form):

        if (PQ == 3)
            /* Don't expose device */
        else if ((PQ == 1 || sdev->pdt_1f_for_no_lun) && PDT == 0x1f)
            /* Don't expose device */
        else if (PQ == 1) {
            /* Expose device, don't bind ULD */
        } else /* PQ == 0 */
            /* Expose device, bind ULD if PDT is supported */

I would like to understand why -- in the case of the IBM 2145 --
exposing the sg device caused problems. Li: Can you shed some light on
the problems caused by 2145 LUNs reporting PQ=1?

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
