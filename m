Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D331EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiACAlZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:41:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7356 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230516AbiACAlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:41:24 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20298FCD005922;
        Mon, 3 Jan 2022 00:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1VehZnXXEI59ArhfwhYK2AdI4MNy2mi0dMHyokNQN3I=;
 b=r/knGDaSLJIZHkMPT6fEj+iuVNtU5GoHVh921EHUx6gAAalfXy4m6zanToO4EHfY+U1N
 qKTaSaQhFWrOSRvL8n3YGz/MitSjX+3A1hk58ntVgYtFQRR6/A1hsD8EzGxQDXjuK3K+
 GkqE+C/uK4kwr6tmGKZ5s9+8wtotjWQb281HabRVe8XD2sHugzES89fO+2fmiSM3/SdG
 7JdEsyVTxU6YsqfxceVt9bBsoptmnr/btAAgS2aoTlQ1OD0K1kUYJ3WUxmiVZq1cqFSe
 XZl6Z2CTNbPUKl/my8V/wkjCp5q8xYlc0rHSNJOqeRVJPzOo8/493NqQD8r+L85cMXdM gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dadcd1qsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:41:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030f7dv172217;
        Mon, 3 Jan 2022 00:41:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by userp3020.oracle.com with ESMTP id 3dagdjuhky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:41:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9j5C96tdA6x0yBFKoiHCkP6CjV46y1opJYjpFKpucWB5NOs1yEPQn83WNcyhuBuwLrR8tu94P5sd8105o3RmMDfdQ+/cSV5RVAWPe5AOFAK5XD4DpWBO0iZwI1cRTKap5I8NJWOWWBJVoIXbhtpEuJ3oSYqxEYBgKpA2EzvCVPmhNSjGgpzEFcysLGe9TVFdNv3Ow3ieIm1jqR/SxLzc9CdrSrqvw4iBaDSHYf8YUZbKLUGWIyuIXpuSIo7Z10VAdW27Y7X+yrshKBRvUBWivQuCtJXjeNE6kbQMTTM2ZHK+8gBQd9qed7a7xB8PNOAk7KAYbD+XF07oKOiwsJjzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VehZnXXEI59ArhfwhYK2AdI4MNy2mi0dMHyokNQN3I=;
 b=bKagAgnpHz0hIv4N5yfollcg3GkEFYfnCKViJaBV2ZkPqMTXdBWlRqFLeXAuZpd0esRpw8ABC+gd/lOkgL8C1NhZCAkXag0p9aEzpcbo9rT8ej9NJbTiqDCj2yqxt4ySWvA4P5xTio5ln8iH5uLOV4BRCsFPiJFljm/OyNuegJG+f9TBZGBfUEBgC6SRzYyHeyqNHBsxAZUr8UhoROj12Ty+70khXEJy6SfPA/LZ35UjGXbe9FbtSxbydChVrBw2F5nK/BzX08QQqICvh937/d+h+SRNhvEHKjlbBtu5pm8fArly25fFyjpuBqvB2pR5lUTuYob0jWeN8Yz1PqEwWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VehZnXXEI59ArhfwhYK2AdI4MNy2mi0dMHyokNQN3I=;
 b=zM9IRcuKbFPEdEleiJSte2/IlsR2vgLGkJalBARvLRsi+9qV2zjdgEcAejpvZ4a8l5dNW7lN7iCr6OPwhWCnHzyhYOqmVNuFgsEjO8EIyPmiL1w+3VvSShtKiJkm1Gdi7vs8xdExRu+GdRSZq44c3dEYrEfCyEuBizbswiQK6vY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Mon, 3 Jan
 2022 00:41:18 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:41:18 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 06/16] qla2xxx: Fix scheduling while atomic
