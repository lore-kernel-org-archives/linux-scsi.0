Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B870AC32771
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 20:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351460AbiHSUfJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Aug 2022 16:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351270AbiHSUfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2022 16:35:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4027A80375
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2022 13:35:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JKJMmc021518;
        Fri, 19 Aug 2022 20:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=l6Pjwg1fbY1Uth8HDrhIQXr52wcRbL8vC4gNcU16H0M=;
 b=GjpfIWId6tEPF7D/EjP2ZkkBkUWxJ/2dKmow2TCBbDESi247Ib2P5l55OZ6/9f0GDyNO
 qMVYosofPIVMW4ulLuIY+juPI+bCdvHnSNzfyIUz+QCi/Z+Brc6Z+w4PRdpxFw2Bg9MM
 0lAh4dfpHMdeL37aSaalEOhd/RZEGTMN5QhII7QvTYs9U6cjNDGM3JcK+fy8JXpk36iT
 ojrv6R4nJBSIQym/25egTGaef81jJx4e9uVFboxneDFReNHnN9KcEs7KbPNr0W3z1asr
 97VBogvAquiEGYWbZP8+k72XWo6JcHcehKrQ6tAG9j8BvaynR7YK0l+8/f6fGHjwcj50 3w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j2hesg0s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 20:35:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27JJ7UM9023768;
        Fri, 19 Aug 2022 20:34:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j0c4a4btx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 20:34:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgsZHWJWd9yKCBXku3q02rWCuolLh7ryjNJYIWKKj1U8g0odCAtaxMwA2HWU5btFMszrNwx8qmfCdHH4p/OvRIXqrT90NLT/uJczDWQbMBIehz85IbpzuKdc3MId7Rph28hkxbuu0/tre7wMQTF9igEkrkobExAIXpu6tA3yLirUDttf7N2LqCzjDwFtuNhGIfdwHRZceyXhxPyJcljGCYNuccX+qvY40haLC99PKAxE3gRbWKM8ZhJp556UEXr+t99/8OxQbYR5EGfheQJ9VJZLwStiRwm/6cay+1CMCil2O0UqdHKUYg5r4benGLOCXrAG4ZtmjiwiUz92tMTTQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6Pjwg1fbY1Uth8HDrhIQXr52wcRbL8vC4gNcU16H0M=;
 b=UUFeCazkG9q/MpeYje2ZKZ5WdtLeDI2WkDig6J8vZ3sNPv7g4UH/ICVRkmQHU5Ioz4ZtL42dOPdIE5OBH3jXEaeHTDlartC4xYo3GTxu4bG6wao6zrmxIhdvd9ireLsVgL3dV9HEDWfpQM3RNPulkTDSzfmsoa5DDgjlASnrO391YYkEfnBdfFRBUDPVWnce9twzCIDyoVNaigHuWRrUKvsrGLKRoRnxm2TW4hgFv35eEK4MjOqY7UiM4ro+bmHQWXCJSBwMHvaKKPiJ59J4tSPK/F+EH09Yi62WEWvOG8j0KGbSdAVa7NTZrehZ9Z+rSnH9OXaC/l/A9EvNvq9LqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6Pjwg1fbY1Uth8HDrhIQXr52wcRbL8vC4gNcU16H0M=;
 b=BRvRmpTgLFZ7QTSXaqSJom/87hPgLievrua8WaWKzp7eZCbcAqgF836VLzXbcP3dlDfWyNMRjIqh498eqrxyjJkznsVgkzVOmOkHfvdXoP34lm5Qhz55S27JJhIFojf+8PTOlriV+5RPUp4Hb/1YdjMhnAnbqIcSt29747ES0zQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN6PR1001MB2115.namprd10.prod.outlook.com (2603:10b6:405:2e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Fri, 19 Aug
 2022 20:34:57 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 20:34:57 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 1/4] scsi: qla2xxx: Remove unused del_sess_list field
Thread-Topic: [PATCH v4 1/4] scsi: qla2xxx: Remove unused del_sess_list field
Thread-Index: AQHYjl+ZIAbKxw8z0ku5tELATwO4Ja1zdr/SgCzR84CAFrDYAA==
Date:   Fri, 19 Aug 2022 20:34:57 +0000
Message-ID: <0401713C-21FF-4FA9-AEF8-4D590D6E27E5@oracle.com>
References: <4b3c4c8f-02b0-4d95-85ef-9368b5557cbf@I-love.SAKURA.ne.jp>
 <yq1v8s84ne7.fsf@ca-mkp.ca.oracle.com>
 <cafa1228-d9be-69a6-b748-4f4503315f74@I-love.SAKURA.ne.jp>
