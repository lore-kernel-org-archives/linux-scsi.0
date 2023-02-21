Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91117C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 09:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjBUJRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 04:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjBUJRB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 04:17:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9665713DC0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 01:16:57 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L3ihbm016803;
        Tue, 21 Feb 2023 09:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XSr/tLvDhtsfeUQnMcsVSNziljG6QGe3YGVjQu+kgoc=;
 b=i4Gbm4/zAYW1HSk9u8/QowDv2bhXE9YGaN2K+aMChiii7c/sZIe/TQ4JjOaF8XjmT4rT
 HpvD3/RfYa7g9FtIJ5EmlyZx5BSX5e0zXXL5C5qN5lDC8XIGNlbWc2jpZ+e8qj77v9+5
 OeVddmNMQGGIQqTmwIMt+/Ri9nfjDoFqGgOWCKMzVk4WQpK49LRRzJju1D2UFqkqJ2jy
 ozOABuMWq0nR10bVZsvxi14qZ6Pr+0OYdJV1v0R9gulMEZkCBjxYrWctpO7pnheJHAbW
 2Z1tfp/1gK8xMvnj7o9obg3P8VIxzKzcziS++gxmMjQSFM//zwMqA/LlCl5q3ok1mV09 TA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9tmnqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 09:16:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31L8rgI0006666;
        Tue, 21 Feb 2023 09:16:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4bcy63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 09:16:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUATglfr3kWFg9f+krXtZk7bSapzgj29MGzb7RDnYcLZnILZ6HxT9dfkGwFwM+2Vi0pfoEqIWbIIAA+ngP4hYz+zBk/q4E07tMpEHh+XvcYOC0px1i5jEmTy3HTX2ygQk0koR2a6n7fHJoV9HgiqIOz8Go49iZ4mJZF2Q5IFfYb2o2MAs7xerIhdbXjTXRt056xOuDRdvhJMh9SqIDUB/0OGAM0T4v8GP33gQcW0HVgE2caTRmMlmv2Aob0V1M++t6md5KpJXVn6hzBC5nsWClcMJzWgEQcif3L8uXmc+EzeD7ANJ3lROZcVw95m0qrLqBcaNZYDqnNMFWGoMfCxOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSr/tLvDhtsfeUQnMcsVSNziljG6QGe3YGVjQu+kgoc=;
 b=bhstY1WFcQnx38cxTC+M6scP3ShWhV7Jmo/H66/Cz5sR5Ka4eu1iRu1AykQNJmBAx8Ivq1SKV+Es2mKvl0+AwQkRNE5s3bfGNWnlyjaldckH3Hda3Dx2jkysbmXgStvuY9pmfTj465F3ypd4pukBB1T/DQ5H6l9+TNO/wNqgT6mG2BtgmGc9ZHVvcKzqcbec3Lw04YAX9OAPCeMzNvTn/RAsf4xfg4x4FP0dpKxftJ/fNGz34mFp7A81bGDdebb9sPKXv45FSa+jW2NAfBJV+5rpHmiTkOB5HEBZFIf3roueacwJLUNvP2qchtsxpHfwufshaOes5msqESJnJmk8bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSr/tLvDhtsfeUQnMcsVSNziljG6QGe3YGVjQu+kgoc=;
 b=zAV+qQ7NsbGeQq9zU1Xfm2qAV98XzgqPgiscItpU41Zz/EtTnQFsxDJ9lFS/JbnM2n9ApkGuhy4OUKpF9kdci+T3kcPk77tZL+fYHMQRBI0GcUAPr1pwuDMRTkQGuMUwqEwflxlruttdm6GMWGIYWBvZ5Esk3T3U82N5MG3DtFA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4581.namprd10.prod.outlook.com (2603:10b6:510:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Tue, 21 Feb
 2023 09:16:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%5]) with mapi id 15.20.6134.016; Tue, 21 Feb 2023
 09:16:34 +0000
