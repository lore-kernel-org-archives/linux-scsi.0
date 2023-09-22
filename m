Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26B6E7D0BB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 01:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjIVB0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjIVB0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 21:26:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DCACE;
        Thu, 21 Sep 2023 18:26:18 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsUCV009875;
        Fri, 22 Sep 2023 01:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ffFlkq75v2oL6JbY/3XG0kgp3PX3JLbToGetKX8AAn8=;
 b=MFIfjEVo5sCI4v/acvJVjJiRGhB9mfOUNF8qVJoF/5LFGgqLo1KuO6VWdvFRNxYc+MNs
 bhiAZL38/XyGWF3SpaS7lm1zH/bfu3k7xTOn3/ytqXOWZFbTpL+SUaJIgoG0M1vuwCBx
 3xIhVjmj+S0QsoZO587hw1rfPN/XFiQTRxbgZ/jskZWnaacqT1jcs0++367mAC7/F18p
 UozCL+IWXZrJcygT5anrUr9wleM5jJ6+7ULNGAmraocWxfbPsR9ZxJ1eS2MtuU6JG1tE
 yidxKAyCOtzgLMzQlz7ZsL2tUjwSq4NXvQy4rZ8dzc8EY+ThoPDlEbF2myovSemasZqW yQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tswgks9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:25:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMookh015695;
        Fri, 22 Sep 2023 01:25:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u0ubxym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:25:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvJBXHrKtXmNH4w8Jl90F+bp7hff8skIPnBfxqZmElttqJvslXLZqS5Ey0PUqyaD5DnuiTaFri80wOB/BXGQVw8bWh95Vj91pEggefB5+3DFTkFp3Jm+URzggC3s1hjTS0lGvgTSAPkZMIo8ROkuQ3RcONYzrOEv1dqp6Pp7GcYqSnPs1Jwi4BN7wa4URqIut6+Tw/iCMUpf1KXs+uimDzHvTSvmfkSli8UcE3xVneWY2g4ZG603p8+n8P8lhzxrlo2nnH1ZIjRdhSMd1pC9WbyIffcawo4SzyIwRJ4gF/KLrizbAX9Se9jA/JTxIF7f4Q/90JeutnZk2HJS+hjndA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffFlkq75v2oL6JbY/3XG0kgp3PX3JLbToGetKX8AAn8=;
 b=nQENsACXEolegaXSuVaFZElIZEaRYZKScmg+93ZoYvp3eZIekWbnPS2R5p8YTr4OnFrEGTWXka+Toyf+gyFTM6JS8DpwMcETHBWh/z38FrlKlZdoyKppFyz5AxOtwIrr3a/027IRcMDJ+11XSKPfHaPBOXvn+XcPXfKMYeuuxTfwsNVvSGQ8uPhiqTaSwoq5IGmxGcRGZfDJHfsxUbDA/4pKBHSkK2FD5mPdCg06JbqAtehxG0WEU8otT99Zh6+K9t3l6tqYPziRTTKhvcU2cQKGWqOxXLG4S2c44rn1Q/3hMODsZ+dyRoWNPnxyowdgm/a5dNjsT9QzAb5/NDQx/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffFlkq75v2oL6JbY/3XG0kgp3PX3JLbToGetKX8AAn8=;
 b=l+ijC6e8kUSsn5iRHxYiUvnT6Y5tyzJ9FNXZYOh0Vpjnj2d/88krssQa1S1jVgXW2OxgrVWFinPz1qqLaLhabiJ98uzX+TfJWMlDRrFkMPw/WHNBwHmGcoX7WHU7G1LHsNDEekIoGMCl/bWvoVkGIS1WjZpY3mim+/212EE/EKw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5813.namprd10.prod.outlook.com (2603:10b6:510:132::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Fri, 22 Sep
 2023 01:25:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 01:25:54 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v5 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18r8z57g6.fsf@ca-mkp.ca.oracle.com>
References: <20230921180758.955317-1-dlemoal@kernel.org>
        <20230921180758.955317-5-dlemoal@kernel.org>
Date:   Thu, 21 Sep 2023 21:25:52 -0400
In-Reply-To: <20230921180758.955317-5-dlemoal@kernel.org> (Damien Le Moal's
        message of "Fri, 22 Sep 2023 03:07:39 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0081.namprd05.prod.outlook.com (2603:10b6:8:57::6)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: fe2a9fb7-cd1e-4719-da40-08dbbb0add77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LY3gvGqoSFEAh9QkZCTiy4UFykM45P5f3eGqCfBoaYzetDBKmUplSfOI/bM1nb1dVTpYY/uppZ4NU3R4OdX2t90EHAqf+zxa6lMfupa9iH6/BVUtgbzDzU5bDlkLkZ9aDR33qb8izSy3TqPqIfd3jej9bozSyKuXNO+CT7q6M8rmUiw9r43xgetG/s3uQFnH2KqbYMc/vWJta7nNDW0T2QHFvYfQ+nMXgFyzRrKbqIXOn1mHtXMHIcdPSgJnuTX2r8eAv9JWUIdqDP7VeJeHbJ7jf6H+oU9rga49sEpbIkuToDGU9K2YH5J+bK6pHW41En3Aetm5BkhL1SNtEW7MombJ6XnDKLrb1oTVi4v7BdCX2gmJ+2YjYVREJKvxS7lEqEoskh6ury9f6zHaJmJV0kZegQBQVZ2ehYOXSebo12Ma2bEDzujXIRp1EgGDl7AMqeybgbj4kYHyNWiRQCfwkIWrwVBRsXnxuPB+oci0AWZMoJRAQLQkjwjuonDILZ5VdHD+Y2XTFU+Bqc4YxfX7SKei2B9BGqFZp2jw9sqRO6HllmXso9PBYwD6LLzXdVd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(396003)(39860400002)(376002)(1800799009)(186009)(451199024)(36916002)(6506007)(6486002)(6512007)(66556008)(83380400001)(478600001)(4744005)(8676002)(8936002)(2906002)(6916009)(316002)(66476007)(66946007)(5660300002)(41300700001)(54906003)(4326008)(26005)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G0Y9eXtrNgrJqbWF5e68nuVN4CRi/WQm3tLgnTP7rXx/fiOSy62a3vEDb0cM?=
 =?us-ascii?Q?kTiUkTzc1vgGOM44037nySia6Nuuc9jPKnCFyjAHl0ktrat8Gy2q1rW99tzl?=
 =?us-ascii?Q?z6oTCA/3T8JOnMyI3KRlCwnT1Bio1fnPk2b7ZRErnoPIZwVzmnlhDYJMEEfs?=
 =?us-ascii?Q?+FKOX0ct6Y+PgZdLUZwi/dYbCtCPZZZa1gZfPMshHftw0ZktPrawu8tfq0tM?=
 =?us-ascii?Q?l3GVXHmEl1REb7G5KVJDARIu5FZko2tfFTW6dGClhBfAS22HoI0Ybc9gHoxc?=
 =?us-ascii?Q?weoN5Ax9IGrfisMjTbzAUf7mAS6S/OSMKaSce1Zs4yqMuAMgNlLlYAV7gcU5?=
 =?us-ascii?Q?YdNhiGn0l2SkWTJnpvhyHt3tXCu81csMhtKVXbpZH/ururPxrkOJYHlRWCqj?=
 =?us-ascii?Q?fNr+VygCyU8qKEFvGvlwf3edEr8CD/wqCmoEzuAxjTo2YwiWIM9sqV6q+D1q?=
 =?us-ascii?Q?J/feufg7U1z6aE/T/g4x0ZCStWWrKG2Umbgg/+SD/houU6/3Jo3sza1MAxic?=
 =?us-ascii?Q?RTitQa0ZMgI145Q6E4QRh+noDhtkk2lVq6U0QUR/pFbwbIfFc51RIChZ+rZ2?=
 =?us-ascii?Q?x3PthcWnS5qeP4Qsh2ax9jXJ9cSVdWeG9M8tl1px0Vm9yjHcV+9GQ52IPOp7?=
 =?us-ascii?Q?+iTyk3ZM5E5Fw74AZCeomSn+l6pQjVyI2/PK06vAWxsL6o6Ax4N7VKgoWCHh?=
 =?us-ascii?Q?LvRJfnqBKx8FMWpifBx0Sn9+8iS5HMuzimSuupt5bBG9Fmlfd0PuNdXwZWCI?=
 =?us-ascii?Q?5K9GYS4JLBl4/iSmuER/NPSnIzySidQVlWxa3aKIZRbKKa48y2B4RIMfkrZ+?=
 =?us-ascii?Q?7/9poRgRI7KppWjDobFWjKeu69uxuyPYbBzJp/ebjXlzhcmUsjL06aX3QNwQ?=
 =?us-ascii?Q?5si/FN/JEDdhyyxIPpPcmigAsFDvx7mBA81BsoCZKXd4cYaM5jRYCuekaxcb?=
 =?us-ascii?Q?mDmzw3lbyrQfxuXidYSJicKe6z6oTLJM9os6R48gZt39LYh4vpyRbTdIc06x?=
 =?us-ascii?Q?zgzLEBetpdD9xXTP6plNHn+Stbp0qO7Eg44nS+5DeA4HT02BihpRZ50n892m?=
 =?us-ascii?Q?ny12Pvxof2kfyA59bWEjH+j/il5tu6DoIAbGoez39jB+lKdp9FJA/A3UTe19?=
 =?us-ascii?Q?8VRXJB4WbC74zzr3xNBX0coiKR97+fjBBHLmxd4R8ZvOuNHfc8I+mM0hoq3s?=
 =?us-ascii?Q?DyJORU2VQgjr35xf+NnJNQubKd04NQFME0zQhrToSTmEs2ipzYKVK7jif+Nt?=
 =?us-ascii?Q?8qYJNGzq2Nmue9df/z4mPbemuwpE3ZK85NR9mjlVHCImvRocZQtUf5+GaQQD?=
 =?us-ascii?Q?Ewa4MLJEjqAJ/imGqjD9LNj5elvmemigXkyATorXRYj1h/330jjlNM8MuPYR?=
 =?us-ascii?Q?WUs+H3U2ha7+IR9g7toX04XH5RD35AMZHHNr0CrxcdvEdR35llFCyQqV1N+R?=
 =?us-ascii?Q?TmFA60C7JplQ3Ujsbae6Mutz+9Rh5HMYyFRhASsEbS2CbW2pdN9aJStWIzv8?=
 =?us-ascii?Q?zD1WSTTxk3ZgskcBd5klN+/FZsAghlnlTCWyPGo2YYLhJuqUUneFN1RJocwG?=
 =?us-ascii?Q?EMcHY1uMaC4QV3Vp9cxOljhGMYcsRfO4Hu4BN8cQhouuNC/7PBfj7QEwEm3C?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?xrwkaGE2jcNB7o3/gfKhcSI2WlqWOENIMQstrlJQ2v/20KIA8kQ47epLapCg?=
 =?us-ascii?Q?r9K3aX9sPtwIZMnzwoS0VkP0BcUYEZq1ermxw7U4SWcw4ZdUoB/reCiQMmIC?=
 =?us-ascii?Q?8bJSQnhPAoCnx1C6F9R39YPTitBPNP6s/iYX8d/f9V5AZZrxtzxesB17IXre?=
 =?us-ascii?Q?Peu1HLPxrnYmm1UpieuRMx1SEyt/BAeLA31qoVkLkIBjK7k1LMuCKxLn9JC6?=
 =?us-ascii?Q?iVq80qCq+7PEKe4W4MzfzIw2UaPhi0qznkVHChD/MZaG5js3wutsiasF1pxV?=
 =?us-ascii?Q?9CF8AuFUjhvhwlN0wbj3UIxLKx21L7QNsjZ9MV0K6yeKJu4UB+xm9qjVqIWE?=
 =?us-ascii?Q?7fGGoQ+C/CJwxi7dx3uOPUlQEF1DPkxFmMOH65y0Hdo91IgIfSTd3RNOdVzs?=
 =?us-ascii?Q?3CSdFNZ48NDb6npGXz/t942/o7Bx3gK8rwH/023lbE+K9HxmRk8WoKDSc5lp?=
 =?us-ascii?Q?Gx8XLBwDefL+H2fScgP7zPOOksQF/2qxfGj0tXo9m+mIngBY3uLIRuoVjqWq?=
 =?us-ascii?Q?Vy7pGTlilVwAf8nP3XPydHB4KxuJMqdXcj9i+MW/25ljOg3Uph5DNrFP13Ed?=
 =?us-ascii?Q?U0hIWXbRdIz/IX6PaW4/DfWbTyQOFxnBRnC0U8/2vlqxhLO0yTxljp2dpdBn?=
 =?us-ascii?Q?rHrLFJo5Kl+Z8EHW2OddcMAQk3h1hWpdPgHinE1Ev5rCB8BCbwJUGj3HKCG6?=
 =?us-ascii?Q?9ghpqc2QMigmd4yTiavWCvzwXp3WZJjAu9TqqSUaOGC2HwczNguBA76DP4tw?=
 =?us-ascii?Q?HNPsMxDpvDvoMD4iRveueWmh15k6zLFl40SkFkNAm3b3G90AVRMPr1/ecEos?=
 =?us-ascii?Q?rIcNbcxZQDe2cNkX9xlzv0PK0qui/3LViFlKbd8U/mgVwdXH84gQulS+s+De?=
 =?us-ascii?Q?Or0A7HGWf+K9MiBGJBuefFEq0aWNYOXVdlP76MjV7rjp5ZKsqPIgTC2rkW+Y?=
 =?us-ascii?Q?7B+41dsOPRfst4061P498Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2a9fb7-cd1e-4719-da40-08dbbb0add77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 01:25:54.3912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S40R2KHgMWMMCBXTu9F8EYwY35NnkvaRqdG+j9B9G9+dnRtmSiBF0ch3xzUGv5QlUzsximds5Ja/KoeaxEXr/U1LwDXLV8U469XhTasjd10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5813
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=984
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220011
X-Proofpoint-GUID: nQ2mUmp2rdq2nyFItVggabUW0lNUsfkh
X-Proofpoint-ORIG-GUID: nQ2mUmp2rdq2nyFItVggabUW0lNUsfkh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

Just a few minor nits...

> The underlying device and driver of a scsi disk may have different

Maybe it's just me, but I always trip over lowercase "scsi". And you
write ATA in upper case...

> device will also be suspended and resumed, with the resum operation

resume

> requiring re-validating the device link and the device itseld. In this

itself

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c92a317ba547..1d106c8ad5af 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -201,18 +201,50 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
>  }
>  
>  static ssize_t
> -manage_start_stop_show(struct device *dev, struct device_attribute *attr,
> -		       char *buf)

Shouldn't we leave this for backwards compatibility?

-- 
Martin K. Petersen	Oracle Linux Engineering
