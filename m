Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3D3CE7A8B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Sep 2023 20:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjIWUuJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Sep 2023 16:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjIWUuI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Sep 2023 16:50:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7A311B;
        Sat, 23 Sep 2023 13:50:01 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38NJmhBS002200;
        Sat, 23 Sep 2023 20:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=BZMbcmchRzUwm39aPO4DT15zSQemC2JtwUsL/VDwfdU=;
 b=PuV3S+Zb0lahrImMJYWfcqh7jK3V3Ltph6A8Btp6ju+ksFhd53IRyZn/+k9pWOnas/bP
 Lt8cpth3+71Rp1VT9hEEZFKlYvpNSkW03AN6G2VNnU1iYqqzWqeTAU65f8zlMgd/1VY3
 ABRXDr/g5RdDwGs7Z5djW9aYmA+u4hjDt/078L7smK6tgJ82IAvDKUwPdaPcTdql9Q8P
 MlCMfWxkDqZ3/nAxjn53CbOF71rCoaRS0ZYyaI8158w6qH6TGEI01J93IKMjTmekwjhD
 Lrr6HXlGZ/g+oAzF33PHYcN/aw08x4r9GE9EffXJ/mY5docwnzNhZBcoQAz56r2IYptE AA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pxbs9ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 20:49:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38NKjEkn030643;
        Sat, 23 Sep 2023 20:49:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf2jdvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 20:49:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gW64sfdsWFNq8gq2k0H4dMrBwqLW9uEM4pzl0nO2F+eGReNJ5oYrF281dap96bmC70QSKbuRlwrG/y77fOb6JJdgv12v3zWIG7EgwwbkKxCyXxvXBBYau31R5mg57qdsN1X0ThhxbGh6u9XJ4un2iIms54/ebGNmQFtmQ9/rT0YlydlI3pNEd0Kl+AqUInIkp+1IbjygI/pb2ZgDgyNV3ABMYw70jMk++apitAl+kksHZvWPkQDEz0TtrXK1qWAeTRcnd0NYD3BXdYDwc7oIJuvX1yT7Qive5vkLlOALNmEkJGI+qdZB4lPPoxn7tvxE5gFxWcCeR5BcSqAG2kv+eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZMbcmchRzUwm39aPO4DT15zSQemC2JtwUsL/VDwfdU=;
 b=U65e9RNStxO1CGVlNs6ZKallS6X0i60diGhtbH/BkEYLcqwpaXYc3Dt+76nIX4zX8HnERNPN5oS7GpoF/Q0VjZmj4jP8JMAC5mIDeYwYO/+f+ecs36K3m7cpsRBUlwNliJqZt4W15IH1DqCHGMRZP27cszFYuQI7X0w/7fBQ3jMbS8dsRVZkyw67qWgC7xhgsxYoPIv1ppevrNQkmDd+kshZU/kOvEUa0r9NQ53g8ebnyt9QtCHsaxSwFHVu0U5VBp1glgc+HXZVdD7T3VLzpMag9htNaNKzQsiY3cPmtoKVqXPVGn5EKs5/9rp8Vsl6c9F+FmYYSPPLyyuLReontQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZMbcmchRzUwm39aPO4DT15zSQemC2JtwUsL/VDwfdU=;
 b=YbFlxa6I66p4tPYaPBSh7+IqaSoNzHhzmuJulUzGscaoaS2hrSF+haiwrZiCqWR5LdWPcmQA+yUg1j8DAYiAInVFtgFV+ndDhn4HMyjmQJUKbsPa3kiy1NJY22pGUXuWArObmjt2olKaTz/BUH2FR2lGuDAMphZktdczS6st6cQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY8PR10MB7217.namprd10.prod.outlook.com (2603:10b6:930:71::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Sat, 23 Sep
 2023 20:49:56 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Sat, 23 Sep 2023
 20:49:56 +0000
Message-ID: <cda2ceb0-e397-7a35-991a-ba094f969aba@oracle.com>
Date:   Sat, 23 Sep 2023 15:49:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] scsi: target: fix deadlock by recursive locking
To:     Junxiao Bi <junxiao.bi@oracle.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org
References: <20230918225848.66463-1-junxiao.bi@oracle.com>
Content-Language: en-US
From:   michael.christie@oracle.com
In-Reply-To: <20230918225848.66463-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR18CA0028.namprd18.prod.outlook.com
 (2603:10b6:5:15b::41) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY8PR10MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: 25d490a5-ea15-4a92-1306-08dbbc76a4bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzedpWhKBGjQ5lrZbDTbnfqLsfSzVeoHqUcfhcsZBW71DNbs6NH39OHZRPEq12zME10YN3EFsc08MoCvSR/hq0lRIKSK0qHJ6kId00+3U++QNIMVwRlmMTSnkZw4humXJTWVZjx8sPRm2WDCJSnhZf6l+X/DXgnRFHQKxHhExWEjW76RHqDJjlHauMQgB5B58NR1QSZAIf0dKBrqEB3RsA6Y83OZPqhUgyuB5Fcoy4L03lqR/pJLcTckpT77P7WemvWBdK6wDyggLAFflaMiabJWB3aIR0aIcK+DZR2fXTycmm9t7yda6ZJR4qBdmqVax6uJInQSKc9HpaNAvxaDXMXmOFThZwEPFgHvMCw4tupJy9oYJOLp7o2BrQvKqTa8q3T3XrsOY60dSQa2z/pMyWKFo6zGOGkpciokuRtBy9iBOiiknHF17o3d/D0iHrtCxXJYKxCTe2aP1h5XY/XByq+1qeU31QXmREzuYDzF03gSxDjwIwWPF/UWh1ST9XhJq8QT+VEMO56MP7d0ykeLmeL5KF8is+gDykdD8PPtmgh3PVJmxcXlEZGN/loXZFVxjXM7kL944HcLUqGvQIdeu/OhGcZne+zDBo1hYO957opzb8SiA3TX8WuTgks1xUUE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(136003)(346002)(366004)(230922051799003)(186009)(451199024)(1800799009)(316002)(66556008)(66476007)(36756003)(41300700001)(66946007)(31696002)(86362001)(478600001)(6512007)(8676002)(5660300002)(8936002)(4326008)(83380400001)(9686003)(2906002)(31686004)(26005)(38100700002)(2616005)(53546011)(6486002)(6506007)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWxnVEREUVkvTm1tYjU4Z2lZc3FRZVcvU0pFT2R3Rk5EZHZMTjJJRUFnZmhq?=
 =?utf-8?B?ZEdIZ291djlQQ3MvL2xvODlNVGlmKzRyVEJEaHA0NTBNWVdXTkpzd1dLd3lM?=
 =?utf-8?B?VG0vWENpbjdqSEV1YVhydVg0di9jdzJFY0piR2FGMDZRNVRKb3Z2WVR3cy8y?=
 =?utf-8?B?VDFVQ29hZ1pnUjZqU0hkeVpPOWtiUlFxWWMxYUI3V0hSd3JDU09hTXdkUGdF?=
 =?utf-8?B?MFNPQ3RuQXU5UmJCTlBSWHRFR0x0UlNVWm1mV0JIM3JaYXRCbnh1MWRQVXBs?=
 =?utf-8?B?N1dtM2ViVWtWblFEMGYzR3QvNTlpY1QvUStKcjB6eUszOVZ0ajJ5ZUd2UHVu?=
 =?utf-8?B?Sys3UlQ0R3dudFJRRkJRRkdNUVkvU3ZncXlyVUd5UTFieW9NSFh4OVhvaDY1?=
 =?utf-8?B?cUtRQXE1VnFLS3NsVEVLZlZLUDhkb3hST3o4bnYwWXJ4RW5zNCtiaDdpaHVq?=
 =?utf-8?B?dXd4UldnendBQTg4TUJnU2ZCSU8wdVVGTkxKa1FRN015V01HUzBXY2dIK0xp?=
 =?utf-8?B?Qm81NXZrRndDbkg1RStrS0xOZVMybW5QTnBvcWdabmgrdG5PaHYyRHhDcVBK?=
 =?utf-8?B?dUxiYnlPTlJrU3JuZlJtcUNrNEg0Ny96WEpOU0lPSnBTczI1ODFhT2k4ckov?=
 =?utf-8?B?ZTlQL1Q2eGFoNHdUMzU0WmdFWTcwbGVTTEt6UGlseDk3WS9uMWd6MVc5RFZY?=
 =?utf-8?B?OWJzRFp1WHB4bk1qM0lrbXV2SjhJTFFCR3VIVFlpNGc3ZWtSQ1JZUCtqSzgx?=
 =?utf-8?B?OWNEWVlObWhuQktYRDZOU08ycDJrcU9jalFiN1FFTFczYmpiVnJKTWNnMWZ5?=
 =?utf-8?B?dUtrS01BTFUvczUzSENqVm5SbkVGS1BRby9LZnpKS1V1KzJudmtSeFdKWVpH?=
 =?utf-8?B?VVlRZ3B2U2dZNmYrMzEyL1NjdXRhYW9ZenNiblBwRzQrQjd0TDVLV1VyUGRl?=
 =?utf-8?B?cDJSQnZxWDF6blI5Q09YcXJ6eWhQOEhHUE82Wm9PNUJvMHRTWnEwTkNOckNm?=
 =?utf-8?B?VTM1Rm95NXJLRmVvOVlST2U2R2loOTkvSkx6WStTT290NkcrK1gzUDdyeHhK?=
 =?utf-8?B?c09GZ2QxZExydnd6Qmk3Z1VRak9tTmNsQ01sNXFUQ201RGRjTFdRVkZRTUtW?=
 =?utf-8?B?SnlBZW1pWlo5MnFIY1krUXBTa25lM1hyUmtyNUgwekM4ZFdHd1BJdlZvcFIz?=
 =?utf-8?B?SGNzM0t1SktyR1Z4U1Z4Ykt6bnhNanR3b3pBaEhNSzQ5TitJWkVaRUN6cFNK?=
 =?utf-8?B?UTgydkY3YWpkc2pXNXRhT2xGMUJ3alFCc2ZoQnRBK2poTlZDN0lENXNDRHF5?=
 =?utf-8?B?c201amhpU1VVb0FEQWlkTWV5blk5TzVpZHdMZG1FdVFYZkpnUU1TbDJYLy9N?=
 =?utf-8?B?SGQ4VkVLMWpSb1RvNHBBVzIyUUdRUnRHSUt0RFB0YndoVEtqQzRoNGkyL0JO?=
 =?utf-8?B?SWpPNG5ZTmFaaVNsczB3aDNjYldqVzFrRFBjVklXNlR1SURsQ2NmK2xuc3BG?=
 =?utf-8?B?QTh2bDhDYUhtOEVTM2ljTlNSNHdBVlRkRlZSUU9DWllXMlF0TW96KzBmV0tk?=
 =?utf-8?B?YlArbXdoSmZreURaN0ZEdkRhMzJYUTk1Q1JMTGF6T05YajZkYmRmdEVxc0FM?=
 =?utf-8?B?T3NaMTRLc3FtZE5JRlNSckUyOUpGa251OHNDQytSNFkvRXdJenlQalpWVFlm?=
 =?utf-8?B?blZGM0hLbUVWMkxsK2dVZlZQaFIxdTJiYWZnSjh5aExrUmo5dXhpOVp4MHBP?=
 =?utf-8?B?Zm5iS3VGM1BLSDRpenBQY0JmaThmTFNGNGJvTk0zUndpdnJZNXE5TXdDVFpq?=
 =?utf-8?B?Ylh3b1dhbUYwQTFpZFc3UlY3ZWxtNTArdWVkelBad1F6N2E2Q1FDbkNzTlNM?=
 =?utf-8?B?TTZMaHpuajRnQ21GWHZncm04c2E5bFZTd0laR0JRb1ZPQzExaTAwbXlCVTZS?=
 =?utf-8?B?ZHpLSFgrL3NxSGVKNm03eThvYmZRTjIzTE5EN291S3FCZDdNNmxUdHpzRUdB?=
 =?utf-8?B?eHlhZjA1M0pOSDRsaldiTDNkU3hoRm9uVS82NTlvb2dXSzFXQWc0WW1rTTdF?=
 =?utf-8?B?RWtuRXVHS1JvYUJkVys4YUJKbUVvWm81dkx1QUZZdE8zOWlxc1RIbERNSHZM?=
 =?utf-8?B?WEo5VEVRejdEdkhnb1pyVHF5b0wyaVZ5SlBXemdFOEs0K0g5YnZwTWNXTU15?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZeSpV7LUOUDxfT7kUo1toPvHXmZFnruaqJXbVijLe/OByYqhpMPw+73UNk7wro+68qjcjmfALJKq/xEAWbGnCrM8/S57jYBbpBhM5Eypt8MP8TscpbVYlLAWzWXiJaQdiWfKhjp/wgF8W48+0vZGUQd8yjJ0+ODmCHVdV4Eky8HYJRSlJj2LMqa431AxjsEE2P0GH3usYa3suESTwfEITew/SdkbKOimujzQzY5LHqe8zDTegJcNY+9m/Hh76kzLnZkA6Hteq2tfRsu/dTM2xartcRHlE0xTZYcqqNYmdsHmMzSluN4cFUoqaqUNq7xhjBc6q0YaPyxM0dZa/rpJ3g1xSBnz7Zz0nLQz2SmB73BXvSx7CqKoprv5X2mItMzWK3z1s3nkzfSHyS8gzqyWRwmrMk9JQs/03tmrY6AeBYp4OSCc++vTQ86sOqXOzzKtm6iI8RaEGrA6AfyAQgqPfK9z6N+ooaZCYR5Fg84S1XAMI2imUSuPIHT1JuaPffoUAywboetLEJTw8nRwSV+yC/qNVNieXvrD0GB0ippE3JFI4LXxjsJ0NlPIKzzqQ6Grlrvf9rRrTvmzMBZgmx7kQTFdBEGb710bVy7nApxt3uUUPelQKzFpJCSP9vjesbjc+Yww2onViZIZ6OoJ6ccm/2PVQjkM5jhBMfmw80cXMHxshdV1Syr1OGUCL6jwIhDBgvDXsVfktAJwposGGwprYjHnMRtfa+ruYHLpOoPPhNv38BsQuzLFpm/IOPA5qZ5dPMXaC/3+XU9q12s9dggg8aVc6x0MCnjCr2QhBlhWAMo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d490a5-ea15-4a92-1306-08dbbc76a4bd
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2023 20:49:56.2680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuCedLa3KfQodRj0fzlw+eVL85YagQB43sZ3LCHY38DiTglftSM20T5oqct/6neObcGx9Z+2acvuvAoBGUzEtHWRZki/98rltMRc622uowQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7217
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-23_18,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230180
X-Proofpoint-GUID: 0xBvkyxdx8qJz6Jtp5VefrvxrAQyZUFe
X-Proofpoint-ORIG-GUID: 0xBvkyxdx8qJz6Jtp5VefrvxrAQyZUFe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/18/23 5:58 PM, Junxiao Bi wrote:
> The following call trace shown a deadlock issue due to recursive locking
> of mutex "device_mutex" , first lock acquire in target_for_each_device()
> and second in target_free_device().
> 
>  PID: 148266   TASK: ffff8be21ffb5d00  CPU: 10   COMMAND: "iscsi_ttx"
>   #0 [ffffa2bfc9ec3b18] __schedule at ffffffffa8060e7f
>   #1 [ffffa2bfc9ec3ba0] schedule at ffffffffa8061224
>   #2 [ffffa2bfc9ec3bb8] schedule_preempt_disabled at ffffffffa80615ee
>   #3 [ffffa2bfc9ec3bc8] __mutex_lock at ffffffffa8062fd7
>   #4 [ffffa2bfc9ec3c40] __mutex_lock_slowpath at ffffffffa80631d3
>   #5 [ffffa2bfc9ec3c50] mutex_lock at ffffffffa806320c
>   #6 [ffffa2bfc9ec3c68] target_free_device at ffffffffc0935998 [target_core_mod]
>   #7 [ffffa2bfc9ec3c90] target_core_dev_release at ffffffffc092f975 [target_core_mod]
>   #8 [ffffa2bfc9ec3ca0] config_item_put at ffffffffa79d250f
>   #9 [ffffa2bfc9ec3cd0] config_item_put at ffffffffa79d2583
>  #10 [ffffa2bfc9ec3ce0] target_devices_idr_iter at ffffffffc0933f3a [target_core_mod]
>  #11 [ffffa2bfc9ec3d00] idr_for_each at ffffffffa803f6fc
>  #12 [ffffa2bfc9ec3d60] target_for_each_device at ffffffffc0935670 [target_core_mod]
>  #13 [ffffa2bfc9ec3d98] transport_deregister_session at ffffffffc0946408 [target_core_mod]
>  #14 [ffffa2bfc9ec3dc8] iscsit_close_session at ffffffffc09a44a6 [iscsi_target_mod]
>  #15 [ffffa2bfc9ec3df0] iscsit_close_connection at ffffffffc09a4a88 [iscsi_target_mod]
>  #16 [ffffa2bfc9ec3df8] finish_task_switch at ffffffffa76e5d07
>  #17 [ffffa2bfc9ec3e78] iscsit_take_action_for_connection_exit at ffffffffc0991c23 [iscsi_target_mod]
>  #18 [ffffa2bfc9ec3ea0] iscsi_target_tx_thread at ffffffffc09a403b [iscsi_target_mod]
>  #19 [ffffa2bfc9ec3f08] kthread at ffffffffa76d8080
>  #20 [ffffa2bfc9ec3f50] ret_from_fork at ffffffffa8200364
> 
> Fixes: 36d4cb460bcb ("scsi: target: Avoid that EXTENDED COPY commands trigger lock inversion")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  drivers/target/target_core_device.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index b7ac60f4a219..b6523d4b9259 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -843,7 +843,6 @@ sector_t target_to_linux_sector(struct se_device *dev, sector_t lb)
>  EXPORT_SYMBOL(target_to_linux_sector);
>  
>  struct devices_idr_iter {
> -	struct config_item *prev_item;
>  	int (*fn)(struct se_device *dev, void *data);
>  	void *data;
>  };
> @@ -853,11 +852,9 @@ static int target_devices_idr_iter(int id, void *p, void *data)
>  {
>  	struct devices_idr_iter *iter = data;
>  	struct se_device *dev = p;
> +	struct config_item *item;
>  	int ret;
>  
> -	config_item_put(iter->prev_item);

I can't see why we did that (I had reviewed/signed-off on the patch that added
the bug) and I don't see any reason why we would have needed it in the past.
Looks like idr_for_each would have handled it ok back then as well. So patch looks
ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

