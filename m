Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F17DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbiBISFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238627AbiBISFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:05:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7C0C05CB92
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:05:46 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HGo9r013543;
        Wed, 9 Feb 2022 18:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Al+vhv5Ed8wyPk4wnP6CPT2fcuNo8O7ZRDsax04NdoE=;
 b=BvWNMLY/ubIxucOSWgHY8uWueNRRGHsfDMGPwzprc6PVpbnRGMzIjGWvrL6jdiF8z6f3
 JScyA3lmLvO5r0CXHE3mSRkTqs2Q9qFLECWyoWE9szB1MQrej3kUqWSDaw/YE+SAsFtk
 auz9FUNclwKSnb86HTcbO2Hvs6FBBxX5ARwILVA29DdTiMdSycU08ZyD4Vz0x9Txlnuh
 nw1tOYjE7qeVKPV2P6XklAe+wObNO2mrvjpY3Z7dsVstFl0RAGJ/I7d33dGxogr0y5hC
 j1lq252wq1ue1t3+4x0XZwV7kvxI8TGml60C2ooQXOUIZawM7yyq7UOw+Lh4UAtSclUs Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e345sqa87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:05:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I29Hx066971;
        Wed, 9 Feb 2022 18:05:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3030.oracle.com with ESMTP id 3e1f9hshcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:05:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ilvt+fJ2PgXx6zTN2XJ6vWYlRWqORKkI8NWA93ivaCPgD802AfAZA8tBd8aNf6HVd4bfcguWIN26uurCPfJHYsSbMM5eQrrUiFRq9OLPLnxYgoRPScpIcWS2+2EUSJQsUEgt/xcQO1DL4ain4VUIMFEJqqtrvmLUqmL088KfXIlpzsBCwKoOOmrybJPfltDAcuRNkb8P9V5qsuh3X+1+ALRT5bkGNTzdCYTJoW3XTTO9ACGWs3FstcJsuRoWM2paVnpihNtsUtMChuYmyRWC8fEDDcuKmweZQYlC5rszpI6TWELNKXj1MvkTCqhQZKN7GHQlCUUifmN9W0JFqGj0nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Al+vhv5Ed8wyPk4wnP6CPT2fcuNo8O7ZRDsax04NdoE=;
 b=DD+6giz1tpXTB2V4buIj7ncKmZQeKlbnSEeGHZIDfym/SkEohWkMfa1q691zylW+xhIbfDzLcbw4RELfnoQ54GAskeoT1f0mZ21pvAwgqK7vix2tUMz5Xejkph5gdYJu2opVgFrx52RO8sLvXdGgj9Fnaoux1O7OjVtcilhvK8nNSrASgJ7xpC2kSjuj3a8rirW7PNp4+dBlnmkWYaVxQLeFqemcuSF9A0SSVxqDtbGTYyv1dDZA4OY3nhTBJXRvVwSIMgBqLvTw+j0+FUCz6UNXB6/vhUvXWErR/SAamJmrBlSfFlgiIUaxk9PTymaOCC1goo3nd+0c2JdAcrEkAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Al+vhv5Ed8wyPk4wnP6CPT2fcuNo8O7ZRDsax04NdoE=;
 b=STeH1FG+WMqhkmSLMQ4jKK52YWovRbp0D8UjGmi00GQGGcbj6pDsHM1dKjq126xkTrjGm4t6KoeqO3B3LZQburJqP5sZwQvpUKmoKGuSFdbuGPv2K9ZkBa1fdC4MpbpeC0N/dJHxUcarlRA/xlR8SUCNqPOE+04aMuybeHvixPE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB4140.namprd10.prod.outlook.com (2603:10b6:5:21b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 18:05:39 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:05:39 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Hiral Patel <hiralpat@cisco.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: Re: [PATCH v2 18/44] fnic: Fix a tracing statement
Thread-Topic: [PATCH v2 18/44] fnic: Fix a tracing statement
Thread-Index: AQHYHREmdVD/hHqP00qMPmIrwRmXoqyLhSYA
Date:   Wed, 9 Feb 2022 18:05:39 +0000
Message-ID: <855B5925-4792-4317-A991-FE35A2C886F2@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-19-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-19-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c96d0ddf-6f0d-4b2b-1c70-08d9ebf6c784
x-ms-traffictypediagnostic: DM6PR10MB4140:EE_
x-microsoft-antispam-prvs: <DM6PR10MB414032822A5B007909E6CBF0E62E9@DM6PR10MB4140.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7gsNXF2K3uV6/KHtXpvN+OMSbWHq7xt7ZIS3tEmCmCFLQPvXldNXxcwkPrtrfF52capZPumzB8V4fjSyO+Mfocfhs5whlheIFKVUUxTUX1lIb1EURCCJnqaAF0rzS7iJwzhdZiOQzI65ZTBusEtzRVcY3ma20XOxEtzvrBC/X3D8JddIqBclP9TOHroPPs80rOciPoUQktzj/kzXhwogDnNembqwXXblxGM/OsHEVxNioU7edOfFVGBA0efgRvkU3JRgnXhwRwaIBPsRpNeB/Wlwx4GMvx21tfTUC9zXGcpbBGWlirn6xLjM/m9H+mzDZakY7HqEamvtbDmvTcsJAIMKyhoXMuakbi8nl0SbByNTkxTT2L131IT5hrXWEGQkGGZCPCgigFGq+DsAphwqlSSzVrIolYR9WKrM+aJSG93tgmWXauQDekyluyQU2tpWEbyse4Gb1YtC5gLUXYIiM9UOAZbI4OUVdZh8QL13Cj1luEXZQVWUjhGrhBV66iGok3g0EoM7ytBdZMKcbSSRJyl94aYv8gRsKPv+8KIfGtSFsshN7PtOgW9R5CZi/GEyI1fB+oq94ErUuqxI2sMe2h4r1473GcjaP2whOxT+0uagaLf+k/0RIq8/WAqJ2156wwH0vBpcm7KP84ojDLCPbtwhniLpRmaVro+0JxDFl76tb5pH6r+gCVNdI4tDKOy2uuW6tcWPUrNGLXtUOxgn8gBwl0FbS2ce5Rl5Rg8vpRonztodlYdNgrH6kR8mYtIv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(44832011)(5660300002)(2616005)(36756003)(53546011)(508600001)(64756008)(66446008)(33656002)(66556008)(66476007)(8936002)(4326008)(186003)(6486002)(8676002)(38070700005)(38100700002)(83380400001)(71200400001)(6512007)(6506007)(2906002)(4744005)(316002)(6916009)(86362001)(66946007)(76116006)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TiWHLgOc7syyb/UF//NfbvtXEzzpLDfWf+029kSdWy9bYcrDWL3oundVXmWq?=
 =?us-ascii?Q?m8r4Kd02KdHNKfvV2tGD/mL/TPcIPH660a2zCUGcUGGLOrlGJhLUuKmC1+B+?=
 =?us-ascii?Q?u5t50gknYASyOlyepdTuCgihMj4RSAqqcrcAUxrgtG/CNeLrkAHPdZU/jqmx?=
 =?us-ascii?Q?EbRGzscIOf8izUsGyCRCoREd+DzHcxXqlINf/kItHr16099phToOj156wvHW?=
 =?us-ascii?Q?MUDex6vHZbkGqIYGL8FdXjdWM930FMdjxuQcd+glUUBFWEVHx6CTimZCpyGP?=
 =?us-ascii?Q?k5GTwxg5zRHupD1sHR5jZ5F1r64VSKFpCvpTQRogSGZtozMDgqPMq5ZFSI4S?=
 =?us-ascii?Q?4/SROLJgDMfIJldnipof5B+06BJd95Zb97HcsiQ2M326czr1e8BNaoiBfKfr?=
 =?us-ascii?Q?JuWkWOIT3x8akp/akorScLR/KS6F+EWlnsEjgPi5K8lnKnaqUF8gaw1GqMKT?=
 =?us-ascii?Q?sVs8iY55yw+zdrBjIxfdsrlFZeMFDPVk4ryg5BWsfkscZajS8tjSb3kWGX0V?=
 =?us-ascii?Q?+jhoonPu+mkc8K8TGdf1WwS9K0MAmNbwRb4nIaXgja3u3aCpX9Yz7P+J4HbC?=
 =?us-ascii?Q?hObKOjhOMZNoOXVvp6PR7MxyVeuwx/zolUDWII1PPR55UOyZVk6xEgibRt92?=
 =?us-ascii?Q?RkKQzBzejBEKIeUEAX26E9pbwE68ubmZKZ+T2D2pSp6CIc8DdUJU4UntQ5T7?=
 =?us-ascii?Q?vBqSANkybLB2YgYw1bnsQpdXkejZXrxqLwXA6AlDDhDGf7dDQlI0kvcAmaqK?=
 =?us-ascii?Q?YdUPGVmuKanJG+DxCeqj2gd720YUJnL7ZyTxhYA4HjNLEz37S5YQrffDlWcO?=
 =?us-ascii?Q?XDy8zWRMVFtwmVDy7cOtSIJ9gnmqDvaTPA7ohochPsL+CPN+vFa0pJQGwt8C?=
 =?us-ascii?Q?00MBBaur7a48r9OXf7R800GAGEaipY7VhGL06SebFHfh50pREK6X159MgIC4?=
 =?us-ascii?Q?l4Qg7QHeVc89bUDELiN2MRv9jXKxZ2kLaHR5LuTGyRAVQ61ZuWphJD71G0hQ?=
 =?us-ascii?Q?f1Fb/XdtN03fniOP83IOULMTKu17xTclDIPLSJK5gq9NbI1zltVxzo88woAa?=
 =?us-ascii?Q?kjzf07L2GaIJRlILoniQPjMOrhmsOjXtblrq548pqwjA+KHq4Gl+veyoG6eQ?=
 =?us-ascii?Q?/lcaPjNEPMsG/JffmuGFLevWQVB7djQ8kk8ETzjxGG/4eu+ugQfmUz5kqtL5?=
 =?us-ascii?Q?rVBQXYaGfbZ9pjbAuLmWnV8yqkmZuZlodkPRJmfQNbQC1rhMv9Ce/HaeyvkS?=
 =?us-ascii?Q?p8ykC7Wd9bjFfHE+bD6GZZLO9EOIJYQ3xluTzTiGzN5dRdYI2ftPikx0/qo5?=
 =?us-ascii?Q?fh+kbQx7cZlkBVkkKDvvtE/3fAsEzr1vTC0sGsCd3ULzVyvNAjaK+yYKDTFQ?=
 =?us-ascii?Q?e9k2H40mU1/+emmDtCtU3YZ7VZyuktXY9g6w3NeAr08V6yqg7RdwTc1cz0XL?=
 =?us-ascii?Q?i+ZWj9pDa4EdY9Seuc1cizeFTkTHAwysBUWoW8aFx7dxiflYEsFHk9/hJUcb?=
 =?us-ascii?Q?aM58JTwm/X/6YXYDFB7JhOuT1/0BIxSsguvyeGY5AKj3R7H2+gGiNmzeN0Vk?=
 =?us-ascii?Q?SEJkirvXSc31hdEr7d7LbOIfnUpQnotFZL/8x3jPGXccEJLNN3unAa8JEuqD?=
 =?us-ascii?Q?NYWYcEFu1IMV65cfJn7l8O7PV98EDGJ32yWdGIlRAsVaCMfeuebHppTgJ0Yp?=
 =?us-ascii?Q?NlmkiGnXOmttDLCNim6KnwmHOsuq3GguWv1mlEbaQD8oHSOy?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <240CEFF67FD18742B76BEBBB3D99D814@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c96d0ddf-6f0d-4b2b-1c70-08d9ebf6c784
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:05:39.0973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NznKdVgCuqUCtKfEj1iu14FNAh1byTGSOXo6U4Iw4O2/1QUSp2wQfW+jlbE248P/asNY0Dt6eW/rhC1S7msDzM1KCPRocoGPZmaQ9DCyJ60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4140
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-GUID: 3hxXHUjIgfyoG7d33lP_xob2FppFAO_v
X-Proofpoint-ORIG-GUID: 3hxXHUjIgfyoG7d33lP_xob2FppFAO_v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Report both the command flags and command state instead of only the
> command state.
>=20
> Cc: Hiral Patel <hiralpat@cisco.com>
> Fixes: 4d7007b49d52 ("[SCSI] fnic: Fnic Trace Utility")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/fnic/fnic_scsi.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.=
c
> index 88c549f257db..549754245f7a 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -604,7 +604,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
)
>=20
> 	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
> 		  tag, sc, io_req, sg_count, cmd_trace,
> -		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
> +		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
>=20
> 	/* if only we issued IO, will we have the io lock */
> 	if (io_lock_acquired)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

