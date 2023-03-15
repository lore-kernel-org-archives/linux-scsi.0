Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6198BC61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 22:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjCOWOC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 18:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCOWN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 18:13:59 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DF61630A
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 15:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678918436; x=1710454436;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2MqVQ6h+3WKCjChDZO/zT35qkaE5FA8VFW3cRoosGJs=;
  b=imF82JJjBMgW6a1dAwMMQel+2ap5y6HpBgXWp7eTHaf54GXviTXXmbrh
   blisKJa+kwbynlQdUOSZHZEZb/L63uMtVXpCJy3tAsUCnn0UB9mSpZpgL
   oVYmrVHmcAfh/KMdYIVLA6nsWHz2Jic00zTKw747x2UrPz4OT6ZFlGdhq
   ZENcL4xx3Dm9gcjm6Yf73a8RE48aGPXJdfi2tywV/2G6bNbYebU/X77kU
   P8oN/Cdmp+7EfDKRhZa0dJyAMiei/db9L2rjPoURBUBl5wIDIAujT6USk
   +/DVvwp0lipoFuOFkDX95EYA12h9fWrX4G9rZljhRPQCKB3s+2dpGFzvN
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,262,1673884800"; 
   d="scan'208";a="224008463"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2023 06:13:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF0bvg1yNC2GCpL+6KSljumfk69JtRmFEwi00u8CC05jWC3sOM6pkDb51/eIy9qL6xnzX30XfyJ/zntYB36oGjFUk8bUVO2h0Jb9UxsDxewzIsaRUTe8TqqJy7HoYbRV4Ufs23Dl3HzW7AIIjN2qkFLA5A69kU9CgrVFwsyLU58JkEXk5cng/h8XqoDOch8UQaBIMeeJmNpNv2POpyLENllSmfinvEQqmaueXVo64iV1xBYQF1MvcWolk+k0j7DncgX3q8HnJTSmNabGom8VzkF3O7YefND+QWnbTdR7nNYTR49b2dMF0aT+JQHzX5QYuApyFLaebwU7u4dNDMibJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MqVQ6h+3WKCjChDZO/zT35qkaE5FA8VFW3cRoosGJs=;
 b=Lgava7DVLrXUWo6hryZdZ92RYON+1ROdkstRES0HB28NZ4RJUO7L/2JMipym4RhGvpFsNxzQS7YDZrr7xMs0xNY/ekWTz72VlHmmctxg/SGdSSao8/381SuuyVF4BIaTNapqzEWpO3Rhc70qVeRd+pYFNa+x2oSVcEjo4/aHwgdRSdZHvAQrfk7i/LSlGp3WFGpoHFhYJl2MtoMh5g5lHtFdgOLWy9DqS0rM61gLsKCpw57j3kObOpBZOcocoeO7VAZQ0A6cd8znO40hhiIOooIXfh5y7jaRLM8qhCGyO8AOHHnxio/uPo2NWFul39KoVh11uvcOOvaF90qm6VX2ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MqVQ6h+3WKCjChDZO/zT35qkaE5FA8VFW3cRoosGJs=;
 b=CRs64sSHM6W99US/Ski60sJd58uZ286Gf784d29QxY9/+LN8uhbxOlCQmMMSGA1BVbOY52niUEqc032QrR6eOfU1h4OhfnpYk1teT+Gfvu48btFWYwkyWI/xhlhEtUULwEnImLLlIv1POk+fzDqTddgjG1KhVr7a9QECmScAc5o=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB5584.namprd04.prod.outlook.com (2603:10b6:208:e6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30; Wed, 15 Mar 2023 22:13:52 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::2219:5d8b:8a1c:944c]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::2219:5d8b:8a1c:944c%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 22:13:52 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: RE: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Thread-Index: AQHZVrfDqXFgb4oCmUShIwppDXdKFa772ngQgAAku4CAAGjwcA==
Date:   Wed, 15 Mar 2023 22:13:52 +0000
Message-ID: <DM6PR04MB6575D6BA280BA7B4396D39F7FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230314205822.313447-1-bvanassche@acm.org>
 <DM6PR04MB6575689FC234B87CD997F474FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <09ed808a-b697-37fc-8bec-c4da6be1382c@acm.org>
