Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14D3C77B7D
	for <linux-scsi@archiver.kernel.org>; Sat, 20 May 2023 18:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjETSFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 May 2023 14:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjETSFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 May 2023 14:05:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AB3124;
        Sat, 20 May 2023 11:05:11 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34KHxu7i006626;
        Sat, 20 May 2023 18:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=gcdedEqdsIJKWkAtpMD8kIkkrl5DomkG086u1lYVdzU=;
 b=lvz68AXXEMMrDFh22nc+rnMdjw7DehQWLCYdx5Tgr2hJ3jtEmmeCrSdBCgKpCIT84uJO
 qGqQ0p/VwFaKdm5jxFYb9QnL38MfiGHftvb9FvuAHRJZH3q08KJiKvbttZUGLIxrZI9A
 vCLXt3O3WjuxUogaujMF2OUxSeeZ5RuuDQGoh0WKxzHIv1QuCUA8p6hOh01m+zTugF55
 o42rkOHYCjbB2oLGptn9n09+Zajt4B/z1ft41AKHJObxretF7Zclg/lPFW5nGVBbb4Ac
 nGAVDWcC7Cndtg3B6kyDab31zSXyOGU9wVJxZJTpWRjNeYvqAoYtJ6eluqyPQKXFWXaX JQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp44gjcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 May 2023 18:05:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34KH111i030868;
        Sat, 20 May 2023 18:05:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qpmn1fq4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 May 2023 18:05:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7AZ3ATbw7STInADbFAscdWWY/yCkw5/Qv4IO9w02TGv83v8BS0DkJfXy3WQrupa2q+O7DInOVUdBz0IBTjgxka9nEjmYxKgcEwPbDkBaUttiBdwhqytGdEU6SkLvu/ewZvyLJkCjqG0AC+r89GZ1/vR+vPIKMbNPPE6pWpppL0E1cvLe8Llhlv04v+RC0pUeBYvbHPpxgoKprnkDXfgiXJN0YRTUBxe9J0Xyse4G+H9xGxHzHJ5TQZ2qTg6ERSx8t5wI+4yC2QYBN8lB7Z9rjlD19gBvBMXFTX4w+FUPCEinZ5QSYBH1hC1GgU+sbBghJ5lVoYqNWQIpKu3tjWp9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcdedEqdsIJKWkAtpMD8kIkkrl5DomkG086u1lYVdzU=;
 b=NCXsAbZ21WLaXGXwe5ygkcgz8qcV9vOpWjGF244qv6DmoYPXtCgRF3qTirdsHTJDy2gHtPNU1rfEKckXY42ge8BDUBHkpFIRxZCKz8Wv9f9emMzQ3DCvHFdmTMWwM1p3iexjMsbOv80RvURiyZ+C1KCZjBPb4Iz0hbdcVPYof16u5L51u58UILV/vbY2D7tNdZhhscbgX7h6k5uCQaMQN621Yihj3QA4bXBaTLIeoL67K0WpwvAJtDT3JcDIUQtNGAiyvknZYqWMYpppPmFYccplK1faW2XHoPI2E8gOe0PlHk60IsnFZ4wVqit/j0jNv318uegWPnkl5Alt9n5Lnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcdedEqdsIJKWkAtpMD8kIkkrl5DomkG086u1lYVdzU=;
 b=Uj+26thDDzSUGiFDIh2D/SyE9VeH5QnScD+K406QaTYhFGRP8ZIBiNn5IDgMBRV6YX8aa78AjxDuTlFD9uKzhRVwSXDZKEIPd5Cm5E4CIcTLu0tSInN0szmgQMrw6gVHY5Eu9rxHcO8rmV8h81jHloQ4AQOEow1ORq5eNCGSNy0=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by DM4PR10MB6088.namprd10.prod.outlook.com (2603:10b6:8:8a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.19; Sat, 20 May 2023 18:05:08 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::6f12:fcdf:da87:2bfe]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::6f12:fcdf:da87:2bfe%7]) with mapi id 15.20.6411.025; Sat, 20 May 2023
 18:05:08 +0000
