Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AB1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 17:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351604AbiBCRXQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 12:23:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30682 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231389AbiBCRXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 12:23:15 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 213HKtNW020585;
        Thu, 3 Feb 2022 09:23:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=yvUWJqMfsSwPQKo18bJhoegbjawAt5Y2tF6mdrauLNg=;
 b=j3K16vhf0LHIm2XmuAl0Ep+dVbrWeN+xqU1TraaFfh7u0Ua+yv0SMo149ZNP4UzpOAh/
 PG1+6BCOC8t1jFK2FsmqAIiTvdfm6AGn1Qk1WDsL42LHy4+0hBcABGxJg+UXJyIvx/YU
 5qo1/s3MONIGwWgzIbyjZ9xC6fnjoi8HCkk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e05sncne4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 03 Feb 2022 09:23:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Feb 2022 09:23:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1qBRnKkmlbAOfK4LFYMiqxZsvoff8wHA0NKOkUXMJEtejELsZeUC0Y/7OpbHWNO9mC4z47lp747luYWjgE1CmfWi5UHvkiLOhOpjwSXt7KlE9GeXpsiN2nVluahvLpfuTgb0OBxuSF6yU4x7VgyIE98Btgg6hZ0psxDwZnPAigvNKVy3r3rhS/LhLZCtsPn1wKCllM/IWBft59jZ2ZZAYMHcA/Oh6E6oOaBMsMERK/X0M6Rnmd+9IvYFEHMLzj3jBd1qTMvN6188TUf5iWMabtdCQTlSZbbJ3kX+PDJYYoYuJeixPAYF7Ckcda1cTsZKf1YfKD/NcBfCaOQsU6VjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvUWJqMfsSwPQKo18bJhoegbjawAt5Y2tF6mdrauLNg=;
 b=av/Ewd32YqH5TnAyam/FshU06gU/WKvJKftHx/O7h5p3Q2b6c7nSeuQ0nZZi7Fb+uyNyWIdhXPr1eiHsbUXJbu03q892Qo87VSwaScFcjbQ5BraB0a4ts9zViDS7oOoneENGZkorWi621odlQ5sYa1Cl6LGHASlM48VPNFKeX2MGtYn6gUyYdmcXugi4NIjQIhSThM4iddlk18V1DjUbbT4M//EHLI7BLZWx0qgh4fRpjv67iOxAT80VXJ6BIWE8+/PvrD1+XxoUifVuCwqvpmY0jdOxZ74Z1IK5paSKRk61RY30QD34OHSpL5csEO7JTkVlBPZIebUXggRZpEqh+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CY4PR15MB1622.namprd15.prod.outlook.com (2603:10b6:903:134::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 17:23:09 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e%4]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 17:23:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Hannes Reinecke <hare@suse.de>, Song Liu <song@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] block: introduce BLK_STS_OFFLINE
Thread-Topic: [PATCH 1/2] block: introduce BLK_STS_OFFLINE
Thread-Index: AQHYGMjwyuZSzyBrcUKDpa/SuWPXVqyBY7UAgAAIyICAAGr/gIAAPF4A
Date:   Thu, 3 Feb 2022 17:23:09 +0000
Message-ID: <C3D342B9-C4D0-4C3A-9582-EB15A5F5D7FF@fb.com>
References: <20220203064009.1795344-1-song@kernel.org>
 <20220203064009.1795344-2-song@kernel.org>
 <CAPhsuW6PNaYUb5xDxPX_gX=2fZdiRURRos5sT_Tsbngon1+eKw@mail.gmail.com>
 <f7489746-b8fb-bc9a-a706-e5926fa9e325@suse.de>
 <27583256-dc7d-74bd-115c-b0c835cd5c1b@kernel.dk>
