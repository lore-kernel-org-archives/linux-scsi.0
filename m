Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39790C7EE30
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 16:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjEQQxl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 12:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjEQQxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 12:53:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1BE359F;
        Wed, 17 May 2023 09:53:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HE51Sf001687;
        Wed, 17 May 2023 16:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=hv9PkfY9MA6Wd4sgSjunXaaXSwDQEEJ+dakuXMaLecM=;
 b=iL47dtRddKYDCwON0C7hKsGXoavyefg/NpY7Mb6YfNvlPboletSCPDvZ8ygZz2rUiPCl
 xLdTTKD4MzwT5ByNGp6yxIS2gYgTnRJxdfraUwX8A9MqPn3F4/ockYNG00RM9dA2dM8w
 NGOqaSY9LM/Zx0V7NZmo4wlg1zKn+/4Q3uEU/J2ciKuCDLS7o9Ns6WhTXJjrsxn4G+aX
 HZLm9pP6S00v4ZgFIJDPBf/ghLa3JLxdKfV6MJ0k1Gem2+esP8DWYHN+LESJJBuTcUow
 h1aucPN2rY+PFkTt+qMZMSmge46u2QwUvnTOOiSJNrmBCL0UsA4/8RedX3MelOi8+xpJ zQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj33ux0sx-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 16:53:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34HFiwcb036399;
        Wed, 17 May 2023 16:40:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qmm02ntpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 16:40:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B00lZ19T2kmLlqswuD/VcSM2xnzSAjHWMdh/bDh7K+JZzO5nBhHem1gy/Bw6QFORDP2sJw2ZOK8u4ITnFOVEeL+P1lDTYKDqU0h5JnegHIbNZe/Bbb9e1Ra3AB3K19eBd6WZVnK8mQ9t5jWrNfyYzheSbrPqefk6af+qamovi3lys/H96o8oRdHs9ZKsSLLmwG9LrWNt+TOEm0fn9yETegaPy4t+S0kqi4l9VsjQcnDb69Yss/yEq4jRB1u51+M2sJAaiv3q+XekYf/iHvdj6XCi9wPWWTVf/sUyWoOqFO6TnrBIamRfhhneQ5BCJfAycyOz9droAdKB66iJQ/BOpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hv9PkfY9MA6Wd4sgSjunXaaXSwDQEEJ+dakuXMaLecM=;
 b=l28qZCJoD70hWw/0d3TI4WFCqNiasokGz9MEnJ8yQ/MJnHLQ/3f+DVy6leWP4VKP9Dm/f+iMGA8GMUxvWu34s9v+C74gNKYX7W901Y+a7cvWN1u3gNRfwpY/tuFQtR1Gir6mWh7+yasPDtpwdqzLKuxgWPzB+xC1y0425/+LglKY9bhZNm2mk1hBq556Uwut88szXqbzdxBw2xixUkHQyJLaCymkiY3uN8t0kxXtOU0Yc0Os2FeVSExXzdfkaq+OLZValIAeGcodEaP1UZkB/+V3VYubbt8IiQzn1ssF5y0+2uOdQhaFA7tzfiGzT7msz83ehOXznlDzrI5KJUCKKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hv9PkfY9MA6Wd4sgSjunXaaXSwDQEEJ+dakuXMaLecM=;
 b=mC9YeyBD0H/TFFcGMP0cv06O/tepLOON3dM0/aHTS0Y4dEYLcVQLz/Yp9BENOoRlXqMXexam1vyE6xAy7tlPkSek1ihLAulpmLBt3P3fje6aOOKtRLCBuojXJi2V0yzDTcIILzwzvJ5PG151R7Gbh0o7k5QDMx6b2mzqsrT6MQI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7668.namprd10.prod.outlook.com (2603:10b6:208:492::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 16:40:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804%7]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 16:40:47 +0000
Message-ID: <17aeb219-f950-1e8b-4897-ee92baa408d8@oracle.com>
Date:   Wed, 17 May 2023 17:40:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
To:     Sagar Biradar <sagar.biradar@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        Gilbert Wu <gilbert.wu@microchip.com>,
        linux-scsi@vger.kernel.org,
        Martin Petersen <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Tom White <tom.white@microchip.com>
