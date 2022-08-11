Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7A3C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 16:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239103AbiHKQrm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 12:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbiHKQrV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 12:47:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918D4C7F8E
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 09:19:59 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BFnCRT032637;
        Thu, 11 Aug 2022 16:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=gcpzE3cA4IgcgpI45d3ZMLFQc8pjOEZoNiK3o7Pc/V0=;
 b=AFfm8SW9BpwALLd/G4OvV6E8nAiJ4WzCSwA8cfZCfrRwJI3Im4Se9tRdDoHMyZK7Z7vB
 QafjGCfmkIRHBnrXFlJ6xcajR2q1rnlUiuslAFv2oUyDkS6CmBIwjmXRjVHgyM2HgVUG
 4QkgFt8iiEAmlf4pnbnuTJb+V1iGEBsSw43tFsrbH1ZwDgd6LsHlST3yDv8naSIePSLV
 d3Ey1IZ+rQrlr1NqC3PnJ2aaLnKeoeuOh8aGpR2XjFTxhFd73buez22c2/oxGac7EtCM
 d+rbo1tYmoHRnZj40bfM8Y5JcuZxSZU+rSguHWp3iVf0PspgMzvyC3O7pYYg7ixdxrPv 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq95bm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 16:19:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BFKIt7020514;
        Thu, 11 Aug 2022 16:19:48 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqjs1wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 16:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijduCR9pylvpXQRnxw0bld3FPeW/QA5JkK+C6AVgaAcW9OhHd4RH1Uew3xiSeV+bhLjequYVY9bT3TAhhtbog4zCEkOGE5x/itRAV90rIpYCGDrN3jcjkEAY0uA0WsHolgNSF6Big5ao0zVd9+Zf74xWM0szFlR5PTqtxPAPMtkZVTSW/aK0DPEEf6NJfw87zT0hHqAPgjmdseDZAaELpaztEjahutBYS67ox//y0RJRT9FtBL7hrgy7HAJXGiMeVDSFmTy9nx45HVHMKx0imks9eifZV0ibuceGl+bVBAwitTsu+sUmZTgRThgSZ08GY4QFBETKDJX8QcoTxVbiuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcpzE3cA4IgcgpI45d3ZMLFQc8pjOEZoNiK3o7Pc/V0=;
 b=nXZhv9dmadH3QecOnxG/QPt1I0prccLY69bmVM4XcMskF3mD1R+n6TaN1dkJryyiW7/ucReatzPqyHMZy8ZprN6f6fJMT1eCTmmaRvUrIvi2Zvtc3hd0nFXkV6nzd6PrZ6f46PShosXtsEma4l4ozjJX6Yk0Dm+LF/84utNs2h/u1ggEbCJUFDWj+APVsWy050sdWd62s+gLvXMr98Y7/R3Id/HnNG+C8rcNWO3/Wpz5TM36UlTWh4nMxEHU6aiMtD0MTyv08mt61G4wl3w4XjfTIC+/qi2Io6xjdMtnTDYzvuWubG4djWvl8p/eb3f1/MFp6rVa6Dr/vaozPXkDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcpzE3cA4IgcgpI45d3ZMLFQc8pjOEZoNiK3o7Pc/V0=;
 b=IIsYTi8Z+4xJxNBhQCjBxv+Y8IsHUOtSR6AqjNzp1lc92QHBEUiItdOBJsb95+b+83OWZ4c4BZQbWadqL/FHXUQ14dJwPa8RDnS1GfUkITRhXcPjxHkQy4QI0KDu1xs0EJGS5GxRXsZw7ClODK4kSAumy/PS3yWMeszz9LzCkQQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Thu, 11 Aug 2022 16:19:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 16:19:46 +0000
