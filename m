Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C512C43217
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Nov 2022 18:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKESg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Nov 2022 14:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKESg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Nov 2022 14:36:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8732611C2B;
        Sat,  5 Nov 2022 11:36:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A5Dlv1c017181;
        Sat, 5 Nov 2022 18:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BcnZeY+gLrwp/DPJ1z2ywrwMv4YRqg7xYwzW+POnP/Y=;
 b=VczbwtfYxqEZZD2RYB/9JX/GqOrB7LCM5ku86xeNZbsAt1EllrMJhvVfI6jGQso56Sew
 IM3ZRtJQbgqJzicj6ERqyKtnrWfHjuZzABtwkzXeh3T+0mqdBsSh5TmlLb7qV0XeUXqQ
 ZjILaclpAdSeu/4XaqCt+7KLVhJdGH9uGHsHgT/cpSVpTS+DhwWUFNUHSzTtOPokiej/
 zG/7fuPWmuyMoQ2qvGckQA4y9uYXr6YuAje6OMc2JPNWy6DN717Hbi1fDDrhdD/Swk2Y
 8YldCHQfQtyB2WiC8kp0/szlnnTGFAlrRu4sdXHHefaw39ul8U98FxlMsVKE+k1XkZ1L Xw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngregqnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Nov 2022 18:36:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A5BcZ35017496;
        Sat, 5 Nov 2022 18:36:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kne985d0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Nov 2022 18:36:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wzb3hFtTXcQZJuHHW38QANtR+Bt0XvU5S3L/dYTdpBWhRJ1BIwtbkxUXnbOLonClSrdNaDzHe3YMmX0st7PIDB6BbkMehVwAcA0ydxJPqmIndLjLO+s0evtU04KeTKyRgWfAGFgwEiXUFEVN4877/wXh3s2SiIGOStoAQsTuBS63ySeXiP2z6gtc8JLkxTSq4smVWXo2ESXnBQyIJUmB8D7UQn8aUNPc3ttVYXMfdW7khYzxsTD61je/Bn/gTnLps3zW77HsqM263Qy4hqfbJEMsAclrelNAK0VPbRItcLlX8YO9BVkM7l2rGPVVdjJMv4Z7+Tn9qz3yOqL0ns1Izg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcnZeY+gLrwp/DPJ1z2ywrwMv4YRqg7xYwzW+POnP/Y=;
 b=LoUE7BzsPbW/k2+luxSNiaVzBe1eT+PpsHvZh6lqAjGF294+0eYLZUGkgn0Bm10jZbr+Ol9hUzdTekrMm97MOAEdOM2Jo3xybyHxHCmYZ6RUdh27fVQpfymAExiMIlbDaRWMlqSq2xfqDr4c6OPumTy0UY4UU70sYMQsg7BEmgaPCIME6K23csZ17HNbcSmAbEA5zyIX0eHroTZN/GOq64FKP5PsGICONDN45+nD0OPIHkgm4kk4gpbJNquAVTRzM66UHHeO4YjaUQCvfv3mrw2d3biHPnO3jIO5u6Y+vYZbKfKX4d09E+uxjLHoQ8pLh/mmdxBHJidJuGD9nDupUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcnZeY+gLrwp/DPJ1z2ywrwMv4YRqg7xYwzW+POnP/Y=;
 b=aFoA2IqkcqgI4KBLnm5GyRcjEeqjgrOGiuMlAxmpqEisLjhyfwFdV2uUvopBRvV1iyA0wFU50kR46kCWMvmBj9qJA/JyfAzQ0EjKCZUClWrJmB1bRF+ZU4JnYcG5LX8+kLoMggjR6PseIcw6LQZ9Pj1sOIeyhsW/kQ15fUsdl0o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5372.namprd10.prod.outlook.com (2603:10b6:610:c2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Sat, 5 Nov 2022 18:36:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.025; Sat, 5 Nov 2022
 18:36:19 +0000
Message-ID: <7762a877-9a5f-4dee-6dfc-c2e1fcb8a66a@oracle.com>
Date:   Sat, 5 Nov 2022 13:36:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 12/19] block,nvme,scsi,dm: Add blk_status to pr_ops
 callouts
