Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A22FC3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 03:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiHJDWC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiHJDVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 23:21:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C649082F98
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 20:19:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0Ds20026739;
        Wed, 10 Aug 2022 03:19:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=skH5XuCBdcfJ3OmZswXEOHvTYZWc066fRQzxEV1Hf7Q=;
 b=3KYO0cT1/Mpg8tkSx134Sr8Q55pdLDE6gFGw6T1TPxdiTir2nd3X5kohSUzFcIZi1nSq
 dgV/t/oaW0SPDhW6j1TEXK4mYEUH7Bs348jIVrHgX3pMkTA5h6BSXAr+PqLpVwED69V8
 unb2TxW/UBoTd2GV/t+S0bk9AJql4k13a95XEFDz0ZsRkKztSAz2wD1NsHmkU/eVkDwW
 hkVozMZL4JuS9F1eyiyDiG7Tk8yfckQCkWDTluH1OdVJkJMt9Ht00/aVOOc+wQCw/qYs
 4ntNcIe+5EZ0XVhK2No62wuxnK+dkbP4x8LYADzJnsEh1mNARnkNg+J4R/EuiDTs53lU Pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq90q7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:19:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279NmuT6019827;
        Wed, 10 Aug 2022 03:19:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhrka6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:19:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdvepP5uDHgverxKSs7e27VEeWF0bTndtcG140OvPbO5bTcPdOO2Lrd2gMLw3xcEFwiYflEgAbEjTqqkOdO4NSGpJxxCzECmejwVoAJdf+EdkI1YjD7ogHcThbL51aOCdEwjRRjpPE7/fKp54MJPPyJNnlORdoEpOPzlLE0Yvtg3JREZ/Xpf7bhV5Uf9fMmNV3SaNvRmIRCEOWit5BNPDLcShg0VDpDfDM5BLmmUFGWK/GrZyNZSVcjVw+jQJlL762h7S3rE3k+XDTw7baCbKlHFtFuUvzTNTAmvP1PLXjFUdusXsIeRagkXLAql/tJ3SQhaMMQzBNlNY10jMgDf3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skH5XuCBdcfJ3OmZswXEOHvTYZWc066fRQzxEV1Hf7Q=;
 b=OJe++3l9bh3/QLfPkdjQG3sSPF8GUau2+CNA9MMJfbfLFV1eDCC/yTuHk10NT8IAOmmtlW/EpixpIoeTz3hJOx0AryXrr9TOsmIvGYn2K/eJZKZ+3hgSGJ5cdYQBk7mnx6+Kfzbh4ZN1YYvsvO/ZxsW1PJEkv8IHR3zm/EcxFESkSwOgFNSzF6zXgvae5bgY3ItOQiHrOrBXsbVP1CsP8DJ3NolFi1zo0uUWFLnok5aimho02pUhGtivlgBmk2Nct/1zFstBTWbDhzKoHNrVS0HI82q9UYsGzInNOlSOZPZZObanc3D47HY3ioIA9Jlve8Z10CEXBsr1XY+dbVjQ2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skH5XuCBdcfJ3OmZswXEOHvTYZWc066fRQzxEV1Hf7Q=;
 b=GqPLk1pPpcZZMFZ4ahZk4KW2/UKwB8/2AuIy/QX5p4CqH+FQ43qwg3Yfl8r0dzmn6rSW3rsa/RAWBbg+Vc5SB7l6b7hDEYKGTBohE37NpBLVXZAFfw74FaJQYSoMkZes8wxt0Qyy2hihjn8zXD5ubiTKCRIUqg0Pd9XQnfOwW/Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5376.namprd10.prod.outlook.com (2603:10b6:5:3a9::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.10; Wed, 10 Aug 2022 03:18:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:18:59 +0000
Message-ID: <da423d85-e4af-d4e6-4da9-8fc5f90c5cdb@oracle.com>
Date:   Tue, 9 Aug 2022 22:18:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 08/10] scsi: Add error codes for internal scsi-ml use.
To:     Bart Van Assche <bvanassche@acm.org>, jgross@suse.com,
        njavali@marvell.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, stefanha@redhat.com, oneukum@suse.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-9-michael.christie@oracle.com>
 <67db6828-0e1b-83ad-9c4e-1fbd736e39b4@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <67db6828-0e1b-83ad-9c4e-1fbd736e39b4@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:610:b2::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e176aec1-ca20-469b-ed99-08da7a7f10e8