References: <20230516001703.5384-1-sagar.biradar@microchip.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230516001703.5384-1-sagar.biradar@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0502.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: 20fc1c3f-85dd-4797-a99f-08db56f57751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+6UA1wNFCyj1CbBXXhYVBGB1kdZvXhZ4rO3regOZGr/J/5FXBpkrLQXbWcaIhm+Aa9JUrwPgHuE1RIO1AtJjAyjzgCgpPy4YhjBV4x1F/CmKwh/Gr83xXbDaK7Z/vkMKvVLnAqyz7en54g6QOD2xPRBXI4lRuOmhxYHW2GAe7iNa0mggf9X5W4/NlHP1fE6j0MN4O1QmmIiGNuyqt6edktd00pocFPIKzIVO2MY6kzfWHu1HvQWa3+h6XUmm2f+xybmUm/gk+zSzMaozyyfqcvSAbVNp/frMLs1ZyNLEGZjjjQtDSlBSNb0U9nY7dHCr/lxhvljo/0hyn8vrtcobHBoMuryO6GntJ2qojb0RdSLw2eXJ54ZU0ax5TEDepMGJut89s2yXcQNFoZnxVxQx4H4q37ViaRuEkIPVj+QD+8RZakWzHkeSjNhUhFbOXl/EArItLUN4L5h1mkouMTV9q1Xesrnatn4ajD28dwdRxbVugQb/9suRIMlOZVQ3Nht0XBuIltTICN0GH/suTegVoq4aJZS0lkElLtBYNg67d0xi2+xMrA/peRkL6Bvez8jBGVyq3SlrHv3iimXX1XUIF036KashAcBRcfjXa+9gP7B9WTzmJ2Bk/ST8dhYs+XcGbOHmr1x2WgZnp02AC4lmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199021)(31686004)(66556008)(66946007)(36916002)(478600001)(66476007)(110136005)(316002)(86362001)(36756003)(6486002)(2616005)(83380400001)(26005)(186003)(53546011)(6512007)(6506007)(41300700001)(5660300002)(8936002)(2906002)(6666004)(8676002)(38100700002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkhXbElpWHZjSWhVTU8yYjZaVUsxR0dhbnJ4amV6Nk5yWm5venFpVzhrckRw?=
 =?utf-8?B?eGdndStKaGV0WTFUdUUwbVlEZGdWNmRVSFA2NUI1WWhzWWNPeU1ZZ0JoRHZX?=
 =?utf-8?B?eHJaRjJnbkwrSXJWQWNRQmY1QXV6Y3A5WjVlTnF0OU92a282VDQvVEswc1FZ?=
 =?utf-8?B?TVpOV0VUSDNRZE92dEU0dHVnVlh3NXJ2Q2tjV0N5WXZ6S3YzZWdsNGp4ZXlH?=
 =?utf-8?B?ODdJc0NHYUt5ZVpRaWhCdkd4Q3hlNEFUYTFjcGpSUk52NVBGVk1BN0pMMUxn?=
 =?utf-8?B?VVc5K3k5dWFNbjdqaWJiMEV3YkQyUjVGR1VBT3R4ZTNTcWVaKy8vT2ZnVzlj?=
 =?utf-8?B?R1N1QjFOYy9NYmM0aCtJSXZyZVpTM1IrY09RcUhuaktHbHBqTit0RkhKMjcr?=
 =?utf-8?B?NUFPV2dVelVvZEFTWEhzZUkweFloa2tZZGJHR1hieDkwNXlKTmQzNTNTL2xk?=
 =?utf-8?B?cXFzOCsxeTRMbzhvSlhTQUg4d2RjbUZKMWZmRHJxUjl3L2UwZU1DQnBxMG01?=
 =?utf-8?B?dW1iTWkzanV4eHN3WUplT2VVeHZkT1RNQkhSSmJHbGpnanJWbVQ1d2w0YTJW?=
 =?utf-8?B?QnU3NHA4RkxrbkxTcUcyQU9EMHBRSmYvQUxYbzl5MFA0S1BUK2NTUUVlQVZS?=
 =?utf-8?B?WExhcmZidEszTUY0c3hva3ZvN1pOOGdFNXYyUndRWGljclJIUi9Xbkc4bVpT?=
 =?utf-8?B?WC8wSW9wN3phSURHNXBrclRvWGZ5algrMzNmL0p4M0MwRW1HcHBCRm1WcjJF?=
 =?utf-8?B?cnNjaUJ5NXd4d25GY0FhSDM0SmVXZXBxQkhGVGVWR2xtdmZNQXY4YWw0Mjd6?=
 =?utf-8?B?OE9Tc0xrdXRnUDhFZmpyYVd4TlliQjYyeTFaL3N4bE5TMDFUOEJYVTFSMDVo?=
 =?utf-8?B?ZmlIdkFXcG9tWmcvM0h2VzNkREpaS3Bra3MyTXNwUTEwYUtuSDQ3RzlqOUdu?=
 =?utf-8?B?ajhmck5VbW1lTDRsNGFlL0tuc2RkSkRWL3Z3ZDZXUTJKWVRoUEduZG1uSkND?=
 =?utf-8?B?bG11eEYvQko2WFhESVRkMHRZeW1wYkdxUFRWb2t5OWJNRFdhLzNPaGtGVTJw?=
 =?utf-8?B?K2dEUytDNkJReUxiM3JMN2JEZ3R1bTdjUXR6eUx0MURxUHFKTldqVk53encr?=
 =?utf-8?B?N1pwaDJFNDlVYmZTUUFMeTJEbTZoejIzWEN4VXRvWTlxRnZLQ25FNFlYODNl?=
 =?utf-8?B?RzZhQzcxOXBDcUJramx1SEJFTTQzNk1HNkxRa0J2ekszeTFsTkVqVjBCU0kw?=
 =?utf-8?B?aEFBdWlTK3lyV0QzZTZhT09VZ2JxUHRjbmdma1czbGJpYXJvME0wekcvK3d2?=
 =?utf-8?B?dXpLSXVlQk5NcGI2UjhxQkoycDFoZE96cVREaXIwYktEOTNZQ0paRWxDMmY3?=
 =?utf-8?B?WnZVVlZDSFlUYWJ2dlQ5QVRaREY3UmV2Qi9vRWdjV0RWOHVsRjhGQlU3ZGxk?=
 =?utf-8?B?M2E5M0hoQ0JiVFRnVmM2UkZIb3RTbitKSXVpWnlxdEN5dDdnWjd2YVNQaTFL?=
 =?utf-8?B?djRIbFY4Q2FWdFd0YWY2SmJ5cE41bnJnWWY0RXB1ZGxFQ25UZHdXQVpiZGIy?=
 =?utf-8?B?NGtxRnlMOUgwMVZWbWNEbDc2N1YxSG9oQkNQeGlybVZ5RGhHWG40WmJjNWlj?=
 =?utf-8?B?WlozbVhlaUVrN3F6ZWhsZ0M2eVdMY0p6VUdyMTBVU2NpYXJxaFlXdk9FUERZ?=
 =?utf-8?B?ak93SDVQdHVUSHg3RmN6MkFuT2svaGFPVisyRVkwbEJDTm9CRjJYc2QyajlL?=
 =?utf-8?B?R3E3eENtVUxReFZld21XWnNrVUtvVDkxK3VadnFDZVcrVUtkVkZDT1pTZzlO?=
 =?utf-8?B?TUE3QkF3QTdMYVhMNmxSSW9PaWR0bmorM0NRU2R3Wm9ZOEpMUEd0UHVlNlZl?=
 =?utf-8?B?cHQ0ZTlsUndmalFFbzRlWXlUNTBUS2NaZ0FFbGFnckJ2K3ZUVTZRRXlCWjRr?=
 =?utf-8?B?VXpUSlVHZXpiem8vK3k2ZXNjOEtRZHNkVHlwMGR3MnNhc1ZGOXVzSmZCVHZZ?=
 =?utf-8?B?RVUrU1FHRjlIMERTZG51TDBzYnAvcmZRcHFnRWtGdFUwZUdtVVFMTnRuNTE3?=
 =?utf-8?B?NVhTQ2psMzdMZHVCUHo0dytPcnpXdkxkbVpWbVEzcmgyczMvcUJrcStYcFpk?=
 =?utf-8?Q?5evBECg//hkFIw0OfyeaMFbUd?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ovli/9uagM41p0rBQcyCTCSzEhVDvI9m9wiVw0Rp8PSZwWJtnCbVyfCL99uVnQnmNa3GmPejnfMrCEataXppUmtmq6eDBcOartcvaAih4ppAuVyMrL1LMgy70YObRQMVGiwZRqvd/+klhRdsZHX7x3XZAc0ARsHQbAANFgex4hkk3l5dA9ZI09OkjeiW62mYRyM42uRqmS8vXdCDPju86n5PL/fRLWqwgOignIW3Vs83uqP2QOet1Qswzbo2M1HfX+WbJ/OGOyAptXK7uxjucIgPrenai0NTWdK4L9W3zWXw5a8r3AtcDsh73O2wKn9EaLCwWVHkjBUQ5H+0KWr8Rm+eomtQFRhGt7e6r8secHDtxFko6sd8+Wv4EBSZ8f6xtmS+o90DF5zSnG7D4eok0ImOBBTKHaQm8kH5btC6LP8i3xnnvcnLFjWl7yKYN6hZ2yJpDIXGO9At4V+106OTfDrJAzLYoBeaFDvBO1zKH5oBQxVAEDoEOJAba7Nw4EoUv+khrMMcT7jNp7osV8cH9AgBr3qkXnCaYndfYpMC7Uf3G6gYqja47lBhO9c8hINIfetWxgr7qgmniarEqmcuDLvwELcBsYaba7DkHr7nZlM0aD6DTiBW5/ytGGHZIbYVrGbIIinwYD91+XCiYzeNR4b0qkehyV10il/uUc4bIBrRsMwq6lrd5gyQ8JX5/nItu8LzbN5dYSxJ8qlo4ALTaNX5bjRD9pQ4drIsKVEyC12hNwa4lWORy7jvBWtselprcmbx5NgDciyYBwJjiZczGs3Yo+/xLKiPVPxd5lPmYe+Ps6lJA9BWFuCJmruAEJr043iY8+W3h8DHjdzgiaW5Sp9+Xfpy/wnAj4iEsDb+svfGS3iJQs4SkXkXZ1cTdhg7
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20fc1c3f-85dd-4797-a99f-08db56f57751
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 16:40:47.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwyOSTnxUbtFkqVb0583q3vlbOo4ydugsesAIcCFa5jkw6UnwibRKSVaK6QJ1zVXWBmk/HkWMtSL1lz6bQSMxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7668
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305170136
X-Proofpoint-GUID: 4nJnaIeu3r-X9MoRi2YG4wcq1Vs1F5QG
X-Proofpoint-ORIG-GUID: 4nJnaIeu3r-X9MoRi2YG4wcq1Vs1F5QG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/05/2023 01:17, Sagar Biradar wrote:
> Fix the IO hang that arises because of MSIx vector not
> having a mapped online CPU upon receiving completion.
> 
> The SCSI cmds take the blk_mq route, which is setup during the init.
> The reserved cmds fetch the vector_no from mq_map after the init
> is complete and before the init, they use 0 - as per the norm.
> 
> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>

this looks ok apart from minor issues, below, so fwiw:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/aacraid/aacraid.h  |  1 +
>   drivers/scsi/aacraid/comminit.c |  2 +-
>   drivers/scsi/aacraid/commsup.c  |  6 +++++-
>   drivers/scsi/aacraid/linit.c    | 14 ++++++++++++++
>   drivers/scsi/aacraid/src.c      | 25 +++++++++++++++++++++++--
>   5 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 5e115e8b2ba4..7c6efde75da6 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1678,6 +1678,7 @@ struct aac_dev
>   	u32			handle_pci_error;
>   	bool			init_reset;
>   	u8			soft_reset_support;
> +	u8			use_map_queue;
>   };
>   
>   #define aac_adapter_interrupt(dev) \
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index bd99c5492b7d..53924912417e 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -630,6 +630,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>   
>   	if (aac_is_src(dev))
>   		aac_define_int_mode(dev);
> +

