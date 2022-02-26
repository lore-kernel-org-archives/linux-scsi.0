Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C591C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 23:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiBZXFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Feb 2022 18:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiBZXF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2022 18:05:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D86815DDF4
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 15:04:54 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21QJ5mwk030117;
        Sat, 26 Feb 2022 23:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8g49V0GdqG5qddVXl9LWidodjEnMlrin/1FTibsXqE0=;
 b=YakvZisoCqhoLG+iawcgnZzWohhElF9X06FUQaGKGuPtIuPSUoqK4aFH18iMU/Jvi0w1
 SLtBrZjzPPP4X+FDqzuMhES1eI9vWP4FlQCNFTymPOMZXZhb2fC83jqssDyACXwYiLS8
 Y1HmuHVRItGvH1BxfHAaTn52SNtKxoWQ8krp0CWeZ/VjQsi8jSVZQknw5pI2AKZExc0O
 mZU43+Rmjz8zdVa1GBCE9hgVsND1/IYO02glUgx+ucoFoiqOeQDVi82vQoU9HAoMdTXv
 5nWlVUJh0zxlhSUwMGYxX3JddO51isKAdJVSJJU5OSc4pM0Ixya3R9K1sv73GRN3LIjA JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamc9bka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21QMtKAL179769;
        Sat, 26 Feb 2022 23:04:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by aserp3030.oracle.com with ESMTP id 3efa8awbct-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKymegZMnAtDm2i/hOM7avLMY4fo73fazLX/Oie6OhSIekCyzCYuifrMDriQuq4wZe2keEsZF6EKUYXOVTfmBYwyJgq3tsPvcqmjwyVEGWctdF6Us95+1Gbn69cxyi0qdOPbxe2ftV7/+2gD/wbw9EF6SstpmfTMKzcneQe8VkI/EvyDu6sh2nXu550VV2aZJSBaBo4HJA4eEHhLYkdXnSnr3OhCv3SipV/pLknBDT2tB0u3eCAF2YEwB/pIzD37OVg+Ch4RNYDhbJ2iL8Lm40+r4Y/YbhuzFxHjb01MY7hhOXda7oPVze2vl3nllLI2DqtlyV2bw/RhcGkRktVVFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8g49V0GdqG5qddVXl9LWidodjEnMlrin/1FTibsXqE0=;
 b=fcg0Q/zcabOslBkrcJguFJ9oIM8nxq7HlwDczjMBToaToID0enaYOvR8LRfCMRcFBtUTWtxyATlp1s4jVFXq3G4jRfbXxpRqd0LB60cP1n4EU95I0ChNLm1zo5jsFYsdjbEGX0U+jb9RVnMCKQEWmCNLgk/lg3H49WTKep92ERUjZEi0Eo1GvoXKNVLLhDms3Wwlv97Zzesq9+0reM/mog0wchcJPEWiqLRwoIqmSQ+boPgbaytFDvjptgMt48CC+ufkU/9RDGuUWAfX+7GDrqu/ek40Lzl579a0pZd+PqXkWmBsEKu3Q1W3t5lpaS2KhKgxafngNo99hmGNKnKK2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8g49V0GdqG5qddVXl9LWidodjEnMlrin/1FTibsXqE0=;
 b=I0oBylL2faNgp4i3u8jJ0QTIU2OlPRPA5l85H2uH2MMcZRa/K9Hx2ZWUbRaU4QlblU7M0IuqmqsTRVVGD7TF0AMo/s+y4Ddnqc/DZkaSoxGEOzW1vyMQ9eQ3fjFU78ghomRF1pu6oEahvPqeEF50aMyJvgTji1ENFL5U9FRG8Ow=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB5750.namprd10.prod.outlook.com (2603:10b6:303:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Sat, 26 Feb
 2022 23:04:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 23:04:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
Subject: [PATCH 0/6] iscsi: Speed up failover with lots of devices.
Date:   Sat, 26 Feb 2022 17:04:29 -0600
Message-Id: <20220226230435.38733-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d363a1c-b418-4d2a-c515-08d9f97c6001
X-MS-TrafficTypeDiagnostic: MW4PR10MB5750:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB57502647F5570B54AE08FC5CF13F9@MW4PR10MB5750.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TpgqMQ0kaRowbDjDvqXleu5MuuJA+2ucs74i3YVxhVnKmn9g2DVGqUTz28C4UHYVyN/qbjklANhWPN8Lifm72yQ49gd3T5LdrqKnNhMrjVYUFYXDO77aySlUVEXfQ7B2ugXeN+0SbAUzcGxa6RRxt4gif9OfsHPKkq+Et8DVsN5omTBiOX9tq2iTTDVsqbPwwl2wgkVLJOsaMtxjIZVjQ9sJatunDIWQsN66/7xpIwrVFFxIEKbIE0H4UOIkjsIGaSpLc6rs6ERaN/ZIAyQPuVZ3itGBcXkGVhR1NHIS3UZuaouLqg3FCM3v0aczS9WDdVB/wSZYPSkjEzCmGwYawopkkglM0A3RoCbMbDjcMYAdwxVlzNs0Zm90Tbvq9HX/pLLT7YtAXC1XY+E8TnKXvobfvtkG8ZSJMhL8AOEL2T+CSG2a+8w2g23b9YqvMGkDHWstwp6QPxEGxydIlw8WZtqH8huFa9IlBiVNW93054yqtbHpXSTtWhE5kkBcktN8TNeagTwRKMD8JJE/j6GkKlirOxLQe79gCMypkvzaGRhhyMkafGCaIRReEafoJbJ0q7qZMrtgz/lAcC+1rsxSclveymfrJBXmD7NW0GwppbeBedEdAKtwHITR4UUZPfBG2SdoFrS5QFvrbopxm44fkF4JWshv0NM6+31Cu4L9LbG+stAazepqNps1Uco4iziKp5NX7amo/HPu92gRs2lMbb0DRp1CTFaYLNEdi3UhN6DlrIXDUUEOksatM5R/asMwpG+m4q+bJ9d1CVMLWFioqIQT8zzrDaYMUiWRU51LOA0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(1076003)(2906002)(4744005)(5660300002)(66946007)(8676002)(36756003)(186003)(26005)(38350700002)(38100700002)(2616005)(66556008)(66476007)(6666004)(8936002)(6512007)(6486002)(52116002)(6506007)(966005)(83380400001)(86362001)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RIIcSfB/YpXvdIFAz0N8ICNONtdMgUyvQF8Z0Sbp9U+9MZJjhwlk41O/O048?=
 =?us-ascii?Q?J0C58Mw+i6OJZw9HfhctbVht4KNiAhUnJjU3VZ9wrVkoqAFSf3DkR8HDk5v8?=
 =?us-ascii?Q?3y0gIxrWto4c9NbhsskNx9CiIvV27UQDoMKVEKEVj0umcNf21L31vO544x+S?=
 =?us-ascii?Q?nk6qCyWfGMbna8Rf0CLnNAj+fYPMEadLNyWX0ncPppqunhCCZW/usT53OzZm?=
 =?us-ascii?Q?DMQ4RRvVTVeivd0L/Fn3A6+m6Lz1IkmwNp+EQvlHs/yQhieiZ/pdvMmDkVXn?=
 =?us-ascii?Q?5xHd7NfNqX3X+o05dSYlDgxWA9UdORmz5/vTgJbPIrn4T5C3L1pvbNP6OfQN?=
 =?us-ascii?Q?+If4P6wOYXIfQQyQXRoHTbw+YcGUZ9TRWtoXMNwsRXDDR+jSSn6LY9kIjTiT?=
 =?us-ascii?Q?RnoAvZbxEnbIN39VIa3E+D4Xjj59RPllOwwmT/PnKP4Sgxr0IyRsaumBdzMF?=
 =?us-ascii?Q?EhlAse0q4W5xHMJEgxS9zhf4f6ONEsC4J1hf+Fa7vKUshP7XVtBMfnf5qxAI?=
 =?us-ascii?Q?es/7Qsh6wgmBlFGQKoH0CC5j5wi+tOmKnjxBE8hlvL87IteltHmEQCnZaAck?=
 =?us-ascii?Q?Vcj2IMxIJ9biYZJ3jgPed7JpBtNQWcWcZY1pwPjtaFrLEwUu2wiBzYXSdBfR?=
 =?us-ascii?Q?hP2FaF5E6b+/3NnlE0ZTlpa9VqlNhKvatFVpqtCftEuN6hwfLyYS9iTP+xFO?=
 =?us-ascii?Q?DiV6wdZS4EbM9M7a6lAmDN51Kiy2SE9+oCVypbzloTnmxw2Kxw16sSsshy96?=
 =?us-ascii?Q?xrdLIBF+IdZzp9ebHSjaxCQQ8le9qQ0TBnMTBkpRI76NSCFWa8hAb6PV4Afb?=
 =?us-ascii?Q?IrIfSU3Kqv0iOz3KPgTCr3u4L/+JAAjkFjdSqkRGv3lBtG0rgvMfR5rE36KK?=
 =?us-ascii?Q?WimEyfEULNFEnQin77oUUM2tXuy1gaOGc0af5p67xCI3L9gUFOHRKPTU45EX?=
 =?us-ascii?Q?wPAVZ20sQRfuhpiDjzfoOpaEDtXsGKrJoV7KZG8TWWQghyIU5dCzKO2EJ70e?=
 =?us-ascii?Q?EaSDJWTXK/sRL8yZfUqzCGe4DJxDpJ1RTzbJdEVB79T68m6A4OSIJS6WCqIa?=
 =?us-ascii?Q?lwEREWGHhQtx7SqXe2PQBU9sXFgcGFh+8623v6tDDLOknjYNVEjeEJu6vZ7q?=
 =?us-ascii?Q?pBSRixKtCF0wQ3i0RuLA2YDhoO2WU1uMP7Jf8+Sta12Zwp5mFa/NuebNH/3q?=
 =?us-ascii?Q?C62jxQfLKTMAemUNDdusiTE8qzLH7U1D49m06Q5dvvpNQkWk1VsI/1S4uRzM?=
 =?us-ascii?Q?kjnpK51Wl0oTLRgnmC5b0dYeOPKvyU0Y5ysDXdMfopCRslP2Tj9WB6wCcZzv?=
 =?us-ascii?Q?Tqcj2L96ELqiG4L9EPqXRXf5kB4mI+BfO9RNfOvEbKAaGFc0P425pXcw+ws6?=
 =?us-ascii?Q?Otv68AX+d2enCNhsn1MnTU89lvNkXYlZp2s2Rk+StPNoTIFVIDG/c9D+6tz/?=
 =?us-ascii?Q?OSRmDi5iJUJqEea4xn6vSYRvhb5QAygmccUPwejKlGIHHf7vJgLjm3WTy0sJ?=
 =?us-ascii?Q?OaOny+Jaeib5hAbkIvXK9Yetvax0O3Dx69+6zsPxmIYkuPkiGYNY27CcCnDk?=
 =?us-ascii?Q?bdIgEETWJZEOcTbxzJ37B+JoULmlU71HdI5uDz01fXVqdzDv6o0yITRj0mwg?=
 =?us-ascii?Q?KI+iWZxHmbsD9WNWx3wHmiDhdQnd1GjPRfHhSBaeKkKHBu5O6UN7cN6kgUfS?=
 =?us-ascii?Q?p05apA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d363a1c-b418-4d2a-c515-08d9f97c6001
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 23:04:43.3031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHuDd8SUQA4rUrv2UO7Rf46U/qbPqzkWp6lGRel2wGsDZiGqsnFVJolOIW42JixOqA2QQW7LPBvdTDp80HIzUSh5pO1ohex7OJRnqm4OAiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10270 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=880
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260163
X-Proofpoint-ORIG-GUID: TX7q8e7VJ1Qkcear6t-TXCv43_6W_hFX
X-Proofpoint-GUID: TX7q8e7VJ1Qkcear6t-TXCv43_6W_hFX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In:

https://lore.kernel.org/all/CAK3e-EZbJMDHkozGiz8LnMNAZ+SoCA+QeK0kpkqM4vQ4pz86SQ@mail.gmail.com/t/ 

Zhengyuan Liu found an issue where failovers are taking a long time
with lots of devices (/dev/sdXYZ nodes). The problem is that iscsid
expects most nl operations to be fast (ignoring mem issues) and when
the session block code was written blocking a queue/scsi_device was
just setting some flag bits and state values more or less. Now a block
call will actually handle IO that has been sent to the driver, so it
can be expensive. When you add in more and more devices, then a
session block call will take longer and longer.

This patchset moves the recovery and unbind operations to a per
session work queue instead of the mix or per session, host and module.