To:     Christoph Hellwig <hch@lst.de>
Cc:     bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-13-michael.christie@oracle.com>
 <20221030082020.GC4774@lst.de>
 <a7e447b5-b26e-7aa0-ab6a-3463b8497d26@oracle.com>
 <20221101101511.GA13304@lst.de>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221101101511.GA13304@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:610:11a::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5372:EE_
X-MS-Office365-Filtering-Correlation-Id: ac32dc75-c12f-4bc5-72b7-08dabf5ca199
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m3cCFyT45maPeZLcupO2a9DEOKPofV3WB4sFh3RmWsK9/NR5SQj92MwHZXTNoi2fToZ6GvzxEbTXrmDjYd8oSLPuipblLT675uVp40bBcwjdTCb9pbC7oC7X9ETxskQzOx2QfBPOPVCUC4baatkdT83llKj5crnXZTOCVwjFVuWkoQ+/K4aNcNL6P6881xQsoo8Ogoe1z9llpPvzbCsvCMaCYm9Y4xhOXLW3iEUNHHPVkPnsrlzfOrg/AHkWs8GAiOPUQbywAZMu8Hngg11AhQ/jJFoDS1X/pCXeBi6jcJ3Tl1Hmfn6pMWt/7AOHZ7HPXtvqgqHzfoKHfI8eXk6iuY9OdsCfzrp3Mo6Kq7gieNrpNKJcIptSBmyOuZUK5v0khBDjUBtv0mZRhFtudeNBOVR6M2gRS6Vn06EoyxmjjpXH3d4mNtpz9fhTJJPZ9SHG7XSyTWMg5BjQvhz2sWMzWRDIwE1Dwjk9euNBpvmDOSIC+JjurpW9x1jwaZx5FMiM5jPFDOBH004AlPr4QbbuEuIHXe6qzX587T18fA5eLrveBK0R/xepAcJVcT6IMF8rxBTb7SXspunHOZ+buWSN6wMjw8AYFXthYP6cuiTVkcB/W0k5aQR1LOeivIrVuba+T67RJPIW+rYd+JuA/s897L1gy0iqopWINTDEzS9wrXscsqK284lHiRNEQ/iRNRS1rDCrI4NOdlJmQBB1scw/BUNV0ZXhdLN6DidB/enu1QdkRK8onvwvtttV658Zfq51jbFG8w49PueECupzsy8waHATyMtC727XAccuLLYc+C4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199015)(83380400001)(31686004)(53546011)(36756003)(6486002)(30864003)(2906002)(38100700002)(31696002)(86362001)(2616005)(26005)(6916009)(186003)(6512007)(8936002)(8676002)(66476007)(316002)(478600001)(66946007)(4326008)(66556008)(5660300002)(7416002)(6506007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1NDTnI1bkFDK0pORmIzdGl4SFVYZkFyajR1K2VLM1ZIMk1rQTI4UFg1SktS?=
 =?utf-8?B?cExRbVhFdmRwSTA4ZHFYYWZOZTVuakNBSlhybjBnWmlJNERUNHlmTEVLMU5i?=
 =?utf-8?B?Y1JOQjlCbUZPbzZ0RGxXbnFLZExieGk4ZW01ZlpFOG1vMDBYS3R0L1Nhc0NZ?=
 =?utf-8?B?RWxhSlQ3WkZIWWJjY3p6SnFJZU1DTktzWEVqVVhkUitaK09zL1FVd0lKMCt6?=
 =?utf-8?B?S2dqMGcveGQwUmdIYk1pbXJacVplVlorRW5TMVRmQ3RKTEZuWXJiTmhGdWw1?=
 =?utf-8?B?TTNqSnQwNGJOTkhOU2xrblNqQkxGTEg5NkM5WURCdjVlaHpqQ2o3ZVdmTW5V?=
 =?utf-8?B?NWlZY3ZFakFoSjVtRGdrOU5QNllPNlN4cGkzVGpiVWV1QmhQUDRPVS8vbXA3?=
 =?utf-8?B?eEFBbDE0M1FHQWxiRkJjU0RlRHhPbFlURU5INDBEblpGOVo0Vmo1cTRvUkkz?=
 =?utf-8?B?NDhMMHBTc0I1c3d2UHpWV29qTmg4MUpYQlYyUXVQcDJHOXhYN3FXdXFHY09u?=
 =?utf-8?B?b1RPcHAyb3I1dXBlUFVYa0N6QWcxNThKZi8zSmYrNVA5TnRKK1Uvb0FJbGVY?=
 =?utf-8?B?Sk5VcE1IR2FvVXpTYjBwbWRsMXlGRG4ybWxTakxNMDdLMURuTDM4Z21KTEFq?=
 =?utf-8?B?eE0zS3dDNnYwdjlFT1BBdGdkQnNtYzZIRFVJamZZVkdQSkM3VHo3U3FneXVh?=
 =?utf-8?B?K1FIdURoVFJncENuRkszSHE0bTlyWU9RZ3VGMlkxb2wrd1p1bWw5OWhFYjNO?=
 =?utf-8?B?ZzNvaUNYZWxLY3Z4eHJFbVNwYk1MaEtQWVZjdlhKcGNEME9YUlREWmwxQ0Ri?=
 =?utf-8?B?YklPY2xnV2QzdE4zU0tmZ1JLOGF3VG1vdmk5YzhrWm5FNnduVWpmbVY1NW5X?=
 =?utf-8?B?Vmp3VUd2NG03YVg2S0NnOFdTZWlMcmpJaUc3eXA0M09rMXdZaDdlNENFWWRK?=
 =?utf-8?B?SWEyM2t5NTEzaUgreDFFQjl6WEp0ZkpDYWpURzNhcWNEcDhaUzhmczJ4d2Nq?=
 =?utf-8?B?MDZISk5xYSs4cFJHMkNwWU1JenNCQjdnN0hRUUZwOTdoL0dTRHl3eWpBemF2?=
 =?utf-8?B?RldYVmVrRzJINktlOWRwRmhDcUlEWFNaYjR5M0NHRjI3MEowTzh2L1pib0t5?=
 =?utf-8?B?Z3lDZWFkQ1p3WjYzN0hrSWhmYWN6UEtpUEFOVzcxeFJQdXRvWUdWOEtvUnM3?=
 =?utf-8?B?bHRTaDBoOUxRdTFnM2g1TlpBUW5CRXBCTGlaUTlUbWxLUkdCWFpKeGtwUUF0?=
 =?utf-8?B?YUFnTyt2WVNFRGh6NHJ0a21uZ0thM3lNTGQyTndKU2dJY1lVbTRCS0g0eFBG?=
 =?utf-8?B?UnkzZDdVS0xDdnZpcGdwQ2phclRtTTNsclhhdGkwVmJVUnd4SjlWSUVQSDVl?=
 =?utf-8?B?WDZpNDBHQU5NN0lGMHFsUEhDZnhseG9leXdPMU1UT0dhWnBwMVdKanRIQjZK?=
 =?utf-8?B?emN1NGlUbTJWTmxpQ29zTzJpS2oxSFRKT2pQTGpyMkVjb0lZWmttYmdHQVNr?=
 =?utf-8?B?VVg3V1Uzdk9SSGpFK09HUGpTYXBTT3lDNlFkc3RMNFRGMGwxK1liWlFnMTlB?=
 =?utf-8?B?ejB4Skh1VHRLd0VIenJEOXBtejVZMi9adUV3Sy9UaERhY3UwQ0NlWXlNQWtV?=
 =?utf-8?B?WWErb1grWXA4VTNlTkhXK3hDSnlaeTJsOTBqdEh2a1Q1eFllNkdOVEliNWsr?=
 =?utf-8?B?eUZCblRCQnZmWmd2U3g1WFpiVFZiRjZiVjdPVVFCOEdaTTA4bjlKdTM4YmFa?=
 =?utf-8?B?eDhHVGtMejYzRjRNZ2NSSzN3TmN5VVZWcEJlWUhCR1oyRmQ1aWI0UElITmhJ?=
 =?utf-8?B?dWhJWXR3czdYSkgxZ0c0dm0walNQcmI5SXRkQnVUT0YyV1UzWTY5b0daaHpI?=
 =?utf-8?B?K3pTT08wMkFqVW5zRmdUUGo3RHFEa1BHblRBMEE3V2ZLbHM0NUlCSDJtclV5?=
 =?utf-8?B?VHF6N3pNOTdFdTlhM3F4V3ZVazlHS1hJN3RpUUhTQUdRQ21sdGJMUmFzNXJY?=
 =?utf-8?B?d0orZlN1ZWt2aXlHMnFRNEZGZnZQcU1tT3ZRcUFGOVlYNEk3TWRGVitqSXQz?=
 =?utf-8?B?TzhOQkdHaG1CZHdUYm4vQkFRaVd0UW5VRTFQM05HN3VXLy9wMFVHWlVEK1ZF?=
 =?utf-8?B?Z1dud0NsYmUrZ1JxTmo2R3dzeUhwMUpQUlhlTTNmZUt4d0JUSjN6VWFQVUg0?=
 =?utf-8?B?YUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac32dc75-c12f-4bc5-72b7-08dabf5ca199
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2022 18:36:19.8712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2f2+sLf68YrvCJYFHhipk9hzcF5z4oKW5X+ekXMgapm7gkRereAqzVDh4R8RBXpnIcp2Y1c+c8jDOswY6IDkJRnQMcJW72Xh27u2Bh9GXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-05_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211050139
X-Proofpoint-ORIG-GUID: fkmgIeSLaBPG283gLLGJGWW0OrENtPkl
X-Proofpoint-GUID: fkmgIeSLaBPG283gLLGJGWW0OrENtPkl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/22 5:15 AM, Christoph Hellwig wrote:
> On Sun, Oct 30, 2022 at 06:05:35PM -0500, Mike Christie wrote:
>> The problem I hit is that in the ioctl code I then have to do:
>>
>> @@ -269,7 +270,14 @@ static int blkdev_pr_register(struct block_device *bdev,
>>  
>>  	if (reg.flags & ~PR_FL_IGNORE_KEY)
>>  		return -EOPNOTSUPP;
>> -	return ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
>> +	ret = ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
>> +	if (ret == -EBADE) {
>> +		if (bdev_is_nvme(bdev))
>> +			ret = NVME_SC_RESERVATION_CONFLICT;
>> +		else if (bdev_is_scsi(bdev)
>> +			ret = SAM_STAT_RESERVATION_CONFLICT;
>> +	}
>> +	return ret;
> 
> Eww.  We should have never leaked protocol specific values out to
> userspace.  This is an original bug I introduceѕ, so all blame is on me.
> 
> I suspect the right way to fix is is to keep the numeric value of
> SAM_STAT_RESERVATION_CONFLICT and give it a new constant exposed in
> the uapi header, assuming that SCSI is the thing people actually
> used the PR API for, and nvme was just an nice little add-on.
> 

Do you mean just doing this:

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 727123c611e6..6ac70514170d 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -72,12 +72,17 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
 static int nvme_send_pr_command(struct block_device *bdev,
 		struct nvme_command *c, void *data, unsigned int data_len)
 {
+	int ret;
+
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		return nvme_send_ns_head_pr_command(bdev, c, data, data_len);
+		ret = nvme_send_ns_head_pr_command(bdev, c, data, data_len);
 	else
-		return nvme_send_ns_pr_command(bdev->bd_disk->private_data, c,
-					       data, data_len);
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, c,
+					      data, data_len);
+	if (ret == NVME_SC_RESERVATION_CONFLICT)
+		ret = PR_STS_RESERVATION_CONFLICT;
+	return ret;
 }
 
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c0a614efcfce..c7621d8ffa51 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1840,7 +1840,8 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 	    scsi_sense_valid(&sshdr)) {
 		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
-	}
+	} else if (__get_status_byte(result) == SAM_STAT_RESERVATION_CONFLICT)
+		result = PR_STS_RESERVATION_CONFLICT;
 
 	return result;
 }
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index ccc78cbf1221..7a637f9e5b49 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -13,6 +13,15 @@ enum pr_type {
 	PR_EXCLUSIVE_ACCESS_ALL_REGS	= 6,
 };
 
