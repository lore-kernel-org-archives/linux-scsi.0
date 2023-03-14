Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CED3C6FD19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 01:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCNBBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 21:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCNBBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 21:01:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4711911D2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 18:01:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32E0xqOC025734;
        Tue, 14 Mar 2023 01:01:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=eSTQdY9+qCyTlVSaenYFrED9iVM3rtyOScrc0+MS7eg=;
 b=aSLMJnKcxhZ440qIW9UZMljcz0RzSfCUPKPWgbxji0tF/7zc53bt6sIM9Js9i0d/S3a7
 x9q+GTsY76G2/2VJ2spRTqT34pUjQfiglH0ZiGBwbmHE0MbrFp5aOv2sEjgT8gWQYpsx
 0OjMQb3zmQlnik750AbqEjxdqP28e/sUKRqZIDKzjctFLx+fZIgPjcPf0Ot5TMw3OKNH
 eMssLVLWqSO51uKcjcpjgeU9SMRImrfJuRSuL7bFb/IVgYt0oFAdWdeSsXMfe4K1vjW/
 JZD4Qpqyw1V0ALShiBX4kksyn6l7IxoLQX9V5dTwmjrszwkXiH66N9S0RXUI7/kTHDyH IA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8g2dn4ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 01:01:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32DMwpKP002582;
        Tue, 14 Mar 2023 01:01:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g3bxs8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 01:01:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/rYUCqn7gRB5InyWYgOBDYFSL6N2xteN2mCszPnsyHivlBTNNzIi0oO8VoLW+MbASGMaPS9Q1rjf6GT2gMRfo2hCZIc5geCjtaOCYKK4yk4Ti7zu2ruYzC914WqocfSv+mdoQ17WqSgpLxBguJQMGsy+mZedFfgR5FsYEDdhg2PC0tshIa0wPxb4JOIuwy5TqaAGl8yAlBUXpyEa7ubgnJfoG/PhYDztVBQgioJnfZKN+27hkHJkn32S5WGa7ccQD9qInViJFFhbeLwcbAg0pMKVi3XonQ04oXBxZ4qu66nHbB6U4DosGmZzfur5yV+pXBrJ+DO/AG75oJY8f1mTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSTQdY9+qCyTlVSaenYFrED9iVM3rtyOScrc0+MS7eg=;
 b=a4S4FMnBiunkTbr7yn252cDsh6gDrmQWu7IxggWADi5eq1FJJ9U07qD/DMKESudSEDkUvkuYKf0/jDpheC6FPZAov/Fu0EWUyfDoTnVS4AYGV4dwxa4PP3CQLhWauBadFXZt+EG98QQSVCcX41t0+dvk/7PDc0SvTF/pTh5gMZ2xBRafgKJ6smEibdxzh4wYqsKLIx+R5oM7Z/jD1GljVJVvmknDMvIjdXBn7PFQB8Hn7wUbqty/DTAWuTf/pIEjzOEVmMCWzI2gZtuFdwuiNhKP5AfWeA8/tMXskbOnQzezqyWjrgPdtKGm791fT9CA8LfwnkRFCVpL+3TyYJWdmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSTQdY9+qCyTlVSaenYFrED9iVM3rtyOScrc0+MS7eg=;
 b=0MZxbYtnolyAwv2bPiR08KeLQV6c2TihJTGY7csApAjNMYXpeO4QnEkURvMbVqyYNRGckp3lrt5MS9aCIQ1CNorRWe/N775gZ3u8/BcaqomiHgueWu11BR0EBna8l4nddEsRehpZ2AA73fX7AHOHukjls5XeeKme/Tkyvmukvg4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SJ0PR10MB5599.namprd10.prod.outlook.com (2603:10b6:a03:3dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 01:01:42 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::3c4d:2182:8a44:31b4]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::3c4d:2182:8a44:31b4%7]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 01:01:42 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH 2/2] qla2xxx: synchronize the iocb count to be in order
Thread-Topic: [PATCH 2/2] qla2xxx: synchronize the iocb count to be in order
Thread-Index: AQHZVWWLj+jvAnOTKU6D3PsYOm7I3q75djoA
Date:   Tue, 14 Mar 2023 01:01:42 +0000
Message-ID: <A1BAF4C0-5C10-4C3A-B4E4-5254F2ADDD2A@oracle.com>
References: <20230313043711.13500-1-njavali@marvell.com>
 <20230313043711.13500-3-njavali@marvell.com>