In-Reply-To: <09ed808a-b697-37fc-8bec-c4da6be1382c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB5584:EE_
x-ms-office365-filtering-correlation-id: 4bb76a17-4a57-4fc5-0b78-08db25a28f84
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Upd6cQWN64j0g9fGqNcW+kTOO9Ypy/zOfYNE4BXWFQPL5Gtnx4dvOuB0zdUBMFYoh34S5nsy729HPUN9CiOR+YhHM14ScFfc67qTCr343z79Z3QPL86ChJ1NFYp4Sg1duwXuwzZxBeNP71dHzQq8f9Lla/5J4HeMVSEqnxldZ+OkGvTii5jC9hch166d6iKk+CQLp+FCHQK+IUYdZROsNqE5nuTjd2GXGTWDn6zLfsb5uHR571hyaRgyN3oEdJ/etsY05HWMWZKhvLmgL5xFmIkKpnzFDfUI+kt6Wf1ADZujY+PcuQUY8FawH1QLv6W7GVGrm6LhwF39i4tNUVgfTw9RSE7qKwCVG1cS8O4aIK8cqRnpthCmxntlGyNIdZz29pbSgIv+W3OJhAOjXK/tOObAEzhXNVl794eECBLqRjZN+GLVtezOZadYXRsZZEBnW4aV0BYi6TbZmVJZ59unre97i4AyfhwgnZLtiaRiPS02stoaFAbqkbX+5if9g+j9e/uJ28WDaiEAKfhowIRXISIZLN+suBeVel606Jf/3sViJ6JVFvR7Pv3fKBNqrY+KLukifKqOqTQYsSDENv5thPWMrEw0IEofm6PKqbFdXxmcTsaTTMoOyD2hU/knsbTeL1RVt1FtmaV3xwdLr+EwxZA2LO7LurMRqUC9YnS/Q+S84c47KCLBP0ODHyYTxal4UOaq7xY8YqG0wQRwUD8vAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199018)(38070700005)(33656002)(86362001)(122000001)(82960400001)(38100700002)(66446008)(8936002)(41300700001)(4744005)(66556008)(4326008)(8676002)(52536014)(66476007)(76116006)(5660300002)(66946007)(64756008)(55016003)(316002)(2906002)(54906003)(7696005)(26005)(186003)(9686003)(6506007)(53546011)(71200400001)(110136005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nnk1ZXJTbTRPRHhXL0pkQUtRUXEwa3BoVFIrdzNXelpzNEJJMzFzWkdFSDFu?=
 =?utf-8?B?S1djTGpFYkNXZG5MZ1ZRQ3I4UEhHMkJDNEdkb1hXYkdEYU5Ka25qYWFveWRR?=
 =?utf-8?B?WUR3VVVFTnBEQmhscFN6djBxR0dvM1dPOVFjVFNOTDlibGFlT3A5MjJXMndF?=
 =?utf-8?B?bGRtUURWU0dtOHJzS01rUWZ6RnVWdiszbG0rc2NvbTlicDIrdDI5cTlpZTVJ?=
 =?utf-8?B?U2tjTk9DTXhDQ1lZaTU1NkxtQ3hqODI2N3ExdDRiVUc2dWYxYjRwM051QTBz?=
 =?utf-8?B?Uy9DK2ZrUzZHZFM1d1FNcm9ybVlYQ1BzNzllY0dlQmpoVkl3YmNNY2p3WnVl?=
 =?utf-8?B?WmM0azJZM042anRBREc2aTljSk13eVR2TEJkam5TdDNxMm9oV2xBTUJpVE43?=
 =?utf-8?B?ckNZVmxaUktZaVJ6ZnpHMHFPSUdJenNyOTFtc1BNRUJNVDBycUQzMnJzU3Vr?=
 =?utf-8?B?QlVhWUpyU3JocWlHelZHTmJ6WmUxMDZEQWRZUEhDSHBLVUJZYlBMR0ZiU1Ar?=
 =?utf-8?B?cE1FMkhLU1lQRXJmdDRyTFdoNUZhRE5iMzMrMDNCWFgxMi94Z1NKTnFuUFRP?=
 =?utf-8?B?QnJMYkR4OW5rdmRIbWcwWmR1RmE1ZndBcWk4dUpmVnhRMzVpTmwzZmg4V0Vi?=
 =?utf-8?B?YzFXT21VYVlVazJEeGxhOGpROVR1QWI5cWdYUmJZL0c1YldzazFubjc4aFY3?=
 =?utf-8?B?bk11M3lZTU9lMHozL0Q4aStIdThiZHN1dENDbzU0bS95N3FTMFJ0LzVBa1RW?=
 =?utf-8?B?akxrYVlmTHlSLzZBcEJFSEo1TnNNa2ZWZUNmenpsRU5NOTZMM2lWL0hSZ0Yw?=
 =?utf-8?B?M3UzYTd0Qm1jZzVFaUI3N0x1UWhIaEd1N2xMTHFsZ3V1SlBORVdHWm5CUFp0?=
 =?utf-8?B?YVdlK01nMnhLRWV4d3BnZmtGdCtGbnR2dmZVc28wZUlGT3hFQWFEUXIzbUQ5?=
 =?utf-8?B?VkxkYlVtejBQV1gvMHh5bXB1MUYzYWJzemJEcnVWdENicG5IRkVONHFxTERi?=
 =?utf-8?B?Q3VRVVN5Z3FPa1lCZlQyRi9DOW1xYmdIMVdUWW16eW9sclVhNTNQTW1DNW0z?=
 =?utf-8?B?TmRwd0ZNQnJGZDA3Uk5GSWhMMld3dGdhb0xkVTJXWWRtalNmdEdxdUFLZHpm?=
 =?utf-8?B?VXFJd0UzN2xWNVlZWXVZcUszajRoRFAvU3p3OXBwWit6WjVCQjFGYloxNHVj?=
 =?utf-8?B?QldPcnhRdkoxTEtTald1c3EzUm1QTmNQcVBKM1lKY01qeXdtelBGVFJic1NR?=
 =?utf-8?B?ZEE0Tis1dUhjMG8vZUNKYi8rUVhVTWlyRWtMWjROMmIxbFNiN2xpcVdiSWZh?=
 =?utf-8?B?aHdJWklyblNlaXp2MWpHNXM5RnU2RVZXbHA5SzF5eis1WXpwcTBoSGd2VWNY?=
 =?utf-8?B?dDMxNkp2SkplaWtySmdKTjFTdDNNZ2RGUU5vd2lRODJpOUlMUDZMdmZWR0p0?=
 =?utf-8?B?aTBxQlBTTForZTBEa1l3enFub3p5TEtZVERKVHZDN0hVdE56MGhrNW1DL2Ru?=
 =?utf-8?B?dFJFZ3llak9iMzdPNHV0U05qUXR4K0RZZUN6L20xVmtMaDNpcFlDaWx5dnhz?=
 =?utf-8?B?WEJIRmN1SmFFcW8rL3BWVVpPV0Q4UDhqdXVpdmVVVGlEVTZVTFZHNnE5NEFB?=
 =?utf-8?B?MDQrcjNZNWVYUFZpRC8wV3ZwVTJEbWk0bnVKQ01NZ2c0L1d6UFVucnAvRXph?=
 =?utf-8?B?WXJlVzlxZDhoV1FxSFErTFdaYlNmeEJnUnZyemd6S29XTkoxYzZoUmtPVk1k?=
 =?utf-8?B?MkRqdU1lN1JhRU1aSmMrV2pRZDRid242NTFiYmdUbVM3NkxUL3JEMTAvalFo?=
 =?utf-8?B?NGpUMlJUNnNwNEUrV3dTMDBEOGRLYlcwS1NGY1VWOEpiaG5uOThpa2J2aTFO?=
 =?utf-8?B?S1pQVUVzdzZsMEJOcUYrRG9oL3ViRUdDTjI3SmR1ZFlyMlFKQytOVFY5dURv?=
 =?utf-8?B?MjZWdTlQbExKcmtXUlFxQUZ6b0NrNVMxa2ZkMHg1UHNKNndqYVJoZVZ1aWVo?=
 =?utf-8?B?RjExR3RVcSs3T2IvZkJXS1h5Qks0L2hWV0pTS05uYUpERFgvMmpqekg4YU5x?=
 =?utf-8?B?Z3lvM3I3MWFVRjFnUTNoSU52VXgweXlVOGxwSmFkRDN4SU55VVRWT1pHL1Vu?=
 =?utf-8?Q?IvEppVL8CXfcpqqeMefjxP07u?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K3BUZUVKU2I2R0hZeEZxUFhuMmlFUVR0ajdHTHRTWHlaS3FNYWZ5UWIwMEtw?=
 =?utf-8?B?eFhRc1lTZXROS3BKQnF6bHFTSHRYRk5Pb0xiK1NkclpVTlJHOUxuZ2tKL0Fh?=
 =?utf-8?B?SzhrT0VUdjNmTjNidmc0L2c5Q01WL2pWQ1RKVG1aS05KN3FyMnlCNzJXcmhk?=
 =?utf-8?B?Qk1zZjF3WWxmN3NlQ0NGNmUxeGlrQzlNaXNheXkycENzMVh4NlBOd2tZNkVn?=
 =?utf-8?B?ZUFxM1BKeURsMXRScXQ4cUpFdGw3ZGZLV0grbmhzVnpWa0dTTjhVb1pwM3R3?=
 =?utf-8?B?L3RiSlMvT1VyZHJOa0drbDdYbEN4VUNGdEwvSEk0ekNabkxwSTVHUVc1aEY2?=
 =?utf-8?B?L3RnVmdmZVYvWmJ3cDIxZS9sQmk0U2RMNlNLMVpROGJ5NmNNOXNmbXRNanpW?=
 =?utf-8?B?L085NjduRitKSUhmK1NrR0IrWWJJRUdWK2RjRmpveElPTnJhK2JtNmQ3dkxB?=
 =?utf-8?B?eTRCOXhxMnEyT3hiZTR6SWFIcllXVnJudDRFbGNIbWRrS1p4VzhkMzJBSkN4?=
 =?utf-8?B?c05NRjg0Z0hyK0hvSGs2T2h3YURPcHBMVFlvaTJ6RzkvUFlveUEzdld1ZVFk?=
 =?utf-8?B?S1dnUnh1QTZiNWxMWG1ycGRDdEJHQklqVitHVDBKMk1SOWRDVUVObis1bU1t?=
 =?utf-8?B?d3RKNlh4ZUlpdk82MVAwRUVTUUtHbWJKcmpWdGlBaXFLZEhBcVRlQjVOSG9u?=
 =?utf-8?B?Qk9EdkgvZE04ckJQM3MzSHBNK3gwaUd2dW53ajY2b2lDTk9JWXBvK09nNHYy?=
 =?utf-8?B?YmVTd3BPcFRyV2QwZjNVYUVhL3dxMTNvVDZyRnppVS8xVHdPZGZldHc4MlFP?=
 =?utf-8?B?QzdXYi9zamdtaUpOejVVTmlOa1NSQXpFY1piTjRpRld0SE9HMnJ4dEc0QWQ4?=
 =?utf-8?B?MHdQUldnOHBxRkNHcUIyYXBVMDBEbUkrUzNaSW80cXYwazl0S1FIZ3JqUEt2?=
 =?utf-8?B?YTFiSkhtaGRtSUxqK2lBK3ZndGNnVEZQQmJ1N0xndDdmUWhoNjdCTHViZVVX?=
 =?utf-8?B?VXdISjYwNWdUNDlodTNZa0VoLzhGZkYrcE1yYWRzY1dtQTMweHcxNytMc3ZV?=
 =?utf-8?B?dVZDQTVnbTRxcmJ6cHhlSncxSm9CWGUzUGpjdHVMeUJGWUV0aGYyTmhjS09J?=
 =?utf-8?B?Z05aMktiMTBRSlp1N25SVDdLbVBLbW1rM2Fpb1pvSnlHaTh1elRGQ2d1QkhI?=
 =?utf-8?B?VFpkT2cyZWk3LzRndGpTRTBaVFY3VnZWWFdwZk9nb0VoZ2RxeVNhOUZ3NDRj?=
 =?utf-8?B?MlYxUE9hRGJjMEYrbkF0eGNnTy9CWXRaenV4YXZVc0c2Z3IxRHprR3FhTVp4?=
 =?utf-8?B?OEV0bEsxUHUydTZQWkJYZUpNYXB4QVlFQjBiYjhBN0ZIWHRWWFlUd0NnWmJO?=
 =?utf-8?B?ejkwRm9YMHlhS1E9PQ==?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb76a17-4a57-4fc5-0b78-08db25a28f84
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 22:13:52.5313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zJ157JYliClbe3G/rJVnWPOo7Ex9WYjp35SrYZTB8M7c4u8nZMzJrwfoMjEanPL880HykguAS6p5DbwhwsDf3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5584
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiAzLzE1LzIzIDA2OjQzLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4gTmVpdGhlciBVRlMg
aG9zdCBjb250cm9sbGVycyBub3IgVUZTIGRldmljZXMgcmVxdWlyZSBhIHRlbiBzZWNvbmQgZGVs
YXkNCj4gPj4gYWZ0ZXIgYSBob3N0IHJlc2V0IG9yIGFmdGVyIGEgYnVzIHJlc2V0LiBIZW5jZSB0
aGlzIHBhdGNoLg0KPiA+DQo+ID4gQnVzIHJlc2V0IGhhbmRsZXIgaXMgbm90IGltcGxlbWVudGVk
IGZvciB1ZnMuDQo+IA0KPiBIaSBBdnJpLA0KPiANCj4gRG8geW91IHBlcmhhcHMgd2FudCBtZSB0
byByZW1vdmUgdGhlIHJlZmVyZW5jZSB0byAiYnVzIHJlc2V0IiBmcm9tIHRoZQ0KPiBwYXRjaCBk
ZXNjcmlwdGlvbj8NClllcyAtIHRoaXMgd2hhdCBJIG1lYW50Lg0KDQpCdXQgYXJlbuKAmXQgd2Ug
Y2FsbGluZyBub3cgc2NzaV9yZXBvcnRfYnVzX3Jlc2V0IHRvbyBzb29uPw0KDQpUaGFua3MsDQpB
dnJpIA0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQo=
