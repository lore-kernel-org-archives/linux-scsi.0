Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BE0C6FA8E
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjBXRpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBXRpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:45:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3CE13529;
        Fri, 24 Feb 2023 09:45:29 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHhwtP019983;
        Fri, 24 Feb 2023 17:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=TJnlkmBsKXTXNyAh/UnSxlRNpQ8wVXlz1SzzGrPFZ/M=;
 b=FvQUU/IRc2GKxetCJNl+ScgXFHrwnaGhWR8H7U3axItoM/HPN7OgD79KyzppOV/Mav/K
 MNYvYMOskPtM0WzP9oFYj2AD8o2CJy/SCOeMp0wImVC61l75G7GbN2mf8Sq6jRTudL8I
 kfI8h8YGB8jhDToddC4pU5FUaztyWh5pMIcwb3FnrHR5sPx3b6fkM6/V1LMcw8YYYEfV
 V6hFwzLVdgtaUuF3uMrsQGDk7BBDZY6wsYaoyxkepvl8TkLe/xmE+d/zD9sbx3NPG/Cj
 VeF319H5KqFI+YPehXyxYEfSLW+vVUmi+2TjYkpT1ptnYkAgSQXNOhwSNNAkBICSw9z3 lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9twu3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OG0ikw030220;
        Fri, 24 Feb 2023 17:45:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn49ssch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOLssxY94n89oqANyZHmE+WIJyBCWp929HV1d6A9GKcEsPdCDd5XU8FkYFKIHJjJ1muspCzJhxCpd/Xz00ZPmq9d6oAExqKg470jZxbnz1sHzC+nLJ4GqKewE3sZiOAvUfJdd72RH84w/za1xabgp1Or7ISFvJozCBWaq3cXNAx0Jl8pNr10v+omM6OjLj+KR6j9PSREdekq8lPq5p1w+i4kq5yB9gX3aNA7xmRJfIP+urfv9zML0VbZrEzo7qLyytPSZL1FLvv/0g1EeuVcxkjY3h4pHL+7HzWCsphGq52esy4Fyn7AuJ5B/d/23a3/zJGnnedMKZGHb9ZmkCHkIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJnlkmBsKXTXNyAh/UnSxlRNpQ8wVXlz1SzzGrPFZ/M=;
 b=OTdzn8XCHWc7PZ+KYiCVT2vu1WVIQrK+/z8vl3aU4lHzLbWrGb2CHgtzt46XDFgMMKpBcEZmEHlcZNjhXTFEnyi5lSk/Tk/9Oys0O1BaAWX7yJLxbalk+vZg0YgsOivZCjoSvVbvB2nWPt+iXXosHnUYkqToEslxWWw1bdCLV12uT6e4iJlW1Agfim5sVKTvcXk+KnCPpP8UqhIzl+fYoxMS4ac/EvDkN2diFBlrBhV0hZb84udhB7Fpv+b80iYCorkLJ8F2mqOr2rOexP2mmgqVwS1M1maM6CkvoowDrE1QYDhB9HK5IUbtu627m9KlV9eUKA369lcHtAzfgXRoMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJnlkmBsKXTXNyAh/UnSxlRNpQ8wVXlz1SzzGrPFZ/M=;
 b=KO8//AobnfDGECf7W+9Y/+VIZuxY77FvGqcitI2UCbw77EkW6ZzeKjVcWeYyT8u2VWWlNnmCgDXBhcTgFML9ZFdYMsISWA8VtfeO+wdKmw2hEaFcgCqINpTVoE7875TDgZNmd4jGJV00yR58kKFodrMd/Qjs0fBOLqGAjrGFFOc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: [PATCH v4 01/18] Use block pr_ops in LIO
