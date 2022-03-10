Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA250C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 20:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244568AbiCJUPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 15:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244559AbiCJUPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 15:15:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4339210EC72
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 12:14:06 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22AHrEo6008587;
        Thu, 10 Mar 2022 20:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=EtSL+V/reTeWnkrLDZCia3qsoH9yfoxlb/LdS/1y/n4=;
 b=c1vG6EoU/Q9SWPt+zJj6tIQz19wEALa9p7v3jTfeFIvgAXGpHi/s98IRZXGCpxsKFcWT
 7bsdsbmqUfP9raBwknfXJKKSgRUGFZmYiv8ii9rlyXr6iEgOjGYtZUGAL7ywgiXyyjxo
 WgKyEoOLiW2euFiO9/uR5iIRjoa55WqjYrxWlD1ewHJNNflkCwPznmQ+Z55jgKbyXERX
 Strmcmblw4RkxFcsdL8Xcxi/TaWRj380zV/+nhBFc7QVkcAZM5zT8Rz30o2pKPbeOdTu
 S5Bk7pxaFNFfZ/gu7oUOElu/N3h45BMohHvR+jb+uWL+182Si9XdwMUaN6p6dRZMc/BE jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0xdbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 20:14:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22AKBH4g007880;
        Thu, 10 Mar 2022 20:14:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3ekyp3srvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 20:14:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfBiE+n/GB0qW8/nxz9hMc9HSaaqGARTyls7uKkqNVScKVcDcv3Ja7HcJ2VY0QZIUTCzysupyHs5vnzujRrxVW+y4JoZSEnLSIcbiKKpK3+rNxEp2UGNvzHBnCSvxqAnyHM2FXl/luO4Fp3qaLNQsaNLmHvIQd29aCbhK3dezkA/rDKIZOGldNPTnTeWLD5EoU1MzNPVunWnhZCruF0lgtOI3xbBr1b0T/k6737A0/DdQOzpsjfYg4iXX1hb3oWXHQbqLT6ynJyCxDpVTvj3QhCxnBAh9lsoqOMac/6JQQ2M5mId5e++/R3HmfrLFObIZwTXsYqHDQpVDwiDTFExOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtSL+V/reTeWnkrLDZCia3qsoH9yfoxlb/LdS/1y/n4=;
 b=JKdlcyB6XEDQDMOTfdjOdaDCg07BC+oaGxSPn1lz7ja9JI6zqAdp53sXqDLZttIstrgMx+0YIVa48rK64mVrhSSQ5/GGGi7tORgUe4Z9vR5fWLB38uma158DYfLlL7zm3JzRfEAUV7Yhqozerdo8e0mTae76VDvYRQPy+t6xsN7vxlPVnrLs0b5fGlggWam4PRILOxnb9m9NjBXtPHfHClqGZjsAUwv0jbb47Umfjz1a4IEBOSMYPO+yN6CUAqdljfiWdekkJNRdkclzmyyNtZHKBx+3i14vGO6/mKISp/CW1N+I/A2o5IIMBuQ2ampENh6L+QEDTL63TMkg8Cx8EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtSL+V/reTeWnkrLDZCia3qsoH9yfoxlb/LdS/1y/n4=;
 b=pSMBkfyhdiEGJOUgjqLKDwQlUpFsbmGfq1IwsiEfXMS/v+HsoJ3B6AK+HzppcwvsibdD7/fMtW0bAGNu4F45bUWEOgU5MuoWf6lf6odKSpuzyu+qTZk6fkpD0R7Ie/YAPVKsHr9c/+Gp887r99rE7qJJCvzEJVPf7U4pZL3KVZU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR1001MB2380.namprd10.prod.outlook.com (2603:10b6:4:2f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Thu, 10 Mar
 2022 20:13:58 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 20:13:58 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     James Smart <jsmart2021@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: Remove failing soft_wwn support
Thread-Topic: [PATCH] lpfc: Remove failing soft_wwn support
Thread-Index: AQHYNJZfXP9Vc/PhB0mw+F2fWaaYp6y5DZMA
Date:   Thu, 10 Mar 2022 20:13:58 +0000
Message-ID: <12901799-72BA-4517-A173-0128EF389EB8@oracle.com>
References: <20220310154845.11125-1-jsmart2021@gmail.com>
In-Reply-To: <20220310154845.11125-1-jsmart2021@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d6151a1-51d0-4ebb-cf19-08da02d282ba
x-ms-traffictypediagnostic: DM5PR1001MB2380:EE_
x-microsoft-antispam-prvs: <DM5PR1001MB2380E9DF97AD9464202CFC8DE60B9@DM5PR1001MB2380.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3gIv7al7Bf2mNAymUD3xr3ymkoNKPqwz/o6oNbvQbCnLLNaKhJVbVslIvnRKAtEDqsnXkBOIy6sAWiglyDHnfDe5T54czE5QSxpv3QnWvRUcygWFvgKgJm6D074xax7GCh7Cx+slZ7Mg54UoUQSR8tzurCImuv+6NNfFDzcLI5xYZ4WWGMTwX9n2EX/keKTzg8/DwgvswC5h18owaTjBhQnoTPflEwbu6mP0X/jZcdXc/OJkrCuivbnvehK8zliAn9pNval7ZyG3Vo7gCtRJZA16LUfJmpYos6sx0aTB5DVMWtXPNHamyxYSiwq8lDC8pSudQW+g3sw7KcEmDWrNI+eny0o+8Ct5jDKB40QLEDiNlQZU3hUEVGsbsNxg/9s26MMA3LpGvoVKpT2ojVBl+K/5btnYWxq1tOtXqS5RxJ2RqV+fpIBBNRqmta5KKlEEm6k5VL14McIP5uWdEQcMcRNdd0PQI5uyLOBvba8UVtDhTcg4bqZIRA1wsbAFZ69xVLaQMWGTmdCU6U5D6KTVGdrAZymsthjol5T0WL8mHR1KKwsFa2LsodA0BXVnJMH+clbBFJP4k3eSCSLE2X/cngtVc9apCEelxv1cN8qkhtoEWklqpstgoB3h9uB8Pd6DfDoE23/8Kl4AfpvASu2Gg5ARX2x6n6LOUBuvDHPYxZttxT9cxH9UXfJUbxS53wEihBLnfBj4b/yvgqrP44HwUksxsvuoYxLPPFsOXLGRP00=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(26005)(186003)(122000001)(76116006)(44832011)(54906003)(508600001)(6486002)(6916009)(316002)(71200400001)(86362001)(6506007)(2906002)(5660300002)(30864003)(66946007)(8676002)(4326008)(66556008)(6512007)(2616005)(64756008)(66476007)(66446008)(91956017)(38100700002)(8936002)(38070700005)(83380400001)(36756003)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h7FfFgNJDYYhWbG4xGCKMztohYHfIoUMMGlhbYiPLIv9a3MIG80HMuUiwX83?=
 =?us-ascii?Q?3YtPRqQgtiKPURJ9B09JnN9tYulYEiN3J98caLUmoxexqL9Fag+A8k4ZHhJy?=
 =?us-ascii?Q?m27Auux/ukUPcyRctTZUGDIXRpO8A6g7aOhoP0qyC9O1xpLT60U2jeNkw7Ph?=
 =?us-ascii?Q?huxO0eH4rRkiPuz5Ml1lMV+gYxwFblCDEzwLxZXMt/axLaAdg1Cr0mySYpbZ?=
 =?us-ascii?Q?RkoSUEgDXsNok555nPRmgVlDploL//25VxnOo04QmLzerlDYKk0EQ9KtM+wH?=
 =?us-ascii?Q?bDkEuqdmvL4CiLqh7cmEMcMCIedCDqwaXbk4aRXtNHpyLiMWeAdIRviRucQM?=
 =?us-ascii?Q?IrRFCHhUoq4S5E2SlCjKJ+m22LCpvvZiIhh61FY+njf42cU6Rt/6kO219kRn?=
 =?us-ascii?Q?2dTuojSfGlK7tULX5otn53p/E9lqyQFjYpctXh313o2JYl5HKRmBarG9XqB3?=
 =?us-ascii?Q?TkHbyopAqq6sN5Kz3QdASy5jMZ6Ep/HqEsRUeRH9IqFuID5IVf0pFyhXyx6R?=
 =?us-ascii?Q?tIB2iSVtDYaDjhhImUmak+6sz57ks+Je4P3vuGYtYTRgOMDDULqVqduRKaCD?=
 =?us-ascii?Q?hSHqrpSomlYXJvF9ZN/wAZtlwpogH7NgJICuYheWrI9/D0S98ot8brYVDou5?=
 =?us-ascii?Q?7UGG50BkqKWk+4+eqZz1SxydjjmgNqncU+IA+BkXg3WcH43l3e7Flvx9zgZe?=
 =?us-ascii?Q?AKeuMQqWTjAJNggeaMmAqfJS5q3g+WYfuPDoAWadP6U5djeOuTqEU6a+X2rw?=
 =?us-ascii?Q?ANzb1nV5X5DVz+gnDgAYbq1/9gh1y2T/w5uNarlgbBeURRCBXz3koCZCz0cL?=
 =?us-ascii?Q?XCOX5hbVoPhZNjnQh4xf/UuOT27EN6xOwyfmugPqWHPdXk5IkpivJPTUvcjt?=
 =?us-ascii?Q?5EASyMhlos9tw4OleB0xyVNYOfN2+P4XtL4HW5NMut90BPaatOBO9Z2kVPq0?=
 =?us-ascii?Q?4dJp7HBWeZNQBuZiRGvZUfGnxQyS8AnbP2Tnb8vvljwzRJFnSrY19r6YEsoT?=
 =?us-ascii?Q?MjcXKIYtTDzLm+dELGaDjLF9mVvz/sL8O4XrsLhr/xb+67yDStJvBjC108qR?=
 =?us-ascii?Q?IXAyfq+5d8wxuJgN7ZnUdNE/ZpyBl+K37cWbV2osLE9oUjo2V2b2Nj7GbMyQ?=
 =?us-ascii?Q?pSzSOcVMprRLanptkY62ESyNuK53++40/nMnUFL8/jC90E/x5xkolw0tlwDn?=
 =?us-ascii?Q?iF2J4o3vEUvVEiEsFU6rM1mzi5hWGkLYSd5W6iMFgXFNlWf/mNiLs3CfEXap?=
 =?us-ascii?Q?kPGjrJ/sgUyo0wfWgG5uSkBK+Vz1JhJPyJBJyaQLuSQPMzS5OSG7zvLiKazq?=
 =?us-ascii?Q?K56FJO6cy8b8NjdBlax/6UOjeUQxFDn/oXPahFTwojov/1MrKOuFdDIKuCCC?=
 =?us-ascii?Q?LcSlKljuL61Uc+pNVUh3Wzg8UjnmOUMHZSSWpCbWJYOyjNCtrsG2Lo1jD4N0?=
 =?us-ascii?Q?VdGNwUM0aRrEkredYQ416CeMcOYdXepSBcvi/oyNcrRsqI8W+R2hl1JtKYZT?=
 =?us-ascii?Q?Usd27zwdQ1/jZhqmDMa5Nt9cEVqaWU2pATGnzswPWv0yWD+KXJ2ha4So9cZv?=
 =?us-ascii?Q?0SLMEPcfGYKFhC9E6xXqiM+WQOH56WoU+u8OORdLLPg5NstI1B2Y2999c923?=
 =?us-ascii?Q?irzKPONqpvh3jycp/2sOkxhiIkGbYxgOFFO2A+aOyQBdOtxm07WBNa8SMS+l?=
 =?us-ascii?Q?uDHpMKx7CI6PMVrn86DMNzdsesA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43577F665FDC0347A87058D6DEFBFD4E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6151a1-51d0-4ebb-cf19-08da02d282ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 20:13:58.5077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PEEw3ya4hn4YmBAw/G/zX/OMYud9MVzagwWtUKzOa8EZ3qm8MqOOaX4lzPySMsIJGkhg46q9EapzSxwzdZ7kSPQQ9Z77MzAVTuMiBtbguyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2380
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203100103
X-Proofpoint-ORIG-GUID: Kj2yJrexn6JHWPjyqDpDXFDboO64peuW
X-Proofpoint-GUID: Kj2yJrexn6JHWPjyqDpDXFDboO64peuW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 10, 2022, at 7:48 AM, James Smart <jsmart2021@gmail.com> wrote:
>=20
> The soft_wwpn/soft_wwn functionality, which allows the driver to modify
> service parameters in an attempt to override the adapter-assigned WWN,
> was originally attempted to be removed roughly 6 yrs ago as new fabric
> features were being introduced that clashed with the implementation.
> In the end, the feature was left in with the user being responsible if
> things went south.
>=20
> We've reached a point where soft_wwn is no longer functional and is
> failing in almost all production use cases. Use of Fabric features such
> as Fabric Assigned WWPN and Automatic DPORT is now prevalent and the
> features require coordination between the adapter and driver that can't
> be solved by the simplistic update of the service parameters. As it is
> no longer functional, the feature is to be removed.
>=20
> There are still ways to override the adapter-assigned WWN but they
> require the admin to invoke bios/efi level menus.
>=20
> Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
> drivers/scsi/lpfc/lpfc.h      |   3 -
> drivers/scsi/lpfc/lpfc_attr.c | 228 ----------------------------------
> drivers/scsi/lpfc/lpfc_init.c |  12 +-
> 3 files changed, 1 insertion(+), 242 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 8197ba8d401d..86653aa9b389 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -1153,8 +1153,6 @@ struct lpfc_hba {
> 	uint32_t cfg_nvme_seg_cnt;
> 	uint32_t cfg_scsi_seg_cnt;
> 	uint32_t cfg_sg_dma_buf_size;
> -	uint64_t cfg_soft_wwnn;
> -	uint64_t cfg_soft_wwpn;
> 	uint32_t cfg_hba_queue_depth;
> 	uint32_t cfg_enable_hba_reset;
> 	uint32_t cfg_enable_hba_heartbeat;
> @@ -1286,7 +1284,6 @@ struct lpfc_hba {
> #define VPD_PORT            0x8         /* valid vpd port data */
> #define VPD_MASK            0xf         /* mask for any vpd data */
>=20
> -	uint8_t soft_wwn_enable;
>=20
> 	struct timer_list fcp_poll_timer;
> 	struct timer_list eratt_poll;
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.=
c
> index bac78fbce8d6..ff99f7cdbefa 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2835,7 +2835,6 @@ static DEVICE_ATTR(lpfc_xlane_supported, S_IRUGO, l=
pfc_oas_supported_show,
> 		   NULL);
> static DEVICE_ATTR(cmf_info, 0444, lpfc_cmf_info_show, NULL);
>=20
> -static char *lpfc_soft_wwn_key =3D "C99G71SL8032A";
> #define WWN_SZ 8
> /**
>  * lpfc_wwn_set - Convert string to the 8 byte WWN value.
> @@ -2879,229 +2878,7 @@ lpfc_wwn_set(const char *buf, size_t cnt, char ww=
n[])
> 	}
> 	return 0;
> }
> -/**
> - * lpfc_soft_wwn_enable_store - Allows setting of the wwn if the key is =
valid
> - * @dev: class device that is converted into a Scsi_host.
> - * @attr: device attribute, not used.
> - * @buf: containing the string lpfc_soft_wwn_key.
> - * @count: must be size of lpfc_soft_wwn_key.
> - *
> - * Returns:
> - * -EINVAL if the buffer does not contain lpfc_soft_wwn_key
> - * length of buf indicates success
> - **/
> -static ssize_t
> -lpfc_soft_wwn_enable_store(struct device *dev, struct device_attribute *=
attr,
> -			   const char *buf, size_t count)
> -{
> -	struct Scsi_Host  *shost =3D class_to_shost(dev);
> -	struct lpfc_vport *vport =3D (struct lpfc_vport *) shost->hostdata;
> -	struct lpfc_hba   *phba =3D vport->phba;
> -	unsigned int cnt =3D count;
> -	uint8_t vvvl =3D vport->fc_sparam.cmn.valid_vendor_ver_level;
> -	u32 *fawwpn_key =3D (uint32_t *)&vport->fc_sparam.un.vendorVersion[0];
> -
> -	/*
> -	 * We're doing a simple sanity check for soft_wwpn setting.
> -	 * We require that the user write a specific key to enable
> -	 * the soft_wwpn attribute to be settable. Once the attribute
> -	 * is written, the enable key resets. If further updates are
> -	 * desired, the key must be written again to re-enable the
> -	 * attribute.
> -	 *
> -	 * The "key" is not secret - it is a hardcoded string shown
> -	 * here. The intent is to protect against the random user or
> -	 * application that is just writing attributes.
> -	 */
> -	if (vvvl =3D=3D 1 && cpu_to_be32(*fawwpn_key) =3D=3D FAPWWN_KEY_VENDOR)=
 {
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"0051 lpfc soft wwpn can not be enabled: "
> -				"fawwpn is enabled\n");
> -		return -EINVAL;
> -	}
> -
> -	/* count may include a LF at end of string */
> -	if (buf[cnt-1] =3D=3D '\n')
> -		cnt--;
> -
> -	if ((cnt !=3D strlen(lpfc_soft_wwn_key)) ||
> -	    (strncmp(buf, lpfc_soft_wwn_key, strlen(lpfc_soft_wwn_key)) !=3D 0)=
)
> -		return -EINVAL;
> -
> -	phba->soft_wwn_enable =3D 1;
> -
> -	dev_printk(KERN_WARNING, &phba->pcidev->dev,
> -		   "lpfc%d: soft_wwpn assignment has been enabled.\n",
> -		   phba->brd_no);
> -	dev_printk(KERN_WARNING, &phba->pcidev->dev,
> -		   "  The soft_wwpn feature is not supported by Broadcom.");
> -
> -	return count;
> -}
> -static DEVICE_ATTR_WO(lpfc_soft_wwn_enable);
> -
> -/**
> - * lpfc_soft_wwpn_show - Return the cfg soft ww port name of the adapter
> - * @dev: class device that is converted into a Scsi_host.
> - * @attr: device attribute, not used.
> - * @buf: on return contains the wwpn in hexadecimal.
> - *
> - * Returns: size of formatted string.
> - **/
> -static ssize_t
> -lpfc_soft_wwpn_show(struct device *dev, struct device_attribute *attr,
> -		    char *buf)
> -{
> -	struct Scsi_Host  *shost =3D class_to_shost(dev);
> -	struct lpfc_vport *vport =3D (struct lpfc_vport *) shost->hostdata;
> -	struct lpfc_hba   *phba =3D vport->phba;
> -
> -	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
> -			(unsigned long long)phba->cfg_soft_wwpn);
> -}
> -
> -/**
> - * lpfc_soft_wwpn_store - Set the ww port name of the adapter
> - * @dev: class device that is converted into a Scsi_host.
> - * @attr: device attribute, not used.
> - * @buf: contains the wwpn in hexadecimal.
> - * @count: number of wwpn bytes in buf
> - *
> - * Returns:
> - * -EACCES hba reset not enabled, adapter over temp
> - * -EINVAL soft wwn not enabled, count is invalid, invalid wwpn byte inv=
alid
> - * -EIO error taking adapter offline or online
> - * value of count on success
> - **/
> -static ssize_t
> -lpfc_soft_wwpn_store(struct device *dev, struct device_attribute *attr,
> -		     const char *buf, size_t count)
> -{
> -	struct Scsi_Host  *shost =3D class_to_shost(dev);
> -	struct lpfc_vport *vport =3D (struct lpfc_vport *) shost->hostdata;
> -	struct lpfc_hba   *phba =3D vport->phba;
> -	struct completion online_compl;
> -	int stat1 =3D 0, stat2 =3D 0;
> -	unsigned int cnt =3D count;
> -	u8 wwpn[WWN_SZ];
> -	int rc;
> -
> -	if (!phba->cfg_enable_hba_reset)
> -		return -EACCES;
> -	spin_lock_irq(&phba->hbalock);
> -	if (phba->over_temp_state =3D=3D HBA_OVER_TEMP) {
> -		spin_unlock_irq(&phba->hbalock);
> -		return -EACCES;
> -	}
> -	spin_unlock_irq(&phba->hbalock);
> -	/* count may include a LF at end of string */
> -	if (buf[cnt-1] =3D=3D '\n')
> -		cnt--;
> -
> -	if (!phba->soft_wwn_enable)
> -		return -EINVAL;
> -
> -	/* lock setting wwpn, wwnn down */
> -	phba->soft_wwn_enable =3D 0;
> -
> -	rc =3D lpfc_wwn_set(buf, cnt, wwpn);
> -	if (rc) {
> -		/* not able to set wwpn, unlock it */
> -		phba->soft_wwn_enable =3D 1;
> -		return rc;
> -	}
> -
> -	phba->cfg_soft_wwpn =3D wwn_to_u64(wwpn);
> -	fc_host_port_name(shost) =3D phba->cfg_soft_wwpn;
> -	if (phba->cfg_soft_wwnn)
> -		fc_host_node_name(shost) =3D phba->cfg_soft_wwnn;
> -
> -	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
> -		   "lpfc%d: Reinitializing to use soft_wwpn\n", phba->brd_no);
> -
> -	stat1 =3D lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
> -	if (stat1)
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"0463 lpfc_soft_wwpn attribute set failed to "
> -				"reinit adapter - %d\n", stat1);
> -	init_completion(&online_compl);
> -	rc =3D lpfc_workq_post_event(phba, &stat2, &online_compl,
> -				   LPFC_EVT_ONLINE);
> -	if (rc =3D=3D 0)
> -		return -ENOMEM;
>=20
> -	wait_for_completion(&online_compl);
> -	if (stat2)
> -		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -				"0464 lpfc_soft_wwpn attribute set failed to "
> -				"reinit adapter - %d\n", stat2);
> -	return (stat1 || stat2) ? -EIO : count;
> -}
> -static DEVICE_ATTR_RW(lpfc_soft_wwpn);
> -
> -/**
> - * lpfc_soft_wwnn_show - Return the cfg soft ww node name for the adapte=
r
> - * @dev: class device that is converted into a Scsi_host.
> - * @attr: device attribute, not used.
> - * @buf: on return contains the wwnn in hexadecimal.
> - *
> - * Returns: size of formatted string.
> - **/
> -static ssize_t
> -lpfc_soft_wwnn_show(struct device *dev, struct device_attribute *attr,
> -		    char *buf)
> -{
> -	struct Scsi_Host *shost =3D class_to_shost(dev);
> -	struct lpfc_hba *phba =3D ((struct lpfc_vport *)shost->hostdata)->phba;
> -	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
> -			(unsigned long long)phba->cfg_soft_wwnn);
> -}
> -
> -/**
> - * lpfc_soft_wwnn_store - sets the ww node name of the adapter
> - * @dev: class device that is converted into a Scsi_host.
> - * @attr: device attribute, not used.
> - * @buf: contains the ww node name in hexadecimal.
> - * @count: number of wwnn bytes in buf.
> - *
> - * Returns:
> - * -EINVAL soft wwn not enabled, count is invalid, invalid wwnn byte inv=
alid
> - * value of count on success
> - **/
> -static ssize_t
> -lpfc_soft_wwnn_store(struct device *dev, struct device_attribute *attr,
> -		     const char *buf, size_t count)
> -{
> -	struct Scsi_Host *shost =3D class_to_shost(dev);
> -	struct lpfc_hba *phba =3D ((struct lpfc_vport *)shost->hostdata)->phba;
> -	unsigned int cnt =3D count;
> -	u8 wwnn[WWN_SZ];
> -	int rc;
> -
> -	/* count may include a LF at end of string */
> -	if (buf[cnt-1] =3D=3D '\n')
> -		cnt--;
> -
> -	if (!phba->soft_wwn_enable)
> -		return -EINVAL;
> -
> -	rc =3D lpfc_wwn_set(buf, cnt, wwnn);
> -	if (rc) {
> -		/* Allow wwnn to be set many times, as long as the enable
> -		 * is set. However, once the wwpn is set, everything locks.
> -		 */
> -		return rc;
> -	}
> -
> -	phba->cfg_soft_wwnn =3D wwn_to_u64(wwnn);
> -
> -	dev_printk(KERN_NOTICE, &phba->pcidev->dev,
> -		   "lpfc%d: soft_wwnn set. Value will take effect upon "
> -		   "setting of the soft_wwpn\n", phba->brd_no);
> -
> -	return count;
> -}
> -static DEVICE_ATTR_RW(lpfc_soft_wwnn);
>=20
> /**
>  * lpfc_oas_tgt_show - Return wwpn of target whose luns maybe enabled for
> @@ -6495,9 +6272,6 @@ static struct attribute *lpfc_hba_attrs[] =3D {
> 	&dev_attr_lpfc_nvme_enable_fb.attr,
> 	&dev_attr_lpfc_nvmet_fb_size.attr,
> 	&dev_attr_lpfc_enable_bg.attr,
> -	&dev_attr_lpfc_soft_wwnn.attr,
> -	&dev_attr_lpfc_soft_wwpn.attr,
> -	&dev_attr_lpfc_soft_wwn_enable.attr,
> 	&dev_attr_lpfc_enable_hba_reset.attr,
> 	&dev_attr_lpfc_enable_hba_heartbeat.attr,
> 	&dev_attr_lpfc_EnableXLane.attr,
> @@ -7727,8 +7501,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
> 	    phba->sli_rev =3D=3D LPFC_SLI_REV4)
> 		phba->cfg_irq_chann =3D phba->cfg_hdw_queue;
>=20
> -	phba->cfg_soft_wwnn =3D 0L;
> -	phba->cfg_soft_wwpn =3D 0L;
> 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
> 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
> 	lpfc_aer_support_init(phba, lpfc_aer_support);
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index 6e247b6be7de..eed6464bd880 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -340,7 +340,6 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LP=
FC_MBOXQ_t *pmboxq)
>=20
> /**
>  * lpfc_update_vport_wwn - Updates the fc_nodename, fc_portname,
> - *	cfg_soft_wwnn, cfg_soft_wwpn
>  * @vport: pointer to lpfc vport data structure.
>  *
>  *
> @@ -353,19 +352,11 @@ lpfc_update_vport_wwn(struct lpfc_vport *vport)
> 	uint8_t vvvl =3D vport->fc_sparam.cmn.valid_vendor_ver_level;
> 	u32 *fawwpn_key =3D (u32 *)&vport->fc_sparam.un.vendorVersion[0];
>=20
> -	/* If the soft name exists then update it using the service params */
> -	if (vport->phba->cfg_soft_wwnn)
> -		u64_to_wwn(vport->phba->cfg_soft_wwnn,
> -			   vport->fc_sparam.nodeName.u.wwn);
> -	if (vport->phba->cfg_soft_wwpn)
> -		u64_to_wwn(vport->phba->cfg_soft_wwpn,
> -			   vport->fc_sparam.portName.u.wwn);
> -
> 	/*
> 	 * If the name is empty or there exists a soft name
> 	 * then copy the service params name, otherwise use the fc name
> 	 */
> -	if (vport->fc_nodename.u.wwn[0] =3D=3D 0 || vport->phba->cfg_soft_wwnn)
> +	if (vport->fc_nodename.u.wwn[0] =3D=3D 0)
> 		memcpy(&vport->fc_nodename, &vport->fc_sparam.nodeName,
> 			sizeof(struct lpfc_name));
> 	else
> @@ -382,7 +373,6 @@ lpfc_update_vport_wwn(struct lpfc_vport *vport)
> 		vport->vport_flag |=3D FAWWPN_PARAM_CHG;
>=20
> 	if (vport->fc_portname.u.wwn[0] =3D=3D 0 ||
> -	    vport->phba->cfg_soft_wwpn ||
> 	    (vvvl =3D=3D 1 && cpu_to_be32(*fawwpn_key) =3D=3D FAPWWN_KEY_VENDOR)=
 ||
> 	    vport->vport_flag & FAWWPN_SET) {
> 		memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
> --=20
> 2.26.2
>=20

Looks Okay.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

