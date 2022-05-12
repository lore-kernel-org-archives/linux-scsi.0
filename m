Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5142C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 23:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359570AbiELXgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 19:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359569AbiELXgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 19:36:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D642580F9
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 16:36:41 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CKVR3f010450;
        Thu, 12 May 2022 23:36:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Ei2g/RAKhTXpR30OW/uneNtKOpT1dDr7RaOU15Qf19s=;
 b=eKmwLlyVkXJU2o51r7Uf8JDPSxtDUf3SRsUAMDJchJ9p+aDrlIZ/gFHxPPc/7MyXVrjd
 aUD8U39jxxj687TZXes6BOraV9UPZqaiOmQ/B9noLVTnaolBaMttz4PbxdPtiqCxF6/g
 13MC1Qmd/eq+0Oz1WGjmEkR+GJP6coXXXVM31sFl48tqAZ9JwvOl39k9vLGXEU5hPcKq
 U5lERtd24jB4SFz1CK1ZlMOMtLvbQh09Sn+9R7184Bnj8Y2rS7fHeqeIieGBqSOe3rUa
 UV8437ZYry6JHJVv3f7tR/qqpghSFDGeprzldjJwKEhtBQeTkZTsZXhvb/cNe14DN46/ cw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwf6cdseu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:36:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24CNaaTj032958;
        Thu, 12 May 2022 23:36:39 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf75t6q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:36:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQVb+HgIds9wRU/IHhze/gSx7HRRRbYQHdSY8dkzyVtpMGFeb0mH82MDAFQg0PK3P0UWMdCMyEMX2fs9O7khrFZEMkBc+wSNmMSIqtur6+Iu0QingrmJa+AVlsBQc1zw9/rwPFojNP94pMspcwbJ8iv+uY/6k/9FpY+ZO90UBCb41HFmKyU3566kUoztj6sE344JlSzOwUy2kXhsCeNhujeAYYq4cP9b0g+vOZynxsurSLSRPmwzJ/zD90YsJsfysA1fqGttn1ti1cOVzjRElkqhz3jlhxi9Lc0lhEgDwBTIzYboNBlUEpUkMzHkD/RotsWefYlhwhqTqYxkyLMsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ei2g/RAKhTXpR30OW/uneNtKOpT1dDr7RaOU15Qf19s=;
 b=geOREYu/A3VGJ6cX0YnU26Yx8SuYGTelOO2FM6x76M9CmnvzghfQ5K6wuo3Au2u3HdZIk+1WKBiG0GzQ4jZ1x1PzmRairbbgOIXqE6XXhmNmSexwaEAXwY+8ufAbsVz8vlCILw/AMDSWQQc0VK/EKEsZ//X0vTx5cxUptDdVhfVKWDVDbpCyNP+mymoc0avymjoQ+UA1IAewzsneRNzXjvEzEWeOj/P2gL9Vs3UUyimOkhRSNkM+j+T14o7NMLO0dMRGCsyCGuyKNNwXPYybDLYg7PMKIZdtBkojF47aWhyDJb1eO1Q47WCrRn0LZBgYM4Fi2NKZ2liHpY1j82vzJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ei2g/RAKhTXpR30OW/uneNtKOpT1dDr7RaOU15Qf19s=;
 b=jwgiE+I6JojUWqUloSuo3EwF2iFiAgc55fjuliUJ8qkHM3RaH2nXQmmod1A1EmGGBS9HrFiLkFF7nCthLHjAhl45I0Dfv8Ue7OUFv2UJWIcXW1kVj1mhhS05CkkJ7Jt+1WkFbWD8IzTmqcATujsZ+R4+IJJ06G3yFvypH5L217Y=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH0PR10MB5516.namprd10.prod.outlook.com (2603:10b6:510:10c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 23:36:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 23:36:36 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] mpi3mr: Add target device related sysfs attributes
Thread-Topic: [PATCH 2/2] mpi3mr: Add target device related sysfs attributes
Thread-Index: AQHYZgdG2ZxAy4N5skSDJlXKqhzO2q0b5i2A
Date:   Thu, 12 May 2022 23:36:36 +0000
Message-ID: <75A01390-2A9B-497F-B703-A07B64C969EB@oracle.com>
References: <20220512140046.19046-1-sreekanth.reddy@broadcom.com>
 <20220512140046.19046-3-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220512140046.19046-3-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85611001-6c7e-4e34-d6b2-08da34704173