Date:   Fri, 24 Feb 2023 11:44:44 -0600
Message-Id: <20230224174502.321490-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:4:ad::42) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 89aff5fd-382e-4625-ec53-08db168edce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFFgWg8m62M1Q0ZTI/kw8UTzI6/HvQKeM44buNdlYXQ7nH7xwfxA3R/7YbqYeGAvCvdlOr9XdKpPlpdjqzgW6GQFAj3SUuNlYgdFWUg+ReOCvmKUxbUc/S2/pVLmtQ5I65oMb3L0UFP4upxLAyCOZDVpy9Puj2UxEwsa9cBhd6eGYqhJi5yO4h4oxXW6p+rqsb6Wd/9fwsdN0V+B3wASZoLvaenYahmUviWwm8ZH1WmcwavnIMSn3EEoPFQO/YW+bCjg7BHvhUtEGnzzZ55ned5w+5M9B7H+f1dl3pIiAgZTk+/xktf7ZjXJycYYAmEQkpXXb4Sk5RvWIamf9XTH1ZSbQ6g71XrG9YYXValbOhs79jpWBnUInSyBYMjKQiOzPQnvM3GPFxyqyfizgv9c0i+yUA7ehUSJrm/idVuZuZYKBMtbJ/b4tRrf32JXgWWIi8Ufj8penP08aMpeLndx0HVo/JE1p9pDBNvPd6ew+09p0QtlhFa1CfEfFVh8s6kPKxdfLfOQJ2v4aqhYBuOmwL1daWBrh/F6akkUhSXGUK3VohM1AtBnelfjIDPlxb8hFIB/REbtSa+9rxjsH9NKbeDgaatzz/Q9uB/Qk7M0kNCWz4QECVbNQjJRIicTRhxF13DQ/glBCuieuFLJKtKyKgQ3DFrQSYUxue/mWTTE+xytq28uDxa6IFgP5F0JCdxe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(966005)(86362001)(478600001)(2906002)(6486002)(6506007)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MyLGzuJLw6qxfLd38DN/tIpM+X+hhoOy2RbabO9Xsm8IH+BSNYbQjwuYDrDP?=
 =?us-ascii?Q?LtrIn5VM3hn1YV0snEsQiccDtkGsk0lF93kxOHWLBY75fB6qpI4KAJ6U/q2Z?=
 =?us-ascii?Q?sOsihb5jvUv9a+Cayn5c/uxUQuc7+sG6yaUMAJv5gs78hmmHOV40mnXh+nEx?=
 =?us-ascii?Q?qG+nfHUjXLUzm4DJHjECW7JyF0xvPccMPXNltFWN2r7bwJqcxLoyKRHFUPTk?=
 =?us-ascii?Q?fyBNT+iZJxxhwhf3aOu32GLsxvou4daxo5bWpsy7s2MJMg7lIht/etpciLDW?=
 =?us-ascii?Q?uBPj6cfuxC+XKxntFbTWk2dJU6lNViCROCYTXcs3McRzIfDxJxGX4D2qYNSP?=
 =?us-ascii?Q?MJOUITYI7pu1ftil5nntsN9QAnYxsR2MXY+Lk/nYPvH/VJ3/gJgITxaZEL59?=
 =?us-ascii?Q?gOge1s7sPUzqlqFhGwk6UrLYUCyACulvDSIcOAELq1vd+zHQTgnzncQUrK6g?=
 =?us-ascii?Q?fju2Au0to3LUiGqgd1h88q0v1rHlU0YGvbS6RDzgY6GD7BXRtCiAGZ9t5QQB?=
 =?us-ascii?Q?vI/XpLQjrqgc/HYwH300Mh8/uRxLenxKlZ/TcexINmgq3nokQBoVioxoXHrt?=
 =?us-ascii?Q?kybq5FpEX2QSIzr0IAfIt3VZ77I+7pu5Ww515sZTNcoQZFKM1kLQ7HpB6t4P?=
 =?us-ascii?Q?LG1THmhMMmzQs1R4wSPxAla3rstbLKKO+gyIxkNnfQ0Ffo1ZHXRpSGIZRgSQ?=
 =?us-ascii?Q?Zkme40SEyecjXco0JiLy4oKqJVH5aHKUWzKlZjTMrXO4UIcY2Ch74B1HwPxR?=
 =?us-ascii?Q?qUuHwpzhTnQ3X/eUr8xTFcg4PM7dNvKWOqzRJkjZeMfqF9Cvukp/Wi6dvcOy?=
 =?us-ascii?Q?X6St6PA9gdH+ivq6rInNOhuxs8jrUZgdo8HFe6e98WIM04cqOG8zUkUWMoYH?=
 =?us-ascii?Q?RSoXSYNSUOeO6JrqKj2OnpnL1ltl/zIFxS06rcLYoVt8y7/Pwsm4cTkXKA+4?=
 =?us-ascii?Q?c3NRPthsoHgKMsMIID+e7LMm9CTaWAYmr8GBOGjLa7G+p01ewwhQbj/fHMdq?=
 =?us-ascii?Q?cBWSmWPSpCO4Y0KG+Yac9uQly0mPvxI92n3i0mvNoXOCXv7ZRT/Yg05DT3dq?=
 =?us-ascii?Q?ormZVE20Kkqk9KntXNe/fpaCqJ8KB/2ltsuAjvE3d4UBV/Y7rYOhkWhd1KJH?=
 =?us-ascii?Q?oAQ+f73A5hvwLvGqXxa4Pc71W1oHp7gLjfib8R+ncGzwvwXsJzfkLicDxE8Y?=
 =?us-ascii?Q?EeXChe0SvLzfN5ICBzXe97NnlEkQNVRq9RwGFUk3lvZ2gcr0PEY8gXb1/Vie?=
 =?us-ascii?Q?4HwND1nEx0RaLG/JfIww3PxYYLhymaE398EW/WC0GejycD8JJa1xo3gf4CpE?=
 =?us-ascii?Q?PD+b4j9Req8ictbBxX8Jm4hFqK1B0PB3qysmKRxC6pZTqttB2tis4RJtG1z9?=
 =?us-ascii?Q?uq7xD2tFGzFmJbFo2yGgLF3nDFKeoRhTetCHDPSFeyvCe5BUOU4mw4xrDLd1?=
 =?us-ascii?Q?cojdC9dBmGRNdbQfv5KTZJ3m/9iqSNs1cul5TOrNDMwUXX8h1H6nFZ/OLy/H?=
 =?us-ascii?Q?UIXIw/iriwY9IcKhK/JzW8WSN1w0heET0/Th4OGih0D4l8pXNpA22QuyfzbU?=
 =?us-ascii?Q?V1fwQKPAWTcK39RZn4f+q1Ce2UH67KFnxeXc9K/OHcyi+IGsVCR23nWgFI+0?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?EQEvJ8MKzPTGe/p3e3S/RzqeB+lTSrXessVtEsDZxWhlvoiQ8p6lw72jVuDn?=
 =?us-ascii?Q?DInPdYsqSZrP/kWF2mwIXn4pnOPG/U867dVFTGXXWG1CCHRsFVtCCAvsCV0u?=
 =?us-ascii?Q?qUzLF397gZJ8ce+jmt+sGcdfNdy+YRGVxWav4g0MZjo9gne/rayEXrluUGwZ?=
 =?us-ascii?Q?n3E6ny7GM6qEMCkrkqrx0kjrvRLusQ7fEW2C/60vWWIi0E79W4t54ul03tQ8?=
 =?us-ascii?Q?+XKkBbdOfnSdZVeKMNKhWCzslHOY9Sqg+rw43K9FMxVwtWXD4OpW15h7fCld?=
 =?us-ascii?Q?jB1sHpwdM3Gno6MQxNcUHyy+j191Zvf5OKc3kFu0m9etzwLrnY7mraDK5DpU?=
 =?us-ascii?Q?SCGDHn4xNqFmjHkX3vl25Rxaim+fZak2Y8R7KPwSy14fIjGqCyyDA/ADKms4?=
 =?us-ascii?Q?WEa55jtXJPcdC6enBVYAcBkU4Ei+KvImmH/4MtzMk4j4Q84ZFD6+ZwLlRQ9q?=
 =?us-ascii?Q?FLYC6gYB8NAfTydbHhknNE6877mgCiHRsurn0p0JRohK7mP4yeMEYOFwZEt7?=
 =?us-ascii?Q?yQwvGSoAKBrFLMwwRsy5gm52/0b3H5QPTvbR6oC22vBQsD7yzssCz9YXVXwS?=
 =?us-ascii?Q?XDAsQHf0eRl3I8LsaiCBnSElrvoo06xIi3y/+/65KkrhXYGmNKPDSNbbGBF2?=
 =?us-ascii?Q?oD59gw230TtQBDMzMz7DtPBLqv+h+Q7foEtq6b0wHB/iaSlhYhYGle6q4HTx?=
 =?us-ascii?Q?ZgdlpwA9AZ6k/VXG739BhdeV7KQ0/BNmfZOrXCzH1QkoPCA7B+w0RXvt8ExW?=
 =?us-ascii?Q?wNzOjBmPnqrMJD9U2ovVp1z3gqOqiBS+dhZDqKUIQs2cZzMlD7ldqxYu/JoT?=
 =?us-ascii?Q?O4sBz3EZ5dp+0/ENEPUVouu6rub3xD20GrDULbAj8EqRncVkmXHoTkmyheBS?=
 =?us-ascii?Q?Z/Vz/WCY+EnCCqsnsrBfXuVtzRRPUqfp+BSNiSJ2z1LWABd+9yCqCswcKIOR?=
 =?us-ascii?Q?GSH/B2n+jEpVZIywX+rQNEPJER2+JV70Q0HhIsABAdTiBPnpZmX8FdKXbFoj?=
 =?us-ascii?Q?vYDsyLOWAhj3GZRc2dyP8AFC/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89aff5fd-382e-4625-ec53-08db168edce1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:05.1892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFHdQ51imIb5SMC5a4wiKjXkViIOAOVdMfynTk3bMR0tBCAaF+ELR/aJ4lUcXulja5XpDWcTf3PWl8E4S4Q/3pPULNCTd5ZEzWZVe5t/UgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: OuvwkHYKZFwztoJSmsJoJfYsOTTfscjG
