Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6006C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 18:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjGMShJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 14:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjGMShH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 14:37:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724E2211C
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 11:37:06 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DHhwdZ027275;
        Thu, 13 Jul 2023 18:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3IeB27YhMM/jTtqRDOpFEK5ApDtJKgGa7EfpvJXdzcE=;
 b=09VlF3+h/qDQ9SAEprrtuuOYwvxhaApxq6e5iOZ3ByM5WfgqCesj1HT7Oe3HrVI5y4I2
 8qfY9+NbjcqIiA+uxhCdJU/iH/ZjtZuCPx2BqhsXwN18gIzQx1SzJkJz8zMoCPvMb/7y
 jONZQouveV1exlYriDXsF7ynvvOZ+WonzzrlZSMbUsXcKOzXQ1zTh+675mgrkTFujUvA
 EwqbQe6XrX0WKucm6lz6e/tw1/GHDcKd68Dlgh4Uv9vvVfrJNdTv+akdf6SWYG8gIbfj
 8zjOQ7TogDEOm5AMZiJ+oQ40dT0z1fdJ3kzO3gEWZYqykQjJwfQOxpX3d1jbvVvQZxzD aw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyudae0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 18:37:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DHIJ0J004345;
        Thu, 13 Jul 2023 18:37:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8f3nme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 18:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6ECJctUvHPDMNP2aA4FhTnyEEH9fUBGvWm2nLprLpQN5hGhW4NT5ecgIdcs6u3bLoG8bRbfHFWBpUSxmN8FDrdU0OMjiT3N36tfg5tWNFPEbfvHUZNimqBXQ2aVTk0+6s7Mx1iJNloQYmEhf/98qfoA7fdTCo38BIsVW+QaKcGidOK6tV31a4gl5pa0d4TPhA0eEQ9oOH+NAjKKcDLMXGhjmyhadq1JhcZqE5g9fkfr7aIEr/h6e0MeHTeByt5/0sGc2PeBxKsv4DfmzofUTyxJXQpSaYIZDLF+Tfo9VwQrManuAWR+UwiREnKuwiK+ZBNgO/jiFPJjYpHiy/lLCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IeB27YhMM/jTtqRDOpFEK5ApDtJKgGa7EfpvJXdzcE=;
 b=EYBtfNY+DbrMXR6FQrEIGFS1fJbvJ6yCbd/Tuk1U43iCRm5JNfk/WhvQA6Q0INfn3eBr5zp8xdqK7AlDToig6iYxNtrmhlFzf0+7mxc+9jBw663JRy+nJp0w8Bp92aBH3u+EaUmxhpmN+Mrs8Kb5SDpRm7Q6K8OC50sv152RfEyCAgqoukJVc4g16hQKYwulDT1BmXyYOPC8BfptW8HSjnUnOPOQqina3DLi1g0G8eORq0fKUEzmBRAUgkSskYkQmRANjp3AbQZgbfe99DZ0V5L/XOoewGDkeFDWEOGccuqFSYbGTD0OvNPzEDBR4ROUWQZ2Cu2oLOu2dXq6yrcREw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IeB27YhMM/jTtqRDOpFEK5ApDtJKgGa7EfpvJXdzcE=;
 b=dn9JxitF2k+/DycToRL8jt0dBVBNz9xEUl30ZPl+VnCQxKgj9CS1hQivkm/qCdmWKuOncNvqfXpaT2D9fLiLWNO5cjxTiM6P5ERnku0qE1i+1fIbNAAyCAl4tiF89gpaaZ49PXRiEDvPhYkm71ha3uQA4C3TBx/yEJwZjOcyEqg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BLAPR10MB5091.namprd10.prod.outlook.com (2603:10b6:208:30e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 18:37:00 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 18:37:00 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 01/10] qla2xxx: Fix deletion race condition