+enum pr_status {
+	PR_STS_SUCCESS			= 0x0,
+	/*
+	 * The error codes are based on SCSI, because it was the primary user
+	 * and had userspace users.
+	 */
+	PR_STS_RESERVATION_CONFLICT	= 0x18,
+};
+
 struct pr_reservation {
 	__u64	key;
 	__u32	type;


---------------------------------------------------------------------------


Or we could add a new flag and make it nicer for the user in the future,
but also uglier for the drivers but a little less uglier than adding the
blk_sts field to the calls:



diff --git a/block/ioctl.c b/block/ioctl.c
index 60121e89052b..cae58f57ea13 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -269,7 +269,8 @@ static int blkdev_pr_register(struct block_device *bdev,
 
 	if (reg.flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
+	return ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags,
+				reg.flags & PR_FL_PR_STAT);
 }
 
 static int blkdev_pr_reserve(struct block_device *bdev,
@@ -287,7 +288,8 @@ static int blkdev_pr_reserve(struct block_device *bdev,
 
 	if (rsv.flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return ops->pr_reserve(bdev, rsv.key, rsv.type, rsv.flags);
+	return ops->pr_reserve(bdev, rsv.key, rsv.type, rsv.flags,
+			       rsv.flags & PR_FL_PR_STAT)
 }
 
 static int blkdev_pr_release(struct block_device *bdev,
@@ -305,7 +307,8 @@ static int blkdev_pr_release(struct block_device *bdev,
 
 	if (rsv.flags)
 		return -EOPNOTSUPP;
-	return ops->pr_release(bdev, rsv.key, rsv.type);
+	return ops->pr_release(bdev, rsv.key, rsv.type,
+			       rsv.flags & PR_FL_PR_STAT);
 }
 
 static int blkdev_pr_preempt(struct block_device *bdev,
@@ -323,7 +326,8 @@ static int blkdev_pr_preempt(struct block_device *bdev,
 
 	if (p.flags)
 		return -EOPNOTSUPP;
-	return ops->pr_preempt(bdev, p.old_key, p.new_key, p.type, abort);
+	return ops->pr_preempt(bdev, p.old_key, p.new_key, p.type, abort,
+			       p.flags & PR_FL_PR_STAT)
 }
 
 static int blkdev_pr_clear(struct block_device *bdev,
@@ -341,7 +345,7 @@ static int blkdev_pr_clear(struct block_device *bdev,
 
 	if (c.flags)
 		return -EOPNOTSUPP;
-	return ops->pr_clear(bdev, c.key);
+	return ops->pr_clear(bdev, c.key, c.flags & PR_FL_PR_STAT);
 }
 
 static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 727123c611e6..7c317b646cde 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -70,18 +70,44 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
 }
 
 static int nvme_send_pr_command(struct block_device *bdev,
-		struct nvme_command *c, void *data, unsigned int data_len)
+		struct nvme_command *c, void *data, unsigned int data_len,
+		bool use_pr_sts)
 {
+	int ret;
+
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		return nvme_send_ns_head_pr_command(bdev, c, data, data_len);
+		ret = nvme_send_ns_head_pr_command(bdev, c, data, data_len);
 	else
-		return nvme_send_ns_pr_command(bdev->bd_disk->private_data, c,
-					       data, data_len);
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, c,
+					      data, data_len);
+	if (!ret || ret < 0 || (ret > 0 && !use_pr_sts))
+		return ret;
+
+	switch (ret) {
+	case NVME_SC_RESERVATION_CONFLICT:
+		ret = PR_STS_RESERVATION_CONFLICT;
+		break;
+	case NVME_SC_HOST_PATH_ERROR:
+		ret = PR_STS_PATH_FAILURE;
+		break
+	case NVME_SC_BAD_ATTRIBUTES:
+	case NVME_SC_ONCS_NOT_SUPPORTED:
+	case NVME_SC_INVALID_OPCODE:
+	case NVME_SC_INVALID_FIELD:
+	case NVME_SC_INVALID_NS:
+		ret = PR_STS_INVALID_OP;
+		break;
+	default:
+		ret = PR_STS_IOERR;
+		break;
+	}
+
+	return ret;
 }
 
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
-				u64 key, u64 sa_key, u8 op)
+				u64 key, u64 sa_key, u8 op, bool use_pr_sts)
 {
 	struct nvme_command c = { };
 	u8 data[16] = { 0, };
@@ -92,11 +118,11 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 	c.common.opcode = op;
 	c.common.cdw10 = cpu_to_le32(cdw10);
 
-	return nvme_send_pr_command(bdev, &c, data, sizeof(data));
+	return nvme_send_pr_command(bdev, &c, data, sizeof(data), use_pr_sts);
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
-		u64 new, unsigned flags)
+		u64 new, unsigned flags, bool use_pr_sts)
 {
 	u32 cdw10;
 
@@ -106,11 +132,12 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
 	cdw10 = old ? 2 : 0;
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
 	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register,
+			       use_pr_sts);
 }
 
 static int nvme_pr_reserve(struct block_device *bdev, u64 key,
-		enum pr_type type, unsigned flags)
+		enum pr_type type, unsigned flags, bool use_pr_sts)
 {
 	u32 cdw10;
 
@@ -119,29 +146,34 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 
 	cdw10 = nvme_pr_type_from_blk(type) << 8;
 	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire,
+			       use_pr_sts);
 }
 
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
-		enum pr_type type, bool abort)
+		enum pr_type type, bool abort, bool use_pr_sts)
 {
 	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (abort ? 2 : 1);
 
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire,
+			       use_pr_sts);
 }
 
