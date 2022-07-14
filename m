Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E923AC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 03:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiGNDoS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 23:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiGNDoH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 23:44:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DEF20BF9
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 20:44:06 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DNgweL019282;
        Thu, 14 Jul 2022 03:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LGUfae8UHdDHE7D22hbjUxIznlvoIFwdCDOARME4Ae8=;
 b=epBO3sqPCk+1tqPzn2SsEGH8r6JJ1V6q+1oPmi5t0U0WUcec6OLg3PJwFruVKzEc2ZEN
 FvqmdEljx7KBVxiVJ+FPvO/vKbYEa0iISXXqbjG/SlX6qh/QdFDL9gp3shZVL1jEuYTZ
 KN4GMeFak5JYcCBBJ93qELO3dr+l+yBmtN3hg0BHlli7nuWhLgzdfZvacmZoKyp1dq1B
 uq1p8ZJ53G8luXqOrzp21X7y4rT8gbVq5De3TRpr1dsWRx4bJi/zdTOwcErfmXK54dhT
 kZGRckc/pTH+YteCHSnsG5taY1i00Jlg2q1mR2WLtYhnpVZaZCGdIbJYyl2EpGWFDMA3 4w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71xrkwh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 03:43:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E3eFjw013247;
        Thu, 14 Jul 2022 03:43:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7045rev2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 03:43:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFoeHvnV00ks52ZDXQvvxf7iZsfq4ot/BG5jk1pATNnAbZAsEPuW+l5QxR4FeCvTTysh5E3e0ZcfpiFzG/7s24jzW4Hwoseh/Qp43JsLu/ANuCMwZwxYSAVPq6vHW+6kPnhGxFpJ3u2EP2kntfbuXaUUmGGZRo6bJ+r7QHQpe5r42ws0s9iOR3pfEX3X2fPic6EN1Z6m6dltI0tz8ylKhk5ms61SHdt7uUPZ2r86W2xYNFHyJxCmb08InVIQ1mInhvdyo6y6ILOgdCgieqfT7jPWsPw9ni9lfvoWhnCBlmtx/Ooei8PqZ3FtqIAONDkADRrPapoB63oqthAr/Y5C5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGUfae8UHdDHE7D22hbjUxIznlvoIFwdCDOARME4Ae8=;
 b=hV3hjxR7uqC6gJl56e22t29wnSeZI+jlUfHCAwnb+mQ3zXB4wWR3NOoydw7hQoHHz47eNXP5VxtVUzGZaat9+4V9eP4zZw3CviTsS4aM91Ro0Tx1Y1PNchy5BhQQALDR9vjurJBvVkT91OXLTKhJ7joelVis0DDjtVTyg60PYhmB1NO5Ki7p2gNII+3ONHA9rYYee6QYIFg6FqJ5A9wULv3kSjgRJErD7PmZablvFh5ZSUSngjJ0wK52Ml8+NDkWKLNbu7ncN5LFwquZfgvdbANDpVNf1zl5k4YdQOLtB3q+5yBsrCQ7/5qIu6j789Q4OMgKZ6JvTo0JAf1veUPbzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGUfae8UHdDHE7D22hbjUxIznlvoIFwdCDOARME4Ae8=;
 b=b9faxwhKygI+LlyVAflKMT4BKSPK6Gh4h1Y024pxNuTOiorCZ9bHqrEAF0FUWth0jfUOIM6lLQmArMwyHbxHSwhWhGuo9ShSGM2CI0J6SCMPCBAtA/vWdfwS7NWHWx57I4Ytp7N1heyF8UWRXATpezkYvZVy3EuKxLmCoHt2CbQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4643.namprd10.prod.outlook.com (2603:10b6:303:9c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 14 Jul
 2022 03:43:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 03:43:46 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V2 00/16] smartpqi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1leswwe8s.fsf@ca-mkp.ca.oracle.com>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
