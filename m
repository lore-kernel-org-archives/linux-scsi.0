Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380C7C04FDE
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLIKGI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLIKGD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:06:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3999163B81
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:06:02 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97neLE007737;
        Fri, 9 Dec 2022 10:05:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=a7rWixKiyuUMSsp+6XeHV2sDL3kONWu8fjerXtjFdis=;
 b=o/EsHuh/PYU+D72hDWcCDDVuxs5Ws+FrIL8AmwYxvgeOtbXQfzqKM/YG+mxI0f202BvE
 XwlKwzeLpqVJ0IAKlDEeEcSxJlzgKs3L1/s24Fvn8wZSn8Z7CS1mJFq4waGTQ7+fHQ/a
 1bbycl7sCiGvqkOSItSr7FySb9eeDtc6M7uZoIxQZPz18ShoKbtObkP8xxBswz18+iLa
 0L6+Ue9mYCcI0bko/CJr68X0EZymWXyM4+VhbecN5XydqHHxrv4lgh+1JgYzZ9einHZd
 WGOZ78J++Rif5w1VJS/nYTAohNfjeFpVwkSRuagbm8qaa5EhY2aiEwpWFLFGs7CwboX/ qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauduvqr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:05:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B98Lt2E008386;
        Fri, 9 Dec 2022 10:05:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa62750v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljFhqFeGjTO6EFINRp+W5GujfzcSaUfC7BKxhuZyUHZ06zsn1yhONzcWv+Y6y+ZxTbmbO/BrivquWpBynBJqxlC9XSm14qfoC/ClZuMPtXKVt8Vu4qhJXlZjv6JKs5m56xu1XO9c3nhqXvicUDmWeESj2osZcAZ29n4kEifQobLjB4yTj61Ek0fPfSTg69FeoLCdxGae0cZkGz8Y+zfjSfoMqHt547q/drIakrOny2o2LS/OVJR7ihUVJ3naQkhDMrudOm5XbtYJYdiSgYjN+rhcUoSVOPXogfJrrIItUuxlFxI2KJSwsjoHi8o4n+nxl6ko+zaPQpT3nS40JQKvhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7rWixKiyuUMSsp+6XeHV2sDL3kONWu8fjerXtjFdis=;
 b=H+iNhYfdiQLWrmDbj9hHu4APVMQbV0KzNWw9KyQWz62ZD7Z+kUfl2au4UATTamr5pZlcDfm0dPey5XXKndOZWY6VY4lvwYOHspc/bXIHlQblqXS56vjn8mDehYk7Z5jYSRzoVqeu60cUdTo7ClN+pI9ciDR8H7VOCmz8uYWoiKZq9MOnF9if7hDWuPWj/Cknod77LXnpuH03fuEtp/++4fJij3mlw+bXTtPxMFZhBlVd5hDnhBby32NyUapH9VkgZdNO6kRJFg4YCDMI9Pf+j27SNSxiyhl3wIARjTQRRAPyMBSEMK3MyMhwH3rdr+O0npA3x2Bk6UabWXE8TQSCDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7rWixKiyuUMSsp+6XeHV2sDL3kONWu8fjerXtjFdis=;
 b=R3izxUAWnSMyYOPiCHZxVslT9ZOUAdozWRI34rfvZCBEJhPgXF8WF3NAnk5ILtqlK3QtNOlIy3Xa5evv8Yq1USC9iGFZ5FGvzaOj0F8/ZaUniCGYDamQrKH18u+fvhGODZ2FB1jmhO40yqzEpADeh3v2oh89IK24extc8Zm2nw8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5135.namprd10.prod.outlook.com (2603:10b6:5:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 10:05:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:05:50 +0000
Message-ID: <b96ac0a3-d7d3-a184-64c1-6b8849096fc5@oracle.com>
Date:   Fri, 9 Dec 2022 10:05:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 06/15] scsi: core: Convert to scsi_execute_args/cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-7-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0164.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5135:EE_
X-MS-Office365-Filtering-Correlation-Id: af7c698b-82d5-49f0-38d4-08dad9ccf2e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dqdoZIj4gdBPP7G4OPOMFEkhLbDEIY3auB9G0uZi0hetrfFhKXU2M2W/N5ZD+O4d7dPVSHTtlOiNciNKisuTc6MuJlQfJoSCf4f43jpbPam5iedeXtT8SgNWnwa5ITo2Eo3lK//4/llmYx+EbcQMoB4CvXxGz3C7c9oh9V0cu7r2xlu4QAacyjeR/PXhzZG97IilkmyGzFwkasI7TAtjr6OydtPDPZJCT2vYGDNpBhjbUXqO0sZQHy3P5KLAw7E8PS9V5Ex6Qnr+Ymr63zpe6RwDPNXMmF8yuQUwoM7cSo/VvikPTwQ2jVpX7yu+1UFs/PRiLiENNi5TaPlNSK1jAViMBS34KmzvRozTlfc7IFpP24jvsSsvZzTRf2rsM+OynBUVFnKvFT/omK4KjhHsXFS8/4PUoya5hMOLdQOJcUmJIO52EVeJrOydRjtOTH8Qzo2ihGeqIC51eZOXRUHWTMmkMy2CciCbr18ym3cu6kNGjiibZHVL6FlOwnbWfxTj2VknwbGQnXs2odpdvr4Vms7V7YFXyvMFvR8qn/Kt06go7h8xMfT7wNbanqGmoALjsIIqs6doAHrYYj41m6eSekmwXiuh19QrAFb6sBQwvTGtwpU3tMahliDgkcxkq/gLReHmwF1nFJliK30BWf0DuN25fSvTvzNW4k5BWnEObXH76Mun/UqQTXgKtZUbMZKTV+L0CXC+NN3686MyOM+DOEDn42fDHiuHThFF8q2opzg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199015)(31686004)(86362001)(31696002)(6486002)(53546011)(38100700002)(36916002)(478600001)(26005)(41300700001)(8936002)(6512007)(66476007)(8676002)(6666004)(316002)(66556008)(66946007)(2906002)(186003)(2616005)(558084003)(36756003)(6506007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0VlYWlxS1FGcGJkWWdtMFlhaXdqQVNPa2JNaVFUSUU0RzNsL29iSnQyNUl1?=
 =?utf-8?B?ZjJMTVc1NkpLSzZlcEk5Ym81QnRLZmluUWorWW9DUldWNkNwYjVrUmFhTUtq?=
 =?utf-8?B?ejlTQlk1OVM3Mm9IS1A0aU1DMnVGZllEaVhHWlhObVp5bW9qZFUxZERQUjZp?=
 =?utf-8?B?Qnp1bzBMUU9zWXJSWkQ1alB0TFBiNU9PQjJaYW85RFlEL0ZCaWRPbUVycTNW?=
 =?utf-8?B?dnVuMi82UTk3WEdlLzdYYkRDT2tEVnJnWW4wVTV3Q0lQM1pKOVRhenpJRjlG?=
 =?utf-8?B?RVRjNGZNRllwYmcrOTZ1RG1zSE45TXZFVzg4cjl1akNlcHE0OXd0RHY0YVJU?=
 =?utf-8?B?UzBHeGNoRXJFYzI1ZVlJaVV4VURSWkxBVTkremZNVm8zK2svUVRNMUZINlhS?=
 =?utf-8?B?dWVzek9uaHRnODF6a0ZML045VmFGMEN3bStReUNrdFdtRzc2Wll6RnU5M0pm?=
 =?utf-8?B?NFplZk9lQy9hUlJhaUk2UkhEVHNNS2h0V2U5WGxkNGFWaGtIQzN3dVhSMGFC?=
 =?utf-8?B?a1lUNkZGKzh0bFB4blk2cnNXcVlTNHRic25DREZtT29wUHZTWldLWC9TdnYy?=
 =?utf-8?B?YVY1UkxlTjhPRTlmckVsbjhINlg0SzFZR3Jxc014NGQ1d01qZG9nenRScEFF?=
 =?utf-8?B?ZXhsbUFvYlVSOEZXM2FpamZNV2phdUxScExUdXlkaGNINWhwWWMwWXNNSzdr?=
 =?utf-8?B?dURMVDRydit4SEgzaVd4NlZMcVBhZU0zSTR1SFlObXB3R1YyUGRROUNuREw3?=
 =?utf-8?B?Y1F5c3BwbFRuTXg0VUFrUW5aUWp5cmZaOUVXMEZ4THZHUVd4c1F3WC9keXhh?=
 =?utf-8?B?Y3BwTFI3TWhXTGRBR1JyQkVuVGViOGZIelY3WjdaUytBUnpDS3ZLNjFicG5M?=
 =?utf-8?B?UjhQOHY4OXZaRjN1cVVDSHFzM1RGM2IyV0NMVUFSNlUyR0xwU2dwQ29KanpR?=
 =?utf-8?B?M1IyODFnY0Z6eGY2c2pMZ0llQTMybkp2TWdYaGF3dzRkbHhoRlRoWlc0WGwz?=
 =?utf-8?B?RDhaZ2tjeWs3aG00TzBJUC8xMDJsRXJINFJxNENzUy9ib3kwTXluNFQvMWhB?=
 =?utf-8?B?SXpUM0J5dklnSlp2dUd4S2R0WFhNcUwyZXAvOUZOSEovWE9LTTRQRjRpOVNm?=
 =?utf-8?B?d0JadDBJbC84QjdETVlmRHUzMGI3aE1tWUp1bXFGcVRLU0F4NSt6V0NnN1Fk?=
 =?utf-8?B?YlkyRzJvWlViSmhQZUQ3dktwckVyNGpFbnN5Nk5YOFNZM29MU1QyMUZTUmdR?=
 =?utf-8?B?NFdmMk8yTmFEc1pNQ0lkTmZRWTJKUGMzT3NPaHlvZnZYNFdvUGVXREpNRThF?=
 =?utf-8?B?UXhXSW03VGN2UlBOOEFDVlRoMGJyanNZMGJnM0JscXVLcDBZbzQ4VWFwaUNo?=
 =?utf-8?B?NUVpNGlHRlFybFl1ajFvUHgzcWJvT0ZkRFZsSk5QR3dMYmdJa212NUtWRnIx?=
 =?utf-8?B?UGRlNTdmV245bVVJRFhZcncyNmxid0NFQXYrYS91QjlIbThHazdvc1ZrOUta?=
 =?utf-8?B?OVcvNHdiZGtnTkNDSTBESlozRUhvdU5wTndxTEZJTXdRMmphdkpGRzhWM2JL?=
 =?utf-8?B?QUFKQjhUU0FCa24vdUhtS2ZFbHg4eWpDclBrNjJ0R2pZYVI5T24rcVM3dlNt?=
 =?utf-8?B?am5rVEdWWVJoRDFoZDdzRkNzbGxkVlB5NFVMbWlTeEREejYvWTBlNk53Rlps?=
 =?utf-8?B?SThmU29HelJ3V0Vhczl4V25nUENic2QwTHorWXFpNVRXdStxVy9jOTV3QkNo?=
 =?utf-8?B?UVE0L0F1T2Q2ZGxpV1l6L0JnaXZBUXlPY1lWOUR1ck05VjVrMWlZUFRXUW8z?=
 =?utf-8?B?eVovdVpwN2dmLzZXTWxKa1RNYmRqcCtDazdYRDM2VFpRbE5ZeE1ZcWlJM2dM?=
 =?utf-8?B?YzZSeHl6b0JHY3J6NEYzL3ZialA3R0pjVTVIMktNdXBuM2V4ZThTc0Radnc2?=
 =?utf-8?B?NkJNa3ZGOUZLVkd5Q2Vudm1qMFo0dVp4NjNtckI0UFdWMlhVMnBUWUlGdEt4?=
 =?utf-8?B?Y1lhZTZaTDl1ck1CYys0VzhiY2hEUnA2bHI4NlNTcGNzTm02RkNWc3hkcHZU?=
 =?utf-8?B?NzVJUEtOUTIzbERaRXFNOEY4c3FMaTZXcmZkMDczWVdpTEo5dEE2K3JFaUlz?=
 =?utf-8?B?bWNad2o4N2hwN1hpc0VkTG92eGVwd042K2h2YnppMEg5aHJCdHFYc3hKbHJV?=
 =?utf-8?B?eWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7c698b-82d5-49f0-38d4-08dad9ccf2e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:05:50.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkqyBPxvi2opMkZtiiDqjNAGZx+cce4+zYHwRGYKsRQFBO9Uvg3WXqBrmKjWNBV7GOOStL9gFF8/7s9hBxW2TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-ORIG-GUID: -28M-OvpLMzz7CtqEyNlTDu-LNw7Xyml
X-Proofpoint-GUID: -28M-OvpLMzz7CtqEyNlTDu-LNw7Xyml
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert scsi-ml to
> scsi_execute_args/cmd.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> ---

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>
