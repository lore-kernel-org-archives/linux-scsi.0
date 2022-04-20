Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C9FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 19:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381683AbiDTTMW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 15:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381649AbiDTTMV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 15:12:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8074842A2E
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 12:09:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KHpGaJ011984;
        Wed, 20 Apr 2022 19:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=JCKm8tSEhBF3VXrZPXJnklsWQeKP3JOkSbCfOXfSND4=;
 b=W5zCm66+tuxB7HcMTOqXAN9HAnBEOARLk8obB365x65ephLA3sczG3ZQ/hlK7sp1UAh4
 QQi8y0AEaAdLN0o06CU8qzWC3vOo607wS0OrI7z64wSL9AAdhMgDiofGXlcgHQ8MOGyX
 5MB/qV9rlHEuNkmSpOPkg1ZUwdPphIXmIDSphT2COHyycb6ZSQ89jsLOYG+f49dxnQV9
 HLV8OLPJR7E/dHBgZAB+7NxVkZaKtP+cDtUMCHk6flaRcwlH3EMac1Cfo8O/rHWLcMbH
 smz6yv8quoTTUXF2nGoYPOuW7OMnOP/v2aIfSbmBpiHtNwArvI606iebuZQMzopHbvUs dQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffpbva7r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 19:09:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KJ6GfB028869;
        Wed, 20 Apr 2022 19:09:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm87t1v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 19:09:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVoLeDw+uanBgW6Q9b7F8Uk1VMeBW2b/iD6DFA9qDN7JxnQL9Mjzo0j7raIG4JL7bGv3Yk3nFA6yVLmK8xMekkWH30jKqek6CQGyJcBfqmc4fKeLNAhUQpRx3Z3JJ629pZ9UITfMOJeyjznLGuLteMf1dTdVK2kZi5udSARi8fmM9m/H0o3E7p9bAHIDiuLUzG0s3XZRyzuBkbvEyGYRfwuQ+f+0cvw6japDvZMAXl5R3tLFcyNoc23CUTYT7s1MeLEg5DRhbhbVF+f6yOur4j0bU9y8dymAFbaxc1YL8W6dC6wyPAuBs7oBe76ctSqOD6MV6LwCPEtovtqTJwYpZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCKm8tSEhBF3VXrZPXJnklsWQeKP3JOkSbCfOXfSND4=;
 b=Kys72D6dex194mGCC/F9ED9KtNyBMVcZen6OvHxTnpjOrh2wOFjcLqFh9GNTnRu1DTGNkDSTIQGVSV7bTDMx9W4f2IfyLq3mDsmHu+DIZA8nZewYC8VtUpQEPTs6Dhq+QcAEaziUPE/N//gwyzvBJXhXIkRcSE7K/+OIsI/xeRi5NYs6YRCJ04MKVe8seWNoGXUSzxhYWfWZYPUN1XM4n1zTnyzFLbO+9fSWgU+wcqMqVEuiIIvopdPligEuRdRMp24j8lxvBYeuOCVk793CtND6yMcENEnIumKnrFo0hYwrMuhmWS8yKJWhVEKakwuDo+d4i5Oo+jD5suABBB7Wiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCKm8tSEhBF3VXrZPXJnklsWQeKP3JOkSbCfOXfSND4=;
 b=cvTmzKIBlkoBuRZZzMZKxT9oe3+cx2QSfc//zNO8BSBuHgENVxJy7GJWQVCYi00omspga60Vy7EHoQguVky4FNjR92+zeq3T+DHbztBqBQBAqvp2HSKDGSas+x5Wt2hRkB2Jo5xCeqdEDlbRwTe+jkSckh35aAi9ybNkJK6DFRo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH2PR10MB4053.namprd10.prod.outlook.com (2603:10b6:610:a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 19:09:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 19:09:27 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Topic: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Index: AQHYUMYtkLBbKidY90SJACyXGZHZ2Kz3qV6AgAE75LiAAE2AgA==
