Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B61C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 535AE61262
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhHXDfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:35:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64936 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234377AbhHXDfM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:35:12 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xE8e011513;
        Tue, 24 Aug 2021 03:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3EJrCh9uXiyw1C43OL5ODpmfJan6R8fYH9a+htAJfrQ=;
 b=CTRlj9BfDchQ9/00zFz8nCktli6rkMWCz12d6NLqhATuR0/jkkSN1+wXOo6dOxxU2gb7
 EvGz2JE3cfxzkWPi7dPowpcU9OrJY0l3m2MqYMxv1vw64lFUlGteWEfjJFELEN/jcgA4
 nEOwue8HnmQF1ENS31uJTZVli/W1Dq6ZUSszaI/oOHg0mYpquHyg4QsHUXAColRvCKY0
 BDDKb3a5VpTMB8Yamg44CmWeg3t/WQkUWab/y7eyyLrJN/UyRtfeqhaJfounMv5RB6xW
 pkc1nRaN//DLpyvioRtEyw6M6w9pdXmeuezvbRVxEBWO+QGilXAuOctIZW3QpEPtkF15 tg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3EJrCh9uXiyw1C43OL5ODpmfJan6R8fYH9a+htAJfrQ=;
 b=A+UD2b/9Oes7Dg8Vn61SXUfRurszEccciHJndCUtEdmuQAB/jFpQ6rQvoJexCTbUs1fE
 3GblvJitI4MepgZO7lReRG3xle/EL88sWQ7nd/EQ1IyKZ5FUdYapWLt9QA48K0M/TV1l
 wgTcyHzS3z7HuQFA/vR2jycHJhRJR1py8FA9FujuCQBnxuPoF9cZ4ljJCxtiJATp8MFM
 y8qlsDX0pOX81Wp6FdqrebtJXc7elk5icBN5/0tsjbGVqoUQGg8rOcsxfo3kr0SPsxLW
 sZ0jYHFEYVuzsLFqdLX+wqqKnoyu1KD3tX4ZI3ZUGGwizrnpxiKXx0bYv0ahr9u0v8hw aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwfm362v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:34:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3VU7S190813;
        Tue, 24 Aug 2021 03:34:17 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by userp3030.oracle.com with ESMTP id 3ajpkwf9mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:34:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOVQ5FljgOIYG+ysbYrXb9DAGmfucoxsdM8QwkytIkdk0RY0QaTY8PSaRbu3+zcPMW61X+tbYn1RZB3jQBxcjyzr1JM4/WyxGYyTVLzfT0CdlNwdsXHWlPR+y+KUzuWA4M1byD2A94UCzSuzJjTdhkjGbqPwH/bKYpsciXHh5Sa2anmAHHK/whowFLYWT2cCDmVHcZet2WDoiz99BzAawf/rOZybbkeyqjSNwxiVKonpgOBWFHNjCYo597gdhMfqiXh89PrigJLZYe6Jf9CJGOTMlBabafEQ1GbhwKzy4+u4EcfCH7xdiiNOO/5uD39/q6irEgo6fO2SGE8/B+ZdOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EJrCh9uXiyw1C43OL5ODpmfJan6R8fYH9a+htAJfrQ=;
 b=gxKOAw1ysvVeigDse6Q8McOOaS0sawFb8hKtA3TNbs3+oaaYe5hLFjjniC9fzhQU6dx9V+Bdna2jqnxUhzz6sVIpzH44q+SYopSvxVtv2F1lCUov/3QO0apfia5RKmcpBUA79SYO0oIqh6kxhfAgVbKSN/7Ag/5neiHi9F34cbl2uodwXfTkYF1fbySB+JAjq8eW+d11r7sljJ0VLP8PT1ImbfG1ud0jyau/x+h8tUufSQCNdgv68EukynDZx91XbnvGMht1AICt/1ODqmB776vzF703V3o78FBvOcCady6Pmmb0DWU5jnjyxgToTAZDLikzaF9e6p+02Jspa+isGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EJrCh9uXiyw1C43OL5ODpmfJan6R8fYH9a+htAJfrQ=;
 b=E3T/hdVKBqShFTWiGd05Ljp/V5x9XZUpmmVysRvKcF62wxDDsGKK8IgGq7vLa/+dv489hRtrBJIpy//Cx4LtnPFPCzJ9/yGv3YrLAj3V5QzXMkrx3nfnV6jlkxXlsfSTvMoZNXjzIU2MlMb/Q/jqcHWGROzrkn8nha6XCcK87To=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 03:34:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:34:15 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: Fix ufshcd_request_sense_async() for
 Samsung KLUFG8RHDA-B2D1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yvvect1.fsf@ca-mkp.ca.oracle.com>