Message-ID: <b812a7d0-4142-60e8-9989-7de2870d1a18@oracle.com>
Date:   Thu, 11 Aug 2022 11:19:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Martin Wilck <mwilck@suse.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com,
        Hannes Reinecke <Hannes.Reinecke@suse.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
 <20220810034155.20744-4-michael.christie@oracle.com>
 <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
 <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
 <2b33796a-b504-f0b0-85cf-09383543fbcc@oracle.com>
 <20220811122839.GD1742@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220811122839.GD1742@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0294.namprd03.prod.outlook.com
 (2603:10b6:610:e6::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd98615c-72d5-4199-1032-08da7bb54e70
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6wZHGh/VZ9OKISpE3JxlZchudw99dMpP0vlbcomBsoXHLSkQX3/wEyeinN099PwnbHyHll1gPinopl3h4mOHg7r1AVhe6oC5b9Cn4qWS8m+5lCjjmnxeYVrLyX/qPt7tF9Q7Wwu+pr6h7fY8PPV80kMFF4cJcqP6w1Mj0K27W7MH1XLBFgrzz1LB25eHWQtwldiCpNgm6qVE2jEKajYIUZ7nDgJIrLY/HCg6JuWHnGZY2DzsCs1TcRuQZeKeNTmOIt7HgO+mtG3kMszrMIxbffvP3lw6rcN24IzsK+NvX3YQTuiIKf84UAMPob/VOEN5AISFoedFV/gUdMNLMqVnTR6pl2WKBTrEr6xDz4onrekOPW0bE5ktKaQK8F2aJ1x1Q4yobyUHWlyl3iD2I3Rin6SIiVkPtMcVmKBRo3sq9YT1ozwwfz8Y4qQtlZia+FmvZ9X/rr0rIrBw7ziTEyUiqsawlSP/CfkVF44p6f55WpEimyRJfwp25NGP6w6pcyrX3JgCDaszpMG7AwpAOXbkvCZ21bRSJoGLIETK7VowBwMgTbD2SVYOjy3UlKbsdaLPTXoRQIZoDey3TuO/krkWNcnb9HDIgIZj1PCa/nZyO2WDOYJVwxfiN6FG/OgdcKftu/mUnA6+jtSYhCxaj3p/NIFw9bo0iU041fheCUjAqfCUUd+ptFDs6TmvLjZCh1uOiQpfOmyiKIoh8IdJmqn0FNSn2kngVPJ6lgtbCzxX0vhaNPZn+6QogThkvEhwsdgVlcmpln5OqU8ZsHvCPHicj+cnQUNFcwEmVfq5tZCg72+Fmr35421se65DatswPie9LEVzFroQ6gLX9Hbqg3bZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(366004)(39860400002)(6506007)(5660300002)(2616005)(2906002)(53546011)(4744005)(38100700002)(41300700001)(31686004)(36756003)(54906003)(6916009)(316002)(4326008)(66946007)(66556008)(66476007)(86362001)(8936002)(478600001)(83380400001)(186003)(6512007)(26005)(8676002)(6486002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1M0M1lYN0Jkb0hQTUVNMkYyR2YwSE1CZzVBSHUyQnQ0b0dncXcxVjJteUFx?=
 =?utf-8?B?UEp1YVlYZHdmNmx5K2JqYU0vQ0xwdTRIS21zd2swQzdvNHIrL1ArbDc1M3Zo?=
 =?utf-8?B?WmRCbmpzU0xVeVREQks5a3ZrNDdNOTJvYWFyZGgxTmc1dkNhTTh6YmQ2cmhZ?=
 =?utf-8?B?N2NRdVZIMnUwNldwRWgzTGFUSEtqb3E2RGwxaW44T28vaWsxY2NlNzZBU2hH?=
 =?utf-8?B?YlRnMkVYKzRWV3kvNExQczI3em50K0ZDdnN4Q3dDSnVXbUg5ZGhCSGlvZFQ1?=
 =?utf-8?B?RWdPMDVTNHYvZE5EempwbUhpSDJyUkg2azhETFY0UVRVZzB6WmMxbUdyekZx?=
 =?utf-8?B?Ty84dW93Qzc0MHF3djBjTWQxY1RaSEVrRk00R0hDSkRYbmp4ZEdXdk5rMXIx?=
 =?utf-8?B?cGZPdjBjMk5hTkpYUjRkV09tNFg1Y0FPTTFYK1h2TlFFMG0xcFo3T1FScWxN?=
 =?utf-8?B?U052aXVoTkp0TnJQTFhGcjFNczd0QTFjZkhNV0puNndLL1J4NDEzOTg5Z3l1?=
 =?utf-8?B?OUxsL3RWY2RRU3ZDcThPUURqRGlkR05NQUhDN21ocWtKR0lPR1N1MUF1T2VD?=
 =?utf-8?B?MWlHSjdtaGIyVjk4b1dXby8yUmRGaEljcWJwVW4zSGpIYnVya2JSQmc5V1Er?=
 =?utf-8?B?SjZBVkx5RVU4SnhIanZPYVE0WWl6a2c3RlZYUjVsMFIySXd5ZERBTW1ySG92?=
 =?utf-8?B?eE1Pa24yMHhNSlI1Z0wzemd2SWN0VzExSzgwa2pSMDBtOHNCbml3dmxwWEVV?=
 =?utf-8?B?UXQzSGF0RitEZ1FLYnk2dU5kVzJ0dzNKRDVFS1I2d2U4bFNuMWkyMXVSRXBT?=
 =?utf-8?B?SHduYVFpRVRlZTFjOVZwTG53NW9qTUg3RkF3UmhNU0ZRZ3UwditNUlFqTHBa?=
 =?utf-8?B?QjZIVlo5ZkhnTy82cmszWmRuOEpobHc3UGpLNGkvREJRUkJpOW1NSkdBOUhY?=
 =?utf-8?B?dDVGNmhyNlpBTzQyNnd3ZmxsdjBsSVEza2JPd3o4MVdRUmhxbUFxT0hMOVZK?=
 =?utf-8?B?cXJWODBkcmlmYUJXSktqNFBnQ0FXMFlyMEFMZE1vMThuay80U1V2ZGpzWXIr?=
 =?utf-8?B?ODFDT0VzLzlFZjJFSDdOVisrU2htMkl3SjdBTDhaeVFPNnNkTktQeTBqckov?=
 =?utf-8?B?d2k2cm9pZU9qNmFmN3BXbUhidHMwcVpMTUlMQy9xUEI5OFk3cVdFMDdIRXZV?=
 =?utf-8?B?amY5K1psNGVDbTVYTHlEYjBqWUFoL1lwSDAvY0JmaDQ4dFlYRkFGaGY1QnNy?=
 =?utf-8?B?amt4L1Uza25WRlQ0TGs0M1h2RTRhYW0walYvclg4WklxaUVXcW5vamczMFBH?=
 =?utf-8?B?LzV4QlJUMGRLRys3S3l6RjZGUmVVY0V3VENmbjVUV3F5eFNMZXlSemxPeFJa?=
 =?utf-8?B?NTlFYllVR3pKdGlwYml2eTNsbmc0dEpMUVlONVRrV28yUUpvUHVJZVNkRTBX?=
 =?utf-8?B?eW42SHUyRTB0YkxCVDNzOW1uRGZ6aEhBV3IwZHlxOENwc2FtQXVHVWoxSEMw?=
 =?utf-8?B?Tkh4a2d2WDB3RERjK1FkNnJDRHpGVDlWTGZsd3YyRmNjWXVGRUtlMU5qYXJt?=
 =?utf-8?B?UE1SZDJQaVpiZGtOVEVjSVJEQlh0QlNJU1JvM3lzc2xKR0h1aU1UZkhFQldH?=
 =?utf-8?B?ajZsTll4VldpOGlRWUZXdkhLRkh6dXVEa3ZiWEN4aUtkN0lPSU8vd0xQZ1pE?=
 =?utf-8?B?K0JpLzhxaFJJc2xvbWhuUUdoSytuM0JrMzBuTzc2c3ZNRUl6alhKb1p5Mmxt?=
 =?utf-8?B?K1dXbFpRTXZEL08yS2ZpT2tTRkNYRUlNU2pxODhLTkI0SHQrNCtPTTlZaG0w?=
 =?utf-8?B?dzl0NlhwelBzSTErcUpWNlNrb2M5RGMwdVdPM2NocDVsME40QnZaN09MSSt5?=
 =?utf-8?B?cHliZzlYU3hMRHZoUWZPUWQwcldhWi9PK2RKUWtReGFMK25UeCtYVldTRWhY?=
 =?utf-8?B?NU1sM1o5bU5sWGxoM1NFUzVCQTBoeW5TRWMrSEdGRkFUWVVOYnNxQUFseFlP?=
 =?utf-8?B?TDhLN09wNWswVis2U25aMkJBdzQ2U3I1VTJ6S0ZQcnNhWkZOdXVnbFIrSHBI?=
 =?utf-8?B?Nlh2V21UT0l0NFpvUW1ic21oMVJwV0R2aFhWbkZZajZjN3JVR2RVelNiL3RG?=
 =?utf-8?B?cHlIdVY3OVZicEQ4cnBGYkp5OURYTDF4dzdvTzl1T1hoK0JhQVk2QitYck5D?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TWRIL2dmNXh5YUVOK0x4dmlNd1N2MVFPaERxeThIV0s4ZlpwbDl3TmYrcEVH?=
 =?utf-8?B?a0l0ZHpLWExRKzMwWW1VRk9UVGduVG9SR09hVmJkSDZYY2g5cnM4dTRSS0NI?=
 =?utf-8?B?WFlQOWtXQyt3ZmVnUmNobVBKcU4vdVFkNTVyY0c3b21ZTWg0SWxqL3BXSDEv?=
 =?utf-8?B?TFVNY2x0Y1E3dk9qbVBCNlFPdk9GQXR0UTNhdnpTYjMyMmVhUVFDMkV4WDlL?=
 =?utf-8?B?MzZ1d29KNHJmZVp1ZkYxd2VBRHlQalhJdXZTOXZkNzh5WHhiUHVqY253Zitx?=
 =?utf-8?B?NUJ6bVA3UVNPVnREd1ZObUQ5Qnd0bENVY1J4RlV5WVpqQjlhT1BGakxNTStF?=
 =?utf-8?B?SkZrcHZxNE5uTGdiam9YQVdQTkwyWEJIcXBibmE5bGhPZHdYTmlHNm02aE13?=
 =?utf-8?B?WUFiRkVJRFpFcWZaREFNNEJkZ0lSTVFVTS95YW1MRDRCZjJINzRTM1lvSDFQ?=
 =?utf-8?B?MzJPdmcwTnJHeTdpT0JLcWExemltaEh5UGtrNC9lNlhINXVzWEJ3SXpnZmNP?=
 =?utf-8?B?NGhTQm92OVpJTFBESCtaY1ltcnZkNVZONXNRQi9WYVV0Zlo2SGZmbE5FUWN4?=
 =?utf-8?B?MHhUd1ZsdlNPcU1PZThkTHBJem4wZnR4Yk0xeWVxYzJDLzVYazdDRHJGdHJl?=
 =?utf-8?B?MStJYlkxc0ZQbk5PdWk5M3JMOU50dGtxc29yOU1WYnA5N1NtaGZvRi9IUUdU?=
 =?utf-8?B?Wjl3NWU0M2taeUhVVWZ0WWUxd2VwbHJkWEx0N2d1cFJwM3plM1cvYzdjSGpm?=
 =?utf-8?B?eWVrUldSQjhUM0dNaW4wcnNBWktKTVY5T2RsSXZjcWU1VE5PUkc4b0szcTEx?=
 =?utf-8?B?R1g2TGgyTlh6Z0JXcmtFeENSUUNneWdZOVJtK1VIWHhWeFg0MFlRTFZHZHUy?=
 =?utf-8?B?b1M1Q0NXNG5VTVkxRWU3UHcxc09xVU9NLzJDSG53R2JhWXB0V1dhZ29OQUdI?=
 =?utf-8?B?dmpNeTJBZk1QOFoyRjJMekUwNEpCbnBYMFpwT3RPd3Q0RTdLMnp5Q3ZsMFo1?=
 =?utf-8?B?T1JtY0kyNTVGZE03dG51bERCaXhMWUJIcUpSTGpBTitVcFM4aTlpUExPZjQ5?=
 =?utf-8?B?emRhejRCMXorampwY2JoeUdWTXFsVlMzVkxGTE5kWXNOSUpseUZ0ZHQwN2NF?=
 =?utf-8?B?RTdFbHFCcGVxUUNTQUJJb3lmSHhDU3ZYZUNWRWhjd1pEVG96SzJuaEN6RnND?=
 =?utf-8?B?dHpoUk85c1MwYWRMRzZ0ZFc0UW5OOW1tSVdGY2ZxVXY2TlZjZm9CVGJ2WnlB?=
 =?utf-8?B?UzE1OWVjRGswL08wRnc2TXBqUVViYnlyMWVOM0dyWkd5MGUrY2Z4MndyckFF?=
 =?utf-8?Q?oLRkHDfN6r1ekdR8SHIcquWD9H5Imy1e9J?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd98615c-72d5-4199-1032-08da7bb54e70
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 16:19:46.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnh5DZet9tVhuuHzK4H51O6ji9pdyZ4zS+2J3O5EVwxPg8tjY1yYlekuaLuvKXF29b3TuzYZqQ/yMrG6xsDZ4SmDb3enjmwJ1OD1VPbnfU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110054
X-Proofpoint-GUID: itTTaRit7FXNs6bFdPsonnzt78jXbIPZ
X-Proofpoint-ORIG-GUID: itTTaRit7FXNs6bFdPsonnzt78jXbIPZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/11/22 7:28 AM, Christoph Hellwig wrote:
> On Wed, Aug 10, 2022 at 12:38:08PM -0500, Mike Christie wrote:
>> It sounded really nice at first, but to do that I would have a bunch of
>> cases that might be specific to pr_ops, alua or scanning, etc. Then I
>> also had cases where user1 does not want to retry but user2 did, so I
>> have to add more SCMD bits. So, in the end it will get messier than
>> you initially think.
> 
> Do you have an overview of the different cases you've spot so far?

I'll finish up what I was working on for this type of design and I'll
post it as a rough RFC, so it should be easier to discuss in code format.

I'm going to break out the first patch, handle your comment on it, and
send that separately since it's a regression fix and not related to this
discussion.
