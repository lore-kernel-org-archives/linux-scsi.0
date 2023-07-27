Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B627C04A6A
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 12:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjG0Mgh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 08:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbjG0Mgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 08:36:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925831AA;
        Thu, 27 Jul 2023 05:36:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0sJld018991;
        Thu, 27 Jul 2023 12:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Zn1BpWpSo/1YgYTOS8eTdWiUw03QzZb6MaXVZttJ3ow=;
 b=lPJuToU5FTemCxwi2CQZ8tHzwquBfkliKl+IEg71Z3bQ4DAMztYjBo4QiWzFGXVBlEjo
 BD3OYBQhayQMc0kM2Zgcr1I9eZsJcGd3176oCsrYDA5LHStcoaIpMc5Nn1KNPcIDwEp1
 +pnjjuymSqHIIcYUM6b297KBATNJzHaOvBTgNMuCPVaRgUKRlpVrBCKTqtVBESH9caxN
 lV916VL3rMVeIK8fwwBpQq866ln34fCDZhLOwtoGG8UAHN47+RwDt0qJPuuW3ZBtQ0bG
 dVa4vSPSwHJUi/BxAPJBgVoMTh2xARf0esTw3rJwLxEAPlvKwdJHEVmDA6AVmJ49MZAh sA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3sknt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 12:36:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36RCGkNR023011;
        Thu, 27 Jul 2023 12:36:07 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j7junh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 12:36:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtTMnvFiMJUsijRZWqkEI6fmgcA3JYA5jxFiqK2B11Ck3D5GGtu0EWsSzcDvyAMDdc1BQVQAHis+Cd1ehwaFMwq4EwEcnK4+yk72ahoyxP1HZVidDoW6A8rFWHyXgD7fLsga7a/VcYwcn1Y45MHccR3ss722T94SdPH9rCoTH8DH0huFGk3NKy2snT2I3J+Ah86IPrAQOzlZjQza+Sswqzi1U1R8qiykZsdOc2T133oaXaOC4UJEXEU7J1bW0V750E+WpFxt6caBeUGb6yg6cSlWoC7bXA2ZiiD+G98BuXP+ZN3l6g7sWxDGX7qkRDzWQcoH6P4qfhDFdaiTmlW5ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zn1BpWpSo/1YgYTOS8eTdWiUw03QzZb6MaXVZttJ3ow=;
 b=FYbAi+uHkzdMIxeoAWSvzPyfsXqkpJx+wD2Qr4EphQCIpoHH85b2LNKDMxTf/khCJlJkD+AWdEotSYYKcl1Ey5ELycGcb2eSNqhBobDfA68CwkaWGKpm9QReQTmFtK4IZXfIjVOHzuutbxukY13Fh4nKCnXH5DtjE4F6PDtXfA7A4NcVkws6//uZmWXL7KvYsls9qlqFTjpRdNaeI9MBzDpSh+7bacqf6TE2SRlYciRgU2lO3Yp5HVqBLCK4DLoaWfkvH5O9p0C9iu8kLTXQqLHzIVLm5qlVpVjB35gjYIV+oeM/6MiouQT1oO1vSPFef8jTjT+mN3W2h3E0Vm75qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zn1BpWpSo/1YgYTOS8eTdWiUw03QzZb6MaXVZttJ3ow=;
 b=qUyt15zmycI4GSb70WteCh2tQzeeRdxIEyMR5ll90hjinraT17eipwPuOyPN8DpjSdhQasBgh+KQGzvfqj+P4AyiQXxyMdelk09uyAYJtHmPCMjjYT9HfMoUBrRqoCIW+7Lh5ii3mHhTjyIbiem0g1hIv0D3+zZBYkZBfT4zPGs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7148.namprd10.prod.outlook.com (2603:10b6:930:71::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 12:36:04 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 12:36:04 +0000
Message-ID: <b0ae97fd-583f-794b-a62b-452548ef9afd@oracle.com>
Date:   Thu, 27 Jul 2023 13:36:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V2 5/9] scsi: hisi: take blk_mq_max_nr_hw_queues() into
 account for calculating io vectors
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-6-ming.lei@redhat.com>
 <07f84570-5307-df3c-99ab-a996bfcbf83a@oracle.com>
 <ZMHFQm2BpuGjjlTm@ovpn-8-16.pek2.redhat.com>
 <44b1bd30-426d-db85-4b52-4f079948e52a@oracle.com>
 <ZMI78klyiVUPFRZA@ovpn-8-16.pek2.redhat.com>
 <123dc4ca-88da-b2b1-44b2-791ea841572f@oracle.com>
 <ZMJNXk5MiViklCBX@ovpn-8-16.pek2.redhat.com>
 <cc41d37e-5dce-9381-8b47-f8c690388a88@oracle.com>
 <ZMJcqzeaE5e0BdmK@ovpn-8-16.pek2.redhat.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZMJcqzeaE5e0BdmK@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7148:EE_
