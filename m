Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5BBC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 19:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiBITEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 14:04:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241733AbiBITDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 14:03:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD39FC03FEEE;
        Wed,  9 Feb 2022 11:01:51 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HFudE017462;
        Wed, 9 Feb 2022 19:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LRiwtWhQndIo/qhzD6BU0k1FMJGILxcumxx+QPczmQ8=;
 b=gczDKEwidFiX2hin2toRVWtrUyHLJjIc2u7nfGgncGMiUoGzqyi8g9pUClI2Al6dFdLc
 Q1iMhToEmJfeDII7QvasQAMcCJIzu03l0sNRWJqPNcB5sErbidTIWDQIABewZLajNznP
 XSgM+SeXbgwCZ7Tp/YefP/SdRZj2ReUfgweRFXrvuy/nCxEhxp2FDJGFvbVQZzhIvIDm
 ym24YcEGyTUwNzoQ++w1xgApUkGVoDj/OnqOOJgg/0OsjYslQWOtm4JhXLihO129s4/v
 h3sCCBVMi2woH43U55Kx0FV3g8JH7avXiqpXvy5Qo0xpQjFm+RXUfY3Jo4G5IEofhx1O 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28nfct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:01:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IptNl018269;
        Wed, 9 Feb 2022 19:01:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 3e1ec38140-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:01:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpTZJIMGwwLe+ItJ2EQbpF3YAeXFnXHrGHqJocUqhGkWRAxKjDLYqwyyQtmHyVd2MkoW6O2Cu1WyCNnx8/1HRiFDX7JVCjg0/JljPEnRafVvg4S6XHZvQ1woo/1opors3uxAQTI/WJ2MSM4WOOc105muOFxXKCYkVSHLggcwOcZbDXKaH/qA04zPrMdEDBCdHQEUwwT87/0hd8ApRC2Mp1UrsABYKcEWK8eVcPMepSJdsLCCM4ch8AUnzNTv9a/e3yImZXBS0PiJ9edffBi2DXFG3e/EfXDhijYGyd7ZO+5583khTbQWeMUFXo5Nb5bVN2U0K5KSLReLW0511vR4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRiwtWhQndIo/qhzD6BU0k1FMJGILxcumxx+QPczmQ8=;
 b=BHtl72GC0Ca+DomyGnwfuN0wYegL4MZt98kHnjFqfRGygyqk3XMPKVU1kVC8F5n7trjeqkj+Ii68koBnE2lnF3MCcl7GwXbVDkiofXn+kUYaowarJFFpa33UWmac1vPkfhwiSOh4cfA8nltaQG/0VIJJhcp/osH/AGCWCynQ1IAuzM4eFqaExpxBpDRiHCRGM8kvRXbvWoBzKw2AQ6+aYrbYJqz7tZUr5y1nckOH70s+qFTVqSaEtl88zZUV4fiokDSkg01Wwg2K7fU6SuCZlQDkU6OHzVfna1edpvg9byjRtPs71iK/vBvHtOApOnWkR9a6bKqOh+r6MAGZkN4TKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRiwtWhQndIo/qhzD6BU0k1FMJGILxcumxx+QPczmQ8=;
 b=ONmeW/U17blazCaSWSvIhNXcDyP3MxZwU2OUfFh1jweILpvq+OkK40Oe/qUx4iK2I7bDGj3pfgpFecSY66Uk8AEBOKJJf0W1+3prQS/Aetr9UMEEZ5oTQnTvvCqAfP3NYZuH+W40jiCJlciL3NlYJ907A3wiD0KI2U3hEfyhfxQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN4PR10MB5800.namprd10.prod.outlook.com (2603:10b6:806:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 19:01:17 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 19:01:17 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 40/44] scsi: usb: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 40/44] scsi: usb: Stop using the SCSI pointer