x-ms-traffictypediagnostic: PH0PR10MB5516:EE_
x-microsoft-antispam-prvs: <PH0PR10MB5516E0E995285EE182FFED03E6CB9@PH0PR10MB5516.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uv8M9jJtGaUfS3noUMBEHFXj+rnGomAuLfOH8TsN9LQs2VZhokrq/ngCtqV31i1k8xDIwPiBRlFcEo/rh+S1aKEOhapuGWXV8VomL4UouFukKZtoCbP4gvMqK6f2dNlntblw+lYsS1G3zDKq0VpOX4OV8Q77KW99DPtKhqXYDpf8Ch952PJQoe1mcBUFvby3CsgIS+lnIMGqhFCmoldc7N8atERCkIdPKRI0B9RembTiOeVfRftMMPOMcyUTjHF+AP/6qiYi4i/8XNvLN7UM9vlKSiLsvriwyGMsxYFzo2inWZYlSZDeNESDh4ZF2y0uVSOyGugrhaML88fJdRmJ544CTFXYX/onPh6zGpEoX1Mq/kRsz7sA5XuBuYVHqRgopj/QYvpct109Dqcgg9AalNbl3LY6g1Gx6bNtGsOHW8P4iWVzAsFSC73IA0ijI04R4TfsQNoxR8wPvQyjKinrA+uyB3Wi1GwfSTmT5Z4AgJ7jLgXvkBQGfcCsMLDRNAzD2Iib7nyZOTowjgEwn7GOZijz+K5bYneums++kTv/eh+sP1gp7IA6O/rJbfL0YgpCIQgYI0XdjcxZqc9rj3tIkWQ5u611EbSeXn3cPMsE/fGSiz0vr7JtIPZhUPL2OlvUqENxdsC9ACr1Rn8hC2H8H2/8zU9+8baBi/Gr8+N2TdtQKLp4NrP9oBFgmLtfGDuzJCbWnEv7gdPpvFpFGzdg076CVaDhd9d+IOHEzffGUBAESUuB9Q+QlWWibwh//TQY5P1L3l53AZk4j75Ja9CWQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(53546011)(44832011)(38070700005)(186003)(38100700002)(8936002)(71200400001)(6486002)(2616005)(33656002)(107886003)(86362001)(5660300002)(122000001)(508600001)(36756003)(316002)(91956017)(26005)(66446008)(64756008)(8676002)(66476007)(66556008)(76116006)(4326008)(66946007)(54906003)(6916009)(6512007)(2906002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Hac0pjwbNr7Q+M6cnL0LMUfEOrd1XoVN/anGZ0HxgYpPPdY1igthCwgh8QX7?=
 =?us-ascii?Q?yhIFM+DwhgyCgsJ7yvSVLjy/DbSNTpL9WZ+B9fc48rImcM4e+6DeSnuIfobH?=
 =?us-ascii?Q?1f9oYWBukFBWOdrWf225cWBRDUhiqZMh2pvjQasXrz5hQ7l8eUbG0QnqCkJh?=
 =?us-ascii?Q?AGo2QhhT7CQP2jdhJrmbvJZbXLRoifH4zW2TVZJGGqEKP5OsJTak3bfp0k/6?=
 =?us-ascii?Q?Nr6zobyYl9R8aN4ax29N1x0AmcVnyEZYV/jutEtFa7ee9dQxnryhzSerHWQk?=
 =?us-ascii?Q?yFo0QCy+pEOg8p6x4jWTjKjPTUiMHUlYTZ43auxwKP6QroiQ00wsk2/kjDAP?=
 =?us-ascii?Q?XxY8isxymrgKfa5JIBxteUNtwxFXPnsMxiWQ5FdwjsgUuvHiKh7jdlgpDDN1?=
 =?us-ascii?Q?l+gDwcLEML7cSJE4ejy+xiM6jo6PA2lgNYTjb/918UzxVEMPkJ73Rgk3NzF6?=
 =?us-ascii?Q?m0XQSllMtlY4Q7RJyeN9+v3YelTCS4e08OF7H/68LRxOa6SK2BYhSUYl/8Pc?=
 =?us-ascii?Q?wyLszir1lwwFcKljykekUhzuad4xbAxRuy4R5AXtvBEf3+bvGuWbvtVs+xpY?=
 =?us-ascii?Q?jw1Ed1t+xrE3jswZFEX1dFMnc9Z7LHZhgSMosItFAfNNn4maAJqObqoxfWLg?=
 =?us-ascii?Q?HAiRKuVfgjhOXkW2uBWrOAXWxVIcWIuFc71X9S88mVndU5CpFXBJsPAim/eF?=
 =?us-ascii?Q?4nyre/EGxCGdp0sByfk3zfm16uDLNLrUyI1IV/wlg/tUVvOiOMMFuc4WRa//?=
 =?us-ascii?Q?s9xPVYM/Hge7K4qMIzood+sVwP/1xu2NB/0b2RU/fF/sFEoca8Oxf2bGxKoD?=
 =?us-ascii?Q?ZIh/4Gz5gZFVTAnTftqqFupY45Lwzy05aLB1MxjNhlwbINfGtirdIvPiMQcG?=
 =?us-ascii?Q?3cf3PTGdNCu7Q/ySqxaevtJCfl73iaw5cC/6qZjpnTiLQsw24PO/ZRlm3vLt?=
 =?us-ascii?Q?Y3QBD5mTKdBD5w2Dyoy1LJW3iWcojs+j+lxM8FfPjAPUXIlsP0hdhLOBGEJR?=
 =?us-ascii?Q?xcXG9y4KH8l+e2m4ADp/GrWwBSoTANqvbUSGqwV1TUmo2DNuos13zYjeqLqb?=
 =?us-ascii?Q?EkOZBSUqyXZHh4iSoP5NmlFoLVzd50sgPjjRMC1DW6xJ56X58C1W+OmKcoZF?=
 =?us-ascii?Q?r3+vLJrbvtJBCB3VIh+/uQ8Rt75w5dsVilUqPjffG5Zn7fEnvzLtKXtQjDvm?=
 =?us-ascii?Q?i+NYgKaOKnaXz5lqW8uHq7c9fDTACQQmcLptJVQvO5xPB0KUK1yaynKja8/Z?=
 =?us-ascii?Q?V5dfg0RyaSwwemjIK/UkXijcNjQWngTrCRYN1b4mWc/ahfPOjD9GrEYGPXib?=
 =?us-ascii?Q?d+vjmhxC6Llrz1taegcGFKCwdp6ybe8ztueaaS67FQWAtmr/5N2CfMmjsQhi?=
 =?us-ascii?Q?rSa49bb9/pEV1f6S63noR/2zjXerHD+/S4eEW1Ie6QexCOBnZvp1m2f4ZSx9?=
 =?us-ascii?Q?1Brp8wNcyOJyEKruBoQdQ4NFgEfqSeVYIVCou6LqDHo+whRHJ5VA0i5QOFD/?=
 =?us-ascii?Q?co02q1JfYXXrF9HuO0b1mZ9dmNolVrI7j+6ZPYY/CAe9Sa5w8dtEt7foXJUl?=
 =?us-ascii?Q?tMQF0wDAtq3bWuQApK+Ap2ONh7K+RaD8OKtPTBMO+Y0C+vywuNxUpZjTR7P7?=
 =?us-ascii?Q?J76XhttaU0JeN3hIxH0B0qdI42sijnhiYoY8w/ZKv/n67cm3LT7MC1hkG+ty?=
 =?us-ascii?Q?IEqSM56YKtxS4a3sE9lkTkmcn9+D0/xmMv8VHw2MY9aKm5TQ//x7NXvxC+gi?=
 =?us-ascii?Q?+nnayVPgZXdPyqzBcNm1+kS5wOustLWP3d27MTmgfnSFYe4P1/en?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <579AF8388285B643B24502D959B9C75B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85611001-6c7e-4e34-d6b2-08da34704173
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 23:36:36.4813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XE/NrTpVMvIvCCfz1f15aZHG2SJKxOUaT59Kb8dEAVN7VuC3hkjkAcA+yWb5/UfsGT7sC3ahmG/LIXyQ8s4Zsj/BMibahbnYvxFx97PmjfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5516
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-12_15:2022-05-12,2022-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120101
X-Proofpoint-ORIG-GUID: 3ZJLNdhLloxOzookt40YG9IO0UEdjMaT
X-Proofpoint-GUID: 3ZJLNdhLloxOzookt40YG9IO0UEdjMaT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 12, 2022, at 7:00 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Added sysfs attributes for exposing target device details
> such as SAS address, firmware device handle and persistent ID
> for the controller attached devices and RAID volumes.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h     |   1 +
> drivers/scsi/mpi3mr/mpi3mr_app.c | 120 +++++++++++++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c  |   1 +
> 3 files changed, 122 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 584659e..01cd017 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1085,4 +1085,5 @@ int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *m=
rioc,
> void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
> 	u16 event_data_size);
> extern const struct attribute_group *mpi3mr_host_groups[];
> +extern const struct attribute_group *mpi3mr_dev_groups[];
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index c9b153c..69054a8 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -1742,3 +1742,123 @@ const struct attribute_group *mpi3mr_host_groups[=
] =3D {
> 	&mpi3mr_host_attr_group,
> 	NULL,
> };
> +
> +
> +/*
> + * SCSI Device attributes under sysfs
> + */
> +
> +/**
> + * sas_address_show - SysFS callback for dev SASaddress display
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * Return: snprintf() return after copying SAS address of the
> + * specific SAS/SATA end device.
> + */
> +static ssize_t
> +sas_address_show(struct device *dev, struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct scsi_device *sdev =3D to_scsi_device(dev);
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	struct mpi3mr_stgt_priv_data *tgt_priv_data;
> +	struct mpi3mr_tgt_dev *tgtdev;
> +
> +	sdev_priv_data =3D sdev->hostdata;
> +	if (!sdev_priv_data)
> +		return 0;
> +
> +	tgt_priv_data =3D sdev_priv_data->tgt_priv_data;
> +	if (!tgt_priv_data)
> +		return 0;
> +	tgtdev =3D tgt_priv_data->tgt_dev;
> +	if (!tgtdev || tgtdev->dev_type !=3D MPI3_DEVICE_DEVFORM_SAS_SATA)
> +		return 0;
> +	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
> +	    (unsigned long long)tgtdev->dev_spec.sas_sata_inf.sas_address);
> +}
> +
> +static DEVICE_ATTR_RO(sas_address);
> +
> +/**
> + * device_handle_show - SysFS callback for device handle display
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * Return: snprintf() return after copying firmware internal
> + * device handle of the specific device.
> + */
> +static ssize_t
> +device_handle_show(struct device *dev, struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct scsi_device *sdev =3D to_scsi_device(dev);
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	struct mpi3mr_stgt_priv_data *tgt_priv_data;
> +	struct mpi3mr_tgt_dev *tgtdev;
> +
> +	sdev_priv_data =3D sdev->hostdata;
> +	if (!sdev_priv_data)
> +		return 0;
> +
> +	tgt_priv_data =3D sdev_priv_data->tgt_priv_data;
> +	if (!tgt_priv_data)
> +		return 0;
> +	tgtdev =3D tgt_priv_data->tgt_dev;
> +	if (!tgtdev)
> +		return 0;
> +	return snprintf(buf, PAGE_SIZE, "0x%04x\n", tgtdev->dev_handle);
> +}
> +
> +static DEVICE_ATTR_RO(device_handle);
> +
> +/**
> + * persistent_id_show - SysFS callback for persisten ID display
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * Return: snprintf() return after copying persistent ID of the
> + * of the specific device.
> + */
> +static ssize_t
> +persistent_id_show(struct device *dev, struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct scsi_device *sdev =3D to_scsi_device(dev);
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	struct mpi3mr_stgt_priv_data *tgt_priv_data;
> +	struct mpi3mr_tgt_dev *tgtdev;
> +
> +	sdev_priv_data =3D sdev->hostdata;
> +	if (!sdev_priv_data)
> +		return 0;
> +
> +	tgt_priv_data =3D sdev_priv_data->tgt_priv_data;
> +	if (!tgt_priv_data)
> +		return 0;
> +	tgtdev =3D tgt_priv_data->tgt_dev;
> +	if (!tgtdev)
> +		return 0;
> +	return snprintf(buf, PAGE_SIZE, "%d\n", tgtdev->perst_id);
> +}
> +static DEVICE_ATTR_RO(persistent_id);
> +
> +static struct attribute *mpi3mr_dev_attrs[] =3D {
> +	&dev_attr_sas_address.attr,
> +	&dev_attr_device_handle.attr,
> +	&dev_attr_persistent_id.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group mpi3mr_dev_attr_group =3D {
> +	.attrs =3D mpi3mr_dev_attrs
> +};
> +
> +const struct attribute_group *mpi3mr_dev_groups[] =3D {
> +	&mpi3mr_dev_attr_group,
> +	NULL,
> +};
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index f5c345d..d8c195b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4147,6 +4147,7 @@ static struct scsi_host_template mpi3mr_driver_temp=
late =3D {
> 	.track_queue_depth		=3D 1,
> 	.cmd_size			=3D sizeof(struct scmd_priv),
> 	.shost_groups			=3D mpi3mr_host_groups,
> +	.sdev_groups			=3D mpi3mr_dev_groups,
> };
>=20
> /**
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