X-Proofpoint-ORIG-GUID: OuvwkHYKZFwztoJSmsJoJfYsOTTfscjG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patches in this thread allow us to use the block pr_ops with LIO's
target_core_iblock module to support cluster applications in VMs. They
were built over Linus's tree. They also apply over linux-next and
Martin's tree. They could also apply over Jens's tree but it needs the
scsi_execute_cmd changes that just got merged into Linus's tree.

Currently, to use windows clustering or linux clustering (pacemaker +
cluster labs scsi fence agents) in VMs with LIO and vhost-scsi, you have
to use tcmu or pscsi or use a cluster aware FS/framework for the LIO pr
file. Setting up a cluster FS/framework is pain and waste when your real
backend device is already a distributed device, and pscsi and tcmu are
nice for specific use cases, but iblock gives you the best performance and
allows you to use stacked devices like dm-multipath. So these patches
allow iblock to work like pscsi/tcmu where they can pass a PR command to
the backend module. And then iblock will use the pr_ops to pass the PR
command to the real devices similar to what we do for unmap today.

The patches are separated in the following groups:
Patch 1 - 2:
- Add block layer callouts for reading reservations and rename reservation
  error code.
Patch 3 - 5:
- SCSI support for new callouts.
Patch 6:
- DM support for new callouts.
Patch 7 - 13:
- NVMe support for new callouts.
Patch 14 - 18:
- LIO support for new callouts.

