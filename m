Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA34C001DE
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjGKVrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjGKVrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB8D1735
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:11 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDCbP015529;
        Tue, 11 Jul 2023 21:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=fbUZGGzHLP/Gms+L5XHc/EadHFm53cAHpcjH7HxQ0f4=;
 b=QSFCrjD15k4W+hJnBRYdEJXeQX9Coz+lDyH/PWZJ9hV77FPQUc7iS7wH7CIKroevhlXX
 6XOlGJFGWRRJu4kQgTPjSP0Net4O61KW5bvk4e6nz8qGXvmPSKut3wgU7NWMKm0OzpK2
 E9zgvD8wTy8WG8x2mkHIAXH9pt623XwXft+962fQsGMd2sLffWOqFWTSbv0pZJ1r97Kj
 h5CN1zRSHe4Dl9s5ZVZcTdVnyFhVPM4vujSPVYHyDFi1ph/9++1Goej0WWY5MQzAr2uI
 fU3nj63C9RZB4s7ngDsvZaZ1rrPY0GZHayVek/vzF6MyHi2xR4NtcrBiXJr0QOi4pMZr Jg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2v0k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJwJW6000496;
        Tue, 11 Jul 2023 21:47:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd29shbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGlQhmYYKW2QDtox7uGOsjTn3m/ijV0gnz3OnV55+Wybc69pjmnjpfppcPLH9hCvUHfKjjkSgN4NK4ofTDObXv4VeqPbTRpUiHd3rz1d7Y2HWRluuoGjbUHBCfXU6WqOkVpdg4sRX3FfRU9tSlLxif7jV31uh8N9Wey6m+U+Sc8JKWMFZ0bQ/gEl+GfISKUaCTZHMeAzUXScgxP3Tp3+TB7QhlNY3UwEf1+w3Enb+h3WHYBHnTaletlIxXh7sn348pnfqSp2wPoBnYLs7xVqkAVfnP0+wNxkwhjpKP6EmZQfjQdHDF+fTBDWgjwG81baTRMeAD6bSwMqaBoq0SLOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbUZGGzHLP/Gms+L5XHc/EadHFm53cAHpcjH7HxQ0f4=;
 b=Ps2KR9a3nycLUzXNRBo2wk+lID8BBzYKgcHuZbP3XNhyXkneiZG1rest2aAACkrc0fUcj0+5TIug2cUpTN5e8+HtCd2NcfzIVFd57DeStgNKRFoZECSkokNypMZzR3laIt220p2W6ltsZZ9VaR3bZLTDe96dnomSu60NTI0b5zLckDVcUWVNZO/f3BJGxbVhZdFCjwG/dg0IE6qMrBTRgk1TG5GToL02JypJqoL0JHRwIcEuHhJKyT/2KnHJX80Kgip9R53EccKtUZ5j06+8smUVY2O/Us0bNWL8deuJ6sydibobPzf78WrGhycqLPiZijK7kVBkTmMTxAe6IZG9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbUZGGzHLP/Gms+L5XHc/EadHFm53cAHpcjH7HxQ0f4=;
 b=awWxhPsrw3fdFy9sgnO9aj+B4RXoA8ofx8a1PYH6MfULMDEUWQlTwamZHnIL26ebEGmqcCOOsB3dNTSOZMPiHEKkURaPFpeW37EZf/O8uistNXEcvJ6Q6841xv+TSwWIsPfY3mps2GnJWYHm9MaqZR3zoD+pixc+mGDkQLV7O/w=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:55 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 15/33] scsi: spi: Fix sshdr use