Thread-Topic: [PATCH 06/16] qla2xxx: Fix scheduling while atomic
Thread-Index: AQHX+JUCRf2ImA4OMkeJcmdasBjdrKxQhBMA
Date:   Mon, 3 Jan 2022 00:41:18 +0000
Message-ID: <316EC96E-5CEA-4D0E-8F26-3B190E618CE6@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-7-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 787294d5-ba41-49e2-d9e9-08d9ce51c198
x-ms-traffictypediagnostic: SA2PR10MB4537:EE_
x-microsoft-antispam-prvs: <SA2PR10MB4537710246CF9BE244DDBC46E6499@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GUqFkg3R4RyUKuIbb4+Qw2+XXDbtlDqtU0RhIWGJtm6pm8kPYczAfaXS1PFljH8eQhrxZ05ZrRXwEpGO6YSNYfYBpzy+XXRJrju0078uZ+3KL88dVBdI+ECpDRc32eTif0VNuhpmGh8K87yfnlrRm8KgE31PhVygDG/1onwNf44a3p6Ua1c0RDhxemBh6zBiQzmpSz/rKnHcU4bWO+nv0nZVeRa7WBVzz8MdY/t3m47pcqxe+tNy9KqL6IUxsxKUi2AETXkgE9WvcsgBfN6n26D3EYSGp14xqoJpj+vl9SGWOUGkwP+UiPBDX/ROYZYMxYOw3MQvMOeu60f4I+FzczWddEoSM1zqPTuxGIN3kWoD9NxJ1gZ5E9Yljyv+YU90r7pRidEaC39doWt9edFa0pjWgRkPJrZbx2oZdwCzHjyrhSfu9Ehh1jketOKhj4pBBE5cYmzQ3NblCCfaDe9xVGFIbV07EfHdTcJrOUoBpULwXnhwhhFiNPOllSxSTYbwM8Gs9RuLCo0tO9jnoEDC/WKGSXvxWyqeq93RmxjP6Pk269mLPxPtjfd5cohpHYYl2AtPJtysv9ESJMAfPWeo1oC4060oHuByxG7DFpM9P/NfVflLuMWLJ++hRYPzD5wzHKhbqUWD2dX+eXKiazsJcn/xeSFBN1riMEUo/g8cQMu2nJKd7uFjz4bgBsiL3KOZQlw4tN2Qh2T5y9CJEGrgdhd22lGLstJh9bkAZiMZ21U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(91956017)(8936002)(6916009)(66946007)(2906002)(76116006)(6486002)(86362001)(36756003)(83380400001)(26005)(508600001)(316002)(33656002)(4326008)(71200400001)(38100700002)(186003)(122000001)(54906003)(8676002)(44832011)(6506007)(2616005)(6512007)(53546011)(5660300002)(64756008)(66446008)(66556008)(66476007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mRplcx7FKY1CYUHXozrELvSLHrVIuAAZ835Bz+wdd35TAYkZZRBq5+Oqj2ow?=
 =?us-ascii?Q?r51qOXO1ifwOsoGYjuenQULlrWCzjVBsqGakyyNA+rP4IHVdkkKpUXIF7AwF?=
 =?us-ascii?Q?bUsKX0+ZVSaRxd+ki32PxLmBwcOHKt0NZIbHP6jMDVxLUDsgTPZeZ7vtlHEI?=
 =?us-ascii?Q?vY4grgdZjT1Ugy51tQOwCPBiUBnENzuTwAFhRbMDF29NB6WTZX0ZhoZufdei?=
 =?us-ascii?Q?0ab4RGn4XMOk+IJpFV7s0PMqlEtlvh1gvH1uLlFu7C2/XF0REFI+LnJ8lmHX?=
 =?us-ascii?Q?ul9V1MLLYy4Ts0z/DXRJaopkwwXXmBW9LV6HslDrXGlLfQkmehdZi4ScWE5C?=
 =?us-ascii?Q?yXpxGxvnIZrBFuS41GTzGdrVCvIpDKTQgxjc4DnaRb38N4y1Gnpb438cfCLd?=
 =?us-ascii?Q?qVjbYJ5mR/8paptpz5MQ92B/voWA8vZoEtPm455wYYRxyHK6WF5cpuE+Xe38?=
 =?us-ascii?Q?BlJ1rlBkYlqqQNZk7r+XMjJx5rTPNQk8iheIJFLWwKOoynNfUU5dUtfTEfoc?=
 =?us-ascii?Q?guF8x/7nhptEpypQ08SBCgsW6umScuUhBAcOa9zwQ5aqEzzo9fmuAMw1jUIi?=
 =?us-ascii?Q?bfaxqpSb/FARiINREcENbMYZvZKVJyb+hakDsKHBvKbwC5jKy9Ww5mwsuTt0?=
 =?us-ascii?Q?UQhRB1Yy4dF3YNLVDDcCiOxIzh2ogsAMBXwtOsigbjrQulP3lqDQ4zIvgfTl?=
 =?us-ascii?Q?YAEod6vGdbmgcaRYMR8OYxRq28K8E1qvc91J4k95iFjVYhhA9XYl3xOkgWSq?=
 =?us-ascii?Q?nS5g31YP/LcFqgDRNq8RvK2xO6Ws1d4dbNfH+k/o//hIgY7RN174oJULQv2t?=
 =?us-ascii?Q?dmMuLydwgcefl+y+OdYISxPO2dr9pFJ5HmFfiGk4xLcpXFXazNyWbuN/tiCL?=
 =?us-ascii?Q?Hxvx/v3M08TD+h2cIVZD5DfXcgRw2Qv1uiXjHcHq4ww936MTK5w2zwuiTxqf?=
 =?us-ascii?Q?FLeuZFYBj5ns7BGbwEV9dOLPkEO/ZScHuWNoY9JdQ/vbwD7yaTU3lbLKBz7X?=
 =?us-ascii?Q?qH3Nlne4pziQPY3VCyLufABJTESz2Go1fm+QI8Wg/zdvhLbS4UfbN9mIU9l2?=
 =?us-ascii?Q?2xWtiTDcli41wSi+d2gF6ZPn0ibLbvu34sL166XrbIvatDVb9pc5KOKWJreP?=
 =?us-ascii?Q?gAMTy/HX32S34kQ7UsKX7RBHAXY7UYUQQZYx6LJ320N5HyZBMHLxnfrvgIGI?=
 =?us-ascii?Q?m2qCHiDMSl/tcI1metB8zwRMGuwxmcqiY1US5jC+mXnBGmL5dLYvArScWKE6?=
 =?us-ascii?Q?6u5I4TNcre6w1czjUq90me1f1XF0taiVb6Wu5RjpvRRfbdeYEbsBjSiEsTgC?=
 =?us-ascii?Q?smLrKZB26rEUKpUXtWGjI4ntIoLNo47RjsK/L+NP6Yq27WaYg+PWQMIWlTQ8?=
 =?us-ascii?Q?g0MixyXbOiFXOU/5PEcl7KiATEjZ2GLojucouWX9LyzI5RgE48EMbnd+kL2O?=
 =?us-ascii?Q?znA2xlKcQTIuS3KhJ9EXtctrZljE56yfuwOL3A+Pl0rki0ISlXq/FfKaLh/A?=
 =?us-ascii?Q?fkx2Ah+k+MbdGLc8BbforulI5wfUyrx1DBn1BhstRcfonWRzZ8SKhf6iWeVQ?=
 =?us-ascii?Q?7Ufefk5rplvVTGIXc3cheGs6RWt7siB7iAmNxKk2rtMLpUR7V2fvGvn79WsL?=
 =?us-ascii?Q?ksqMTiNPW93yB37jUaG6ndS9woBMNx5RG/Qk5Vr6W6QUyPzL9INT6XCpLFgW?=
 =?us-ascii?Q?dL5Kz5J4EtqgFzqo0IHdEhTpebA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5970968CA5A91248BA9AB149B654FBD3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 787294d5-ba41-49e2-d9e9-08d9ce51c198
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:41:18.4703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z5J3SCBIrRQlVDRSQaN4BH0NjHLyqL5N6Ylu53Gu8/qjuxMq1lTUaobWgHW3RftKD704C1x21qkoPeDz23XvNVcIFtKd3EVt6zlBYH/rYOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030004
X-Proofpoint-GUID: 5Nt8Z3Yr5rN8-Jw2MIHzddJiiHaxSW18
X-Proofpoint-ORIG-GUID: 5Nt8Z3Yr5rN8-Jw2MIHzddJiiHaxSW18
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> QLA makes a call into midlayer (fc_remote_port_delete) which
> can put the thread to sleep. The thread that originate the call
> is in interrupt context. The combination of the 2 trigger a
> crash. This patch schedule the call in non-interrupt context
> where it is more safe.
>=20
> kernel: BUG: scheduling while atomic: swapper/7/0/0x00010000
> kernel: Call Trace:
> kernel:  <IRQ>
> kernel:  dump_stack+0x66/0x81
> kernel:  __schedule_bug.cold.90+0x5/0x1d
> kernel:  __schedule+0x7af/0x960
> kernel:  schedule+0x28/0x80
> kernel:  schedule_timeout+0x26d/0x3b0
> kernel:  wait_for_completion+0xb4/0x140
> kernel:  ? wake_up_q+0x70/0x70
> kernel:  __wait_rcu_gp+0x12c/0x160
> kernel:  ? sdev_evt_alloc+0xc0/0x180 [scsi_mod]
> kernel:  synchronize_sched+0x6c/0x80
> kernel:  ? call_rcu_bh+0x20/0x20
> kernel:  ? __bpf_trace_rcu_invoke_callback+0x10/0x10
> kernel:  sdev_evt_alloc+0xfd/0x180 [scsi_mod]
> kernel:  starget_for_each_device+0x85/0xb0 [scsi_mod]
> kernel:  ? scsi_init_io+0x360/0x3d0 [scsi_mod]
> kernel:  scsi_init_io+0x388/0x3d0 [scsi_mod]
> kernel:  device_for_each_child+0x54/0x90
> kernel:  fc_remote_port_delete+0x70/0xe0 [scsi_transport_fc]
> kernel:  qla2x00_schedule_rport_del+0x62/0xf0 [qla2xxx]
> kernel:  qla2x00_mark_device_lost+0x9c/0xd0 [qla2xxx]
> kernel:  qla24xx_handle_plogi_done_event+0x55f/0x570 [qla2xxx]
> kernel:  qla2x00_async_login_sp_done+0xd2/0x100 [qla2xxx]
> kernel:  qla24xx_logio_entry+0x13a/0x3c0 [qla2xxx]
> kernel:  qla24xx_process_response_queue+0x306/0x400 [qla2xxx]
> kernel:  qla24xx_msix_rsp_q+0x3f/0xb0 [qla2xxx]
> kernel:  __handle_irq_event_percpu+0x40/0x180
> kernel:  handle_irq_event_percpu+0x30/0x80
> kernel:  handle_irq_event+0x36/0x60
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 7 +------
> 1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index e54c31296fab..ac25d2bfa90b 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2231,12 +2231,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_ho=
st *vha, struct event_arg *ea)
> 		ql_dbg(ql_dbg_disc, vha, 0x20eb, "%s %d %8phC cmd error %x\n",
> 		    __func__, __LINE__, ea->fcport->port_name, ea->data[1]);
>=20
> -		ea->fcport->flags &=3D ~FCF_ASYNC_SENT;
> -		qla2x00_set_fcport_disc_state(ea->fcport, DSC_LOGIN_FAILED);
> -		if (ea->data[1] & QLA_LOGIO_LOGIN_RETRIED)
> -			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> -		else
> -			qla2x00_mark_device_lost(vha, ea->fcport, 1);
> +		qlt_schedule_sess_for_deletion(ea->fcport);
> 		break;
> 	case MBS_LOOP_ID_USED:
> 		/* data[1] =3D IO PARAM 1 =3D nport ID  */
> --=20
> 2.23.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

