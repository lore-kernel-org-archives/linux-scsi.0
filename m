Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C143A1D3
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 22:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706740749; cv=fail; b=TcQZT4CYeAerA9plZETXLvo2lrOs9ne6ly7a6CR7dFY4pSVyvgGvIeEV/iVcgr2d+QpvqfR94qE+A74cAZ4wmAlSR5qcS4x2Z70wEjbXU+R5/hvtW9cxggG53nWkof0CJhIZWNnDE6W0HEE/5oaqlS8K4wr3auOLXGyEfS5IxNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706740749; c=relaxed/simple;
	bh=DM3v9cFxKHB7u9PjJn3g58rkOitAKsFtZ3Xa3Q/ZieM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X7yFprqi7QbfmuWf/an8m95vFicFTz5O4MipQLpn+GzY0LhexsN1PL9+7vojIIy47vCpoYb+LhbAwuIcKsl03XH6VhWixTkTGHKyA+4i7ungnmseoiCICx2c8AmPTrOSrIDr5qY4K28HhvOTxFVG4twtLsMAzvK5x+3FXvoQPZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U0TmbAio; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jizu5MV2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U0TmbAio";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jizu5MV2"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40VMUk9x019116;
	Wed, 31 Jan 2024 22:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=AwAFa9taTnSsIkOG32ZlNYN6WqFdEGjE5EnJsykq6Uo=;
 b=U0TmbAiomx4aiW5CSXsFEZUdg16oXRIbrdoaZb4Lw5XDQkNxqPLl8hOvk6RoE4QBWjb5
 mExxmkbeXtWGe1QZHhHR6AKMJBaEekrm4wC7A1UGM+iXr8jyQkQWPwts8RpjkrtMRZY5
 EAVoVhwZHkbcsLHuaRkr4rjninbtpV5Wse1hzAiwzfBUMEtHf+3JbfxA06ZG9UK49XVu
 5GZ86GmuDO0iRvtAxNheOKpqAUOlEFcDiEuc17YF4Qh7lkscW0J/BGftZZOUxuCVsfEa
 /VF8mft18XACtqRmnw5ogXpCUbnXGny8rGEDjR7jW2UTfmGcIILpU9QPBqouHJMzBWXn 8Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb3457-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 22:39:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40VLmxHS036057;
	Wed, 31 Jan 2024 22:39:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9g0bhg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 22:39:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKmJO+g5mvmF0bz5JsA3EjOQYvifcHNzMpiZ9QtwhhYqsC5aFitIbMK/uK5J4eghv+JCSnkCP6ez4nzFc/7wDMymTlJWBiK7NIGm6ElMLvZesBnYY656r0lCT9KfTDgN7KCzbQ1Fc0RI913msRqWr430oenLgFlzVpOM/t3+NMjH3LRnk434RAdlzlVwr8Tw6jQdGYzLUSCvnonjQ3gyRMhYN2t2lcHJsaH0WSfh0UUiu3gl5pAZShVGEDFJug+4cgRd8/aG51yNc2qfrdagm2lVITBmRPIF/nVE8Jcuz4ErhUNG8Vem4LhYMlcfFOKtknmhunqa3MUR3LSveAsn8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwAFa9taTnSsIkOG32ZlNYN6WqFdEGjE5EnJsykq6Uo=;
 b=eu1wRiy66924bNI8aV5FbiPN18U1UNWFfs/nSguI3k9W8c3EGOxC/yeQdo0amIwEAUYx7ZpnYqJXNV+Yosiz7HnIwVr70nsM3In0g/0v3xZm4xM23D5wsW4XgSIcTsvOWj1qlo9H4w8pdMHdLd64El882qhtyvhKljqFkek3P69j9dgOw5D5bOVuhYRRarwI3VpmmKlWAksNAqeUlgA79eCj6OU3TjKgLuDiYPT41jTXggw5W5mHuHM9CttNfj6AIS8aBUIvjBlAw8M7UOIwQ0SWC4RgqFiVXRDzhGx7NBCps/CF67YVgGvBP57qNy963KHYQ56S3D8aMUgqcbBxlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwAFa9taTnSsIkOG32ZlNYN6WqFdEGjE5EnJsykq6Uo=;
 b=Jizu5MV2ZH1oprcK0JbIRnddJaQSuLKOQnIuojRgGYjL6cMGlGf/LN1XC6miqx/TXqFjBhjSdXvJUqnQCDtFg3x28ajJqkuKlnvFc5FuS602vSZdtqDlpCsrx7JyOSOtnY4lbRe7WT4VMJypk7tm4E5lEJOJTrm4zcGzcqKgxUc=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by SA1PR10MB5821.namprd10.prod.outlook.com (2603:10b6:806:232::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.23; Wed, 31 Jan
 2024 22:38:58 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 22:38:58 +0000
From: Himanshu Madhani <himanshu.madhani@oracle.com>
To: Justin Tee <justintee8345@gmail.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jsmart2021@gmail.com" <jsmart2021@gmail.com>,
        "justin.tee@broadcom.com"
	<justin.tee@broadcom.com>
Subject: Re: [PATCH v2 00/17] Update lpfc to revision 14.4.0.0
Thread-Topic: [PATCH v2 00/17] Update lpfc to revision 14.4.0.0
Thread-Index: AQHaVHR+yTG0wKxuvEqjTpN2kbqDMrD0g5kA
Date: Wed, 31 Jan 2024 22:38:58 +0000
Message-ID: <FC0B6DB5-A8DA-4C79-B067-32B7F73C7AA1@oracle.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR10MB7959:EE_|SA1PR10MB5821:EE_
x-ms-office365-filtering-correlation-id: 1ffcc507-725a-465a-e1e8-08dc22ad6a41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 z0849GTKNnyC4tuXqaGVukyw3aqPKHEo08fI2zlY7TvTKzJ9wjORvhZ9cikdSbOo3jnVVZAHQAvPn3wA67w0SOMB/wGWs4ztVQRoGD85Vw6c127sK/oJl9CAW8LS/uOtfm7rXQxZ6atP+XOHQAT7vznFRyF+fIuEY5C8AoBw5ApIs+QsgJive/0WMv0KJMZ1X4eIdTuk7QHQ8vcouKMnlSMHn2UXLwcIktfZajK4ul/YfGHOJCOxPym4FxM3wX5Kd85ojK/2oMwSD9NDRDuRLwlZ/wcB2Q2Vh8aeril4qRf022ZpPHHx76Y5MC6mHB1k2JgnUClRUn4rVXh+uHRJD93e+/koyLVijeUwdHgO1KpQTA4HeQSFcZPHOtkxStXhrCyXlBvNrQPdmJaZYVGJXwQkH+CkaK22De2iJG/BZzfTfMIBmvHi6an0/ET3ylTgs8vjL88KtW7fUmjFBQ/eDjF3T5xeAGBNCWqs6wFUZ6+SWMb5JslrXW1LQgKjqF9jwVgQ1DNkWSqB/xM4x0mSzRaAItvbeEnGeLkZW8kaNGvuDKNg3mvokUh5X0iHSRpoYDuvkYtzOUvB5amKDwKJf3VN+114Bpg4s81JNbhBNDxlp5NON0dVDO5rBaxEOsv4ECRtktspvy1gXkgog+xLuQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(376002)(39860400002)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(2616005)(26005)(41300700001)(54906003)(6916009)(64756008)(38070700009)(66446008)(316002)(66476007)(83380400001)(478600001)(53546011)(36756003)(6512007)(6486002)(6506007)(71200400001)(38100700002)(66556008)(122000001)(66946007)(2906002)(44832011)(33656002)(5660300002)(76116006)(4326008)(86362001)(8676002)(8936002)(15650500001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?7oAw33fg2Oyy+ynnO2aw/xl9JefvBIQJvgJcgPu+d50yc8ddZyimfP++Gbr2?=
 =?us-ascii?Q?u9E+iEyD92N650X8faeRQSftYf/DzPL9pe7oirSxnXJEgHr8H6OT6viPAo8J?=
 =?us-ascii?Q?i4DSCUvoSujFNpYtoJE6amo+gK9Z8EpDu7Auy+xfbcVfWBcC/OeOv4PnlPOP?=
 =?us-ascii?Q?CanDehgQlkpFmczAVDF1pYhMqIXIGNdkIBkoPzF4Nj3I20SZJhAUU1a9GwWd?=
 =?us-ascii?Q?OFmhzpLJCyzW5fC+dk3Fc7bg/MVySYqExjkG1S5RyknIDqrUx7gTjXfswniG?=
 =?us-ascii?Q?5tQeFGOoCmgHBYmK3uZI0uC8N9Vm8sDZjvUNa8eETeGOn8uXnko2f/znCxvn?=
 =?us-ascii?Q?XR/sKSyFmjHIqgpIYBqyHJP7bxpPUlkj9C7bTcVeZPtitmxyYhZDDbaAAumb?=
 =?us-ascii?Q?FFpvs4+k4DwANhoroST3HARK1jlGkLbKvQk9+SNwkfBGPiYMUb1Fmb4vCkGI?=
 =?us-ascii?Q?+MLHDB1kylqfE91cS9czHs25xTYDRJ1e4Vb322xaMUE1UInbzPsN62usLe4D?=
 =?us-ascii?Q?9sWhoOTjeV1ABVnQxhofIF9M8LfqNPUkGVmSIsOqe/ZloXK5slDqIIgGkv8N?=
 =?us-ascii?Q?6B7D39J+p/Yy8YNS8JsYwjqAZ+nvjln84d0LaoNGwsmurfRfol6hfyUjZkb2?=
 =?us-ascii?Q?hnmn1duXLjyUQgjhRjbmi2gd8hz5yTyNtR8XjNsKkZ8nSdSBWGlKxxoKjx0W?=
 =?us-ascii?Q?GdoeRV5u6r9EF6zfJWK+h93H6+Y37/9rdUQJ8ZOIYNJnP9nNYNInTOS+w25m?=
 =?us-ascii?Q?EvyTLocMpgwEXETYLhps0jvkRL691lPw9Xvpx4OiPcFC6OZRFqMjMfz2HL76?=
 =?us-ascii?Q?VTtIRit+NI3W9FlZZlWQsHSSHDvj+Zr7nlFPwK6YyPHRRH01KK/Y8cSaoQzn?=
 =?us-ascii?Q?5re+cwnD7JhK8/YJk5i1T1pZC6FHjjQmpHsXojZo86M66ZuYeynOOqfUC5Ws?=
 =?us-ascii?Q?H5aU+Ri1P3LcB3+GxMFfkP9OhNGivtwyDpVKWY23nlQaeLq7VsllVgcKza1r?=
 =?us-ascii?Q?Fl3Mz6hsPK7QwKK0jej4aYUVKd0c1wstXcrsh4Dm6UUnGkj3UQoGHw/W9anO?=
 =?us-ascii?Q?QKBnM5iOhLhi3LS0m3orxVk3zXkWuEi97ETLOlmSg4S2vWR0vspu1HcXxyCW?=
 =?us-ascii?Q?AfCbVL042bfyqZWVxOFVQPZyyBpTMAsDBgyQBlXGXZrzMTAdSJYceWK2g8WV?=
 =?us-ascii?Q?bA7NhRn5587NOaOvjlROV1oH6cXhGxZVoJNhk0kbAVm34BEoVJjSL05EEvId?=
 =?us-ascii?Q?QhfuzPkjXeUXFN7YkNRO2rzthpqYtrJi2RrndtQOa39sIuDs50Rlggrj5AD3?=
 =?us-ascii?Q?OYYV8ZdaSN6FlTjN2cXHpTzyh6EkWgXT5qyG0QcwEQIJPstpd6ARYRfE4iuV?=
 =?us-ascii?Q?pYgbdynhk3XluzQuiuznPLglFISShaUa7jAmBOuVAfRnuCj2VCMZDeMBFuhf?=
 =?us-ascii?Q?cUTxi3Q53LkR5qkEr7pZy7cEEGDtapqqBuTQzWgSEi8bufseJvv310TcQskt?=
 =?us-ascii?Q?LeO2Rv+K68mwt9BL2IbJbWo9+SZv4pdVdcADDAS+qFYkmHV/jiCGlMnlfTAo?=
 =?us-ascii?Q?tYX1qS+F5H9haa6YXgKAJTBNrGkukF2UjtdMvuggoUID0QJOczcPK24ROEuS?=
 =?us-ascii?Q?q2QX28XQBQhn9OfLGNq+nQ0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A6C91A240853DF4C9C0480467F34665E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GQE2m5C2yBo/gXH9d1EPxaGsAejBpeFUgqOrTAdatAA0rpBHuVlJeW+35sTdLsTKQ4IXhe3v0JCLU9xJPjpbR+cpm0zF1FBY1KpXFkHLGpFZB71bfrNZcmzBqitQv7teWKdIHyhr1XHXQfNIEhHZvmOcqgxNlJkoTUTvONv3xkbLUTuwJD+JPK2uHuUOQqgjK6p4wzhSjVe5fxlac7Gp5TXnG0++npTSI/YgTpfylQM9+Yo5QW/YjPbARLtzQFxuHCm/uA6xlBVGWvCBWBxmhJ3Clhocet7nv5fk2/m3YVCBZPDH8PlC1ev1luV6u0JnOzs7mupDfOLkxjkjSL9b9DHAm7lI20Rq7kz0BLAQiqKL4ujxBFJckuhD7Etc1vLzSb/dAa1mGY+Gy1zbs8cvab1RS3jcJ7aYns7ELmJSUjtt1Tyuk1xLSFqjj/6noEEgHArWm2ozA8aDzBWUUOt29qFzGRfeb4MWot1YyH79rfvjJyoXUdy9B2K56dOXesIlbTELQACYACyz3MncuQNbGXZRQ2AvZnOUjc0uGhak5jNkRPTvXIpQQugpAVIq7gVF4KuPG0Ob9RVCzuYK5eDKDfbm0ggLBo2ASeQDr3KQ2rA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ffcc507-725a-465a-e1e8-08dc22ad6a41
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2024 22:38:58.7010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EKrPNhBdXozzhJb1tO40bSNOe7prG4IjZtYLsw6NIDxcazapFSMIT3QIf1JPyhrek+06HRKYEaW+asYxnMUBkoZNLZqB/0gF6TOq7I4jBDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_10,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310175
X-Proofpoint-GUID: FtGEh6icIllfBMdusLLyKh1GCwsysoWd
X-Proofpoint-ORIG-GUID: FtGEh6icIllfBMdusLLyKh1GCwsysoWd



> On Jan 31, 2024, at 10:50, Justin Tee <justintee8345@gmail.com> wrote:
>=20
> Update lpfc to revision 14.4.0.0
>=20
> This patch set contains fixes identified by static code analyzers, update=
s
> to log messaging, bug fixes related to discovery and congestion managemen=
t,
> and clean up patches regarding the abuse of shost lock in the driver.
>=20
> The patches were cut against Martin's 6.9/scsi-queue tree.
>=20
> Justin Tee (17):
>  lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list
>  lpfc: Fix possible memory leak in lpfc_rcv_padisc
>  lpfc: Use sg_dma_len API to get struct scatterlist's length
>  lpfc: Remove D_ID swap log message from trace event logger
>  lpfc: Allow lpfc_plogi_confirm_nport logic to execute for Fabric nodes
>  lpfc: Remove NLP_RCV_PLOGI early return during RSCN processing for
>    ndlps
>  lpfc: Fix failure to delete vports when discovery is in progress
>  lpfc: Add condition to delete ndlp object after sending BLS_RJT to an
>    ABTS
>  lpfc: Save FPIN frequency statistics upon receipt of peer cgn
>    notifications
>  lpfc: Move handling of reset congestion statistics events
>  lpfc: Remove shost_lock protection for fc_host_port shost APIs
>  lpfc: Change nlp state statistic counters into atomic_t
>  lpfc: Protect vport fc_nodes list with an explicit spin lock
>  lpfc: Change lpfc_vport fc_flag member into a bitmask
>  lpfc: Change lpfc_vport load_flag member into a bitmask
>  lpfc: Update lpfc version to 14.4.0.0
>  lpfc: Copyright updates for 14.4.0.0 patches
>=20
> drivers/scsi/lpfc/lpfc.h           |  94 +++---
> drivers/scsi/lpfc/lpfc_attr.c      | 107 +++----
> drivers/scsi/lpfc/lpfc_bsg.c       |   8 +-
> drivers/scsi/lpfc/lpfc_ct.c        | 154 +++++-----
> drivers/scsi/lpfc/lpfc_debugfs.c   |  14 +-
> drivers/scsi/lpfc/lpfc_els.c       | 446 +++++++++++++----------------
> drivers/scsi/lpfc/lpfc_hbadisc.c   | 350 ++++++++++------------
> drivers/scsi/lpfc/lpfc_hw4.h       |   4 +-
> drivers/scsi/lpfc/lpfc_init.c      | 137 +++++----
> drivers/scsi/lpfc/lpfc_mbox.c      |  10 +-
> drivers/scsi/lpfc/lpfc_nportdisc.c |  91 +++---
> drivers/scsi/lpfc/lpfc_nvme.c      |  20 +-
> drivers/scsi/lpfc/lpfc_nvmet.c     |  14 +-
> drivers/scsi/lpfc/lpfc_scsi.c      |  10 +-
> drivers/scsi/lpfc/lpfc_sli.c       |  56 ++--
> drivers/scsi/lpfc/lpfc_version.h   |   6 +-
> drivers/scsi/lpfc/lpfc_vport.c     |  69 ++---
> 17 files changed, 717 insertions(+), 873 deletions(-)
>=20
> --=20
> 2.38.0
>=20

For the series=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

