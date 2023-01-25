Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEF4C54EAA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 17:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbjAYRS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 12:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjAYRSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 12:18:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA09B46C;
        Wed, 25 Jan 2023 09:18:40 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PFNksO030139;
        Wed, 25 Jan 2023 17:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=TfWiLvG1Vz9iUSyYQ3V7jkPGlT+0XrdMI4eYb8ECW4A=;
 b=09l5WOlWaU3fzDmTPCV8XC70bYMckat6GtvEjFOoxtC/Zu4h/aCr8H/QlQOV7ZssWHop
 17BAyoJv/AJhntBxnkQqkgFeb4JiW7M8ht0qszEu8isNvwKEcWDQoAXWVEDN/PK9ua2x
 7swfhWOQC6zAoWOZKlfAoE1nqcov78EqYByaMWgYNRog11bpTX5mV1EHyBKDPhseQXhc
 me9AVcDhAdvGs4TC/WB8GFqgMobaVjiqOkYENmLC2+z3LyeZKbyhDZ3C4jtcq1UU7GQD
 fTUuzhruffyIV+esRgjN+pk+6um/LrmmKi26LVjAAUT+KNRAbvzN7K5AseeStpUtrLIh yw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u30jtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 17:18:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30PGGVqC025075;
        Wed, 25 Jan 2023 17:18:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gdp0ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 17:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaRWiYJ9dFHyj6mtVoLCECYhVNf5UEN212Q2Fgn4sRb7AxEMd/Wonl9OlJaYeRirQUnpuHqtiP5nvmG3ifyY63nj/xizOkWF9yVm+zqfAM4w0hg7vd1HDVUiVLAgdgEQegxilA3qpbZtDO9nHoAPYHZ/6rCqjl3zOHhyVnZiD1Xk8q0lorokTEK1tRyB5jJJ2xLtM6V5aqMpDvrL42hBtIX/Lef6b091t3kIO9sq9WuqcmR837hded2jdIEW+wZc69OokL04nc4tJpbQwW9417GQYpfvcWj2A2tDv/+cnVhKRLEofACY4pCE4KRrPlMtXjFcJo0SuJXZweaBNieg4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfWiLvG1Vz9iUSyYQ3V7jkPGlT+0XrdMI4eYb8ECW4A=;
 b=bdZfNtL0NB1MmQL6WgzHs7H0BkLjlgvc2VNo+5C8Uae4u8Rh2zJtymqpaGwjjY4PRpDZYiU8C33Lrv3yoNQbesWnIJoKsKO+QqvyjO1BlSG+GKQIMHL0E7dvG/a+OMaBm66EE/6z2sMq5jvZ7gUIGMiUK6jxwGEctN5VodJ4fpjo/i6SNqCUs2A7MveGHMLR/wyvtkKXeMfufvpbVS37hL0Ke30R9mXwnrSdgJz5H2sN6xgoKTJc1gJ0IlWdQsCv4uiWZcNJsZ3dILhB5Xw32u3un1jiJJXaDhuoJTMoCXyHZD7u/d/ZJxjmZFmVhhmwtmAUMo81a86jekrof0x7Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfWiLvG1Vz9iUSyYQ3V7jkPGlT+0XrdMI4eYb8ECW4A=;
 b=Gz/ps+5H4yK9ybqM4VSqVTLWbQilPsoTkKWNyPVnHwvZie0BurzGNXcjMhVlL9DCsDDI5aZTWMLiVSSAfioTeSLK3yHFPOeaLyI6XfodD6J++82pDNrsBovLCPZSpTJpJhFf7iGotFbsoaBtB4WQWyr+Ws2nKUgV5k49DAoLWW0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4895.namprd10.prod.outlook.com (2603:10b6:5:3a7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.20; Wed, 25 Jan 2023 17:18:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.020; Wed, 25 Jan 2023
 17:18:34 +0000
Message-ID: <478beda7-df98-d925-bfac-2856984c12d7@oracle.com>
Date:   Wed, 25 Jan 2023 11:18:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] target: iscs: reject cmd in closed session
From:   michael.christie@oracle.com
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Forza <forza@tnonline.net>, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20230125083309.24678-1-d.bogdanov@yadro.com>
 <20230125083309.24678-2-d.bogdanov@yadro.com>
 <825571ca-4687-4b5c-971f-b9e13efb152d@oracle.com>
