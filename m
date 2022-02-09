Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D224C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiBISYJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiBISYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:24:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D39FC05CB82
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:24:11 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HMhp3013360;
        Wed, 9 Feb 2022 18:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=I7ZKmVtB34ZxBFDIWvL1poA9wTFDsdGlXm04mBKn/+8=;
 b=XdIRpJLq5J5Gy8YwywEwxe5BNmWPRXjJvNY/PtpaSQxCiOIJPuAYRI/u+3jJcxYjArhS
 rTQXNr90mSBceMx+1V8OJ2kXCahJeYxW9K8loyXwSr1adgianxGGOCQs4OOsaICyVZ0h
 mpL/jOvNWyHkYIWjTwZef1MkT6odvL6ZTtGOwdYNhrmtm6W7TKqUKHMXbSJOs8HZC0Su
 NRA4QrwUX7xc04B6YfG5Bh0DFbvyY0TnQVX2pTrywtL3HrjVexNYBtNE66X6TxMn5lia
 YTUjcUtGtyax6IcDxkQ7dKAjaz8TiGwVoLat01k5tISJTwh2FKDg4HNwmKecDpqRjr+a DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368txmtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:24:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I1cNc104177;
        Wed, 9 Feb 2022 18:24:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3020.oracle.com with ESMTP id 3e1h28rh9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:24:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+0Z8oBDzY0ZPS/2Yq3ZxSV5YkCqgeLeXtzNq+ts/UqL6csxIkCg+cIPqi+1Nn0apTSwXAnO7VcCj8vxaKbocEGRtHcyebXOwI00o4WO3O1xUtEa3Alwe4SJsnDBh671BKrvUhurz81EIEjv2vZJJNKNo1j50Q+jP3XVBzmzIVgiTu/DL1wwxHcF53J9OE2Ta6HaKhLfwbdXlTsYTIabwUtfkqTYgoMD8g+2uUEPeUxbFsjkMZT0TsedszCNCezl64cT5QxgUAy89nACaTC6gmQAinBt5RcIDLNEfI7GyiFrLRA2oL9+pL6WkdXBWTFedAYM8xQJcaeWV0Ymey73FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7ZKmVtB34ZxBFDIWvL1poA9wTFDsdGlXm04mBKn/+8=;
 b=DIsjVALymMupiMOMVwt9x+YM1EIbXcrNKkBBHKrXQfUOII9FC8lFQAP8iMQxGYDfEkuG/0UOzfwuwKm1bwMnybe12sss5SWKDhVSnjEyFz13rEDA8LNAGkIrXnIQbcHOfZpsxAuB/qIpwOOFVaDcLiq8XRJdDyIdLS9TPRobQdLC5jNNReBqo7MVTnB3lyTTTj7zatQNZZtr+wnVLZxyns4bS0ory/ysuFOSljd2DGj01tIRRk7OMZHigxYCZ8fV/U5itS6ZbsxR+Y/wReUHmz7i+XCIO8Kxt5/SrvE6PQJgn6B029tg8ahz4vI6yE2rPnzLYIGEjugYbE+oAnQADQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7ZKmVtB34ZxBFDIWvL1poA9wTFDsdGlXm04mBKn/+8=;
 b=r5o21ob4RjnUBH/neBE6rDkZaAd71ObsJ5/bbyaUqSE7VCfuEy1MC65Dc0uw0/ChgVD4tOcjvJ95W7yzc1tonFJ9qCJ/GKbnucfYKPHjSW8Ga98wmiE/uGt7EmbMEDLK2bNzswIAG4aMCUn2HRZSzka9dS/AQIAbAeZkPUYlhwA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB1785.namprd10.prod.outlook.com (2603:10b6:4:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 9 Feb 2022 18:24:03 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:24:03 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 23/44] initio: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 23/44] initio: Stop using the SCSI pointer
