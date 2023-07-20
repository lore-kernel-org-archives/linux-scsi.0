Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCF2EB64DC
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 10:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjGTKKE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 06:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjGTKKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 06:10:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5073FB4;
        Thu, 20 Jul 2023 03:10:02 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36K8piXX010665;
        Thu, 20 Jul 2023 08:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=R0nrOAgRhmH80PFa1z9FlFAsKxlm8D90PocorvB2eAs=;
 b=D3vRL18PdGwmhXEEtqJIp93ScULkxGJp6IzjRcsJYvDoqwyVrPMJMf2ESBb+zrSPPPVe
 ZsMmFp6G2tn7veC4DPdQtWCgjZAeXUpDXo/B5qNOgkwj06SKk7LKWMfHUn8V8pR9lw3I
 F5GHEUqQfuzZKxwX1POHisFP+zOpjy43/OuUZKow+sk7hGVnAQEAOnRGV3Se4R43/xKJ
 FOh3vjCBiR67rTDdbOURhORMafUnW/EXFfUevvZyoDqhRi/Sf+/khDGXYfHqGj54DPZ/
 +jRCzKpvziKp13r8jHI8WNy2dxabl1enqAsVMhmtd+HOe4XKT+nXDgI/dFL9u70pmufY XQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a9awp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 08:57:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36K7kcIM000869;
        Thu, 20 Jul 2023 08:57:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw8bsta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 08:57:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAx5xev7b1hmUq+XT78t55nQbAmbRve3wd5C9yYrOZLV2j/HrBb/HohdaruHRfVKtGc77IkdXWHeCWBmni0g6s7d1siYY720tucVM2lQfraDC60JR/5NeOgQbzgo6UUT97u1egGxZE1WovUIUJjTQNLG6ysyySBQqANHDCCLMTdTabq/5hvi1Woe9d2PhV2nt5j1BAiSDcbTB6L8MLbcgUNBHPP5AK9Ft6BtJyTFJapNeirE2r+ZZmJkzLXEUYAzwHzLJTSmA+q3leJ9ehtQGq4g0hnaQlmTLbZHu7MGEAKKZFdcUsxXNPFx2PZPIWy+aUk8R3cfPrWbj4jNWvcPAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0nrOAgRhmH80PFa1z9FlFAsKxlm8D90PocorvB2eAs=;
 b=mTF+G7coNqMXE0Ug3Odr1Qpdg3rKe08Hc98NbA0btHXY0zYkAZaYxdbUjjDd7xHkMzMX4R0Ikw6ZZ4LkJHqvya4FoNIuzBgL9526D8KNS+O5Phiwsi/+lM2mUBH26GRaRIctj+wsiiHokAqzF2IRrxS8dBuhjiIevk3Bmv2OsULI+2JkSvZ4OBQRCFAyZQ9bZmr0fu72l+jCrTw6YTKbJQxcQ09rsIqPFXU2JxPmePZMz6i0EjTzhyhdbKd6qdGbmOE1gEkF2RixUQ6ORMHh3fiOy2cptHTNc4r08MLdSyB3PZOAaWV39LpjQhWCS9TxhtSWPnBLpjY+q+wTEQHHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0nrOAgRhmH80PFa1z9FlFAsKxlm8D90PocorvB2eAs=;
 b=AvYlduSFagqEd9n8vNIeyc8+ByFynfiDtpajKx3Q15yva8Ae7p29FC3Edp2+HoDKGyVANnTAPNEjuB3Q1kXv+sV26Xij5pRH6hmB3jfo70WgdOpbNLLZ2/NTTG9WyloOi8vqYllOpJY03264RSztu1l0hhcoEoamJxzXb2ZavE0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4461.namprd10.prod.outlook.com (2603:10b6:a03:2d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Thu, 20 Jul
 2023 08:57:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Thu, 20 Jul 2023
 08:57:34 +0000
Message-ID: <8db40977-19db-2180-24f7-cddffc5cf3a5@oracle.com>
Date:   Thu, 20 Jul 2023 09:57:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 3/8] ata,scsi: remove ata_sas_port_destroy()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-4-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230720004257.307031-4-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0030.eurprd07.prod.outlook.com
 (2603:10a6:205:1::43) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4461:EE_