Thread-Index: AQHYHRFFAtJoDnCtS0e7IP97pdjGDqyLlLEA
Date:   Wed, 9 Feb 2022 19:01:17 +0000
Message-ID: <E3686D41-6609-4CA9-86BC-C49D39656889@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-41-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-41-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26001f15-b1c4-4c72-4c3e-08d9ebfe8d45
x-ms-traffictypediagnostic: SN4PR10MB5800:EE_
x-microsoft-antispam-prvs: <SN4PR10MB58003E95A8BA495A97E011F3E62E9@SN4PR10MB5800.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: muuc0ClQcq30Q73Y7p4wgdri0q7a0a/ZbKv0upK1rCZsYgsgWzOt4G2iVJ0H8TBchVbGd3EFa0hPfI7wmB8e0iLHB2PH4V3cnRSpaDyZkVDalopSrxUrymOBBarHXPzvJ2jOAkKfliVNF4EufckJ8y3doUW6d6lDBpeLgjMAo8F1+YX7yIhV2fqHGr8rDcSAucG32Jy1U6OYg2N7BUEK+85G8Erz8pk9YAtjXqc63DehzuCnQ0Pb+mp9H/LDOemLYVOH2ve2vICkq8KbTV0c1nKgvf9M8LsoJH05c8Rh1fJ5LI+tY1DYM6Nudfny8XuBSLjkUIgu9Xg8SIb2bTBpNC4OTBFWe1IJhurBAMDbDcZSmAPkn94HRO7kTi6DvAwvytJhKV5XOnPKeOStWfooE+2wXhofXJXQ92N14XpjNLLByXibpjGXya/UWN45KIjHUSLFqLRKnLUiBuVGDIS6QGxVeHC2PQTuvgtPuEXTath3ZzqGehVK6lTKjUDaOVsDu2eoFUuWE8MaFQ6Sbu3+5B4o5GAhwYiXHoaYhrA9E5VJeoYFeKNcVj/6ymUeg3787mjTvHIiH4DAE9qbw+VLfZfsPbY+0is2TEhD4P9GmSwxX5P8UW1jehOuZDME3SKLR+40wSFZdjhpoojVVQt37VrWbU3nJMcN8HBu2drlPBe3wVy0e7iWv9w4RvtdiAk+YmdeWaRQJwirsOobVNk2ZAJV3ek4ob4FQGUPxfFXDVw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(6512007)(36756003)(66476007)(2906002)(66556008)(4326008)(38100700002)(122000001)(5660300002)(2616005)(6506007)(71200400001)(66946007)(6486002)(64756008)(66446008)(76116006)(33656002)(6916009)(8676002)(53546011)(54906003)(8936002)(508600001)(186003)(38070700005)(44832011)(86362001)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2zw9KHHTPNXMSR+yBt8kWOL3pYciQhkuOXuBsDHACw3JBcU1jOF4M9Z+NXGC?=
 =?us-ascii?Q?1AmD52aq/pftRGX0uzZNAkWPGWL5wakP+EMUhclevktluuOyL2c10fVvAXFd?=
 =?us-ascii?Q?vTDAkz6UryyuldLEfJcjRZ2XgwuUsf75F4ydquiNb7axHQ9mqK2J7eoSOM5f?=
 =?us-ascii?Q?tbYQ/vQnRtptafk1433oFs00ALQTaIijJOQpLS5PAlgy6+1+lWzrBoSev219?=
 =?us-ascii?Q?8p4Ur6D11VGjmzBaLUrh4Jz4VIDwarBl6UagTTklQXDvvmhGyGqxZnV4I5b1?=
 =?us-ascii?Q?Q90D1Z5q7AdUwqRZ+Skng+TmR2Rbo6vH0J12AM1rcD+PNz91L0YBjP1ygT9b?=
 =?us-ascii?Q?px8Q7msio90nw4kgtOQn+p8BxBd0aDg056qklkOUhGs8E+SJMRxyIq+ui4V7?=
 =?us-ascii?Q?FY4k0LkKlz9JgdRZ0xEaS6wl2Mv4OvLtqcJsd7ZWDzonrS6GyTptei5odBpE?=
 =?us-ascii?Q?DqeJbxUS5/JsGli4ugc2Z6bN6eOXkD56j4qgHzgV5u0A2qmMUbWT6nKzD0D+?=
 =?us-ascii?Q?ZLiSL8GA0K1BbPilKPCVEBmf9XmRk2csubm0oiAnkUOLCEWDuK+gYRD3fn5G?=
 =?us-ascii?Q?yWWl5jP7pYsNl7Jx6NRO4HoRlvNC8rAkjhE9RzcqGvgY4os3NWu9J8OT+0Zp?=
 =?us-ascii?Q?aCzTb4SpyKvdyjqubodU4IDKcjYdOwUQynCkK0yDQ6s6OX6EoUhWvOmp/hFk?=
 =?us-ascii?Q?LrFDzIMDPVyVa425Fp/8A5felrnVr579IAyHMLGqOP3hufJSo2vfzGy1prWp?=
 =?us-ascii?Q?o3Abe69it39WOUrdz9vRKTRsIrpQdrcPufNZX6zoW4dSmmaYUJ+0FF2pQRBl?=
 =?us-ascii?Q?nrkLSgIFo7AJkIpTFLAgfaNBb/KqNrssLaL9iGSjdrBFPo9JTpHAtOT9gour?=
 =?us-ascii?Q?UR2GB4RYgVIGaEH0KHEm9am+6Vn2AF0FGyyG4s6FfqpZ7ra4get9Fq6IEkYv?=
 =?us-ascii?Q?Osy0we1CrUOFITjv3ILhVnAT1c901QOy7oqF8PxiZ7I87MoSiR7wyv0eSRUw?=
 =?us-ascii?Q?WRipM5/KMO0qwID2GDTC0b7/4Sxh9G0HvvBAMGnoAp6gIzfaBNg3GjwZP77u?=
 =?us-ascii?Q?i3DFe87hr912LG8ljsie0Mk79fx97VvuiNZ5+BObjjyIxm4DEYJrwIvh7fj8?=
 =?us-ascii?Q?pBDP/0Xka/fnPGErWKJCu83oN8//KlnRQXIzdOYXw6OTPjzfutIYjleuUDRQ?=
 =?us-ascii?Q?J8nRDNY+ksorNg39iGOo9g8ff9/2VjcDPAMURC6eSS6sT5g/GndbHl7WMqtd?=
 =?us-ascii?Q?5PNT1L5Q2SL/3UPhTVGkXXPFciQEO+q1Ymv252AppLcnq3/Tn5gDk2alge7u?=
 =?us-ascii?Q?5vcPfpx3NKRGpNjo7iwFL18AnuunDnMSTISVGIFJBoxcM5tZdY7rmIVh8mXf?=
 =?us-ascii?Q?Aqvvx+BCRB7Nbj1Xq/ocqegOvxqT88PTFcjSe048U3T8pmDuN6Ip04OwnMce?=
 =?us-ascii?Q?dd4aKLhrgeMnT9waGQes75998OVyuKUjbU1BdwuUGKRR00sItVZwhLSZM7Rl?=
 =?us-ascii?Q?it2EdeuPayo6s74eEotbe5ryMVEAzz5ILrUuSHuT8qNR0vE3FrG344FhJK9X?=
 =?us-ascii?Q?R0wye0aJPTA2z6EhMt41wlvwLNPT7/RLZfIPbYfXbgVeQTA9wP1uH28717da?=
 =?us-ascii?Q?7w26gfdEfpxmxJVHpiUuItDsUJ/3JklHr7bofzYg04/ifIpXngz6VqzPMWt0?=
 =?us-ascii?Q?lSxCWlHYv1kjl7+xo+Q2r30hthBwydZGLWzq0VwvxqBbtmHk?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <217AD80DFA90EC438797482E56AB8BF0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26001f15-b1c4-4c72-4c3e-08d9ebfe8d45
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 19:01:17.2891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fFAZRaTwVwsj5hlBLoxdhk8RrFn5sYbMoKos+i2CrSBIK/OpWfamvbTtmZ/Kq2mvjBPltQ1yXGi9mBEKoonZ7UHmt2N/Imny/reHboi7R38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5800
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090099
X-Proofpoint-ORIG-GUID: tV-GlXLqDf2pJ5JSkm3a-PpC03DgudQ1
X-Proofpoint-GUID: tV-GlXLqDf2pJ5JSkm3a-PpC03DgudQ1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set scsi_host_template.cmd_size instead of using the SCSI pointer for
> storing driver-private data. Change the type of the argument of
> uas_add_work() from struct uas_cmd_info * into struct scsi_cmnd * because
> it is easier to convert a SCSI command pointer into a uas_cmd_info pointe=
r
> than the other way around.
>=20
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd=
.
>=20
> Cc: linux-usb@vger.kernel.org
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Oliver Neukum <oneukum@suse.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/usb/storage/uas.c | 43 ++++++++++++++++++---------------------
> 1 file changed, 20 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 7f2944729ecd..84dc270f6f73 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -113,7 +113,7 @@ static void uas_do_work(struct work_struct *work)
> 			continue;
>=20
> 		cmnd =3D devinfo->cmnd[i];
> -		cmdinfo =3D (void *)&cmnd->SCp;
> +		cmdinfo =3D scsi_cmd_priv(cmnd);
>=20
> 		if (!(cmdinfo->state & IS_IN_WORK_LIST))
> 			continue;
> @@ -139,10 +139,9 @@ static void uas_scan_work(struct work_struct *work)
> 	dev_dbg(&devinfo->intf->dev, "scan complete\n");
> }
>=20
> -static void uas_add_work(struct uas_cmd_info *cmdinfo)
> +static void uas_add_work(struct scsi_cmnd *cmnd)
> {
> -	struct scsi_pointer *scp =3D (void *)cmdinfo;
> -	struct scsi_cmnd *cmnd =3D container_of(scp, struct scsi_cmnd, SCp);
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	struct uas_dev_info *devinfo =3D cmnd->device->hostdata;
>=20
> 	lockdep_assert_held(&devinfo->lock);
> @@ -163,7 +162,7 @@ static void uas_zap_pending(struct uas_dev_info *devi=
nfo, int result)
> 			continue;
>=20
> 		cmnd =3D devinfo->cmnd[i];
> -		cmdinfo =3D (void *)&cmnd->SCp;
> +		cmdinfo =3D scsi_cmd_priv(cmnd);
> 		uas_log_cmd_state(cmnd, __func__, 0);
> 		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
> 		cmdinfo->state &=3D ~COMMAND_INFLIGHT;
> @@ -200,15 +199,14 @@ static void uas_sense(struct urb *urb, struct scsi_=
cmnd *cmnd)
> static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
> 			      int status)
> {
> -	struct uas_cmd_info *ci =3D (void *)&cmnd->SCp;
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *ci =3D scsi_cmd_priv(cmnd);
>=20
> 	if (status =3D=3D -ENODEV) /* too late */
> 		return;
>=20
> 	scmd_printk(KERN_INFO, cmnd,
> 		    "%s %d uas-tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
> -		    prefix, status, cmdinfo->uas_tag,
> +		    prefix, status, ci->uas_tag,
> 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
> 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
> 		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
> @@ -231,7 +229,7 @@ static void uas_free_unsubmitted_urbs(struct scsi_cmn=
d *cmnd)
> 	if (!cmnd)
> 		return;
>=20
> -	cmdinfo =3D (void *)&cmnd->SCp;
> +	cmdinfo =3D scsi_cmd_priv(cmnd);
>=20
> 	if (cmdinfo->state & SUBMIT_CMD_URB)
> 		usb_free_urb(cmdinfo->cmd_urb);
> @@ -245,7 +243,7 @@ static void uas_free_unsubmitted_urbs(struct scsi_cmn=
d *cmnd)
>=20
> static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
> {
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	struct uas_dev_info *devinfo =3D (void *)cmnd->device->hostdata;
>=20
> 	lockdep_assert_held(&devinfo->lock);
> @@ -263,13 +261,13 @@ static int uas_try_complete(struct scsi_cmnd *cmnd,=
 const char *caller)
> static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
> 			  unsigned direction)
> {
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	int err;
>=20
> 	cmdinfo->state |=3D direction | SUBMIT_STATUS_URB;
> 	err =3D uas_submit_urbs(cmnd, cmnd->device->hostdata);
> 	if (err) {
> -		uas_add_work(cmdinfo);
> +		uas_add_work(cmnd);
> 	}
> }
>=20
> @@ -329,7 +327,7 @@ static void uas_stat_cmplt(struct urb *urb)
> 	}
>=20
> 	cmnd =3D devinfo->cmnd[idx];
> -	cmdinfo =3D (void *)&cmnd->SCp;
> +	cmdinfo =3D scsi_cmd_priv(cmnd);
>=20
> 	if (!(cmdinfo->state & COMMAND_INFLIGHT)) {
> 		uas_log_cmd_state(cmnd, "unexpected status cmplt", 0);
> @@ -394,7 +392,7 @@ static void uas_stat_cmplt(struct urb *urb)
> static void uas_data_cmplt(struct urb *urb)
> {
> 	struct scsi_cmnd *cmnd =3D urb->context;
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	struct uas_dev_info *devinfo =3D (void *)cmnd->device->hostdata;
> 	struct scsi_data_buffer *sdb =3D &cmnd->sdb;
> 	unsigned long flags;
> @@ -446,7 +444,7 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_=
info *devinfo, gfp_t gfp,
> 				      enum dma_data_direction dir)
> {
> 	struct usb_device *udev =3D devinfo->udev;
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	struct urb *urb =3D usb_alloc_urb(0, gfp);
> 	struct scsi_data_buffer *sdb =3D &cmnd->sdb;
> 	unsigned int pipe =3D (dir =3D=3D DMA_FROM_DEVICE)
> @@ -468,7 +466,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev=
_info *devinfo, gfp_t gfp,
> 				       struct scsi_cmnd *cmnd)
> {
> 	struct usb_device *udev =3D devinfo->udev;
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	struct urb *urb =3D usb_alloc_urb(0, gfp);
> 	struct sense_iu *iu;
>=20
> @@ -496,7 +494,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_i=
nfo *devinfo, gfp_t gfp,
> {
> 	struct usb_device *udev =3D devinfo->udev;
> 	struct scsi_device *sdev =3D cmnd->device;
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	struct urb *urb =3D usb_alloc_urb(0, gfp);
> 	struct command_iu *iu;
> 	int len;
> @@ -558,7 +556,7 @@ static struct urb *uas_submit_sense_urb(struct scsi_c=
mnd *cmnd, gfp_t gfp)
> static int uas_submit_urbs(struct scsi_cmnd *cmnd,
> 			   struct uas_dev_info *devinfo)
> {
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	struct urb *urb;
> 	int err;
>=20
> @@ -637,12 +635,10 @@ static int uas_queuecommand_lck(struct scsi_cmnd *c=
mnd)
> {
> 	struct scsi_device *sdev =3D cmnd->device;
> 	struct uas_dev_info *devinfo =3D sdev->hostdata;
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	unsigned long flags;
> 	int idx, err;
>=20
> -	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer))=
;
> -
> 	/* Re-check scsi_block_requests now that we've the host-lock */
> 	if (cmnd->device->host->host_self_blocked)
> 		return SCSI_MLQUEUE_DEVICE_BUSY;
> @@ -712,7 +708,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmn=
d)
> 			spin_unlock_irqrestore(&devinfo->lock, flags);
> 			return SCSI_MLQUEUE_DEVICE_BUSY;
> 		}
> -		uas_add_work(cmdinfo);
> +		uas_add_work(cmnd);
> 	}
>=20
> 	devinfo->cmnd[idx] =3D cmnd;
> @@ -730,7 +726,7 @@ static DEF_SCSI_QCMD(uas_queuecommand)
>  */
> static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
> {
> -	struct uas_cmd_info *cmdinfo =3D (void *)&cmnd->SCp;
> +	struct uas_cmd_info *cmdinfo =3D scsi_cmd_priv(cmnd);
> 	struct uas_dev_info *devinfo =3D (void *)cmnd->device->hostdata;
> 	struct urb *data_in_urb =3D NULL;
> 	struct urb *data_out_urb =3D NULL;
> @@ -910,6 +906,7 @@ static struct scsi_host_template uas_host_template =
=3D {
> 	.this_id =3D -1,
> 	.skip_settle_delay =3D 1,
> 	.dma_boundary =3D PAGE_SIZE - 1,
> +	.cmd_size =3D sizeof(struct uas_cmd_info),
> };
>=20
> #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

