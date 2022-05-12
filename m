Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E4BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 23:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359571AbiELXgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 19:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359530AbiELXgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 19:36:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D136765D22
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 16:36:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CJK4C7011683;
        Thu, 12 May 2022 23:36:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=X7JLT7bw1ZmwVaFNiGltVS16QCFCucEHeQ6GOrWM8D8=;
 b=vR+BOyOBHdFMTe93dr178iinL87hWroaJs8uEozl5thQCWnz0S9szujLiYg7n6z6em3p
 uxeTCD/0rHoZmezjXjN1iUQNjV5WbOvCtmkKSBJ9eI0Msl1XBHjAP1YFQDA5JcDQmjn1
 mhaJsNsYOx4PgbieBQ3/cYP7vr5xY0JXFO7EFqDtESvxror+gN3st/wWWgbOAXM193hi
 RlIZX76kXkM7dlobAKVUYNKdjitiOw34pMCSucWtKrX16msUCo0Vkp/GmLz6YVh29c7i
 LbJAGbGBDr9Z+Z9c8DfinCoZvc00IisXbKLWljQPN0jcKPU0I2OSIDGH0JxXOP/mf0G0 HQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsx8vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:36:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24CNaaTk032958;
        Thu, 12 May 2022 23:36:39 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf75t6q7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:36:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKjEf6v9EB/Kd0SskN/Wt/iqCTX36Nb0O6Sj0vEy/QpOhN5troY3YB3bpgLbcWs0B6BjxBhzOA/K1tFSNqvSRASUEIB17slwvpVXbYHuwS501xBaO0L+Hp7IZB9g7Cr4okv7btQPtferIQMCh5sEpmY0ISK2a2Moj8IlxOrBrHL0LPZxqMAlBHITnIbF426Iw7ZsdCTNZpwIy4xt89bGE2rA6BcYJNu0KziAWRRihNIdcoWVAkQZSe6VVo2fWSVwtlaPIVKwp2fjkMqEjhdEQC7i1GIYt2TXCVQS+TFHFOzmWcqcHYb25UGZficFJT/Y4YJy2I+3YiR5ys+ZxPsEvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7JLT7bw1ZmwVaFNiGltVS16QCFCucEHeQ6GOrWM8D8=;
 b=g8T2ZOQgSaF4O4FTln/pPCqmyFzjrw5tZ4kKyia3DXHWz5QrwYBWrcb4IvnILMlECWEc2QA/mvr0Aq4br+tt299IAL4Aw53hqlXmVNdOMxA6xTb4RGR5ciH4ujHfeyj/wMBO5rqBP9iFw6izj4dYiJmK+KSJtIO/lOPBjqE7vvcG2uvQMVN3qSKZ4HktV6uhZCz0BaiD+yayTPNoVnEF/JCfPEyN2mNyT3Nv2ONeOjtK6k2rbC4+6W20uoqlGCp1+oLYF+CROAvlnQCaPxGghGobqU/1IjHxKmdoxGiTAOyPvgAsmeR4mccE8Fy7QNN0c27cbd76dB48d3vJpy6nUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7JLT7bw1ZmwVaFNiGltVS16QCFCucEHeQ6GOrWM8D8=;
 b=eV1oQ2wuAFLqiIg0daUgYk7teYa7aoe7FuAnBxhBGo2c9Tro3UzOW3c6k2vp30VocJA79PjpqzYXkURVlKLGqHOya9jRvTez7VVYLklyjO7LN+vbHju6rzkC0gTi06BGSJ5UMbCoH4FdiYnJc67NFzh/hui1945Htw0/vY8YWoQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH0PR10MB5516.namprd10.prod.outlook.com (2603:10b6:510:10c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 23:36:38 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 23:36:38 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] mpi3mr: Add shost related sysfs attributes
Thread-Topic: [PATCH 1/2] mpi3mr: Add shost related sysfs attributes
Thread-Index: AQHYZgdGdvtTQ2/LtUCAVhiJlUTWsa0b5jEA
Date:   Thu, 12 May 2022 23:36:38 +0000
Message-ID: <4348727B-BE3E-430B-B444-C845E2298C89@oracle.com>
References: <20220512140046.19046-1-sreekanth.reddy@broadcom.com>
 <20220512140046.19046-2-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220512140046.19046-2-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fbbc096-ea84-41ff-e9e5-08da347042b0
