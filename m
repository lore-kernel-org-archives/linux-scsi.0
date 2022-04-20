Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F890C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 14:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379737AbiDTOpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 10:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379531AbiDTOpL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 10:45:11 -0400
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D219C28E2F
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 07:42:21 -0700 (PDT)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay.digdes.com
 (172.16.96.24) with Microsoft SMTP Server (TLS) id 14.3.498.0; Wed, 20 Apr
 2022 17:42:18 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Wed, 20 Apr 2022 17:42:18 +0300
Received: from smtp.digdes.com (172.16.96.24) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Wed, 20 Apr 2022 17:42:18 +0300
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (104.47.6.56) by
 relay.digdes.com (172.16.96.24) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Wed, 20 Apr 2022 17:42:18 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTS9RQXuTAnIssfxkWM2O61YoYyk5Z7UWA2u0lEz23T/x5MsOjfvJ438gikojMiVSGgtu+sG8aDQg1uVsuJvEgeMbzK0obnHRed2NyMPzgKhTJG0VoPiewvQN+w3YGrbIN1AJfHvjBfO8izvGAZgaSGPJJmoqciHG4pfAtPyJPdy6xqUoHqJHoazpdeXd/Zrr9haOeMh4IlNz4o7EOieiNF+jCpXe3kJgU6DhNdvlznnYitYBnf1g9x0seT4Y859igPjLK5moxLo1mRGjl/vlicftNa3Ui3EIiNeqwxkRQ9cS2h+Mo7EFtHV8eQnn74TDiyPjhAVkxMNOgbIbYvjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWZWKGOjY2MFOMY6M7ydajkpbr/0jXNpW8MTesO1k3A=;
 b=BXJM7HEXvHgUkB/rMc93jC/tne9Kc7MpquQokfdU/w+CGkrNifqtXPmg+fFnLrGFLRC/yHl6r6Cp6USLWdw2fs5VK4m0G9RcZGPxtYr1xHHTPxAtHtc3D5gfqzR60aWg8ZMXmZqmZl5A0ETCvdRolAWpbwrWN/eYg+KIAVBYlWIm6MA8egQAm7DfxWUCBb7i3uEBbhpzK+C9/A6FfAt9ipPpjyN12FwVj9i4WSLwBoTdb5q0hxsou6pqvqZbMTSRSOL69PEWEgABEuTyVDTfwN5yS32aU4ZGi8z2AbxZejH857iQEtc/k7OO0UGarS/6qvLqS90oPx0bwTX/fZ57sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWZWKGOjY2MFOMY6M7ydajkpbr/0jXNpW8MTesO1k3A=;
 b=YdvtOlbsYC1DvjzBIwuz7R2QkqI9wo3TLTlrgST2TK4fkZo2UR3zTZQBKGxshjvLWS4nalLF79aljHjBKlv7doCs5S+oaPWHnTWRY3TiZWd7vSwaY7XJdZnr6kM4MIjbjyAnrGaDi9KHqEMjyRD+nbwxC4dTxVL4fvwTiebiGzk=
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:403::6)
 by DBAPR10MB4107.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:1b7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 14:42:17 +0000
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::74ca:aa66:a112:d987]) by AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::74ca:aa66:a112:d987%3]) with mapi id 15.20.5164.026; Wed, 20 Apr 2022
 14:42:17 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Topic: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Index: AQHYUMYtkLBbKidY90SJACyXGZHZ2Kz3qV6AgAE75Lg=
Date:   Wed, 20 Apr 2022 14:42:16 +0000
Message-ID: <AS8PR10MB4952FA41BCC382A6464D842A9DF59@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
References: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
 <4FA3632A-690C-470F-8DEF-663F9AC0CFC8@oracle.com>
