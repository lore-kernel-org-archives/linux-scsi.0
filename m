Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F1AECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 19:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiINTSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 15:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiINTSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 15:18:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBFD80F55;
        Wed, 14 Sep 2022 12:18:50 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28EJDloi023963;
        Wed, 14 Sep 2022 19:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=GPmZbr97xzNlsQK8kZYBUdQqD0koDVV+SSbfvdQqzLM=;
 b=OOx6U7U6f0RgQOqTFKAlZ6hwYxwuTr5tnNMNTjzxOSp9lUqRmK81kJZ/7D9fL21bFmT5
 Y/0cLLyHTZFIAETX6Q97pDcuQ1syixbZ5Mgtt4L5DVyVw6WDlGB1hL4g5J5bcyNLITdA
 RnlCUjfaU2LDSpIATtqrfVBx1onKTMVb0bwlGV9aDaQuc/ZTYh8EXJHs5OthZKxT0+S5
 0qopDh/aAjR8MRd7r7841myYn/7dPXBmhYcR0DaCWsFVVSc/ImtittzRq5wifK8FQbhk
 hnjT5yLT3CtFWgafTsmWBhEDMUf+tANidmufqqq8K2zExhLJAp/r1xLlyO2G6tyTUVe4 gw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jjxydua9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Sep 2022 19:18:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28EIvhbH006515;
        Wed, 14 Sep 2022 19:18:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jjy2bc7be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Sep 2022 19:18:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5tcu2nxPkpwkIQLUZTfAO0dpeYzcY8Vus2x+X6J32mcjbUSyfis/U/+heuVxlPz5vEWgUFa5DbN3kYOvGEuS+iRphVtgyCQ7wkD3TpFqaZo51GkMvOqbePKuWYAx1ZUQcGBmBAJ9zeTvfFOg3jKeNTy7neaZyOpYZuPI8H9slgaBSmNDm2K3Xye1sLd7+cyDayGnMUSkRldtI/CQukgofPfn7ccS4bQKD5X8yrHCjowcEBVEU9xTo1rK/84oRtk3WLlHu2HK3MyJX0woKxAP5Cd2atY5eg7UEuLlaNjiYE9awTUDx4oH4mgYDqm+KpQhnVxZE7jqNBmc2nCxnTvfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPmZbr97xzNlsQK8kZYBUdQqD0koDVV+SSbfvdQqzLM=;
 b=Ubq32MXjySyNJmrkUguP485C1ehR79BU3+2BrGitphm40QnWHYENxLLGLouKi4Kjm+LJeMYQw2qB9cbRjMvrXJJZrpSFUhuvryJPcEhaQ1SFZDjH+PxZ0RQfX3yR9ZrGDKuQ1f0OoEz7uwkrOcLpCcHZcccc9xZiy+7PJ+eu5ECVb+NR/sjfyDpogOYKzrphntYw3E4+30N20a7K665oViCa6NYnAj7EQSdjTuZza7S6EztnC6LZwptmCqX7TNrh8oAq64dgkn26tZupeXRUvGfH01lTf1AmXZIihLMGOdrpbFRjP+SrXPPBpBcn7qgy+GvA0bV9pRYF87pfvwGZ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPmZbr97xzNlsQK8kZYBUdQqD0koDVV+SSbfvdQqzLM=;
 b=WRO2bSas8egkmTHn4sxJs3R+r2AMCnCMDULFzC11Cay88yPRUr23JBaupbdyQTqQVBynfeZtsyzUDeVlQjKLnkPlBFoYq4l33Ynjg0Tqdh2L4lnEKR5d2ufXXKwXmvK1WkUSvCUpqfpF9Y5AclEBonr9/H+Kb9R8VsHzT5l6T/A=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4218.namprd10.prod.outlook.com (2603:10b6:5:222::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Wed, 14 Sep 2022 19:18:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 19:18:42 +0000
Message-ID: <82d31d9d-700c-d961-d284-a5a117487adc@oracle.com>
Date:   Wed, 14 Sep 2022 14:18:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] scsi: target: alua: do not report emtpy port group
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220912125457.22573-1-d.bogdanov@yadro.com>
 <92f6024a-7898-e281-099a-c79b67fecafe@oracle.com>
 <20220912214521.GF9218@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220912214521.GF9218@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR05CA0026.namprd05.prod.outlook.com (2603:10b6:610::39)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM6PR10MB4218:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ba45c06-3270-406f-9413-08da9685ef6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtWqve2nDe+i6aSLFuwxwAVZkhg04jbClQ8jyIqANxPJSosmIH1tkjbDX5O6QfaRIKrqLeYo4FwI+avaFqmBNmdYq6aznlR/zOdHtWaqImASogVS38iOdiBCK3ir5mxKdHTM6bLnnXBhh0Z5McmETWiPQ5yhuS0doHWcbzRmaQKNAa9/qe45voebQEtIT0eWVP6u0VzzC964n1Rg8iNEs/cyMk2OqcKg+aRGXbv5NM8NfrQM1yty7bZ4NPz676xAcmrZSFedcLj+aac2QgMi6V+jOZE8yNwouGXjrhfZl6H4bdNHf7QLOwUK9Gis0E+1cYMHwombO2V0RoWX6h+JnLVRDL+bC1OGU3TMAMg5hQok7mtGDy5tBaZLAOODAb38SWy1c9hZCwlA3UsFPkEnJQsD22YGmdwc5e5ej+WHVzE8OViT1uiEtRdsoPn+wY3naFpNbuSljLI4NyPnIM0qVam18oRSCvafBbcbpQ7bo+DMo1xHHw1jXDCWM7PGqZGeX3TnhzBFQLKolpGoffzg2+HWvC6wvWCwCe93FWmaHPBn3z2in82O/eAhCsX1EdNvayvDGAnCB3+tPVClxYhJZ6cgrb4skA5TzRgIW5QO9Apsc/GGvhCt09/n/zWQSzqmP6OpiyRPtYTuneSuw0Kzock7KcPCHVqDM5u4AAo6o+ffYfG2Aw329GX3bokJB0VPUe6A/xVWlZkIi9N1RkQHOFj+nZeHDOI3fLqpUzweR3djW37cYOO+WxYv3jjryimAUrUakOqPW40rAlteJazO0+NBlh/gFCwa/Bg6Z66fenY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(376002)(39860400002)(346002)(451199015)(8936002)(31696002)(6486002)(86362001)(316002)(53546011)(41300700001)(4326008)(36756003)(478600001)(54906003)(83380400001)(31686004)(38100700002)(6916009)(66556008)(186003)(6506007)(6512007)(2616005)(66946007)(5660300002)(26005)(8676002)(66476007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2kxNUh3c0ZTWjRJNk1ZLzdYeFU1OHdoMnMrUktwT3NTdW54bytUelVOOVI1?=
 =?utf-8?B?dzVNQkgrMGwwQUNPbXAyamxsc01jRUZRbkFibXQyMkhVQ3g5TFNTTXA4RHdx?=
 =?utf-8?B?VzZmV3RwcUZyeGtQb1VJMDEzRDJOLzJ5YW1XM09BaFFkTjdyTUFWWUMzMkcr?=
 =?utf-8?B?aXhhcHhJeXpXNVJQZC8wYjFqV3V2UzdxbElMMDNsUlFPSU5oclUyODJNZnNU?=
 =?utf-8?B?MzBMZ0hteXZ0M290M3F3Rm41UTFJam9xY05LZDlOQ0ZKclRDNEdEYllmQy9z?=
 =?utf-8?B?ZTV3dDBGajJxcnBmci8xWXhGUGVwK0J5Ym4raTRIdjcwWE5PbldoUFlVWXNK?=
 =?utf-8?B?L1RNZW92SnM2bm95Tk9uTlJ5YlVKTnB3NmJEdUZ2NGc1eGg2aURiQ2h2V2kx?=
 =?utf-8?B?SUpkVzhodS9vVE9pY3NlZllaSHpEVE1mT1BqTDcyUmNObW5xbVlTWjROM056?=
 =?utf-8?B?bVBWdWYzNm9QYlBQQUQvYjZvamQxOE53bjErSGNLR2xCeWY4SjFKQXp1WVhS?=
 =?utf-8?B?VGN3MlVyRnVnZUE0WDZ6M0JCVk9jK0JsNDQzQnZCWXByTjRvTThicU1HRmJX?=
 =?utf-8?B?ZFJGVjA4UExIWEV3YUtIaTNobEdZZjEwU0hORXZyS2duaHc0SW5JalpHemUr?=
 =?utf-8?B?NXcrWUswQzliMTVWQmpVTithQVh1dzZlcFdsS0xiQy9UUVlYb1hDR3dmK0x0?=
 =?utf-8?B?V1NmV0dBWVJGa0ZSdnltcFBGNGFXdnB3S1A1UHB1UlMxeGdHOHNSTm1YZlla?=
 =?utf-8?B?Z1hyOW1FcC9UVkJmSGlFaWtpdnNScXZoTkdFTFM4RkEzczFJN3N6b1d1MzBx?=
 =?utf-8?B?Lzd3cDhlUnZkRDJZZmQ4TU80ZnJtYlZVc2ZNYXpjc2pZQTJWVDNMaHp1VWxS?=
 =?utf-8?B?R2JyTUV0MWgyRFBVSEpZTkEzb0tqTG94TDd4ZFhQS1hnWEhlOW1QSGt6MlBV?=
 =?utf-8?B?OTRlZFBVQm9JTUpxcjBxTHRsWklNSVk2N3VvUjRMNHNFeFl5TmtENjl3KzYr?=
 =?utf-8?B?YTV4VENsbnhLVHpVY2lERWk3TGpLcS9jTjhLYnNlMmRjK1hWMEVhUzBLbWI1?=
 =?utf-8?B?Q3NzWThsWENBTEhTazVidktBSVMvM1gzNUg0VElTKzVoY0p6Q2hNN3p0d1Bs?=
 =?utf-8?B?OGVQcnlnZkZWQm8xN3VITkNSWHFOQldVcEhPbE52b2F3S1hrTi8yOWFZcDdl?=
 =?utf-8?B?Rjc4a0F4bHY0YkhxWFI5Mmg3MFQ5ZWQ3OGJ2OS83UjNCcjhqMVdnVXNJWDl6?=
 =?utf-8?B?SEJYSHAxU0ZwSnNwYXIvVlM5L0ZWT1g5UHR0VFRpY0IyY1Z1V1g2VHZUcEtW?=
 =?utf-8?B?VlMyUUNPb3NKR3Q4MzFlaFpvQndXVTlaOUxFajNRTFRVUlUzQzR5TlE3YWsw?=
 =?utf-8?B?b1pNb0syUmN4QkxBck5DQVdmRFBEbWlad2J6S0ovMmRIdDNHbjc1Z1pOdGVY?=
 =?utf-8?B?Ums1NG9hMkh5NE0rVDA0U05WWkExc2V5NExMaUdFTTdrQ1poV21Ba2dkMUE2?=
 =?utf-8?B?ZVM0azZFR0NnUmhqLzVTVFlNOTQ5dnpybUlpbHNoSTZKOUdyS09qR3lTOEl1?=
 =?utf-8?B?MVk0TDN1K29TWTlMeE5vdG8vTG5VNVE0U001ZDZtOGdhNjJ2cnQyb0pnOE1M?=
 =?utf-8?B?cEVCSTJhTUJpZVR0TFFxQlhsRmdadnJySnJ6eERtUmt4RTlDQTJxQ3NaKy9K?=
 =?utf-8?B?VGFDNnlzenBLYWNxbmYyNVZIRWpobi9UWUlTcmtSS3lUaDRoeHhNbGZpbDl0?=
 =?utf-8?B?RURMNk05RmhIUkVtMHVOTFVST3h6dTZ2ZWJwZGNCRmVWWUVncGsvM3FxNWNP?=
 =?utf-8?B?YzcrcVFndUY4SUZqWDdDYkg4bHFZL01GTnBVUGtXMWNnbjhVSWcvZkRjSHVu?=
 =?utf-8?B?Tm9rdEtNQ0o2THMzdzdUTGdQRzQ3Q1VwZXc1dWlGT2RjRGJteXJ6M3BRT1gv?=
 =?utf-8?B?Q1BhVDVsNU1rWmtPRVpNRU9JWUg4VmNhV21KN0wreFpOeDFQVnA1a3ViOU8z?=
 =?utf-8?B?MXhocFozaDhIbGtvYllRMXh3NUYxS0dzaXlkeFFZM2ZISmxIRDQwc1lqRENj?=
 =?utf-8?B?NDJJMGxGWmtRU2ZTUlZKNGtHR3JDMVNtUmxyb2ZEM0o0VUo0emEyZVVDN1hu?=
 =?utf-8?B?SDhNcUs4VWc3Y2tlbzIxRnpaUDZkbzE3WVpLbEFoOGpvK0N6R2N6eXkyWC9k?=
 =?utf-8?B?TVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba45c06-3270-406f-9413-08da9685ef6e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 19:18:42.0196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qp5b7PbV7SwrSEk1AfEkQEj9lJk4B8E14Ltjr/TzB9zYE4n9fRZybnKJqpuHBBIRf7ArHQSomyPsV61WRMrPVCYDAzKoiZLe+QfilNJWLfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_09,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140094
X-Proofpoint-ORIG-GUID: Aagi1R5k9zpFfTm0NzDbe3o-4-R18ZqA
X-Proofpoint-GUID: Aagi1R5k9zpFfTm0NzDbe3o-4-R18ZqA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/22 4:45 PM, Dmitry Bogdanov wrote:
>> Remember how ESX used to send a RTPG to one port and expect that it got
>> every group and that the state info was all in sync (basically opposite
>> if what's in the spec now)?
>>
>> The spec and ESX were updated, but I don't know if other OSs did this and
>> if/when everyone was updated. Do you know this info? Are the old ESX versions
>> that worked like that end of life?
> ESXi is kinda a pain. But fortunately it has nothing to do with that
> patch 😄

I didn't get why that is. How do you set up a distributed/cluster/HA target? I'm
probably missing that part.

Software drivers like iscsi I get, but for HW drivers I didn't see how you do it.

For example, if you have 2 systems/nodes running LIO which each export the same
device via 1 port each where one is active/optimized and the other is standby and you
are using qla2xxx, then on the local node would you create 2 groups:

[root@ol8n4 alua]# pwd
/sys/kernel/config/target/core/iblock_0/device0/alua

[root@ol8n4 alua]# ls
default_tg_pt_gp  local  remote

Then under the mapped lun:

[root@ol8n4 lun_0]# pwd
/sys/kernel/config/target/..../tpgt_1/lun/lun_0

in the alua_tg_pt_gp file you set that to local. That would then have tg_pt_gp_members
set, but remote would not.

Before your patch, windows and ESX could do a RTPG to just one port/path and we would
return the default, local and remote groups. We don't want the default group, but we
wanted the local and remote one returned. With your patch we only return the the local
one now. I wasn't sure how that works for drivers like qla2xxx.

For iscsi, you could just mirror the remote node locally, so you would have a second
tpg:

[root@ol8n4 lun_0]# pwd
/sys/kernel/config/target/..../tpgt_2/lun/lun_0

and in there set alua_tg_pt_gp to remote. Your patch works fine for that because both
groups then have tg_pt_gp_members set so if the OS just does a RTPG to one path/port
you get all the groups.