Thread-Topic: [PATCH 01/10] qla2xxx: Fix deletion race condition
Thread-Index: AQHZtKBMWAEd9Zfpk0ag4l6GbgRAaq+4CLeA
Date:   Thu, 13 Jul 2023 18:36:59 +0000
Message-ID: <9E4F0B59-9371-4199-B7F6-E2FBEF8D3AC4@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-2-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BLAPR10MB5091:EE_
x-ms-office365-filtering-correlation-id: 144f0724-d500-409a-5641-08db83d024d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K9YvtGqe4Y1T/el+tcQNi3ASfuqmOQHYq+azFhCoSrDUqWU85QdVy5yOJmYiXV3lZlQUMSQz0F8KVqEQZ2Osbt6eyNEQUmyjNUtpVQ/9UBh/Q+WOnMXQn5DeKofMXhj75+fU/iJPnVuzmX349SNjaL96guzsDOefzyVwj7aU7QE33whbsHFoK253YP7AID8W8Q3q+O77nY5ae3Owr4hvcVAxvSv6qLX0a5r6bz61nJ0dEa5CKwjG4R15DpzPbkRx9WSqOMTpenMTmsVnFGo4yQk97lZK+5NOLzd+FRWWEHjFqun19dpwF9J338+aTVBfUgp7sXaMLMZNpZYtDG2fpTyVCY4Zcc0VkEY+Z+5x9lBb4h/SOXqPebmGu+VK2VU3QvzqTZVnA7CDfKKVvq9IE3tmqh6/QEjrhRD0YlUHnUXRIaXU9PaPE9l3GqZz+tnJ6fX90ODMKehgfFsfJKGdPrfa3GIB+o9FwHl9Z0KmMYeUqAnruav/RC00Io5uLQfocdhyvxH045IA1ctHm/JLJ99+vKc9NHriv9+/jDqAM+31AiqUcaWzZ0M8Qalrt019IhgpJcsabyhpWB3fhVmVKznBK32LU7c41NZ9lyQfHYrtxNww9Erm+BctXpRH3+SlQ89yUyA0r+saiYgQeak/sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199021)(6512007)(6486002)(71200400001)(33656002)(83380400001)(186003)(36756003)(2616005)(122000001)(38100700002)(38070700005)(86362001)(6506007)(26005)(53546011)(64756008)(66476007)(66446008)(66946007)(66556008)(76116006)(4326008)(91956017)(44832011)(54906003)(6916009)(41300700001)(5660300002)(316002)(8936002)(8676002)(2906002)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmZVNmp0L0loemlRRW84a1pER3BMUTFNTTZUWlR3Z2dVaFFORHFzaVlnd2hw?=
 =?utf-8?B?TURLemxLZko5NlV0dDNaeTZVV2x4MXZvZlRCdjJvcDNyM0tsQmdIWDlySVJz?=
 =?utf-8?B?bWVxTGUyOTdrRklUblMrTSsrMC9CcVlZa2NJTWFqV21IQnFOQXZNRHpnamVV?=
 =?utf-8?B?ZHJmL0ZMQkE1UTl0M3F3bXE5SkM3NUFpVEwrejNTbkVrOHNXaTY3cEoyalRs?=
 =?utf-8?B?NHN6ai9vRGxEMEd0U1Q2aEpOTHVudjNDTTA2V0tUcGhwMFQwSmNqQi82UU1y?=
 =?utf-8?B?Rm8yKy9neC9Pb0VZa3kzc3BZMHhWbm9waHFkZlNwMHpOYWlXSGFXc0xMUjBE?=
 =?utf-8?B?WUJyQm5tT2VCczFmMnVIRzdRMVdObVBWcDFMU0tFYlBjcDBnSnpCdWtHRTNP?=
 =?utf-8?B?ZEVCaFo4V1R3WWduRjJyYmlaL2p1bE1QN01kYjdJZGMrZGVVbm9TYUNlMmJz?=
 =?utf-8?B?UDJzYytndVJySWpEM3VmL3JsS2pJK2Qrei9TRzJsOXlJazJmVlMzU3cxNWE1?=
 =?utf-8?B?R0dYanlXbmtlQWtaaXczc0ZWY1dxWHVrYjQ3Vm9SVFhnUFpWWnNwS0JsTXNE?=
 =?utf-8?B?L01qOThFMUVwQnRJQlZudU5zVVZXVFRBNDNrSHV1RVo0dW1DYXZTRTdZUTU1?=
 =?utf-8?B?SFR4MjhuM0tBdFpQd1gwMDd6NVVMMGZOTTdSZURybDdyQTBFVzh5Q3JhUG96?=
 =?utf-8?B?SXRrSWpqT1JPUFZYdmlaV0hvWHpodW5EVzVST3V3SmdhWjFaRjNVbVJmTEJr?=
 =?utf-8?B?eGpPK1BtdXdvT2lpRnVYTmFraGdacFpiR2dGczdOSFc4WUVXL2lhSnA4SnRS?=
 =?utf-8?B?SndVMWI2WVpPQXVQMkU4WXhjaWJzVHRaUzdqcVkzdEo3bnErZGJCY1JWNHRt?=
 =?utf-8?B?WGFmOEhLT2k1c1FBcG9OT2dERzZvYWx5OGpQdHRNVXJaM1h0SGhHeVNoZUlY?=
 =?utf-8?B?MjBjSmwrRU4zSmZNc01YYXRQdHNoSytQNjhYSUhUY3pndnpVZTVGZDkwUEZ2?=
 =?utf-8?B?ellSVVg4RDYxMFJ5VkUrb2YyTnlBR0Z5UW1ZTitjUlVhYTBLSWd3cWVlSEYr?=
 =?utf-8?B?VDdZeDEyQVhwQjlwaUVnbnkrRCtHaER6NE1yK2dPREdtWi9QYkhYOU94K1FE?=
 =?utf-8?B?N2lub3pJSGFWN1BFZSs5ck9SbGQ1VVhjalR3TmFQMkliOEZCR1RrbmQ4LzBw?=
 =?utf-8?B?NWlMcDNNUnZIQ2xmMVVlbGFLekp5RnlPcFNQR3k1TjM1MitoNUNMRzkyQUJw?=
 =?utf-8?B?UkRwWVhMbnRFYlhEOVRuVk9LUnFyR1BHZlVlTnRWM1FadW1FWlhKN1JCNnlk?=
 =?utf-8?B?SmovcnRjbHljV2h0NFA1anJobDZHU0UvYTc1bVhqK0VpZFdhMjVkN2JHWXFE?=
 =?utf-8?B?RXQrR3FUV2hXT0FYTVg0dE5SUXR5OXhIYk1Ib3RwT291SDluaUhHenlxZURY?=
 =?utf-8?B?bUF0ZG93TG9rTHM5V1ppbXJOVi9rSVZGUk1oKzgza2IrVklleE95alFNT3kz?=
 =?utf-8?B?WXY2SGdEQ1lHQktYbk5rU1pQcktVQjZDcWlNdE5hTEhWUFd3dGFUNzhCSVJh?=
 =?utf-8?B?M2MrOGQ0OHVpSklsdXlIZzNKekEzZG4vQkllTi8rd3k4blp0SVVqOURFUE85?=
 =?utf-8?B?U21DMWtaTTlvL2FxanBhSCtXUGVkUU1Qa2wrd0FDV05HNTZGZEc5V2RWNWdi?=
 =?utf-8?B?bWFidGJZd1M3VW02OHd4WnVHRk5xRTU4clU5cnlUeVUzc2JSOWM0K1dUamdm?=
 =?utf-8?B?MjAyWEphUW9YT0NSczNXWDRGWnFaL1dIemQxdmhmL3lZbnQycFZZdWFoUFJD?=
 =?utf-8?B?aUxwbWFWcURPV3FYMStGR0xHZDBZTHBpeEhmMCtkamV2MXNRM1VUMlJqR1JK?=
 =?utf-8?B?UHllS2xNY2JCb1piMXJXbE5nYUZjVFdRV3F5dld6TDlDWTU4clVWbmJ2S1Vr?=
 =?utf-8?B?cjZRQWNiOUFPWUVxOHU2U3EwWjd5R0RNLzVDNTEwelFEVTFNWjJ0TytwT2dm?=
 =?utf-8?B?aUhmRFoxSjg1Q2Z6UUl5Y0JHb1hwYVl3QmQzbDVKRERSOE00UTJmSFEzUGJO?=
 =?utf-8?B?UjJKTTZvMHJ4Q3FBNmxsQzljK0RybzU1czVyZ05RWUxUbm96MEsyb09GK1JB?=
 =?utf-8?B?UDdnb2ZaK0RqUDBhWXpwdHBRc1FEbzdnOG9VTkpGUzc3em12ZmhnZ2tUUEow?=
 =?utf-8?Q?ayV3za+nk4u9BaV+/sYfILA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <513FE518FD5EED43995BF9DB091D1040@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xdigAKkmzXRYF7YZihTwS2hoPo47279YNn6koig7cDIsix3acxsUlDmqVfIed1+NksJJqb2OJhK17PVRqLZhLD9vMTIo863PgJ6wFZd9RyjeIUonAXwU+kQv8S6RRLfeoGSTZswcwnpWTrh5MGu1Mv1ugOTbKL/JqtnkI808CLAlE4jYZqenL0sn9NbloBNIZHQfVWmx+Aa9dYwPW5FgOCjmNhMLaBjZ4dzv2wqTDjKF3CKEEZ3yBIfxlYL2LnqaNBMVyLSx3kN7Co+F1kAOuXqqMdgWmJ+DYiAXIKQZUiQ3d1onAr2alU2jtzaJEoSdRwoCXyETSUTL8jIADvSXsTIWaP0mMqkiuLmqzz9FTNFLeR2seEDwu70e1x77xHnpuTEZMG/GAYkaXBFbQ6pZEay7RKfLS5ekKyEd/FYX3tBH7KwIGASqWtTFv7aAy2B2ZSjEe5NbH480oOnR4vzckYub3brUCX1oc+QWP9iOUlD/lUNmEryMkZPsztDQEOcjJ6MECOMKjwdNY1sxZuOCfRWmbPU9dXFFxdsjtfZZT/BjHeNBlYKomHil/73aj33ZIvbyjJvh+h+9q3SGEpVawdOR5GDbw2DrxUbsPT4A6rK5Ld2Zrxs7FgHZUqDRl5oZeMIdq7m46u5k0hYmpfm40FR23WU4Ay0NU2CjZ/iXbqvNTR8rWyRU/FykalSDh9amPaorHWX71e3xv2nT/ztd5pX8MOkugXQgXdm5eZhH2ogLktJe9o3/hOZ/347UsKy37XL4TtAF+NYrkmamZj9FoqgQ/F+CU5wul1BZz/veLq4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144f0724-d500-409a-5641-08db83d024d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 18:36:59.7401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RyhihWRMFhIge3C0+K/HXsZu9OLi56GXgGwll8Il2YH5ZsFt2zc3BhUpLQ5uHJUqCHXb3ZOl7Ex9Yc8jVjNQNGgjbRvDUzscMYe77B9tOZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5091
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_07,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307130165
X-Proofpoint-ORIG-GUID: yMENvO0zNCyqrBRDy8D_K0uFXU3p803e
X-Proofpoint-GUID: yMENvO0zNCyqrBRDy8D_K0uFXU3p803e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gSnVsIDEyLCAyMDIzLCBhdCAyOjA1IEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IFN5c3RlbSBjcmFzaCB3aGVuIHVzaW5nIGRlYnVnIGtlcm5lbCBkdWUN
Cj4gdG8gbGluayBsaXN0IGNvcnJ1cHRpb24uIFRoZSBjYXVzZSBvZiB0aGUgbGluayBsaXN0IGNv
cnJ1cHRpb24NCj4gaXMgZHVlIHRvIHNlc3Npb24gZGVsZXRpb24gd2FzIGFsbG93ZWQgdG8gcXVl
dWUgdXAgdHdpY2UuDQo+IEhlcmUncyB0aGUgaW50ZXJuYWwgdHJhY2UgdGhhdCBzaG93IHRoZSBz
YW1lIHBvcnQgd2FzIGFsbG93ZWQgdG8gZG91YmxlDQo+IHF1ZXVlIGZvciBkZWxldGlvbiBvbiBk
aWZmZXJlbnQgY3B1Lg0KPiANCj4gMjA4MDg2ODM5NTYgMDE1IHFsYTJ4eHggWzAwMDA6MTM6MDAu
MV0tZTgwMTo0OiBTY2hlZHVsaW5nIHNlc3MgZmZmZjkzZWJmOTMwNjgwMCBmb3IgZGVsZXRpb24g
NTA6MDY6MGU6ODA6MTI6NDg6ZmY6NTAgZmM0X3R5cGUgMQ0KPiAyMDgwODY4Mzk1NyAwMjcgcWxh
Mnh4eCBbMDAwMDoxMzowMC4xXS1lODAxOjQ6IFNjaGVkdWxpbmcgc2VzcyBmZmZmOTNlYmY5MzA2
ODAwIGZvciBkZWxldGlvbiA1MDowNjowZTo4MDoxMjo0ODpmZjo1MCBmYzRfdHlwZSAxDQo+IA0K
PiBNb3ZlIHRoZSBjbGVhcmluZy9zZXR0aW5nIG9mIGRlbGV0ZWQgZmxhZyBsb2NrLg0KPiANCj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gRml4ZXM6IDcyNmI4NTQ4NzA2NyAo4oCccWxh
Mnh4eDogQWRkIGZyYW1ld29yayBmb3IgYXN5bmMgZmFicmljIGRpc2NvdmVyeeKAnSkNCj4gU2ln
bmVkLW9mZi1ieTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiAtLS0NCj4gZHJpdmVy
cy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyAgIHwgMTYgKysrKysrKysrKysrKystLQ0KPiBkcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMgfCAxNCArKysrKysrLS0tLS0tLQ0KPiAyIGZp
bGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyBiL2RyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV9pbml0LmMNCj4gaW5kZXggYjIyYjA1MTZkYTI5Li5mOGY2NGVkNGRlMDcgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gKysrIGIvZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiBAQCAtNTA4LDYgKzUwOCw3IEBAIHN0YXRp
Yw0KPiB2b2lkIHFsYTI0eHhfaGFuZGxlX2FkaXNjX2V2ZW50KHNjc2lfcWxhX2hvc3RfdCAqdmhh
LCBzdHJ1Y3QgZXZlbnRfYXJnICplYSkNCj4gew0KPiBzdHJ1Y3QgZmNfcG9ydCAqZmNwb3J0ID0g
ZWEtPmZjcG9ydDsNCj4gKyB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiANCj4gcWxfZGJnKHFsX2Ri
Z19kaXNjLCB2aGEsIDB4MjBkMiwNCj4gICAgIiVzICU4cGhDIERTICVkIExTICVkIHJjICVkIGxv
Z2luICVkfCVkIHJzY24gJWR8JWQgbGlkICVkXG4iLA0KPiBAQCAtNTIyLDkgKzUyMywxNSBAQCB2
b2lkIHFsYTI0eHhfaGFuZGxlX2FkaXNjX2V2ZW50KHNjc2lfcWxhX2hvc3RfdCAqdmhhLCBzdHJ1
Y3QgZXZlbnRfYXJnICplYSkNCj4gcWxfZGJnKHFsX2RiZ19kaXNjLCB2aGEsIDB4MjA2NiwNCj4g
ICAgIiVzICU4cGhDOiBhZGlzYyBmYWlsOiBwb3N0IGRlbGV0ZVxuIiwNCj4gICAgX19mdW5jX18s
IGVhLT5mY3BvcnQtPnBvcnRfbmFtZSk7DQo+ICsNCj4gKyBzcGluX2xvY2tfaXJxc2F2ZSgmdmhh
LT53b3JrX2xvY2ssIGZsYWdzKTsNCj4gLyogZGVsZXRlZCA9IDAgJiBsb2dvdXRfb25fZGVsZXRl
ID0gZm9yY2UgZncgY2xlYW51cCAqLw0KPiAtIGZjcG9ydC0+ZGVsZXRlZCA9IDA7DQo+ICsgaWYg
KGZjcG9ydC0+ZGVsZXRlZCA9PSBRTEFfU0VTU19ERUxFVEVEKQ0KPiArIGZjcG9ydC0+ZGVsZXRl
ZCA9IDA7DQo+ICsNCj4gZmNwb3J0LT5sb2dvdXRfb25fZGVsZXRlID0gMTsNCj4gKyBzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZ2aGEtPndvcmtfbG9jaywgZmxhZ3MpOw0KPiArDQo+IHFsdF9zY2hl
ZHVsZV9zZXNzX2Zvcl9kZWxldGlvbihlYS0+ZmNwb3J0KTsNCj4gcmV0dXJuOw0KPiB9DQo+IEBA
IC0xNDQ2LDcgKzE0NTMsNiBAQCB2b2lkIF9fcWxhMjR4eF9oYW5kbGVfZ3BkYl9ldmVudChzY3Np
X3FsYV9ob3N0X3QgKnZoYSwgc3RydWN0IGV2ZW50X2FyZyAqZWEpDQo+IA0KPiBzcGluX2xvY2tf
aXJxc2F2ZSgmdmhhLT5ody0+dGd0LnNlc3NfbG9jaywgZmxhZ3MpOw0KPiBlYS0+ZmNwb3J0LT5s
b2dpbl9nZW4rKzsNCj4gLSBlYS0+ZmNwb3J0LT5kZWxldGVkID0gMDsNCj4gZWEtPmZjcG9ydC0+
bG9nb3V0X29uX2RlbGV0ZSA9IDE7DQo+IA0KPiBpZiAoIWVhLT5mY3BvcnQtPmxvZ2luX3N1Y2Mg
JiYgIUlTX1NXX1JFU1ZfQUREUihlYS0+ZmNwb3J0LT5kX2lkKSkgew0KPiBAQCAtNjA5MCw2ICs2
MDk2LDggQEAgcWxhMngwMF9yZWdfcmVtb3RlX3BvcnQoc2NzaV9xbGFfaG9zdF90ICp2aGEsIGZj
X3BvcnRfdCAqZmNwb3J0KQ0KPiB2b2lkDQo+IHFsYTJ4MDBfdXBkYXRlX2ZjcG9ydChzY3NpX3Fs
YV9ob3N0X3QgKnZoYSwgZmNfcG9ydF90ICpmY3BvcnQpDQo+IHsNCj4gKyB1bnNpZ25lZCBsb25n
IGZsYWdzOw0KPiArDQo+IGlmIChJU19TV19SRVNWX0FERFIoZmNwb3J0LT5kX2lkKSkNCj4gcmV0
dXJuOw0KPiANCj4gQEAgLTYwOTksNyArNjEwNywxMSBAQCBxbGEyeDAwX3VwZGF0ZV9mY3BvcnQo
c2NzaV9xbGFfaG9zdF90ICp2aGEsIGZjX3BvcnRfdCAqZmNwb3J0KQ0KPiBxbGEyeDAwX3NldF9m
Y3BvcnRfZGlzY19zdGF0ZShmY3BvcnQsIERTQ19VUERfRkNQT1JUKTsNCj4gZmNwb3J0LT5sb2dp
bl9yZXRyeSA9IHZoYS0+aHctPmxvZ2luX3JldHJ5X2NvdW50Ow0KPiBmY3BvcnQtPmZsYWdzICY9
IH4oRkNGX0xPR0lOX05FRURFRCB8IEZDRl9BU1lOQ19TRU5UKTsNCj4gKw0KPiArIHNwaW5fbG9j
a19pcnFzYXZlKCZ2aGEtPndvcmtfbG9jaywgZmxhZ3MpOw0KPiBmY3BvcnQtPmRlbGV0ZWQgPSAw
Ow0KPiArIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnZoYS0+d29ya19sb2NrLCBmbGFncyk7DQo+
ICsNCj4gaWYgKHZoYS0+aHctPmN1cnJlbnRfdG9wb2xvZ3kgPT0gSVNQX0NGR19OTCkNCj4gZmNw
b3J0LT5sb2dvdXRfb25fZGVsZXRlID0gMDsNCj4gZWxzZQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3Rh
cmdldC5jDQo+IGluZGV4IDUyNThiMDc2ODdhOS4uMmI4MTVhOTkyOGVhIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMNCj4gKysrIGIvZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX3RhcmdldC5jDQo+IEBAIC0xMDY4LDEwICsxMDY4LDYgQEAgdm9pZCBxbHRf
ZnJlZV9zZXNzaW9uX2RvbmUoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiAoc3RydWN0IGlt
bV9udGZ5X2Zyb21faXNwICopc2Vzcy0+aW9jYiwgU1JCX05BQ0tfTE9HTyk7DQo+IH0NCj4gDQo+
IC0gc3Bpbl9sb2NrX2lycXNhdmUoJnZoYS0+d29ya19sb2NrLCBmbGFncyk7DQo+IC0gc2Vzcy0+
ZmxhZ3MgJj0gfkZDRl9BU1lOQ19TRU5UOw0KPiAtIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnZo
YS0+d29ya19sb2NrLCBmbGFncyk7DQo+IC0NCj4gc3Bpbl9sb2NrX2lycXNhdmUoJmhhLT50Z3Qu
c2Vzc19sb2NrLCBmbGFncyk7DQo+IGlmIChzZXNzLT5zZV9zZXNzKSB7DQo+IHNlc3MtPnNlX3Nl
c3MgPSBOVUxMOw0KPiBAQCAtMTA4MSw3ICsxMDc3LDYgQEAgdm9pZCBxbHRfZnJlZV9zZXNzaW9u
X2RvbmUoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiANCj4gcWxhMngwMF9zZXRfZmNwb3J0
X2Rpc2Nfc3RhdGUoc2VzcywgRFNDX0RFTEVURUQpOw0KPiBzZXNzLT5md19sb2dpbl9zdGF0ZSA9
IERTQ19MU19QT1JUX1VOQVZBSUw7DQo+IC0gc2Vzcy0+ZGVsZXRlZCA9IFFMQV9TRVNTX0RFTEVU
RUQ7DQo+IA0KPiBpZiAoc2Vzcy0+bG9naW5fc3VjYyAmJiAhSVNfU1dfUkVTVl9BRERSKHNlc3Mt
PmRfaWQpKSB7DQo+IHZoYS0+ZmNwb3J0X2NvdW50LS07DQo+IEBAIC0xMTMzLDEwICsxMTI4LDE1
IEBAIHZvaWQgcWx0X2ZyZWVfc2Vzc2lvbl9kb25lKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykN
Cj4gDQo+IHNlc3MtPmV4cGxpY2l0X2xvZ291dCA9IDA7DQo+IHNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJmhhLT50Z3Quc2Vzc19sb2NrLCBmbGFncyk7DQo+IC0gc2Vzcy0+ZnJlZV9wZW5kaW5nID0g
MDsNCj4gDQo+IHFsYTJ4MDBfZGZzX3JlbW92ZV9ycG9ydCh2aGEsIHNlc3MpOw0KPiANCj4gKyBz
cGluX2xvY2tfaXJxc2F2ZSgmdmhhLT53b3JrX2xvY2ssIGZsYWdzKTsNCj4gKyBzZXNzLT5mbGFn
cyAmPSB+RkNGX0FTWU5DX1NFTlQ7DQo+ICsgc2Vzcy0+ZGVsZXRlZCA9IFFMQV9TRVNTX0RFTEVU
RUQ7DQo+ICsgc2Vzcy0+ZnJlZV9wZW5kaW5nID0gMDsNCj4gKyBzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZ2aGEtPndvcmtfbG9jaywgZmxhZ3MpOw0KPiArDQo+IHFsX2RiZyhxbF9kYmdfZGlzYywg
dmhhLCAweGYwMDEsDQo+ICAgICJVbnJlZ2lzdHJhdGlvbiBvZiBzZXNzICVwICU4cGhDIGZpbmlz
aGVkIGZjcF9jbnQgJWRcbiIsDQo+IHNlc3MsIHNlc3MtPnBvcnRfbmFtZSwgdmhhLT5mY3BvcnRf
Y291bnQpOw0KPiBAQCAtMTE4NSwxMiArMTE4NSwxMiBAQCB2b2lkIHFsdF91bnJlZ19zZXNzKHN0
cnVjdCBmY19wb3J0ICpzZXNzKQ0KPiAqIG1hbmFnZW1lbnQgZnJvbSBiZWluZyBzZW50Lg0KPiAq
Lw0KPiBzZXNzLT5mbGFncyB8PSBGQ0ZfQVNZTkNfU0VOVDsNCj4gKyBzZXNzLT5kZWxldGVkID0g
UUxBX1NFU1NfREVMRVRJT05fSU5fUFJPR1JFU1M7DQo+IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
JnNlc3MtPnZoYS0+d29ya19sb2NrLCBmbGFncyk7DQo+IA0KPiBpZiAoc2Vzcy0+c2Vfc2VzcykN
Cj4gdmhhLT5ody0+dGd0LnRndF9vcHMtPmNsZWFyX25hY2xfZnJvbV9mY3BvcnRfbWFwKHNlc3Mp
Ow0KPiANCj4gLSBzZXNzLT5kZWxldGVkID0gUUxBX1NFU1NfREVMRVRJT05fSU5fUFJPR1JFU1M7
DQo+IHFsYTJ4MDBfc2V0X2ZjcG9ydF9kaXNjX3N0YXRlKHNlc3MsIERTQ19ERUxFVEVfUEVORCk7
DQo+IHNlc3MtPmxhc3RfcnNjbl9nZW4gPSBzZXNzLT5yc2NuX2dlbjsNCj4gc2Vzcy0+bGFzdF9s
b2dpbl9nZW4gPSBzZXNzLT5sb2dpbl9nZW47DQo+IC0tIA0KPiAyLjIzLjENCj4gDQoNCkxvb2tz
IEdvb2QuIA0KDQpSZXZpZXdlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFu
aUBvcmFjbGUuY29tPg0KDQotLSANCkhpbWFuc2h1IE1hZGhhbmkgT3JhY2xlIExpbnV4IEVuZ2lu
ZWVyaW5nDQoNCg==
