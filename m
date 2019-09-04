Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D941C3A59E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 23:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10DC220825
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 23:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbfIDXxi convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 19:53:38 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:31416 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727125AbfIDXxi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 19:53:38 -0400
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x84NpWm7020556;
        Wed, 4 Sep 2019 23:53:33 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0b-002e3701.pphosted.com with ESMTP id 2uth06jks1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 23:53:33 +0000
Received: from G1W8108.americas.hpqcorp.net (g1w8108.austin.hp.com [16.193.72.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3426.houston.hpe.com (Postfix) with ESMTPS id 9E45F60;
        Wed,  4 Sep 2019 23:53:32 +0000 (UTC)
Received: from G4W9120.americas.hpqcorp.net (2002:10d2:150f::10d2:150f) by
 G1W8108.americas.hpqcorp.net (2002:10c1:483c::10c1:483c) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Wed, 4 Sep 2019 23:53:32 +0000
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (15.241.52.13) by
 G4W9120.americas.hpqcorp.net (16.210.21.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Wed, 4 Sep 2019 23:53:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bl8GKSnAXH4fVbTuAJxKHFE60rPenxrrMF5P8Q826PKodNSk0E/B1wv8H6Cmru6kGl+mTRC4OHcv3x40H3Zw3QJJiRwuA1WH+jQiQrfMdoQb3+R2UMtuU9W0LQq/4rNTOfTDW9GFON59uTdmUy2DMQqeqHO2MZPruKSEp2J/bKjXCb+F+KYwkI5GpbQrwm5PYfwQyE5jIhjx3kLaH1eLwSJc3pXML0sCprQRf4YyHbehwwnRuyZfQzdQu2BVFObKGlwNXXPCCq57Bms5r3jpPCo3poQAIKkI81nY6twxUI4++mU+ahKPo62zQ8NyVdrWkLLZY88WpKyh7Sjan/1MvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t171dIFp4ZqSENZRNx281iCa2S/0WbsbLI4jkC4MkE=;
 b=clBxLnJSR1w3dVQ3jBXOYeCou888X413iHsd991PHBVakIU4Up2LhF/QHy/AfnWuxI4lFwTp4AC3Uwuhqk+1tmrBB7MjFzWlb8yLIoxbZY45Vg2UqMYApuL+ArjBqxxy7DA1+Z0laJ+4xjF77SJGWiY+NfNtprSImW4KAd6Jr35h3LM3AeVijqH6qUKCkxIp8E6Z2AdrmNz3KsKpESClE27gGjc/qdGHLYb7FppRe1XPHgiEEW08YXfH2AF25GdUyeA20qLtPmfVdPTFAGeIIVmxXr4YkKt1Yq41l1nNgKoMEd1Q7++EUWyLIozZcML48qI4WHCKd4eoaGPEoFfD4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM (10.169.47.145) by
 TU4PR8401MB1005.NAMPRD84.PROD.OUTLOOK.COM (10.169.47.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 23:53:30 +0000
Received: from TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::78cc:1150:78ab:83c4]) by TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::78cc:1150:78ab:83c4%10]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 23:53:30 +0000
From:   "Seymour, Shane M" <shane.seymour@hpe.com>
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Ales Novak <alnovak@suse.cz>
Subject: RE: [PATCH] scsi: scsi_dh_rdac: zero cdb in send_mode_select()
Thread-Topic: [PATCH] scsi: scsi_dh_rdac: zero cdb in send_mode_select()
Thread-Index: AQHVYzjBAITGKtoVOE2kn4wGusRszqccMUuQ
Date:   Wed, 4 Sep 2019 23:53:30 +0000
Message-ID: <TU4PR8401MB09273C3400C27141FA607862FDB80@TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190904155205.1666-1-martin.wilck@suse.com>
In-Reply-To: <20190904155205.1666-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [180.150.37.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f978d9e-cb6c-4d7b-b1c7-08d7319316bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:TU4PR8401MB1005;
x-ms-traffictypediagnostic: TU4PR8401MB1005:
x-microsoft-antispam-prvs: <TU4PR8401MB100582B2079B94FB8F2F648AFDB80@TU4PR8401MB1005.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:335;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(136003)(376002)(346002)(199004)(13464003)(189003)(76176011)(71200400001)(14454004)(110136005)(5660300002)(54906003)(66946007)(478600001)(64756008)(66556008)(71190400001)(8676002)(33656002)(81166006)(7696005)(4326008)(186003)(2906002)(81156014)(55016002)(8936002)(99286004)(52536014)(102836004)(6506007)(316002)(26005)(53546011)(14444005)(3846002)(6116002)(25786009)(86362001)(256004)(53936002)(6246003)(66066001)(6436002)(486006)(9686003)(7736002)(66476007)(446003)(74316002)(305945005)(476003)(66446008)(11346002)(76116006)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB1005;H:TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9msDa2IqrjDk1+8eT/HMfrgBv2oVjwve5StehnS++/YxBlLFtBcVj/lW2GqHTBjCLvMuAoeJ9Swo8H8B+ciBuserB4BdokkoN3UD7DF2hmTSjn96ryZbCeujKH+voOftJR3TfbI6OH7IDWEVSyV6+pup3XDzp9IZ5QBk4L3Lq4STZkaP5suKmFGEyNdSfcuwb29hQERudYjkUg9TuUcFEOZFrxjuX+AXlhHuwj23raFcbCSCkPsmFQWQoMnmzNU6zEEzUsa4IKQw0w9NSZqdgvENCKFpdkuKfIeemUKJ1RYY9Bm13fZa0hc6ocE4gxOa0+l2pOQ9knEluPPVNy/7E6Ie+v0cG7+zrOfgHrmGBUwQLKPkVPJ3JgpuAgO2jH8Dspi07i6onsSDC93k2FKcRY7G3XDU5B58vXkweVlJ/n0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f978d9e-cb6c-4d7b-b1c7-08d7319316bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 23:53:30.7037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a4h8YSoYWwwIDbQea8GiiSawwSx2XFmpHSChr7P84CzO+YnqJqe3zFaAgl1NLBJfilJK3DO8oTv6NSAr6y/RzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1005
X-OriginatorOrg: hpe.com
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_06:2019-09-04,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1011 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909040233
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin Wilck
> Sent: Thursday, 5 September 2019 1:52 AM
> To: Martin K. Petersen <martin.petersen@oracle.com>; James Bottomley
> <jejb@linux.vnet.ibm.com>; Hannes Reinecke <hare@suse.de>
> Cc: linux-scsi@vger.kernel.org; Martin Wilck <Martin.Wilck@suse.com>; Ales
> Novak <alnovak@suse.cz>
> Subject: [PATCH] scsi: scsi_dh_rdac: zero cdb in send_mode_select()
> 
> From: Ales Novak <alnovak@suse.cz>
> 
> cdb in send_mode_select() is not zeroed and is only partially filled in
> rdac_failover_get(), which leads to some random data getting to the
> device. Users have reported storage responding to such commands with
> INVALID FIELD IN CDB. Code before commit 327825574132 was not affected,
> as it called blk_rq_set_block_pc().
> 
> Fix this by zeroing out the cdb first.
> 
> Identified & fix proposed by HPE.
> 
> Fixes: 327825574132 ("scsi_dh_rdac: switch to scsi_execute_req_flags()")
> Acked-by: Ales Novak <alnovak@suse.cz>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/device_handler/scsi_dh_rdac.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c
> b/drivers/scsi/device_handler/scsi_dh_rdac.c
> index 65f1fe3..5efc959 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -546,6 +546,8 @@ static void send_mode_select(struct work_struct
> *work)
>  	spin_unlock(&ctlr->ms_lock);
> 
>   retry:
> +	memset(cdb, 0, sizeof(cdb));
> +
>  	data_size = rdac_failover_get(ctlr, &list, cdb);
> 
>  	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> --
> 2.23.0

