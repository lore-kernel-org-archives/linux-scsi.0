Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F958C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 23:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349582AbiFCXJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 19:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiFCXJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 19:09:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB4F326D0;
        Fri,  3 Jun 2022 16:09:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253LTmCT016569;
        Fri, 3 Jun 2022 23:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fycbvXA9Rko5CZ02ONEe1/NfXnAy0jlPXCXZPw+kjGw=;
 b=Lv8SCs7O1PJuFjxKE2r8wJrYQGhUoia2dOmedQIESuQzhiilVxQaa94UCsVhUnRoYh+n
 Oh88wOguJIoQjFGAqGId+6eXx8A1SKqCcL0yexCvv8IG+FjWXr17PzGjjtf3BllQ5Zl4
 u8tri4DDMEhb/hnOVT6sJFUBmsNQyycmhkySZiqZ9IIzRhCsBJwRg1hAMa7FLzhwQVRh
 RXQpXOpklMXMJ4C/IE3f9nfoOj96fnxl1UuIdcpYheTYmthK42QAntjawZIb8eeFGs3W
 BHu/znsXZ53+msjqGwUTt6l8FRrt1X6AvAYnhzYpvj+W90f2O+28c6Vw/5bD5vlYNiLg zA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc6xdyby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 23:09:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 253MeLwl011626;
        Fri, 3 Jun 2022 23:09:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8j0ke6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 23:09:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1725evZSo15gD/c2RFva3D05qG/7CvkTmFEghethI/B7mbNH4JPf3akYy6z0DJmhTw+iJRflfulmQR8K8Hxu9Sm0/CzAiOAnE5vnEwfIQBwEPMAjD1RBJVicXGMNwyOFV36rWfZ+9yNUGWXFKi10QCt9El/C2HCuEfnJbWh6kNYgkSEvwDIhL+M5lGuEUPD4F7TkmJvqMJ7ScpCpDPX9qvpSTPWOGrygIHTEWat/WgA4lGuH0kVDKs39oSAZZXonj3ZCaOBQCSUye0SuJFQ/RuWitNfxynMuyh6c42kuetqHy5vVb3wPM40151Sre3JIG4mxa1YmXLkHC6SveihRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fycbvXA9Rko5CZ02ONEe1/NfXnAy0jlPXCXZPw+kjGw=;
 b=HQrkaVluUMNSkf6Q+ykxUIDlHhiDhQstrlZbBWidARLotEQ3Tm8qI4mna6GVL2P0I+Ppa+DYksr0XsBXd9hMp3RV/Z5wMwDZb236IljXjwLifauE/qd1r7aPdvr6bLQcyYc0vU2p32fqQ3EedLyjFzQTdoGI7LA8FnwGgTBd0k56/th6+/ids9PFAJgcBQ4OAVJnSYBcqqEx0oMu0Ampy7JoV2m3Z+Mx5bZSYDc6akRtAhX22t26LXg/GEgUO5h37+gZicT+35iiK6hUD3L3YOLtjF2ty5NZ4clwWgG00VjAt7FnNN72PyYr2r68JUudho++Js6cJ10muuAKJDFKjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fycbvXA9Rko5CZ02ONEe1/NfXnAy0jlPXCXZPw+kjGw=;
 b=g/EB6d23c42SFV+Lbd0JEIdYXdkfYNcDT6zVpi78NaCROHWlIMVdyQiieVZw64HhtRaS2WtRMnEhsKnump2+JRrV7tS89JinjLcQfq3/zUa65M0FlwW6GzNsctbr3rqAFDy8OolH0y+ynjAbvGmiix8CnngzrP5WqU4XfzPhHzc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB3061.namprd10.prod.outlook.com (2603:10b6:a03:83::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.17; Fri, 3 Jun 2022 23:09:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 23:09:00 +0000
Message-ID: <7aa54c8a-7f2e-694d-882e-2ae967690607@oracle.com>
Date:   Fri, 3 Jun 2022 18:08:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 09/11] block, nvme: Add error for reservation conflicts.
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
 <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:610:58::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1489ff64-290a-42e3-a49a-08da45b60b37
