Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E3BC6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 02:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCPCrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 22:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCPCrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 22:47:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAEBCC305
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 19:47:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32G0xxq5003667;
        Thu, 16 Mar 2023 02:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=7mq9Lf0kUtzwHrHw5kPEZ4SSwLr/Sc2X9+Y79ehMvjA=;
 b=BfXgLxf2/6uyKM/ebjdwlz/yqE21sGpqnPyQ93CZa3moYXd9ZiF77DO7qqF0rJIhoboC
 PP16nZ2XGVNwWAjC887EYPpT6tIS0Ta38t15rc0h4CCy2SfgU0DuG/ekjPbZ8PTQroFJ
 EhDTNWt2NnL5stKm/iBvf36Au59uxoVqPj9aMMocQ0NrA71GQxzmj7ZD4ienSm/8xIE1
 PHxJd4IIS37SQyGMmc2tQ6SuNVQ8taTYd7aIvovEhH083sj99YxyPJ8e8YSz9X6+og40
 EjY6flGGO2rtC26OFVGGnetNJI2wiYXRyAP2tMvgVy1mgt6Kn3lLfNsIgNusL9XoRVko Kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs2ag33w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 02:46:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32G20J3c020428;
        Thu, 16 Mar 2023 02:46:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq45nh56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 02:46:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nk51vLAgnItn/6qfJOnwy4Nxpi9jKQPax1TJ+24w2aiTRDRUDzbBaDNF9ywbtb3jH9CjFRnlEfdmy6jxPxZob1L0H/CWXx4WqXLRcg57IzbE8XwGMtEwLKGAayYPQ6MAyGahkoUH0/1gkyq6w9dq2diE8KAPkUD5D7l3TfCS7qtdhRyEZmUofXIkA3n50eNyPtINve49myj9GIE2jumU1BwoHucJojjHk9cDx6RxRtOjqLiSpqBqMRNMhXUBPKLK1sa/6MxgE9K31gtw5CApGhxcQ2U+ZCcl3hjdPZEJFaEzP/EgqjYcAfTqu3iLTkvouUAgaJZHDGXXQGuqjkKtmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mq9Lf0kUtzwHrHw5kPEZ4SSwLr/Sc2X9+Y79ehMvjA=;
 b=lDbyA8gQ/XmL0Msr8LVIMrZt3RAy1VRWtqrwIRh2WyJYsTXfwXgMn+IcrE3IofCAg9jeMGKrHskF2xeMMbLQ5g3piwVYTwstWmCOc5pxy9rFntb8/vpGWjEony/mP+1KSLOakUPgICUmUJAWLJ5r/OcBSmgb5vkYb4xPbXXtGs55YMT6z8TJX+0XuOcWrKBiED1j9b6PSOokEIi6nP/s5cUn/iWxNjK+dvBxzwRgjF57vQeuldEsq/eERstxQr0uzH3Cviwm0oU/e5vIVN70CSggi7Qyr0qATQGp8O9/xhZnOay3v7v9h4qG63CeM/dRVKJ/R0Zo/Y46ocw94Rxsug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mq9Lf0kUtzwHrHw5kPEZ4SSwLr/Sc2X9+Y79ehMvjA=;
 b=GQMpwN5E47Xx6GcPFRiR/6avyAUqlRUYIcY5QbunBVSdB+rgphEMBzNy+BfHHeHGbtRf+uJKPMqZc4AQYVcLjgbts9uFtaUPHrpxzTg9MSeI6tagGJ4iLZNS4iuBX2Xc/QijUxI4/aqkrNweaa8iJJVDtgvAkUQaXXHyM0yqIQw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB7178.namprd10.prod.outlook.com (2603:10b6:8:e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 02:46:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 02:46:56 +0000
To:     darkpenguin <darkpenguin@posteo.de>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: Force ignore LBPME bit by using quirks?
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17cvh4eko.fsf@ca-mkp.ca.oracle.com>
References: <2162608f-7515-bfa7-9a5f-047495713eed@posteo.de>
        <d12671d8-c6e8-32c6-000d-8c28e9a0b71e@posteo.de>
Date:   Wed, 15 Mar 2023 22:46:54 -0400
In-Reply-To: <d12671d8-c6e8-32c6-000d-8c28e9a0b71e@posteo.de>
        (darkpenguin@posteo.de's message of "Mon, 13 Mar 2023 08:57:19 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:806:d1::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB7178:EE_
X-MS-Office365-Filtering-Correlation-Id: c2496c7e-dcc2-4898-1c65-08db25c8b4f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjhhtbereqMOkaq3CXUwZjL6LTTZ5j9U91mAsqEu/QbInKC2+skWzom/BwzleCIcpSO/jHtDE0Ih0P+notEILViYwsU/lUmBbhUWu+JhEZiH45LNwjCATgKnWYFcPkY93+Qui78KM6bb8XXjYJ/XPE75wDpL18O4bUJmr8GXVCClCtqIH8u/3CVvxUWj1Tr3ppfyzip3TFNet+aXvycz3zw8a7DJQjmRiDCTV3g9DzmeGuNJxP7luAEl/I/xy4SgYOqX7Mk447vSTgEncKcdFaxGKtR7Nw1DOoKghsi0ipVbqqp/RipPUvEry2NZ6UJeYLwF+r3bCB5pgCT5dUbKhCqyDiUDxyn1HEn/HkRr91y9FQBItjDoXc7N0XdFRd7glKSSGP7KyfU9UeQRUMgs64dQde4khOAOsDEFKizdL1cSt7KuySQTsan3oPUI2HP6e0uDATIiMB2efHilExy0zJ2uZikAWyIRpSW4WPXQtmiM41bupz+iA7vIDwFv7I5NEOZouH7qiCd0jSGKW9XQNMQXA7SVbvqEZPdmrx3HIxI9DUuWMImqTyBODnBz0PeG6GfL/03XkkwoUxKbWhWdD3fGCbAkFewjtYE5eVJOdfDEiJ8Z3K/TvJ5Qt5zEl7GltU/r12HVnERGstkrLWE2Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199018)(41300700001)(2906002)(86362001)(83380400001)(5660300002)(66946007)(6916009)(66556008)(316002)(38100700002)(4326008)(36916002)(478600001)(66476007)(26005)(8936002)(186003)(6486002)(6512007)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vq2RnPiT+McFff9Bnk1fXMMMAF3I0aH0nj913oaGbkTTDSFCBCFT25+4ztd3?=
 =?us-ascii?Q?bDCRuPPlr8waGCTn6WgxuvYJKnOqIlgPv8HfPMc3su8cZQ52Y3i/T0OsFL07?=
 =?us-ascii?Q?OuZiUkB/FskbT0xeVgAxPVSw5M1XL9A3d+8mVfwDXpOeZP32CNu55AfkNMc3?=
 =?us-ascii?Q?mg4B+I/XGs5yAKabeIhp7MuPj5jq6n8F4fvc4OcOd1Gm1qHQ4+9o257Y2+7P?=
 =?us-ascii?Q?0+wPLV6hPrForAPyh4vj/EjXkC365E7KDmU5COKclrrPVbxV+M1xegSOxlYt?=
 =?us-ascii?Q?BoGJ1czy//uXufXtjum9Kx3iTqr9/ZVgACHZG/cLe4XWCWtj7gNhNIWGvJoX?=
 =?us-ascii?Q?PyXoRTgLi7TtOVFNcmAtIPJjLYrWQbJ7endLyizSyhe8qtyRdvMM//ipuPl/?=
 =?us-ascii?Q?+pDfcVj4mae3AKxw1i0r5LO4tDiIjekATr0IbRSNlvF6ABC7F3XEYASXrkH9?=
 =?us-ascii?Q?9BT2D3KgBlhgen24goV7qcvZq+PZ4IEVWjMNg7t+ZPaN8TkeNkQUfScGyOa1?=
 =?us-ascii?Q?inSEioH/o9VSCzqhD+dKRGR5Voal2eR5q4TYii22Z9IhmM7qRpOMr1mv17Wv?=
 =?us-ascii?Q?fGhUumWmA86+4Up2fPvGcfjZwFpL9P8HI9i+ZuHO2ACPwUEHH8FyDTN3AceX?=
 =?us-ascii?Q?wvuy0ralpJoRHGy+vOLvuLUmbKd8la0V344g+sdgWh4P2Psq0iQECrqIX3IE?=
 =?us-ascii?Q?Ge/7uLoyIor7knriS4T66vwontf+UvEe1st20IqiMWuKO+R2ZpwkshhCfBEC?=
 =?us-ascii?Q?VU1ZGwJpu82JK0kWEEPJAXFyPme357iqCs6L+/CRpG//c/2BxcHV0Z4zW0ZP?=
 =?us-ascii?Q?g4syqkF4M6fxg4uMmgeoJkuzNldHxTQbFtlAJt5t7Q4GOzwuGJO9ypu7rXGM?=
 =?us-ascii?Q?IgCZ3kTp1OMNAhMgyO2CWZjpEHIvBKUKGqPe/LwwhrMlPOleeXx4WjH/Yiwd?=
 =?us-ascii?Q?ftTgOzbaRVoRl/h2966+EOstJUm17ScFMb6nQU+29O994wc0VgBJrCHHR3Sf?=
 =?us-ascii?Q?07Szg4pwRUzBBaG2PUTLSlwYuYFo8A8FNAvwGp+U/Ei/rLHF80tk30/N9hhu?=
 =?us-ascii?Q?afVoN9ltDf2zxCDPY3FC8F7mNTQU4Cf+bYVDgHJOtAH49ml/INOBicmbQy9P?=
 =?us-ascii?Q?OTXqKLx6eE+FB1iTKvCXObA2alAtzP3xb0KY+RGV+Zeaa3uHQNpP/Lt6JKqw?=
 =?us-ascii?Q?6KdpVtdkJpXjHA2lMkeqibVUk3vMV3sMGYfJLP/yqQkI6mH5Vcf11uUWlU3Y?=
 =?us-ascii?Q?xLp2piXCEsOKTCjzc7o0fUe1FIIBWFP2NT/dIE0C7kRz7fQIoOt2RuCo7QQ2?=
 =?us-ascii?Q?F2iTtpqbWzvH+4rRfTKbKcnXJzRPvWOgpJwmvvrHkQjivDi1cr6B6nlNLTs0?=
 =?us-ascii?Q?vcFnWUCcvMRfXUNIgEsq/w3IsWif+EoUv8Cq/2uWbOfxntv5IQI1LDrOnjNT?=
 =?us-ascii?Q?yogFgqpyu/z4RPa9pZdXmuwDhR1OysKKyHMAtWe9r/suV0BVUdA9UeB1W1QS?=
 =?us-ascii?Q?C6mJ+jblLOyeB1JSdCWJhmUzyODBuuYAk/ww9Gw8u5EUe6zEweUWmCDrkbOn?=
 =?us-ascii?Q?ayw+YwnTNFPJQSssjjTGMRDWwf7SlWkzWIhV4R7OsPhAutAVfLcjBQc5ikPO?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dc0nM/XQ0DYJeJz93j3Du7vqD3XwbwMyJASnywX5v5ITZApUV1kvad9ZQMY88c6zbbEPTXxuhYNXPwyuiQbOUbByK/Mbxi28KXlBwmZSCuuraJmaDvbFgjI37W3x3vlXVrY+yv/ih4YRfrN7vYZU4pEjLhkr2bPwoYs7wWpLeKzSNA5Q8RbettfuZ8Up024jj9n0BlIq5rR+0miD8kwQkSlR1ayG9/JMK9xtGzt0nopPFvgRgivSNlDWTbmEG0U/gAM5sLjyTJCL2dqikNpAfBZSoIp1VYqQybU2yuwCFuvW1/Fk+O3YrUDY0RxSEekXX8N27ItIud+3pNhbSBWEDusy5UTYEOARcnr0bi0V6oTygsJJ80i7PvGPdfX6XnLZ34DcqqL8gEdRd7WXc33EJKJ91fI1DBE3g1X9tAIZE4aDnVRkr+pHm+3dREMPauG6NkXm1r7TU7a1wvsnElrCCY8xioBQzcQCATx7EslRkf75ra+YPYRl+wxt3o1cjrXcUsUf0HxR9V0FzYn6NeAdIXC7rhTl4l9GOjWpBRnh8jbYQf+1j7eYxuntT3ID78UVUgRt6MTzvAZ9Wa2EELbmCAkrf710WdfZZONi+M7ZpO5YqjoE+Z0a2jglKfRH2tCjK4AVJGAfGFw5DxbM5XGzxilaVqZZIvoE3FaRdCEOGxQR1TjwkanEerqwGGB2Mo+FkNFeUdDBrKkuLpMB8Xeivs0W90wHcyECLP/mmS8eFcENL+OE9oLNrstj0zv1wATrEE6kuNr9Z4TKmThEEXgu7dHkAHftJS3p6SDPbpgALK0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2496c7e-dcc2-4898-1c65-08db25c8b4f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 02:46:56.5049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StD2UQlfzmWsQacAfrK106s7zp5R90nYiKh0NGPIg6AOXmYdp1qAbMZdSTye1MnvJ22ySg03y5/Dh/nCLVepOdzWalEy4lcK+QiOj2TtWE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_02,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160023
X-Proofpoint-GUID: d5qdnf3o4MouoD6wrNB66zmc_Ikct1Hk
X-Proofpoint-ORIG-GUID: d5qdnf3o4MouoD6wrNB66zmc_Ikct1Hk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> my problem actually goes even deeper. I see that you can override the
> wrongly-set LBPME bit by switching provisioning_mode manually. In my
> case though, the LBPU bit is also 0. Argh...

Argh indeed.

We'd need these reported:

> Block limits VPD page (SBC):
>   Maximum unmap LBA count: 0 [Unmap command not implemented]
>   Maximum unmap block descriptor count: 0 [Unmap command not implemented]
>   Optimal unmap granularity: 0 blocks [not reported]
>   Maximum write same length: 0 blocks [not reported]

and these:

> Logical block provisioning VPD page (SBC):
>   Unmap command supported (LBPU): 0
>   Write same (16) with unmap bit supported (LBPWS): 0
>   Write same (10) with unmap bit supported (LBPWS10): 0
>   Provisioning type: 0 (not known or fully provisioned)

but they are all 0.

Last resort would be to see if ATA DSM TRIM passthrough works. However,
your device does not have the ATA Information VPD page either:

> $ sudo sg_vpd -a /dev/sdc
>
> Supported VPD pages VPD page:
>   Supported VPD pages [sv]
>   Unit serial number [sn]
>   Device identification [di]
>   Block limits (SBC) [bl]
>   Logical block provisioning (SBC) [lbpv]
>   0xde
>   0xdf

So I'm afraid that we literally have nothing to work with.

Is this USB storage or UASP?

-- 
Martin K. Petersen	Oracle Linux Engineering
