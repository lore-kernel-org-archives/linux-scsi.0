Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5689C6FD1F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 22:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCNWYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 18:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjCNWYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 18:24:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5C91BADB;
        Tue, 14 Mar 2023 15:24:05 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EJJScJ017278;
        Tue, 14 Mar 2023 22:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=07rw9rHI5ExIfJE8nrXhmlrneiQr9VmWKUXAUVsNNF4=;
 b=at0AWDDbtGvlF9Gh+Sors2FeEI7VEhubVJei1cQfUK636XPCvKK1YJXXc1gNffr8Qvvn
 ppq5O8bRIskR9iH820vByS7SwgwxDF0G8ByA32ddEEnSmlNdhk2cFy50HFoaOv0bbmZa
 nqR9PZj1Xf08+x/XpKwBW4Rlw14lBjmCHjupJQ2ZCNVkti2gflc4ab/h3niIFBJLmCmS
 eF4q6prp1yk+p6wcH7WvEugAv/iWvGtZgMzbnG1DSdDgArqBq17YruJP+OsuRrSvu+s4
 AgkFe85B+v/b+thPu7d3ecOCjn/YswLxgPUsR+jso2P2Js7GYkmvEtMQKv8iVVM5wWRv aQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8j6u7u5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 22:23:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32EL3mP5033479;
        Tue, 14 Mar 2023 22:23:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g36rqyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 22:23:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeOpNv0fZT6ixBANzhdBca2uwzqpMm/4ZJuCikHp1OLL0ItSvl/WMLbbePbm/zz/SFxiDZIbkKkym1YABJk7u7Wd0jl4zQoZ3BRF8qL4N7lNcTD55CLrA3D1iC6xe5A8QwJp5qIIiC1vG+V2/Af9VeMiliJmc61ezbxQYn4e154w390luNH9DiIRgzQr2tot3LmAbclDois1gUPxb5p/gdiXIfm4y2xyRHyJiYh+bYH2vzn3RRTP8VYoyf2GMoectu5QvKL/NgiiaI0BaK3jlA/CI3UXrZ2On8GIg2H1p7BASpG/zpumcW1f0Sg4xDI37fP4EPv/ImaNGKDmYsxlRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07rw9rHI5ExIfJE8nrXhmlrneiQr9VmWKUXAUVsNNF4=;
 b=YXUF/jw8BO10/jPO+Y6qKvG3XS7j/NaUt0X+BP0v1N9jUJEFp0737Q5LR40vr62o2kYbU+WNAGJmtKIdL7nueikpwmGioptWhSBCufik0xBo6PsRoDXD66fiXJguhuihVet1SvGFWCVpREYgiRyCfD1idiDA8bmWOO8DhTrK91VqDcqetI6H7LOuAtKRfJzgXUEI8nA0CBe/xv0PcriDoU7rKxFcngEqPku5c96WP6cFowefPovHZ/ePThwqnvWzf84Zw7M2ch3z1iFYA8URsS0SqjW4KfzFqu51GWa6dgVBQmkRW0Ni4CHeNxpnknBcvkcgvHB264HlgQ/r7h22ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07rw9rHI5ExIfJE8nrXhmlrneiQr9VmWKUXAUVsNNF4=;
 b=rUInmUZgGgNeRuH/Pp4fW+EAt2ZBM4rFteKZNgU325Jm4K2/ydkaHprW094re8JoDLUPg+OnOvYkNNlZhABhYeawABV9mYXlkWt3BaYh7m3pLWdfzBJqTNzRCUKC0w+GaMqf/zoT+BGak8YmgV/3xz7KtYPqqaah9rf4XKQOhdc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB7407.namprd10.prod.outlook.com (2603:10b6:8:15c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Tue, 14 Mar 2023 22:23:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 22:23:18 +0000
Message-ID: <c9082d55-7009-279a-fde1-7f774fb7e6e8@oracle.com>
Date:   Tue, 14 Mar 2023 17:23:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 07/18] nvme: Fix reservation status related structs
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-8-michael.christie@oracle.com>
 <20230314171538.GG6780@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230314171538.GG6780@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:4:60::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB7407:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df83549-e6dc-4188-41cb-08db24dab64a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtFHGAZD1GhQxeBS+diuj5hpDgo0DyT5h7doV5igLUtyBUChn4Fp94rwqFuWJE437NjRHQy7yMKOs5ShPs6QqNOF/ITAZi54FYKovFAAP4IzqZEvN+7/PpbWY+RZx/rQUlWiNCGC3RHPw8fV04hYEweq4brVcCY0dq7ElXYJN5yPLjj5ew3ddgeJtGRujob+sQdfU93agCKBdtJGN5fV2pR11tnj1wLCd2MuGL4Tev+uwQ/oqFFKF7n7B1YZQ25NkgMGsxZXqsdxuSPAyLLmaaVQtdy3JcrOvrpAsrVpsvADq30VjcDFX1p7tnDrAXtm2nN/21VkH3ILw7YkeXUIY3/XxAYvaFzhT2Pk7TM1vU5L9cgyDrrie+mNq0CgxhRx4a6hGUdvJYLKdHGqh693D7r3V1skHLogryHmORCOcd9xWZqX/Czx8EkTCyVqPmmkN/rTu6S8rqmcvImDH0BfEmsyj+GLcdxS/sBgeBPhKf8Q+Wc116Gp+aZeo535vM6zyJFR8l9qfekmRtiyfIdhqab6qhP3zNwzwny9IQ+QZgrLp0e9noJ4T9gl32FHtPePvNXjpOsrP/XsjmhxWgFKmayr/zgeC4/D2gEWj5jYy3Qvm2TwGUeOqRcA1V3Ku62QssSFIt7oZDBDl9ioqOIgHhakyBVPf5AvkoYIWzg10G/n8evFAoFssoRNlz+uSxcmVhV8TlKhNASSVGRGpdNXs16qoOgvPZe41VrY0hQ9nlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199018)(316002)(5660300002)(36756003)(38100700002)(8676002)(478600001)(66946007)(6916009)(41300700001)(66476007)(66556008)(86362001)(4326008)(31696002)(8936002)(2616005)(186003)(53546011)(26005)(6506007)(6512007)(31686004)(7416002)(2906002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUpLeDVjTldTZ0VBUjlXSnB5dFg4WU5Qd3B1U2svdmdhUkNhOXlNa3B6SWdn?=
 =?utf-8?B?aGdkbmVNcEx5ZDhsRXpnZzV0MFVZQUFjSDFhNVlqZFY3b2FEbEZhOW9nZWlS?=
 =?utf-8?B?MFJBRmdjOVlyVzZlTy9GaDZqQkxNTTlxSDVBNmhtZXlIYW1yRy9FWU1kSlFi?=
 =?utf-8?B?VkhvTXVWNkhoMGJGeENFNUtnc0hZOVpXL2ZIN0xtaUVOeEZxMXlJU3hiUWps?=
 =?utf-8?B?aUcvWVVVOEZ2UW9OcHgrUUhwbEV5NkZ6eEVIMnZFR3p1QzRmSzlQeGJGL0k3?=
 =?utf-8?B?YzdESFQ1SDBkSjZWYmJKeHNvRUNQTkw3MFhkZ2JxUCtQZVNsUkl6MElnY1Z0?=
 =?utf-8?B?N1p4Rk5RYXVjK1hzZEhBZjFHQUd3anp3YzAvNzZSeExPOW5pM2U4Z0NWcWpr?=
 =?utf-8?B?K0JFZ0tPbGZwMVBWU0RvWkwvallmYlZwZmlQSyttSHk0NldPcklkejhTbzA3?=
 =?utf-8?B?a0E3R1lXTG1NRENhcVhBU3hmQlMrSkZFc1dmTWNabkRJNlAwQVUwQmxUWlJ6?=
 =?utf-8?B?QUZxcGkzMk9XUzJPUkFwOHlNeEw1TVhHakJzQnQ1Tm1pNFlEVGc1VlAwSUFB?=
 =?utf-8?B?TzdpNERPYUUwUWtFY2NldXRUWDJkVDBmbzFVQkkrMVI1SnF4L2dsQ1Q4N1FK?=
 =?utf-8?B?Q2FTZnFHY2VESnJ0QzZxL1d2SGRZb2lCOXc4ckdtNG84TjRwd3puTU8yZ1RF?=
 =?utf-8?B?clBQRTdVNVVHMWVPYTBvbEp1bUJYWUkzSnNSN1VRS0Z4THcyNFhXUExWREhh?=
 =?utf-8?B?NU9hQU9Ec2s1dDBlUHFFMlFzTHgxUVJhWloxa3hlUklOYk9zNFZWbGNHM0tW?=
 =?utf-8?B?dUdOVlhGQzh2djIvVHRKSmZwSHkrZEFyY3doN1VPRTNHUG9FTS84UnNQbzVB?=
 =?utf-8?B?dkZQOXhUYm9KUVM1VlppNzV4czlEUlZHaVNLQ1hWY1kyQUdYNlllUHdrV2xr?=
 =?utf-8?B?aUdVaURLTkNUZ2hxOTJ2bWNOV3RUV2Z4ZUh2QUd4MXBJRXZKKzRQdHFBSjJj?=
 =?utf-8?B?ODAwU1pNY2g1Q0M3SG9CNVh6akdWOFhHb2dtTjZoVi9hUXNURFpGOUx5V3cy?=
 =?utf-8?B?WFRwQnFTcDZTNzliL1FjMnVvLy9adWRROWZvUnhLazd1TWVaczBLcmdDbHdn?=
 =?utf-8?B?SUpURDFaRDVQdFpRK21NY2tOYTFRYkc1WEh1R1J6ZW1EYjlpTjl4ejVmNkUz?=
 =?utf-8?B?TytTK3B2SDh3VTNxanJyRW1WMTJDY2R0Y1ByUHlML01FYWgxVlQ5QzdEY0hV?=
 =?utf-8?B?anh1Ym9SQmZGYUdGRCsrdXpWVEc3VG1ERjQ5VERpUHBRU1ZKdWQzMkZMTXps?=
 =?utf-8?B?aUo2bGh3TCtQRjQxeTFFNDVFeGNvQUloWmwzbnVyMFBtRENYNVZ6RWxGTnBt?=
 =?utf-8?B?N2dBUTBsTHowNURyVVVDOG94czBuK1VUR1NPc3BONFg0L3RqOFNsSmJGckph?=
 =?utf-8?B?OU5GOXpJeVMvaUVMMFhFaTR2OE1JWHRZQjVEQVNwdVk0ZjluQzYxM1NWUGlX?=
 =?utf-8?B?QUZYckRXb1c2VW1aT2lSb3hqaTVueEhZSzRvSTlLTUZBTktKa0hiRUc0Z1FX?=
 =?utf-8?B?WWtrd1BPSDI4dTliaFZXSmNuekRwNzVLTjZZWDZzZmtBRlVZeDlZTXo2Rm5U?=
 =?utf-8?B?djUzM0duQnFFQTdxV0Yyb01FNkk4MHZwdmlLdmUwS0RlSVQ3bXhzV3RoR0s1?=
 =?utf-8?B?akpTeVJCZzM4TkdKcUZJREF4ZUtteHlMZWVvV1NqcDZ3SnI0cFpjOUNZeE5m?=
 =?utf-8?B?eXl4Ulp2VHdSMVNSR0ZsbnR1WmYwTkM4MlRiSEhIOUZ3QVZ5T3ZjTEdUc2lo?=
 =?utf-8?B?Q3gzb1B3OHVZY1ZmSFNmUDEyL1ZpME9QQjRqc2lraFZ0TzlWaHk4R0pmTWV6?=
 =?utf-8?B?Sm1sR3d4SUtCTXk1TDlrR1BOc3pJMzFGNkFXN05NUXorR2c3dnZQaXJEZU44?=
 =?utf-8?B?bnA5UGZIa2VQREl5cHdLOHNuRldjbThZWms2WEplVm1aYjd2TGdsWkV4YUp3?=
 =?utf-8?B?NXJSNWJzNkErcStqdGVFRGhKY29kZnk5ZlJWbzFNSkx3djVOY1Y3Ym04R0tF?=
 =?utf-8?B?SitURER0MWNqNVlhOTNTaXpnOElmRkdTN0lwcEozdkdiYkJpL3dtWEl3dHpw?=
 =?utf-8?B?WEtOVlE1UWZtNng5NFZ2d2dvTnJVcXY0SGpqLzFnc2pqRVhzUkUrMFhRbEIv?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SGlYcERtb3RJSVZiSUhUUHhTSWE3QlBXUDBPZjU0bHFaWmhZZWh5N3JBUVg0?=
 =?utf-8?B?MnhMa3B3ODFoOHRvdnZWNG1FRlZ2M0NYWE4xK2xuYTdpQW9NYjhLVkl5UzJo?=
 =?utf-8?B?WUFiYS8vZm5RQ1o3Ym9ZekdZV05nbkdmR1Y5ajVTOXZoa3BSc1E0YU1qZjVF?=
 =?utf-8?B?a2l3blRmN1FzVU9NUU9WOVBBcnh3TGk5SFFkcUlXQU9wekFpdGxkOUVvUEQw?=
 =?utf-8?B?Q0QrRGdPZS9NMGJ2UFdvZmNsOFpWVGxiRHJ3aWgwM2xtOGhHY0w2ay85aEhC?=
 =?utf-8?B?SFJ2c0J0OVkyeGh0bmVzTkVjQnE0QWZNdG1QZXNTRWtKeEUzRkg5a1dZcmxq?=
 =?utf-8?B?N3ZtcTVLWTF1TzltSjg2V1dhV3BUVjZiejRuZ1NqOCtFdTFzQWdnZWhReEV5?=
 =?utf-8?B?M0Jib1EvWFRPVTA2cUNDSFFiNnBaZzJkUG9wZWlDRFcva3lzSDFidDFyY3BZ?=
 =?utf-8?B?bnlLQm9GT1NrajZ2TFZtR0Zoc3hWMis2L2QrVVc4TGplUVB5S3RkQWxoblNq?=
 =?utf-8?B?OWc0RUVQWis1SjBFaDVhdHcrMVJtUWhoamhMSkEzendNYkFIRXQyZ3l5M1Na?=
 =?utf-8?B?bjk0dzVZeUgzams2R1Y5R0VCbThYU0d0NGhXQS8zSzI0OEFHUGtmWDEzWEh1?=
 =?utf-8?B?VjF0VnZ2TTg4QTgycVZDcFNOeUlpYjUrOGRNY0xqb29ic1d5aU1lRkZodXlq?=
 =?utf-8?B?dTB5Z1VnbXRpeERSUXZFdERuTllVTUVjbmV2NFNmZU1JV0RBSDBFVlpkTkRV?=
 =?utf-8?B?VTU4SFFIOEFxVGQzM2d6VFc4YzlzdlMySGZmSitZNm05VUN0S0J1TVVqZVFz?=
 =?utf-8?B?ZERDZndKNGhUdEIvcDViSmhHQlJsdjM0dnk2QTlWTVVrdEllN2tHNks4dnBw?=
 =?utf-8?B?Vi9taytDVGpYSVhNb2xoWVNMMXdtYWR4a05Ua09nUUlGY2ZOUnJINzlHc3M4?=
 =?utf-8?B?b2FCMVcrRnpZME1RUjQybGZHTzJOYXBoS09XajA1dUhHSTlUM3hjVHRuVm9H?=
 =?utf-8?B?eTYvQk83YWVHQ2FvdlNsWEgwRi9vSmVtMXJvSjFBMnk5MzdhTEZ2SnI5Tm5u?=
 =?utf-8?B?TW9aSndUOWVOSFExTkNyN0Vma3VZb2JkTmJRWnJIUHNHNG1Ga1JoNWF3RGZT?=
 =?utf-8?B?Zit3a3I4WUZuV3Q3ZTlCMStVd1pqNnBVK1BvakNPVk43T3NkYy9wRzRORFdM?=
 =?utf-8?B?Q2c4NG5QK2xHOXkvWExjZEV4VmZITC93ZkRORTN1R20xRWpQblp4cTZ6UTM2?=
 =?utf-8?B?S0F5TFRTTU9WczlIMmxpenV6cUh3UEFnNGk2MnZGUzc1Y05iLys2T045aVNP?=
 =?utf-8?B?clgxbVo3QStDZDhXb3o5dVA2K3FRaEdVdm9lbDZUUW9BVnQ5M1NnT0R2dndi?=
 =?utf-8?B?dDdUUnVtTSt2N2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df83549-e6dc-4188-41cb-08db24dab64a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 22:23:18.4878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtMzbknd1Zvqlr38oX3qZltgADrdt+phe5PZdj1Bs9lRAJ8w5tr59K8v9S4MFeS8Uqt7ihcgZkMhWrXe62kRxAjRBX3R1TNaPNBhIolTB6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7407
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_14,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140178
X-Proofpoint-GUID: gqnGOfWimCYZz7-3gyjy8awA2Wvecjkd
X-Proofpoint-ORIG-GUID: gqnGOfWimCYZz7-3gyjy8awA2Wvecjkd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/14/23 12:15 PM, Christoph Hellwig wrote:
> On Fri, Feb 24, 2023 at 11:44:51AM -0600, Mike Christie wrote:
>> +	__u8	resv10[14];
>> +	union {
>> +		struct {
>> +			__u8	rsvd24[40];
>> +			struct nvme_registered_ctrl_ext regctl_eds[0];
>> +		};
>> +		struct nvme_registered_ctrl regctl_ds[0];
>> +	};
> 
> ... actually - I think both these zero sized arrays should
> be the modern [] notation.

gcc at least doesn't let you use [] on a member in a union. You get:

./include/linux/nvme.h:804:31: error: flexible array member in union
  804 |   struct nvme_registered_ctrl regctl_ds[];


We could do separate structs though:


struct nvme_registered_ctrl {
	__le16	cntlid;
	__u8	rcsts;
	__u8	rsvd3[5];
	__le64	hostid;
	__le64	rkey;
};

struct nvme_reservation_status {
	__le32	gen;
	__u8	rtype;
	__u8	regctl[2];
	__u8	resv5[2];
	__u8	ptpls;
	__u8	resv10[14];
	struct nvme_registered_ctrl regctl_ds[];
};

struct nvme_registered_ctrl_ext {
	__le16	cntlid;
	__u8	rcsts;
	__u8	rsvd3[5];
	__le64	rkey;
	__u8	hostid[16];
	__u8	rsvd32[32];
};

struct nvme_reservation_status_ext {
	__le32	gen;
	__u8	rtype;
	__u8	regctl[2];
	__u8	resv5[2];
	__u8	ptpls;
	__u8	resv10[14];
	__u8	rsvd24[40];
	struct nvme_registered_ctrl_ext regctl_eds[];
};
