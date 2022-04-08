Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516BCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 16:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiDHQtq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 12:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiDHQtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 12:49:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF2E1265B9
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 09:47:39 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 238GiqkV024771;
        Fri, 8 Apr 2022 09:47:32 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3f9r5whb8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 09:47:31 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 238GgW31032564;
        Fri, 8 Apr 2022 09:47:31 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3f9r5whb8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 09:47:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTlcku2h73JHwIRHEySoFb7/vwLr4TUJ7/PufhgZsYCkfwLwaBajzOblyK4QqaweykEfhc4oaHrKfJKeCSwv9ONGUGtpqYEeAHTJ1kbKnWR9WfEMTtQSWSZ4F77OZXs7CPjj+mKy8QCu4Jy5KZB4u+FKmmO31HwdSfoZLaeM8P+j4y8BalFHXecJK/wXnmvTyMWbc65UWSL9KMGjslo3eBQ4IpWdGMk6rjnu+zZ/YNSQYb19KpJiAklAcDCtha2ZqoMVArbTBj2X9i53zT83Xtf7LUtTWMIKQKpgsbgVOsnfIB3ixFlYhoi8l4qleThzBAfHYtHNMHMpSl+0/Eu3JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPwuReA6YtIJ+NwaUBCf7dyo0ThgBaOKyQNdG4y83Hs=;
 b=IHwPiRBaNFM0yIS9C87LhDx4Q2fx5rFCdi2tGqH5RQFiLfaWcVrSgjg+VpDIp3lzDeO9WBf9i23oNHfy6I+AUC1qVqPpFpMUcdwVKw6x7P0rgduZvLIOx0pYuvQ1g5QuaO/+vPFk3PrMWkcfvdp2sQUXv7UBAFEjL19uGwzKYvB3tZ6sVF7wZhka2FmkjoQb8S2VfweeGYtvDBW9Quyia+6WS2qzdc2i6KNQ6xHchqKIhI54psNb3aiOVo0+RkkYo/ffheca0ren7tB6NaK2w3kVZ1yCWjqPFPGhGYB6fhc5Daf5IqiQ2E+24YgE9/u7D8MTFdmDLKHnP9dB0vGclQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPwuReA6YtIJ+NwaUBCf7dyo0ThgBaOKyQNdG4y83Hs=;
 b=LuZEgxbUh8m7FoIRtTXsV03UrHgDygdfD9IvXhto53ngBz4FFPMD3kGXaER9ERTXPNIMyevSCXGcuoAgDtlY/9P2cgAbt/BEcBo4rcIjXQFRoIXR9erIK5T6OaRgxkNuq32GZ1CO5zknS1TTxvghy0UGR3Js6aXdVzJNCrn1KZg=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by DM5PR18MB1548.namprd18.prod.outlook.com (2603:10b6:3:14f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 16:47:29 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::3412:b64e:80b5:94cf]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::3412:b64e:80b5:94cf%5]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 16:47:29 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 00/10] iscsi fixes