Message-ID: <2b4cb6ba-d820-b1be-f0db-4d93b6da7d39@oracle.com>
Date:   Tue, 21 Feb 2023 09:16:30 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] scsi: remove unused sd_cdb_cache
To:     Fengnan Chang <changfengnan@bytedance.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, hch@lst.de
References: <20230220130530.62854-1-changfengnan@bytedance.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230220130530.62854-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0101CA0054.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4581:EE_
X-MS-Office365-Filtering-Correlation-Id: e7d15a04-5f6f-4254-6451-08db13ec53b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ry6WspT36+ih2j9UeO+MMUk1LjPbjvEcxauhq1+CWUxbE9GcK+xUHhqcjRijFbLVVVhXw5i5sVMvmheNqb9usITMQK+0kRHkGnh5rfVptfIeLKxGNTeYP6B1/1q/JyhfVh/d6XfSDjSlyATPdqpEkGpRDUNCj4ERddvcwaChc2OGC3BuoRcm47hkuiIchLireizSZdwWBekolNB33947iwrXwH5NLoffhv5Cfv9XsUHYKDkneM/aDz7Img/E+f5jVMBgLqZve4TT30co9UFwOpak6+7diAGSSYdVmfQnOSI+9be/6vJNuTTO7FXjA1nwydRldTUmR3DbOaImKoqQ39pVC9ksXCu+g0V8l5dP8VACsnw9r3THBpj0Z4/rv6kdGn1+pI1Ikl5IhVqo//343L2R1a+47F0nxUTsnBfdTTbP7O8b9ROdrhDi6DwYZMYVxzgv8eCb3m6yMwV0tA6JN71QClcx1Aetth76SnPaaocTXYyqhSqb0Jq2XH7vM2GVew+ZCdIURbh/XzADlvxQBxM/XqbwLj9GtXMvPpC/I8np3Pe2b6c7r3Qw+Gowm+nOTOMdG6T/ZxM9V4IwDossTZpV+K8OHjiURDCLt5bKXcM+IpJjW0Op/bcSk8iEeFPDUqk4V/ohfIg0U9I5CzijRw3AoI3kkwdK9JzNGi3BQTjwJhJj1rGhLW95BC4mwFm245RQ3EJeemnAJdzsBN8FAN3RmsFTo1X0sMvCc8N6NfI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199018)(5660300002)(316002)(6636002)(8936002)(4326008)(8676002)(66476007)(26005)(186003)(31696002)(66556008)(41300700001)(66946007)(36756003)(86362001)(6512007)(6506007)(6666004)(53546011)(38100700002)(2906002)(2616005)(83380400001)(31686004)(6486002)(36916002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVlwbGsza01OUjJHUko2aEZyYXA2alpJM1JuR1NqUnc3ak9lTWNFWG93V3NF?=
 =?utf-8?B?M3V2dTFoZlN4SmpJVTNxT1hHV2YzcFl1eVlPcXFFeHh1bitzTUZEL2NHSlRD?=
 =?utf-8?B?dGhhSXY1VHNUU2R3Y3BoUmJKNnFNQnRNT1dKc1RDM0cvajdTYWs0Rm94Rllj?=
 =?utf-8?B?SGtOZFhvVy9YWitpQWlONXpibnRMdEZPZFB4SHZLSWQvNG1FaFdMNTFjM0hT?=
 =?utf-8?B?Y3I5QnJwWHhXVjF4L0VKS3ZDN1VUSTM5TlpTRy9SdzlHSWszcWo3dkVsZFUr?=
 =?utf-8?B?ZVYvVFhJSWNidkp6dWVWTFJETno5QXBPWmJyeXM3N2F4Y3dZWEpFazkvZ29J?=
 =?utf-8?B?RWNNOCtzNVBHb2QxNWdCYmJQT1FXSDVhM2Z4OHhmbk5WS1B5OVU4TXdTNU8r?=
 =?utf-8?B?SEdVR1FwMVlrMWVXQlRLbmgzczdDQzd4WWlPSU5jY25MQ2VIVy9iVnRnbkxN?=
 =?utf-8?B?UGJSYTVBNitpNlNVWWdpUWp5ODRtVEhUaDNPMFBSYjc0ZGFXck5sM1p5d3Bx?=
 =?utf-8?B?Y3BQSTZCVGZ5emtZa1V2YVY2c2RMU3NQV2tkbGNjQzlMbGtNNDRlQzRiSHly?=
 =?utf-8?B?b1VwNnRxNTFMblZLVlBWR1p2T0lPTnZvRDZPTXlDWkRpS21xc1plelltVjRx?=
 =?utf-8?B?MlVKeUxuRzJuTDZRNGROVGNlZlBVd052UW9IQ1lSMC9ITFErcjR5ZE1ic1Zh?=
 =?utf-8?B?YmI0eTl2WGpCZEhjdUpNQnRXYWlIOExlaG5qTC9MSDhlZUVmZlg4MEQ2bDZO?=
 =?utf-8?B?YjQ5cjVhWHR5eUQzME01SWN2alJCK0tQN0x4dmZWd0J3NTdYSFJXMEZWL0F1?=
 =?utf-8?B?WVk3R2Q4WjdtdVZxZWEwL2ZRRVhnZm5ZQlUwVXJaM2VteEJyVHZJQ21kY0VS?=
 =?utf-8?B?cGcvTHc4bnp5UnRqS1BvdmUwTVFyd3hXejRZaUxHOFhFczBiazVvRGZ4bzhS?=
 =?utf-8?B?SXB5TnJTTjRpOGRRMDlaYkhHWkhsM3p0TWlNeXl5UEZWODFkcS9yVGgrd1FD?=
 =?utf-8?B?ek03MnpDUGdwR1dPMEk2Nkl2cWRxditVLzNMSllua3hhSHlBWTJQZTNiVG9F?=
 =?utf-8?B?WUNTQTJ5M29CRHJRbzlEVGt6NWhhTEVFY2FCbG9QSk5PZDh0RHRpMGhQbEVR?=
 =?utf-8?B?Qm9iQkVLVWdJNWo0U3Y1WTBTSFZwa09CNjFUNkRsMzUwVSszUXFXditMTi9l?=
 =?utf-8?B?b1RISGtoTlptUTNDMXIrbmdMbjhrMEVlWjhOeE91YU1XQXpiL2s5WDdZVXMw?=
 =?utf-8?B?L3JxbUZjdTNxaG1HeVdTRUNvZ2hVbHFBdFV2RmdvNXFRbUlXeDFsSmhZMFYw?=
 =?utf-8?B?R29QQWhGVmovZkorWkordHFFZUFUZTFBSm1DZkdWUEdKR204MTZmQjNBanda?=
 =?utf-8?B?V0pjaWN3cUUvWFNXSVVIdXY2U2wxakpwMVZWcDlYcFZ0UEV0Y21vSjdXaitJ?=
 =?utf-8?B?Z2o3VFJBQzk5M1IzUWIreU04L2JUTWQ3QjdpWTBDbUtEeEFRWFJvVEZIbFhm?=
 =?utf-8?B?TFRqOTZBbFhTa1ZiTVZ2MkkveCtRaGdTQ1Y4Y1IrR2YvR0NCYmxvazlJZGNh?=
 =?utf-8?B?MmlIbHJoaG0wTTEyNDJJWTczYlRyNnVBb1JpVk1ObzdycUtaMDR1NU1qSW9M?=
 =?utf-8?B?a2FDUjZJVDFxaEZ3WDZFcnVYSnduVlROZTU1TUhYZmtSLy9RMTFZejBGK3Q1?=
 =?utf-8?B?SU1VTDNCdjNtMkJ3ak5SR2pOWnJLNWhpVUpYZllrSlQ5M3gzOWRBenBmZ3lz?=
 =?utf-8?B?YjlndHNrdVZjdDlYMGpZME9NeDZ6azF3SW54dDFzSmlYVGZQaUovTjNLdytv?=
 =?utf-8?B?a1o4NDdVSzZzU2ZNMnJiSnByWm5lSkRLUEpHZm9KVUR6NDFEbE5jVEx2T0tZ?=
 =?utf-8?B?dUlxd1FseGR4M2tjYWV2TEQ2UXRuSXluRUhaY0xPb2t2eGpKRW1RRVZJZmVT?=
 =?utf-8?B?aWF4R0RXMzBKbTAvdVlxUkltL212WTdFRjVPZm9CbDBOb0JvUUU4RjlBMTha?=
 =?utf-8?B?L0w5bmVDak1yakFjUHhLN0I2SDhBNUdaNkdQL1I1Vzk1ejdkYVVQTlRrUDZk?=
 =?utf-8?B?amMzZFNpdXdqelk2T21xWUZYaloxMDBzWGMvQks3QjQyaHRRcVFGcjFJSERo?=
 =?utf-8?B?cjJPcjBWYzFmOFdyVEJVRDVqNk0zSm1JTDcxSEEraE5lenZRRGc2cXcrbUVX?=
 =?utf-8?B?ZHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 858V2C+mT4WPaQk5TXLi8pwb0GqfL4clXKrnIznkRUeeo6hF2pBti9tDzu7EQZPY5ZUNx+oJEMi7zune8IRQLulW0k0fHTzT11ulz5/pxZz9aqzA8QjBr+T1xe1q2YEDOJeRpJVWkDKCBmkLbyVizeWnlz7FcgKFDT1/r7f8tfzwpxKvlUFHcaLAloyekABsN8Ql4/VctTF+C+sP27JZyqYRVSWTwh0J+LDBmon+OBfBu0dkTU8NFshJOHYfnTh6XDIxmLUHTEDC71/RngHAB5c4OKBKi6N0eRRlIg4VjQbIf8YROdUktcg7FYWIFol6yu3QSv7hWoxcyD5bK4yszPK2Fggs8nTeofu/6U51PHFwRNA6DjMA61fSLKaA69WIZQ3gygWHp8lfrcG/u0hn5HbjwqDiq8AyKOuI4rMLWVO58rqt8pYrRWCILUAQWKJvOeHEiU+QJ/WcpP92faAEITmvCM66b3xcpbUXJ1VjRKZne1XNVQItXLq5ctpHosYYvRYl1TmILYqLTK34CPz6bT7CT76m15zddtsSjPkHHQmmyQZTx+VjvSPtUHX+z9j2PANvjDItT1zEbz5Vw9XRXCjtMoC8JSpfNt61U3+N6I1fum8PiUy75UvP0W+R3xYXluQkqoaTBaPRk6EDHME3CE3C9nPgpSQ0GZ2zJdZC+53eOFX2xKaAFI3yJpjU7qwFCTOMj3+kSwh4s+N91LYV+fhKnGEBC2gYwjuHCv8L4gqibrj4hGTQaR4UyzkcjZhxSspfDqPzpQd/Q5FKs6ojJf/8w0YcG3Zv93xZksXnq+q1DBdxfA6jCtk7l22z3u22jOkrHA+8rWLBrYTMVH7GZ+mReEJlrFdoVOiGQw+yZgE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d15a04-5f6f-4254-6451-08db13ec53b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 09:16:34.3097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6osxCzt6mOOeZBIyClLoeDzJ/rdzzPwYnGgZg3mnMFNkHxllYLKVYOiM26H9GbAfgbfU6xX2hY7lX/HxhPyMRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4581
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_04,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210079
X-Proofpoint-GUID: VFtRaUYBHV_dvKoyIFYkNsdLU73Ow-fe
X-Proofpoint-ORIG-GUID: VFtRaUYBHV_dvKoyIFYkNsdLU73Ow-fe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/02/2023 13:05, Fengnan Chang wrote:

