Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EBAE7D0A4
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 17:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjIURtK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjIURs6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 13:48:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877B364599;
        Thu, 21 Sep 2023 10:31:06 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38L9UP4U002741;
        Thu, 21 Sep 2023 14:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=lnQOra2Ky22O++fARLx+EH4WZLethJrjIBIkp8m6Jrk=;
 b=uSnfgCiFOVRrotyHcjBlNRLPPketC62Va7Ib4a54TfXsI9YHl7zbYC2LwRYNRHWY2dmg
 MW6qNJP4BbZiwFxqfGE3sEolb+9jwYGruWEDk08n4unQrWCTguGWIaj8tIG+8uQ8waum
 jZrA1Sktt18OtvxFyAYY6fmfTqzgfL44PTtiInfyooJSGj/uU2oLl34QLjrQhyDwZEev
 W8qnNrP4tXrO5Htnlt+fgMr4mw49+T4vToZqWbBu7tLCJ7EMupMFZVb93KNp5UfcFtja
 EisQxBM4zm/CqRON41GQASiF/SxI7PLzn16baCX8orCyoK47WfeQGwThj2zHfRvqFD5Z AA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t54dd9tk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 14:01:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LD6W7g027078;
        Thu, 21 Sep 2023 14:01:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t8v4r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 14:01:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbawfCnTOa0t305G4P8sUKT9tVQJxYY+5hN5dH+Q/X2GRTP3e2ENmbPBlWgroTLJaCuNZNKXJigLnEYcfG3widuOKIn9nfO+epBPEHMZelFvd+lKa/UhIDe1Pz0KQUyt8YxiWML3C/TXGWsQXWWxnQnjN2FzT4/KiqbOhKJRi60yQgH/vYqoewroZdlp5j2zkTTOJvAoZ6Ja8JPZhJp7AKl7z4F3T8kToFXUOhWB9IILkWqOTkeWgMJ1XNqWE0sXGJSNloLaUjLFUTciATxJdRzZMkjsS0SFIwj6hOo458hi0FEpefHtI9HmoQ1D3xFmc5FCWv4IffB4CZdRtA7vRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnQOra2Ky22O++fARLx+EH4WZLethJrjIBIkp8m6Jrk=;
 b=nGBmJ4ciLkQnV+xSMJvIRAC+rTlM4rRv2bGgBngv2Uq/NPR1/Xj+7aDE+0n/WhCqXK7RSp9+ULxr1OqwE0lCIP4V8Tw4inFBqlWfrfwf2zHSobrxxociLSf+zPpROEm+UYPLDSgawQfc8gRrIcG3iPxjnpEt1iTvl08Hx6QUd+LWXIxbWacpOonjObwkEa4UZc3dcw7NrOR2UWCj9anNiEUk4ItRwjVGeFVspnA8um5A8v839l988A7DreP13TV0P6zokxX1C5FlCoa0saWOb6bZgrj23MA2Rox0CR3pKBPbeDr6sKo4KT5sReYPkY59QtiawSk32WovBW7qsXKjSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnQOra2Ky22O++fARLx+EH4WZLethJrjIBIkp8m6Jrk=;
 b=K0jRF6wp3ztLemOTV+jcPAOzj2JibIoScTPp5e77upfbaj69D8wNdpZ+ZX/X/Jbmv/FcyPpa4pnfQ3G8EpNQkRXcGQSaEgUOS1TxAa/JQyOHKB1DtHREiYW4p/DW+l+LIUgciJifo0LieuZ/aBSMdoH/WP12jyhUqqT8qpb/8qY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4989.namprd10.prod.outlook.com (2603:10b6:5:3a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Thu, 21 Sep
 2023 14:01:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.017; Thu, 21 Sep 2023
 14:01:55 +0000
Message-ID: <06749e66-45ba-f9f6-44d4-49aef60559a8@oracle.com>
Date:   Thu, 21 Sep 2023 15:01:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 08/23] ata: libata-core: Do not register PM operations
 for SAS ports
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-9-dlemoal@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230920135439.929695-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: ba5a23bc-67bd-406a-5513-08dbbaab5018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tj7i6xdHprq+ZcH1m4wvKoHjm015acVGdVnrtXRGrTNsdzmW1RreeeZ4Nigd0vQDaVMv4NXWljH0cKVvivc6eQhA+qSQk1aY4gEMNpTplI10dUEQiMAvGrgtI4vuMbUjMp7524ikachOGg+8Dm9aVqRkdgpTclaI82Xl9JWC975hL0DJbKmbKl18sYqX8VYwm0uV7p4otBtVMQFnmxDzTv/caMHuyP/kBNO8Ko1MMrU5q1L2F1MTtdTneRc5608RDe5Wydl/Lz4tuF57znHQnurleDp341Hd470VUHexzS/PteL8Qqtaku+3ijiA6Wzup8hZChMEKoVjxIV+WeYdnMDYHeYHTs9M7CKyT4jALZSa7wblHsx7v+P3reecZzREIQdf3Y9r5USfm/bMOHnEC7Hy0pmLUjpBxOoMtFbW1fkOdVFncli7uZ8GjrmJLQiFHGM5ylxb/IzR7NGPqjkJqxTuVGOdxzcNme3pJxrsx5tS8JDrhfbAGw6jOeQ74ZjgHS6eOlmmhp6fywa3AnUFS7ueKE0vtaUZWu+WReUD2RJiyvszU4m0+ZhHflbsOTDXfUdPOlpLcrU+FjbMua1fCUrWaLf4cmT5Y6E02l451n5CBWmkE+UVExGgdej6+OdfIuPfEFVu1AWgwJRBp+fAjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(136003)(366004)(1800799009)(186009)(451199024)(66899024)(83380400001)(26005)(2616005)(66946007)(66556008)(66476007)(54906003)(8936002)(8676002)(4326008)(41300700001)(5660300002)(6486002)(6506007)(6512007)(36916002)(53546011)(6666004)(2906002)(478600001)(316002)(31696002)(86362001)(36756003)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUJRVGpJdFR3V3NGVFdhbXFvSEtSUkQ3NXJOVjZsQiszay9ZdXIxS3lBYXly?=
 =?utf-8?B?Q20xclFuekxCUlhzcHB4UmRKZ0pnb1o4TE1nd0ZTdlRDSG1ETEE4WGdTanFt?=
 =?utf-8?B?WUxKOGxhWFFTZ1ZsUHNBeE5DQWR5SERNTjNOYWdUbGlsRTJleUxyTTRyK0kw?=
 =?utf-8?B?c0QrZ2ZrYjBEYSt2eC9KclBwc3NPN08zcmdhdHRUVzdGbXJJL3VObFMwZ1Mz?=
 =?utf-8?B?b2EzaVBJWUZGRkU1WHZ1YlUvWEZaTXVBUjRyK0ZqYTI5V2owb0JSeE4xbmpi?=
 =?utf-8?B?SVF6eGFBS0k1Y3FkSWR0N0FMYXR4M212RzFYNFBIOUdLWi9EbHp0bDltczNL?=
 =?utf-8?B?SllsMHdrVjBNUW9yNTQ2V1l4bW9tWUFPeno5UjFaOUJyRkJ5RSs5QkhpaGNM?=
 =?utf-8?B?bnc5QWFRdC9ha0o5YjhENXp4bVpaa1RicW0rclhuQUg5NkdJeGpKOUlFV1cv?=
 =?utf-8?B?aUxLWUM1d2tGZ25BUVhtTFVIMTRGa1I5QnJGVmZreTdMQ3A5UGlGNmt1cmtv?=
 =?utf-8?B?RnFrQnU5eWY4ZU1MS0NpN015ZDNIeHFIeE5GL0J3ckQ0QVdiNURVR0s5aHpP?=
 =?utf-8?B?ZVB6RjRCZ2JmaWhxWU9tQ05aNzZCRFB0UnNDVDIzSVZBWnFaWU1tYWF2b3Nh?=
 =?utf-8?B?ZUM0SytWWVRYQ3pBRktYcFBCUHg2Ti92dWZsZkJJa1NFeUxSUDJkWEIxTFBF?=
 =?utf-8?B?akdjR3JLUHdXcHE5L0h4ZWtvWXNWME13S1IvaGNRdDdBWUxCUUd1TVdFL3cz?=
 =?utf-8?B?NHBkL3pFb0x5bnJtVHFmQk9DMEo5d0llN1llR211Q1V5UW1ERFRuWUNTclpW?=
 =?utf-8?B?WXJTTWlCU2ZEQnI2bnRhdzhNdzJhTEJqcHRUL1REWm5KZ2dOMG1vRUdmQnc5?=
 =?utf-8?B?VGlMM1lHYUxFR2doeFNpNG9hN3Vzb0FCdGdZMjd1R3QrU2hYRjBCMHBDUElV?=
 =?utf-8?B?N2V4YUx0Ti9lQUxOdTFkWGRtekN6NjM1SU91K0VmN3ZYS0JuZmJnczNxa056?=
 =?utf-8?B?VHBCTHJyQkdybFlMd2hyaWFiUEhITlpjUHJiYXRyQnMxVHlIUjBEd3hsS3pE?=
 =?utf-8?B?dWpvdTIwQ1lLWE01ZGhtL1VJc2IxU0ZYNkQwQWV4MGRHY0NrcWExUnNXbEdL?=
 =?utf-8?B?MlFJRFhBWjZFayt2dTNQNUVHUGJYN08rS2x0MHdKK2pTN3lldW9IU3l1Qi80?=
 =?utf-8?B?NkJYazhVa1JoRDhtck5HQ0dsMVoxVVF3dENCZkhUM3JmdVhESlFveUQ1TTlB?=
 =?utf-8?B?b1JzbVZuWE5iNGZXcmtSdElwZ1hrV2ovSEhoQ3lqYkVMQ2U4Z0JpU2VkWEtn?=
 =?utf-8?B?cGo1bDhmQ1dQSy9VQ1FDWUVvNk1KZlA4YnppRVpDZUUxUGZNc1dCbXlpSDl2?=
 =?utf-8?B?QUJvZkFVbC8vb1dRL2w2NUFnZ2hWMHB3dXZmcUpERnZQK3kxdXBRMlYyb1ha?=
 =?utf-8?B?SUZuRWNtc20wUG94dkNleHh0ais1ZkUwQTNZNEo5aHFsc05JR1k2K1dWbUJ3?=
 =?utf-8?B?TEZjRnlWMmt6RmI0Q01VcHR3elFGdXhNRnovbXdKNUoyWEhjTHA4VFd0bTNy?=
 =?utf-8?B?QzBKeCtOZ2l6RHdDTlNCNXoxWXdEby9PU3hiOVlONUk3Z3RnaVlBMjFZVHp2?=
 =?utf-8?B?K25qL0szU2FJRUFYQzllNjNHNUtnK2hOMWlua2NuUzd4dVdEdUZpSERnaGFs?=
 =?utf-8?B?UkZ2OHVmbEprWXhBbUEybk1FUkt6UkJWbklaOXRoYk9UQktVUHl3RklFbEJ5?=
 =?utf-8?B?SUFGZEIvVEJlckQ0VTB6d2RBdlRHeXUzR2NBYVhkd2gwUmR2d0l4bkhOVEE5?=
 =?utf-8?B?d2FReHF0K3NVcHhjMDRvRldFc1JLSnJmckQvNnVnQlcrNlBBZnlPSFQ5TFJV?=
 =?utf-8?B?NldvRVg5bm44T1hFeU1jUEdQT0xpREg4WmNBRGEwb2paOEtMNGxVTmVkdWwx?=
 =?utf-8?B?Ni9tTzZqMkphMm1GQW03Mm1qMHhnSFpQSTdUaURCQlo4T21XeEtybjhRS0tn?=
 =?utf-8?B?WE16R0NDWGVodzQ0bHBZZXBrblpPTGlvNWZTcW9Ib2g1VHBJUlo4UWI2KzlP?=
 =?utf-8?B?MDRMKytTSUtuYnJmdUU3ZFFjQjhBYU9nMEhoUm8rbmJrUVk1VWtra0Jnb2hP?=
 =?utf-8?Q?loZzzkDumo63NXVzwvO9hzHyp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UWplYkNTV2RXdHpRaUZlMXF3Z2VkYmR3ek12ZmNJN1hZWkdzT25OL2E3L3NU?=
 =?utf-8?B?YTE4WEJsdkxMRDlmNXo0SEtzNlBxd1ZxU2RXVGE3TzVVNTZuSnlEdGVTWEl2?=
 =?utf-8?B?bXo3MTdaaGhNYjJHbU82WXJKV3hFbjZ2bkw0VmpXNVJGaVcvdnNkTnd2Mmt2?=
 =?utf-8?B?cVVJM2VyQXM4N1BXMnRSMkVHUUIvamc3NGp3Tk5SY2M0T1dYSThHc3lJdThn?=
 =?utf-8?B?aGVkYjhPcVNOak9hb21TdzZjajMwTC9KcC9ZRy9TdGJWdloxeVpIOFg4cTlw?=
 =?utf-8?B?Q2lnS3FzVHRPUHQ4QTZWRW1YQUpZUDVHVmlKMEV3THoxQUlLdkZvSURDeW9D?=
 =?utf-8?B?ay9GbHhIQjJGcWgxM3dBU3dTaFJIL1h3dXVuKzRqcFNmT0ZyY09WcW9iRkg0?=
 =?utf-8?B?ajRCcFU4ZUxNTCtDSTZUSnZKamZZN2MvdFQ3eWthZmxvVjBYQTN6VDV6dUlt?=
 =?utf-8?B?dnAxQzhYVHJLbkpaT05Bbzk5ZDM2Q3pMZitudHMrVjNQeXN4VVJnUm5SYmdr?=
 =?utf-8?B?YUE4eTdUcDlYQW44WHh6aXRpdkt3SEFVbWRVelAybjA4RExTU2tmSGlUblBx?=
 =?utf-8?B?YThwWkxGTVBvRStjcDFJd0JYSHNSai9FdzYvR0g5Q1lPOCs3N1FjUHRqbEJ6?=
 =?utf-8?B?UTVVUFpqalBHSUw4UkNYSzdhWFBXTGJsWklvT0tlS0xLN2tWN2tjamp0OVNL?=
 =?utf-8?B?R3Nvd1JPK0RjMFRvUkszNitoU0F3RzNnVm95RWJSamYwcDBlQjlPL3dhSnlZ?=
 =?utf-8?B?WmFrc1FGdWs4N2NjVExDNGFJK09GWTkzVG9QQ1hVUHJ6elU5VlZlMHUxUnNm?=
 =?utf-8?B?R1JqcUtTM1A2by9tQUxhL2ZLUi9rUG1ubUlta0NkYlpmbmdwaitJSjB2Mm9l?=
 =?utf-8?B?REVSb2QvWjM4TzA1TmNXWEpaNC9JdlY4SFFmeEJnQjQxT3lTcW1TWDROMUJP?=
 =?utf-8?B?QUNvbXBKMzdtMXZEbGNLWllpcDhyaGtqcjc0MHAxUE5YWmQ4SHBGV2hBL2ZO?=
 =?utf-8?B?OTloSERLVGtzdGFCa1N0L0FWRXNZNWRTejJiQzJNdEh2bkRXcWNSbDl6eTNF?=
 =?utf-8?B?Y3ZkcWFWbGpxNkdXOEs0UUp3TVZYMCszQXNBMVZRMFF4dVpnZUdSclJmU0cw?=
 =?utf-8?B?dHROY2lNUW42a1d6ekN5L1VmWGQzMGg5cCt6SXROOGlZQmFGWjZRT2J6YXZI?=
 =?utf-8?B?b1hiQXlGeno3YjZBdUF5VEpQN0J0VzJvS0tYUGd0ZU0zV3BOQm5xWGNheWRs?=
 =?utf-8?B?QXlkTlFiWnVqUXBEQUI0NlEzcW9EU1lSVzVCdE1HbGdQNzhEdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5a23bc-67bd-406a-5513-08dbbaab5018
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 14:01:55.1763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBJJizytCBvbHYtfFLVhINX1Sfq+Dk6YP67ujp3meJZTY0FwmED51im1CNulHAnCL4VTUTk93ViLDUYlsGpaNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_12,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309210121
X-Proofpoint-GUID: BLo17plgesBi8LrA0gVNPTk2xZhp26kw
X-Proofpoint-ORIG-GUID: BLo17plgesBi8LrA0gVNPTk2xZhp26kw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/09/2023 14:54, Damien Le Moal wrote:
> libsas does its own domain based power management of ports. For such
> ports, libata should not use a device type defining power management
> operations as executing these operations for suspend/resume in addition
> to libsas calls to ata_sas_port_suspend() and ata_sas_port_resume() is
> not necessary (and likely dangerous to do, even though problems are not
> seen currently).
> 
> Introduce the new ata_port_sas_type device_type for ports managed by
> libsas. This new device type is used in ata_tport_add() and is defined
> without power management operations.
> 
> Fixes: 2fcbdcb4c802 ("[SCSI] libata: export ata_port suspend/resume infrastructure for sas")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>   drivers/ata/libata-core.c      | 2 +-
>   drivers/ata/libata-transport.c | 9 ++++++++-
>   drivers/ata/libata.h           | 2 ++
>   3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 092372334e92..261445c1851b 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5335,7 +5335,7 @@ EXPORT_SYMBOL_GPL(ata_host_resume);
>   #endif
>   
>   const struct device_type ata_port_type = {
> -	.name = "ata_port",
> +	.name = ATA_PORT_TYPE_NAME,
>   #ifdef CONFIG_PM
>   	.pm = &ata_port_pm_ops,
>   #endif
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index e4fb9d1b9b39..3e49a877500e 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -266,6 +266,10 @@ void ata_tport_delete(struct ata_port *ap)
>   	put_device(dev);
>   }
>   
> +static const struct device_type ata_port_sas_type = {
> +	.name = ATA_PORT_TYPE_NAME,

It seems less than ideal to give different device types the same name.

However, from the definition of device_type.name, it seems to be used 
for uevent, so I suppose best to keep the same at this stage.

Reviewed-by: John Garry <john.g.garry@oracle.com>


> +};
> +
>   /** ata_tport_add - initialize a transport ATA port structure
>    *
>    * @parent:	parent device
> @@ -283,7 +287,10 @@ int ata_tport_add(struct device *parent,
>   	struct device *dev = &ap->tdev;
>   
>   	device_initialize(dev);
> -	dev->type = &ata_port_type;
> +	if (ap->flags & ATA_FLAG_SAS_HOST)
> +		dev->type = &ata_port_sas_type;
> +	else
> +		dev->type = &ata_port_type;
>   
>   	dev->parent = parent;
>   	ata_host_get(ap->host);
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index a5ee06f0234a..c57e094c3af9 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -30,6 +30,8 @@ enum {
>   	ATA_DNXFER_QUIET	= (1 << 31),
>   };
>   
> +#define ATA_PORT_TYPE_NAME	"ata_port"
> +
>   extern atomic_t ata_print_id;
>   extern int atapi_passthru16;
>   extern int libata_fua;