Thread-Index: AQHYHRE2MsIfYF7CukmVzAO7J0Mw6KyLikoA
Date:   Wed, 9 Feb 2022 18:24:03 +0000
Message-ID: <FE6034E8-655A-4C64-9941-0495524BF97A@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-24-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-24-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8ea3dc3-c3e0-4bd8-3511-08d9ebf95992
x-ms-traffictypediagnostic: DM5PR10MB1785:EE_
x-microsoft-antispam-prvs: <DM5PR10MB17854B4B76EA6F9701DA89F6E62E9@DM5PR10MB1785.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TVb8Hl0Bzqgofq4zFtGVoFpWeJ29YP12Zm/zCH9hRLnveEtIS0ts5kWsFOdWWsyyQW9NzxpDI6YJ9jj4QauMGZHn58sYmR2uKPAcquTJQAznbIPqgIbVMamMmnSu+azMcBXqhT78fOjp3QGQks+zVN93+Q29QmcnzKThEp5bo9ngwZJrzw61Hs4J6ZWMOlZMuwoUzDaDPKavdSGvmHsNnhvOMS+9X5+IihfnSqw4rUfora+gHbILyEZ1iQA9aIbZDDVXrtW8VsjYLDgr3bTT3oniJpPKmxRC5pmleLJt0YBsgXxi6eBAJ0rbK8jQonyLeVuWzxArt3nNVNEawC+USShroaaiqR/zv3wHZSbRB+4IBSB9DcRpwJcxavbe8kjCbIa56b0nPOtIM2p2LuCnc4DO3Z90fFyay+Rzg+vX8JsPNhwYtyBiJrZ1TCyepZzIPh5bJXnH1SGiHesrp/BA8qvrlqcNgkvvIiNIK51Hwa8zan432EGqirDQK41D5+5YI+KVlTzFATkrIWm9P28rKGDsz2LYC+oq+TGId0lPqRGXWLHVJaeOtvPYh4jlgGrcZ9IjAKgUP50fK8l/P1fwGse/dkctJvYoo2uUpiuOOBMMEu1K8J7uC2BgSGCrIPFgee48CbBPMDpFQv1ef/rKfdqCoIeoqpLNCAryNzlpqx/oToUpdvbYPOnH/1JShK1CBuikUU0eKe/ni610iCE7MxX9t/7nxzm96qZteC9mgK135HPf9ITZb0m3XTlleCcW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(86362001)(36756003)(83380400001)(54906003)(122000001)(508600001)(6916009)(6486002)(38100700002)(5660300002)(6512007)(8936002)(6506007)(66946007)(8676002)(4326008)(64756008)(66446008)(66476007)(66556008)(2906002)(186003)(33656002)(44832011)(71200400001)(53546011)(76116006)(38070700005)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TH/huFzFfL88e/THH1tCmVBe3XPvFd/K2AyxG+y/4234PBcDz7KXG9rK8SX8?=
 =?us-ascii?Q?gYg1VpX13kg7S3KSfdZ0/Bkn8Okx0IEu30FzRpYNnotiIDItwpV55yHA8G/1?=
 =?us-ascii?Q?JrPiY69jR4b8NTMr2QsQL2zSzHuL7z4WeSwG26oMbgRQBt/zArimLqqg1Gmo?=
 =?us-ascii?Q?p7N8rS80W/L4PcE0016azsv/FQcClge2ue7AxRU2PcB7RdzWv+zqaD1kWnYi?=
 =?us-ascii?Q?FWFGy4iX9yby+ny8YQgY1XhRme9Urhw2cyh+rPwj8bgD1H2G/UnNn6iLDwFC?=
 =?us-ascii?Q?Y85r40FH6pV66X0h05RRqjMZLjw2qcFt+8Vrc3gMU6ZNKV3wnyCJs2gWcGjV?=
 =?us-ascii?Q?f94eaXE3Ks7R4ufyMOtINxxWvrq5/fPRfpz7JKUaijKBW6YXdiFh4zSk9prp?=
 =?us-ascii?Q?in/HfBHrfBGWdp1zee0tBlsG/UMBTvkelU+TpRZTzw2tUnrj8cKqGQ4BV+cp?=
 =?us-ascii?Q?eIVAhb5QaYRqmJ1kXKZNS9wNrP+eNz7E7nhzd4FLIlIBB/8hZQqzWTrg2xoJ?=
 =?us-ascii?Q?umkskszL2b6I2KkjhpCL495NMGFEyi9YrvGTHVoHzug2kXR+MljOjn106g2N?=
 =?us-ascii?Q?EaZ97e/yYBCpv1Pt9EH/4iItX0sdyvOlMzpGXx3P3X0szCTjzopO0zIjb2i+?=
 =?us-ascii?Q?+vgvzQtL3XgzoN7VgbhwROsiQe9ClkU3C7qGUuL8amgtrpBzBEPHG3MhmiBJ?=
 =?us-ascii?Q?Nnn9+CN6iJRQ+b6MaxnfAIM+tU58jRQbwGv8uZmf+0D0+RrBV8kmxcNAWt2K?=
 =?us-ascii?Q?yl1agOHJ/xiehKP4bVr9oC7aatVmHgncEcr/uZxugFgGOu8RigMi3U05wSvo?=
 =?us-ascii?Q?iB8jXjHD5EihAimOePTBz45Inv7GQk8/eYUUoNg/GFDbcPozOf2sDOh4g030?=
 =?us-ascii?Q?iU8webLalSsOBlnGVBHYZ2E8pv4s4rEcvEilNIe4tLoFHUOUxn1uwbZtSOD3?=
 =?us-ascii?Q?C/us+QyCJLjvRCzYVVMWmRSv8cwI5m3m9OAXX+6JzWZilD3vc6ZqR6Nmn3eP?=
 =?us-ascii?Q?OJDvh3GFy5MtrAi0oq8cYOGXrH5JKoRj8DTC0PgIP9vlv0HoRJaR5OILfGME?=
 =?us-ascii?Q?qGRgxU3pAOsnzOuW4FjcKhiJHhCI/JEoS8Q4h+HcYMsHYJTgzH8RUPKH4GR6?=
 =?us-ascii?Q?9CSS6s5t6+p+2LWrC3nP/p+h9uXsi3t5Rikjum+qvz6rHD4m4VPiOPWEiwoQ?=
 =?us-ascii?Q?ph5H+6BcDe7MbzDRSQvaGMKvrjpn4VEDx/hq/ivCFmGHg8i2JrcLlm9sb/4N?=
 =?us-ascii?Q?csBnma7OWTvELIKGlP2UcLstsbObuzt8DUCDpTY40alpLeQ6MXy5590E+MaR?=
 =?us-ascii?Q?fjiXGwSDAdjDIlVTWDt1U/fWBN9FmjtwpO05vOo+g7igM7o3JUEzLSBV9PWM?=
 =?us-ascii?Q?XMpA1jIZVNKiyQmS4TuiYKPx/mN3aT0pKx5vRoLjPGIEjD3FNqkzG01hI9Ja?=
 =?us-ascii?Q?l0y/S5niPnVf4vDhGjBYy8wEanf15aBARCo/9Q8h+y0utn7liaJSWFtji2nE?=
 =?us-ascii?Q?W/PoQhlYh5aKbySUhYst8MOkdQGfAUdpttOPCqxN0m4SE7XOJkoqsAtDgS35?=
 =?us-ascii?Q?c7q/m89U+TjkOkwROEb5C+0dE6xJ2NAF3D7YshU3MqzK+6H/yzEFYcfW8WCr?=
 =?us-ascii?Q?94GMKugCq2Jit9AgSv/DnAtPgJZl1bYezWTbnSNi+r25/JwszIe2mCdg1FgR?=
 =?us-ascii?Q?hLjXWnONoLu6M4iBA1ySTHLg8UA1M1pLXaPos7t+CaRf3dj8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D8F063E322E95544AC5B75D05EE64799@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ea3dc3-c3e0-4bd8-3511-08d9ebf95992
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:24:03.1149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VLlP0UQ7WK4sC4nyk6h7wU4+GU12nKUb5q9Tb8dHToXs4VOseK/ZN1xluTnf5fJ/Z/y7pirnALIPFk62OmAGh3MN/QGN0tAjwyJgAoPxYbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1785
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-ORIG-GUID: UYwi7VsAc2QTCxwjZxn34uUD69s-rj49
X-Proofpoint-GUID: UYwi7VsAc2QTCxwjZxn34uUD69s-rj49
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/initio.c | 14 ++++++++------
> drivers/scsi/initio.h |  9 +++++++++
> 2 files changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 5f96ac47d7fd..f585d6e5fab9 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -2553,7 +2553,7 @@ static void initio_build_scb(struct initio_host * h=
ost, struct scsi_ctrl_blk * c
> 				  SENSE_SIZE, DMA_FROM_DEVICE);
> 	cblk->senseptr =3D (u32)dma_addr;
> 	cblk->senselen =3D SENSE_SIZE;
> -	cmnd->SCp.ptr =3D (char *)(unsigned long)dma_addr;
> +	initio_priv(cmnd)->sense_dma_addr =3D dma_addr;
> 	cblk->cdblen =3D cmnd->cmd_len;
>=20
> 	/* Clear the returned status */
> @@ -2577,7 +2577,7 @@ static void initio_build_scb(struct initio_host * h=
ost, struct scsi_ctrl_blk * c
> 					  sizeof(struct sg_entry) * TOTAL_SG_ENTRY,
> 					  DMA_BIDIRECTIONAL);
> 		cblk->bufptr =3D (u32)dma_addr;
> -		cmnd->SCp.dma_handle =3D dma_addr;
> +		initio_priv(cmnd)->sglist_dma_addr =3D dma_addr;
>=20
> 		cblk->sglen =3D nseg;
>=20
> @@ -2704,16 +2704,17 @@ static int i91u_biosparam(struct scsi_device *sde=
v, struct block_device *dev,
> static void i91u_unmap_scb(struct pci_dev *pci_dev, struct scsi_cmnd *cmn=
d)
> {
> 	/* auto sense buffer */
> -	if (cmnd->SCp.ptr) {
> +	if (initio_priv(cmnd)->sense_dma_addr) {
> 		dma_unmap_single(&pci_dev->dev,
> -				 (dma_addr_t)((unsigned long)cmnd->SCp.ptr),
> +				 initio_priv(cmnd)->sense_dma_addr,
> 				 SENSE_SIZE, DMA_FROM_DEVICE);
> -		cmnd->SCp.ptr =3D NULL;
> +		initio_priv(cmnd)->sense_dma_addr =3D 0;
> 	}
>=20
> 	/* request buffer */
> 	if (scsi_sg_count(cmnd)) {
> -		dma_unmap_single(&pci_dev->dev, cmnd->SCp.dma_handle,
> +		dma_unmap_single(&pci_dev->dev,
> +				 initio_priv(cmnd)->sglist_dma_addr,
> 				 sizeof(struct sg_entry) * TOTAL_SG_ENTRY,
> 				 DMA_BIDIRECTIONAL);
>=20
> @@ -2796,6 +2797,7 @@ static struct scsi_host_template initio_template =
=3D {
> 	.can_queue		=3D MAX_TARGETS * i91u_MAXQUEUE,
> 	.this_id		=3D 1,
> 	.sg_tablesize		=3D SG_ALL,
> +	.cmd_size		=3D sizeof(struct initio_cmd_priv),
> };
>=20
> static int initio_probe_one(struct pci_dev *pdev,
> diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
> index 9fd010cf1f8a..7c9741552654 100644
> --- a/drivers/scsi/initio.h
> +++ b/drivers/scsi/initio.h
> @@ -640,3 +640,12 @@ typedef struct _NVRAM {
> #define SCSI_RESET_HOST_RESET 0x200
> #define SCSI_RESET_ACTION   0xff
>=20
> +struct initio_cmd_priv {
> +	dma_addr_t sense_dma_addr;
> +	dma_addr_t sglist_dma_addr;
> +};
> +
> +static inline struct initio_cmd_priv *initio_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