Adding "core" to the headline would be better, like "scsi: core: remove 
unused sd_cdb_cache"

> sd_cdb_cache is useless, just remove it.

Like in the commit headline, I'd be more inclined to say it's unused, 
not useless.

It might be also useful to mention when we stopped using it, which was 
commit ce70fd9a551a ("scsi: core: Remove the cmd field from struct 
scsi_request") AFAICS

Apart from that, feel free to add:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> 
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>   drivers/scsi/sd.c | 16 +---------------
>   1 file changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 47dafe6b8a66..46d814035323 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -121,7 +121,6 @@ static void scsi_disk_release(struct device *cdev);
>   
>   static DEFINE_IDA(sd_index_ida);
>   
> -static struct kmem_cache *sd_cdb_cache;
>   static mempool_t *sd_page_pool;
>   static struct lock_class_key sd_bio_compl_lkclass;
>   
> @@ -3826,19 +3825,11 @@ static int __init init_sd(void)
>   	if (err)
>   		goto err_out;
>   
> -	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
> -					 0, 0, NULL);
> -	if (!sd_cdb_cache) {
> -		printk(KERN_ERR "sd: can't init extended cdb cache\n");
> -		err = -ENOMEM;
> -		goto err_out_class;
> -	}
> -
>   	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
>   	if (!sd_page_pool) {
>   		printk(KERN_ERR "sd: can't init discard page pool\n");
>   		err = -ENOMEM;
> -		goto err_out_cache;
> +		goto err_out_class;
>   	}
>   
>   	err = scsi_register_driver(&sd_template.gendrv);
> @@ -3849,10 +3840,6 @@ static int __init init_sd(void)
>   
>   err_out_driver:
>   	mempool_destroy(sd_page_pool);
> -
> -err_out_cache:
> -	kmem_cache_destroy(sd_cdb_cache);
> -
>   err_out_class:
>   	class_unregister(&sd_disk_class);
>   err_out:
> @@ -3874,7 +3861,6 @@ static void __exit exit_sd(void)
>   
>   	scsi_unregister_driver(&sd_template.gendrv);
>   	mempool_destroy(sd_page_pool);
> -	kmem_cache_destroy(sd_cdb_cache);
>   
>   	class_unregister(&sd_disk_class);
>   