X-MS-TrafficTypeDiagnostic: BYAPR10MB3061:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3061CBA26E102CCE6C073287F1A19@BYAPR10MB3061.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bzogrDPge9BfJZgSocbZZljDndVJZa0XW1zW1rauks8fzIxdU51T8xONpcDNlV3hMn2s/QsCY3C4CALxdGEuuSn+SyujBirADl/sJHM4V0pLsGwtH9J4O0A6p3uKfzKz7YcYYAytuDSQ5aKavqfGrHjOObkle7xCqHDiXjjpT8kdtH4LNUj+SP9otf/MLiJ96Ye8nxp6Oy990+q4UY4nFQd1dN0zzQtk2huNQwMP9gA3QZDPV6RrfMWAfspXz1YYDz+xAllkkrqOnuGN8EndCCCRqzCFGwuknTm5YRDwk+dNW/bLUpSxK3+pug8yCWYUxZRAkBL4BEHsaPc4XlmteX8X9IUbFHbbiqwH2oLroEcJtTJ+SA+apQDIE4xceliDMmQ3PZFUWz16q2L/hppxHjHuzmj+EUhKbIU3Rm81es9nVrV+YjqTzf6O0JYHL+BQs03Zo3SZ/LErgxllJwWwstzvzf3BQziDdgyTGoGa6tcvrb6JryrXGr1FqYszSP5YXYY0335kBdsvQXOgtZWv4MoqJFGk2pT5CpRFzcULukNrj8gx+X9qDE7cM3hyHpd8miEO5kYS3FXrGhogTn2Mrb54sw411H8ZVqd+iosZzAh2pBdx0pahlvUltodBEbmJE0wUDs0XnDTXwMzLcd3ExqY39rgbUmAtPf4vIc1D5uB9J979k7ikmK75sCNK+g4UGhruMvqLj/kJFPgHvJiqwDTVMC4OlezaK+kRKkvvSu0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(316002)(66556008)(66476007)(66946007)(8676002)(53546011)(508600001)(4326008)(31686004)(36756003)(6506007)(6916009)(26005)(2616005)(6486002)(86362001)(2906002)(186003)(31696002)(83380400001)(38100700002)(6512007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3ZyazRtRmxVQit6N2xYNWt1ZGJjVmFaSkE4akk5dlhCNldiNUc3eXlWYVUx?=
 =?utf-8?B?NXZXREp2SFhWZmYwLy9ITnlwdzdjOW9xRk5GQ29BL2VXMjkrUm01c2p5V0Vz?=
 =?utf-8?B?bUlpMm9yRkp5RTVWc2NTaW5wb0VBM0p4QVo4M29yVWp1NjB5WkxjeEJjalQ0?=
 =?utf-8?B?TjhUZEVvRDJjYm1kTWI1d2dXR0Z6NDBOT2ZxMzAyMVB6ekJqTHhLUjBDSjRJ?=
 =?utf-8?B?bnRESzRqQXR4WU9TQWhJL0duWjhJaUoxVmtRbVRteDB0SmVoRXNsTGFuWGNj?=
 =?utf-8?B?VDZWYjZpazFYa2VPUklBWmE5bDFGbm8raFZJVnpabG5zZFZwWE4vcmdmWEVT?=
 =?utf-8?B?R1BWbnZkWnUrR1hXdlFwcHVSL1JZZkFDSHk5alB4TUNpWkExWDhmakk5WDZU?=
 =?utf-8?B?YzRjcDVEcVBzVnloSmRYZ2tiR3VhSU1QVnlQYkpCQXJFVER5UE10ejI2Z1Ny?=
 =?utf-8?B?WmpaTXlDTi8ya2FoM1N3bHpVaW5LYitKVHV2cU9iVSsxajZDc0JtSUZmcHA3?=
 =?utf-8?B?cVVXNUlJaWZYRExna05sNEtOekN4NVJJam5TRXN1NEVaYmlucnU0YUkwQVRm?=
 =?utf-8?B?c0dZcnM4M0tBT2lpZ2dzSVg0YVJXbTBJcW1ZUHgxbTc3THFKRDU3TVFkMFF6?=
 =?utf-8?B?NW9DeFJsZmtvU1pabkFIanp6VTdsbXBHcWZnbjkweEJzTnN5bkEwbnFSNUU4?=
 =?utf-8?B?bDJ6UjJRem4yWjdiN0tBaTY3MjdWNFUzaTZHRXRyVUVNRWxRQzhITEQ5ZHJ3?=
 =?utf-8?B?bGw3SlN4ejErb1MrK0gza2t3R0VxdW1vSXV4Umc0WExVUTFQK3RJbUFjT01N?=
 =?utf-8?B?Q0d1NERKaFhKYXVQQWRjSVcwTWhTeG9nTGMrODYybmhtczBnR2djdG9ZcDI3?=
 =?utf-8?B?S3V6dlBqUGt6QmxtODF0M2ZuRUNLL2NzWGdMK3NEbks2VmdJVEMrelU3UlpG?=
 =?utf-8?B?WlNVNFJGMDNrU1VaSk45ZXlMWW5ZSWhEZFN3amhDeDVoa3RxK3dtUmQxa1ZO?=
 =?utf-8?B?NGxEN2dyUEM3QVhYY01IL3JXbXJES2NrTS9Sc2MvZjQrNXNWZk0rRGZYdzlh?=
 =?utf-8?B?K25jOFM0cnBHTTNZL2h1R3MwazU3S1FoelJzL0pRSFE3TWhIYUtkZzRZU0pR?=
 =?utf-8?B?aVJkZFdQUm13UG80YTJnbG1sV3FCT2Z4eUJ5SnNDWXNYZlVOZG9kR01vZWww?=
 =?utf-8?B?d2IxVTdpU1grQkhuVUx4NldtVVl3RW1IaGJaYlc3Q2RMZkMrdXMxMkpzRlEv?=
 =?utf-8?B?L3RPYndXUEwxVjFNekZZdTdqT3hqMnM1Z3lIODhOaE8yV3NOdGI2aE1YOEkx?=
 =?utf-8?B?MHhNTzlhSjk2a1ArK1hqK1ZZTFhDampmMmlVbis0QWNuUmNPaU5PZGJLOXdE?=
 =?utf-8?B?N1lEWERIdlg1U2treTNNV0VxM2lEWjdLRzZlekkzVjI4WmY2azZBQjFJUkEy?=
 =?utf-8?B?UFA4WWxySTRwMmlUSXVCRmVhakRwdzQxeEg2eU96M1JnSDV5ck95cWRXdXNJ?=
 =?utf-8?B?eGV3TG1CbjFSVGE1YllMRFRQbGlXSmNOeHdOdk95L01MM1krNkNRbmFYcHBG?=
 =?utf-8?B?cGE3emhvU2tSZU15RmdZajZzYTUvOHMrdDM4Vy9NVEM2QUNoQU41cmR2NGU0?=
 =?utf-8?B?aFJONXdXQUthRDd2NTNoSTFrWHFuSE9MNmFURy9yYmY5S202RjFPTStNaXh0?=
 =?utf-8?B?Z1BCVlErZzA4UEtxdVEwKzNYZysxUGNJdFI1clZ1RWJWYURqb3FhdUExdGZn?=
 =?utf-8?B?RS9ET2xPM1hCRTJqc3BuY1NZM3hBdWVOYUhZL1lhWDZvaGh2QTJvWVFRT0V2?=
 =?utf-8?B?S1FqTmxIWkpHRi9GUGVGc0U0VVBadzFpb3JVUk5zQTVpVnBIM0hOSnYyK2NB?=
 =?utf-8?B?OW9kckQ2UkhENDU2Wmhjc3N6MzN3aEZBUG5FeEVNekUzTTM3VkRjM2JWWEtV?=
 =?utf-8?B?Qy9QSVBzcWNGQzN2RUc2VjQyVTcyMW01NUh1dXFodSs3WlNoMUQrUjJjNUtG?=
 =?utf-8?B?Uy80Zjg3UXlnd1dFeGRFRXpCTWppUlpUdklHbWhnZ2VGSjVsNmEvR3krcnhs?=
 =?utf-8?B?V1YwdWpjYW51ZHBZR01UTUdmWVNTVnI0SFd4b3hZYlZBT054aHNJbW9uZzFr?=
 =?utf-8?B?WDEvWSthWC9DM2t3MkE0SVhhRk1QMUxEcVJZT2ZheW5SQjdHejVCVkUrdHpP?=
 =?utf-8?B?ekRsU0ZnazNGMzBzUEpKSWRTQ3RQanlnc3RJdzdsaCtTZWt6YzlvZnZibmJM?=
 =?utf-8?B?QWgxMjhpWXErV1JiNlBjdGdCRzJESjdoL3lPcVE0em5uaWVmWFVHeVRWL2dz?=
 =?utf-8?B?QWhRMFJ2emVwT3ovdkRkOERzelR3OHQxVmZvTFA1TlJyaG9EYkZSMlN4ZE5j?=
 =?utf-8?Q?auNAnN7JmWTcUsGE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1489ff64-290a-42e3-a49a-08da45b60b37
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 23:09:00.2625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nJkXVCEZ3MTE8LtO3pdcnk9TJvUHp6IJ6OkbAR8m82mDMcqE51JIoudiVZWhVa8Qhu8CtItTAnay2qfp5wUohMetF3mNfzZRWqSg6wZTUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3061
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_08:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030089
X-Proofpoint-GUID: BlcyF_pARbor1dDkIktOvxmqpZYqXTvo
X-Proofpoint-ORIG-GUID: BlcyF_pARbor1dDkIktOvxmqpZYqXTvo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/22 2:45 PM, Keith Busch wrote:
> On Fri, Jun 03, 2022 at 01:55:34AM -0500, Mike Christie wrote:
>> @@ -171,6 +171,7 @@ static const struct {
>>  	/* zone device specific errors */
>>  	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
>>  	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
>> +	[BLK_STS_RSV_CONFLICT]	= { -EBADE,	"resevation conflict" },
> 
> You misspelled "reservation". :)

Will fix.

> 
> And since you want a different error, why reuse EBADE for the errno? That is
> already used for BLK_STS_NEXUS that you're trying to differentiate from, right?
> At least for nvme, this error code is returned when the host lacks sufficient
> rights, so something like EACCESS might make sense.
>

Ah ok I might have misuderstood the reason/usage of the -Exyz error.

The patches in this set use the pr_ops in the kernel so I can see the BLK_STS
value. We do bio based IO so we get that value in the end io callback.

I thought the -Exyx error can get returned to userspace. Because scsi and nvme
currently return -EBADE for reservation conflicts I thought I had to keep doing
that. If that's not the case, then yeah -EACCESS is better and I'll definitely
use it.