Message-ID: <80a07968-e33f-efba-cd7a-6e3047a520c4@oracle.com>
Date:   Sat, 20 May 2023 13:05:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 2/2] scsi: target: iblock: Report space allocation errors
Content-Language: en-US
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Dmitry Bogdanov <d.bogdanov@yadro.com>
References: <20230517141537.80936-1-k.shelekhin@yadro.com>
 <20230517141537.80936-3-k.shelekhin@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230517141537.80936-3-k.shelekhin@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::28) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|DM4PR10MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: f3866a90-399c-4bb0-0bbc-08db595cbf1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vtteskv2K/MTFZdkDsy6trf2MdiZKSb4D5QrY/9qbTu46ha+1+Qi6yFlBWiLVbisrZjFUgNzD3Xh7T8yz0x2GpbndiqwoaFqsLlziEB6DL1Dp7joFvM9Qo7YLYzsn/sIjRJg2a6g2h/jYTAcyrSKBE5Nj1jU7nVIGEtLM/osoparXWw/jEUoOuEtgO+ccs3hiWZk++e8ukL/kEFBk6NLUWprI03SWraS8Wx6HIG5nrUw1B0tqKJX4KyScoXepD0jyzFyXwM5hNSbkJ/AON6oWASPvgPTQTU9Ezhv9njQY/cp1EfsSp5M2l0UJAFR2dEdpca1QiID14gEFJ0ZBn9AYIn9hVtLVMPDtNKRuuIRmeabQZITadujJJzI1XHJlFR6C4vnh01mWX4lx/irucyIVjZPjMvFk5C3FE9WGhMRzHQ791CraL6W6vySoX73NLWLUQT8Tk+QGfeWU54dCkxdr+uTeNXPYRH/dq2/rydqDCpHPjl4c+xNvPt/L4Q8e0F9BU3WIN7hKPAMSYRZB15pBlxE8J1Y/lUnq0nmCHj8IpGqq4XFHdEjXQOcVD2vfwMBA5Gti7DQaFIVHIM6rzipUVdegj4FTWX/8Yxvx+4ucXaQXr6mZzRlTjfFVbPy13gg3KhD96rc/oP0ctnL+eHwQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(39860400002)(346002)(451199021)(6506007)(26005)(6512007)(53546011)(36756003)(83380400001)(31696002)(86362001)(38100700002)(186003)(2616005)(110136005)(6486002)(478600001)(316002)(6636002)(4744005)(2906002)(31686004)(8676002)(4326008)(8936002)(41300700001)(66946007)(66556008)(66476007)(5660300002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekQvRnB3aWZPdUVNSnFuR0JaME9raFpaZmhyRjB0aGxxdlI1a0pzZnVuU1lD?=
 =?utf-8?B?MXNSc0tpSVZDTzdRd2hDN2ZvTTdrYjBxM2JoQlhReWRnY20yRW1ncFk3YTQw?=
 =?utf-8?B?bU9KWjFTbWwzZWE4K21RNGZHZ08yaFI0bG9ZeTEwVHY2OWt5U1I3NkFkMWR4?=
 =?utf-8?B?aE9xcllna1Zhb3NKVmxZRDkrdCs3eWlIRDl1aU1QcC9Lamtqd05ZRDhGb1l1?=
 =?utf-8?B?K01wSUpjTHV3am1OTmR1VFVNVFhBY2pISTRVMW5PWEZLUjZXaXhHRnQ5UVE2?=
 =?utf-8?B?Y0d0SEJvMC9Vczd1bVdKdHRYUEdiYmRTbVV1S0lrT1JuYlloSmJHQzgzTkg3?=
 =?utf-8?B?WHY2SlFrZXRkWDE3RkUxeXRadUg5ZjFyVFBmTHlkSjBDVVd4Q2ZhWUZaZ3hj?=
 =?utf-8?B?bklsbVU4QjZiQ3FzZ05pVHJ0SFdMbyt5QjdacGN5V0tFa2ZYenpNTGQ2Tnc4?=
 =?utf-8?B?U3dZVHBEY3hNMTc4ckJHYVh6KzBycXRiaFZPYW9Lam9Da1FJL0dZMFd6Ymc4?=
 =?utf-8?B?TW1mQkZsQzlpWkVVUUtZK2J0TUNYek9KZkQ2WURJZE5GdE5qd1dmbGhoU2xB?=
 =?utf-8?B?K3hSaW85b05UaldDYkVlckMwNnZxSUIwY2Z2R2R0a29YdmdqOHk1Z2Fmb1ZQ?=
 =?utf-8?B?LzZzcTNFdnJabEpGdXJPcEFzQ21LbUo4NDJDTGI5eWpRQlhRUmx0eVNBRFdw?=
 =?utf-8?B?RCtyQVdiTitsaWxkNDc5UWpSZVAzMXdaTjlLRlZuOXllTWNFVnpEK1VQelRQ?=
 =?utf-8?B?RWFVMzdsSElQelZCZ3V6NUZVdjdVaDlHSFdkVFgyTWdub0NkRlUySmxGYWtK?=
 =?utf-8?B?RG5uMllxMFJIeWc1WDBtTW9yb3BkVVNZQzVXV2RsMHR0Ym1QWGJCRVFlaHI4?=
 =?utf-8?B?MWtNK2hwR1ovREVJTUd5endsN2p1Z0pGeGkxbGJ5TEtXYmJ4dTFLbnp2a3pn?=
 =?utf-8?B?aHo2c05zQ3dIdXcrd2M5L0VFWjRBZ2pPQXB3UFpKUkpEc0JZRlpYQ1o4SGM0?=
 =?utf-8?B?ZVhaTVRMUmVBRnowd1pHbnFQNDdISUpvSWNLTStqMWx5emNDdlBRUWJneWJE?=
 =?utf-8?B?KzRMZjExN01BTUh5SjhBMkdRYWV1eG1hRTNaRmVrcUdHUEgrNlN0cGpRY1l2?=
 =?utf-8?B?NVJ0Qm5BeWhzM1dTUmYxeE9iVTEvOXdiZE9iWjZtN0xNcHMvUkpGVEtESCtm?=
 =?utf-8?B?cHR1MXpkZUk2cnpWOTN1RE5FdzFWeVdCNXU0bGdjVmluVUR3S01FSXk2QzF3?=
 =?utf-8?B?UWRYbmdMMzZKMnorUzJBV3NML2dPc3lvc2Rhd053ZE55bS9mdlF1dWFBWDZG?=
 =?utf-8?B?N0xaTXh6NVVCMHc3VXpPVUk3cjVrR3ZMTHlydFBMellsTHlwNWcyTmFYdHkw?=
 =?utf-8?B?dDBnRWlsZVlLTFNTb04vUW5OSlhhUTJwRW52TUo2YXdaR0NjRXRDZ084Uk96?=
 =?utf-8?B?cHlsS2JPZXVCV2ZvOG5Ra21KNStZSTlRandXaW10TU80cTdFT0t2RzFyRkxH?=
 =?utf-8?B?by9CT3Y2OG95aTdWa2EvT1VzT0dpdjVKMWMzclduZ2Z6UHJFQWVkNjhmSGg1?=
 =?utf-8?B?UEZNR1N2WDBPSXAwN1ZEdVllYkJZbWdkb3QzZktJV3FlUitXTXN3L1lQSVVW?=
 =?utf-8?B?c2x0Q2pBQlU2MlRKQTFyanpNWnNodUdEcVhWNUdUc21ISWtaV3A3Z2JQd2th?=
 =?utf-8?B?WWNUd2dlNXpHcnYwNzRNUVVZWDhHeVNjV0JOMktEQTRHY0lrV1MxckJaVmpj?=
 =?utf-8?B?cnFQc1ZtdDNMZFRhdFRSaDZPWUppemtmN3ZVQVp1dkJTRmd5dkRCdGQrczFu?=
 =?utf-8?B?YkZUUmhTbXpjdDFXcmFZbDN6SHJYOXdrQVlmbjN6NWNEK2FVcGNpZnJzSmNm?=
 =?utf-8?B?eWJsS0tMU1QxZ0JCMitZTWF6elVaOGtCUCtOU3VZeHNRSHpZN3FCQVpyQzB1?=
 =?utf-8?B?czVRUzZDUUsrUERMS2hBd1JoOHRQZU02aFN1VnpSb05peEx1THJyb2YrOFVD?=
 =?utf-8?B?UnFTUUR5SlpMT0hScjNhOG1WM1lmcHlTd0pzamJRZGN1V2hGNkhvUUJIRFNM?=
 =?utf-8?B?endFZHRnU0MzTnVWM1hwbFpoTHI1djdMc2RYQXh5MnRZdFFTaHlEelNlK2xN?=
 =?utf-8?B?ZE04dU03NEwraXBxVVhHaGdEdE5xaTN4cjZzSlg5U0cwV0ZYS1ZFendlMThr?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cvTU5OgHeos5kA2bekCM3LIcl9uGxkMEsQsxBYbc8pQoM/1TTtZ3jhAa/7YxenLjdJh1Y/1p8LCqAIi740RDX4FL8Ugm/41WY1y3WQjJeSZxgq7KYmZZrNv+srD1/LNGzPa7Oi53fZLmf3RYkM/tC5n5Uam9lp5yRGKcOgJC4d60kpmjxJB7gMnW8a8NcWEr/wqrn6uli8gX8R80C0LQbedAmfo1iEHqAAhPl5Kv6noZzYibF46EqPKj8P2OcsI47qFv0iIyWmlc5AJjHHxyh/8Gg3unVIOtRzckKtM3F7YubCbt5zRf/D48JpDlu4VCOq/HcAx2MptEkfif/nDvNxnk+5owlq2yoPmmM6DRVl8UV9sIBNY71I1RTEr+Jbtxls9hVlIPM522HxqnSzpZn8SGlNJqRDwRsfOzbKd0y2Rd6zPqXPiH9fKdEAYPrKeeq6RrDiEe2F4dPtx1+xAGGJectaMX7e+m5qUsQbrFs5TA+MnM8I8KjZrd+dKLK8ybuPcX7I/ePiSEzKhCJZl+W+9hL3oLclI97KBOuvXk+LAMa4doHTT9EeQJ2HqfC2+RTWyj/2ZjlRtdkyCUwyvXPpMBYY0Zd85LtF4hr1OvbX74XYrU/cQMuDPW5WlN0Icus6plL7OqOyrKskE9gxr+9jb11WuhXBa6ZfKQ8JDSKF9FYJmGFPbmbcu6uDPROHUxl1Czf/HnsYwpIl+pjOZ8tQHTEMyouw1ND6oX6johHWBF3uqoTz1vcDiEjN0HFHSqGL0NWEVWA3oPvESznFMS7HM0ftCKXIqsus+hMhA4tLg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3866a90-399c-4bb0-0bbc-08db595cbf1e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2023 18:05:08.3286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bb0VVCwB+YfR97HXGK+HUpAnqO6NzOKv3POOMbob8XXYVGjAON2lFdOu3AnH6oFdPUlNG1EBLUkiGh9h/hMSvKluZ/uf5lHcWB83ls/+uDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6088
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-20_11,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305200159
X-Proofpoint-GUID: ukp7pKcfSJZ-Y8VXa7V8N7KIWX1iVU0A
X-Proofpoint-ORIG-GUID: ukp7pKcfSJZ-Y8VXa7V8N7KIWX1iVU0A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/23 9:15 AM, Konstantin Shelekhin wrote:
> When a thin provisioned block device lacks free LBA it ends bio requests
> with BLK_STS_NOSPC. Currently iblock treats bio status as a boolean and
> terminates failed requests with LOGICAL UNIT COMMUNICATION FAILURE if
> the status is non-zero. Thus, initiators see space allocation errors as
> I/O errors.
> 
> This commit modifies the iblock_req structure to store the status of the
> first failed bio instead of the total number of failed bios. The status
> is then used to set the specific sense reason.
> 

You posted this patch before right? I think it didn't get picked up because
the kernel bot keeps flagging the mixing of the blk_status_t and atomic_t.
Just build with sparse C=1 and you should see it.