X-MS-Office365-Filtering-Correlation-Id: c9c9ca68-3733-4f37-d31b-08db8e9e0b15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHt/0ZT0HSiyAjFnfWWCJRvdG+ny+ERRzrYsRe1HUe5xmQn2wPndHRP/Q/eSWDzOnpbbD3Gs0zHlGMT3XfhqqvHK8t/QLR+Pv9snBTOkUq78wIZV9tbQdZRsrQynAeBIqm26EU1ygwk6mlFm6+bZ+iDfKoBDEXEFTlXlQcYPRj/gkeyu0N/PKoskHWVGzrAcNFCaPpJyzsXFprh6bh3AmQ1/kJQ24XwCuGUNwYztVOmlB+HK0gPO/wArlTwWIECJfBlmL/tGP44tLTX9bfZg5F4Z3NhICHo5T8LhMnGEalMqKgyigHqfDG5RNcT9owiU7OMVcne+FDPnZI2JUyH3i/oOBi7s9Oc6sJt15XYkXtI07gQZO5gkgq9cwjIa/9S6OeAzh9iyIHOGEjZknZn146ez0CGVYqlo4QIu4F2AGUJS90RDB80IkVaIxE1hUstjS4WtQA9WBlLGjDRn51kLT4WTmHdYTUnKBzjurerZ/2PW4oO7XrGFb3fSoWF8qMLXHqMvmnObkDHNv+SFASDCSSy/fSpHOiqnsOwL48xwF92fC3WeUhonatL9dP3RwnJfCT8VRQ7l3RAJP6CEv1dAA1AdpV9vG7fCgjrzbliBKL6cQ15yK9HkBljbQTbleoiux6VkmqMi0+6erlNOtqPTtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199021)(2906002)(316002)(8936002)(8676002)(5660300002)(41300700001)(36756003)(86362001)(31696002)(6486002)(6666004)(36916002)(54906003)(478600001)(26005)(6506007)(186003)(31686004)(2616005)(66946007)(66556008)(83380400001)(38100700002)(6512007)(66476007)(4326008)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVRGSlFDVTNhd3g3OWp5eVBhSnlnc3NReUVia2JQZ1VaRHh3UlJ1UXRwY2sr?=
 =?utf-8?B?RXNFVWMzMFQ0WkNWcmF2NzhRWUE2eE1ndnVYN3NvVWpoM1NDLzQ4bHJ3NURm?=
 =?utf-8?B?TXR5RGV1dmpGbnhxaXZ1VWZnMHU2b2I0ckZzWDIxMmtPQU9OS0dudjFLbUIy?=
 =?utf-8?B?VmhXL2FjSnNqTkVtbFNiYVU4VU56V2VHbkhoNkFhTXVSejhGa0xmVHAvQlkw?=
 =?utf-8?B?TnNQdU1DcCt2TTdZdEJCOUxka1dqNUVtSVpzYjZ3RXNERUhJUzhyVU1XajRG?=
 =?utf-8?B?UDY2bnZROUdvdEdTT0pvRG9tRDJNZlY1TldlQ0VwTEFQRmd4ZHhTMnMwa1Qx?=
 =?utf-8?B?UzczQTdlS0RRM0x2MDAvK00wR20rQXF5NHBzS0p4NEcwdDl1YTFGdkJ2aG9W?=
 =?utf-8?B?SW9TczFqNDZUY1BtZEZwNm10VVdlVEt2Qi84TFU0MEZqT21xeUl0Um5UM3JT?=
 =?utf-8?B?amc0dEllbUV1YTh6aFF6UU1XUnJuTXBQZG84SWlqS3lQTGF1K1JxNDVhMlF1?=
 =?utf-8?B?WEhXL1BPbjNBOGJYOHYvb0taR0wybFU5Zm1mdVVYbVBDYzlicFZGSUtjcW5U?=
 =?utf-8?B?eGNlekJ0VWk1ZkVkWnNUQzdwczRZY1lIUy9EQmR1SXM0T3hGSDk3akhkTFZL?=
 =?utf-8?B?K1oyTXJPVmlodXREQllLQko4OVlVMGFTNWxiSDE1UGlNSThLWGpnZnVjNzFt?=
 =?utf-8?B?eVE3eUo5bXJoZDhGVEZTZlR5WHkvUEM3Y3VzQklnVjFnSVR2dWtTWVVNOHls?=
 =?utf-8?B?Vk55SlZGank2SmlZcTNzWGZ1VUZielN1NWg5bXU3Yy9yVHBDUE5NSEpSSXNo?=
 =?utf-8?B?SVVZNmJvWURENzRkUnRyZjRUd3RlSkRhZUtFUUhsTFYyN3MzNnhnNVpHK213?=
 =?utf-8?B?cDI0UEVjUUU0UVVtZnhGRmhsS25OanlTY215OWIxUmdBQjMyZnliZGZGcGxs?=
 =?utf-8?B?aGE0N1B5ZUgvQ3VBeTFjSXFnOVB5YjZvbzl4RlFpTWc0YmRpOFNhMU9VOGta?=
 =?utf-8?B?OU5nZDVERjNSTjk4aWRjdE9DNktObGNxdWFmWkpHaVNWamlNd3N4Mjcwdllj?=
 =?utf-8?B?aG5TczVkVWhld0dycThSVkpJWDJIK2ZWK3BFRDNYdWdnZkUycVBuSVF1eDAy?=
 =?utf-8?B?Mk1FRVVxaWhmUmlqWHNtOE0zTytwTEZtN2w2MHJFUmNJOGhoOVRBSTZLM3ZS?=
 =?utf-8?B?QXZVQXNaMDNOVnNOaXJWL205MDZzbVNmV1VsdkdRalNJNC91a3VvZVkxVUEw?=
 =?utf-8?B?eFptN0Ixdlk5ZXpIc3lQYnZkZnJxRlBPWmV5QVQvYVBwTGlEd09ZYms2WHpL?=
 =?utf-8?B?cUxHUC9DU01abGRsZVpMZ3hWVWZOWVd4WUtUUzlJYVk0RGc2bVdnaWtteTJY?=
 =?utf-8?B?SlB4Rmgxb2tIbzhyaUtJWFRRcWI1NFVHdE1ubTFLWVdDY29UWUY4cWp3bUNn?=
 =?utf-8?B?SlM4WUVkMjRrOHBMZ3ZYRXpKR01OcHhKNy9ORmR3dWxRL1JaY2EyMmJXaEI1?=
 =?utf-8?B?SlhGTG8ybituSmNzZDBNaGdBZlRaeGRDUy80S0dlQXNNMTByYmUxdFJWWDhK?=
 =?utf-8?B?dFNNUDZUTVcvdUpXUjI3TGxsZy9BY1JDR20zUnhKRFBvcUhmR3VYbzFmVDBV?=
 =?utf-8?B?Q3VydEdmKzlCWUJSNmg4NjIybXd4eDlOdTNGNVM3dHUwc05lZ0E3eS9MOGp3?=
 =?utf-8?B?eHhFT1I4T1l2MmRDMjUySjhMdW5TK2ZGempnYVdweWNJcDJEbmVBdWRNai9S?=
 =?utf-8?B?bThSNFZjRE9QOVdHY0pmd3kyald0WFY1MXJ0WXhPa2dWSTZ6a3I0U01KdCsz?=
 =?utf-8?B?MTcrS0NiRXRWR01YeStyUVhGcDZzWGVuWmJ0M1pIN0pRLzdCckMzYnptSGxK?=
 =?utf-8?B?TEl4eERlZnhaeVdRS2lUQ1BXZ1hkRzFpSytqa3RDT3JVMGdNR0ZNMzNUYUZX?=
 =?utf-8?B?WkZSeXkzNjB3WlIvK0Ixd3cyUVRvM2k5eGhBc2tUNEZUcERvWFF0N0dHNzZn?=
 =?utf-8?B?K0NXZm54VTkzTDYzaFBqSWtHbmhuN2Rxc29yRmRyUUx4KzJ1YXlZYzNLeGFm?=
 =?utf-8?B?QWJPQUl1R0E4OU81OXhmclF5aVQ5M0xCdm0wRHEyNWprZDFLM25VT2liZlZk?=
 =?utf-8?B?djlFS1dsYUZCWnFnZUZFaGdsOEVEQXQwWnU4SkNtdmJBcUpuRW1Ma3l0MTcw?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VUdxbnRyVEptVEJKSVMzbjZGQm1Ed0gxSVhCYzJjTTRIa2hMcWZONTFGc00r?=
 =?utf-8?B?YlA4Q2N2dHZ4UEpZa1RnS0g0blNWVENaZm1OakFVK0s0MkExc1BFeVROM1o2?=
 =?utf-8?B?ZzZYMzRHRTBnZVFxWlhidDFHMG9kOS9adFVjKzJ4ODF1dENycmJZQjVQNlMv?=
 =?utf-8?B?SlpqNmFCaTduYnhNaWMyalhOTGxCWE1KZG9PeFhrNDVrcjYrNUJQaENCd0lU?=
 =?utf-8?B?VENiOEpXdDZ0dUxmRCs0MFFqOG1LVUtJT3hSK0srQ3B6clFyRjJBaU1QY1N3?=
 =?utf-8?B?T1NFSnUrTE9nRFV1MDl3MGRPVncxYVowVzZqdnU4a083a0xJOXNYT2FRY1Bi?=
 =?utf-8?B?K2xkV2hoalQrcEt1eEpFcm1peXBwWWEvcEErVS9WaFJoR1RyQ2dCa09zZHhu?=
 =?utf-8?B?dnB1MGNSU1ZiS3FRYit3cjF4VVo0T0tPRnlVMXBVVm5YVmM3MS9Bclp3VlZU?=
 =?utf-8?B?V1pHY0xIdk1nRDR3R25vM1BZc2s1OW9zUk5XNXp5NzhvM2V1VWtaL2RWL1kw?=
 =?utf-8?B?WTVaMS81UFJFTlpnVU9vOEF2UlFjWjM4dHFFbFpiVHFMZVVlUGpvM2RPbU90?=
 =?utf-8?B?TlR5QU50NzJndjdWS2liNU4vaVcyTHFQdjczVnhtbjJJRFhhLzd5K3BVaG1B?=
 =?utf-8?B?ZDVJclBLWTdjdWJIbElkZUNLTzQ1RU4vMHRJcWhCYjNOdzZEdlQxdXlYbEpX?=
 =?utf-8?B?T2ZQNUhrTWpPNms4OVZsTFh5NCtLdkpadDZiaFNyS2xUVzl2d0VQdDlUMnFQ?=
 =?utf-8?B?UWw2b1p4MzczVVhGSUUzT053ZzNveDA3YXNnNmRqSTRRZVMrb0VmNXVQV1Rn?=
 =?utf-8?B?OG5FQ3RQTjZ0MEtoVzlRRitjS2tzQnp2Mm5ERTVmck5WdExZZGVwTUJhOERO?=
 =?utf-8?B?UXZ4enQ3TVdsN0RMVXBmUXhZM3d5T0tBWjN6MnF0SlROcmFIaHlDVzBORFdy?=
 =?utf-8?B?SGttU3N6Mjc5VHUxVDc1TkVBV2g2dWNlM05tOVg4dGRHcUFXbGdmSmwrRXpu?=
 =?utf-8?B?Y3dhZFplMWEwZTFXaUNpalpiZDVzamlyYU1QSFlHT3QzRHZrNk8ybWYvRTU0?=
 =?utf-8?B?WWNQYWlSUDNLY3BDMVhXNm1WbVFIQkVwUG1IbVZCVEg4Q0J3N215di8zRDZ2?=
 =?utf-8?B?eDZRRWJIeHpIL1RiMGd3UGxNNFEyNUk3N3FPK2FaNFN0RTI3ZFpzalgxZEtS?=
 =?utf-8?B?NkRwVUNubDc1ZUxJc01Mb2tvSG1JK2JGbWpkM1p6UUZldlRDNzFiclpXTnJo?=
 =?utf-8?B?RHRna1l0KzhOM2k3NHJnT3haMVI0NUFkeTN6Z1VabXdQYmRaSU1PakN1YkR6?=
 =?utf-8?Q?RL6e2XOYNneqJZlT/cJ7bIqKLtncj77HAP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c9ca68-3733-4f37-d31b-08db8e9e0b15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 12:36:04.7663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHleXJODtH72+KKV5WW0sCm7sjmeuM/HBU8udZEhK3mWZDPoWMEyMsXFZXYvFU5h1jSR39ahMgbniWE+vXjtmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_07,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307270112