-static int nvme_pr_clear(struct block_device *bdev, u64 key)
+static int nvme_pr_clear(struct block_device *bdev, u64 key, bool use_pr_sts)
 {
 	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release,
+			       use_pr_sts);
 }
 
-static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+static int nvme_pr_release(struct block_device *bdev, u64 key,
+		enum pr_type type, bool use_pr_sts)
 {
 	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (key ? 0 : 1 << 3);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release,
+			       use_pr_sts);
 }
 
 static int nvme_pr_resv_report(struct block_device *bdev, void *data,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c0a614efcfce..46393bdd7427 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1797,7 +1797,8 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 }
 
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
-		u64 key, u64 sa_key, enum scsi_pr_type type, u8 flags)
+		u64 key, u64 sa_key, enum scsi_pr_type type, u8 flags,
+		bool use_pr_sts)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1842,44 +1843,74 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
+	if (!result || result < 0 || (result > 0 && !use_pr_sts))
+		return result;
+
+	result = PR_STS_IOERR;
+
+	switch host_byte(result) {
+	case DID_TRANSPORT_FAILFAST:
+	case DID_TRANSPORT_MARGINAL:
+	case DID_TRANSPORT_DISRUPTED:
+		result = PR_STS_PATH_FAILURE;
+		goto done;
+	}
+
+	switch (__get_status_byte(result)) {
+	case SAM_STAT_RESERVATION_CONFLICT:
+		result = PR_STS_RESERVATION_CONFLICT;
+		goto done;
+	case SAM_STAT_CHECK_CONDITION:
+		if (!scsi_sense_valid(&sshdr))
+			goto done;
+
+		if (sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x26 || sshdr.asc == 0x24)) {
+			result = PR_STS_INVALID_OP;
+			goto done;
+		}
+	}
+
+done:
 	return result;
 }
 
 static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
