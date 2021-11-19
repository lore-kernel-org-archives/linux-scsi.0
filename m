Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA52DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCBAB61B27
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhKSDAF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 22:00:05 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51984 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229678AbhKSDAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 22:00:04 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2MfDi020976;
        Fri, 19 Nov 2021 02:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=FMMvwTDnLR1JmO+JaQ4u7J4n43ZhO6iyvOF0x5v6DBc=;
 b=zSXEVXnm21x/UEgvqvdvdmA01ANg2ASluQdyAXw1s6pqj2DWLbD9ndK4WmussWT1wnBE
 5IrUthvvssM3K3YwBp1Nc4bPLVxINJLpY4befpAXhrWlaI9tlwQQ7SdQFUJJA6dNuHwU
 3gnPchvxxwyonRrUnyooRPb1JyZXhVB245QlqxiPDR8O14cmOaGOVbKSOf1IVGYFwiv6
 orcAvbeBqe36rgyKVLflPR2McMxd63PNwvFLgZ7nYIaUNYp5dXaADLdotsOWEX67WVMj
 bIFE9DYUFThkPyrE25paZ1Te4mkLggxl1yxcVx1pC+yZ3XJoohotpbAVJXg1cQ1TKi4V CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyu58g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 02:56:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2pBcn174618;
        Fri, 19 Nov 2021 02:56:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3020.oracle.com with ESMTP id 3caq4x55nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 02:56:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuqG6h2J2xeFO/7i6K9Rc96bS3XDqyucEAsH6F7mGxtDyrs+vQtECGRYp6gKaUBN+w1gCRSF8GW6zW6EUaPbexlEsPxTOXz5Uhgk77tg7FvnOy2hspTrJ5jfYHKMX955GxuYHdSaqVnhfPE1HrSTGNIiqQ9KnU7kEkcUPMaVUWHaA8CXmpRALSFnsp4Dj8pXlPbHC834St1cmshgfl1e9jXd8J7vtTxmiTMjoPBNt3R84sMBunSvy7KMtPF9wEq2vwNdICmjIJOFBgkArP6m32lBOfcoS3Q8DHtC5mZ0D3mmE0QevQEZaoRFl4GxGZT3nkyQhpSXwyvepGKWf9iuTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMMvwTDnLR1JmO+JaQ4u7J4n43ZhO6iyvOF0x5v6DBc=;
 b=UAZzMP8Stij6w0Bg0+G45C3UKJb7t8lZPXeu5hIhQecVM5HEdWaaN1oqHH9DFfRMZDnxO4ZUMOmk03IfvDgbs5gXOSDnjc3UpZzC++vCWmxaPtmNkg7rudu0qov16ssD1hHVXysA9a6DIlXEmdIsQ7JNjDVVkp0k4E1kqHoK4kAXE4HkSBe2rzUUsFmDQkBhcg+q3or4OdRw0fL2zG6ZBlK+GMQji6z/QawA4m7TZyNi5Sn8V+NulCqxtMtk8Qk0aSsqqVOPCmY1Zb15tXtNyq2gDrILlmawLy9qb1LrsjHYYr7Lj4CxIkbIGTXeWQ+HBeM6U152XQsPeGYWXp0LGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMMvwTDnLR1JmO+JaQ4u7J4n43ZhO6iyvOF0x5v6DBc=;
 b=V3nF/p+aLAadc4JZ1gxJypv4Lagd9AC+7XKo94c8lj9fLETc8DBIH2+dV0Va2Nmqj0wbqpSEEixFjAY2qthgVZf1iwKJurmBiH1HDyZ/qaFOMRjF+q5umtaa7F0pzTM8dGSNT55pLRls8ddelGWTd8wkiuegOlzfJo2k+h2yeto=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5625.namprd10.prod.outlook.com (2603:10b6:510:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Fri, 19 Nov
 2021 02:56:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 02:56:56 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Remove Scsi_Host.shost_dev_attr_groups
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6i07t00.fsf@ca-mkp.ca.oracle.com>
References: <20211116223115.2103031-1-bvanassche@acm.org>
Date:   Thu, 18 Nov 2021 21:56:54 -0500
In-Reply-To: <20211116223115.2103031-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 16 Nov 2021 14:31:15 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:806:121::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.14) by SN7PR04CA0083.namprd04.prod.outlook.com (2603:10b6:806:121::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 02:56:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37594642-3037-4f40-5cc9-08d9ab083f85
X-MS-TrafficTypeDiagnostic: PH0PR10MB5625:
X-Microsoft-Antispam-PRVS: <PH0PR10MB56257DAC67532B2CCBF0A60E8E9C9@PH0PR10MB5625.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUPKejRGu3XJmu+j9fQGct9dByOcMsI7giaokSzbaYqQSdVIJ/X3jn+jPa8e7UsxjUFbaThuNaR6+l4y6mlI7LRfK1QNudZNn6wJQbAt91YUV+8EWx15TKzQaxwqQ+Q2ASB2cuECWZLer4agbd9+GzXf+MrZYWEdWTgoGHZigcIpXT6pDXcuIOa/pPVpNf9sdpQKENBzzUuv8RcyksE4oo8q2+uy1L2+S+72rwp7Gij5czyx4Rj3or+k89AL7WJ5tAOCIhonl9uwiXjtswtc8Cuv74OF/1fSdtNy6m/UqOmLqTkT5GRDBwX2HTqy3a6tmaLyWMUzceD6Df6eVt2nlkJ3K6ILeUs9UosYQpHbwVaBxBmhKFdcY484LdnS+777X9KCYGcJThWEsqwLoQ6Nl3QPFQ14nYJeuRSr8c7+ZGEnELBq/HkySLKcWZakeg7v7tBTW2etkYmoyRwuvTO2qb9e5ErchYRQqd/c42ecVn+8EN5px6hxS/VzxPRB2GdFsS0Ff8BkYmboAk7K+7D25hl3sjLbRl9pgHldzTDsAmVjqsoY56QITOpZprjweNbProrIokAe0xIYexFjsdsmLsOzoZmqX8dcYq7dT9TEc1QI7TcyIjF34zBH7J5vRn59J8NvYtru+BBKVKw2IMg8W3ypDi03MzggqzTBERUFRr+RNJXkUokx76RwUE4YIKgwv1F4xdxxD2PP6vbKROQADA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(7696005)(956004)(5660300002)(86362001)(26005)(186003)(2906002)(508600001)(4326008)(38100700002)(55016002)(36916002)(52116002)(6916009)(8936002)(38350700002)(66556008)(8676002)(66476007)(54906003)(558084003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k9ZHtEGU+yeG2P0R1YaLvq4TF9yvd5uV8Nfem3oANWpUvVkCRYu83+/9Va1F?=
 =?us-ascii?Q?FgUAvGHyfPB6XlJwTEMp9Gei1y5MUQxi14cHxPcXEPppdmsoktMNbJdm5UgA?=
 =?us-ascii?Q?IIl1zp4PfVRitOy9W+UbXXXlkfgZOBSz/oijx8+Nlu2kea3mCcwz9G9smzHq?=
 =?us-ascii?Q?EmB0xzpQRhnmXprxjbddd3zUcfVIX1S4xcRdyF2+im4WMV5Utz5AE7N44QcX?=
 =?us-ascii?Q?JDottZu4L+EodHRSiZ9oXoMj8Bt9++3IBT78JBo3LHDIouaMHv7SUtbLqubf?=
 =?us-ascii?Q?d101S3wLghd7a+0Pil6dt0I0oRQJRx6dzxINpmBM88b2aub3hG2lgiWX3/BT?=
 =?us-ascii?Q?7X0YEHKjLnPIsKD90eTCO58E/Sq0zyaRjX4xv3keSHI34s0GipzxgongSoow?=
 =?us-ascii?Q?C2JRPKxxuIBGKJn2jUaBIDynJG+JttlQzrYsrP5UjF/wlaK/h7kUb1D18mq1?=
 =?us-ascii?Q?VJc34AwesXT/0yMhG1RydLDpAjlEwNvJlgo7vyimVQWq8tdChKk9yuNHjLk6?=
 =?us-ascii?Q?hnV0azAXjvFbxtahmwSSnAfL1SeRd8ilctYYpGOcR/q5sMq1Q4LP/wfpOoOa?=
 =?us-ascii?Q?kC3WjOIDn3jNi6q66IEZQkXiKtFMvk4MJVOhwzLtbBG4UDkG4+QlQEHWj+C2?=
 =?us-ascii?Q?JbvRaGjbYg0e805B/iOtYhBisjwWWgw8wEtgcRJtJJxDL1ZHrX/wDKoB0WXm?=
 =?us-ascii?Q?ygusOvUIyNPdVq2xrcFhbTQK87pVqQXEH0ylwnmdaL4C91uGdFlw+Q9h4R7u?=
 =?us-ascii?Q?EuV+Bs7kSpiUJI5YKeWtAXOQj5N30uWCrtxkwqhbu+Ae/O6RAJJn8KAYq5y1?=
 =?us-ascii?Q?a/8bneFtNoP3q0JmrwwZsZfngu9hMhiVFlSXxTIT+JEMVKoumD7JHDUriDYb?=
 =?us-ascii?Q?gw6KVmpPh3x1pakPwN4wIHlNMrsoMwOr2pTm4MmuVIaCWxh5BbrJZC4j8b2B?=
 =?us-ascii?Q?18B5mo8h2tif3tQpJsxJy+WJvit3516YbprxP/NIHniYtHsR4z253RHoei2B?=
 =?us-ascii?Q?6UOleJR8KDNYIKRPnvOdUOF7qOxsn8kGSPH7gqihHrj0xXa2aeER0W98JJUb?=
 =?us-ascii?Q?Bwv4Cwbysm75MeI4uU8EtIRW+Re5a4y75BCxhEIeW0E6CpmMMUF6f82CuW0H?=
 =?us-ascii?Q?+uWrTLF4B902dZnTMkjcZbMI7J4r6cyKSV4rH2AP6IABwJdLyp7+2cTWIp6T?=
 =?us-ascii?Q?pZJxZ9QxFUF6y0VJkR069bae+rw6yWoJltlyiLzo/X4Kzzk30RlvuHofoHex?=
 =?us-ascii?Q?wy06c0rmtS65ScT7aGXE/gudTTBBiYL2jBROljN76i/pa6kATdw8CxXHOcEh?=
 =?us-ascii?Q?qpdZtZf2ceKMqKHbSS3QzGXOvHRvuVBqoVB5IiBKuH11MmV9oKJnlqSB9Yr+?=
 =?us-ascii?Q?XQrV0ZItNnqXmkV8bjG6NoX1v3ItWIFv44h0yXNU5vcEFWTUW4t66kclrhuS?=
 =?us-ascii?Q?kyniuc/AQbULUFwuh5SYqdX9mzUhYo7LfT9t/ydkTv4TOtslsL9kmh5ukQ8C?=
 =?us-ascii?Q?1dmXRixBiG14L50KSlWbvs1cAsiD6cE9OOnZpOH3ohS1b3jALANnl9BoSUgf?=
 =?us-ascii?Q?rZpGpEUBaxxs+XR7HPN0Gn8/cheRsj9nOt00CghPooDs8ygdW06RaKmsGv48?=
 =?us-ascii?Q?suJXBH/m76CQ93uj8QULVncD1aogdii0ZnD9F/iVXPq5P6560eJE88J/TU+T?=
 =?us-ascii?Q?Cklj9A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37594642-3037-4f40-5cc9-08d9ab083f85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:56:56.4563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kdE00RMOMXgCsp/u8gFdLD4n2E+cwYArD7UzxVZhWhl9/qK9OJTjSOAhZ08/cZ82qZFc4FiOi/YYF0T852VrBMqNdBUhXYczPniLaKG1Hg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5625
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190012
X-Proofpoint-ORIG-GUID: fSi7Rmi0OkZDXs8vzdXefehDQ1mmiUBz
X-Proofpoint-GUID: fSi7Rmi0OkZDXs8vzdXefehDQ1mmiUBz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Simplify the scsi_host_alloc() implementation by setting the shost_class
> .dev_groups member instead of copying all host attribute group pointers
> into the shost_dev_attr_groups[] array.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