Date:   Wed, 20 Apr 2022 19:09:27 +0000
Message-ID: <F1592489-7C94-454B-8EF3-BF5C56F48A10@oracle.com>
References: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
 <4FA3632A-690C-470F-8DEF-663F9AC0CFC8@oracle.com>
 <AS8PR10MB4952FA41BCC382A6464D842A9DF59@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AS8PR10MB4952FA41BCC382A6464D842A9DF59@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0455272-72b2-4e27-4ca2-08da23014a98
x-ms-traffictypediagnostic: CH2PR10MB4053:EE_
x-microsoft-antispam-prvs: <CH2PR10MB40534198A1A42919C3647136E6F59@CH2PR10MB4053.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b1q7wQmjB68qA9DD5OPqMSIW2/fkn5UAXPEm9Xj9nj1j9wYQPdIcfV2AYx9/PqaNqHwqqsHBibhpHNn4NT/cTJxKPHdmHqS1TSqUMX6lIKGSWwOIZbn+ixyKKMhxdJf8hVUK8FpI+ncXEovSwjiIKJ2bKrZtLTQ29iUJvrDV79xl2TbayaMAQOYHcySWJinxzW4EjYPz1AxAactsNTxbKPr3xvKWJ6xL3V8z7W8DN7BLykx62VSiUx/ME3CLPQibNMfMjBRnVRp3xrclpPBLcrlGnAjmHG0xALAFjWRXmCsgRfoM8uPO8teqxfSa+C2pmVUPLbW5vbLlEL0GQuoxUOiBF65bgKwr1nSKatH9R6v0pWq0PP4GWFL97pn06MYVli+LNai4KzrGEIx5uHG3K3LFpcyPA8U7NJJ1UV34v1Q1lXPHi1yAr1kbzP2tbwSoy8dJNYakjD4wEQqT903psms2ObocTt+UWl6fXXlZWDkJwW9Atco726qkzYssVMmRu6GfxertDuKSzhwEnl6BqcE9Z9dl1OG4mDVru14bkd7yv77bRVqBS0bh0mOpxBmVnjGn5S6Mz9NLg25v2Bz9Mg22WJ9lMztGA71ksHqrJxbe7nI0iLz0sT/Dpx7cfHIA8Vrg7ntNpnZmPdgxH9okLsvbw/6T/rU+S7Z69W6a11egIUWXbDLlAInDWTrRXgZNWc9SUJsnFIVeh9NzNEY9MJnG001s6Pm9cO8tVIu0CJLtD4lYXDZIV+11VcrMJDRb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38070700005)(6916009)(316002)(36756003)(71200400001)(122000001)(76116006)(66556008)(66946007)(6512007)(64756008)(2906002)(83380400001)(6486002)(508600001)(186003)(26005)(5660300002)(6506007)(91956017)(86362001)(4326008)(44832011)(66446008)(66476007)(53546011)(8676002)(33656002)(2616005)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5jhNk8uutxT9QFMX/oTOIIfMV1ukhqj0vYDzOglPwKBX+u2RSfJoEhdfe6oj?=
 =?us-ascii?Q?Yluf8Tp5PIycjVPtlxNxVddg3TgX8qsVRvjjXxOSNVq5hD0TkDXF6sb8juJS?=
 =?us-ascii?Q?4UwO/eh9uFqgAEQoSCXqaAgV0QXL2j5bymXeFZz2iU8A7XUOPYVtQ5FjmZl+?=
 =?us-ascii?Q?WNrX6XLQCxr9ryfy8ecgWQcbFDVSxAZ2qz8Nb+YUvf/wxDPeakJACobYKHui?=
 =?us-ascii?Q?ZGu0Nh03n7RrpAOJ+Yh+EdzKQ84Zw5a+wkdiP9VyM9Rof9KkmjtiXMLnzNFE?=
 =?us-ascii?Q?44wRlEmzftJKF09JRS4nEIlAJ4aq5Lhab7uhJnduHOQ2oWdHekZijBa+JWQq?=
 =?us-ascii?Q?oRy4LGQtRJxKuodXerGLHogYBu4e1vs/4WxQaO5EpMhV27an0lGrgjgAX+5t?=
 =?us-ascii?Q?aVO+5whLg8Hj++1PcuicbPYpXN9KprycuGJzH0w680/Suw1Rf5l2EeV27bfz?=
 =?us-ascii?Q?cVx1KqOTm8EkEPT5ppNK2B9BGY2VI+rEQDtHL4enQPxMbl5DPIDXsa8gCnm8?=
 =?us-ascii?Q?9u5RhfwzYCqryqXAEfgNo71Gqbvuvy7PVvDdFqTHtMY6jjwo3aGJyPakYZQc?=
 =?us-ascii?Q?KjMu9Wt7KmkgSQiMgNhz2Nz4ZXlJJMfJzc3jeiLde+EEVP6kfndwdFtvH9dM?=
 =?us-ascii?Q?76zZMe5tWtnSblpVhPz33lbwT+sB125ChRg53ef2bd+yYjIK9RIJX6nbipQ0?=
 =?us-ascii?Q?TTUXEAB1dWAayg/MUpFxQxx0kqq61u+ra0rY448gCRelPUXk1rrp3PhiIy/t?=
 =?us-ascii?Q?3uJ2gH5udJ1grZnHjGURc9E/hITyXyElYTMfjh5wAW0sW27BeVXV4l2QB9Cp?=
 =?us-ascii?Q?gSgnHDkPuLyOtzZYdvT2SBbqVTwzAqT9kaKiT3q3F0lRgPVxzBbjXG5HWfZj?=
 =?us-ascii?Q?08QbeWc5FALYx4BhkoqBLxmqwN9IhQsNHxWCA8AO0/PBbPLeg2h5LXEqhrrJ?=
 =?us-ascii?Q?50N6PCQubb462f2No0WXInO5Dsn1MEsitpjFEDR8jefpRP6AOf3FREaPPE2r?=
 =?us-ascii?Q?9wZ/ZZan6PbgvcBxVAkvYTZhkTp6aj+M8s+0xOT/RXxrzt7EJs1ZzfFKPyBG?=
 =?us-ascii?Q?3MgWp6EAbdWiUAZSHn2aRLGFiFyaYMS7T5++1WKCNQukp4JRDp0/qK7XkOHs?=
 =?us-ascii?Q?wTnqKKEDpo7zIsTrD7P71mPk4Ejs+raTI346gm3HF6HrRinf16G7Z/3sguBY?=
 =?us-ascii?Q?sYIxWmTnihVNkGgHh5F5PttHDaNrCqkbFc+W9OhECcdxECCjU8/SGekINjiE?=
 =?us-ascii?Q?sq/uVObzTCKrb9qpwmnsmhEB4m14/Krucwi275lcAKCW2RZrtC74zkqoYIg1?=
 =?us-ascii?Q?PUXLGhh4/pN6MxEfmDRDHHRqgY8PHxLEK8nJtv9mAojD9QUtmeIEUbLyLm0l?=
 =?us-ascii?Q?uzgS45h8dim2IBav2VvtpZtUjU4mBcyOosydZeQm5IELLBj56jKT+bGrUY0A?=
 =?us-ascii?Q?/JQzupqqAJX+HBFXeCHm8G6bZIVLOE2BRRpajQXBGavrNYUa6U1akoLSd9Bt?=
 =?us-ascii?Q?lqYTIJ84IOON8vnVUVX2sEUw+fd/44QbUJSbEkz/Rag7rHfzSaBV/I8uQTjI?=
 =?us-ascii?Q?MvAwGqIWJVOvyCPjDnWvtKhkvylHIszbW3lwp7bOYagsokFsPXN0kbcAKN8a?=
 =?us-ascii?Q?PGUncfc2nMH4miaiNRcDBMvHWC6MycNAYC+wtcZ8szmaNY+WgGCGCKAM+Um5?=
 =?us-ascii?Q?oOpnGj3pS6IsBxihz1NR5kOO4ktuNIbYI/Nz1nO7FSYbQoGkL7w+KA7KCs1W?=
 =?us-ascii?Q?bGhYJKdCjc4HGFpCTl7XeTnAIe+GNxkkPXdsDLmUBZuvV46uXEUd?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0CE3A8D8CFFE1344BEE33175908BE7FE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0455272-72b2-4e27-4ca2-08da23014a98
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 19:09:27.9156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: InRcYmehsw5/PnaFDKQir/nMzNmjy1vhXVtoQBsg2D5lRbGAV0Sz0ZMBRtun4eNe6iQdcTSos4f8M3kBkPzzl/vG6mNZyJAlrsW8LaUz3D0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4053
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_05:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200113
X-Proofpoint-GUID: EjsBBO0MRUUAH5yuNf1xECEA5Dk46EwP
X-Proofpoint-ORIG-GUID: EjsBBO0MRUUAH5yuNf1xECEA5Dk46EwP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 20, 2022, at 7:42 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wrot=
e:
>=20
>> Do you have a log showing this error sequence?
>=20
> Yes, I have, but the problem is that I have a different target stack, not=
 LIO. So the Call Trace basically contains code sequence from this target s=
