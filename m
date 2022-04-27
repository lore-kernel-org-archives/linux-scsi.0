Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F727C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 16:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbiD0Qzl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 12:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243478AbiD0Qzh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 12:55:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91D72BB0D
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 09:52:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RGmdFp025784;
        Wed, 27 Apr 2022 16:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uvVNsbY9wL4MzZhfuVo9JLgtNCM2VyWrran7PVgn7Lg=;
 b=JJ++JQb2dg7g0/Z4PJmIn9Xy1I8JIWNorpvs7Qnl2MPyolyykjD894cMNIq9VZk56JmI
 Q7Nmpe0sK8YIwLKAWBYZd2rjrjDmQHg3BfrINdfZlh9KPGqr7W217iyYFxIXROkUfohi
 24Llx3lpqU7KxGbKbBIo79A3eF9uTa/fKjnBKxPGPw8ozlIXKPDoCOdxWlzMt8gIr9mg
 o+yFln/Hely32J0qUaSjGwM+/grNAiHXN8pnfKaEJ1WKL3QhdNnl3DmGrnewBWR+A/Og
 sywYh9ANLqax/g7t2o0PgNsdm1aw3u9fy3U9HSbRVjqb3CZIMjcZjJoppmQXuINHtQ00 sA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1msrpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 16:52:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23RGj8E5038666;
        Wed, 27 Apr 2022 16:52:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w54d92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 16:52:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfAld9Wv+ynycrK2qBYdp685djxzm1ri9OcRb3NaKaziFhSySRtdubrs2zGC66hShaUxZhCNyP/9dPMj8sjpGIm4mbchJ/T95FEHR9oYT2N889NCNr+nAVMFqlZ96V0hl8ex0lkGe562ZK8SfBIHEkDcBXKRoQDHELvT5OAAN0Zv01FxTiboPLQoDCAyc7VNQdVQxUMvQpJvFKZBxxQnE5llLXIFyduK+8CuaXwoaxhRJgmozCsbEOG6nUpKJ1mkM6cUO/NDvQB2VIZiHB+Eor6ydPq8R6aoywVP//l/jrQZfpHN1TLk5kY+6QGWuLpinqzn+MqIGWibe5PrCwuCXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvVNsbY9wL4MzZhfuVo9JLgtNCM2VyWrran7PVgn7Lg=;
 b=PY6KnhGXu3+MI3RFaTu1EvAUjJOy3Pr28gs11OSdAqn0hIjf8a0EWQtXjBSndOsmwF/3NBXDs5pXatumURiKxA0k+RE9vI6+szTRYWxjA7uiSg77VWtzLelXeqgmLG76V7WRKXE3RNW+ctQl3ilPJLfhUMkwgHrPv05+PNS/tBaAOk6z+5oPwIkNUpqyTrqEmtvVP5xGv3XzBtB3HVzVqnXWcjJV4iu5UFGXdFdKf1UlGeGiUvNThALXUFFRUcNlM4Q/YScRJMRqwrB1Kv+gSGIYEGBDT8urE/wTm6SKdoHVVo9JJ/49pZxWSjRF8J7pUK3JmyPbNvwXQIi6RSDGwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvVNsbY9wL4MzZhfuVo9JLgtNCM2VyWrran7PVgn7Lg=;
 b=fOSVfqwXizhnUGrOlK/CHbOi7cw3hC+hg6+VhFqJFukK0xFSJXPIYCjnE2MkM/WtBMOROpeBn91vLmgXFZxj5YtJNva9aBtxBb7IGtVR5pGBRYgV00AoAT8bwOf1JzP5dAaQGmNo4J76EN7NKcpQTZhrtOcbNxB5kjz6wFCiWec=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3755.namprd10.prod.outlook.com (2603:10b6:5:1d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 16:52:10 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 16:52:10 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Topic: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Index: AQHYUMYtkLBbKidY90SJACyXGZHZ2Kz3qV6AgAE75LiAAE2AgIAHyTkkgAMQvgA=
Date:   Wed, 27 Apr 2022 16:52:10 +0000
Message-ID: <66EED9AA-1D62-40C4-8585-6EB49FF0D63A@oracle.com>
References: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
 <4FA3632A-690C-470F-8DEF-663F9AC0CFC8@oracle.com>
 <AS8PR10MB4952FA41BCC382A6464D842A9DF59@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
 <F1592489-7C94-454B-8EF3-BF5C56F48A10@oracle.com>
 <AS8PR10MB495233A032E7425D1DAE9D549DF89@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AS8PR10MB495233A032E7425D1DAE9D549DF89@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 475cbb79-6e0b-4107-7993-08da286e4598
x-ms-traffictypediagnostic: DM6PR10MB3755:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3755561B271FD57E932DE868E6FA9@DM6PR10MB3755.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: inZMIYQLFAdFsjF8muHWHPiSB1/MuENJa5+W/Ui2imzSeAxZx9+4oBAZSzMLc9/yHMEeN0Dp/TbYY919KIUFcT97T/d2j41/m015ZlDL91HcAHHaCgNuWxYScbyAa4uCAf7VclamAZ6szoxgZ8+ZbDFgjLByOope5fbwmYR7h59NtiKXZdyTBRyQp+pI77/Tuv8HN5DFA11soU2oC+btzosxaQfqursXYVSktP8JpAWsVU81z/F74YKpnLdrK4muiNNlgX24YzGpVFfup98iDciqwHL3uIBBE43AG97p1i8FvrYcWii38Mm+GHGWN/rVvwYV25Zq1br/c/k7RSYKkQ1+2rWd3I4eMKPKpm7BDdJEaR2TjaTANlvJgSwNCQmrPVx5orTrvfz/PmD0WkC01C5s0IAc57OJDqSsysNjkRMT/ntsRc3ps9UXP/GG5eJZrY8s2w5Xf55hhhLwLOF/5y58TYoprMFPNYF/krlVhe3h8VWAGeUB1eeZEp8dJR6RScYEO2Il+ppEgFc5+eJo3laMhQuvCYFf2vnF98MxrHteb4HZ7A+tKXaHjOexSSyds25e9nUade+X8RMT4K4/6qvos19FISROeXAIM0dyEFWuFn+j/o6e2sifyrDo7bgj3fkEjrDKVwweYeQY9Z4a0gtuIz5gJJNz3u2T5thRR646cp7hjnTjGkdTdXyIQ5mi0Xc+EqTrp9F8wgUCGhUJtyHxOQnHUpK9PYRccvOz84LSMYjwqENSN/qhP5x4YcZ6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(33656002)(508600001)(4326008)(122000001)(6486002)(66476007)(66556008)(8676002)(64756008)(66446008)(66946007)(91956017)(76116006)(86362001)(316002)(38100700002)(6916009)(38070700005)(6512007)(26005)(2906002)(53546011)(6506007)(5660300002)(2616005)(44832011)(83380400001)(186003)(36756003)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oKNrkmk7ruS6rOa5wlMWEnwlkN4DScsbuDOoVF9r9Na3G8aetaBAZywikLge?=
 =?us-ascii?Q?tkOJug1PWHu/7l+s1/XZ8ffnj0Pp4eh87eVCXV/RMcKt3JjExIQ9cIyn4gS9?=
 =?us-ascii?Q?/bJw5wFC8+lS+qYXQKvNejQG2G0UHrcpYDl0mnJ1/CaynXZZmkMcCpEWJOJz?=
 =?us-ascii?Q?J1+CtBerawJnLcIkrfH4mffezqyK06Fok4A2/J8ZgAY9NFjAl312ZS7yNYNp?=
 =?us-ascii?Q?EelW1E5QacuztwrYgnjtIGXRp3c3jr5kThFilD2Ac1FOlTmJGyCVrqWa5e7e?=
 =?us-ascii?Q?FNoxoYPTsFe8BAoC9bHUTsbQSkFSohD1j+WOc2nroUnDBV9apdizVGQqv84p?=
 =?us-ascii?Q?0vnfSU2z202pwMC2ULJByXMj3BkohINiXzxfyh/g3PXkkNlQUtNyJaNUQNaI?=
 =?us-ascii?Q?Z5+Uxqk1L9wxQEY4QgSY7PqOOfSPhYQ2aE7TNVGlNHboySCQbZu4A1f1vlyT?=
 =?us-ascii?Q?YsMzd6x+IVWHzG/qp1yGhK9iCYOCN+MqWUGG/rdphnye70nkqvsSwZen37oF?=
 =?us-ascii?Q?idDXwPZtC/ZnInMhbS+kYXzSu9r9OE39T+1HahG746DGMpglGrQnGZgSkI/p?=
 =?us-ascii?Q?neVSNtH3tBjy6XiD/HSwCGzZuj0V2Y3pS8eU1aqU5f9uBIWKh6ni1sR6i4Xm?=
 =?us-ascii?Q?858J9dtvU+6l1Z/1pM8V6boGuHvxL6wBg3yIz/cK5k00NYXal6GYfCOWGzWv?=
 =?us-ascii?Q?XuRjoEfEacCX9iRi8iXBd1nrCOiLUTOps7FA7hwF+bOkCkiAc9E4WX9x5h6M?=
 =?us-ascii?Q?eNIeB0j3/TdxBJcqT9GrWuY3cefmvDjrhFNralXSuh5drABZH6rzUod+dBXT?=
 =?us-ascii?Q?dghr02l9SloxXbdi3JQPz09tvX8RwqaF1NbrV/EKKa3l37ck9Ntf/+arLm0J?=
 =?us-ascii?Q?99jxLDYHO+xGxEZNK/8l/A7ib8dqgm+UXoNVt60nvufjRdNTvN8jt6UexqgM?=
 =?us-ascii?Q?2VXHO6+X99cTFr2WBeqSr/yAK2TiVgY3JgaeWeslgztY1vitzRCHZ3+oD6BN?=
 =?us-ascii?Q?Tonre+XyoLlHb3vn9ij1Oc2N5jidJvk8IYzG/MDc45JLOSHcKKDEyoUuY8Ts?=
 =?us-ascii?Q?qep9G3DdLnPUcFeyVuuoxyjjef5A7/h/4t31YehAlXKKbBUJgu+V0WanxDNR?=
 =?us-ascii?Q?a1ujvdiHMmVl1o9UiSsmZ9iROeyTlq5svKgljstPsJ9DYS+xEa4t3FnGLSsK?=
 =?us-ascii?Q?o+syulAps5YgJ8YHQ3sCxoX6l/jR2HI+9ulmReOVIfos2+byVKeUgrl8Yl43?=
 =?us-ascii?Q?Ekxk5cVxKwLY9lVxNWsaK5ZQ0tiudTpm5+lBGjvTrealPqbFSDHoX5tj3t1/?=
 =?us-ascii?Q?jhRi2r4H6C7n5JMMIOWMiChWpfFDq5r8AuPVqIVUYRoC/aCksbpSgHyrfIMe?=
 =?us-ascii?Q?Rsuza+fJYadL3ZfZpsCxcfEFpw2cUkcYtb0Bjl5QOHYPmWBCOREJKqJAp7ff?=
 =?us-ascii?Q?cuz+VaO8IHGkxlNxtcvlHRYdJeby9Kc+0DVDW+Zkr18TM8TgAw/FzdrOBhyx?=
 =?us-ascii?Q?udpwQ702bNS9WlFKMd00p1xFVdNs4Rr/d2oKGYM0R1oIYNzuRV6p2LwgLloS?=
 =?us-ascii?Q?zTJSO4+HLTWFzsLgWz78EEfdXzlip79pVInXtjsJb+7U+7sX7KNz+gcgOz2e?=
 =?us-ascii?Q?0TYSFCTMImsNd5pXp/PwCFFzEM9H7a/XNprJWMMe7Ue7w4GBZme86qz+6qZw?=
 =?us-ascii?Q?i8S7Gw2BKW8fVzV6zs1PV83glPDyWqL3uHi49vU61YuLBDLowitXbpROEcD+?=
 =?us-ascii?Q?Ugeqg1+gglamsE1Zu5sjL12C7PTukAp3HD+kHjOrxcbXJODuRFDL?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1128E79C2C134D44B5B1FB7590DE8D1A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475cbb79-6e0b-4107-7993-08da286e4598
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 16:52:10.5324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SiZjBBGRUFGvzDB7S6htLHwzy0OJ5SuCD38/WVcemrkcKz7i4UyGLo8xsVrrTfTkGXTVKjJSqubcQxpKZabaN91kMWeoxC+i8eIASKT6rZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3755
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_04:2022-04-27,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270105
X-Proofpoint-GUID: r1QyPuZ-ETABxssXe6Wyq36fuPB4I4IC
X-Proofpoint-ORIG-GUID: r1QyPuZ-ETABxssXe6Wyq36fuPB4I4IC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 25, 2022, at 11:49 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wro=
te:
>=20
>>> On Apr 20, 2022, at 7:42 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wr=
ote:
>>>=20
>>>> Do you have a log showing this error sequence?
>>>=20
>>> Yes, I have, but the problem is that I have a different target stack, n=
ot LIO. So the Call Trace basically contains code sequence from this target=
 stack only,
>>> except for the call of the qlt_free_cmd() that trigger BUG: BUG_ON(cmd-=
>sg_mapped).
>>> Regardless, I think the problem lies on the qlogic driver side, because=
 it is responsible for management to map/unmap sgl list.
>>=20
>> Agree. Am curious to understand the test case/steps that would trigger t=
his issue in your env. If you can share your test scenario would be a bit m=
ore helpful.=20
>>>=20
>>>=20
>>>> Can you share more details?
>>>=20
>>> What I am observing:
>>>=20
>>> 1) Command processing calls qlt_rdy_to_xfer(), maps sgl and sends a com=
mand to the firmware
>>> 2) Qlogic adapter reset occurs
>>>=20
>>> qla2xxx [0000:82:00.1]-5003:13: ISP System Error - mbx1=3D110eh mbx2=3D=
10h mbx3=3Ddh mbx4=3D0h mbx5=3D8a1h mbx6=3D0h mbx7=3D0h.
>>=20
>> This message indicates there was a firmware crash. Qlogic/Marvell folks =
should be able to help you capture/save dump. That firmware dump might give=
 you clues on what is the cause of the firmware crash.=20