References: <20210823050117.11608-1-adrian.hunter@intel.com>
Date:   Mon, 23 Aug 2021 23:34:12 -0400
In-Reply-To: <20210823050117.11608-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Mon, 23 Aug 2021 08:01:17 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0121.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0121.namprd13.prod.outlook.com (2603:10b6:a03:2c6::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 03:34:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1619324-9ac5-4f9b-01b2-08d966b00be4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4759934C5EF15352080A95938EC59@PH0PR10MB4759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rswZDuHExDzN/qy+jt+wJE+46JltocdIsqSvfJoQqVz7hq2qpSCu/BnigmlQLaNf37tcY3e7KGXkfEsZlrMoQbyDrFtexgab2p1vWmebBxn6Mp7qh6Op6/yFa0nV4dn92zC6HzoUehwJHvWDAYrAyxRXa1M1Z934r11QgtzrYWzgpbw9eP6tNX4K48DxfVCNNxo2xv8qa+m6WIgftXFe7p1pAuwOSWqOehetCyMEgkci5OqnQLqgLLLslEUSeMs7RVOUghwIl0AFocA0abNTNIkQEfJj1/Dff01X7jHdUC65ATI9nPxMCpIJvQ1j23z7xBX/PTZ0qQrqAA4RrkQ95Kxy+IE9zru9VFV8K5Z1DawmVJATkQDOBYQfMt21BfLcheC7A50ytslbcPXL84fwma0HcJlNfrqZSUw2hyIgHrDTexkcTroqqgH8R5iEpDuC345hEExXhipJgkw2PRZdIWwm3hIRFdjKl4NwC7/T+nrzqRV+Uc8Jf1yTtyb6DdlDH+BKDpZWNwI8Kd4gJZfxz57nrl/S3QceaayQgXeSxcHXn3W70inQjBu9NvLERL46bpQHTcWxhDMpnEFLF6Ud9U4IzE/xHvFt06qkfiN2unRyxCRbmRRiumIQmi4qpi8mDn/xfOLntFLsmGfBvDgXs/y6ZA+lAXD1Eui7clTq5T81IuWTE59XiByL4j+RTzL1mjUWggnLv3vBo0FOIUEj+u1WyBr4Any2Air+CZG5zA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(4744005)(36916002)(52116002)(26005)(38100700002)(38350700002)(54906003)(316002)(478600001)(83380400001)(86362001)(956004)(8936002)(186003)(5660300002)(6916009)(8676002)(4326008)(66476007)(55016002)(66946007)(66556008)(7696005)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4km3EyB5Wxzi2d0uGRLibjoHuxQ8vrQ5rsYWk8nVC6/RaL2U+/PbNDTqZuNW?=
 =?us-ascii?Q?+np+tcgCBvqgmS+uxJnsb5U6K1Ypi9+oTtkNs2SypdBI6keIyzzPuwKgAtic?=
 =?us-ascii?Q?lJh6fRGRfYpaQGl6NNIXhR8AXdnttewv+ZH0RM7LEhBhBcqLEwRW6am0Tdy+?=
 =?us-ascii?Q?Hrh4MPeTaS1ooZveeDw9qBiCliZ4M4w52b6I5YrXT7IZJQ2TSZASTVSAW5uN?=
 =?us-ascii?Q?pgByraWRA4iEsTybL6J1qKvb5K3KpDwh22KH/leel9N1ynuJulmXT/T/9+cy?=
 =?us-ascii?Q?mvF/3UQ9Yr6eNbb6EN31pRhCm4e9vHVJ9L07CT8de+3efONfV5KUex4RqSfx?=
 =?us-ascii?Q?MtitpuZqYMqWt7jcnA3E9yOBl48tTiPUmZ5r0+XtgOtbc6GlKTJ9mCF+wEGH?=
 =?us-ascii?Q?kc0qVXdKquKzy+Qkxnb9s5tvktCyAm/OGHrOzYQ9E0GtoWEZjWb0897Djiar?=
 =?us-ascii?Q?Q093PosWt5QGH+83MNl4lwOnWETO/w6kICIRNrbVNKr7Bzu/+lhB3Y9suTfr?=
 =?us-ascii?Q?2vE742FyoWowK6+oQF5V/IvcxL+2mpUeTsLNATwLxS3mVJ3U5VbfsdCoa68L?=
 =?us-ascii?Q?l1CuGdY4X0aTSEpblg+mClN9mFpQcgXrj90aOQEwBAyFn1O23lQLHxN/FqBS?=
 =?us-ascii?Q?PplJm1MgawyYyBDIDIpukcyXuQOQyxc+NEeWux8O1DJb26SIHSJa0pFkoJXE?=
 =?us-ascii?Q?mndX1zCdVmDrWME3TiQFSl5K8HgAlrT8PsWmEYRyQ9hTxRUVmmWgxRy5H+lk?=
 =?us-ascii?Q?A4+Q2si27usaLjm7XOEgRMvS6juSuvikEf3q3/7v1FoVncS8kmd3ij+1/1o3?=
 =?us-ascii?Q?av6ceFdeO7T4YqU4F+c2IOgbgDH3fCahfHlTvuKhvz3xZ/KwCHGLHIxqxWN1?=
 =?us-ascii?Q?VDcLjz8ghFTUd0C/8NwuKpbJz8eTQNxoGh+uYlAI0q3j6j5IfsMvXCLSxOFD?=
 =?us-ascii?Q?35JUHVqa4myDTdsL1ZAn3M52MX70aODGe8ECmC7i76mlGu9RS8mdmrPL4Bmo?=
 =?us-ascii?Q?MtztE9SpuyCPMFbpprZ4ejd78Dx1E/5dgDlUySNrsjn1y/wq427dS+VkyJO/?=
 =?us-ascii?Q?sBrhHO0To8Z1j3Ar3DqAuksgWFWiaXZgsQFkn06I2lsMvkjXD+ZuXgi3f2+4?=
 =?us-ascii?Q?H8PO+iJDWIHHPo/wXjcKyidZy2O0oc4HOEwADtyzQaEqZ/+WRxjBMu6xernN?=
 =?us-ascii?Q?U3qQHY5OnTSIk+pAQesK2jba24ZKM7c+Os+HW9Ll0/Uf3VCTVwEdUUrw1Azx?=
 =?us-ascii?Q?v5dXIFmHsv2KDv+aKlPLMqJ11RE4Zehux2mXUqEH8Ye3dl0xV1U2g+yQyP5q?=
 =?us-ascii?Q?AiuFMYbDzbaQMNbrNDcVO3jr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1619324-9ac5-4f9b-01b2-08d966b00be4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:34:15.0540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ofpiu882hVLrM3RPZmLWzQGoFtTuXRgcOqHU8Uo2MYcQ51IZ3PXjNYN2XHN3AkynE/RyGp47fiTi4BM3cjSVnNLz4HdcAAQHqck7dnyssM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4759
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240020
X-Proofpoint-ORIG-GUID: 8OCtyqq1uH2MA9-BjHZjycqLmMui4jxN
X-Proofpoint-GUID: 8OCtyqq1uH2MA9-BjHZjycqLmMui4jxN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Samsung KLUFG8RHDA-B2D1 does not clear the unit attention condition if
> the length is zero. So go back to requesting all the sense data, as it
> was before patch "scsi: ufs: Request sense data asynchronously". That
> is simpler than creating and maintaining a quirk for affected devices.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
