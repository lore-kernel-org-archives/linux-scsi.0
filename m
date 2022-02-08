Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CEDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 19:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385664AbiBHTWV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 14:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240970AbiBHTWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 14:22:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C668C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 11:22:20 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218I3Tvb013064;
        Tue, 8 Feb 2022 19:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Qfk89df5E9Qh4xJ2w65Tw5uFEIGVo/+Vv0+iuKiAqCs=;
 b=EByny0IumqWkTRs3TlaaDLmlWA0bU7o5LxpfvZIPCxq52mRvW8qHtVnA5eBDX7yOp8m6
 wcYdls9mjk1eSox0QQpkl7QDpNl2ieUNuYxR8Ty/Vumo+CK2hvqNDQXp85yl9h1vdwl5
 0OBXksd7LsCMliVClUvfVmfwp2BlylwE+XEH8fnsn/3otkbXhW3dFOe2YjjuyKBgMXb4
 4KMcU+o1x2et3NXIjl39KBd0q42DvF6USkmrmtkEOR2hTqmpcK79YEBhZUPUjpy1do59
 SM8xVhuKDVgL5tMz1MgC9PIL4MbqvbxzhqW+UB3dN8jaNmxof25OrGVXUsy0L1Y8LArS Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgjhpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:22:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218JG7mS024722;
        Tue, 8 Feb 2022 19:22:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3030.oracle.com with ESMTP id 3e1f9fwdu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:22:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbJbjOstQ3iwBV4YuqatWueHaWr6Ay5jefiJ4we8UqG7qEBcuY7Wl5vmdtjoxgTCb0PhBollySwp6xZ2cmO/akdm7cu4EwauXSrLJSNHylpyEe/NdSJOkc04Vw6IGLNJ68WmYnHgcRaLG7kKBfYnGLdre7DxO+tuRcHjLQXS7v+wnAROyTi9yES5d5ER/Vn8NsQ9OCWethu2xhFLg0gODHgyfXNtvfywE6JuzoNU5Iy0IoxjT676L8oN7FZtIL46JZkWRVOK+dL6KVWeyzkh4o78tjccmwFoQrGehVCR5Jsz+pV6/t5lI6Grn1u1bbykCxA019LI6KsBrZVPE9KyIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qfk89df5E9Qh4xJ2w65Tw5uFEIGVo/+Vv0+iuKiAqCs=;
 b=T/whjZiqfevQ6uYys/0SPdN7iyzCAO1ygKJ88IczcoeuWVD+8iOTAmSr2JDiHq/mAziuJF0tvHPccUMtPo5gSWpEzIU4J26rPDzkdqBVZLRuMHwuYt2EneoCHdz6sOdFEOdfRT8N+eIjQ6n2EiuAtGnQ7DYNQ439f6532EfXn4SdR9DkNoP9v/0vv51CI5K1lMRRWUAblPZkVuX99bJ7TsIvaRaD8S7C3omn4UfSbznCyRbHhrganIFjaqt/1nV/XrrecI6UiXRgCjXJpXJT/k/H4eRotyHyoxqAzpcDL9FoHeoYzoVMTmzO3u8cAemN8neUJi7ws+bmKD4eeAIAFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qfk89df5E9Qh4xJ2w65Tw5uFEIGVo/+Vv0+iuKiAqCs=;
 b=Z0XINTGPbkRPg7i424GTZXR7B4ak0IwGJE1YJXz5jH3yqdoBTMfjK+qqEiEo5oZ/lcOaOlmxSjWD3VNwEiUhF/KLm0KuqvvA+o6LruB3nqSvI35YwGHH743SL6O3Fa9b3KUnhUD3WYY2qU2zBfgnNL8M3rN9ivFYuMLP03SWsxU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB3248.namprd10.prod.outlook.com (2603:10b6:208:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 19:22:07 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:22:07 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 44/44] scsi: core: Remove struct scsi_pointer from
 struct scsi_cmnd
Thread-Topic: [PATCH v2 44/44] scsi: core: Remove struct scsi_pointer from
 struct scsi_cmnd