In-Reply-To: <cafa1228-d9be-69a6-b748-4f4503315f74@I-love.SAKURA.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8b8b77d-e38d-4047-1b6b-08da822247fb
x-ms-traffictypediagnostic: BN6PR1001MB2115:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BfmcSMokVVtAPUvcFMnsY+8jr8/5D+TE1eQSvIBgtzrN9ZH+uxCJlNHQj9dhI3llxcdmfWb5yzm4Js+GUWulT966CDXqZzhZ829kqvteHopnT5neBEYrp05dZfVRrUkkB9wFUVv/h7NZrMDNFcZSMWgKQgvhRcAMyRy7+f9SZ4oRpawhmyPCk+nXHPtG1kus/tr3WpJvbVUYBnWnFh3/qKdAw4MRGvLXChDw4MxJuTvjos3eBdnf9FL7CRgjdxOCKvzZDPJOgAmQaWwhNKwKTHS1+oMeeTTfkCLvp89bW/R36rkoK/q/3LQ8lp0VcJaaIW+Y2MjuvMeqRLqsEaRSfwePUqQ71GBBqg0kK/dZhB3wFYeah9Nr+lUFz+HH0SjDx70Ebbo+J9fOjI38xtfU0lsPLR7c0ypNT2Z+VCPuPDJNO7Mny45iDv6jUa0HTRUxwF4MOE6fPxOO+8s6SaiiVT6gukVR2IMgq24TtUMwt5288uyjkvowMjXeGIUH/P/FKgQTAknyM1KDkzl7MFB6EXyrg/p8yhWzkj3CvfS9k9njEjQ4ToJMukhinqpWSvlzGwEk+Z+/zq4lxchcLlebtixSzTSDV9TmhRcehpUzjX8yOKErJBLv5sqUcZvqrTfFB/h4wVwn7Xm1prSIfiKlLicjO+1NkKcdW6C3G9ieE3fOHlxo5sDB7sJusjXX/xOrPDCPdthXqYXLVqUhpMC5dKqUK885FMcWc8mt1ZDKIVsMEgI5/lDrczwC0xzFY6lOgdidnwUNW9UQsxKEKgGwf1Sha1fXjrbP25l9Dyw13FM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(39860400002)(396003)(376002)(66476007)(38070700005)(6506007)(6486002)(26005)(478600001)(6512007)(41300700001)(5660300002)(122000001)(86362001)(33656002)(38100700002)(36756003)(107886003)(83380400001)(66446008)(186003)(2906002)(2616005)(76116006)(91956017)(4744005)(54906003)(316002)(71200400001)(44832011)(53546011)(64756008)(8676002)(4326008)(66556008)(8936002)(66946007)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eJE24xZXF/v9OR9UnwWlJSXVBb6KN2UP3CGKBJ7wDa2QGcuN0esbAzmR6Dcq?=
 =?us-ascii?Q?FWW3Pfb0LnqJGLDpjYQ2+JQspVD5BuCBTpTRAcUpvXJC7QyvFlOOgQWYy3wR?=
 =?us-ascii?Q?w6yrfjS/Ui8Laf93EiUsJSMpQA2Izq/ajUuu7Xf5sKMRMcnBTH9pqDu44seU?=
 =?us-ascii?Q?3K2i0ZU+973C0uOb7FvNOlCU9W05EbLvo45FcBzGcJKcfHUtrNeYoA3mILoF?=
 =?us-ascii?Q?X++lQMzlIaPUqk0dlSHicoxJF67vCvyvbSMVCsv3dmYt+968StX5S1TAC+bg?=
 =?us-ascii?Q?0/UTJu/iq3e5nuqNa16SWt/dlZY+f55FDaLfmYLjvkpjXYNtmLs7xQkS7s3G?=
 =?us-ascii?Q?tvYPS0I+RVzYzmbnMZmkoF/Dl7kxQ/DdmfPA5Dg1Ka5S+oN8vurhu8TAN01H?=
 =?us-ascii?Q?H6CYLKoOcddlTGiFQyxugId357vZqEo/RwTWDzvuJETM1a4kcjV6XhjUNoST?=
 =?us-ascii?Q?ueWRn/w+APkyuW9qSmM6rNeoltmT4ubsE/gXz3OuENhk3McfRJJrCAeYbQIl?=
 =?us-ascii?Q?up3mwcEU9YvvR6cUDgfkU+E8ECQo3cXE2aV1HwGT9gaLw+lYeWW/qGFdkkET?=
 =?us-ascii?Q?Psxln+R5JCRJIcJA/gAYuTAMP9BzW6bVnJeaNAA414AMpEIuQxvSSAdYKXN3?=
 =?us-ascii?Q?JHuXDT4vZklZ+vagfE4Sda0/igrhbM5SgH4c3Uo8VO8A5ONBD8iFrBO+rPiC?=
 =?us-ascii?Q?l8yPF+9+6RbDzqe6CmT3S3m9inofH6nQXSF6fuuqgvGqunPtDdxZMwzYId+K?=
 =?us-ascii?Q?F5aXi/QAzXpdaRPqrxbXWDEsY1aypz5M9XX9wEjGx1/LqHk0DPdcxnatV3aZ?=
 =?us-ascii?Q?2WGk5ob4pD8n/zBR6BjgJtTmmz/qwGACPP7XhXrKUuiRrF/uMQwkYZWa1rIH?=
 =?us-ascii?Q?et0IKJSZiDcwCWr1fZyRHKFMgUJ/1CwJ5LUpONvjAwAYmgsX18PkaxrYLnge?=
 =?us-ascii?Q?uTdi4OqjK90Im9QhTGGZ5O+dGH9Fax7mFtdAbAXuvjV4RbOVPbxCxXZB8N9K?=
 =?us-ascii?Q?FCpjxpHcnFwbYp3MUnc+ibqinohImX3X6ODFupZH3Ph7+de5+mf4kf3QHF1S?=
 =?us-ascii?Q?4wyucWbDpzZYMRy28Z/EcSjDNeuWAM1yqnuXiEP+xtfnBelBNYYyjMpYj4Fk?=
 =?us-ascii?Q?b52UCx7VrbQ9pVFlWrqinHVFwFi8DnaZ+hYHV8eHs7OIhbARiaOHjCkyDIkP?=
 =?us-ascii?Q?E7rOAt+NhamYkCW98JgAzOT55J4jHZqyNFxa+KkRZ34Puxaz+rSXBYtk79cg?=
 =?us-ascii?Q?zwmk36vfJpVBmdJcOKIJvMRP1z6+Uqzk3hgER6Ns8OfXw2muyeiCrurIWZrP?=
 =?us-ascii?Q?mW1rs7jC2j/GwPLx6e0CgvS1j8eJBsPiN4R6H7CiNUwQULjpyee8o4sll6qk?=
 =?us-ascii?Q?aQQC20g0MEmeoQb+nZaMd+KClGeuwKbrRhn6TXeaNL3xP39vFILYu/RiMD8t?=
 =?us-ascii?Q?V5c8IpAyt6Sex3lj0jKlXzW01MNw3m/eorDHPJU8G7ZDq2YuHYmufL20ffoG?=
 =?us-ascii?Q?8lg/jCF2TzX7m/wkW/veCZ5eTt1Xd/2+YJ+LQuX4sO7lW4RO1lQ2C2FlEzE/?=
 =?us-ascii?Q?5OD/pnG9XDRIoLWXx5abD49mLNKG4KhAGf7g/8FXXu130UJF3ATbQg7YdbF3?=
 =?us-ascii?Q?ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F3F339196E7C2C40A4BCD40E45CC066E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b8b77d-e38d-4047-1b6b-08da822247fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 20:34:57.4171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HbGhE9a7ZI/OxEeueOcooKaAioMMvH8bu82Lr7aBFuyOMLsqEyPAeFUD56P1x6O4cgEPT5wgYG/qS8OHSkwk2ZjmtcAK7fIAkiSeiFF9cDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208190077
X-Proofpoint-GUID: jr7VTxGfhOKCD74s6uKxuDjjD5Yp2Su9
X-Proofpoint-ORIG-GUID: jr7VTxGfhOKCD74s6uKxuDjjD5Yp2Su9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Tetsuo,=20

> On Aug 5, 2022, at 3:04 AM, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne=
.jp> wrote:
>=20
> Nilesh, I still can't find this series in linux-next.git.
>=20
> What is the status of this series?
>=20
> On 2022/07/08 6:35, Martin K. Petersen wrote:
>>=20
>> Nilesh,
>>=20
>>> "struct qla_tgt"->del_sess_list is no longer used since commit
>>> 726b85487067d7f5 ("qla2xxx: Add framework for async fabric discovery").
>>=20
>> Please review and test this series. Thank you!
>>=20
>=20

I have reviewed and tested this series in my limited Target setup with QLE =
adapters.=20

Would you please resend this series. You can add

Tested-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

