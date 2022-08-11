Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812C3C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 16:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbiHKQns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 12:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239166AbiHKQnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 12:43:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB78BFA83
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 09:15:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BFnTk2011428;
        Thu, 11 Aug 2022 16:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=j81iMsiX4JlP9YzBImsvnrgT9WLu941tKLmmxK/K0sw=;
 b=O8g1+rr9/AaAnIMS9qnRrXfqRuLeQKTkF506JHT0RUtKXZu3X0c8V6NfwezuuRhbNWlt
 9NvkTd8fgsNMIKCWuBGT3pBmdtVuuWYvUgoHNKeZEKP9lIrx/8MW1R8aMKRSdQ+H890F
 n/m3yFIe+6pS6x9uNHaAFeSsbegatsXGQ8Np4KwggDcpnN9LEchQbAiQjR7ZaKcICPoD
 zlPnjfDnit/lbCPxaudr9L+GGm9DGgCofmkSQ8se3Mnwc6TR/XkNiqhYZm/yV/D/3Bda
 Fu0gfRV3oeM0IwUcwNTZIcW58VFnV7JzMzeRnX2LMkVaJoWvvaLpjStQcbI1TqY4jI/Q Qw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqgn2va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 16:15:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BFed94004928;
        Thu, 11 Aug 2022 16:15:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqjs0r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 16:15:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Scw/xBHbiU/e86g/Alc1t4W1SitCr58M5mhqmLXVx2ujW0K5knvM/+b2exhGMqymez9Mo9wQlu5zk911Yj7vs9SjIFOVBBA+YyzOr68wyMuclaQIwESos7bh+4jPPeMJduGd8SHOZYbfQky72OeVR6YSg8D9J9uZDFTmgQambHvkByl9W/F5SW1jq2wgN7TPn8Nb2A40xUANImvoBw1l5iTefhGde4Hli+DC2V4NCdUHiF/FmTruJCET/KryLMZz1azn5Mtu3DqeB+WA10xR2awafw9qftd5JDWsvqWfEqnBLq88ij6W3XyIphAEaJmWzU7K6DC6Kldl/Jh3jegtxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j81iMsiX4JlP9YzBImsvnrgT9WLu941tKLmmxK/K0sw=;
 b=bw4FUNhjolMu4OYmugdlC7qmPaW6XFvqUtmEEGZkTEKIRMJjvcxI6rheTINrdo41WOaAiUQoYfrd/SIT8Z+NHdyO/rxx7VrDMnM4aNAZLP39EyXefxQj1iA0OFe9omR29Du4yobUvQzgw80AmCo3TlWjCMJFFj3ishUINNkQE+x2seAIylmqyNiVr56uKwCfSt5KLAP7PvxpCTLIwFys7Z136IjfScXN9OEftH2taIGbZBAmPQhZK79rcyMVWNvtRXa9WqiE7nzVJyADo59j5XLJI1bXjE1FAUkLwFy7aZq57M81AK+hasUVHexhqkkLDoe/Xu/Zho0BrqJqyFnZPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j81iMsiX4JlP9YzBImsvnrgT9WLu941tKLmmxK/K0sw=;
 b=T2UToeMib6wOsvozhgutFV8GGd9e1gMUkbalwU6d2nj1rTfwDBPkNez8gyjre2aWObgTMB8dKgRrl5S5GPTQnT74nVMlbG+95mwV/HlM7u8ZsU/vnlS9DTXQTLJyPj97cGH9+IVKPkiKDGpWkfgM5AKveZYZbiD5Nzid4Azbyw8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4945.namprd10.prod.outlook.com (2603:10b6:208:324::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 11 Aug
 2022 16:15:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 16:15:22 +0000
Message-ID: <e7318011-ee9f-05ec-eb87-1d95f4fe12e5@oracle.com>
Date:   Thu, 11 Aug 2022 11:15:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Hannes Reinecke <Hannes.Reinecke@suse.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
 <20220810034155.20744-4-michael.christie@oracle.com>
 <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
 <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
 <e4dd855269b2efb2e2f3efdde92f1f3339159878.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <e4dd855269b2efb2e2f3efdde92f1f3339159878.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:610:4c::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d67f9b0-0c42-4ad7-b4cb-08da7bb4b0f6
X-MS-TrafficTypeDiagnostic: BLAPR10MB4945:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuP73yq+WaKXJs5jRfzN2fLgBAc2tzsZQ04MJqd2GuWSzowpLzKUIi8BqPDvzXKl4eIXRxZb1P29ELfSdxSPh40w+b2dAbNSYYR2KOcwd7N//mNGeOxax/y3a4LpwZQ5IGdfiRKt4zrFuYsgx0EOw5myc5CldFQPoIVahhOtw6wN4LoGklh6MUNnOU3fBPJN0sIpuZ+cuqXXS21sl3K74Ayff1VTKxdGSwz5qaNdCM8pbN0lyei+dY9Ciy2VzWLBmHjUsHyvCesIxA3Vrl0xrlof0VIQVE2HzDXwfAbV1QmNLTo47m5IR3LUTqINesRXMccD1mJIjSt0dGEtjnGorQ4a9fFsT7ecl6MqewwavKJDD1ZQP33YsZGJafVkGO5qmx1K4LEfC9c7rETqqN95Q+orVsWHRYu9n5qgw9l422em5W2o2Pm0E9OAasHtZAMstv6az2Wins+qdgiypAQtbl9Zm3svA//yYiBJKa8SnhFcVTTIiMHw/+dAANIo9iwjRYLT15EOA079ywDPp1ICLcM6IdoFMUU10Y1d934NSfBTY8is110MU8L++wvmla0g2S/C5w7BQ1O+9F31plL2awWfclv2SEhVY7vJz6pSD+nN0DpAQsfkHb3wc8YveSyhhdv+45LRdkNXNXEweJ/atIjhARCaut8LyaNmiQGdRrFYvlQ8R1pdzveNO8Y4r926cH9nAaU/m41ISxzWWpp/VjxKipYnUBwFeyWpRYuZqhHxH9qhOsozNSuYxI1qcOt8kpK06CdzIu6H69Gzt6hJDmUoxhUo6bumeZApyg7vm7S3bHW66H7Jqt5Oa/KGJDKh1Q7wYjte5SH2EaL7qv4yGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(376002)(346002)(136003)(2616005)(186003)(83380400001)(38100700002)(6486002)(478600001)(316002)(41300700001)(5660300002)(66556008)(2906002)(8936002)(6512007)(26005)(66946007)(8676002)(53546011)(66476007)(4326008)(31686004)(31696002)(6506007)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXV5R05aQ05IemlNRjdrTFhhM1VrRjlMMVp1dklXczE5elBkSk80Y2x6U1dl?=
 =?utf-8?B?SE9DSlVGUXAwdEhxeCtCL01JNEVpZm96RG1JUmVvcEVYVUFNK3NoczRYbWlx?=
 =?utf-8?B?cldJSjQwZ0NaczhaZUl4RFhJUmFyOVcvK0dudVBhTCtQeHpyOUVKK2YvVHNi?=
 =?utf-8?B?QUNDSVRpWWc0RzR1aGJyZjl1cGpRV285R1ArMXVIR0xQQkUxMjVWdHVVbmRG?=
 =?utf-8?B?VVorUmlwdU5HNENtKzJiWStBMitKS2E1ckFkSXFBS1ZRR29IWko4aUVicENu?=
 =?utf-8?B?Sk5MTUFSTitEejNUWUZZWml1cG1CdXk3SmJwTzFQcnkycnl5UWNQZzVqY1Nk?=
 =?utf-8?B?Z0F4S3kwNEt3MHp3TDNyR0cwTVlvM2cvcTJkTnlKYUIvUk5WMGtkZHlIWVBZ?=
 =?utf-8?B?ZVBzMTcxUXhRU1hEZW5IODhEL3U0UU04b1ppeExQWjZZNlJLdHc3eDVPQ0J3?=
 =?utf-8?B?UXB6RUtjOGhQemRtc0hTZFZabStVUlZOVjVrRHdvR1NXVWpzSGJQMGp5dy9J?=
 =?utf-8?B?SmYxQTQ5RXZZVFZSdGl5ejIvRS9nanhUdGxuZjY1Y3llVWxmU25VSE9QYmpm?=
 =?utf-8?B?Q0tMU1ViVk1YSGlkTXJCNW1LS2Y0YjQvcnV2ZkxHMVE4U1R2S1E5MTRRUkxV?=
 =?utf-8?B?eS9TalVJU1piZ0pFODlDQ0lJYXBMK1I4ZzFGcWZiY2k0OVNvd3BjWmxHdGVN?=
 =?utf-8?B?UkltMlpZOFpaQW4xbVJXSW96em5FU284ZkdHTjh3eHREUE44aXYrZGFiWGtQ?=
 =?utf-8?B?eDRXcTJ2ejcvSEQ4dWU2NnJCajZzU1NDUVNmNDFIdU5Rb2hjTTFybEJ6RnNG?=
 =?utf-8?B?cHlENkRxRmNIaXV5MFcvQzV6bjdkYXA3bklYVnNFdUdFSnB6Z3R4Z28zQ1ds?=
 =?utf-8?B?ZU5jYVM4QWplVGVWWjFNeFphT3c2aGVid1hTSEJGLy9lQ0ZUaE1wWGZjMDlS?=
 =?utf-8?B?UTFyOG5JSWdVRU5FRW42OWlBVmIzdTc0MllJaUdSZjIxZFU5OERyOUowUzdi?=
 =?utf-8?B?UUZxd0hySTlQb0ZWenIwVEZsWWljM1BVaFEvYmlZT3VkbVFuc053SXFWVHhk?=
 =?utf-8?B?VHZUQUZQdnEyQVhscU1iaXNXMTgyVVE2MjEwQ0x3WmhwcWY5YVFZOHFoY0l3?=
 =?utf-8?B?L0JBaS9IMnJsQXptVXl5K0w0Rkg2N2JiU0M5akMrQm44VDJ3RjhtZ1ZYRlJ5?=
 =?utf-8?B?K0hqNmlrUDB3UVJLeEF5NXFmcWljQXpGSHlNNStYSVgwSFFudjE5b1NSR241?=
 =?utf-8?B?NEdHUm5lY2Q3OG1Hb2EzQnVJSlRWMksyQjFKc0FKZUlFQmIzTUM3L1k1dndj?=
 =?utf-8?B?dVNYZURFOGk5eDl4aUJwaXB5Wm9OdmxCRnFsTzRaZG9pK2UycDZKa2xCUllm?=
 =?utf-8?B?T25RcDI2NnhVeCtrb20wME5FTTdPWHBTSUZjd0RCMjA2cytvWUxSWFhBV0JQ?=
 =?utf-8?B?SUY5alBqbDJnUmVYS0Q4TXZ3YUJsLzZ5UEZlVEl6VytlUEhVY0RhbDZKeEQ3?=
 =?utf-8?B?emJrc2FxRUVNcElYbFJuK3BNQ1lRNU1QYVhzdmk5dm94TGJHWmp1azZRdHZt?=
 =?utf-8?B?M1kyQTRQVUc4UkdoMTRvendvTkd3V29aVTlnRFlBZzNGMHZFTFpXeHY5d3Rm?=
 =?utf-8?B?SGc5QmJWWHZjSGhHY3B4RktrTnRxYmpUWlUxMCtrSWFBKzVhc1pLVnFGQ3g3?=
 =?utf-8?B?aWlLd3ptQSsyYjI4bnFQVER1ZHBXQmgraklYWEUwSnNQNmpLWFVrL3RSbi9t?=
 =?utf-8?B?eGUvL1BpeEpmbUpJRTZoUkN1RTJkdHNYTVZRYXVPcFJzUUQzLzBob0ZpNWl1?=
 =?utf-8?B?ZUtudXJwemlwREtSRzVxaHhiVVFkc0tUVjZ6d0VMMys5RWIrZzFyRUxjM1Fj?=
 =?utf-8?B?eVI3b21jOC91YmZsak1sY29SMzJxMy9iUnoxbTF0K0hyUXN4d1ZPV3Q1OVd0?=
 =?utf-8?B?Zjl0Kzd1dFNIaVhzNE5vU09oRlVHbmhYdGFBazFkY1lOV2RtYi9YVGNPNjh1?=
 =?utf-8?B?ODVpVDArbnZpaDhFZ0FkeFJTRmpqT3dpNlVDMWZSSjFaOGJNUUQvVjVGK0ha?=
 =?utf-8?B?ZFBLeXRoQkxjY3NZSVZoaGlRRk1vUXhtWEd5c095RkpFejM2cUxzKzByTlNH?=
 =?utf-8?B?TEJBeFlWRjJWZkVRME9qQSswS2FFZzZSL2IwUllZOU9pR2JIc3FXMERXcVBO?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dWNmTGtVbDBDTTNYdVVsRXlNK1lrbjdvNHBzL2NmeCs5TlJGOWwwWGJXRjdY?=
 =?utf-8?B?Smpxb25RSDV2YkdRNFdYNDFaWkdmYnJNSXNzRlUrVUdUTmJrTldDQ2xOSDFY?=
 =?utf-8?B?MG9TdElvOE02dUJXYlRkNVRvcjNxOVlBb0JVMElVOWtTQmQxRU5SMjJZdGtN?=
 =?utf-8?B?REcrcTVSZWxBTjg0bGhtcDVDL0EySU91UTJBd2ZaUmthdXkvR2JMMlNIeDVP?=
 =?utf-8?B?dVExbjBKWmJMQkVYVGxBV01aN0hmZjc2WFR5MjNBUGgxaWprVjdxSVNrL0R4?=
 =?utf-8?B?a3U5aTFNcHQvRHZpbG1XcUtuRU51VkZzK1VoRnVrMEZkNmczVUVYS0ZGOHJJ?=
 =?utf-8?B?Q00yanFwL2FqNy9VbCtpZ0NkNWhUeFNrL3ZjSVEvVjloeit5WjFUZE5GQk1l?=
 =?utf-8?B?YzZxNWx1NGZ1cjd5dlBaRDg2alZvTnFhSTBtdko4M04vL21VK1pDM3ljNnpH?=
 =?utf-8?B?KzROalhlSDhBZlpycS8rdUJLWHBSS1BxVEJ4QysxU1lnb2w4Wm5HNW9ueVUw?=
 =?utf-8?B?UFd2TGROM3VGc29rQW1FL3BIUktqelY2ZHJZcmNpbU1oTlB6OTR2cVJLNWxV?=
 =?utf-8?B?VlRydUh3VmZPbTV0dWpnZTlTbFg3OE80aXBsd3B3NjZKOEFZSHkzdmtmT1Zm?=
 =?utf-8?B?WExGcHIxQjVVZTd4cWJMVzRNYjYzY1RLbjNIdGFuNWc1NEdWYnVZZnNLTUQv?=
 =?utf-8?B?Si93ZWVDMDRQYWdPbnFCM3NKMWlFWHJmeHZSRGU4aGdGSmIxNzlNY2xqMWVr?=
 =?utf-8?B?S09XY1BFZUFtek1iWFBuWVQ3aVl1dXdHUFF2b09SWHlsMXVQT2hTNnh6bG5j?=
 =?utf-8?B?OXlmRm1zOGF5K1VWajdrbW15eExSNEhyQ3dWQ2NZMUcwUmZwUmZtSGhmWUIr?=
 =?utf-8?B?SzNjWjQ4SEdmbzBMdlc1aFloR3lmdVZ1emxwNTlsTnRHRGZ2R1lqV2VTZHYy?=
 =?utf-8?B?OVZmMUpueGpDZGQ2SmhURU84QWc1eGRQZXliU0FaUGxJRHFTRDM2dkJQSjlU?=
 =?utf-8?B?V1lab052bHpZZ3lhRlhyVklKemNFcEVVVkhoalpibXFmUDhMRlJHTEQyT3JQ?=
 =?utf-8?B?VFFSTnB3a0FlNzQxRlY2eFpaQXE5aEVUa2FDd2VyaHlPVDlGcjBrZDRXUDFw?=
 =?utf-8?B?VGM4ZXV0ZDlBQjNPQTJ4VzQ5TFZnYXdRNy9YUzZYZWRRR3U3VEt2V3lXamlq?=
 =?utf-8?B?cENLR01pVlVWRnNXcDh6L2VwMHc0aU03dmlmNDlldlF3SDlCOGM5TEo1TlVz?=
 =?utf-8?B?cDFpaGlUZ25YeEVKUDRhR0RFMjhZTy8wQlpHczdoeFozWGJMemJBejNtZWZN?=
 =?utf-8?Q?B7Y7Hll9rNiRC2xYokpByBiM+Sl8NwCOU5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d67f9b0-0c42-4ad7-b4cb-08da7bb4b0f6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 16:15:22.1352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2ne/9Rs5qDZ/vtHPMCi4kH9ErZUQNtiV6krey5JIIKn4NrpyPOdZcC3hA1F6eTYE+SDNmmJRpB6YBLWPvY3QWB3hjj+Jeffcq27iPRweuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110054
X-Proofpoint-GUID: GudMS4QUdtZqvItVk3DjpOOtzS98rDwo
X-Proofpoint-ORIG-GUID: GudMS4QUdtZqvItVk3DjpOOtzS98rDwo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/11/22 4:56 AM, Martin Wilck wrote:
>> It could change how 0x04/0x0a is handled because it uses NEEDS_RETRY.
>> However, scsi_dh_alua uses REQ_FAILFAST_DEV so we do not retry in
>> scsi_noretry_cmd like before.
> 
> Not quite following you here - alua_check_sense() is called for any
> command, not just those submitted from the ALUA code.

Ah, I thought you had mentioned alua above because of your alua_rtpg
example. Above I was saying that there was no behavior change for your
alua_rtpg example because it uses REQ_FAILFAST_DEV.


>> 2. Instead of trying to make it general for all scsi_execute_users,
>> we can
>> add SCMD bits for specific cases like DID_TIME_OUT or a SCMD bit that
>> tells
>> scsi_noretry_cmd to not always fail passthrough commands just because
>> they
>> are passthrough. It would work the opposite of the FASTFAIL bits
>> where instead
>> of failing fast, we retry.
>>
>> I think because the cases scsi_noretry_cmd is used for are really
>> specific cases
>> (scsi_decide_disposition sees NEEDS_RETRY, retries < allowed, and
>> REQ_FAILFAST_DEV
>> is not set) that might not be very useful. 
> 
> I don't think it's _that_ speficic. (retries < allowed) is the default
> case, at least for the first failure. REQ_FAILFAST_DEV has very few
> users except for the device handlers, and NEEDS_RETRY is a rather
> frequently used disposition.
I'm saying it's really specific because we only hit this code
path that is causing issues when scsi_check_sense returns NEEDS_RETRY.
There's 5 in there and one in scsi_dh_alua. 4 of them are UAs.

Compared to all the sense errors that we check for in the
scsi_execute callers and including all the times they do a retry for
all errors the 5 cases in scsi_check_sense seemed really specific.

Let me send a patch for this type of design because in the other mail
Christoph was asking for more details. I originally started going that
route so it won't be too much trouble to do a RFC so we can get an
idea of what it will look like.


