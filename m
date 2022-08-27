Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88ADECAAD4
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Aug 2022 00:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiH0AEg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 20:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiH0AEf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 20:04:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CC4E68D9
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 17:04:34 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QMY2GM026465;
        Sat, 27 Aug 2022 00:04:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RIrIdUZhkCrLpAanZSC6WmfEYhF+uTMFatd7NoVhZJA=;
 b=jib5sBDLp+njoU/pQpXhJjLykU6/TSjQF3n5IyWjMH31oMiJlDLdhPgsK7lusk3bpfyn
 SUyoT3j2IFMruS6aDCMAtPeyfR8AGQnTMrSvHG7A97tsoEZ9ICHe6ZgkZijmJTw9naI5
 ZOm40HrrBpb7UZA8LVK1nnCDDKV3FHTm8tJJm2eF8e3/dT5UkrwEShCNiBjCgmUYbT21
 Iojc3KX+JiXnuiYxsq0b6JEaWHrPg1CTUuokv26KY+j2vFcABdULfC+rRtRvRkwXqt6+
 Xr20hPB5+o/hRT/wDxG42ioNimpBKhfAV64EW3C3CgfAiWny/Gy43x80jIe8oTB+4+pC Lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j55p290vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Aug 2022 00:04:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27QNMubr018890;
        Sat, 27 Aug 2022 00:04:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n59tawg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Aug 2022 00:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYBkqPaw5n6/mB8WoZ5OmlQMt+6SoVqAo7mTd9Be2/FsKdn11RtqlkwK3EOqJaVjSzSQqcxiG4sMsWsi2qRtwmNin/dsr5JvayApfV2RGAnLrYZpVYewvwKuobxAVw+f+397qDgTRPrn7cD7o3TTAOpYFhvoeJcNSXufLurLQhndId8ozfbbJmu0txgaC7pXxVXn4WtMa5lu1wrxPfQ33n2QmgoBwgJ3h/qFqpIMOTsfIwHgHjBaODRD102KG2RerjsIMApIu8xXwxo0lTTL0Tfo+MlNU31Ga2Huz5rV0tC/9CWeK4Ne4Zq1d3BkIdOvH7gqI+QSFbG670CImClgmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIrIdUZhkCrLpAanZSC6WmfEYhF+uTMFatd7NoVhZJA=;
 b=DQyx9Rbq2py+azA5gBxPkLLJS97dpi1C6xz820VCTJnmXuSMQX+vF1MMi2875GkaUmNtSjRxq51coTHjzqe3d5RZohs99GXeoIwqIwejDh7BltEnv6RLHFvGjBiWcPNVUkhrMKiIS7UwoCIGNwCPZDAbQHFk7cKKkIwRepLSTbIJAOreoALYtV3yuKRQtIAhqRXRti2LZYRF13BEnwOMQZGuYu54ZQO8hI/9LTqDRwJHXAq8Kmcv0PSuZNE/eOeNPxpVgm5cbt0gWIfqveKmT8tzkfCw80qsxeWUhkYOC1g5SpOsyTmduPqS94i/RPD5JWdw0Wz+beyH6qSuBUn3jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIrIdUZhkCrLpAanZSC6WmfEYhF+uTMFatd7NoVhZJA=;
 b=hlVE1eXdX4aUZzWz4idJm7GgmtHLo86ODKltxxL4BQTP3qidikrqz76KhnKTVN6XuAtlTNDdE0N3u/+uI3sUid1DrlbDBHfQ8RnaOLDxo4qbLTcWI+4UDHQKV/NwC0t9qw5XG1ndyIKCKh0tecUpMau6PQtjY+LrlM6sw8tVmMw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1548.namprd10.prod.outlook.com (2603:10b6:3:13::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.22; Sat, 27 Aug 2022 00:04:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5546.024; Sat, 27 Aug 2022
 00:04:14 +0000
Message-ID: <053fccf4-4315-2f84-6f58-2f99307d18b8@oracle.com>
Date:   Fri, 26 Aug 2022 19:04:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH] scsi: iscsi_tcp: Fix null-ptr-deref while calling
 getpeername