X-Proofpoint-GUID: Cs2t8M7cl0M4yZ94tGePHnggK0kT2AYS
X-Proofpoint-ORIG-GUID: Cs2t8M7cl0M4yZ94tGePHnggK0kT2AYS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>
>> I am just saying that we have a fixed number of HW queues (16), each of
>> which may be used for interrupt or polling mode. And since we always
>> allocate max number of MSI, then number of interrupt queues available will
>> be 16 - nr_poll_queues.
> 
> No.
> 
> queue_count is fixed at 16, but pci_alloc_irq_vectors_affinity() still
> may return less vectors, which is one system-wide resource, and queue
> count is device resource.
> 
> So when less vectors are allocated, you should have been capable of using
> more poll queues, unfortunately the current code can't support that.
> 
> Even worse, hisi_hba->cq_nvecs can become negative if less vectors are returned.

OK, I see what you mean here. I thought that we were only considering 
case of vectors allocated was max vectors requested.

Yes, I see how allocating less than max can cause an issue. I am not 
sure if increasing iopoll_q_cnt over driver module param value is proper 
then, but obviously we don't want cq_nvecs to become negative.

> 
>>
>>>
>>>
>>>>> So it isn't related with driver's msi vector allocation bug, is it?
>>>> My deduction is this is how this currently "works" for non-zero iopoll
>>>> queues:
>>>> - allocate max MSI of 32, which gives 32 vectors including 16 cq vectors.
>>>> That then gives:
>>>>      - cq_nvecs = 16 - iopoll_q_cnt
>>>>      - shost->nr_hw_queues = 16
>>>>      - 16x MSI cq vectors were spread over all CPUs
>>> It should be that cq_nvecs vectors spread over all CPUs, and
>>> iopoll_q_cnt are spread over all CPUs too.
>>
>> I agree, it should be, but I don't think that it is for HCTX_TYPE_DEFAULT,
>> as below.
>>
>>>
>>> For each queue type, nr_queues of this type are spread over all
>>> CPUs. >> - in hisi_sas_map_queues()
>>>>      - HCTX_TYPE_DEFAULT qmap->nr_queues = 16 - iopoll_q_cnt, and for
>>>> blk_mq_pci_map_queues() we setup affinity for 16 - iopoll_q_cnt hw queues.
>>>> This looks broken, as we originally spread 16x vectors over all CPUs, but
>>>> now only setup mappings for (16 - iopoll_q_cnt) vectors, whose affinity
>>>> would spread a subset of CPUs. And then qmap->mq_map[] for other CPUs is not
>>>> set at all.
>>> That isn't true, please see my above comment.
>>
>> I am just basing that on what I mention above, so please let me know my
>> inaccuracy there.
> 
> You said queue mapping for HCTX_TYPE_DEFAULT is broken, but it isn't.
> 
> You said 'we originally spread 16x vectors over all CPUs', which isn't
> true. 

Are you talking about the case of allocating less then max requested 
vectors, as above?

If we have min_msi = 17, max_msi = 32, affinity_desc = {16, 0}, and we 
allocate 32 vectors from pci_alloc_irq_vectors_affinity(), then I would 
have thought that the affinity for the 16x cq vectors is spread over all 
CPUs. Is that wrong?

> Again, '16 - iopoll_q_cnt' vectors are spread on all CPUs, and
> same with iopoll_q_cnt vectors.
> 
> Since both blk_mq_map_queues() and blk_mq_pci_map_queues() does spread
> map->nr_queues over all CPUs, so there isn't spread a subset of CPUs.
>

Thanks,
John