-		u32 flags)
+		u32 flags, bool use_pr_sts)
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
 	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
-			old_key, new_key, 0,
-			(1 << 0) /* APTPL */);
+				 old_key, new_key, 0, (1 << 0) /* APTPL */,
+				 use_pr_sts);
 }
 
 static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
-		u32 flags)
+		u32 flags, bool use_pr_sts)
 {
 	if (flags)
 		return -EOPNOTSUPP;
 	return sd_pr_out_command(bdev, 0x01, key, 0,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, use_pr_sts)
 }
 
-static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
+			 bool use_pr_sts)
 {
 	return sd_pr_out_command(bdev, 0x02, key, 0,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, use_pr_sts);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
-		enum pr_type type, bool abort)
+		enum pr_type type, bool abort, bool use_pr_sts)
 {
 	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, use_pr_sts);
 }
 
-static int sd_pr_clear(struct block_device *bdev, u64 key)
+static int sd_pr_clear(struct block_device *bdev, u64 key, bool use_pr_sts)
 {
-	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
+	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0, use_pr_sts);
 }
 
 static const struct pr_ops sd_pr_ops = {
diff --git a/include/linux/pr.h b/include/linux/pr.h
index 3003daec28a5..51e03e73a87f 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -18,14 +18,14 @@ struct pr_held_reservation {
 
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
-			u32 flags);
+			u32 flags, bool use_pr_sts);
 	int (*pr_reserve)(struct block_device *bdev, u64 key,
-			enum pr_type type, u32 flags);
+			enum pr_type type, u32 flags, bool use_pr_sts);
 	int (*pr_release)(struct block_device *bdev, u64 key,
-			enum pr_type type);
+			enum pr_type type, bool use_pr_sts);
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
-			enum pr_type type, bool abort);
-	int (*pr_clear)(struct block_device *bdev, u64 key);
+			enum pr_type type, bool abort, bool use_pr_sts);
+	int (*pr_clear)(struct block_device *bdev, u64 key, bool use_pr_sts);
 	/*
 	 * pr_read_keys - Read the registered keys and return them in the
 	 * pr_keys->keys array. The keys array will have been allocated at the
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index ccc78cbf1221..ac8f7fc404ff 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -13,6 +13,14 @@ enum pr_type {
 	PR_EXCLUSIVE_ACCESS_ALL_REGS	= 6,
 };
 
+enum pr_status {
+	PR_STS_SUCCESS,
+	PR_STS_IOERR,
+	PR_STS_RESERVATION_CONFLICT,
+	PR_STS_PATH_FAILURE,
+	PR_STS_INVALID_OP,
+};
+
 struct pr_reservation {
 	__u64	key;
 	__u32	type;
@@ -40,6 +48,7 @@ struct pr_clear {
 };
 
 #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
+#define PR_FL_PR_STAT		(1 << 1)	/* Convert device errors to pr_status */
 
 #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
 #define IOC_PR_RESERVE		_IOW('p', 201, struct pr_reservation)


Bart, if this is what you were suggesting I misunderstood you. I thought you wanted to
only pass the new code in the kernel so that's why I was saying we still have the problem
of converting the error back when passing it back to userspace.