X-MS-Office365-Filtering-Correlation-Id: 14b91a8a-d8cc-43be-8a53-08db88ff5bc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Z/b6EHjLnRfyMn7YxdBBeYBnygKudGRD6+BFQyk5TjYV2hNF0mtSq2lYLBQxaps/CZ2sAfUpzg7M0NKL9yfEdyktIwSWiMcnBUUtly/JT3X/YZbWuc1xF4oCsZ6tVwQzXRCIaBc4qxqCOCW58D5dAMkvOzxERkLW8zS4g60adJAvHR8nIEJ5LC81g64ffVWHMTr+5vEBss7hvcVx1p7tUNpZMej4JhJnG2IEKj+Err7JDf9CznkHS6QHiWPXtzeO+UAKwC/rqzqAC8jtUdtN+nkr2jkZvwWyd7UBVvidVi6u22ci6WOU2EsagDrjAduFQI/uVY0Lj6Y3CmO7KX3pImVH1UQbYXKh9zTD547JNw6vkJvNZJcS2nohWeNo09+MQOgyxl5iNMBFFhz+axVfu+pjWQImW4PVOuz0EVsGX6PPcIFd/bjiAjvbnq0nVdahyMxJdAA0EXZihe9dt68FJ48cs4sFTlq6sizsjRJ9cbhZNqnQS66niZX+gGojZnPiNciR6NcLQTHCKqYrAGmeZ7QfR+g3zcCdh5dmMG0xuKp+OjXKmwr7Tu62zKgXGtrz7ExsYz5o0G9tqqZ2f4CL9W3ZOfKOquBvGtl6WTaeLbjCiPaZ8Sw+sKMcUFxO5BWr0jPOf12/Wa+WQOiz/4b/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199021)(6512007)(6506007)(53546011)(41300700001)(54906003)(86362001)(38100700002)(36756003)(8936002)(5660300002)(8676002)(110136005)(31696002)(316002)(2906002)(4326008)(6636002)(66946007)(66476007)(66556008)(36916002)(6486002)(6666004)(478600001)(2616005)(83380400001)(26005)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czBuVWhZazg2cnkrNkd6OFI1ZjN2d0lSNGhDc1ZpMjBKRFpvVVI1VHY3Vmt6?=
 =?utf-8?B?NGQrM3JXRFA4bWhNNFNIVGF2L2x3akREMVFET2RZV24yZ2ZqdGxmREFXd2VQ?=
 =?utf-8?B?aVlMdFRUQmJzT2RZdXZHaVI2NE52TEQ0Mnoyd0tCWlJqaWU5N2ZaS2xoOFFF?=
 =?utf-8?B?emVjV2NqMFdMUWUvRERiQ3dneWVTeFBrUHgweHMvbEl2OWtaTE1xRDRMOGFO?=
 =?utf-8?B?cE1JRlRMMm1xYXU4ai9qVVdzMC9XcVM0eTVsZDlWNkJvTEU5ZGQxS1E1M0Mr?=
 =?utf-8?B?KzZidWg0Tm5IT2N6UVVHYzJleU9zQkVsNW50K0QyODFNbkE5b0lJVklLL1kx?=
 =?utf-8?B?OHZSUldWdUE1ZjNyeXZZQkNFWlJzUEtTYVg5RGIwRHlLYU5EMmFXRHR3TmJZ?=
 =?utf-8?B?MGtnZFBvV2ZLV0YxOUpHaHpNNklXWE9hSUVDT3hnMlhYYnZVbUU4S3FQTUJR?=
 =?utf-8?B?YU5DSm1HVEMxOHZ4Rk1ySG1OREtGcEE0ZG5vUTBHc3NCRnZadWt1NXZueG1n?=
 =?utf-8?B?czhkeGpzWnpQUnZGQUhpUkZjd0pTNXhvckl1WS82UDZkUElkeTJmSUNpYjVP?=
 =?utf-8?B?ZHE2SnF1SEZ2cjc5UVFkaXVvOE1hNDVjbmVsQjlLcHpVL0doMUZCRTRTZWcy?=
 =?utf-8?B?b3d1OXVxZU5rdjg4MGNkMGJMZjlVV21rdWIwTmtOemM4VEpOTmlGK09XdzRt?=
 =?utf-8?B?NUh2RlZ2L2xHbWRWMEVyUG5jQno3RkI5YmJWYkp2Yjl5L2pLNk5ESFJ4Z0o4?=
 =?utf-8?B?d1pZbXFwUkVWYnNrVnZGd2VWNVNBK2xvWjhaNUUrN2cyUDZic083a3orVXU5?=
 =?utf-8?B?QlJ3dmM5VFBqZUNxV0hhdUljc0pPS0F4c3p1QmpobUhtOVVXZXh1ckV6aVVp?=
 =?utf-8?B?YVA1NnFNajF0VHlHbUE4a3JpRUdEMlA2WkI2a0t3UjVmQXYyMFBqNDRBN2V3?=
 =?utf-8?B?TnZzU0ZDNk1jaEJiZjN0Y2RDa2Vjajh5Y2JJUURycnVKZWNUaVZ0SlMwcGFt?=
 =?utf-8?B?UjNPSk12RlVjamlxRU51Tzcza0pqaFlvei8yUWgvd3VHZGVMWE5abzVFajhp?=
 =?utf-8?B?cXErckVPeTg5Q1lXYUNPVzFoMlZHc2QvVHpuUDJZOFVuMVp3WHBrK09JaVZq?=
 =?utf-8?B?YTA3M3dQeHBqRmlGWFIzd2RXTDM2YnNoQTN1SFl2UUpOVGZUUmhpZGxzcVNO?=
 =?utf-8?B?cFVvUTd2Q0ZTdGR3a2dtbXFtMzg5RDRsaWxqektKOGxuc2xqQmk3NzBoMDFp?=
 =?utf-8?B?V2pDQzdnZmp4dE1VRVNOcnpML0ZSSEZoK0dUemtKZDQwMUdFWDZmeUJDSWJa?=
 =?utf-8?B?WFZxSWt3bHZSNmdaa2FtUVJHY3pZZWRBWU9kb3U3cHp5SE14d010ZEpIMEdX?=
 =?utf-8?B?ekV1anNPWXlZV0Q3S1pXYmVpb3c0dWdOcDc2cnAwMUN6Wk8wQUVUWTJ3V1ky?=
 =?utf-8?B?RWxBQ3R3MjZUaVVyZExUTGpzd1Boa0p3MDhjWFYyMzFtWC9YOVFNbWpGYi85?=
 =?utf-8?B?NTNpZ3k2R09MK0J2STVLY3h5bVV0bjdoN3FpT1FPOGE2dXdtTVFScFFmUWtQ?=
 =?utf-8?B?OEpDZW8xVWI0VTZXSnBJdHNaTVo4N3BZNkU0bGpBOWxUZmI2VFhXRW9leEJ1?=
 =?utf-8?B?QnlzZVZLQ1M4c1RPc1gxQUkwOUZuNTlvRG03RUhkZlV4OWowRFFJRFp4MDZs?=
 =?utf-8?B?MmtmV05jTllNQWMvYm5nY0RZQzVKWmh4eTM0S1l4K0pYMFVVOTVhdnFIcG1W?=
 =?utf-8?B?ZkdValo5cXltYTAzcHJxVHY2elNUTmV2MnBiZzJVNmlNYXhIVk9NNVU1NUpP?=
 =?utf-8?B?RE9ndnd0Q1IzMEhuTkorREozWnEzYUpIbk1YakVxY3pyQlVxcHQzb3F4bEov?=
 =?utf-8?B?aENxK21xaEphZUhwVWNyT1dFQ1BXbVlOSGJJaS9iSjNkdGthS1JlS1QxaCsr?=
 =?utf-8?B?U2dXZlBnaitYaDdJUWxvdkNkZVVQME8raWxKYlEwM3FOSVdzWk9tZDhWSzJL?=
 =?utf-8?B?QjVzcWMwTWRjaXNhZVlhTk9GclNsQlJSYlBpWmxKWDV0V0F4TkFuTEM1SXBW?=
 =?utf-8?B?VjQ0TjdzS1Z0YjEzNjVpdGJ3Y2FNY3g0S200Z1FCZCs2MWxzMVluOGxtN3pM?=
 =?utf-8?B?cE0yNjF4bHdCdHBvRzBBZng4aVp1Mk5wWmFvTlFaNytwbEpCSGpZZTdYblVz?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?N1Q3VzVhcnhwZG8zbkZweEUrbTJPS0g2Z1cwL3VYOGhaZ1NLcEFQUkxTOUNU?=
 =?utf-8?B?Ri9VN0lISklaTUZxdmd4T3Y1L3FKK0k0TUlvLzZSTVJJdng3cmhkcG1iU3JY?=
 =?utf-8?B?OTdWaHlGbWtvMCtHWnUwK2ovRjRWUUVPT2JpOW8vQkJ3ajF6aHJzYnVLR3ZY?=
 =?utf-8?B?cHI2dHBTSVRMeG1kU1lXVlQ4UXFWUnJYUU02TUVhakpaejBTNy9jZlBPY2RC?=
 =?utf-8?B?R2NtMTh6d2NMT1NIOGUvcjN5b0dISHdJcFZJTjBqVUtqVURGNUhpaHZ2djQw?=
 =?utf-8?B?UExldnVFeENQVXo3ZW9ZU3Arb0Y0cGpETnpKLzFmanMrbVdxZE5nSVdUbkg4?=
 =?utf-8?B?V1BBOVVPY2ZDNHVQblVocFRTZlJGbXJrKzhmNzhnbXo1TG01ZFErVXhVeUYv?=
 =?utf-8?B?NmFpOEpmejA5bVlXQjdXcUlMdUZ5eU1oZTVWSmZvNmNxckw4bFYvbGxWbFFk?=
 =?utf-8?B?U2lYelpGTXprblZGamFDSjQwZURGbDh4TTFTYTg5MDBwTVVaVThXUU01NnR2?=
 =?utf-8?B?TjJwTXd3Qm1ac1BicllGRUZEeENtS3htM25NbGpwNFE1OG5RWEtOZ0dPVkQ1?=
 =?utf-8?B?Q2k5a0ZPajNMNk44OEdBenRUb0lLdDFGbFRCUHR4MzZDMjkycXVEeWJyQWVW?=
 =?utf-8?B?ek42L1ZuMTRHT0hDNjd0OEltWnM1Tk03UFc2UHNuVXVEc0VFekRuMlJtVW1P?=
 =?utf-8?B?WWpTdFFoTHM3eGtFU3BHcGFvZFo1em1ndkc0clhEZlQ5ckQwSjVIb3VOUS9r?=
 =?utf-8?B?SDJ3UDFiWTNVZjJZU1ZtbTJJR3dMVUkvYnV4dFZRVTBrc0VyZ1pSOHUxRTV4?=
 =?utf-8?B?VGRscGFwS084YlRWVDVFR0RFTFphSXFZTkx1dWlVVHd4bzYwMGU2bCtYOFdS?=
 =?utf-8?B?N3RkY0N4Vk5xYmU3RWt4M3JNREFJcTZudmwrdUprRktkMUhobW5DVUQ4RjQ3?=
 =?utf-8?B?aFdrR2VjYmtQK3ByR3JBUkkzSWJ6NE80elRiOWtHNHc0SFUwdUFOYzZFUjRm?=
 =?utf-8?B?Y25LTHJvUDJocnNJQTNLcm4rL0piczJSQlg5cnFhQkZxc1JlQ2hLOW1vMWZV?=
 =?utf-8?B?V0hMYWt4RXU1b2ZpSUQ4aTl2RU1yM2RTTmdoTktzUWxxTkF4S0ZwZkQ0N3NQ?=
 =?utf-8?B?M05GdEJNS1BmU0NETlhqWTBuOEtUMStscThyZXNVWE1mL3ljVVpWVThNTlZl?=
 =?utf-8?B?TmQ5RWtSOVppSnBPRjZKaDNHUkhIMzUvciszOEhmOUtFNXU5VjljR1BrRkh2?=
 =?utf-8?B?ZWFPQjFobHFBYitFSHRSbU5vNVRhcDk3Vm1nanUzdzlGWUI2QT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b91a8a-d8cc-43be-8a53-08db88ff5bc4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 08:57:34.2623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYZ8vNyqzeAju5MyujHzPQIdzwl9EgcOLF9ssoIfrIgAcJ6xVrk32r+SvjfE+R0/Cy1Qhdz1g2jED+Dp/9mXOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4461
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-20_02,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307200073
X-Proofpoint-ORIG-GUID: TRj9uCHYePY6pYNPWPNSaQfCpiNdF2gO
X-Proofpoint-GUID: TRj9uCHYePY6pYNPWPNSaQfCpiNdF2gO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/07/2023 01:42, Niklas Cassel wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Is now a wrapper around kfree(), so call it directly.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-sata.c          | 18 ------------------
>   drivers/scsi/libsas/sas_ata.c      |  2 +-
>   drivers/scsi/libsas/sas_discover.c |  2 +-
>   include/linux/libata.h             |  1 -
>   4 files changed, 2 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index d3b595294eee..b5de0f40ea25 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1177,10 +1177,6 @@ EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
>   
>   int ata_sas_port_init(struct ata_port *ap)