Thread-Index: AQHYHRFKV/dlf4R6aU2GO73sGKdNHqyKCC4A
Date:   Tue, 8 Feb 2022 19:22:07 +0000
Message-ID: <0049A19F-2355-4F78-9E0E-4ED8535C3678@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-45-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-45-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdde05b2-35db-44dd-9a16-08d9eb384bce
x-ms-traffictypediagnostic: MN2PR10MB3248:EE_
x-microsoft-antispam-prvs: <MN2PR10MB3248788418A243656CD67A3DE62D9@MN2PR10MB3248.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C2+Sk5Ak6+OSab/izAY1MzPf3fz1ZZD/XFLu3xCZmU3g071u3P4LB/ZAuQtRxsJgM8yq/HCrWoCmdCFVqjihcj2U0cFOSKy+fRXo50BCViVMp/mfUigGa8bLCDFG8hLSKBtlDVCNcC1RBXwALhYSi2z6XXgF2xMiQyDnQGUrVUgKERzBtup/RXpkH3M3jXFCtz5w86ZUcSfxVZ6EdXth4t7YEN/zCAdnNycM5c1JWQAhSCrI3Tz8END5/Fl/COQed2Q2cu6dlpMN85B2lzw2k0x1ormnXpljvvqP5tSOtUD3edCtvOTpSqxCKscfoHKdacSf+HKZb9OGf0+5C4+B87fVYYXPxDi/YqOsKkR/G9qlTKoAZ58jUDDQOIUPpVQnixbxy6iKPK6LMB5M8v5xWnUBiPd+L5uE1CS8v6oqgkPQKgy/2PtljDDQjbVDvk8q2tVQiLn8Za+50IxmfZg8/YY2A32OxTVKvVh2+eCvug4nDheNg8EhVtkD4s+SaN2JbZyfCs4Gzoh/kjdRilq2AFjOUFavCfGXFyRe8WM6d8dD2R9Y0DiAVtu7tnw3BziBBHXmqOAhbdv9iJZ68D1QXZKqty/7zuzxOH+mND+jCASNlGdhjNgiXZotFUrCoyq3vlPnyMjeh4R98wTu/bNt0QBK+Vri6UEmmrWOKDyRNbCm28k/n3pEs35omZkgfBargMCEzFXSAFEmGlMX8szgo2Wfnwuq+aFhqcg8QFE8ifpCeeRw/aY896MQFNFlMxT0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(44832011)(186003)(71200400001)(5660300002)(2616005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(6506007)(8936002)(66946007)(6512007)(91956017)(38070700005)(53546011)(76116006)(2906002)(26005)(83380400001)(86362001)(6916009)(508600001)(122000001)(38100700002)(6486002)(316002)(36756003)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lrN/m0N0uwXXYlEFmvEIICjDyg1kRNpKwvI2MrFLenTwiWcPX+hRhwLR67a/?=
 =?us-ascii?Q?NIkwBzD0gS4ez0GP2OCBXGR0UQpCKtnxwVFzBx7lttSLeuBFEC/EPVARO7Fk?=
 =?us-ascii?Q?4orrwpaX3Ta23yjv+ywqKsS21sx4iYHSbZu1BAAUYTbo/Cmjf7mGH41a/1YD?=
 =?us-ascii?Q?xzaP4XQdRMGyZ4osq0jYr0BlB8KRN31QjRPJ2/FSMEcXdG1oyrYzD+7GvGfb?=
 =?us-ascii?Q?42uiECSLCPi+2L45s7zbG2NAZG+6DnqMevS1Qfs04QbAC0tc2WG1LS9ZNDiT?=
 =?us-ascii?Q?wCU8AWvwj4G0Qc8QAforHJIE1vZywNWAKYmvTDNLW5KAL6TbaJhRM63o1eyy?=
 =?us-ascii?Q?epE3bP9hv076/6gT7YmslMxRmtRcYzB/BAiNOKw89Dc2AZveVNggjcJYwPXB?=
 =?us-ascii?Q?kAScs6ZdKmk6MeZ3oqdrBmCQ6qqCn92XExl20/SVpN2GO0AW3+9Vkg4AeapH?=
 =?us-ascii?Q?eVO8f4wgK6fRieN+HaDZxX2tlmElUysnOevk9xWt6QUlSz9cFVXNfCqBLwC4?=
 =?us-ascii?Q?gdC3MqaXh9AJT/EEuJQsBdC9yS0Yh2JUQksbwYRV3MDoVrVqPsCIqYQcJZ3b?=
 =?us-ascii?Q?SvnAPL29MAD2f1BaX5tWW8fT7H9+zw8KLxMZyUoUQbOL6a2KHkf2clyl9Bdb?=
 =?us-ascii?Q?2PIPBKZ/yz80Wf9qhgNGhkoWq8LYU5hLD5sdfODPgHd7OEBpFcuNkIeQJOG6?=
 =?us-ascii?Q?vFAk1ZNWJqUrv//px5p0KBjMM22+UBt306I9q521D3CUGSNLhf19v0EmDGir?=
 =?us-ascii?Q?Qi0/7TgHq13FV/QpkQlLW/CIKBhQQ/+n7JdmPX/WQoehoy/oP2x1SYIGKcPM?=
 =?us-ascii?Q?mgZj0SPtb9Rq9q1m0UeelKI9KcJGog+pfLbmmv8CguJdhTrh/bhmFMD+ceLl?=
 =?us-ascii?Q?XB6EV0TxQLHTzbOop5/MMoWg8HxlYdWpIoO24QMqeGm+Hei7+Iq/SGC69EqX?=
 =?us-ascii?Q?Cx3hltNvdmzfM4BSQvvzSM1x8FvFCsx0hgsSi9BU7t4KN+nFIPiKIitA5Wrs?=
 =?us-ascii?Q?CkixI5Owf/JmsEdolSH0giymWSFxXouPNeBbVI2FslPfd8XIJhDRraXSaaHX?=
 =?us-ascii?Q?h7sJQe0zft4gDebzb/1IzUq/guKFD0IE9Bn8bGghTcwFzAkeYIFRDdraT8n6?=
 =?us-ascii?Q?icrKR+XFpSl16KoALB//maHR0+hiqGX08cM4hz0DvZ+gZE7Ounrb76o830k8?=
 =?us-ascii?Q?a3Qgz3fY0TMoAVQAf/Yw+uXLpd+MJsSi7o8NUNWaqYI9aDJnoBzCk0yMz7nm?=
 =?us-ascii?Q?VzJesOHR1PAp6rWOUCfwhq6doSrIA1V4DUCGlOmjL2LppBkeViyI9+K0eti2?=
 =?us-ascii?Q?RmPlq0jxmJX1x6chmfdRp5l8X+NwpmU+Gdt/YBEescaQz6i/m0iEuS6pHS4T?=
 =?us-ascii?Q?KPXebyCgsxIIoDnbrAFksdwjfjTb2i2NUdAgFnGIpEXbLjnmn3pUoAAabW9h?=
 =?us-ascii?Q?prULFgwiXRjoRBl6HsAYiEZhR5FRklEoi3ULFb1/sqEOhO0020f8RmrZRWZ8?=
 =?us-ascii?Q?Gr5mRjkHvEvJHtI5ipKvBoMArpjjWeuvDkT+5eoSJ2wKBhDQY8k+KEmV17QP?=
 =?us-ascii?Q?1iMN0s5Q1Ca0p+6tYtgBEYn+QUHcp3l3BxLnCG7iGGRJJyA7vwc84z+Xg0hp?=
 =?us-ascii?Q?y7J6y1ae1Xg/R08ZCGXIYID4WSmAQIvqjSj2z0H5sDANOhYFTx55E99mKA+4?=
 =?us-ascii?Q?NnM3mn3vc4d+PZFAWvsdiTBFzN0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F478194AA56E7240A0E20E7B53A74D61@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdde05b2-35db-44dd-9a16-08d9eb384bce
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:22:07.1537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJL2rLQEdflQ1BlOOreGgJoj2yaybvUbKzWfElq0sZvoggoRhrZVp4YxSb+1bq6hswfDa3MsBfm8knklI0woca06cFOyTbvkX+leLr1Crew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3248
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080114
X-Proofpoint-GUID: mcK4cqUKuREaDLtiV8pC-4FfEJiuTe6r
X-Proofpoint-ORIG-GUID: mcK4cqUKuREaDLtiV8pC-4FfEJiuTe6r
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Remove struct scsi_pointer from struct scsi_cmnd since the previous patch=
es
> removed all users of that member of struct scsi_cmnd. Additionally, reord=
er
> the members of struct scsi_cmnd such that the statement that the field
> below can be modified by the SCSI LLD is again correct.
>=20
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> include/scsi/scsi_cmnd.h | 14 +++++++-------
> 1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 6794d7322cbd..4fd2c522e914 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -123,11 +123,15 @@ struct scsi_cmnd {
> 				 * command (auto-sense). Length must be
> 				 * SCSI_SENSE_BUFFERSIZE bytes. */
>=20
> +	int flags;		/* Command flags */
> +	unsigned long state;	/* Command completion state */
> +
> +	unsigned int extra_len;	/* length of alignment and padding */
> +
> 	/*
> -	 * The following fields can be written to by the host specific code.=20
> -	 * Everything else should be left alone.=20
> +	 * The fields below can be modified by the SCSI LLD but the fields
> +	 * above not.
> 	 */
> -	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
>=20
> 	unsigned char *host_scribble;	/* The host adapter is allowed to
> 					 * call scsi_malloc and get some memory
> @@ -138,10 +142,6 @@ struct scsi_cmnd {
> 					 * to be at an address < 16Mb). */
>=20
> 	int result;		/* Status code from lower level driver */
> -	int flags;		/* Command flags */
> -	unsigned long state;	/* Command completion state */
> -
> -	unsigned int extra_len;	/* length of alignment and padding */
> };
>=20
> /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument=
. */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