X-MS-TrafficTypeDiagnostic: DS7PR10MB5376:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TZbIwbdM2jqTlt7Li3BYX4sZa3BxgfCCT+Q5bOQ8NFH6Jcs+kJ6JCdSYS2HDCvhRVt58TeGSxm4I7FO/riLOJMHJlI+ubmUQb4pPYLgBR1zw3MqC+Ck+iNwURqR9GeGX+SDyk78omtUXon1l32umBNk/vOOGaC4ART/rDno6UBG4MyWmePTj+szvhZAucAPvKB5+hBSUwtrHe7XJ83N7QbM/y+dxisRz6c8JGqrWUHqpweF/G8jQ2B+LvTlZUuxFIXYGVthST3EQcXEE4+V89BAJnCPGhszHBjsunNG3XGjhMzs1ONaYSNQ2Rx3WgxTYrkScL4uiak9d4R9hFOXbDtG09fgWfLuesHj9yPTQKp8B1U8ghLmTi1K1CPfCeMpSkMaA2H0ha7lt54eg27nh6hGlXr5XYbzbX65h9aoTwuCamURmeYgqjad+ooMsRphFUYkLlZn/zcOov9HYzIe37d9Pw6sj67qY15SLEUDu6XefuHlzNxk7XPo/CWACxv/E6tgEkDClHxU1TzoPAu6ll0ZIqbc2QCjJKy1aIsahje61vt5T3HYexHN/Mw1LAdBFcOhQ70d1ZvsnWVxTJe25Df44tiv9PxjaV1Y9iEW1IHKOxDLZeH09HPKG4soBWpTh0Us6TtHC3FgRN/mY31+bgS8LOy3U2tKNmZfajQq627Zc6XMk3ePqaK/H8GZoIiVncmWg+84HvhhiG45nYaGBdYXQn4TK3pULYI0tFaGVoy+WY26khODNiZXai+oJ/NmI/oM7YNYME5ygflTowKLcfvxmu2Cqb2xaOkMEFNreNiC60IHnnL0nsZA48UUah606GWh2Ns2H017xtwcuSZXttBJPeJKAb9OvAphZuJAK0m8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(346002)(396003)(366004)(478600001)(6486002)(8936002)(26005)(2906002)(6512007)(558084003)(6506007)(53546011)(186003)(5660300002)(7416002)(38100700002)(41300700001)(31696002)(316002)(2616005)(36756003)(921005)(31686004)(66556008)(66946007)(86362001)(66476007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnRWTEtMWjIvZy9vVW10NmxycndwdnlaUzMyK0l0eS9oQmVJNGd6dWxMaEMz?=
 =?utf-8?B?blFnREtUdXhjTFU5N3ZJQU42RHFJcG5EMzlTVHRyU3FwSWFxRDZJRFdEQnor?=
 =?utf-8?B?TGYvMnQwQno2ZkdjU3J3VmxwNUpnSXJLcyt2c0RUOGRNUTB3NU9CRWR2bFd3?=
 =?utf-8?B?SVk2d0xFVGNxaEJ1Zi9MaE9hUU53aUhsdG9IeXd3RjVmQTBjTVViNXZBLzg1?=
 =?utf-8?B?Z2QrRy8rZ2U1WHdURktXcGtieWt3dG1VNnh3Q2RhWnI2dm9xWDdRS3NjV3pT?=
 =?utf-8?B?TEdNNEFyY2ZFbmpneGNza2p2U0w2SGVGT0dEOXhqUUJrUEpaOE5nMWxjZTJN?=
 =?utf-8?B?aHZVSHJjNVdMREVHZ29qekNuNDlYMnhMOTRodGwybDFOTDdUUVdSK3VDVXNT?=
 =?utf-8?B?K2ZnNmxYdkJ1YS95b1E3TVVwVkhSVW52ZjFIdFBjMGJuendyT2VyRk9sN0xy?=
 =?utf-8?B?b0had0xVK0Z1TEpCejNDNTZPNlZ1c0JHd05zNHo4RXZBSW0xZUE2azM4WmF1?=
 =?utf-8?B?czlRdklZdHBzOE5sRWV6a0I1RTlhUTA3K04reWRvajk1bHBtYWpIOHMreTdl?=
 =?utf-8?B?OEh3OEIzL0dzQklVNXFNang3ZFU1UDBUb3phTmp2U2Z4T0E2d2t6ZHk1U0ls?=
 =?utf-8?B?a1RyWURSZnFXOWd0dGdqQmdVYmw4dzk3cDFnY3B0dHRBajAzU3hNelovYVNx?=
 =?utf-8?B?T01WRkRaVWVoR0d3NUc4RWoyNFVxaU4yS3UzUGdwSkIzQ1FROUYvNGdDY1pm?=
 =?utf-8?B?YUY0Szd0M3hlQWlEOSs1RFQ1L0xrdXNIT3h0WmVTQUNxa0svOTgzd3NhdTJw?=
 =?utf-8?B?b0h0elBhUk8xNEZraXNlc3E1VkRUUnU3U0EvVm50SjF6Y1ZjRXVianlEa2V4?=
 =?utf-8?B?OWwzYWhTMUJ5RVFYYllDV0JURFJKM005YldWNWwyWVBNMW5KR1lhdXlxWVor?=
 =?utf-8?B?VTZUaUR6emlDNnlQT1k0cmRDYnhLOEorYzVhWDZPNHd5b3d3TUt0V0ZySkY5?=
 =?utf-8?B?MzdwK2RCcS9MRE1YU0ZTK2tDYVR0bUNYZ296clRQZUpFbGRpRlQrajJGYi9P?=
 =?utf-8?B?VkhvaVVodkRKUkVKVGdQem05d0JjNzBvejdnSUsva1E0aHloMGtjZ003SmV3?=
 =?utf-8?B?Um9RRG0rRUp2Q05haFJsQU5yRHdFait6aVQ4K2tVZVlnZGo5cVBtWlpNRHRq?=
 =?utf-8?B?OHVDNkpjZGFLaHZJbXJIaGV4bURpejFYWGpuMkRrOTRiZ1lQTXFJcDR5bmI3?=
 =?utf-8?B?eFl1UFRSK21aM3hhcFUwMVdrdzlyazBDcU9tK0VNMlBVcHc5bXltOHp2NFVY?=
 =?utf-8?B?RmlzSE00RTdqemdrV2FPekc4SmpZc2xKVmNZaWdGcEcyeitoQjMyZ3FFMkVQ?=
 =?utf-8?B?RDF6TzExRmZXUzI4cGFiQkVHQ3NHcFplUER3UHFDL2Z6OWgxam9EWkxJOHdF?=
 =?utf-8?B?eXdYZU0wOS9taEhwbXJzb3NMbnNuYWQ4MWlPSzNQaEt0Q0RJaWdZUFE5bFIr?=
 =?utf-8?B?ZjQ2Y0U4eEQwaUdZbTFJSmVhVis5TjV1ZC85N0paVERQQXpIam9RRTRrODFF?=
 =?utf-8?B?bUp2WXp2SERndExja0ZqbldyWkJRTU1UMzdkVXZ2M3F6c2kyZytRUlVWelFr?=
 =?utf-8?B?dkh3QVBLQm4yUU43bEtEcDRlR1JkcnM2a0hSTGd0OXhZdkxob3BSdElLa05H?=
 =?utf-8?B?Q0xFUjRpeEIxcENjc2VZVUhqTUFLRVdDeTVRaEVJZTdVSEtSQ3ZpUVVzNlJs?=
 =?utf-8?B?OUlwYVlHNlluWG9CWlNyS09vWDNJRk1taGlKeUdVOC9wb25mMkd0a0xFNmxm?=
 =?utf-8?B?RlB4QnFVSTlaYS81VmM2R3dQeGpIZjN5VVl6YmxBVWs3MEZsY2xLbGVvcWtj?=
 =?utf-8?B?ZWNiRXYxZjhFUDZYZmk3K2MrRDVjZ3o2cTNhM2RFOTdOckFESmEveHJldWtE?=
 =?utf-8?B?Umt0OUY0MkZKcEdnTm5xZzkzNC91QnB2VldZbHJSTUJGa0hYWmdVVHdhci9J?=
 =?utf-8?B?YWg5TlVLdHV3ZndtbHBVdkc1ZGZqR2YwbW1hWEhXd1g5b2dWVW03VW9zdkNl?=
 =?utf-8?B?SUEwaExRNnZzbVFoNG93cFRROXJBQmJIMmNDbW1US2lTZDRrL0VCTmpuWU9N?=
 =?utf-8?B?NGtuaER0djNOUDVyRElIKzcxUG5zNFY3bmNHcDhOaFdQa0pVakhqa05vTUF5?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q2FIR1pmZmN1RGxhN0NkMUtjWnJRZTkvTXpjVDMvY2Rua3FobHJZV0xqaXY5?=
 =?utf-8?B?WUV5N2d3cWJoc3NhNUZpcCtraUd2Rjc1YUdKTUZGdHNURWEzOGdZdmw3K00r?=
 =?utf-8?B?eWV6ejZDakFCNnc4b0RKTmhlbTdOQXpmMWJMeXJ2VTFQb09lSjcyVytZNmtH?=
 =?utf-8?B?dVByV0FzdEUxWXphNXNkZHBlMEIvV1FhMGxNakRHOThwY0tBVVNleEN5UWhQ?=
 =?utf-8?B?c1Q4V2s0Smxxb09VTEo5UHA4WHo2QlhmTE95TWxYUXpUYlBPUnprUyt0Kytu?=
 =?utf-8?B?UmVTbWJQRFNpZmtCWmR3NVhwSksvR3B5RWpQbWIva2IrNTZqTmlwaTVYVHhI?=
 =?utf-8?B?TEpJWVVxSVZXRXQ3S1VZT2xpS2RnN3pkMnFJT2J4cGJYaEZGTFB0aEV3MndV?=
 =?utf-8?B?RExQU00yOFcycnp3SjcyTDVVUXFwSVBQcVl2MjM1MURhODJLbUFqOXo1K2Ur?=
 =?utf-8?B?VUs3dzVwN0RKZWNMRnhBVDVyNDlhR2NhUEtTY1NSMG1KNnJpbCtkdjBFRXJN?=
 =?utf-8?B?aWpNYTdYYkVMYTAzNS9LZkU3QVlzNisrUndjTDg5T0xYQklqL2FqeUV5WEx3?=
 =?utf-8?B?cXhRUFZnTU1wMmJSS3RVb2paTlg0cTloWFFpMjRXdkY1WUVsM0tmb0xrcldQ?=
 =?utf-8?B?SVdma3RaM2RGZXV5K3pvQThrd3Brbm5MK1pNalJUK09VdDFGQm4vRWVtR1pp?=
 =?utf-8?B?Um1iZlF3bUtvV1NIZ21zeno3YVpBWFlVRUc0a2xybTl1cjJVYkl5K3d1cUZ1?=
 =?utf-8?B?Qm1YT1JGcGMzczNId1p2K0NheGV6S1RsSXZWYm9jcndlNC9NQmgxdzh0bmMz?=
 =?utf-8?B?VFUreDQ2TmpvSGMyQ3R6ZDY5cG8ySjAybWFuRTZBbml5bkR0U0sveWFLTzNp?=
 =?utf-8?B?bVl6YjhpRHVjREYwSTd4NlJpREZPNUVxL3h4NE1WeHdkaUc2UU84NHBleDJX?=
 =?utf-8?B?QTNWVlVPUVh4N21BeHhJSGk2akh5K1EyMFBlWnNkTktEU2psc1ZEOHdQQVR2?=
 =?utf-8?B?NXp2YjF2SUUzNnErMVY4dGhxNDFLcGs3R29aTWtkbWVvNmJmZVBneUhyeEta?=
 =?utf-8?B?NGdnck9Hc1Y4bmJ2dDhWR0ZUWWVFYkYxSHdsbE5rQVFYRjFEcjRqODNsS2xZ?=
 =?utf-8?B?cHo5dk9EZWpGVDh5cys3TVN0b3RKQmVqQy9EL0RtV2srSnlTeU5JZmhLSUNv?=
 =?utf-8?B?UkxDY0VQR3pkRE1aMXBZbTNVMGRsUEdzM1MwOG03NHNXMUhpNW4vMjRJYXpQ?=
 =?utf-8?B?aDBnME1wdmMrbGVCQXdHN3VsMVMzSTl5WUE2Zm1BZ2ttSW9WRncwSjRnczJm?=
 =?utf-8?B?UVg3bFR6Z2JHNkRYZ2tBTkVKNjhWYWNSL0dmTXh1NEErYjd2TnpvYWdDdGk0?=
 =?utf-8?B?WmdVQUJxMUZOYXFERTZGd2toVjFGajFSTDVnT2NFakpXOTBLZzNVSlhwMnNi?=
 =?utf-8?B?ZjNtMzFka3pwbUlyYnFrRnk0Z1BwaWhZOGdWTUZzWjNxa1RhcXBIWGc3Z2tU?=
 =?utf-8?B?bzhEZlA2V25EMVFRQ1pDRENkcjVCV2tYNWRTVnJrVHd2VG9lbmxPS1lWRGlO?=
 =?utf-8?B?T2h1eEtwSUhZYjNjaGYvWE1VUlBkWThLM0VrajFKRnhmQ3Q1QmVMMVpkdWtm?=
 =?utf-8?B?QXdkTEp2VjBPUVhoWmZjYnBPd01wU0VEN2pHMVJibDNzWno1dGZPV3R0eWlU?=
 =?utf-8?B?aEdZa2tFRkVTR3FMZzc0bUNhZVpOOXZVNHVOb2ppbzNiN0dPS1NOV0FheGVZ?=
 =?utf-8?B?bFJJM3VFSU4yZzlMaGtZaWk2eG0vYWNoTXQ2ZnBFdmdpeTFVR3I3anRockVN?=
 =?utf-8?B?eEFtRHZaMC9yVHhnQjRWb3hJelNYUVcxakxCMlBZemJnQWl4ejZGMiswbTYv?=
 =?utf-8?Q?p1OPjFu1lJisU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e176aec1-ca20-469b-ed99-08da7a7f10e8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:18:59.2607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EwTR3H0rqma/DUjGBi4YosKz2oLEEb7U4XGyeWnWlC0YHP7NhTOjthlMIR2LfOi/bOoqm+0CufiDZ7HI1vWaaZMQpcVFHH/A64I/uCSNXs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5376
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100009
X-Proofpoint-GUID: 5OToFrWZRJR-6cD5h0WK8g9dGT7HLRUZ
X-Proofpoint-ORIG-GUID: 5OToFrWZRJR-6cD5h0WK8g9dGT7HLRUZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/22 3:13 PM, Bart Van Assche wrote:
> 
> How about changing "SPACE_ALLOC" into "ENOSPC"?

I have to resend for some other comment, so I'll do that as well.