tack only,
> except for the call of the qlt_free_cmd() that trigger BUG: BUG_ON(cmd->s=
g_mapped).
> Regardless, I think the problem lies on the qlogic driver side, because i=
t is responsible for management to map/unmap sgl list.

Agree. Am curious to understand the test case/steps that would trigger this=
 issue in your env. If you can share your test scenario would be a bit more=
 helpful.=20

>=20
>> Can you share more details?
>=20
> What I am observing:
>=20
> 1) Command processing calls qlt_rdy_to_xfer(), maps sgl and sends a comma=
nd to the firmware
> 2) Qlogic adapter reset occurs
>=20
> qla2xxx [0000:82:00.1]-5003:13: ISP System Error - mbx1=3D110eh mbx2=3D10=
h mbx3=3Ddh mbx4=3D0h mbx5=3D8a1h mbx6=3D0h mbx7=3D0h.

This message indicates there was a firmware crash. Qlogic/Marvell folks sho=
uld be able to help you capture/save dump. That firmware dump might give yo=
u clues on what is the cause of the firmware crash.=20

> qla2xxx [0000:82:00.1]-d01e:13: -> fwdump no buffer

> qla2xxx [0000:82:00.1]-00af:13: Performing ISP error recovery - ha=3Dffff=
9dd7d6058000.
>=20

> 3) Somehow the command is being aborted, so that means the command's abor=
t flag has already been set.
> I think it may happens something like this:
> qla2x00_abort_isp_cleanup() --> qla2x00_abort_all_cmds()
>=20

I think this is the aftereffect of a firmware crash and the driver is just =
recovering from that. A good firmware analysis will shed more light on this=
 issue.=20

> 4) The target stack calls qlt_abort_cmd(), and since aborted flag has alr=
eady been set, this call ended as multiple abort.
>=20
> 5) The target stack calls xmit_response, and since command has already be=
en aborted, this call starts the code sequence to release the command that =
ended with qlt_free_cmd()
>=20
> I think I could try to reproduce the problem with LIO target stack, but I=
 have special case with my target stack that lead to reset of qlogic adapte=
r (ISP error recovery) and this is one important part of the error sequence=
. So, I think I will not be able to reproduce the problem with the LIO unti=
l I find out how to similarly reset qlogic adapter during processing active=
 commands that have already been sent to the firmware.


Himanshu Madhani	Oracle Linux Engineering