In-Reply-To: <4FA3632A-690C-470F-8DEF-663F9AC0CFC8@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 70efd7d0-3340-afe1-f77d-2d6f45c0e939
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b66aed6-c0cf-42c6-eba5-08da22dbf774
x-ms-traffictypediagnostic: DBAPR10MB4107:EE_
x-microsoft-antispam-prvs: <DBAPR10MB41075630AD18799A23F350B19DF59@DBAPR10MB4107.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ecwjcDOBEzQpNjgWEQFwypYESoa1boWNbblytwgBT6o0tBtayN9eN0Ll5E2+iak3g7JnwQQEgIjiVNXZNmorz81o4G5NN9zomb2z7/2N8npnvJtmdYTrtxtMogEllbOfKE1W0OZIrK6/qArUzgVjaIjFxRC4AFx2j1So7DhE8Zl817fwZEE3LwzUN44zO8t150fJ3WdFX4QXqUaOnKe6cCeQI3kOmyGfmpVQUv3CUzGSgvS8OxC0By9yHihWCisQ5QOfbQ8w3WacGfnRYFje4Sims5X2tSz08sx4TuPSDA89thXlmo6vCXd4dHjYfkKDV2lI7wOT+Vc9HnnqXcoKakj0dnPeKlsQTUCY/4iISHtFMrVRsqsIMpu1tLUm5mTFSBiAYMkkmt90EQzMuuoJJvI6CHy8t6M3ViAZGie3KqUtQDC6yf3dbuDS83bT7x8iljdcVdCxsN5AE5Ld+skAcd0E/MNd5z9L3WJ+l2sblX9kLujyJf7IkzRzZ48LZRXE5qdjurtXGiTMTVj8NWBw1LcGKo8kmLh/ZDWwoahcpOnrX5ogUOHNdfmoFl1QyYwWYIPS1YUuuwYoYDAE9JH00KVt93EsTWalFeToPtYtsbnFRK2ypM422zGLwfuMnL5lfXz/Fti4FJ/wSnsEF/0+SyIYhKXDa1mCrS9VRPyCpSeETMqnaLwJsyqfvlPZ+Vkz/UhvZr5C7siqD9+mwEGOaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(26005)(6916009)(9686003)(55016003)(7696005)(66446008)(33656002)(8676002)(64756008)(76116006)(38070700005)(8936002)(52536014)(38100700002)(86362001)(66556008)(91956017)(66476007)(6506007)(5660300002)(4326008)(83380400001)(71200400001)(508600001)(316002)(2906002)(66946007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?xXIRf7h3fdWwSIGJNYzJnZYAac1jMDWlh/LCoarLYNVgzVerXb9ftOsYoQ?=
 =?iso-8859-1?Q?SJ/aC06/GoQYcdbi40hNVSaDq6G3FDxx/ONXI0G9fSYNri74I6NSScuf87?=
 =?iso-8859-1?Q?/YQCPTYZAjhjvGzaoaTBgRkadUpsLZSNGkrjCdXSifFPUaZxcEk2i/uYMr?=
 =?iso-8859-1?Q?X2AqNnfbFttMvTY4XMEtw5zK7MwzyEAXLqfCh8ixVXizF2EJ+GFRzacOoh?=
 =?iso-8859-1?Q?Ek21kZGxK89VNuz1LkpuBy4Chsxw8vZh4ZDrqt76Vm4zuy00vADYCFHo2/?=
 =?iso-8859-1?Q?53CcFrVYjFLnIEV091fKDfEG5xCUsUtdE9ICdQpFlMvg9jGT2SV/pQtCY8?=
 =?iso-8859-1?Q?qmlup7EHPV8/g4GPo8JSTS8ICDJc3rZ14KseBWFy3bw8BlfPkjfsmRvzPj?=
 =?iso-8859-1?Q?ahrt4BCYzUxWmyparmaMP2iCejrKvUcAESaQNXfguzyOwxcB0S4hy+FQ7q?=
 =?iso-8859-1?Q?Aj0YlTZjX32/XigPmEMric2D2jlIRCMpK64QlEEzB5XNrZT+nzyobKcJiH?=
 =?iso-8859-1?Q?7t5x6LLpFLsKvMpt++KIm2b9w0vOt4ZThyv1/MIAYkHWhuBERm23ph5UXD?=
 =?iso-8859-1?Q?dnPQKfGnSAW6Mmt+XkW6EldI4wYGnCGcOcC7D1uXeDLTelLKtDYIWkBXMS?=
 =?iso-8859-1?Q?TgLnvwaWwq1pl8Yf8sAC15rpQx9S0UoIfpCcMHvvosucesIj24NSfof//q?=
 =?iso-8859-1?Q?yVMcRyr+14Y2habxdIOqC1OS7Csg0w6IKWWGda8dPRnP4QwkuT8XI3hjCv?=
 =?iso-8859-1?Q?CNGcHNuv0D9QFKIn8Jkn67cggxuBdX7EugALy62Iw9rI5QdDc934pm0tGj?=
 =?iso-8859-1?Q?l6w5pE0Y6gRhm7RItCT4OPIOGKRTVLn2T2r4KDRhvFFLjbmekyO3CjnffR?=
 =?iso-8859-1?Q?tzlLJvSMq8TbGIVxso36MKq2DnopqGnfJqA0Z7scED+Y4p6EXr3bDIus59?=
 =?iso-8859-1?Q?It9zSqPO+ZltdEch8JiydoFZg9czZLy4LcCBtFnFgSK5D/oHIWOn+UpL0w?=
 =?iso-8859-1?Q?lmKWPlc4YCPdAAqDEju+hzz5Fl/Vav3ItfsecN3IZ66Mofl7RQF/GDTQC6?=
 =?iso-8859-1?Q?vkKjzNhF2xfJA8iFu+QZaqJewLYXPGHoFseRGinqplzz2qJpp3OaPa78R2?=
 =?iso-8859-1?Q?BHrmwH+ufs5ahjY71RYo8h8NSDNiBpYFMgM42/oHV9BehRIh6WeBKI5bo2?=
 =?iso-8859-1?Q?jLHftsB86zz4DytW3ybmwtbf9sVTqIpRNHl41qZhu+wNW8L5T6uo/B18CD?=
 =?iso-8859-1?Q?XIsLDfDNCWx83H+ATVeBKkqnBAt9HWLP4Bv3MPqLi3yJno5tCD022Revmt?=
 =?iso-8859-1?Q?VsmgpjKr1Qk6cGZUPHL7Iolc9SpQnQHic/Y6TiwZlr3d5V+cMk2kyFsu3H?=
 =?iso-8859-1?Q?+Hcj9+BqnJQKoYwonp2mW2xAhGX1998OQH2JHEctRuzcOsWHDqHJzNNhvD?=
 =?iso-8859-1?Q?HuBd6tlX9Cr9peHoV8+VWhVcZDrtC6sKDAaEAbD8tcK7OmjoT0Mj7DvQg1?=
 =?iso-8859-1?Q?Ch0bJMAKKxxPclsvlCk3yiJ4JLNEc/PgZXWepxa0cWhrifVpGFWy6qsTOq?=
 =?iso-8859-1?Q?QI30YV5FOTs1CpP2f8UhoCoPqPTrvJB9ibIji2YaMCMGkySGk++Ggh4UVG?=
 =?iso-8859-1?Q?7WPCSF6WgxI6t7p9kO+zzcqvFH3vt1ixBzTyrHt926sLeDyYfcMmTaARoG?=
 =?iso-8859-1?Q?nJP4+B8GbsstNhcY/KWaeuq5x06SMJEY0K7bgWFa90w3HdhLoWlmIs+N4M?=
 =?iso-8859-1?Q?xmYyyd+FUjDce49gwCpKnYeSHmHwcDtCVk10hqFTemIeOPtQ7uPgxSzx8M?=
 =?iso-8859-1?Q?lqi3tpT22w=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b66aed6-c0cf-42c6-eba5-08da22dbf774
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 14:42:16.9288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j7UL1h6yojBzrmxxJ/EB8Z+Qs4/x8rIqNgPQNapCuvHTuO5Se5mjnlJr667IFT3ohWU/MZEuuIShIn5nrVlVtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR10MB4107
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Do you have a log showing this error sequence?=0A=
=0A=
Yes, I have, but the problem is that I have a different target stack, not L=
IO. So the Call Trace basically contains code sequence from this target sta=
ck only,=0A=
except for the call of the qlt_free_cmd() that trigger BUG: BUG_ON(cmd->sg_=
mapped).=0A=
Regardless, I think the problem lies on the qlogic driver side, because it =
is responsible for management to map/unmap sgl list.=0A=
=0A=
> Can you share more details?=0A=
=0A=
What I am observing:=0A=
=0A=
1) Command processing calls qlt_rdy_to_xfer(), maps sgl and sends a command=
 to the firmware=0A=
