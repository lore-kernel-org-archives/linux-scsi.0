Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4115AC74A5B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 03:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCQDmV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 23:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQDmT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 23:42:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFA96133A;
        Thu, 16 Mar 2023 20:42:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32H0dZRL026768;
        Fri, 17 Mar 2023 03:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=6uMvF5hnHC3m6dL7qrdHjhbxqlO1Hk559SqaLgaV4Q4=;
 b=o/R6E2NHLB7ZiFKqI77GxGh3ED42cKexuSttz7tSxGiyY5dPmV4RGgACXxtGmZgTVIVB
 kwuTtXmMu0IWH7H+1elx0wiGlJyAaZgt49iRVdJO2pTk3fmP4OjbnS9tHzCZ8FS49GyT
 r+x5dgu/mMng0e3dIPlMf3XFGdr/7F212PTrUVOMLub4UyjSARe6nKeG1yobghuYtvyJ
 fLkLxPPUONL6zSQN1Ndyylkdsdlxy27UGhiFlscO13DVv1GbZL8uZHlaqSsiVo5j/FYP
 WQoIUnn2ik7U5GfTR7BagKfKQFJ4cS7AjlGASBGhuj1s6hdMgTiEV2LNgxI1EUw97LyI OQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29jybg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 03:41:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32H15oiH023408;
        Fri, 17 Mar 2023 03:41:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbqm06wgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 03:41:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpp/xD74R3XlN8f4o5lqpwAXllicNCQD+nthGett0iPHsrTu211tNp+lY7jWQuRSYF5nBEIzlFY6YEF4s5499VQaFLxv2oGajNKoNLOufeKNr8Q0CnizWWCyYE3UQc5/QodBk4Q/p0VbUDHrphtA9f7we5C2t5X24ZaRzaJCBG0XcB0iO2ZnNnyLxgQtUkmwb6A9mqAFbQr1E/XwshrbYWg4U2vxl6BExoEXadHKJ71uWsuVa2Wsa/sQTuBNcIwyKarUsLmxIl2NpR+e9v9mwqJucW0033yXJK0/U4Gt2v079z0oeZRA8kbyAAaWLxsw0tXzSIZTJNRgFBpb+URaAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uMvF5hnHC3m6dL7qrdHjhbxqlO1Hk559SqaLgaV4Q4=;
 b=W+2/V0MCWF0C7DmU7mlTFBoBbMbzseeUavczHrw5qdk7P2ciwNmn/Oidt8EfRmsEkNXe9ZVn1av19LzlBaNokl/V9tXClGSuhZR8mZYKJj/dTkGYpxKFZwYAGNoiKMrFa+BOlgt1prpaVfeZA8mY/KlBnihOzqVjkzuVwLTOTb76yi3V2Tyken6cRxP9ZfsAxs94y+Far0d45uBqP9gm+oqe9blQGerD2IT8WsDHRbJ3wmuQ8ry2zGn8W84QCNoldkkPTToSQ0oEiK6wskkHZ+OEFyLgWYcg1JTXq1mgMnd2qBE61XRT5OBNjk+X6g3DbvyBMoLc5uvvkzemysDSwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uMvF5hnHC3m6dL7qrdHjhbxqlO1Hk559SqaLgaV4Q4=;
 b=CXFSIKPLgMX8xkNDIQrSobkqNggLf9xVLcsE5C+luCBjdcBG6FEJFw1r33JOu1uamphvIxci/8CvPGR5cvzPM99Vn2BQgVw6u4gTvvYFUg78th8XM3L3J9wHKJfa23ewKlM/WOK/0Z1wWzTOQPeQ6n2Gh55LvEPUMkzqYfbL49Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN0PR10MB5935.namprd10.prod.outlook.com (2603:10b6:208:3cd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 03:41:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 03:41:55 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH v3 00/12] add virtual remote fabric
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkksxcwf.fsf@ca-mkp.ca.oracle.com>
References: <20230313181110.20566-1-d.bogdanov@yadro.com>
Date:   Thu, 16 Mar 2023 23:41:49 -0400
In-Reply-To: <20230313181110.20566-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Mon, 13 Mar 2023 21:10:58 +0300")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0068.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN0PR10MB5935:EE_
X-MS-Office365-Filtering-Correlation-Id: cc13ad96-c70d-4075-79bd-08db26998d62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aq8Q4B2azSaX+t1Z5H72qWgHFcR/LXoV9ciaBXbBKSGs8d+4ZT/RBJIsVSDcAlNmIaVA5kbE5RXbrEjWfpHtKJVPkMTsZn8Ie3vN4cjqSNnsBN3bgBkCJrORTMvUhDRokJS5MHqVP/jsMxLkU85ZYqUUC/+M93uQKUAha3X7pqcOPhjtMdS1et9PhT6Vpaqvl2i/kbxyzxAJaKmEJTM3rKoi4pCnjDBpvFR37wZ4FtN0CfK52aJtEoHxJ3UAcLJlSauUFpPtcfgAEuZJRiZpFyeA8jZslQJWWFcogiDThPjysx9YTEBIUKiuGZsCl+VBmX4RwZXiuLC5Xu2f9SGOloUnhr7JX3BLm9ugx4rooziDjxzbJauKlVijITzkiZME0NkNs9epLapREzbyBNJmw5Z1ODpWcsHY2x5kfoZSc92+BshQsyLGTIPzAECZhBTPfB3Pfc2HPZseIz6GhRFRpodb2tfwuKrmxKL2z5r6kz9gtnN+kml553p+0nUy4oxIYUQgOGeGOV8f8FzW3VI2OuuCumkDjgJDh7/6VqCrIMiZz5hE7pBk9FyIbCw+kq4juYhC0TSmw+Dk1boGjE+76dIOFphr/MFrwrfVJReTv7NscTkfThqo6l7P6RLw5OGBW+6jy5Y7nv613cjrkkmKzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199018)(4326008)(7416002)(186003)(8936002)(5660300002)(26005)(6512007)(6506007)(6916009)(41300700001)(86362001)(316002)(478600001)(4744005)(2906002)(66946007)(66556008)(66476007)(8676002)(6486002)(54906003)(36916002)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eIl3C0ad49PeKQsOItOdlNk/saStqgq9Bm7L1KcpSGjI1kDsIl2mowmGdXzV?=
 =?us-ascii?Q?8uzmSA3VwTpTcvz466svwFo1eQ1f1yiCddym1b3hLoHhHxsH1w5IQV4tGip4?=
 =?us-ascii?Q?3TU2HKjCPwkvrHMEOcT0GhCTHXwtqKmmSXhOm+DM8PlnePp2UGN30Pnb5wan?=
 =?us-ascii?Q?vkPop7wu/jf40G+SHnvMFqhozPYRogKaNgfeX+9UqdCb3rzi8niqeSDOs6pE?=
 =?us-ascii?Q?6/s+6HcUXMOkYl1cq51nTnz5Fyy/bBmn3c+akbaJiIhyG6emst16ENizZ2Yu?=
 =?us-ascii?Q?9IT6VEBS7AZWQoHnuxpzMDct6WCPP+aAa7PYsII79G8qDbyGmaMCqtE+tT5f?=
 =?us-ascii?Q?kQ/2U85gWp6f0rA61AMDgj0KvfaRe+tlmd/jWUJK0IQuPZyMFnpAa3MSRMIT?=
 =?us-ascii?Q?Yr67K0lZ8sP5/5E+wED1RHFaPbi5k/ExTi/4Wy3XhOfLUZHUQ7COAyLFnAOj?=
 =?us-ascii?Q?nAir03YKKZ38zu+CquAFG8oDey4tmXWI420kVDFC+XWiZChgezWnpbUcZq1Q?=
 =?us-ascii?Q?Raq543z5Y54DV97P3sVU8YBCeCZ6JVwegaH+ha5lT0h83VQdCujx0nBPb0pi?=
 =?us-ascii?Q?PuX57A8WWEthq8kE/xNtBBuxoiwZE1xNeaPh3uRW7fB6j5sYLwFvlxlsded8?=
 =?us-ascii?Q?MOYqP6gk/GXFSieverduUjKrTWn07QrnfN1pFxodbtntMy+B7skQaJiA3/ee?=
 =?us-ascii?Q?upTnt+PThtg2JApGzwHnsAYY4DGMUddtdt0XzYtfHhBJIo5MpHCNo6qoPEg/?=
 =?us-ascii?Q?M0ZcMIdqZxEEKENL0RA9yXCBSDv4XAiTiKy6DnEgTf3vZyHomFu9wS2ydQZr?=
 =?us-ascii?Q?pmwHjNlHM60pWIZNRKycJrqUo2irx7OYQoWUQi53pxLFYYlZfAkT3HEcCqf9?=
 =?us-ascii?Q?GdJJn3PPwkbgO+tSBlhYQv40IOsXmwnRUy1mz8peMh+7h9S/ElecVC3HvCPK?=
 =?us-ascii?Q?MO99R3YDHmac4rev6d+RVjOcMkEZ85R3PIbDT8GOZm0oxMNKf9GM3q5JxNwR?=
 =?us-ascii?Q?iJXYlHFDPih3x32+kEMqtJ4nC2iLpkAvtA4GSNbYsptJOZzVp6nC6FBSL1JW?=
 =?us-ascii?Q?GAdxe4nT+loICVZQGFUJC0c8dYIbPJoi4PxUeOkt23Za5xzmw1tbOhJ1/RxS?=
 =?us-ascii?Q?qNQApa3UKRfpGavPA1j2qNlL2KScAdnuqA/HTWntpwd9s3Mw32FE7TkQs9fD?=
 =?us-ascii?Q?txh9iwh518eu9rwQM/vY95Wk3oaBvpq3kpRc9pklpGcgvukZkwhjmC1kYB9y?=
 =?us-ascii?Q?g4oo6hbeh6PZIG8ig9K8hs+5mDhLaa7S4m8x5wL/rVeXfDZswKtzUfuZlAuI?=
 =?us-ascii?Q?KU+66t0fVS5H5x3HGG7cPciGanO1MctrmmR9SvZaquHPG9pCXbZW8okdz1Q6?=
 =?us-ascii?Q?BTdkfAKOZOJwmHW+xpipGXxPi6A9/sENvW1QroBdqFBcP2h5eKWy5FiPsbpY?=
 =?us-ascii?Q?51avrnrUsLOGixo+1kQnxcoZ9LRXC0G4gXd62CD9R/2aX7btV5pEzyRjRZOC?=
 =?us-ascii?Q?qPpa0iXLy4JXrMe9/cIFrMaG/8XjjKiUqldEj/DgDLdjwdJFHzfMtML6Gm4W?=
 =?us-ascii?Q?K1J65J/vfpHPdeZrj1USK9NOV3capDLTx4CqviFr2ISeujmM/aPPuzofEjK7?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?SOtv/w/dHiDQwnWshrKvhM9qUtOwffliLjutaFS/O0wmjevVx8lN7IlUouBv?=
 =?us-ascii?Q?PhLGxlkfVDWL3VaZwhBlHlMaW5xtOq5EVEqPM4qeNaWvBycalds98IvpDn/U?=
 =?us-ascii?Q?ePlS9D3PuuemJ6tgTCia8Ra+9dbCreUwDtm2Dlcsm3j91fsBfj8V4oGaSCN4?=
 =?us-ascii?Q?fOcMjWcehKiza5aYb/HxQ/ZkvQ17w9WSdGza/IN3cTcEa3ifHglV9KDeasyO?=
 =?us-ascii?Q?sjpC3M/SgLcIFaZ3wuBsdFPdzRA0mmsf0IEbWR6iV+Iu6PN6r5xMFtx4O08n?=
 =?us-ascii?Q?g915WWP8blTLZjSi8M0G7HWlTLh5bteybUsaY7w5+Ab89G1y1LsoRHtlkZLy?=
 =?us-ascii?Q?AV4Vb4KAKubGWaDKnBHILHGE7TFar7wm1ffYBhxNZEEkrUrqRS87zL5rooZ/?=
 =?us-ascii?Q?XgNd/ep66uWMflN4loXh/1RzpZnMf8XyabUpJMb5Alf+JxrQ3izz2NpRALQm?=
 =?us-ascii?Q?0AClybRtR/Tmvi0OfRYkRI1QaSoKZmtq09ghHHbXr9i+kOcu3KLb/4Y/gtGz?=
 =?us-ascii?Q?ul7e8Pecldsfkr8ODhn0StabxXWawetr6G1Q5fTf37USuZ87xdyvz8oFjwKi?=
 =?us-ascii?Q?iZIWLF4hzMjxsmLtk/xNlhJzeEPRaibtMzIcv5DSZwhcCwCqqZjYV4eIa+C6?=
 =?us-ascii?Q?1FcTsckhvRK9/hI6ZcU4ZUhPFgBmxTWIyELnVxrgp3tSA779Gw11OO3j4K2J?=
 =?us-ascii?Q?h+/tTCAxS4/AZKZWn605lP5wzEAOmFs1jO7XtbuvieRyyD1uRUIiPkyuOmyL?=
 =?us-ascii?Q?06H5YJKbzIQWPCd2tfwzGdxv7TRyQXt7j3xmGAsLMdSmTKEOpimqW4o/Tol4?=
 =?us-ascii?Q?njEXeoQGH4BlKIvjvCZvzTChjpiEMm8KySUCizV1jkUPAlYgkC2I3BEumAKR?=
 =?us-ascii?Q?vUwV5USrtuAYJ1sL3upqOMRbMFIIwkO5O5IDboUr8BRUlrnI5+OlG1Qc34xK?=
 =?us-ascii?Q?RQoEf91lZ8tO49SYmQ6E+iyBgcuN5BKNMEBk2glIb+yxiF6yQ5DtL87t3bPG?=
 =?us-ascii?Q?FYxgDipNKou97LRi4HsE6LDx5jOHgWRS7DuIqUxrpbFII7rY0m7GLp83iq7e?=
 =?us-ascii?Q?Vkmapff8Gja/geWSeeBGdnRtmbmFA88AWGIdAOSjfKr6UGQeznE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc13ad96-c70d-4075-79bd-08db26998d62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 03:41:54.9137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOv36gNDCtV73fEYl8ei/nZ/VCDEgM8VD8rhNrjTTJM3ETeQswYN2V9Ku3RZLylYCxCBDqf3t86l2DpDoBH7dauBl/jbzzhy/oek0d0j+QM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5935
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170020
X-Proofpoint-ORIG-GUID: jmY3ExeYjF-64N8DNSI_j9-KavFWHKrj
X-Proofpoint-GUID: jmY3ExeYjF-64N8DNSI_j9-KavFWHKrj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> The patchset is based on 6.4/scsi-staging branch.
>
> The first 11 patches are just a refactoring to reduce code duplication
> in fabric drivers.  They make several callouts be optional in fabric
> ops.  Make a default implementation of the optional ops and remove
> such implementations in the fabric drivers.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