This is a bit of a daft function now, considering it only does 
atomic_inc_return(&ata_print_id). Do we really need to export a symbol 
for that?

>   {
> -	int rc = ap->ops->port_start(ap);

I am not sure how this change is really relevant to " Is 
(ata_sas_port_destroy()) now a wrapper around kfree(), so call it directly."

> -
> -	if (rc)
> -		return rc;
>   	ap->print_id = atomic_inc_return(&ata_print_id);
>   	return 0;

always returns 0, so pretty pointless to return a value at all

>   }
> @@ -1198,20 +1194,6 @@ void ata_sas_tport_delete(struct ata_port *ap)
>   }
>   EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
>   
> -/**
> - *	ata_sas_port_destroy - Destroy a SATA port allocated by ata_sas_port_alloc
> - *	@ap: SATA port to destroy
> - *
> - */
> -
> -void ata_sas_port_destroy(struct ata_port *ap)
> -{
> -	if (ap->ops->port_stop)
> -		ap->ops->port_stop(ap);
> -	kfree(ap);
> -}
> -EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
> -
>   /**
>    *	ata_sas_slave_configure - Default slave_config routine for libata devices
>    *	@sdev: SCSI device to configure
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 7ead1f1be97f..a2eb9a2191c0 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -619,7 +619,7 @@ int sas_ata_init(struct domain_device *found_dev)
>   	return 0;
>   
>   destroy_port:
> -	ata_sas_port_destroy(ap);
> +	kfree(ap);
>   free_host:
>   	ata_host_put(ata_host);
>   	return rc;
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 8c6afe724944..07e18cdb85c7 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
>   
>   	if (dev_is_sata(dev) && dev->sata_dev.ap) {
>   		ata_sas_tport_delete(dev->sata_dev.ap);
> -		ata_sas_port_destroy(dev->sata_dev.ap);
> +		kfree(dev->sata_dev.ap);
>   		ata_host_put(dev->sata_dev.ata_host);
>   		dev->sata_dev.ata_host = NULL;
>   		dev->sata_dev.ap = NULL;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 9424c490ef0b..53cfb1a4b97a 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1238,7 +1238,6 @@ extern int sata_link_debounce(struct ata_link *link,
>   extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
>   			     bool spm_wakeup);
>   extern int ata_slave_link_init(struct ata_port *ap);
> -extern void ata_sas_port_destroy(struct ata_port *);
>   extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
>   					   struct ata_port_info *, struct Scsi_Host *);
>   extern void ata_sas_async_probe(struct ata_port *ap);

