Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D35C001DE
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 11:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbjGYLUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbjGYLUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 07:20:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF5010D;
        Tue, 25 Jul 2023 04:20:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oPwG015643;
        Tue, 25 Jul 2023 11:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wTzPyCr6xy0Wl+BTEvAl+DSGNQ84waJJhAHfJEg49eg=;
 b=kD0bjNSNBAXxcXLYVohDOucHYlwGfDDHZxWWyzRuwXzBslDS2gcVyhGlwD3uMLt+eyNF
 0kvlprSY+aBBaR2EspXKfaRm6xH1o5rM56dyYsH4pFrIJRbYICZEejeFZH89YOYsN7CF
 9ujPd53TIduWazIUUNfCDSzyOwuJcmlo8NzJKQbXv4QeXQ5AGNSh04P6qVJXeKcyw4b2
 NbVZ8Ilh69WvrsDjYhOaUJhYi45tQWs5ftowM6KFUnU9wYoZmtcqOAz8q50CTITVCosI
 OBx/0wMRr142FhRWA32tLRJQBOwZvwHQ2Jhb1MkUzFjGOrYPK0gd82DqbjZGZiwsIUV0 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s06qtvsg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:20:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA91jZ029653;
        Tue, 25 Jul 2023 11:20:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05javqp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:20:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1RlE1Xc6QUar36F2ClpKIojKrlb6jmb6a982qvCWO/D6/USj6m5nJtyFcd0RnJJTIbpXkoqdg/3STQj2OjaEVQpuAglFKhYIJS7WdgSZW37Ewc1yLkOjiRnXjvEMe0wrcah33Hia/BWu9dRKhVrdyC9fAvH3dn4avCAmbjjbjqDoBIEZya8mTQhEkwnMj9gBiEbxHqIBFJrOYLJ3Aj5OnvrS+mOSyVPlTXQGNwSmNvyul8zvbBkW2HTgIJbMImPAXXaAVSZ5AtIQNn2Vl3+qzlSwtNakXyoq6+zfgBUMB89eDLnVKKPQpGvhEZn6VQ1onTOuRu65TYhKb0mCGxyMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTzPyCr6xy0Wl+BTEvAl+DSGNQ84waJJhAHfJEg49eg=;
 b=gEuHm+ZGPukf3k95R/OhqHUT+CLe/COm+6t0q1K3bPuzytpDFX7ig9Rb3pfRFWjXUXjqIQB/asCpmoPF9d7YMEFHSNDZ2/JK09+zTGB2TDTma94CVX8EZRcOQF5SFSU24igQi91LjgMbauVWdtMJkAVHjjL9gaSyQFXb5PzolR6AhzBkgjybr+80edYJRikWXcGsj+RcUyz2j7eZ52vS4Uqu9gVBtK2b/kzqgr0v6rPOd7YNZc6Ff+2zthKr2qRrGvO7qudV0cMTN53GgZ12gQoD9EiWTJolHrqOrpjY3IfF5C6XNQ2rmtW487F6oFoXX/6Kn9bFp2+8S6ZkTt+9Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTzPyCr6xy0Wl+BTEvAl+DSGNQ84waJJhAHfJEg49eg=;
 b=kDvPFbaHSmTeTDYzGUBlwvWBOARuufzyDPk8x8EiM5NzeEwIhGVaGGEQQrig0JsjMYpmH+2HufMa3KT6PxKyeUPuMqJL7WHNn23hiDH6bI+Kba+O8LIdPcwr/HOdAZPh+RZbjq2An9zqX/nLV5EDvGw5PmRzuE5tZ0BK2I4V/tQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6774.namprd10.prod.outlook.com (2603:10b6:8:13c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 11:20:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 11:20:16 +0000
Message-ID: <f3f2834c-3977-53cc-5a9c-93dd41f69f89@oracle.com>
Date:   Tue, 25 Jul 2023 12:20:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 9/9] ata: remove deprecated EH callbacks
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-10-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-10-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0041.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae33c1f-2a56-47b8-9535-08db8d011f33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: buy1WjI0+/n+cd474VAidZYAv6j+tj2FcR60lb63hCjjxyyX8ypMmV7GCQYLB/RuXwhy4ej+IZJ2PUfBxEdHMhvzEF1gNAApGz/3WQxouxB1okSZii3VmcrkA3wvLCqUHLwuAE+lgqoSmoLQ4t7BIwMUQoSXIoIUL6C8oJVSkxX0CpEsPFqmEcuMsbU5CBtxquDSJLdgXUT086rssGj2+kaKWH/iKbsaCwHWke0yVB3gP7MIP4z10NMypw5oekv/NtE2jttllipUfNK8syVgrVjWKHKPYePt/U4izE4K+AHKE/Gtqv/38m7ms6GUjwO8GyzkRNtw4hZMe66+9Swc39dqZqn8roAaR4NtabhqLpqIY3wjU2N+psNsORA2uPaWmQYo/tQ2DfFxS4rlNLXlv7xlC+oSyFhoBepujFHBNjtxne+NQ6U0ykdUgH+BwDK9PMmJBZPQ0wU8YHvP2LlgutJNPg8BPfgiv+zWixfhZmtxQEPrqffDL/WRscHuNllg54hGi/KeosdsOFAHdJ9cQmOKd66e+XbtN0+mW8QQSgng9P3k8ylCORWGKEMn7VQR1Ic3KQ7IEYizuOOtkaqRR13jTgJ8atl5uDLBfBMUANqLi6dlm5jkAxg0PT7RLHUPqlhBYLaqzS6I6SCFsiLClA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(86362001)(6512007)(478600001)(186003)(26005)(66556008)(6506007)(66476007)(53546011)(66946007)(41300700001)(31696002)(8936002)(4326008)(36916002)(4744005)(6486002)(2906002)(5660300002)(316002)(8676002)(6666004)(38100700002)(36756003)(54906003)(110136005)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWptVjErRzJwWi84Qk1Mc3hSUlF3QkN0RXJzOVRnR0c3a0pvcEZpZzBrOVlD?=
 =?utf-8?B?MWFkemI2ZGw5a2JIS0VqNnFOektraWczbkNEei8xZ21iWVkzL1pYNkdCU1o5?=
 =?utf-8?B?OStod3VidUZRZHcvL2w5cGFFaHlQZHc2WkNFcjRmZHZLUXAvQ0s1dmJ0WStF?=
 =?utf-8?B?dUpQRUVzQk1ncVdhRlQwbDQ3R2NYK2FYaGE2d0ZKT2JzSnNka0lzWGdLZmRZ?=
 =?utf-8?B?WlU3ZTFpVVRYSlM0SXdlN3ZCT2ZiQ2hXbEFlb01zdlA1bVBYMVBlSktHQzBr?=
 =?utf-8?B?M092RTZlWmNnYUpoUTk4d1JQTzU4RHZaWmZERHc2Y3JpWkxtUGdmRUNNZk5H?=
 =?utf-8?B?Qm9wUHdxaHRXZDlsNW8wUS94cGp6UFByZ05rY0lzOWVxSkNTczhoZHFsSGRj?=
 =?utf-8?B?TUdVNmpEeG9lZzFGcDNDMDlwWnFkeXJBbHg1L2hLT2VHZUduc0RpSm85UldQ?=
 =?utf-8?B?TlFIaUVHOHl2NWRKd1MrQnNkc3dKTzg0QzIrZVZFU0JPWVFZZ3JLcDhYU3Zy?=
 =?utf-8?B?R256YUJTL3BQcklwdWNOVGlqcTMxZFFNK2xUNGV3dkNZaktweXJ3d0VGZXht?=
 =?utf-8?B?OERuTkQrclM5eDdMSndualF2U1hub1pkUjVhTGU1OHhreUwrUEFpRVRGL1I4?=
 =?utf-8?B?cGR3Nk1YWVVyZElPNVRKbkc4R296ZktNbjkwL1pQUWZzeDRqdG5LNnFxZkRp?=
 =?utf-8?B?TnMyUW5lZkhsd252eTdTM0pPdzB0eUNQM1QxQm5JZ1BJMFJzQTdBZjFDZGxC?=
 =?utf-8?B?S0U3bGRKZ3ZDTDFlYWRGMFdtMEhRcHcxaDZjbk45SU56MVAweGhiaGRLWFZh?=
 =?utf-8?B?eFVDSDc3NW5tTkN1ditOVGRGOFFYanN0VzNBRWZsRXlOVTlIeTRtekNtNDB6?=
 =?utf-8?B?bldHN3JZSXcrUVh1cjZqbk51OG5VZGhoSzJkY0pFc3ZLUnczOXNSV3dRbHh3?=
 =?utf-8?B?TEh5UkZpaUJqQUdYYXNKaTAwN0pUSFBNbjdCZ1hiTXN6ckxvc0NGdm9rcDdy?=
 =?utf-8?B?eU5SNWhqVHZwY3lhUEZNZW5WUDM0dmdBYm5JWFIrdW5LcHBHNDhmS3BBQlJv?=
 =?utf-8?B?d2ZGYkdQTzE0RUkvdVY5UHE1ZE1ubUt4QnEzWlhodm5zRTY5S1pjR0hRcGxt?=
 =?utf-8?B?Q1JETzV0ZkF5SXlNTVk5OUlZcGNwdjdJeEloUnpJa1lvVmtmYml5T0F5amRD?=
 =?utf-8?B?WjhBOUtXZlZUeUV1aGtBbkwxMCtnS0FwdHNBYWlDZ1BZQ0NvMG02R3lpR1Y4?=
 =?utf-8?B?dlBOTmgwQTVVTXdnUFN6UVJ1bzQwM0NyVy9ZaHFmVWpLNHZOR3I0b3FObVZY?=
 =?utf-8?B?dWpYWllBNG1VVnM4UThZdXpkdThWR1dUV0ZTTDFMSzdmZGlxU24vU1BhNEVn?=
 =?utf-8?B?R1V5bExld2VQM21iMUZic0U2eXE5c2pqMW5hV21pUmZyV1g1anZoYmpOZi9H?=
 =?utf-8?B?WWo3Uyt3cE5seUZ5eTcxOFZJRHZKK2d5TjhvL1lIZjFJSVJEQ052TTRNQ0ty?=
 =?utf-8?B?Y0NSMkZqY3V5dDZPV3VtZFRLYmhqaFEzbnFKd1MxNWw3VitqUTJYN3RtbGlk?=
 =?utf-8?B?bVlySEpSTkJwZkZuZ3g5TlhKa1NHS01jOHlNUnVubWVpUHl2bDNJOUptTWRO?=
 =?utf-8?B?M2dRZGZUaFV3dEJVWGYzVVRhWDRCbktncG1VeVVaWmNEcG1iL2hjY3lXaCsv?=
 =?utf-8?B?SlJiWEZpeG4wUUdFMkRwdy85ZndRd3BTelp0WkhHNmhoUGF6NmFCQktnMXln?=
 =?utf-8?B?K3dTN29XRG94YzAwV3g3akRJeTUzL3NSMnkrVENIYTd2TndUOHR0cGo1bE9n?=
 =?utf-8?B?VVVBMUY3RWJ1UmNuRUhUR1JjUUEwQUJpYmVmOCttRVBrWnpoYllITjQvb2ta?=
 =?utf-8?B?ZWVxa2FmSUlpekJOWWpPeUlVRG14TkNIcVlVVGF1R3NNRGhWOWdrVnBTUlBV?=
 =?utf-8?B?SExlQmFMSis5ZCt0QU1keDkrS3Z2aS9sb1oyNHdaOEtrL0t2SUNISEFFZmJN?=
 =?utf-8?B?cTRxUEJEL2ZaL0xxVEFwamU4QzJ2RWR1emlrVTBERXo1V0Rrd0JIazJvS0Fa?=
 =?utf-8?B?N0FmNE9mT1BwSTczRmdCZy9RM09PMjE2WDV1QnNiZitUTHVkRmFSUmVlK1BW?=
 =?utf-8?B?NFE4WThMSVR6dm4zaEo5UjJ5MGFUZXptaVMwcDl3VFRLd082dVJxU09TdGtJ?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AiFqa/Bve2Dv4hEfe89ylIbCmR1UL0q4dcl3+UGCdsmrnKrT3ddYUTszcoGYMEKp9rajyzDOzpMS0jJ9vbOCQ0fN9os+O7V/zFF7+QW8g5Rhw+5BmFDcRfeigj0OLWGWLQXzBLFLuVC6L/pu/+cBQVHTfvPKjQ7TXNoHavUAJaAmPum2aOcl1XygqlIyS2qSZjFMmdza6dYq9Lt7Jmncm5NYwWcfPjSZ7vR/1xVUoiT884tQj1N06khO9S+7NOs2PovBSelHY7gF+guYjOVTiVZX0Usv567iyRgKKGpzExGKYcJHypVDEwhJBcLZ9QNzlXFE6LgvWLtKL/172htcAQrw2cBM1a5u9LUJzP0PFbTvHZ/JP76b7oQ7Dm4hflr43rs3KZ4IRZmObLJTeCm3PSHlnolnXfUk78EUpwpUy5XlQgrDfO+iWdJ8W/ORF2Mdac5yLJSP8iVuwM6ACLLAJO2gXc9xbmFfIsMNAt4XKdZMiKRRKqB6tZ3eqwzToaoCw0wgFWBIaAOCi+o2zKntuXNqk2DNfXXjSZ/nqOc9un37JisxefICyYSxcsoB9jYda2HPZOy1gb2wO4ikHUeOQT/WyrRgoRdviBKTsN7CBRW9egpbBjqnhAMEOCIrC0jwmbBArptepTtiZBGynpRZiFviojRkKfHwkiLZ+VnrvSEHOMH7xJTTY2UbBZd1DpguHVsaC1oehoC9gkt+QAResvLv6veYUZN8NSfaxHKnXmzoEZUhuUZa2IDPej91ejzmVEvQv12SAQczv6zNFA0iz+ogKGozyMZL6iNr0B6QewydctJtY6PUiJEzR+NuKYVTiNa27IDR7atynQZHWyaKsP3pQWP0xCZUaqTLlTGa/Z2JWk+6sPvHvimPEQLwx+DHJDGWb/VAHMiGQzyb6RzWv1i524Ezu+dHEF9jIaDfWXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae33c1f-2a56-47b8-9535-08db8d011f33
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:20:16.3137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EuoElC8osUYrEymEeYkFd5A72ltT/Y2eYcY5Tc5sWITXNY6Hn8PQ9MP1CXsQw9OrcQjqzX1uk7Dr0vRVV+AN+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307250098
X-Proofpoint-ORIG-GUID: HjRyTZMBFK7B6F8L-DTMqTB9kUB_79hP
X-Proofpoint-GUID: HjRyTZMBFK7B6F8L-DTMqTB9kUB_79hP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:
> From: Niklas Cassel<niklas.cassel@wdc.com>
> 
> Now when all libata drivers have migrated to use the error_handler
> callback, remove the deprecated phy_reset and eng_timeout callbacks.
> 
> Also remove references to non-existent functions sata_phy_reset and
> ata_qc_timeout from Documentation/driver-api/libata.rst.
> 
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