This patchset has been tested with the libiscsi PGR ops and with window's
failover cluster verification test. Note that for scsi backend devices we
need this patchset:

https://lore.kernel.org/linux-scsi/20230123221046.125483-1-michael.christie@oracle.com/T/#m4834a643ffb5bac2529d65d40906d3cfbdd9b1b7

to handle UAs. To reduce the size of this patchset that's being done
separately to make reviewing easier. And to make merging easier this
patchset and the one above do not have any conflicts so can be merged
in different trees.

v4:
- Pass read_keys number of keys instead of array len
- Keep the switch use when converting between block and scsi/nvme PR
types. Drop default case so compiler spits out warning if in the future
a new value is added.
- Add helper for handling
nvme_send_ns_head_pr_command/nvme_send_ns_pr_command
- Use void * instead of u8* for passing data buffer.
- Rename status variable to rs.
- Have caller init buffer/structs instead of nvme/scsi callouts.
- Drop blk_status to err code.

v3:
- Fix patch subject formatting.
- Fix coding style.
- Rearrange patches so helpers are added with users to avoid compilation
errors.
- Move pr type conversion to array and add nvme_pr_type.
- Add Extended Data Structure control flag enum and use in code for checks.
- Move nvme pr code to new file.
- Add more info to patch subjects about why we need to add blk_status
to pr_ops.
- Use generic SCSI passthrough error handling interface.
- Fix checkpatch --strict errors. Note that I kept the existing coding
style that it complained about because it looked like it was the preferred
style for the code and I didn't want a mix and match.

v2:
- Drop BLK_STS_NEXUS rename changes. Will do separately.
- Add NVMe support.
- Fixed bug in target_core_iblock where a variable was not initialized
mentioned by Christoph.
- Fixed sd pr_ops UA handling issue found when running libiscsi PGR tests.
- Added patches to allow pr_ops to pass up a BLK_STS so we could return
a RESERVATION_CONFLICT status when a pr_ops callout fails.




