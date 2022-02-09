Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CA7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbiBISEL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiBISEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:04:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB061C05CB82
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:04:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HFrj3017470;
        Wed, 9 Feb 2022 18:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rPX6z5ZVsJJl7/sDjSUtqlW++yjJ6zq3EEn8yOg64ds=;
 b=EWXRR4jd7UGAuqzFKxXnOWcJaCIwdERpkvRspG9AS5pwgAlX8cf/B4YZjhyVp6YsOgM9
 9UHxSv36Dtqq2PQHe6k1vgL2BP2rIl0KYtxmaOfll2HeKIuxfHMMONr65+ygsV1qZCo/
 n8rBjHbBvdOZjFTKkmTCRPW1c7X9DEHXOebJqQbUdWrzjkw5Os0mBA/aEpKrLkbuSv/Y
 auW+no6jhxhsxqgODvviGGZKhJYg0JF4fhodsXzUWgfbQR9yB+3fIMaClC6TKTx9vS0p
 oOZKFi5ByAmmRkWSsviZWoLxLMebRKNA5sBwFIxAdJ7aBj/aqEm38tWBK2DNQLar75/W Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28nahv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:03:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I0ICK143639;
        Wed, 9 Feb 2022 18:03:56 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by userp3020.oracle.com with ESMTP id 3e1jptfnjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:03:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9j1l6+j0Njy09c6ns0BCkTGdIgwO2v2cGjf82Mx61vcAd5WzrhuClrHKpnE9nzrpG45wgTNwLG8HPyxEpEHPbmUF4cNJ0sKaZqfG2sXU1airU2KM9q6NkWs5w0C5wWU5TF1u2PCP/cqgNRBDkrwQhx+TNeDC7NDO+0ybJaiq/VBTtoVtMk5ewKh8ekUNaZIkXCIBulZ5mn0PeY40Cc6jgZSV7PlqrUIp4hvry3PK3plfTGobosAWvKjMr3sB81+WwWQKM57ffZFBdRn1bHlr4N+wWA/xFCVSBT8X/bXJOlqMqzxZgp/Ya0IInpGsLFsNG2CiN6d3Lhp1CaALioYfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPX6z5ZVsJJl7/sDjSUtqlW++yjJ6zq3EEn8yOg64ds=;
 b=K8DB+ZZ3Bzr4jeboY+XM+rfStgYH5jnK8mT0DKMbQ2TYpzNkMZKdoYbYtAyAw/Nv9nWuA2TDowvqtjbZfB0D7nBvqcv4Dtx7UOokGmhihFYFulGu7ry2zj915mrDrvM1B1WKG2qBtHaxwFLutrpmQxt9v2uJrq7blHjrUiONxTOE5YU0th4FYiCZEI4wRQo9lHn5tNnopI0oVwIYEan9AyLTvJ8pc9+VLVxr679CZO3PvZIVdkVRamkbDWZM8c3XQ/isjcfHyRiuL8nIweZ+XaKqJYR+Eqk5vg+i2BzlMA06abwSaFLtQj7QduZqRzlyksRTXhltJHvaKtLL9PZTvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPX6z5ZVsJJl7/sDjSUtqlW++yjJ6zq3EEn8yOg64ds=;
 b=wpytxt6dYjC+tePl73c5ZzufwiPrzwdCijVd1nz47S0sJIZCMDSSMCB05nrTz5aa4k4UYMSkEBISSY7L5FiXrhdFxPvhHD+E3V8IFDEjxvhsaSsTsXfdgX4SaFMBLQIOI5tYXHvDohCFLiJlxjahoCq2yp3XCyDaAgJj4l8KDiU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB1289.namprd10.prod.outlook.com (2603:10b6:3:b::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 9 Feb 2022 18:03:54 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:03:54 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 15/44] dc395x: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 15/44] dc395x: Stop using the SCSI pointer
