Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C65CC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06F5A20719
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhA0Fiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41506 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhA0FDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 00:03:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4xKtu119316;
        Wed, 27 Jan 2021 05:02:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZoPMxbPp/gvqNiOJHorTB05L/ZMDKjusiGhTF/NiA34=;
 b=TMGDjs+LbXklzqmFaQVOr+Y2fVh8wa4Y8c1Nwx6s8K6MaWueUrHr52IfghgaLMFb1X6t
 a3dDwnQjg1tIi8Q5ANECbSGqj/3NEnKSrGRckz6KJGES5IL4xXJ3vX5G6ffBLHXZEcwV
 FgXnm+2dEhRxEDr1Tpcy0+xzuLS6cQS+WRDHFQDCYHSXPfrULMOQZ2o6H/MM7ypeukFk
 D6jf3MLk+MtxC1fXk7Tx5dlplPO7hN8mIgE9XXAQ5r0w75Bl0F5vagg5mKKXGOS7r5Zm
 FFbh5mbcYtgFc7Y7WyiSMr3Tks62XPYzq7aA7Mx3WwyH/iYl8aTnc2jT0u7oeFzYiEi1 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aanbu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 05:02:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4p5N8188855;
        Wed, 27 Jan 2021 05:00:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3030.oracle.com with ESMTP id 368wcnsr8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 05:00:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQvN8eNvFFl+7rtEKh9RmY80Cc7rwts9hJYKKvnAbbh/WY0uOCFrPVhCMxrcSCWuuGcw0AVU9OOU5GlV9MmjHplV0qMP8UEWF0A1ItEBeX4JXr+yDI7M7DqeVqKdWZLGAW/nIfMAbmhA3eI1vw/wIu45lhvYqXHDa7ba5Ay8JFc0NQyzVklj+5Q3OgjbziEjsgych6krzbND1mSg0UTEZ3VwceskNXUQjUdnzf7zz6xTgmeaJO5fL3Rdd2G8yHEtews4WyDuB/BzyYmDGcNWAOtUc7VqQWGDIYBd5KbKyvVAILj+pLfWfLs3Q/jPDSs1eEqxIY7x6ZnXwryW/VMUFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoPMxbPp/gvqNiOJHorTB05L/ZMDKjusiGhTF/NiA34=;
 b=kg/aUb24FD5xj1WaK2dr/Zc7Gos74R1AKk/sLS9FAQeKLPV1ydffIHH3SO/19EDAht8SWRRvmjotEowQWj8HIERIXs3f7j/t7LARVZ8fP9kohjdzDK7gZL0yvlfRLgupAZj1QatpSR1Rs2JUJ215+kNGiDY7mwiqytoHguBfmo+v5xZmi/XMjqE1lcZvFXVNVfu0IbvJgREtLDtCg1Pw6Rn4SQ07Sp5fck4epuU3fcW4Edl+UujcwxnTYBNwUKAxYqFqGkrW8ZIfo0oLF4W446m0K5jY/ruf5wqSEEYbaNqENl1rChDZ6bdaGP92BJfNFIADc2WJFQIILfVcrhw7HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoPMxbPp/gvqNiOJHorTB05L/ZMDKjusiGhTF/NiA34=;
 b=m5NiPDQ/kEAuHhRFqwREpjh6JB5e4GXSA0Dsyv5hGoU1xe6LoCa8fNaylfWLo9gKyz+qkhC0AQrmN99fogqysBzICXK6lpo0rQXJtHbq23pqiDzAUirjW+1c5UWxpyexj31Zm/FH8xn337Vh4COOVs4dIla8/V9sy24oHgjrzZY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 05:00:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 05:00:47 +0000
To:     Patrick Strateman <patrick.strateman@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] st: reject MTIOCTOP mt_count values out of range for
 the SPACE(6) scsi command
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8hbf02e.fsf@ca-mkp.ca.oracle.com>
References: <CA+-=Uwah2MS_aD+PeSBkQa_=1wCD+3=g6W4PvLnbJ_-px8G97g@mail.gmail.com>
        <yq1czxrqai6.fsf@ca-mkp.ca.oracle.com>
        <CA+-=UwYTKhvEDSq3pZgpoH1N-Tf8Smq1cRE+J7t3-A+SCeYaYg@mail.gmail.com>