In-Reply-To: <27583256-dc7d-74bd-115c-b0c835cd5c1b@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5361531-37ac-44c6-242c-08d9e739d982
x-ms-traffictypediagnostic: CY4PR15MB1622:EE_
x-microsoft-antispam-prvs: <CY4PR15MB1622F137B47894D74FE4701BB3289@CY4PR15MB1622.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jABASh8CkDp+iiot1USThRfKiN+tQ+HJuoLp1eRNmJCOrWQuIdbQYbLL9pSZZWogSDfWfW39ed++Qzzl+xP5DGodeY/cMQoBmDF/3VLFlStZZqn7Oq9hX9ksZ5OcBsC2IM90W2iaQ3asbZ1tpWMGV6QcyI9lTgAXVFIu2yAb9ZcJthi4BjJdRFOQUq4u+TXsiRx1AW+P4/6Feq854+loiyiZCgsimjeFCwIg9esgpoknxgycng73e7K1OJTGRjpu2tTE6908el0M9614sLY1WRVlbfKOL59CR8qBBTo3W5G86SSL6IKlZS7Fzv9bpjfGS+MtKwvht2NqOuuUA/PF/FEsJde5S/VbDhDDQtARbMQbORvAdWCv++ENQxx0ny4onOWf1huEYAdBwejMXuZlz7LCTSn/f+AuepbHJ9hxon8DVfdrigFDFj6V7d8XG1FFsXp6rh4V1jGsbsC+nRHY/56wYV5k2aF6NtOBJGNVcpbt82fTUwViSgysfoYkvM3O198EnyYS9yl9TcN5ONS7ceRIZ0hOvdjMpkXvkUQatTjsaFkFzHf4kikVuEyMUb3wJvAvFTX3NzoBtf2mDQKacforoBf7Du2eYvh7Ugb23kTC5WYWGykGr4Nr5jc9UMPgkI17/lt7YH6u5hErDycgTciqjoWrctR2QjGuH0ZAtGgg/Ha8SjSycc47vDuf2Na/QgnDyORYKZaEVu3hR4J9MBGRyw3WH+ZTSmTxCs6OfYESzuxk8h6/Y8roDFXb1lhk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6916009)(38100700002)(508600001)(6512007)(316002)(86362001)(36756003)(38070700005)(6486002)(33656002)(8936002)(8676002)(66476007)(66556008)(71200400001)(66946007)(91956017)(76116006)(83380400001)(6506007)(186003)(122000001)(2616005)(2906002)(4326008)(66446008)(53546011)(64756008)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t0FbustmxuO9cR6w9tRzdYnUm0FD0/X0a8s/OogNA1FlsA5Kpi0icaelMoEm?=
 =?us-ascii?Q?+V320/ETQZwwfcc/Abt6HmXE0BBoqp6/Fcbou/JVKkdPG6sNv6G1YCSmdnV4?=
 =?us-ascii?Q?MmWsrnyqWN/OuzewcWXBCfm4UBJr9fMZltgplqQixTCL8H3jFBIadx8KlPFQ?=
 =?us-ascii?Q?lB0jWpIuq47SuoC+kpUlAQNOLC+enWvcFs42hvQzECqq+hBK66ZTpjLJ6IpO?=
 =?us-ascii?Q?Gfs/XR1ANsewUP2YEO7wykXbkoJR3fs5WbES8YJOLpCEna2AqttaH3nEQwjK?=
 =?us-ascii?Q?oWg3x/Coazov2ouhVB7OlX1/HPpJVJ4ppxdu3NU6A3Yfd3jCwNa/juPTxdtY?=
 =?us-ascii?Q?XyPEsYYDohKm/h150XjfITSV28ViBvVvoGXUxTkhpzh8k7ukm9CPwN9hnc3M?=
 =?us-ascii?Q?OSVD06rEU20cDy9L4H3efWa9hqYHNb6e2MUu9jJPBTy3x4BO77Fg3vTGl21t?=
 =?us-ascii?Q?2jKwvwFJlkMua7oXhdU/MTlbk1nCEuMdPuhCsxoSq7lhKjY8HdcIBZE4FtKm?=
 =?us-ascii?Q?cvCsOJFiUOf2L3o8jU9EwswxbmaPQKEfsryNjA8qfejmP7tPXZ2QHEMke04U?=
 =?us-ascii?Q?K3u42spotH842H/+0AXDlEW2PXLqUwXhO1BszKt4ZvDZTi0jo7tMOGEQmjfA?=
 =?us-ascii?Q?lUpzI4Abc4cYhZybWz89MYqkBmcIaQxWN0oyd00fUZZGdOjt+pXd9KlWKhZ7?=
 =?us-ascii?Q?HhjHZLrwrMn0HHRmtVO+ZAx9uOxhhVc4cdaAdp/pOVcAJAljC5C+QV/2T6J3?=
 =?us-ascii?Q?86drTnFNbLUv81VREtU8CcOfIpY+6kVcIlsOeUuITOc7ylbvvCLq3Nk+jam4?=
 =?us-ascii?Q?bz/ncHPe1I4Qx31gUzBkBKdSvwpZiM3axXl/4UdKYjSPGWM6AQ4NBF+lsMZ3?=
 =?us-ascii?Q?e9zu/NVYtwPCSliHMXwA016lu68aoKVbJf25P0cvpjZ+uKt/mrJI30vUERCn?=
 =?us-ascii?Q?tG4B/qg4g30qPNgl4Ggc1zTLawrzbq6Ojn9fj+ovXecwQxkOQUFmTUWlr+sB?=
 =?us-ascii?Q?lREOBSbenI4xSjqNbdZgXUWQZTdB5fKMZuN8xrtVCI6UEYkGbf+8YArx1ZFx?=
 =?us-ascii?Q?GghLglAQQTKFU0kMPZfYF3DFQE5vdi8e5dhzagtlDckrbqlkQbph9InQ1DQw?=
 =?us-ascii?Q?C6P5nVNtQP7bpWPBM/wGrUXjQDEMRsNs2cVqfO3cuJ7s6p0koxYCgXN6bRXU?=
 =?us-ascii?Q?Ddtn8cLOsX+dMw8AcIwfSxPeepcED7lcuvMsBcdvwylpih/Cic9gOnKFa/vw?=
 =?us-ascii?Q?5hKqbBX9sj0LQ14YYMtkTeeL9wHaRlwipQUcwFknhXiFW0m4y7pnsus8Mg8b?=
 =?us-ascii?Q?+IUuQnLqqcULMkpez9SEPLuxabTPTs6DnFF2fI8OQCLcyAm7X44RnKPm1iiw?=
 =?us-ascii?Q?hYxVpX3btBmi+lRhY8B4G9QGXsHhOZLXAXhhPWdW6eAOg/UNUBpB8EzV2i2p?=
 =?us-ascii?Q?+hFhdCvG+BnGldN1NI9QNfXmyvsMF/tzeAp7CSgNkm3L/Yj/3OTEdDgz5oc+?=
 =?us-ascii?Q?Ct7MbuIGCLssAvbj7nPoFDy2+bc3xI5jwSvG6UhBkXRCIhmzx2ZyG4k2F+yE?=
 =?us-ascii?Q?ZexggSj1/003X2O9gmVz4bGM/vg1HfJiysI/3qRSe4mnjDgHIILHigRD//Kw?=
 =?us-ascii?Q?4v7rsVOe656AzPhacgKc1Fwcd2OJF4ncR7eJ5kxnen0uvzAPIGbGHR5WEfx9?=
 =?us-ascii?Q?5REQ7A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B31EEF27F1AC97419DA69F1812ADE441@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5361531-37ac-44c6-242c-08d9e739d982
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 17:23:09.7191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mNI2/YaUBSpEmQCJvA6RT3w5RICnmZoZJkwOvfvLXrf7XsEogbkU6NML1/LWZRDcGy8gxIxMEr+QTJKMO3OC/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1622
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 9mBVDmm3jni78MlNBDxaWRRhhqaym1WP
X-Proofpoint-GUID: 9mBVDmm3jni78MlNBDxaWRRhhqaym1WP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_06,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1011
 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes and Jens,