x-ms-traffictypediagnostic: PH0PR10MB5516:EE_
x-microsoft-antispam-prvs: <PH0PR10MB551669BD54D567A354A51884E6CB9@PH0PR10MB5516.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KwmrGPe1XMs1gTrLIAlRGW1GWquk9laRWfs1viy9UhA1XWaf2lJM4IBjw3WSn3WrYSlqJBqvcYmFpY1M+jJ17ITNMsoKZR49L05dL0fRWJcwn506p05lPa2G4nFMrCQp29g64braPPoUfp+slKt5Db2JNWAbMYS0U7/z+IXaQkFSwWamu4LIlDrj9hYhwZ15cVxf8D8KBYR9e8D6ScaLoaBuoY02gZqaOhtdrVD4pinCiYj3bvSf6VqRb0BtUVlngy9ava7v3LmEo77k/PCTAZkalawdt2xpxmlgCl+tGJkSfipW6LsvmTjkZnQeT4CfgOJdEygBEM+dmcSRedfGnYcQ7WB94MiyFLlyX92dNOVdxQlR8Lpjp4K741wo0cgu3nNIeimALXgfwMDzuUlH4OW2+V5OOcs+Jq5Jk7huhgzdHqb3ItdHWCBmdZBq9Oc+RBqr08YQLBBoGU2AMaW34O9bcFWE4xfBrtuh7ubL0SBLSnraDDrb1qR9hL/VZsVjYN5Jy/QkJcmZYK3NCahnjoDDIMu9T4U6SM44mIl8A2ugJgHi5FwQeBAo106HXMzk5IQQkapZE2WprFhK5134uhDPPWLcOpvTszcP50Mk9qPqNY46tfFDMDKZLUl+n7ahMYQsXQxD+81Oafbqo+38cSasTkm+ItBJW9Qdr/j6jp00dfeBlCmM+/kL5WBJFj6/2aPCx4SI95744ppIwKjbtSue810abI56+O0wCVl9hrcxpWebo7Ophljs8d/DMfkksWUr7uZlVRDXjW3o4TFitA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6506007)(53546011)(44832011)(38070700005)(186003)(38100700002)(8936002)(71200400001)(6486002)(2616005)(33656002)(107886003)(86362001)(5660300002)(122000001)(508600001)(36756003)(316002)(91956017)(26005)(66446008)(64756008)(8676002)(66476007)(66556008)(76116006)(4326008)(66946007)(54906003)(6916009)(6512007)(2906002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r+uqog+28WArXtKC/hGrJ4w8pd0p1UhMoCeGxC/GZSrCQbXciqAz+9RdzW/F?=
 =?us-ascii?Q?VJkCgc9fptWrMxMTlRWYCudhtgLwSYgUaFMa4OQc19w9Ag8v44gvpflTjrAE?=
 =?us-ascii?Q?YeOIBU6g4Ckn4A/W2PzNtS5CM0w2QzI1K9VKuuqQ7UEUHVGAO+27Yi9Fn561?=
 =?us-ascii?Q?z586IKrEJi0r/YNjAx47JXArYUKGn7HDlZ1rY0pQxr+/kNVofW+pCjzR/gSc?=
 =?us-ascii?Q?otUB9X3ABpDGzENy2CJjEqUKTDfO/+dL459Cg8qa/NzuuKbU27HuGdJoMALq?=
 =?us-ascii?Q?5ZwG5AMAj4lJzHzngDf/lEb8djOf9ADiQWMJ5gqvRTVmTKk4AbmhqVpAfuwB?=
 =?us-ascii?Q?HEN0wviE1noAktspGBL8XSrNMeUhAamNEGKu9wfehXw+TPboeJoN3qDHcbXy?=
 =?us-ascii?Q?opfOXLIe2ldC/7kRx0Zd9YQFq/kNlYzSFym+oLGCWaXqgXh0wu6YjPyOY1Gz?=
 =?us-ascii?Q?ZaZKW4ypEVToCjXRGk2vNOtO8cKJ11ZcF6ljwH2+LsbV2RXal7Eih3GU71HK?=
 =?us-ascii?Q?HJCV/PP+zGuAysFf2AXMSU96vurP0o9czmrUEx31sCZ3Svk7tO7JGB1ZuuTS?=
 =?us-ascii?Q?bKbPJppfsvEr6Da1KrnmWK6jxNrUX7kbz/GfF23AfoA06Nzv5x804aY4XXjj?=
 =?us-ascii?Q?kuFCmxG2lgrc+m+/9NDCTB1rgKyjeGdx9+e0B6D1que1YbF+O0/kkm/Ts100?=
 =?us-ascii?Q?AATD3SuDMWvRfWx2VdOdw8vO7MYPBwsHECR4PgQ6qFADwzxYGG1NgCP24SM2?=
 =?us-ascii?Q?ZW6fmQ+/21xVrcOfHj3axKK+UFthNH+bTbQ02y3lvjUcmI4PFppJr4+Ox+BE?=
 =?us-ascii?Q?JZ/BPUBe35JyEB/9rxwz2emqOqat4PsrjhD1xlKWuBW4Vbj4NTlu/ZVzUJnF?=
 =?us-ascii?Q?wZ0bzUoqRGDtrj6u04n09fvyjzscKN3PBBJ/xjm3m78qO2FgM/qQC9jKM0LP?=
 =?us-ascii?Q?RdY6++/u4wSzsyO5Q9QS7RzrPrbYi+bmMuDiDiTEB22tCbxRADO2L09gj+T1?=
 =?us-ascii?Q?HjblJZSmhBcJg6e/NbQWVVFgbPvQJ88F0TPz+FCxTI+Y4DLCiobDG3jlwP09?=
 =?us-ascii?Q?Ft/9er+O2pr6HhfsjHVMwbum/ycL7kaWNBgWqzP0XeEAhHDeWF1Ojohrb2tL?=
 =?us-ascii?Q?1CBnM55kXPNgLcAziY/VTgpYWLUflTfiNqYrLqU/TfEOqULGsHU52uAF+u9o?=
 =?us-ascii?Q?quRkZoKJoo8xo+DfPn3XWV+3l29VpqfR4I/QqlnR4TK8NqSuvU1ZYEBFw+xr?=
 =?us-ascii?Q?/0M4C5t3JrrBMYWpCj/Hd/Ws0vibGhiR4NgMMouCJZhIn4HOC4yvfhYzPYSP?=
 =?us-ascii?Q?PagelOwJEd0fuMvIYn4A/1c73Rfws/0SCAH2li5c4GomdlCidI5veLTSYAO/?=
 =?us-ascii?Q?py5hcCV8KUUWMyROic175FtXKLjAFzLKzG3DcJybrmih14Fe5jmvQiwN9EO3?=
 =?us-ascii?Q?yOVEEi+kTlDdHSGnLeSILp6xFmT2n5sMV3RzucZvP2ZRV2xAPNy8JOnpM1PU?=
 =?us-ascii?Q?gmudgGRWECy5UHXub1AitHXtgn7sJ8G0NB706hTvq+6O2AMYvUZN1wTNmfKF?=
 =?us-ascii?Q?rv9ncWpkhdaE4VY6ItZLaOHhwxHS1D7fcAevi1jOMlxUjKYXhh7AK3ZXwpuF?=
 =?us-ascii?Q?ZslismVYkT597I3kIKH/tBSVcfRUooPe8tgaKXJKVeBH3LI0zR8dg8GfKub2?=
 =?us-ascii?Q?qqAZJBD/pJL2zehr/PM6JDv2gyhJ5W6/g5V09bl9erWb+Ap6TrtZ9OCWjSjN?=
 =?us-ascii?Q?jW1WX2vXyLvmJDnWjqBrBuAHL8bKZiAlC8JZTZRkJOjrh7Qdlfbb?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2FD99F7FD9DC4F49A1E94E8544E8920F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbbc096-ea84-41ff-e9e5-08da347042b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 23:36:38.5749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dyqYhrnriFpDESp/8oTa1GCwreADE8TgFtMvFlSEC1Poda91zddoJea8oL9RZxtqDCfwRdyyDxEuX5A+AKUN0+2JybeHG2OyOwgdc6Ndb5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5516
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-12_15:2022-05-12,2022-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120101
X-Proofpoint-GUID: qqAsM1dEM_kF3ln64CAABFc-9QK9eCgf
X-Proofpoint-ORIG-GUID: qqAsM1dEM_kF3ln64CAABFc-9QK9eCgf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 12, 2022, at 7:00 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Added shost related sysfs attributes to get the controller's
> firmware version, controlller's queue depth,
> number of request & reply queues.
> Also added an attribute to set & get the logging_level.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr_app.c | 139 +++++++++++++++++++++++++++++++
> 1 file changed, 139 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 73bb799..c9b153c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -1558,6 +1558,140 @@ err_device_add:
> 	kfree(mrioc->bsg_dev);
> }
>=20
> +/**
> + * version_fw_show - SysFS callback for firmware version read
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * Return: snprintf() return after copying firmware version
> + */
> +static ssize_t
> +version_fw_show(struct device *dev, struct device_attribute *attr,
> +	char *buf)
> +{
> +	struct Scsi_Host *shost =3D class_to_shost(dev);
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +	struct mpi3mr_compimg_ver *fwver =3D &mrioc->facts.fw_ver;
> +
> +	return snprintf(buf, PAGE_SIZE, "%d.%d.%d.%d.%05d-%05d\n",
> +	    fwver->gen_major, fwver->gen_minor, fwver->ph_major,
> +	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
> +}
> +static DEVICE_ATTR_RO(version_fw);
> +
> +/**
> + * fw_queue_depth_show - SysFS callback for firmware max cmds
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * Return: snprintf() return after copying firmware max commands
> + */
> +static ssize_t
> +fw_queue_depth_show(struct device *dev, struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct Scsi_Host *shost =3D class_to_shost(dev);
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", mrioc->facts.max_reqs);
> +}
> +static DEVICE_ATTR_RO(fw_queue_depth);
> +
> +/**
> + * op_req_q_count_show - SysFS callback for request queue count
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * Return: snprintf() return after copying request queue count
> + */
> +static ssize_t
> +op_req_q_count_show(struct device *dev, struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct Scsi_Host *shost =3D class_to_shost(dev);
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", mrioc->num_op_req_q);
> +}
> +static DEVICE_ATTR_RO(op_req_q_count);
> +
> +/**
> + * reply_queue_count_show - SysFS callback for reply queue count
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * Return: snprintf() return after copying reply queue count
> + */
> +static ssize_t
> +reply_queue_count_show(struct device *dev, struct device_attribute *attr=
,
> +			char *buf)
> +{
> +	struct Scsi_Host *shost =3D class_to_shost(dev);
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", mrioc->num_op_reply_q);
> +}
> +
> +static DEVICE_ATTR_RO(reply_queue_count);
> +
> +/**
> + * logging_level_show - Show controller debug level
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * A sysfs 'read/write' shost attribute, to show the current
> + * debug log level used by the driver for the specific
> + * controller.
> + *
> + * Return: snprintf() return
> + */
> +static ssize_t
> +logging_level_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +
> +{
> +	struct Scsi_Host *shost =3D class_to_shost(dev);
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +
> +	return snprintf(buf, PAGE_SIZE, "%08xh\n", mrioc->logging_level);
> +}
> +
> +/**
> + * logging_level_store- Change controller debug level
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + * @count: size of the buffer
> + *
> + * A sysfs 'read/write' shost attribute, to change the current
> + * debug log level used by the driver for the specific
> + * controller.
> + *
> + * Return: strlen() return
> + */
> +static ssize_t
> +logging_level_store(struct device *dev,
> +	struct device_attribute *attr,
> +	const char *buf, size_t count)
> +{
> +	struct Scsi_Host *shost =3D class_to_shost(dev);
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +	int val =3D 0;
> +
> +	if (kstrtoint(buf, 0, &val) !=3D 0)
> +		return -EINVAL;
> +
> +	mrioc->logging_level =3D val;
> +	ioc_info(mrioc, "logging_level=3D%08xh\n", mrioc->logging_level);
> +	return strlen(buf);
> +}
> +static DEVICE_ATTR_RW(logging_level);
> +
> /**
>  * adapter_state_show - SysFS callback for adapter state show
>  * @dev: class device
> @@ -1591,6 +1725,11 @@ adp_state_show(struct device *dev, struct device_a=
ttribute *attr,
> static DEVICE_ATTR_RO(adp_state);
>=20
> static struct attribute *mpi3mr_host_attrs[] =3D {
> +	&dev_attr_version_fw.attr,
> +	&dev_attr_fw_queue_depth.attr,
> +	&dev_attr_op_req_q_count.attr,
> +	&dev_attr_reply_queue_count.attr,
> +	&dev_attr_logging_level.attr,
> 	&dev_attr_adp_state.attr,
> 	NULL,
> };
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

