Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B827C19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 14:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiHCOep (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 10:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiHCOen (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 10:34:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF2719C1D
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 07:34:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273E4GVa025394;
        Wed, 3 Aug 2022 14:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=L42BGrUk+OaXpZVB60FJSgR4GYfCwcJbo2ZniMWr/ss=;
 b=zTnhuNFdebVR0x3NhjXvFBdZrJ3noF99OhAyOuhWInHItehrLoJEP7fVvWPLNYkQqhJn
 OPDBnGchuYJYSSHBIqM9L6znNu4qtQoFlxQC/prI2kk1LiK8UnW9y5rM0QrWQXG+uFCB
 zP29N37OaXnS6B8ud+psmzuB97Mo/bKUIsyiKIyTZJS+MW/3ImglcVK38Y72a/UsrQiH
 2hupxf9ojjh/CFDUEuJBNgOxgqvb1+OdEhD8Yoke3H49L6LRAzYXIntt0xCbu4NVhaRm
 58ReNHUvc8zx+lsjH7rmQl1bMSTHf9zGIhZjZVDof5KpfW8pMpZbLsX5zBz17wplY91t fg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tj55n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 14:34:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273CgQbF007419;
        Wed, 3 Aug 2022 14:34:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu3345q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 14:34:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rz06FAumpTBnNt4kRjMJL/i2qqIRhzhxkaur5mB2dtyczhm5OgCi1sfJ/3bo7Q0ZS1KSSHymVJOkLm9xyENrZkmtM3mnklHSaprRql/p4Htl1EPaWAP6TOJ//Ju6NcDHksGZk8bWAsi6GfVaVjW51QfKbKtmUnUZYzcbhGpIxp3ZvdSZDzlIvtEK1D9irUgUMB6+0b5NuyvMaz7w4OjuaJ9gsn+flN+/QrB2tN+XMAWV5dkJACxQ8pk1OhhakA2WboZ+Kr6xPAMu/dOGuatXoVtn3pi0tctpYNEJH6SieGiX1yBPwesYbTEJAZdNFOa4wG15b85cCtQy/c2UG84gwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L42BGrUk+OaXpZVB60FJSgR4GYfCwcJbo2ZniMWr/ss=;
 b=EZtafkdk4rD1YXe9q//pjJ+7mlSu0J1rdsOF3L7Y/7LU0CjsHBCTCZ17GuIwHGy16oMj2rCTJ5SRDpv+zzWKaAFfBvT/244Fr2A7+OhIUlQiLrky8YnYEOl9aQLajQtCDRzuy6xynLaKEdojQ/h89aLbgsYxp1Y3KNMyaaS2qez43jSGvCKqVueMhDQMIbT8cGnMmYaPVWlZ7qKDEIbxtIoB34VsE6kwjLrz7R6dXTD7Uffr4rBrOIlAsMlFvuGJibQZOlKQSOyIx7U/A2V59Gejf+yHGoBC9Jl4/5hjGjL5PsCRZeq7rirqjQGrUsMi1jZ63CJvbsKBQI3H7BStQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L42BGrUk+OaXpZVB60FJSgR4GYfCwcJbo2ZniMWr/ss=;
 b=GzhK4m8fqDScBoSAEvDJhgFa/Qvjn3rH3BBqA2j5ShDX8F27r2Z58Mr6q8v5nTdsFxGc/RMpxrl5UJkCSOlJX2zVpCx2A7IZ2xlYwmrheBH46XxhZHglBRYX2ph5V7INrQXSq7zfBgXrYNmUH51AoUc68U9LOk9GrSc+mwaY0EQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MWHPR10MB1502.namprd10.prod.outlook.com (2603:10b6:300:21::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Wed, 3 Aug
 2022 14:34:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:34:31 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Tony Battersby <tonyb@cybernetics.com>
CC:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad
 port ISP27XX
Thread-Topic: [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad
 port ISP27XX
Thread-Index: AQHYnD8KMU0gKn2rh0abRS1QY5xSMq2dU8qA
Date:   Wed, 3 Aug 2022 14:34:31 +0000
Message-ID: <C114FD92-6DEE-4C1E-BCA4-0EEFA0FE99D4@oracle.com>
References: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com>
In-Reply-To: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09898719-78d6-440d-140d-08da755d477c
x-ms-traffictypediagnostic: MWHPR10MB1502:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IFtR5ReEuoN03vTiY9QKJDNjiYcvPYl2PP6gkvhc6WHmDlV8Xkt7kF2bp3CUYQDRFItbVI2INZFY5nNSzbrPw9rGl6gVtWDOjCa1B7JI+UWjWAPLzlGVzfZoxb8yo1Bp7E2SBVNdLJMpiaPh9L56kj+r3tzaRflMj/hNlqzFZs29JonZCEAfZD3WA4YqrQFaxSCfzQ1t598pL6naxIF80N0ekGSi3BTrmhNKB7mPN5xx3NxhOz1KRPNVyEeCQE6rvpXr+i4yd2iW+rl4IS9WMBZRltoDUh9hc3ZCzoxviKaIe9iJeKCDg6XVxzmIGU+RfnwWqoVapZRbwHTPcCJlmZC/gaIQm9W7pOVbulyt7OUyF8Pj/rb+QQ4GvSbU2rHQPU0St+eme1ysvoU0tK5sa1l2ZcsmOVkr3jNzSyRwFBVPhmSl8iTo8FMDo2IHcUzDkitfBhTpGffV8N45i2ibDXcEsoTujzjLMlFMkCq3d7eHAgvinQrZZQ5Hm0F8mwla6FZyqRhJrpjRmHfAGW4ZXFiH1iJoKquU3q4In7UEsawnx3qRDZe4nrHlfdDrmanSII0HIUHK/SFsKGW0M/vgj+rZSxzbCHUO48gpFcQKlhdXmB9pRzs+Jwn+GqCQUF10oC7Z2/7x4TNYDDqF00oP8DgcUUZjyPxZiDr0aCuw7kfWXChCRkVR7pPdcBYshdXCWbnwyUx3C0sutzyIwMcNup9dAhTPoslL6hGXxkX2B8oL77qPsTV0ejSTOXeN+64DH4Sfn0lWXn15+XZKkBlUgOtEpxVSf+ch/fQqpMITMoLmO/IuIC0Si93CL9vi8tg7p6nKXVIHGN/VmnPZPZKHe5ftRQhHeEB2w5BqY09tXkM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(366004)(39860400002)(376002)(33656002)(44832011)(186003)(91956017)(76116006)(8936002)(8676002)(66476007)(4326008)(71200400001)(316002)(66556008)(966005)(478600001)(66946007)(6486002)(64756008)(5660300002)(66446008)(86362001)(38100700002)(122000001)(2616005)(38070700005)(53546011)(6512007)(41300700001)(6916009)(54906003)(83380400001)(2906002)(26005)(36756003)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?djZnpUgKcckh/sVIoQ1edlA1SezuP4STZ4y9gLP1FG7OeI0FvyoxRu6P4w0+?=
 =?us-ascii?Q?l+GUZzNPNdvYlTuJ2latjmOPd6iTmWt2rGnlcPu08ZyZoQ93sa7Y+94/ASuS?=
 =?us-ascii?Q?BuU9uOBx3hPn2n5QIkaAXI3F8QZQWbFKCOAbn75gQrSAGvnULJ+up9qd8pK0?=
 =?us-ascii?Q?tHz2dBl+MEnNHvtJqTF5+4FU+K5p/nBj54mN6hl1Li39M4ZaS3uYptd7F6+T?=
 =?us-ascii?Q?OMI5CD6jF8bgCdDDRSJP5SQ4kyGIqdKcJ6iw9Gog3e17jmES2kkwsAoh7Pp6?=
 =?us-ascii?Q?X9GxJCLeB3161ud8SL3wI1f79Gl8po6M68+t1HaNKx/W1CyJ2j9T2Vx3L6av?=
 =?us-ascii?Q?y1Ydh6kGWvtr/BxCz/xsMgYlrRL+QWXPgWcCqphSLuYK2cifO7lT1zji5Kg3?=
 =?us-ascii?Q?ql9FdAoQ51ckxlX3aBpilrhHVZjB1bYP46go+l/uo/tw+/RXnyVtX4Ti0f0V?=
 =?us-ascii?Q?QZbadq7aZPjEmr8R/q+FzaGowsD6RUoF/tqSJloms3UtHwqkAfM86GUWBtcM?=
 =?us-ascii?Q?Fs+gMvP93Uix0kDYASUF2CspUxc6nClTM2HENgPmmaVbeQz5UPI6bY1ZfOJj?=
 =?us-ascii?Q?NYS9TuWuKzKmQQS8xqca1E2MXk1v45iGxPXhjPX4BlAuDEkJj//SFLKMG/FL?=
 =?us-ascii?Q?wAfrw4d6lqEuGWxjpsG7OSQUL+3/ZMK1cYUM38DyJMK896a8s6IliV4MoGCs?=
 =?us-ascii?Q?k6Bcs+67HJoPFFU+0wLuykGozlslfSraE65zdv05o6T+leV8q8tW5crno6CG?=
 =?us-ascii?Q?vmbfLEAfm+9WrbfcJ+HUXuy0+m1aMr5KxeLyblp/iSFcIiRBDBXDYXhbep7b?=
 =?us-ascii?Q?2b8MDCaunm/+C7hVonpmYA3jq4SMOZqHpi78ovQkLGvoQKwzC8gcldTxTrDO?=
 =?us-ascii?Q?tSzUSCeFt3N4yMXRZL0pNYJxVDZQkEX/y+qu9J8Zu/kNTfnCuI7z3lU4E5+3?=
 =?us-ascii?Q?lmBFopv9LgB1Uz9w2+pBeEYwgGnK05TnZUb0aeYZ0AJw7sojwV+r4rdAXPnV?=
 =?us-ascii?Q?/fMxruxf3WXfQ6DJS28LQErU1NwDQC2qotbDhEi2zVb6154FDbQ4kDwM6TwN?=
 =?us-ascii?Q?vLKLDoZg9WkjraYJ+EVKqc1eWhVeV6R4TmAkQjLYLlU3DWcbdO6JceaA3Uq3?=
 =?us-ascii?Q?l7y8D5UAss+V+g5FBMj1kHS1CKmubnhWev8RZlYbXq8YZlfNFlSqcxcLOoAK?=
 =?us-ascii?Q?ZixWIU76pfJxQyvLFxkUxK0kkVA7nbPashKO5IkGfSRuNQA1N+vIbt5Q8qAo?=
 =?us-ascii?Q?UVK34btGoYOIX9mPjMMQyqOe6j0nISj+rOw4jvBMvkDDhp6oTnfuaKhU0W/j?=
 =?us-ascii?Q?pfDcNGdHWODXKZhUgY3y0XcHSc9IK7TDTHS4I85Jo9+G56dLxLqUIQiSDdho?=
 =?us-ascii?Q?mnIEkZ8pBS0FvoNGGVa6kXyXmolVn/yVqb0YvZRxGu+i/FrhWnHJA9plmEe3?=
 =?us-ascii?Q?QXnBR532h9u/ih4fjstxJnSGWvJsMdP/5b5+eh3lfnNRNI+37lAL62VfVx4k?=
 =?us-ascii?Q?icGWmnS1yAicfa5fN351uPDjz0bmvhbdHCCY47iFFcUAChk+0mSq/sq146uq?=
 =?us-ascii?Q?YXpZpazadUYnhnTKkyiFUlIsuXiiRbJj9no9BaaxQbWuYI9JqVB96cpqStoI?=
 =?us-ascii?Q?Pw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7A81B1FB046C944ABB536CF01D508ED@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09898719-78d6-440d-140d-08da755d477c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2022 14:34:31.7912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2k1kg2LutlREk4MYgMMCC1/ZRzJczIN2KSuK8Q+BIEatFme+WPPSp/gDKF6xNkzVHUeg62RUfe/uEWcYtv6HHkjGGcUerOOZnDTs55M6Dmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1502
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208030066
X-Proofpoint-GUID: zMqB_bhYJFNvjrLLPsstYE8yF12nweDs
X-Proofpoint-ORIG-GUID: zMqB_bhYJFNvjrLLPsstYE8yF12nweDs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 20, 2022, at 6:43 AM, Tony Battersby <tonyb@cybernetics.com> wrote=
:
>=20
> This message was previously sent to scst-devel:
> https://sourceforge.net/p/scst/mailman/scst-devel/thread/d381eb86-d446-4f=
9e-03c3-aa93d93dd074%40cybernetics.com/#msg37682919
>=20
> I am using a quad-port 16 Gbps QLE2694L (ISP2071) with SCST 3.6 +
> qla2x00t-32gbit and kernel 5.15.  The following old commit that went
> into upstream kernel v4.16 is causing a problem for me:
>=20
> commit d2b292c3f6fdef5819a276acd64915bae6384a7f
> Author: Quinn Tran <quinn.tran@cavium.com>
> Date:   Thu Dec 28 12:33:17 2017 -0800
>=20
>    scsi: qla2xxx: Enable ATIO interrupt handshake for ISP27XX
>=20
>    Enable ATIO Q interrupt handshake for ISP27XX. This patch
>    coalesce ATIO's interrupts for Quad port ISP27XX adapter.
>    Interrupt coalesce allows performance to scale for this
>    specific case.
>=20
> This commit was present in qla2xxx when qla2x00t-32gbit was first
> imported into SCST.
>=20
> With the "ATIO interrupt coalesce" enabled by the above patch, ATIO
> interrupts are handled by qla24xx_msix_default() rather than by
> qla83xx_msix_atio_q() for the ISP2071.  I guess this is supposed to
> generate fewer interrupts so that ATIO entries can be handled in larger
> batches.  But this causes a problem where sometimes
> qlt_24xx_process_atio_queue() returns while the hardware is still adding
> ATIO entries to the queue, but then the hardware doesn't generate
> another interrupt until a separate event sometimes minutes later.  This
> leaves incoming ATIO entries (i.e. incoming target-mode SCSI commands)
> ignored in the adapter's hardware queue for a long time until the host
> sends another command at a different time to generate an interrupt.=20
> There does not seem to be any timeout function that generates an
> interrupt after a short period of inactivity to process the remainder of
> the ATIO queue, which is what would be necessary for interrupt coalesce
> to function properly.
>=20
> In my case I am using virtual tape drives, which generally process only
> one command at a time, so there will often never be a "next" command to
> generate an interrupt until the previous command completes.  If the
> previous command is stuck in the adapter's ATIO queue, then the host
> will timeout and abort the command, and the task management function to
> abort the command generates the interrupt that causes the command to
> finally be received by SCST, so the command appears to have been aborted
> immediately.  With disk drives the situation might be a bit different
> since a busy disk might get a steady stream of commands to generate
> additional interrupts to process the ATIO queue, but even that is not
> guaranteed, so there might still be problems.
>=20
> I tried to fix the problem by modifying qla24xx_msix_default() to call
> qlt_24xx_process_atio_queue() before wrt_reg_dword(&reg->hccr,
> HCCRX_CLR_RISC_INT) instead of after, but that didn't help.  The problem
> was solved by disabling the ATIO interrupt coalesce feature and
> re-enabling the dedicated ATIO MSI-X interrupt (qla83xx_msix_atio_q())
> for calling qlt_24xx_process_atio_queue().  Another workaround is to use
> ql2xenablemsix=3D0, but of course keeping MSI-X enabled is better.
>=20
> The patch below is against the upstream Linux kernel.  It can be applied
> to SCST with "patch -p4" from the qla2x00t-32gbit directory.
>=20
> If someone really wants to keep the interrupt coalesce feature, it could
> be turned into a module parameter instead.
>=20
> From e5888ce5dbffff2d38d9dafd4841d6d3bcda4365 Mon Sep 17 00:00:00 2001
> From: Tony Battersby <tonyb@cybernetics.com>
> Date: Thu, 7 Jul 2022 15:08:01 -0400
> Subject: [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad =
port ISP27XX
>=20
> This partially reverts commit d2b292c3f6fdef5819a276acd64915bae6384a7f.
>=20
> For some workloads where the host sends a batch of commands and then
> pauses, ATIO interrupt coalesce can cause some incoming ATIO entries to
> be ignored for extended periods of time, resulting in slow performance,
> timeouts, and aborted commands.  So disable interrupt coalesce and
> re-enable the dedicated ATIO MSI-X interrupt.
>=20
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> drivers/scsi/qla2xxx/qla_target.c | 10 ++--------
> 1 file changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index cb97f625970d..80fd9980dfc9 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -6932,14 +6932,8 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
>=20
> 	if (ha->flags.msix_enabled) {
> 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> -			if (IS_QLA2071(ha)) {
> -				/* 4 ports Baker: Enable Interrupt Handshake */
> -				icb->msix_atio =3D 0;
> -				icb->firmware_options_2 |=3D cpu_to_le32(BIT_26);
> -			} else {
> -				icb->msix_atio =3D cpu_to_le16(msix->entry);
> -				icb->firmware_options_2 &=3D cpu_to_le32(~BIT_26);
> -			}
> +			icb->msix_atio =3D cpu_to_le16(msix->entry);
> +			icb->firmware_options_2 &=3D cpu_to_le32(~BIT_26);
> 			ql_dbg(ql_dbg_init, vha, 0xf072,
> 			    "Registering ICB vector 0x%x for atio que.\n",
> 			    msix->entry);
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