Content-Language: en-US
In-Reply-To: <825571ca-4687-4b5c-971f-b9e13efb152d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0344.namprd03.prod.outlook.com
 (2603:10b6:610:11a::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB4895:EE_
X-MS-Office365-Filtering-Correlation-Id: fb403979-6ba2-4e02-04d0-08dafef83058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9wFshMvsVSNRdpU81NY1Bwq1DrDnU4/valNzXbIqVu2DZLFKVU9MXcN/ZZvs2yF5tIExOC9Q/9urdPnM8VkPUF+ATovh9r3nCOoVx3VW5JYTmvB71g6Y7l8FXQWJqgXD7RsSh4uK+1KtcSuaNLi/FUgoBhsS/D3g4tbqqwvH06HJAAaCnIaqmVrrvHi9qwelkTWXmrSkBIFBAm0GEDR+s4XKuQvjJ82F9e73Jm+I1UVfT1b03x9PcEXS4j56qZu+DedG5ngijzZSx6gUpl2Xpfuj7Mx5MI8dCaZqUiDBez+s3EAKWR5WMhWReCGXO2FSdjO2PXSTUvWjCn+LoNxNWQoBCQIyf5msJd6tDmFoX3eWfLb9KSzS4coBrZQqdixLQREPnvOGUkUIBPtFUYmHDKlDCKUxyc8OsTahX56r0HJlhyFdErLtMPX5/Ks/l+zyHtFILTZyUr5Ed668rzO/DF4uTQ0TABBwADzL/2hF5/YUW9/u1jlP2Ca1Lpy4uu8FFxWQ0+UxIe+cmclqkrZz+Hy9DtGVUwqrILBGEB4u38OnSOx1ov0tVTvQPlMxsxSrTNTjAaPm9TnfYUtBaLgbFaEUecFZ6kd3Uw8+BWD8L3Z7856iBJcGqjrr8+YaxOxGdWB6j6r5VWZVdEnPqsVcKCpketWqXzTUxTUSzTTlDRsFZMOaQ7GUpUzCZVbsgKHiIS6CygqaH8dkVYjud5ATBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(346002)(39860400002)(396003)(451199018)(2616005)(53546011)(6512007)(186003)(9686003)(26005)(6506007)(6486002)(478600001)(66476007)(316002)(110136005)(66556008)(66946007)(31686004)(83380400001)(8676002)(4326008)(41300700001)(5660300002)(8936002)(2906002)(38100700002)(31696002)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlF1QS9VT21pVE5hZ0VVZ2EzbVgzQjJEWkFuL3JVU1JNMjVGaTBONnFyVld1?=
 =?utf-8?B?RE80ekkrcjBDNnZxdHNFL2lndGUzWFp6VXRoYUNCakFLNHJqNXF6THhTWjFx?=
 =?utf-8?B?RHJscjBRYWZTQ25kakhJOFlMT3V3L0NuYWZvaXFSSEJuekpUZ0pkK203d1R2?=
 =?utf-8?B?R09aMlFtdlhWeFdwN1I4anhoeU9jbEFIaENGc3I1UE5LSk1RMExMd2k3ZVBR?=
 =?utf-8?B?UkxrM29jM3RlWXU2ZTJBNXRHQ0ZKbE93cDh0OU1iZFVzWk1xbjhkdk9xbjlT?=
 =?utf-8?B?ekZncmF1MXc3c0QxekkwdjJZMU9mcDNHM001OGtHYXZ5SC9TRXNpUFMvbW5x?=
 =?utf-8?B?ODZqM2RERUdWVjAyREFkdHRkaWdlRVRTang5UWJMemd6UmU4S2Rma0xrOWJ0?=
 =?utf-8?B?bXdiektINmsyQ3B1TlljMFFjN3llNDJpUUk3Zm9URUcwOWxvTmpybk5DNG1i?=
 =?utf-8?B?U3puVFJqNHFpckkxdkxlTHhmMjkzemRyMUtNcSs2TjZ0blFZTEU5SDZISDRa?=
 =?utf-8?B?cWdqTUF0MkkrNG1WVlJuMjluaWhvR1JYNmdrQU1vR1VMSDJRWW0vU1loL0lF?=
 =?utf-8?B?dERUVm4zclRDaHlpbWxtdnNsRTdzcVhRUmhxMFpQSkRyMU5wRStOdVpZekNn?=
 =?utf-8?B?LzkwaTBZRHg3YWRrUDc5M3pUdXc5c200TnpMT1VpZDVCWnJ0aXF0ZTB3dldv?=
 =?utf-8?B?VjBlUk9VclNEN3orQXNzalNnMDgrb1RmajZTeWpFc1dtR0dzUnVKcm96bVhW?=
 =?utf-8?B?TlIvTk5CMnNrdzVkZHk0V0JNck1OQ2RhYzYvaWE2TVB3S29xSFN6d0l1bW0r?=
 =?utf-8?B?aDB0UytPUW5BWVZRb2dicVo1enZFNGxwMEFHZ0M5OG9QV2VtZTF0aEUxTWtL?=
 =?utf-8?B?VDIxSzl5aFNLZDhZWithMTBaSUtkdFBzcXF3Z0xDV0hQbk4xdlFNamdhZ2xm?=
 =?utf-8?B?U0toSk5lOVlIU1ZhS1A0MXMyOFF6TEpaamF3eVFqN1FLeElYMkJpWXdzUk1Q?=
 =?utf-8?B?R2lHYlQzVGkwUW1xeTlFOTZ3TWw4VDNDVUJXRE9Tbld3eVROeVI2VVZCSnV1?=
 =?utf-8?B?V3RtcFRtSXM5aHRxTnVJM0pGQ2g3cS9TUnZMM29mUXJjL3ZXaTJvZXo5K2Nv?=
 =?utf-8?B?Yi82bWh5K1htRW92VHFyeE9ELytUMmlzUUcyR0Mxd2JWdytnakxyN0p1cXlS?=
 =?utf-8?B?Nm5Tb05RN0NSRFNvMTBJQi9DYUlnamw4Q1N1TzZZdmtGWUN6a25vK2U4RkEr?=
 =?utf-8?B?UElLN3RKc3owNnlhOGt1Qlp1NXVEZUZTT3F1Q1NKMHBzS0dicmJ2K3cxaWQw?=
 =?utf-8?B?UG5nMUdDMHhvRXZFNk9rbG9xeFVGQWZpZmp3VzlmTitNZ3E0eDlhbU9ZSUdv?=
 =?utf-8?B?ODdWU1d1MHUxdUtoNExxTWRBaTZCS1JBaFM3YVN5U2paSXFXbERwRVAxUWZ1?=
 =?utf-8?B?bWFmSW5OWGZqbTRrd1RVVEFPdk15dlpIWXhWY3hQMGRCRHgxT3FkQUlhRDZI?=
 =?utf-8?B?MjNCVnRpdXg3dEVrQjh4a1ZJYXBlSHRqeG94THl2Nk1NQjZZak1FeGQ5T1JQ?=
 =?utf-8?B?SVpFb3ZHR0FYbUNST1p3TE9Id2JjbFI1dTZVbWtMV2s1MXgxa0Vid0hYSmEx?=
 =?utf-8?B?SUZ2cFp5NlhyMWdxVGNyY0Z1Qkg3eTdkN2VKaGRwSWpjaGNKNXAxSkJLZytG?=
 =?utf-8?B?ZWpacVU2NmM5K2dmQ29WOEIwdDFmcFNBVkhwRzZjTDVqTWp3TDRWcGpVaUNH?=
 =?utf-8?B?RWhDTnRDU21aNWMvaHhENEpTb3U1UTJNR3l0cHArMjhka1N3V0ZtL0hWM2U4?=
 =?utf-8?B?dWNJQU1LTEludm9qekREcExaNmlTOTQwU2xSYWRpTlVvZ2dTQmlmVUh0bUh6?=
 =?utf-8?B?MWUvRkw1WWEzVk9KMHVqWTMvOEJMZGNlc3piUXBLcTBKUDhyNWNHUjdmd2p3?=
 =?utf-8?B?NHpxOWgrZzFhSHVqeHJJblRwQVVUM01WcU5xY3Z4R1VvTDRPUTFxQk1hL2Er?=
 =?utf-8?B?SVpSVjB3S3V6Yzg3by9RTmhLblQwRytxc1RyeGQ2TnRjQWdPWUkrazljeldT?=
 =?utf-8?B?NTlJOWtvRExsU2FtZVdlQ0dQSW1PckQxa2ZFMS9ob25EQUpZZ2M1U2tHc0dD?=
 =?utf-8?B?RHV4NjlhUHo4UjZYMUd2MUFZb2hLUWQ2dW9SdmNVK3dVVjNvTmhsSUtYcFVM?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rj5QePlStmphAGSgkvvEDSpC+oztY8YQn2n8VnEu32ZRB8sQNrgTybQA7uBrHQ5K/chHU289GRbYzCi2Af1tHmp8KhBoWeVq9W4ch89S2OZDDpJvyIRgwTAzPj9H+WrbUMFudAdEPyPAOY4vZ1HlZHNU9Wit6dG43lwvNVOOcGrj2TeKb+VTDtUzSyYXNpxYFVFzSSYAMtISpJBHd+yPnw0IRCTEKZtvhW0MlbRFFKQqpifFyJi+B0HqczbFPbyKKVnLhQCpYWRocgN1U4IgtnB6zufs36yeteH1+JUBM+zc8unpeZYqP/g/1SxgCk4nBaAOyR6kWmuO+D3E1A2f6NNARccJa8OVokoXPLxaGbbzYYXgD0tdiaKYi11oVyqjEWU7BL2MC3r3zsPr2bkgNdYqzs7jG3WslMxrnF1eliGuoCNMXwUSgyX5r+W0f1CD0Wib/f1ESXpS7oJmCNyrdkoCXlqokfuoejpbfvsCnQR/jR/+Ihh+RJDvZOVNRSKMfJhi/5aLs7t/DmDh/2da27wl0nzRRif+Knr4H8NCdEmfY29C5lwULY+FkTC6LvSIcB578RJ1HCWFRQdBhtYMhhYfzFc+5qZnQTnn6XXwopbLeFkacsBMlmaB17Fl2F+tqA3eEWiF4lxeYfKmVFS8Alusso2UFeu8QLa4cmGaasM8MEtTPniTAxCYlMSkQUKrvcA9ZiUriWE+dgi8hqqA51T6iwXMJvyWjc9hkiLa1ZcTdG06O4GyQ62NbYQN563WHPJDwDuSHvwRSwUe6/1TaP7VFGMGkjXVOEJY0NuOXTu8MNrOPBSzhyfQ8ZJIxatT
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb403979-6ba2-4e02-04d0-08dafef83058
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 17:18:34.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ladHuDYs1SxupYiehr6OBcCDS48bzL7diLLRPfhWOLdB8Q/9L1tRX2DaXh7voXY1FiidIeFhK7g4T6WhwTU7m0cEQCLQkOj9KA8dBk/YW+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4895
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_11,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301250155
X-Proofpoint-GUID: RuU4FcqMRyU2oj83YgCz2nG6pOkerRS1
X-Proofpoint-ORIG-GUID: RuU4FcqMRyU2oj83YgCz2nG6pOkerRS1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 11:03 AM, Mike Christie wrote:
> On 1/25/23 02:33, Dmitry Bogdanov wrote:
>> Do not handle incoming commands if the session is already closed.
>>
>> That patch fixes the following stacktrace:
>>
>>  Decremented iSCSI connection count to 0 from node: iqn.1996-04.com.local:3
>>  TARGET_CORE[iSCSI]: Deregistered fabric_sess
>>  Moving to TARG_SESS_STATE_FREE.
>>  Released iSCSI session from node: iqn.1996-04.com.local:3
>>  Decremented number of active iSCSI Sessions on iSCSI TPG: 0 to 1
>>  rx_loop: 48, total_rx: 48, data: 48
>>  Got SCSI Command, ITT: 0x2000005d, CmdSN: 0x4a020000, ExpXferLen: 0, Length: 0, CID: 0
>> BUG: Kernel NULL pointer dereference on read at 0x00000000
>>   Faulting instruction address: 0xc008000000a9b574
>>   Oops: Kernel access of bad area, sig: 11 [#1]
>>   NIP [c008000000a9b574] transport_lookup_cmd_lun+0x37c/0x470 [target_core_mod]
>>   LR [c008000001017318] iscsit_setup_scsi_cmd+0x520/0x780 [iscsi_target_mod]
>> Call Trace:
>>  [c000000059e4fae0] [c000000059e4fb70] 0xc000000059e4fb70 (unreliable)
>>  [c000000059e4fb70] [c008000001017318] iscsit_setup_scsi_cmd+0x520/0x780 [iscsi_target_mod]
>>  [c000000059e4fc30] [c00800000101c448] iscsit_get_rx_pdu+0x720/0x11d0 [iscsi_target_mod]
>>  [c000000059e4fd60] [c00800000101ebc8] iscsi_target_rx_thread+0xb0/0x190 [iscsi_target_mod]
>>  [c000000059e4fdb0] [c00000000018c50c] kthread+0x19c/0x1b0
>>
>> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>> ---
>>  drivers/target/iscsi/iscsi_target.c | 8 ++++++--
>>  include/scsi/iscsi_proto.h          | 1 +
>>  2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index baf4da7bb3b4..f6008675dd3f 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -1199,7 +1199,9 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>>  		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
>>  		conn->cid);
>>  
>> -	target_get_sess_cmd(&cmd->se_cmd, true);
>> +	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
>> +		return iscsit_add_reject_cmd(cmd,
>> +				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
>>
> Did this require target_stop_session somewhere? I think this is a possible

Oh wait, if there is a use after free like below then iscsit_stop_session
won't help since we are trying to stop incoming commands from referencing
the se_session/iscsit_session. We would need to check something on the
iscsit_conn.

> use after free.
> 
> It seems like if we have logged the message:
> 
>>  Moving to TARG_SESS_STATE_FREE.
> 
> then we called:
> 
> transport_deregister_session -> transport_free_session
> 
> and freed the se_session.
> 
> So above if target_get_sess_cmd returns failure then we have run:
> 
> transport_free_session ->transport_uninit_session -> percpu_ref_exit
> 
> and transport_free_session could have done:
> 
> kmem_cache_free(se_sess_cache, se_sess)
> 
> by the time we run the code above and we are now accessing a freed
> se_session and iscsit_session.