Date:   Wed, 13 Jul 2022 23:43:41 -0400
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda> (Don
        Brace's message of "Fri, 8 Jul 2022 13:46:45 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35545d26-de03-4565-8340-08da654b0e47
X-MS-TrafficTypeDiagnostic: CO1PR10MB4643:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vrzdCKYXwecrkW+gnTLBWh8V5qk6YwYIb9frJF00dj09YdQHW+YbH3fm9yXNsZCyxXFYvD4y6Wc1zlWHrtTZoVPZv/2twfZFyOlnVmwMtyo0onXyMVrxjWD1yEI46vCsUjyuK0nI8d6s7dH0sbXBpY5/SjdMwuWKjbcyWuwn+/ykM612pmN0/+VTvqMWSmB2YxjMv+txSHD2S/YeTeJonK+i7nVsWAC4MELU5CCoVbNfKnWsxRGoHbw7pDrC3dUQp3aiVSMNtWsZ5w5oTNgGmyfpnYlRaVrE8X/+rMHNAYjwy30+iKpNu5aMj/235rK7QXSMsKNwriDYkwp46H+QB5dHeTX7SvxxF2XOLzAY+l0c5wyTOarTl1kccq8I1DTy61RzhGTe17kJApb8MM6q6nUJRiRbQvDm3Jw281VADKq0l5wqgeDv8YO+Z9Ftdf/7y9sRaDXK3d79QUDmhg7V62myPe1iyqM27HyHE7ovhbNZesoVsEvEwyqSlyNJxU5ZN1kc59pOzJI3g+QjwVx32Puw0/cApjGFNUqCDlqa7/j5c7u5zCxDrqpYopWAh1WGng9rcwjZaBMP06yZ/BotNyintn6cy2qU6QLZoWBSq1LZE7uaLF3RGudbbxSjflFCdo38kbamRqOIviwV9oqYJUzai7Cx02WEkN8dsc9WrCnUDUQnRFdyclnA31vneqayQ9oNMy6h2N24P3ZYvoa/fx/gYFLvwMIFRPcsfph8811DUcAqwKXyOZ6m7Hs6xRMic51nPiJYQt8NAv9Dxof5EmUy7/cKItYmCsb3aKodfxJh0rpaQiCSE6Nehao8Mv+Hz3KJSVzitKrfs6k3UDfHfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(366004)(396003)(346002)(38100700002)(38350700002)(5660300002)(186003)(6916009)(6506007)(966005)(4326008)(66946007)(66476007)(54906003)(8676002)(316002)(66556008)(6666004)(6512007)(8936002)(478600001)(52116002)(41300700001)(2906002)(36916002)(7416002)(6486002)(26005)(558084003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/CS3TPnSPxPlz8BV2z0WTelUc6IKCbF3tBBU1oHIUoupr7I5nIWJYIcEyLYo?=
 =?us-ascii?Q?3rT3ChuwtCzH3Rv8aYGiJ5pmleXonCB+KmfPnW9hTtgqzvSw+CCRQEXd3hSU?=
 =?us-ascii?Q?9xCki0KiVPIiX8PSWXXCi5pwCETF46A5iq6DtU6PWmH0my02IzVG4ZwcA59t?=
 =?us-ascii?Q?IALenixhCGnfMtLslr0yLsbuJee7Fc70RVIBGl9muKa4xrwCOiPBpmf0Z2zb?=
 =?us-ascii?Q?gz7tH6BHJhrvGwMmBdwtXKGiCCQNx+cjCw9xYRojEYQINahSHisokCntG1zQ?=
 =?us-ascii?Q?MhuoqeOgZMr8YY/bANLXCz+TevlJ8JaBlAe6K2lQEaHT2MMJXzYhW6U7/qNG?=
 =?us-ascii?Q?Fv6W+dC6Y0/pi4j/4z8SY2j/b98JxvzA4Evp2QWqcDhvmI3r1v41fz9XsIVg?=
 =?us-ascii?Q?LVSRKfuyHZWx58IqBTfxFEV/Okb459WxLTV326v8bmwUqWYFkI1qHLT7xPny?=
 =?us-ascii?Q?xnALMwfNaZrJWkqCt7vVRMa79qR9rmR2CWNNav5zZzO9eO/+PtycD60vD83q?=
 =?us-ascii?Q?ZNJ/tacEl1qb6rQjbVrbsyEv1sQg9PLlsLScFidcVLvpjgQxn0ptjEnzSIRV?=
 =?us-ascii?Q?yPLgzP6LvM7K69AW4iT+vj0nLv5b6LcrL0FpU1fHv8MTYhq743/1KdV9XK1h?=
 =?us-ascii?Q?sNFsan5bBX1wmFYhJrueXWst9lrMVm8WLsltQkbIFCI5R4pmxHu/XNdYPwfa?=
 =?us-ascii?Q?mHZdspwnJQTR9KPfaHFzaPc6SJPii9UNf9kSn9QaJ4+qLucJbmazdhHuYIUe?=
 =?us-ascii?Q?oSMFDmgy5YGVG323X35W6eTSTCARqU9vqJXDXXD0ZRcLPnfPBULzNIHm/Jmn?=
 =?us-ascii?Q?duXVCVWF5XKZWUFG7ovpFKwF+lu094eEpDW9kGqQKeAQS7QJ8ej0x/uoaP7z?=
 =?us-ascii?Q?fX9soc+0T64qOXUTASam+pqXdbO6pB+HyCfjN+/ySFvYO9oy8l3h5vs6x5+w?=
 =?us-ascii?Q?A83/yd+dyXB7Wr7PP/UF9joNeQIdfKotG/VMngPIFBCm364OpoQS9xYeB/jH?=
 =?us-ascii?Q?123bYqJ4+lFhJcKCzeYCSqDivU77Uq5odNuEp/bPj3aFLMJOJSpXT2T4l+gt?=
 =?us-ascii?Q?Gd1cUU4cunnqph1JC4XaSRPZ5nBnHcXDemKmHeV4B4Va6E9it9N+pd0dILb4?=
 =?us-ascii?Q?L+9rE1+eEu7JeomtwkR8QTzC97mi/grCihBuLLcmlQNx590ej/t1yjQJwIX1?=
 =?us-ascii?Q?05R6eTT3hi1KSeNyrabXWzUNj0bQc7pUSU0uV5f3iJuOj6zMeUapf9Lq8Dpn?=
 =?us-ascii?Q?S4A0n6MO5jRnYK+UMNMYzMv3zXVceJFjJAW3IPezt7y9Vb63jaJVJF1C3DJ7?=
 =?us-ascii?Q?iX0bqC3PeKjrl0zfqwluIM7pwUeZBko+3AH9w7prHzhIr3myDzvI9MHFce+o?=
 =?us-ascii?Q?O/bCRCISf9+5tN72Tq61qDLqwaMrGYc1OdNVMUNBogOpxAzkWk2lUUPHv/uH?=
 =?us-ascii?Q?+GRHiYpzzHOUOrxHj5QoRp4bGUdfb9/YCXh2pGckX4zLtn/pcfugFaMxJzXr?=
 =?us-ascii?Q?WG4yyz/UrvU1Kd60kUC2W/gqcSnJJ6sZroMoXIS9yw91TDSzGkIUwYykKfsf?=
 =?us-ascii?Q?H5kvBHcGQPhXaGOc5bUcUu23ESPCd1rgyuUgdwvu1jBkmA0GpgvKUht45gZD?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35545d26-de03-4565-8340-08da654b0e47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 03:43:46.4272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcc4aaBgSReARr9XDIyZZpTzAw022mX/WWePlGAORuvugFTWbTVi5jc6gxgW47GhuwMAfi+sNWAz5GJKR+wSwY4eosh3UZU8andkNKIxr7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4643
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_02:2022-07-13,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=866
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140015
X-Proofpoint-GUID: CURfF6_OeGjim5pDJLv-tSF8m6H_TVlE
X-Proofpoint-ORIG-GUID: CURfF6_OeGjim5pDJLv-tSF8m6H_TVlE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> These patches are based on Martin Petersen's 5.20/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   5.20/scsi-queue

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