Date:   Tue, 11 Jul 2023 16:46:02 -0500
Message-Id: <20230711214620.87232-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0091.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 751c283e-c3d5-49e5-34cc-08db82585872
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8KynbZWwmZFFNtRFdgIonU72tWMhOm/DCltyMSfHkFRsZ+ZMGRCaoxAtySPQn3f6P4ZQQ3PC2bBnu7QVdpliVaoXIcEQdZfO0RaBRSOZP8OGd+vik7fxnaRuAYis/eg/rUviO0dCZhxu2mWdiluBqDO+skoSz/OXItfUUEM04AMzLCi+AVQMxgP6psQqFiWFekfFJBF1wb5eTEM3bjxCC4UviSzOAZ1fMf00r3AXCRs2JET1sOYMN5hiL88XUk+M5WyEK1eNhh1biC8sT31/Br4BRd3Y/nYrStdA6yhLnNdbtIO4Y8EI9D2qxNpis4Gv+TeqL7WwKGx2jzr7f7ELQFK2iSj0nA/58VfBh28ZlzSUNHz2QF5TyLd026HeLDHZ5JoBclfPblGwZUmSOXRYCvf28hkFUToepn2eydrrCXbNsBsBGfL2xxwbPWAbCCsoXmxkQj6NcEpyfy21AqjIN8AE1sH4wkZYXFArmuXZBXhKaFF5Wil82VInK5Hv8a/LuggpQFUqx820LSyWm5qCmqXc2OZgJIrSDFNpgkfpRvLAIA2wG5j8dtE20cV0Qvy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IFKAzdlK3xE/Sd8iwGpO7T9SQo2+d6BaNg8Nz4988qOSS1TrvSuzaMH0ckEI?=
 =?us-ascii?Q?FIPFxV7vZCeVatZuj/v3v8Fv9jww3PoAMaiELcgZVnL+mc6hscRFLASRPQYq?=
 =?us-ascii?Q?ZFMMOp+uQ8W6sRP93xyGVmPS/2mSi5KK7dWqOrzJVjKAmH2KzrPgGbl29N0V?=
 =?us-ascii?Q?/jXeI86r1v5NAvbXTPvXSkmFEH2BwuQB26PH4kUJGQGrjeF9SPBbico3Emmm?=
 =?us-ascii?Q?mNvZkRWI4xGdFxUH8mqp5GkcaH8p3ovYO6QCZqo23IU4p+o4tjmNt99kqIS4?=
 =?us-ascii?Q?F2GOO9CwKjW1skvMMaxSe2IdlyBc0Dpqj9MUxDIh9HJCRg9wdRPO01Nv8fCc?=
 =?us-ascii?Q?mbtTmXDtKNGBLpcedcM2OAq4TqEdVJ+RoWZVNeHx+hLymmpz01NA9XHbNCid?=
 =?us-ascii?Q?5Tr0JpjiAht5gidtguGsutpNsEbLehHHiLs1Ucjxs3EdiDBsyROev93uCMCS?=
 =?us-ascii?Q?buWdqj180OKsodlzG+D3UNEo3u0OF5GQs/TN0nuXNVZREwsYCTmWu0NP17QZ?=
 =?us-ascii?Q?vaT+45bpmjnHiRdKtayaTzwg4RLK5aaK6t6pwMNuyI38IcrnzD43qUWfjIyw?=
 =?us-ascii?Q?2O6ePDtNqb/4BkWB36SvbW9z8gpuapwvFOvyXzQ6f4rMMjMpz0Bh3MxOSrsb?=
 =?us-ascii?Q?dlwAqFBiZgrRUliGCecFUBbdW3ZGb3E74Aa2cjPz1IFcUh7KwuQRlG+F+mL1?=
 =?us-ascii?Q?QGye/RKciftM2er60ZMrtWPg6nN+HGHD8+XdRT52ypa90pqK1+wPNXGIbusm?=
 =?us-ascii?Q?CMhGjr8Z5svg2hWbFGt7usKeVgN1w/Je1Q7wSpXPUMaaOqK0Gq82LITMqCSr?=
 =?us-ascii?Q?bVuMZso1YW42R9otr84SyPhpeWnv4mmpzZkrUnk+cPyAY9nPCT7kZVHzbDOs?=
 =?us-ascii?Q?37+g5qu6pNAznwlUSNjWIym2vnn+o+nxP1MATBSiS9DzjbDvBdUyZoAGlbX/?=
 =?us-ascii?Q?7QocmY52Norx/He1grKtRNoJvq4y6eeOpfwp5ZpTZthVr+qX+fWbsD37XPnf?=
 =?us-ascii?Q?qcIiK29PS+sjjK8yl7rQYOlC4U0iNABW5xlomN8aVZ8CEfbJQpXbQ4bSp3/h?=
 =?us-ascii?Q?DQLfe7HPOV6CDy25PG1aaAXRMcrkv9oroOOTZTsJvrRxBDyWv0S4LaFTca7N?=
 =?us-ascii?Q?PQWsi2zEWU/QZxtnKXEtn5oEev9N/QLdbtxQpqhSSkDf0jHoXCeMqjHtXMfa?=
 =?us-ascii?Q?SzpLbf5iv9NZDv9gsQnOfyfCWh4GtIx8xGu6YNYrUL9w2HrEklWRD1dQzUvw?=
 =?us-ascii?Q?NjCrCEOkBplGU5EBQK3mmcAmzzMCtDMPzXsTjZ5+jrK9OeDJJvx+cVbQEU+4?=
 =?us-ascii?Q?Zz4EdpVcXHyT+1MjwXGU0sAxQRLKhEH6H8uet6OCgf8ASxB3i1SVOBOz+5l3?=
 =?us-ascii?Q?i1ZvOEZ1Vjh1Kea6EBFyvsTw7X1bkpRYPgulhMiS8l8B4wgu6bLORImQkZ5Z?=
 =?us-ascii?Q?bKsnsxcL1lPlCfyr+WP5xXpVacxXep1lJwP4KZrhP3bxFCXdFMU9hUIjXLHG?=
 =?us-ascii?Q?uT87KfJ4EnQwg2gi5OQumWNTsrkqS+OlRzpNuW6p+5vXs1vOEGyH7rUdAnYP?=
 =?us-ascii?Q?hy1jgHC+E4s9GfnT/UuyyJA2tyMI51SgCSBfTVfmrlw+ZuidO1jhnJHoi1Nx?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7VB9DEckiuylF8vaBSCrqthOtZoFOWP0HB0pXWI3AqYgsu89R15rz4D/NNUcEtycfuKzTbFBThuXZlvTatwGjYJIeOSSV8YebjRvdrrsKVxRIXq82qlWs0YdFppdAJKjvY3gvP+1Aw2m0iP10MJ8Xlgmuf6dm5m06XHo2GAtsxj13/fjDsmx9b3K1DRmeHuzyScycO9g5A3Y3GnhSxW4uJqCqEqkOHpd/eTc/P8utPnJhS2OQslUnmEhcZm/R9sWFPCin/uCfBDaId+QB/rTOd/w6DL74zZ3a5E+jhpj7lpLesxug9KFWop4LMjbu2hzQZramuQnNjhzHclTaT+KVh0TQZP1wrZsb37LfRAXqS6OTXXCexDzWSO5/TCpFcuQQVmodp7qVdlUjJDpIeAuyPMaQobH9YB2FUmQ0XUVmXQMgGW/Ujh0BkQItCb5c5LxW5KYRvkrHPL0E/JIVEdbH+J7BBzfSEswm7+rYt6/KxwbcTBOxQmlV4ZGvfsYTcTboHiU/ZkteKbAnh6wcuS3hZjetXhtDc8OzeJuudto0ob7nnUW3tDPtC+pwQ96+OgtJf1dZvdSKNmZWnsLpjig/8KFPwYUkD46sCThrTZdty4XBsVmd4C7qhWLaff7fGfL/fA56xDMKlWGnPwgIzX+bQNObak3qaPc6NC4TYXRppIEp9fdrxEWOC9QRwWJUsF+VjAXrxZd7qTjkXyT2GWR7XjsGXPfnk5vQZ3dwYSUE9b3yf6Qgu+kB2rmeCYLoM6TAy7e4KYRaQsRLi9QjiArfp63lZA7NVzRMRN9tdmBFE+doi3qzxAqHRV0AzoLLbHsJF3ElKVcS4JhfscZ6POiml9ssNlhJo1umiZWFptPRIzmMFyB4YegbWu1F67tIj3V
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751c283e-c3d5-49e5-34cc-08db82585872
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:55.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5hmgcOzD6Dun1ce4J+54VsG5ihyDKsSCw07AgdE9OcbudUtjtIdiUMJ/WyaiJGrvmZirv6XOgRHF8plMPc/AhZhHfHqncfFGaIC9wzl6ng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: e_mOQD7SUBcsZurUaetu6XO23fA834Kq
X-Proofpoint-ORIG-GUID: e_mOQD7SUBcsZurUaetu6XO23fA834Kq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2442d4d2e3f3..f668c1c0a98f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -676,10 +676,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
-		if(result || !scsi_device_online(sdev)) {
+		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_sense_valid(&sshdr)
+			if (result > 0 && scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
-- 
2.34.1