2) Qlogic adapter reset occurs=0A=
=0A=
qla2xxx [0000:82:00.1]-5003:13: ISP System Error - mbx1=3D110eh mbx2=3D10h =
mbx3=3Ddh mbx4=3D0h mbx5=3D8a1h mbx6=3D0h mbx7=3D0h.=0A=
qla2xxx [0000:82:00.1]-d01e:13: -> fwdump no buffer=0A=
qla2xxx [0000:82:00.1]-00af:13: Performing ISP error recovery - ha=3Dffff9d=
d7d6058000.=0A=
=0A=
3) Somehow the command is being aborted, so that means the command's abort =
flag has already been set.=0A=
I think it may happens something like this:=0A=
qla2x00_abort_isp_cleanup() --> qla2x00_abort_all_cmds()=0A=
=0A=
4) The target stack calls qlt_abort_cmd(), and since aborted flag has alrea=
dy been set, this call ended as multiple abort.=0A=
=0A=
5) The target stack calls xmit_response, and since command has already been=
 aborted, this call starts the code sequence to release the command that en=
ded with qlt_free_cmd()=0A=
=0A=
I think I could try to reproduce the problem with LIO target stack, but I h=
ave special case with my target stack that lead to reset of qlogic adapter =
(ISP error recovery) and this is one important part of the error sequence. =
So, I think I will not be able to reproduce the problem with the LIO until =
I find out how to similarly reset qlogic adapter during processing active c=
ommands that have already been sent to the firmware.=