In-Reply-To: <20230313043711.13500-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|SJ0PR10MB5599:EE_
x-ms-office365-filtering-correlation-id: f49b8941-00b5-4675-6216-08db2427acb6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fgh2h7oX0D3qhUd/ZQ28p5ovomPNXkJVD2/VpBGvczQeqrbbyVOeRM6S1cdrGHY9wwahVEP24+xk97K21tVC0pfN/oC8vUXP3E8uQoQHN7aZ0wgG0bQLJeWXZyRWf/jY1D/NDzIm6zBp+wBsncMBRwfpgiJgrNoRDQnTevRYdynfHvyqOi/UiFmq7WRmvDaQfh8d39VLGbjkmcRV4NKNKM5Q6GubpwJDEw/21Mxi1987aV38czdMDjTdcC6+c+lT81PGjnPt+c/fkWPfO47mBLY9NOkcToofTaGQSI29IOdjvDHy8EPwTGB6BQCMavq3LNBha+4N+8Xua3J7v8VlzIiSqkl4CT3l1ggcCzRhtZTNQiorQKwEhQ6kmFLFTTPrSpbYPZIbXYzclvk+wCaZamK+Jmg7RfIUfoc5Ztyz0doeG8jhpWUen2kcLOZn7OT/0AAdmbxrmId693BSNl6I0sBh/CJnVBuJGp2+1OSUfsHokWI4uoEqGBQnOqzxvOMWyBAYRXy8FHF/IceIDKK+eES6Fwl0sUlVmqtDrqg2wnhQHj06pV14PAQhesfGF172/rpbAw7aT7XKzRj/ew5vWAJaO6WGbfa5NPRnjT+TyBKlKpcOLMkHsn19sADaX1xwt4EV9kCSctH4qAznPuaoDIlymgyx17OARnqmGprpPMcZWh1Cc9C9fAaFAM0U8Ot2zTca+I6aaxvfFyh8rQ1vw/RWmZr9CIiaCxCUmUzESyM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199018)(36756003)(86362001)(33656002)(6512007)(41300700001)(186003)(26005)(53546011)(6506007)(4326008)(5660300002)(2616005)(6916009)(8936002)(54906003)(316002)(71200400001)(478600001)(66946007)(66556008)(8676002)(64756008)(66476007)(76116006)(6486002)(66446008)(122000001)(38100700002)(38070700005)(83380400001)(44832011)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NOXSlcLt9qGO0hxgCAwuurTPYixmwnm58AdD1xy+EYlsLKiHuosSozUX58hC?=
 =?us-ascii?Q?5V8Oz135zF85pneA3Yc16BpnCPF9Vf3H6BlIZAYimIzaD8dPNHP/gits/+ja?=
 =?us-ascii?Q?U2FeREa8aW6c0AxZwiGjyj49684w5NC7f/8hMax6Ed+PwzaWaQHaeW0gZ+Ap?=
 =?us-ascii?Q?3DbjSZhu0WGAx+g8QmYQG+Aju3FyAkRRfOFfhiyOfjrY0DaVa67LSw/ZJSN9?=
 =?us-ascii?Q?f6ke253i18Z8jE6YA3W2w5Eyx+vHYhuoftcsRTUG0Wc4ifyKmYblTvwR8Lh3?=
 =?us-ascii?Q?3uqJ69+mNddRvdwQtdqMvwNX2m77zc6SitE408kU04Rg0ZekyLWnm0sZm9rk?=
 =?us-ascii?Q?yiN2EmZrEk8BSkV/EuyHt5u0uulYPPK7+H1sNGvsLCaMUdPU8/+55rQip1k0?=
 =?us-ascii?Q?TRhzXtlC4jpVTPhGyBpkUdLnmVU9nMejhzzF4XzlKAuFCbU+zfJO1n8nt+cO?=
 =?us-ascii?Q?nmPhfPCNNzWxEDmF22I7CvgLqomE5EqOov5AyJEjmqfSzoH6OjPx6tIpKtnV?=
 =?us-ascii?Q?qVISYZS4anRMR1euINvly4GDjvgjnnLM+3EHFW34/L5DNfpRdbAPfiAI+PeI?=
 =?us-ascii?Q?dyyDQdo7Rwj7f1+kweD1C8n0wiIqrh1vSefvF1SVUsG663QLZtNQNuT5bkC1?=
 =?us-ascii?Q?t/JRwQSrMN6amALv/6TGQCrHpbKAM99Bab30hckKQZpnWejOOsDuQ9ylbY2t?=
 =?us-ascii?Q?Qtqxwb2bGLzybEUW2mGUy/Rv21yDJC7aLOj89NXrTzTNsl4oJOKZ/9MOs6bw?=
 =?us-ascii?Q?3VJazPXPQXA4srWHibjo1PPd6W/qnNWFdsQwIrFzO3Fi3N0bZ9sB/kqBDarC?=
 =?us-ascii?Q?tTuazVOi26QJb2gYntREtHePEt7j5py1+rQ9Mhix4onGEetaTHX7Y8Zsupp/?=
 =?us-ascii?Q?jsRayN99M/Kkt36qrg+7ivLf6mBf2xMpLQPF1jZg6YCvJyq13iVsNfW1nK9M?=
 =?us-ascii?Q?I3h1tB533ZYiQ8Aiebj1eMLPcWp6l9GgI4/JGzej9KEPcAv4mEcU/lPOSzeW?=
 =?us-ascii?Q?hQg+iy/Ox4nmgzmYEKTKyLngtx89fyo/H44N21qIqQx+jj4ISGQsdV0u+iuB?=
 =?us-ascii?Q?K7t0DnMJfd/cI/xiEwsuCAQusyVTp5Cz5+9nKLXcRP9HYiEYPXsukRIpTVJQ?=
 =?us-ascii?Q?4BVRf70Tmik5a3ptcMpgulKhIXpr7zOhpn46ghHHT8pxvsC+uyyg30hzdeZc?=
 =?us-ascii?Q?KvHuWm04WcRoAg46BEXq6Ijy8YrJmNw2/JZX2v5LXgUYGsbUCUdicaF9ok0E?=
 =?us-ascii?Q?QBRpH4ZWGXCa/kIBMoSemdQ0gNjVABqlmRIVO77WN9VkZMh5/kZIPU/WLGhB?=
 =?us-ascii?Q?xZ/q409b6VwuvCQfQQFxbhkSkHYTOHyEv8iYfxaUO4TAEvOm9qFajQl77fUp?=
 =?us-ascii?Q?VN+0BNjGCjKO2M2/QXJzQsf3YRXToA42dvsCXSD+H9ZPa9qYHYbuQJIbrVKp?=
 =?us-ascii?Q?lpDAP9ykzo+sNc8x02WDvmU2/Ji8e1JP5qTyBrouJdngKgtn9c9F8XKpoB1Q?=
 =?us-ascii?Q?P5326UmWSzv62l4UVxmMSAif/HIaUcyRGxIhL0PsU0pQFGJYI1pm8c2KcesJ?=
 =?us-ascii?Q?BFrrzyatuDVdPltA25s+nZ4bYbi5XHKSClGCON5sxjoq/FHTgQiiAPHHjoJe?=
 =?us-ascii?Q?GQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CF96AB6119CF06409308D28683200BC8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5Q61p27Y1VblcD7v2dz+AJfULp2UHb2NPvSdZ5aH49llgzIsyJnVPNzT0VqRgduTboQga081c7X/3BJvhWfHLlOEi532GZ2yr6lXB+qSnZIczLS52bwR9u/LKtc5Me/yji55W+aBSxiJNWQkDNejqK3n8+a0fhX4EI5pPZ73UmcFtP6vL8e15IfeqiaynPee6CcYzadq5h2zwLZyM5JtHvIQgqLxgbXCppKJLKzu2nYuZ2IWapWu1g+HWkKm2vVEro8ZCDkBGieex6qBgodiygZd5kj6wN5J6fcbJK3Q3TYSxWgCMx5UFnkKiQcqnRdJadgfviwFfN6lPxuVYvf1sMf0yPghd1tCHC4BPvFbEdHLdClyzQzhh5DZoEEAcTlYuDmFoVnlAhW+gx+/C88jvZnM8Ywo09XBoCOj0IljqssCXR84+qEONzfFRdCBuMStgqxLSv76Z2zNsg3CHXswBHh+808eqIrMOIoPawurqREruchpkOd83imbULOqsomoK0U+9GQxB6GiXV4WzqXMAhoVkOllULFUYRg80DoM3kq0DiISBE8ETvTFFwaS6tvIOgtDJu5zcV8zhjwy+0n/bS5Su2HSXGvNxNuWHmoh9/Z0IimCOrpeTZlQMXTyj3N/0UbqUqBSqR8Jn7mpUC1UO7VGTm2MoM0b8184uPQ4/ooBw2bkcD3KaIwKGshmo+1VnFGvJu7qFDT/FCyyr9WLDAH5JvaDCVXxJ7scUzh1JwBfRJ34RTsQ2BXnjZcIW1Lv905dWdAtKe3Qre59Xeb7KAZqu5kLS2qgOx5jkYTfJOSzi4UydOEvrX4qZyV/vmON
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f49b8941-00b5-4675-6216-08db2427acb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 01:01:42.2702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: esNFxhlJP2SyO3iOZOhAgwMwGm7UqKBbNqjTBMRuW2+Px7V6ba30ZRzYfY1fQ/Pw4sSwZCuNT6NXuPn4DzpPAT/9mw/ttUXR5OGFxMP2QQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5599
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140007
X-Proofpoint-GUID: ggjAXbPJsAmCIsnpdThsmktKroW9PFDy
X-Proofpoint-ORIG-GUID: ggjAXbPJsAmCIsnpdThsmktKroW9PFDy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 12, 2023, at 9:37 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> The system hang observed with below call trace,
>=20
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 15 PID: 86747 Comm: nvme Kdump: loaded Not tainted 6.2.0+ #1
> Hardware name: Dell Inc. PowerEdge R6515/04F3CJ, BIOS 2.7.3 03/31/2022
> RIP: 0010:__wake_up_common+0x55/0x190
> Code: 41 f6 01 04 0f 85 b2 00 00 00 48 8b 43 08 4c 8d
>      40 e8 48 8d 43 08 48 89 04 24 48 89 c6\
>      49 8d 40 18 48 39 c6 0f 84 e9 00 00 00 <49> 8b 40 18 89 6c 24 14 31
>      ed 4c 8d 60 e8 41 8b 18 f6 c3 04 75 5d
> RSP: 0018:ffffb05a82afbba0 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: ffff8f9b83a00018 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ffff8f9b83a00020 RDI: ffff8f9b83a00018
> RBP: 0000000000000001 R08: ffffffffffffffe8 R09: ffffb05a82afbbf8
> R10: 70735f7472617473 R11: 5f30307832616c71 R12: 0000000000000001
> R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f815cf4c740(0000) GS:ffff8f9eeed80000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010633a000 CR4: 0000000000350ee0
> Call Trace:
>    <TASK>
>    __wake_up_common_lock+0x83/0xd0
>    qla_nvme_ls_req+0x21b/0x2b0 [qla2xxx]
>    __nvme_fc_send_ls_req+0x1b5/0x350 [nvme_fc]
>    nvme_fc_xmt_disconnect_assoc+0xca/0x110 [nvme_fc]
>    nvme_fc_delete_association+0x1bf/0x220 [nvme_fc]
>    ? nvme_remove_namespaces+0x9f/0x140 [nvme_core]
>    nvme_do_delete_ctrl+0x5b/0xa0 [nvme_core]
>    nvme_sysfs_delete+0x5f/0x70 [nvme_core]
>    kernfs_fop_write_iter+0x12b/0x1c0
>    vfs_write+0x2a3/0x3b0
>    ksys_write+0x5f/0xe0
>    do_syscall_64+0x5c/0x90
>    ? syscall_exit_work+0x103/0x130
>    ? syscall_exit_to_user_mode+0x12/0x30
>    ? do_syscall_64+0x69/0x90
>    ? exit_to_user_mode_loop+0xd0/0x130
>    ? exit_to_user_mode_prepare+0xec/0x100
>    ? syscall_exit_to_user_mode+0x12/0x30
>    ? do_syscall_64+0x69/0x90
>    ? syscall_exit_to_user_mode+0x12/0x30
>    ? do_syscall_64+0x69/0x90
>    entry_SYSCALL_64_after_hwframe+0x72/0xdc
>    RIP: 0033:0x7f815cd3eb97
>=20
> The iocb counts are out of order that would block any commands from
> going out and hang the system. Synchronize the iocb count to be in
> correct order.
>=20
> Fixes: 5f63a163ed2f ("scsi: qla2xxx: Fix exchange oversubscription for ma=
nagement commands")
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 030625ebb4e6..71feda2cdb63 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1900,6 +1900,8 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, co=
nst char *func,
> }
>=20
> req->outstanding_cmds[index] =3D NULL;
> +
> + qla_put_fw_resources(sp->qpair, &sp->iores);
> return sp;
> }
>=20
> @@ -3112,7 +3114,6 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *=
vha, void *pkt,
> }
> bsg_reply->reply_payload_rcv_len =3D 0;
>=20
> - qla_put_fw_resources(sp->qpair, &sp->iores);
> done:
> /* Return the vendor specific reply to API */
> bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D rval;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