stray new line

>   	/*
>   	 *	Ok now init the communication subsystem
>   	 */
> @@ -657,4 +658,3 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>   
>   	return dev;
>   }
> -
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index deb32c9f4b3e..3f062e4013ab 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -223,8 +223,12 @@ int aac_fib_setup(struct aac_dev * dev)
>   struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
>   {
>   	struct fib *fibptr;
> +	u32 blk_tag;
> +	int i;
>   
> -	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
> +	blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +	i = blk_mq_unique_tag_to_tag(blk_tag);
> +	fibptr = &dev->fibs[i];
>   	/*
>   	 *	Null out fields that depend on being zero at the start of
>   	 *	each I/O
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 5ba5c18b77b4..fa53a9b3341b 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -34,6 +34,7 @@
>   #include <linux/delay.h>
>   #include <linux/kthread.h>
>   #include <linux/msdos_partition.h>
> +#include <linux/blk-mq-pci.h>

generally alphabetic ordering is preferred

>   
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_cmnd.h>
> @@ -505,6 +506,15 @@ static int aac_slave_configure(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> +static void aac_map_queues(struct Scsi_Host *shost)
> +{
> +	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;

this pattern happens a lot in the driver, so I suggest a separate change 
for a helper to do this

> +
> +	blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +				aac->pdev, 0);
> +	aac->use_map_queue = true;
> +}
> +
>   /**
>    *	aac_change_queue_depth		-	alter queue depths
>    *	@sdev:	SCSI device we are considering
> @@ -1489,6 +1499,7 @@ static struct scsi_host_template aac_driver_template = {
>   	.bios_param			= aac_biosparm,
>   	.shost_groups			= aac_host_groups,
>   	.slave_configure		= aac_slave_configure,
> +	.map_queues			= aac_map_queues,
>   	.change_queue_depth		= aac_change_queue_depth,
>   	.sdev_groups			= aac_dev_groups,
>   	.eh_abort_handler		= aac_eh_abort,
> @@ -1776,6 +1787,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	shost->max_lun = AAC_MAX_LUN;
>   
>   	pci_set_drvdata(pdev, shost);
> +	shost->nr_hw_queues = aac->max_msix;
> +	shost->host_tagset = 1;
>   
>   	error = scsi_add_host(shost, &pdev->dev);
>   	if (error)
> @@ -1908,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)
>   	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>   
>   	aac_cancel_rescan_worker(aac);
> +	aac->use_map_queue = false;
>   	scsi_remove_host(shost);
>   
>   	__aac_shutdown(aac);
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 11ef58204e96..61949f374188 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)
>   #endif
>   
>   	u16 vector_no;
> +	struct scsi_cmnd *scmd;
> +	u32 blk_tag;
> +	struct Scsi_Host *shost = dev->scsi_host_ptr;
> +	struct blk_mq_queue_map *qmap;
>   
>   	atomic_inc(&q->numpending);
>   
> @@ -505,8 +509,25 @@ static int aac_src_deliver_message(struct fib *fib)
>   		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
>   			&& dev->sa_firmware)
>   			vector_no = aac_get_vector(dev);
> -		else
> -			vector_no = fib->vector_no;
> +		else {
> +			if (!fib->vector_no || !fib->callback_data) {
> +				if (shost && dev->use_map_queue) {
> +					qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
> +					vector_no = qmap->mq_map[raw_smp_processor_id()];
> +				}
> +				/*
> +				 *	We hardcode the vector_no for
> +				 *	reserved commands as a valid shost is
> +				 *	absent during the init

you prob have another way to check this without the need for 
dev->use_map_queue - that's just a guess

> +				 */
> +				else
> +					vector_no = 0;
> +			} else {
> +				scmd = (struct scsi_cmnd *)fib->callback_data;
> +				blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +				vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
> +			}
> +		}
>   
>   		if (native_hba) {
>   			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {

