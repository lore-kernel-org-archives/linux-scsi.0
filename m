Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B34CCA486
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 15:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiGSPbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 11:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiGSPbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 11:31:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1CF58867;
        Tue, 19 Jul 2022 08:31:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JEwjYW003860;
        Tue, 19 Jul 2022 15:31:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=58p06qH+jaH5FDiKz0W4/rAJqfoO9hsvmT818qoVC9Q=;
 b=oOYbAuj6YAJjQV4rKplwWmFAbY+Y1hkSdhxBKi4uzecEBwdvNZH3WEClP3Fd5Yc45G/x
 2RT5nkB0Z/nt3B/w8D3AkM5pEjD8gviJuQTB7bblatI5Ltrt4AF4Yp3Hwx4unVudzX2y
 A/0ff8zzn/yURPykDFP8W31rBYlzKRsWVZCeMPQd6rK4ZUJhdDxcDeISvz5FOkCx5zf+
 l2+2aknk+ycLmBPtwyhjf01BI6WnjWkjw8eznmwME30ML6JdyUfQHRA2HcP0WROcd8jZ
 SYL0RcRtxsbyoce05iWPJIaX6jBiWARRXy/80FIIyW3FVJ4EfFhtkrP3EIJqfIqjUt/S VA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbmxs6t62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 15:31:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26JEQ1RE016650;
        Tue, 19 Jul 2022 15:31:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1emnph3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 15:31:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro7jIonvzIHU/QNlgGtoR9YqcjU8Vv4RGcv1tWlKU72hYMSMDnD6YZ7eA9YGmlJsfXS+G6AxJRVxfzFAYA+95sCcnaol27RAjdY8rrcaoL80fxU6kY3sxdKaLqg9iB/tAzBwF2ACPt9RKDKp3vBAlb7/ioIEkvh+e8CCdXxyIn+hgkcXx9/xCxvS9TglYQd76JYrRIhhUh2eStI1J/z20gMyaczmXGidhcXMZs+cAD8L+Y8mug2j0zzlDt1sf6Yo0J6+3dpz+qxAH4RhRpkueO+2KxqAUk4kObPlMlqk9adyjXORlUZ6NRwTpo8qxzVJ6ApIr+lS8ffY5ypltN4R2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58p06qH+jaH5FDiKz0W4/rAJqfoO9hsvmT818qoVC9Q=;
 b=ivVWFrefOdsaiFaQpw3e2A5dxEuQaCojfGmavqXknAtA/w992oEUE10z/TJjiguxlrh/NXJdSq1Z+RDkgdQgbIreoVxQuR/GVV1u4xFXMiKwBv4+2MAguJEsT8IMxfOJCcDDv69U1sNOdhE9jM6qb15+nMtvzf+u1kc/IVgDE4a6IxG44EFssHtYLl0YX6jFx8ALnSldiFkEFn8IdOI/e4OznHmo3b+ilGGpwphAKYO6mcCbYkwudZn0lrwzl0Kwep1LwqKGse3dztRULGiZ/0APhalXNejO7juUjEioFTVdPSROFLeyJMKX7MsrN3baEAOuRPtT3td9Ft138hW3pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58p06qH+jaH5FDiKz0W4/rAJqfoO9hsvmT818qoVC9Q=;
 b=gdWIMWkhLQVk8BEAVZ2entbX3cK9gqXtjpADrkGGyBthwwayBxcawy+cKLqHWkGDtQ6MPJu5Z3oWggHTiCIrLJB3mnzUqM2wlBUDxYTuIWWDvwQipt7Hj5jPXfVt2wzF5ELImza++83SSY0/5d+soB1rj5U99vL1I10sbLsrdbM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6242.namprd10.prod.outlook.com (2603:10b6:208:3a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 19 Jul
 2022 15:31:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.025; Tue, 19 Jul 2022
 15:31:34 +0000
Message-ID: <33b0ed4e-65ba-670a-8cb4-d95bd4006529@oracle.com>
Date:   Tue, 19 Jul 2022 10:31:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v2 1/4] target: Handle MI_REPORT_SUPPORTED_OPERATION_CODES
Content-Language: en-US
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>, linux-usb@vger.kernel.org
References: <cover.1658195608.git.Thinh.Nguyen@synopsys.com>
 <41806206e78812afe97101a11881f5a33092a93b.1658195608.git.Thinh.Nguyen@synopsys.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <41806206e78812afe97101a11881f5a33092a93b.1658195608.git.Thinh.Nguyen@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:930:1e::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20cdec53-fcb9-4c0b-5876-08da699bc2e8
X-MS-TrafficTypeDiagnostic: IA1PR10MB6242:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZeX4zFeUB3pQPd4pknfAzYBuDDPURYT9GLIksKFcLEdgVoBVkXhEmuMMO0RuOF2C47SGKIfaF0O6Z7kDH6I3l2R7YvExsNxyMRHqyV3Dnp+TjIDcwd5+AACrJeRCjr0LgMvCgAj9i1WDPMlqLOQikFvXCKxG91Yd2zktVVWgOM+fQ3P1cxzrz3mDWI9spVaMnApZq1Btw5idNRA+dFzWeQ9G1Bms3TrCMBPvLLc0yh1sOKuIZN7hRxCwj5WiRhh1VUHEnqONYn4sMdLNFP90dLcU3NkgzHvGf+mMJ+UBtF5Gynvt0MSLphONVXqH9xOFD/Nj+RZubFKpp3P1NEFNAzrDSB8xALS8rZO/RnLJsfEKr7dvRUMNg/Xs6XiV9ZVP20/vA9AlcohuqDdHxf6YNd6stYzwd8vwUch7PCn1vN/inR+h4Q417iJwinDXhRBz9OnU+C44gPOMW4vuAi9Hsu8SdcRkmDGWLHWN5Dj0WVxrsmeuO5CBFYtgOvGBKfon36bjQkxweTzF9e/leecbH8mTjDTCQgA7jDBtCcYyg+H/vTap78xjYxgSru7+E5Is/cO55WCqKR2XMi0qTrSB3vBxslP+oKit4n5YcXPFdfjdcxEhe3hATgNR0xz/JYXIPHokbduIcY06irgWGoVnxYhWZfcCqmSLsTFraO34Ng+EvkO0PEqsDKXGyzhWrfNozCsG9CQagkebqafS63o84/q2Ex8IiMox5/eNN/IkWblZEEx10vmZVGi2Ir2Uj8Yab7c65YEHwddg/764T3qkXtKina1iQqSvihSLnbZxk6feG2yrGMTKm/88TQlWandr8tjvsvBeOYokqirKyieRAu+6fmkbObN+OdbZEGrgbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(376002)(136003)(346002)(366004)(478600001)(6636002)(4326008)(316002)(6506007)(53546011)(41300700001)(4744005)(2616005)(110136005)(66946007)(6666004)(186003)(66556008)(5660300002)(45080400002)(8676002)(31696002)(2906002)(31686004)(26005)(966005)(66476007)(8936002)(36756003)(6512007)(38100700002)(6486002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlZyQWRxaExhTlV4OTBvcnVvMFNFeGpwcHM2ZjNyblBkSXdBVkxVazBIRFMx?=
 =?utf-8?B?cEx6Wk5BK2tVMUIrNFZYSmN2TlJYcVNSQkt4cGRJUytWcTN2REtHKzcyZ2Zo?=
 =?utf-8?B?VmJlTEtTcys1WXErTkZwRWxMeU5CRzQ3ZTdmZjNYbHV5OHduUFhweXo1cWUv?=
 =?utf-8?B?OWNiR1hKMEF5TC9SNTdpS3M2MUxHbVJ4OFJELzV0MGw3dEpXdmxkTkhMTFBt?=
 =?utf-8?B?YU0yRkNVaUNzMGJ5UnZZbzQyRzMxSGUwbXh3K1dFNG82NnF5a3RyT0wvbGZj?=
 =?utf-8?B?VjlaSGtWZ1VJK3FxTjk2U3d3UnpoWTRmZXFIRi9WYXlNTXFjdG5ab1RNYW5E?=
 =?utf-8?B?V2dWaW9RaWkycGVmQm0vSy95REhDMGk4Q0o4dXI4UE5odnZ0TGpFdzl4c05r?=
 =?utf-8?B?am9RV2dNL0Jac1R6ekJuOFFRMC9VaTZFVlA1eitXaU1rOWQwcVpKeGI2cjFz?=
 =?utf-8?B?SFVJZnh2dVFyNjl3VkNtbkZuVnN0NG1WUFhyZlN6d1FBVEVBZXcxY3JTeGta?=
 =?utf-8?B?L3JKMlNod1dGWkZDakpwamZHR0Y2ejlpQ2JPbDE1ZG1MOEZIeVJyd1pkSHg5?=
 =?utf-8?B?Y25TalJzSzIwNnZXdmZmUjdGTXRaczB4Y3p3ZWdhaWl1Vy9WU3dnOWRtek85?=
 =?utf-8?B?dE1RZ1c4UmV1bnlLd2lhc2FuNzVHRzZXWCtpem9BZ2hjemRMckUzV2VUd0xV?=
 =?utf-8?B?SzZmaEpHSlE3bUIzSUI5c1kyR3llaTYreTBTTU9CQWZsc2I1TlhCZkh2VHRT?=
 =?utf-8?B?Rlg5b0Z1dUZublNLQkJ2T3FjcEhyMkhqeFV4VzAwckw5bHN2dmllWjFhL2NE?=
 =?utf-8?B?WU5mSVV4Q2ZqVXhxcXRHKzR6Q2duTk9sOGhCSGhiY3dZWVJQd0JKYnQyUlJu?=
 =?utf-8?B?SkpHdUxsRG92MnV2WW1ZdVNldk1ydkVGNUt2QzVUSW5BRmFPU2doQWtpdGpP?=
 =?utf-8?B?NkxvSi9VMjBqQVhYaWNzUDNwNTk3YUpUWnZqYmhiQ3VTb240TXlQeGw4VndB?=
 =?utf-8?B?emJWZ1JmUDFkblVldWpDV0R0bWlsWmhCU2p1a0M4cnJoa0dmbFZOM0xQL2V6?=
 =?utf-8?B?LzNNeG1HQndFUE4rVVBIb29pRDg3NFNHVG9SUnRhMWFSNGdZejcvMDVZRWI5?=
 =?utf-8?B?Mnp6M3FMRU1aajg4bmg1TnUrNDV4U2JzRWRtN05VZXBEUGdNb0NXYzlUblkv?=
 =?utf-8?B?cnM0S1FwOWF0Y21zYXNhN241eG9lcnJad0xMZ0t6TDdMSUtGYW04MDJ5b0ty?=
 =?utf-8?B?eDFkb21WUWk1eFF1WWtEUU5lRzBMZ2pGWVh0SWNXcC9zVWlpVmFqQ0Z2Z3ZN?=
 =?utf-8?B?eHRWMzdlMlVRRHVrQkFpNHhFcnRaVndhWTFkcUs2Nm5yQ3pzTFNjNHVjQkFk?=
 =?utf-8?B?L1V2c1NLcm82YWdDSXp3VmRYLzNxeVJOcWJXazJ5U09aY3JUWEZEeWpSM282?=
 =?utf-8?B?L2NnQTZVTEJtUHJXd0hRWkR3MlJaT2R3UXhoNUFaQXd5QWF4VktQZjBrTVpO?=
 =?utf-8?B?RTlna2haMjBjMnF6RHFidXB3V3V0aVp2Q1Flems3SlNOT2ppcWNQU1hoRUxO?=
 =?utf-8?B?RXRnTWdwaFhTYkNDNUl6cUpVUklRUmd2T2t6UU0zbXYrZmVMK1lFcURUckhN?=
 =?utf-8?B?SzFZZ2oyR2VFdnZ5RU5kb1duaVBiQ0JkVkQvSmhQSlpyMjdCSW9QcnVoa2pD?=
 =?utf-8?B?MTl6NDJ6Wm8yZ2lZWGlqak01Wm1xOXE3VGtDWXZxWXRKMjRTREY1UWpub2Vs?=
 =?utf-8?B?YkJSQmVkdmxUaFRYV1hSYVZHM3Vka3VQSlpxUnBZaWJFYWFKUlRXenNtaFQ4?=
 =?utf-8?B?dWplVll6NnVaUkZtY2JBbUVxMmp3SUNwMlBqK1hpNm5NNS9LaEN0SkRsTE81?=
 =?utf-8?B?QnhibmdSaWpkRTBtR2xWcmZmam5UWTJtYVRvdWo3MHkwVmUwNlJ2VCttbGtD?=
 =?utf-8?B?TVlVdWZoeTR2aFJTZXdVVUsyYkJESWx2ZHZFMGw3N25paVpnWHg3VktrZTFk?=
 =?utf-8?B?OWx5N3lGeGFaS1FjT1FpaHZYR0NqL0Nlbng2NjY4WVVDZ1VlZFZrZlduc2J2?=
 =?utf-8?B?MVNWYVdDeldhYk1rTnU5NUJicy95VEhlQ3ZydW1NdHQ5N0MrLzVXSXJYQ3ZZ?=
 =?utf-8?B?c2d3ck9XZ1VhWmpLTldiSTd1QWdwUkltRkYxWHIxbTVaaG5KVXJxVWNVNWNx?=
 =?utf-8?B?QUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20cdec53-fcb9-4c0b-5876-08da699bc2e8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 15:31:33.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihv7po06sgsajM7Tb10GgjkGcQIZRHmEr34XRAobUqPN6EznE0PzT6KD9x8NUN7mjDixYvYs8MqpWTQRdMXWt1SdmmKh9+2+8yUIkliYNJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6242
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_04,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190064
X-Proofpoint-GUID: 27skiEdDDemE5-d5F25s7fvt0cytKyLb
X-Proofpoint-ORIG-GUID: 27skiEdDDemE5-d5F25s7fvt0cytKyLb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 9:07 PM, Thinh Nguyen wrote:
> Microsoft Windows checks for MI_REPORT_SUPPORTED_OPERATION_CODES. Let's
> handle this MAINTENANCE_IN command and report supported commands.
>
Let's concentrate on Dimitry's patchset for this:

https://lore.kernel.org/linux-scsi/20220718120117.4435-1-d.bogdanov@yadro.com/T/#t

It's complete and supports when users can enable/disable commands.