Date:   Wed, 27 Jan 2021 00:00:41 -0500
In-Reply-To: <CA+-=UwYTKhvEDSq3pZgpoH1N-Tf8Smq1cRE+J7t3-A+SCeYaYg@mail.gmail.com>
        (Patrick Strateman's message of "Tue, 26 Jan 2021 23:44:23 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR01CA0005.prod.exchangelabs.com (2603:10b6:a02:80::18)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0005.prod.exchangelabs.com (2603:10b6:a02:80::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 05:00:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f55a698-fc42-46c7-037a-08d8c2808244
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584601011722DC5CF88AEFE8EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2kLAi4dTAe695Ix+RfYT4jF7Wl5bQ1HIniGy7it44GhsltIUu1vnuIbv1cblxPxfh0LxlrrHkTzBoQJYBiL0U/eHjLJQcJir609Y0Ioln4XsiGrEJ7BbgK96FxAkTH1HPmpTAu+Qb+0d6xbaU/uGrbjSe5BekXo0TnOcA4RV3dtXkyHhw95HYF9Yaz7iw4f7QZ2BZUHLBC5csdB0i89OuV251MVQokAGKysWpPcJxeIXBkRV/kVSypFqeKbwdjvO8NLj5O6LRzwjoEDFi4BjRNIIc4wvstagXMqZMdRQXriGfgYhpyyF8Ifim2hhtIGWX60i6trKF9cpi6FST2ZZInkp2i4/sLkDIewFwN+jLgJydMPvlnmwf13CJnEo3T7A3NuDDxqBlFzAza19ur3cfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(6666004)(16526019)(4744005)(26005)(86362001)(186003)(2906002)(6916009)(55016002)(8936002)(5660300002)(4326008)(66556008)(54906003)(66476007)(52116002)(36916002)(7696005)(478600001)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MzpjZM9yBbmoPPP9CalsA+YL9guLqMC7xPLdXcOojKDcW5sYASynQbJZK3Rs?=
 =?us-ascii?Q?KoVWmjXZhnlSAaqY+qrIxu7W5sD1cdwjdLlN9mKyr15fZJP3JeY+NTP4RVxW?=
 =?us-ascii?Q?2y3T5NPxMZEbMum05CSM+cipD6P+wd+21JKXjTPNyRz8OroV8pZrFLcY2a+r?=
 =?us-ascii?Q?q6nUp/NqQgOgpOpbQpFBfGPMyjYymU50I1QtWtpuMOwYZWdJFg7MmPV+KtJ+?=
 =?us-ascii?Q?lx5SdU4Sk33Jyav6uxB9KS9VjBipfWxQN4ML6auODU8ltolHVKZ4zqxrQQ4J?=
 =?us-ascii?Q?iGzlpNPPJ9IPEP0GMMlZfax0FSEUA5qeC8KyMSr7/25DM3xeI2Bn0dMJZnn1?=
 =?us-ascii?Q?cOJxgkoG59BjBAa8DjqO9B4tSaCjJXfRaGRqw3wDUjBd+Lw/wWWx7Nzt2ZsY?=
 =?us-ascii?Q?lTqCHdEdC7tVhTxDDtY90SgaFE9wXj0dgVm7RVw3OGOztaA7EH+RFf06HCFp?=
 =?us-ascii?Q?+a/FywA2mae7Ic5bM/HMVeXbQJbfcl+c3q5pAkSf15J83y107wQj7yPzwy3w?=
 =?us-ascii?Q?ZB+bpjb7Zicc9V8/w0koFKVGCeTdN1IoQPRlBsZHYt66LpaZef4CVm1XGQJd?=
 =?us-ascii?Q?Qq042eNmzY/XJ1xdORnx6dYy4T6wpGJuWtc1cCwE+MFP8cXZNvBjvVecKsYI?=
 =?us-ascii?Q?Lk+RWiVgI9BEqsEIWhimhKkS8r0MiRSxp3bszoKBp+XBJ5uUhBoGlToXwsxB?=
 =?us-ascii?Q?RK7mV38k/20aBrYOlUZ5okJHtYzaPLvhMk1yHgbDbpcZBhU75el1SiSkMqdj?=
 =?us-ascii?Q?TloWhKBcq66IUUB4ZvtEGa5/p1Wq2/R6x9/n5m49vBZTGQN1y9Sz2vfFFOI4?=
 =?us-ascii?Q?Lzp8/oK/1nAcrwaBRYiyfJuQxCKbnaUFkery2U0tsaHaYjFxfWg6ESPRK8j1?=
 =?us-ascii?Q?t09EY8rrAZRsHzm4f0E+/MoRiWxnGzh4zyg93wDCeOd98XEEj3XhCaRXc0ze?=
 =?us-ascii?Q?Aosq0tCZC07CuxpBnXYbVkf9fhyNVPk4lcv0zw2jC24u9yzsHOVEvSYM0fIW?=
 =?us-ascii?Q?7HsyJRqRQGtguqFuE5/AYx44mgcexLrLA/3vP2IhUn8MZkU39BEz/gkURm/E?=
 =?us-ascii?Q?AF2mtEQD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f55a698-fc42-46c7-037a-08d8c2808244
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 05:00:47.1277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IhhfQzAoDHRfktd6t/3wn7URrdGU1TNCDN0FDT0oSgU6T5ZvQbhqqo1FSKXlUHiprZ60C8t8HT4hMYyoA3mLu+xCJLX1nc/PX1G3IgwuoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Patrick,

> I believe the opcode for SPACE(16) is 0x91,

That is correct.

> but in include/scsi/scsi_proto.h that value is listed as
> SYNCHRONIZE_CACHE_16.

Yeah, I'm afraid things have a tendency to be SPC/SBC centric. Feel free
to add SPACE(16) and make a comment about the SSC vs. SBC distinction.

-- 
Martin K. Petersen	Oracle Linux Engineering