>>=20
>>> qla2xxx [0000:82:00.1]-d01e:13: -> fwdump no buffer
>>=20
>>> qla2xxx [0000:82:00.1]-00af:13: Performing ISP error recovery - ha=3Dff=
ff9dd7d6058000.
>>>=20
>>=20
>>> 3) Somehow the command is being aborted, so that means the command's ab=
ort flag has already been set.
>>> I think it may happens something like this:
>>> qla2x00_abort_isp_cleanup() --> qla2x00_abort_all_cmds()
>>>=20
>>=20
>> I think this is the aftereffect of a firmware crash and the driver is ju=
st recovering from that. A good firmware analysis will shed more light on t=
his issue.=20
>>=20
>>> 4) The target stack calls qlt_abort_cmd(), and since aborted flag has a=
lready been set, this call ended as multiple abort.
>>>=20
>>> 5) The target stack calls xmit_response, and since command has already =
been aborted, this call starts the code sequence to release the command tha=
t ended > with qlt_free_cmd()
>>>=20
>>> I think I could try to reproduce the problem with LIO target stack, but=
 I have special case with my target stack that lead to reset of qlogic adap=
ter (ISP error recovery) and this is one important part of the error sequen=
ce. So, I think I will not be able to reproduce the problem with the LIO un=
til I find out how to similarly reset qlogic adapter during processing acti=
ve commands that have already been sent to the firmware.
>>=20
>>=20
>> Himanshu Madhani        Oracle Linux Engineering
>=20
> I seem to know the cause of the firmware crash. This is an abnormal sg li=
st that is generated by my backend driver and passed to the Qlogic driver v=
ia target stack. The abnormal state of the sg list in my case means that it=
 contains more than a thousand nents. So apparently Qlogic adapter does not=
 know how to work with such buffers.
>=20
> In any case, I think that the main thing is not to find the cause of the =
firmware crash or fix it (because it actually comes from my side), but to f=
ix the crash during recovery the Qlogic driver after a firmware crash.
>=20

Okay. Now that I understand what was triggering the firmware crash, I agree=
 with your patch.=20

> I have special case that allows me to reproduce the problem, but perhaps =
it can be reproduced in other cases that cause a firmware crash. Maybe ther=
e is a way to manually cause the firmware crash and it will allow to artifi=
cially reproduce the problem?

Sure. It is an unusual case but you are correct this error condition which =
leads to firmware can be reproduced easily, the driver should handle such a=
 scenario. I would leave it to Marvell folks if they want to investigate th=
e firmware crash and see if there is a fix that can be added to FW.=20

For the patch in question, you can add my=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