Thread-Topic: [EXT] [PATCH 00/10] iscsi fixes
Thread-Index: AQHYSt16nLNMDxL98U+F5ID9Ab/6fazmOZow
Date:   Fri, 8 Apr 2022 16:47:28 +0000
Message-ID: <CO6PR18MB4419CFB012FD95595DA8FD3AD8E99@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c6ee942-d1c2-4e57-ffc6-08da197f77ff
x-ms-traffictypediagnostic: DM5PR18MB1548:EE_
x-microsoft-antispam-prvs: <DM5PR18MB15480F0669BE0D470ED9AD7CD8E99@DM5PR18MB1548.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OdesOBc6qLlw0SK49ZnKfE/PqE0JiVcInfJz/EIjQrOXzVTW0MGYjb+e51K6saVdtDyUHw2KT5MetOW4DbeJW8RGdyq3JLVIPe2qB2pUo+gFqJO3HcI/3mlF899cLfWwnmQplr1JKRNSG78esPCCv0bTg/M3FqDHeJEr3WWB+2UEjCj5jiU6BT8K24oEcbnXefbaLpfNXi49Lb+eluEjk7lOB1U6atCPA+n7lRCcnDB5CA70HrzH9B/D4q+cErAbNO/Q61Dsz62aUgOKOeat/7JTBjiFk3TezFFhpr5z/KS2dRV902wr9dtlnXSY+t/fTGvpipWbdTSB6gJtjFReyZ7Ebx69sYuH38GdE0AX1G8Kbb1B2GxS/SlAWE6MesMH3WsB9gNNE4ezxT81bNSnGx1aUxz5oZV4rOpUX8jiPuuKi1JKYrd0gZO2dwmSBvIXc/mpkiI6XMWJGV3yshXdmkV9kwa4MeugYng5Z7n1My19vl1aRYnZzbQukf0aExIj2POHZb4YEw7XPhd4Gni7m76AgIJoNfDEeN2pn5WtfqNPCG3cEawUAh1bFPBGQgf0iTVe4p+X5miTrEUIxyfpIPV4rnTquiZe31eDdjI5CND31PzfSMOIpK87RhWdbPkiYP27/5nCvyjcQcOTphqJ4pakhbgk7ENShKpd6A++/6Ie5H0682QJB4iT6zlLuU+IemFjPUzmBiO7e2/mNyTb6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(66946007)(66446008)(76116006)(66476007)(66556008)(4744005)(64756008)(33656002)(83380400001)(8676002)(86362001)(8936002)(52536014)(122000001)(38100700002)(316002)(5660300002)(2906002)(26005)(7696005)(186003)(6506007)(508600001)(71200400001)(110136005)(38070700005)(9686003)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9vNg6+KrdUimBafpaQPieQvogcllUxxS1nOQCe1Hk8yKqRgum06uGad7X8+z?=
 =?us-ascii?Q?RqGwq8QRSI9Tg5JZH+yua40M1ZURsu1bsiqALGK4iAtwaQiP2QcXj2dWgAcu?=
 =?us-ascii?Q?vv7h4sjrql30ybgwgMMUmrNZO19UpVJwoeDymY02DL74sEFyxIXTUY4nQfCh?=
 =?us-ascii?Q?N8W9Stz8EDrsnAIuo+G/1nQ2vSlP725w4LtQTvUHqfTH+Zi4kkNDFYKtM2+U?=
 =?us-ascii?Q?qliQM8BszOpyBu1L6uvLW2PwTgPjfyG2lVs1TQfdbNWEMW7ElUrSOvFSZVKQ?=
 =?us-ascii?Q?ivKLqtjVBtgjYE2H1ytgFx+026jAJ7vpRkxyW9uNxVxx2sp+eVZ+CAb4102o?=
 =?us-ascii?Q?uU1hN4YJilaPvWCQ28sdkG//2HNhLrqEVhCvb9+t4zR4+TZRKY+vL/FqXQXI?=
 =?us-ascii?Q?dDVUF/UJKQukrD7jwFPK4ZxTL3/YmcTkys8bl/PtdzY5vnMkC+gU0BtYv9V0?=
 =?us-ascii?Q?D6JGMusuEotIUULG5mShhdt9gS9sQ4qGmK5NzQEJ4fyxoN0qJ8MKXWvrbYoQ?=
 =?us-ascii?Q?MVIJL3w6y3oRdzc0TsXIkZjl8ivZ5IYk8Ofzt98bJ/q7MpMWgKzR9F5Imy50?=
 =?us-ascii?Q?2nv1oD0zjFU0K+kFSiOmHPR5dhsUA1/v6ct5onaUYtHsxnVlVYdiuPyDDg4o?=
 =?us-ascii?Q?TD+gPVV5TATYL9qGhtcm9o7HR0p5Ny7ESDTmg9NNRWZsrZ6hGDCewSiMogg2?=
 =?us-ascii?Q?NMlyudCNrqKrYeYJcXr/QicgVTstdgYKoAqk1JoCRX6qU0rMQZzIvzhFJmP4?=
 =?us-ascii?Q?jnbJxmMzN6f8CsZIQg5SYJszEqLzqhuBxr/2Pr96lw+BCzSxQ5ycmx6Pt3w4?=
 =?us-ascii?Q?wILvWQit7LcWNxM0/zKZf7osiPBKPVT/K10W4VdQ0ELU9E9OJnwEwao++IFj?=
 =?us-ascii?Q?9+kvd8eNR1fe34/jTq169y2CclcdbQ25qXjWTVxEjVDm40emytN+QKhR5+0D?=
 =?us-ascii?Q?w0vGrWOdvWbzMTQ2vK/8fiuxZV86Hcx6KA0wYyUOvKm5ARJqa8xhRdQWU6iT?=
 =?us-ascii?Q?V8tvt/5SPqyJbdyTlCsaSjVnsgK2YdRaPTyAfiWr86DNuSgiIDoz/IRjqRlc?=
 =?us-ascii?Q?J11Ar2Mmumh8PzmPgiH4sDnasAkgO/Z9JmnQOIBXUXdAWxsXMdjSMMG4NrSU?=
 =?us-ascii?Q?4rQflMZGkmEwcl0bkNAqV62Bstf+YpfGlOwLe0WD+ruFHcTYgxtNtDnhH/dN?=
 =?us-ascii?Q?nNd8HKo/TR6rubsW1GCl0N7hsQDAlgRN/LGDXrY8pGzh9sUpViwtqGsqxuCW?=
 =?us-ascii?Q?O+ID6CvnHg1dtDdGMgZl6ZHanyWdsVd0Nk4z0bjeoG4gVKb6wSK1Ja2IahOw?=
 =?us-ascii?Q?WdNdvusFoCuIjkAKDtglbCh81aiC7eaJdXxVGZLCyEf/+AolnN2/eR9EnRYo?=
 =?us-ascii?Q?2uFGv8xKTDR8tsLhzkmmHOafdTNxt97T7hHd4QfBYmSKiX5q6jeTw/sllk8p?=
 =?us-ascii?Q?6RYIxJ8gTG1ySKqNaOq47kBU07hsEEP7sBMrsDWaL+nVu0Pt4SlEQtE+07cR?=
 =?us-ascii?Q?Ovj0885j8HpQysUm5hat54ul97TIrP76NxOPf1QUshG5iXCg3wEDHwpUihUN?=
 =?us-ascii?Q?wiWkguMFcPW6H0i386Hr0OSu27A12R/1O+jkyzCK3Ky6L9QDApQGTPYPIIh9?=
 =?us-ascii?Q?3gyCA2dNd1JDYnaS9ZDa0CvgT31pjLZM7gISAIykdTqzZRYZq+pOCG2OKSvF?=
 =?us-ascii?Q?iwap4zDMoAWE4UoDb1Nxg7JEFxGSAPQUd0XDFdpGx+mu5btKLEFSqq+o4Npj?=
 =?us-ascii?Q?qBBm3Ktv/w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6ee942-d1c2-4e57-ffc6-08da197f77ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 16:47:28.9903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /GEDKYOwT41OkdJS6skO2rQ3Ej67qDrZfmy2WYEzu/qQgb4NK0VADHYculz//FBd2My8ummCes6IX9xywtSxNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1548
X-Proofpoint-GUID: U8w7yIt7ZVLYI62MBbc5s-lITdDUSttL
X-Proofpoint-ORIG-GUID: jy4s8pi1xzMnmE0vO3340WClUtQTmm5Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_05,2022-04-08_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Friday, April 8, 2022 5:43 AM
> To: Saurav Kashyap <skashyap@marvell.com>; lduncan@suse.com;
> cleech@redhat.com; Nilesh Javali <njavali@marvell.com>; Manish Rangankar
> <mrangankar@marvell.com>; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; jejb@linux.ibm.com
> Subject: [EXT] [PATCH 00/10] iscsi fixes
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The following patchset was made over Linus's tree and contains fixes for
> boot/iscsid restart, more fixes for the in-kernel recovery patch, a data
> corruption regression and fix for qedi connection error handling.
>=20
>=20
Validated with SW iSCSI and offload iSCSI (bnx2i and qedi) and both the reg=
ressions are seen fixed.

Thanks,
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Tested-by: Nilesh Javali <njavali@marvell.com>