To:     Li Jinlin <lijinlin3@huawei.com>, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220807165804.8628-1-michael.christie@oracle.com>
 <3e7bb57f-320c-2635-42eb-ec6850a69923@huawei.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <3e7bb57f-320c-2635-42eb-ec6850a69923@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:610:58::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5279a3cd-6d4c-49ac-ddef-08da87bfad58
X-MS-TrafficTypeDiagnostic: DM5PR10MB1548:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnBVRmOR3IlREv7qZm2A3Z0M+jfgP+Ua4QpePVZYiXvj2HsdF00E9o/EcwfoyPcUpPgheEEtrWwX36J+WuO+R6JWvrAZepFKopSRJamfSL9uWIFnQTb8NW3f2R/zhvlvyopcEhFkTy5ED0XX+mdErMaHTN5XllZ4Rubcj73S8EVt4xStfjtKAK/H284MppukJ66QWul2l52DWOIm6nQiar5rg9/zPimjf164N/+ydAHsAYhvFtDABTFDEUfCB8Ju77qInpD2NU+mraRiRPA2B8F39+1dh2NzWIHFOBFXMHtu3RFVtxrjX6CN8sK536rw1dczn0d/Zz43ydelrz6fEIQDLwWzeF5o49Zihd9JDgxguDwrPXYaD6G54RmStCBbCECagGNqNpzwLJOAUvdn0aa1tYF8COVJHikbTuZP4cyXr7aCLVIAe+Hw7cuB7H1gngmZvExqwBGKt9da9+wWOYBmvPoyvEtmO57gjMQTS4hdkEHBnvIPFpDDjX+N3MgrlizWS9l3yBBQLqSndS6Unb2aF4/a+psMtqhjJnD9iKfpGImhLYjYEtWYZ9vi7jjPdd/r22zuEjJQcCDn7APOyEKAADi8MVkkTHTzLgLiGO5h0KTVQOd70QVx2yzp9CnsnovY12mXRyQntMrD297QsbtpXNsR5jMu9CA2XWVrhd2nitnhiyhm/gVr1+pMTbYvOQcIT9Nr7k9V7qFLRff8MZcLBsKi+fMEl2bneJBWRsGol3Y+L7pM46NuyLk1aoCJBPFLNSyWafeeKQGd6DKHRo8IcBym7Hd5BsuwhwQIGbQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(376002)(136003)(8936002)(5660300002)(41300700001)(6486002)(6512007)(53546011)(478600001)(31696002)(86362001)(6506007)(6666004)(8676002)(38100700002)(316002)(2616005)(83380400001)(26005)(2906002)(66946007)(31686004)(66556008)(186003)(36756003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHBHaitmLzVsMUtXZ1pXSWtFdEF5NmU5Qzc3R3Q3YkhzVXBPUHNVN1VzcGo2?=
 =?utf-8?B?cnR3R01ZRWNSZEczMytpVFhGRys4eXB5Y01NSmczTVRRZlU4RzB5RysvNU16?=
 =?utf-8?B?bVh4cHdrb3VGOFYwd21SNGpKYzR4ekx1QUd6M2lBK2xQamJobFFJcXAyTmxG?=
 =?utf-8?B?TTV2WUZpaVpkd1JlS0ZFMG5oWit5SURRZk5JcUFJbVJKV3lQYlpaL0Q4WWpE?=
 =?utf-8?B?a0Iwc2JSS3FybTluUGg1Qll1L3gzbUhSSHRMTEh1MjczSFRucWp5ZUJnRWNX?=
 =?utf-8?B?R0w5V3M3b1NPQnV5di9qS1hUaHVxN0wwK1hWMVBUR1RGTW1QWG9TK1htcld0?=
 =?utf-8?B?MGlhTXZaQUNhVUhGVUpWQmJEeUJFMDhyQkZXcEQ1WEM3K3ZIMVFuOTEzV0NI?=
 =?utf-8?B?VHVnazVPMDBaUVdPUU16eEdmYkpQMVNKMHQ5MVNOQzdYaU9GQ2hkaFIzalVi?=
 =?utf-8?B?L056aDBKalNvUjBZeU9VUEZHVHRibVZOQUNMc1ZaYjBjUHU0eWk4Q2E3K3lK?=
 =?utf-8?B?LzFEaVQ5RXZURTRZRjd4dUw2ZnBib3NaN1Ruei9UQ0pSeE9yU1JyY2lJeGF3?=
 =?utf-8?B?N240dnJhZzlKcDY0MFJ5V1lxejJGRndBTTVTd0U1RVhoSDNyd21nRjZnT1Bz?=
 =?utf-8?B?WDVYTVMrVkJHRTQzR2x5RStTOExhSFJ5U2hNSXVnSG9lcDJoTG4vYnQ4OEhz?=
 =?utf-8?B?eEwxU3BCRVYxMDRKeE5lWXNnVGJoUnlDV0tVVDgwSElzRWRIS3g3T3R5OWFC?=
 =?utf-8?B?VlZpcWNMOHVvK2x3cW1INm9DUXhNWStSbzl1ZE1DemlnYm5ZcFpvZVlGV3ZM?=
 =?utf-8?B?Ylg4TmFtcGZUSzZVZkUvK0xkMldacHVYT2pQYUZZRnQ1RHVPRWNYMFJoY0Yx?=
 =?utf-8?B?Z0dTQ0RidXVJblBBalZaMkdYd0dOQXJxL0F2a3NWMTRhYk1KQnhxVmNZWktp?=
 =?utf-8?B?Z0taZWpwOTQ3ZE5TK1RUd2lHTUxCZFFPc29WUFF0Y3R0eHNYQWJyRk4rS09I?=
 =?utf-8?B?TzdsZG1odTJsWTRCMTdpSFVXR2V0NFdCenEvZVhHcGdzSU5Ud0VnZzdrbFNp?=
 =?utf-8?B?TDAxdG82dlF6WENkdmYvM2xTWmw1U080ZlVLT3VDWnBHd0ptbldPT1Q1Zy9B?=
 =?utf-8?B?dE5pOXlKZmpPR3gwS3A5aUxwYjQvRnBRQVdXdDl6Mld6YUFIb3BtdGRlWkRp?=
 =?utf-8?B?ckJwMHNWNjlGSU1pNEV3SzdtdnlvNWFyNjRNcFFYZkd3cHdEbWN2VnpEN0Y5?=
 =?utf-8?B?dXhQTXNlOFg2ZVlaelVEODVRa2VhVlNubm9WMk1wVk0yeG5lS1hkNFAvVTll?=
 =?utf-8?B?Y1JiaVZhSTZSOFBvWFdnenprTzBOTy9DMTIzK20rT2VkNXphNi8ybjk4U25v?=
 =?utf-8?B?VXpXcE1yVWZMUXgzY2RoQjM4TTJ2ZENjTjlxYkZCaVlxcDlnMlk0OE1yOHZq?=
 =?utf-8?B?MHBNd1U2L0NQVjJHUHFob05OR1NEcGhvT001Q25DYzVGR2JKOUU0VFNlU3Bz?=
 =?utf-8?B?YkVqc3lXblY2dUdmNmg4QnEzK1NxeEV1NHUwY2ZiVk42T2MvNDhkeDcwQW9K?=
 =?utf-8?B?TllIbDBkMVgrRUJ5TkZydHMwVVVJWHg3akUxZEFxQTNVbTNxTjdHRlRIV1hr?=
 =?utf-8?B?RHVFQ3laU0tHSjJ4MVhJTkFMZzJMM0RRZStVTTI4T3MyQlI1ZlpKV3RaUmxn?=
 =?utf-8?B?Qk5yOWs3NkhWK1ZpWW9qQ1V0ZkdCZkhOaHpmUWh6ZkpieHRpaklwV09tRmFS?=
 =?utf-8?B?QWljdmJITzlaUHVSQ1p1VWVBYjExdDFQOEpEVGlzaW90bWJrMlJxV2oxUVg1?=
 =?utf-8?B?VTJxRnp6SVNaLzlSWmdmOFcrTThCSXJJVXZGL0J2QkRLUlRvQmdPZnRyejRW?=
 =?utf-8?B?UCttNUpuaUZsemw5YVdPZTB1ZnF3M2U0NHV1Uk5CQWY4WDI0UkI1ZDJkQ0VU?=
 =?utf-8?B?REh0dU9TREozZjM3WmlQTlVsb0VwcE9MNjJtNmxSVXVpMFNPWkdpME9hWTJr?=
 =?utf-8?B?SndRR1FzVEluMFJZS3Bwbmt4VWNERWdBeUtIUnZFdW5VN0NjWEl1RlNoUHlU?=
 =?utf-8?B?eDdZM2RBN1IxbllqYlZlUHBndForQzZmSVVvSzNlVEtuMzBTVThRcFp3VmZl?=
 =?utf-8?B?NWxtNTlpRkFmenIrTmh2d0Z2VVJCQ3pxWDNMam04R3grOWx5QkFFWW4yUWlj?=
 =?utf-8?B?NHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5279a3cd-6d4c-49ac-ddef-08da87bfad58
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2022 00:04:14.4694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kampOUOyy/hSYEqfldkWZqPV5tgrbdXjfGru6FzxCc+c5pqFym4uxKSsm7dAfsAqPwBJczrAHsCzQO0x7dfblqiyIH8BGzTdeQ1r3arLNtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_12,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208260094
X-Proofpoint-ORIG-GUID: Fhj9HOkRQfw54wj5j6JAOZGew_EkXkDK
X-Proofpoint-GUID: Fhj9HOkRQfw54wj5j6JAOZGew_EkXkDK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/20/22 3:35 AM, Li Jinlin wrote:
> 
> On 2022/8/8 0:58, Mike Christie wrote:
> 
>> @@ -763,8 +768,15 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
>>  		break;
>>  	case ISCSI_PARAM_DATADGST_EN:
>>  		iscsi_set_param(cls_conn, param, buf, buflen);
>> +
>> +		mutex_lock(&tcp_sw_conn->sock_lock);
>> +		if (!tcp_sw_conn->sock) {
>> +			mutex_unlock(&tcp_sw_conn->sock_lock);
>> +			return -ENOTCONN;
>> +		}
>>  		tcp_sw_conn->sendpage = conn->datadgst_en ?
>>  			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
>> +		mutex_unlock(&tcp_sw_conn->sock_lock);
>>  		break;
>>  	case ISCSI_PARAM_MAX_R2T:
>>  		return iscsi_tcp_set_max_r2t(conn, buf);
>> @@ -789,14 +801,12 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
>>  	case ISCSI_PARAM_CONN_PORT:
>>  	case ISCSI_PARAM_CONN_ADDRESS:
>>  	case ISCSI_PARAM_LOCAL_PORT:
>> -		spin_lock_bh(&conn->session->frwd_lock);
>> -		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
>> -			spin_unlock_bh(&conn->session->frwd_lock);
>> +		mutex_lock(&tcp_sw_conn->sock_lock);
> 
> In iscsi_tcp_conn_setup(), cls_conn was setup before initializing
> tcp_sw_conn. So tcp_sw_conn may be NULL in here, need to add a check.
> 
You're right. Instead of a check I'm going to split the rest of the
iscsi*conn_setup functions so we have a alloc and an add. We can then
do the sysfs exposure correctly.

Will resend.