Thread-Index: AQHYHREy3BfLsJoEY0OFfYF7XswHqqyLhKmA
Date:   Wed, 9 Feb 2022 18:03:54 +0000
Message-ID: <35881D70-C729-4B71-B8DD-D96996240CE9@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-16-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-16-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1d6cf46-c5a7-4669-4280-08d9ebf688f4
x-ms-traffictypediagnostic: DM5PR10MB1289:EE_
x-microsoft-antispam-prvs: <DM5PR10MB1289F6D1845B8CC2E4018F4BE62E9@DM5PR10MB1289.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5uQ1zXQqbalRGblE0KD1ZkCmF3+2arXe4pfQ7UyrJhXEKXajJxFSazBuDW4ASWPoiLMaJ5AnYY9EQVsicayDgvwMA5CavxK2Wlbsm6BdneZ1TlIXZ/wJ1gzE18akMNwFYrtljIZUQZhv97kVqTZb5yxt/FbQJm3PfnsC+uM7/7XHSbOfYJpXzaGSiodVQt+qVAtonA60oftuD3RVBBmAAJjetb86/ktKPSg9k2ONtY1A+9ZpiyH827lcY9tU+TMeaSSfs0CilJAt6wTivYa/Bkt3uDoJSg3hsIdKeQijy8X2jZO19Om0KcfiVC2ooO5/XXyumjL44dDJtkIFczbSWF/yjQSL5jIdDEaE7DCsxuGF6mOG21K1Fnvua2M/6TFjHIQEEPuYPRaB+NyCSiIGw35U2JQ0v8BqLOTfDtM4OHirOqI0uAMoAug1IiM/8sJLNf+PVdn1G9EC0H8VWFEedX+B28NtPTxeN+Ct3vDN0eVAnPBeY2I+EudzssVSPWIJlC2kIY8C6DYj4bo8HMSZVhQG0hwULKHlsyETVN3RINsz01y6qGJJAfPVK3eDzYjwwHdrsxtS7fnHpCz/2IMN+/dxj+QllYweE2OLlK/vcCD7EcYbD0rvoXbEzGm5Ob6W1d/L7jIh1yx+GnDFfAYpFljj8lwLyPyZCIGKtS33uzDUEydzt7pAdXLVeaD8xr5LZ/PznShVGVu1YnGncsyZD67pO69THndTCDwGLpEm8aRRbq2dYwV5lN2p9oDzKxO0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6512007)(36756003)(316002)(508600001)(71200400001)(6916009)(33656002)(38100700002)(2906002)(66476007)(66556008)(8676002)(2616005)(38070700005)(66946007)(122000001)(66446008)(8936002)(4326008)(91956017)(5660300002)(6486002)(53546011)(86362001)(4744005)(64756008)(76116006)(186003)(83380400001)(6506007)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BGzw+kQvQOShhUEhgHJlcucEdpvEM4LNbZ3SfymgvR/oUsZ9HVNiKN5n1YJO?=
 =?us-ascii?Q?ZkIsaOIVgDsrbUBKYw2Hpgq0SpahA8mWcAjkutwg9vF1CkUYe76+0v9feyv5?=
 =?us-ascii?Q?R17KAdFK1sgnv0mUJMpPdDaW26GkfVVypZzNMzgrt6PwH7AG3+XZNV/ttf9J?=
 =?us-ascii?Q?CtmXoAaC5hbzq9wf+vlfhuAsbSTMSi4Ffe23biAyIdHTIh9e54J/6O//aftn?=
 =?us-ascii?Q?Hq4kus2dscX+n4dcn36Q/96qAelsqNoY7TiGPDrGaiY2fD6cCyUNQ1B/Nu9K?=
 =?us-ascii?Q?e57TmM/dq6EjuTnhU+JCGT1TPtz3sCj1sNVnWR8qA8IUc+yFgZjwWvNoGSXV?=
 =?us-ascii?Q?yOxqL3jSSueakAb9rfJT3Cvu9N150628/Bn0lZ2I9YWETz/VLO4M5mXEJ8xy?=
 =?us-ascii?Q?nsBwLmy+gaNxjYQx3hAiKETzlOBtiHuSwxINVjDJwewo51ausj6qfY1AAX0b?=
 =?us-ascii?Q?he60B90gyXyhDYw0xp2A899RwCaMdbzTxoAgt65yWGU7UmOXT2CUCaKcgbRG?=
 =?us-ascii?Q?8cAIx2b063cX2R/aE9LVVtj+jbKSCGJVlSEzwArst3rMUbICQ8Tg7Sorda62?=
 =?us-ascii?Q?/UN9IeqrLa6zgNLXI2ib1+xfwXgUXq1YMR29+mQy0y65ehaNjkIQcwVuXF3j?=
 =?us-ascii?Q?9wTShqMNQc0Uk14AH+GN7UIZ5dYeYByarT0Z9TJUjKDOnlQrvLbxa802EuAt?=
 =?us-ascii?Q?Mgis+I4pwVzfHhx+Dxk5LSTZdTtRFcaCtjZmj9063u70Z1L+X9lN9DeVHuCh?=
 =?us-ascii?Q?qMg83uieXTMBOCc82nyCYzYQuwY3wKnhSvYR6gJpvN7bjh5FNokxH7qXK8c5?=
 =?us-ascii?Q?sMqZjd/q9yo6TddlmVkMBHy5Ox26Yzr98k7OJfrzdQN/QgzmaXngoB8sIeiR?=
 =?us-ascii?Q?ljsbIBCarGZFyBrEq11PydvLJO24QA0DHF6vZHLfbRC8Wl/3qKvuMBMzCzTj?=
 =?us-ascii?Q?DsDXKxFY4hMH+NQNdi+hujFz8LD8ZYEdQ+jf/alBXpgDCZDZLQmELXHquhmU?=
 =?us-ascii?Q?8ES4OSDW127gspAB3snZ1U/nQ38IltZA0mgTSvWsFvtLEYs0maq2NxMPDGDS?=
 =?us-ascii?Q?xNj8QfmoXzdAN8lxm8JwCQwBTT6w9mos1KUQJpB/0Lqw9CNlJ0Xg+nX2OBUr?=
 =?us-ascii?Q?x0ByzrPlAWSftgQ47tOb+JPkoiHo14W3xb89eAkMi7wyE1E9nwvpJ9Y9UO44?=
 =?us-ascii?Q?FjbJs8gOBpOBwRrg9TEWWMcYf4DHYkdaXEH/kBZpl2cEgOhZbWVi9XbLDYAV?=
 =?us-ascii?Q?z/IUlpkpYv2P4vFnhqje3e131Mv1BYucZfmHRbPO/lEA6gRsgORiI8yt/Mwr?=
 =?us-ascii?Q?C91MfPaVDePa/7+LlQlU497mEBDXFo+1Ub0j8zDvoZrZ7qZu4LkELaIWQ95f?=
 =?us-ascii?Q?VdvD1PcNW20nF1O6+kVRIX7BPW31t7XH+hzwlEnndsxSvYYln/GZW9yY4eae?=
 =?us-ascii?Q?ao3iLTuZWzkDQzDBYzwfdRO/m+wuGq4tgXKtpTdOve/Ad/klS6UOwB1embSE?=
 =?us-ascii?Q?5wikLsfe/TC+0b3PTFTZvb4MfKBp61I4Zq3dotQ5cVtUJFMjklMKqE5v9ysm?=
 =?us-ascii?Q?6xq9HSZC2PnqmLFg7gCcOSMug8Jewri3PKutmRc3VJfsjeL1tj0HzZseg3Y+?=
 =?us-ascii?Q?1un0et+oSVdyRBPWKnbJhbaL8x3FPYzjyfggT1Gy/5l4IMoWsva4+z+HPT6c?=
 =?us-ascii?Q?8MNtQIoLhlfvK3o/vMn5EFWfn+iYzj20UwrVF+QG4xHzU7l9?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8BCED29BE4AD534F9FAC00089800AC80@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d6cf46-c5a7-4669-4280-08d9ebf688f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:03:54.1358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z78+aBOAXf8nTQ5NxxLjJPIaJBcGTTKCyi3sXCjfOevdDEye+QxmC9OSU+WNn2Itkx97mNrT9gWvp1a2jsWufPCJuueNnu35rxspOcvJj/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1289
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-ORIG-GUID: u7meY2Vy9hxo_4cCiaURTLOjI0oVg2ue
X-Proofpoint-GUID: u7meY2Vy9hxo_4cCiaURTLOjI0oVg2ue
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Remove the code that sets SCSI pointer members since there is no code in
> this driver that reads these members.
>=20
> Cc: Oliver Neukum <oneukum@suse.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/dc395x.c | 3 ---
> 1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index c11916b8ae00..67a89715c863 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -3314,9 +3314,6 @@ static void srb_done(struct AdapterCtlBlk *acb, str=
uct DeviceCtlBlk *dcb,
>=20
> 	/* Here is the info for Doug Gilbert's sg3 ... */
> 	scsi_set_resid(cmd, srb->total_xfer_length);
> -	/* This may be interpreted by sb. or not ... */
> -	cmd->SCp.this_residual =3D srb->total_xfer_length;
> -	cmd->SCp.buffers_residual =3D 0;
> 	if (debug_enabled(DBG_KG)) {
> 		if (srb->total_xfer_length)
> 			dprintkdbg(DBG_KG, "srb_done: (0x%p) <%02i-%i> "

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