> On Feb 3, 2022, at 5:47 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 2/3/22 12:24 AM, Hannes Reinecke wrote:
>> On 2/3/22 07:52, Song Liu wrote:
>>> CC linux-block (it was a typo in the original email)
>>> 
>>> On Wed, Feb 2, 2022 at 10:40 PM Song Liu <song@kernel.org> wrote:
>>>> 
>>>> Currently, drivers reports BLK_STS_IOERR for devices that are not full
>>>> online or being removed. This behavior could cause confusion for users,
>>>> as they are not really I/O errors from the device.
>>>> 
>>>> Solve this issue with a new state BLK_STS_OFFLINE, which reports "device
>>>> offline error" in dmesg instead of "I/O error".
>>>> 
>>>> Signed-off-by: Song Liu <song@kernel.org>
>>>> ---
>>>>  block/blk-core.c          | 1 +
>>>>  include/linux/blk_types.h | 7 +++++++
>>>>  2 files changed, 8 insertions(+)
>>>> 
>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>> index 61f6a0dc4511..24035dd2eef1 100644
>>>> --- a/block/blk-core.c
>>>> +++ b/block/blk-core.c
>>>> @@ -164,6 +164,7 @@ static const struct {
>>>>         [BLK_STS_RESOURCE]      = { -ENOMEM,    "kernel resource" },
>>>>         [BLK_STS_DEV_RESOURCE]  = { -EBUSY,     "device resource" },
>>>>         [BLK_STS_AGAIN]         = { -EAGAIN,    "nonblocking retry" },
>>>> +       [BLK_STS_OFFLINE]       = { -EIO,       "device offline" },
>>>> 
>>>>         /* device mapper special case, should not leak out: */
>>>>         [BLK_STS_DM_REQUEUE]    = { -EREMCHG, "dm internal retry" },
>>>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>>>> index fe065c394fff..5561e58d158a 100644
>>>> --- a/include/linux/blk_types.h
>>>> +++ b/include/linux/blk_types.h
>>>> @@ -153,6 +153,13 @@ typedef u8 __bitwise blk_status_t;
>>>>   */
>>>>  #define BLK_STS_ZONE_ACTIVE_RESOURCE   ((__force blk_status_t)16)
>>>> 
>>>> +/*
>>>> + * BLK_STS_OFFLINE is returned from the driver when the target device is offline
>>>> + * or is being taken offline. This could help differentiate the case where a
>>>> + * device is intentionally being shut down from a real I/O error.
>>>> + */
>>>> +#define BLK_STS_OFFLINE                ((__force blk_status_t)17)
>>>> +
>>>>  /**
>>>>   * blk_path_error - returns true if error may be path related
>>>>   * @error: status the request was completed with
>>>> --
>>>> 2.30.2
>>>> 
>> Please do not overload EIO here.
>> EIO already is a catch-all error if we don't know any better, but for 
>> the 'device offline' case we do (or rather should).
>> Please map it onto 'ENODEV' or 'ENXIO'.
> 
> It's deliberately EIO as not to force a change in behavior. I don't mind
> using something else, but that should be a separate change then.

Thanks for these feedbacks. Shall I send v2 with an extra patch that 
changes EIO to ENODEV/ENXIO? Or shall we do that in a follow up patch? 
Also, any preference between ENODEV and ENXIO? 

Thanks,
Song
