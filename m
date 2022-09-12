Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE7AC6FA89
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 17:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiILRtg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 13:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiILRte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 13:49:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E122DF0;
        Mon, 12 Sep 2022 10:49:32 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CHY3iB000804;
        Mon, 12 Sep 2022 17:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VJ/GwHwr3j9YDRt/ZFSWkhF5o2FWO2DetRIyQtkrpIA=;
 b=LPr7N8rEqvqr79sXWVG2v/xOrJZvmm8ei9wc+/gSC79NDme+P+hJCMIgOpiRCVhTvLxO
 84YtoN1h49FtoMliHoCRgWtUEoQJudihemIH9VQoZoXRGOOZWaAU2eN51kxosIa6PnlJ
 2EzYUGRCei4IS4wXsWpWMnhsP54t8EwwsC+O07ZaXGageJM4Ipvyl9g44cTrk8chhE8D
 PpkUxNv+Nhg+RQXhN8Vt25a9cxDJOt3/YiAfudy8JvWj0IaAvtDQHznaIdeETHL9JjR9
 WnBaf1DaA8GXG3PxmsCY2EfrKGjg4lLbCSJl08Mc69hgb5Tulf7e6aBvDoZVP1dFyODY ZQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgk4tc9js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 17:49:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CH26ol014566;
        Mon, 12 Sep 2022 17:49:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgk8ngry6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 17:49:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LK3A4vqtW3hAEJknHWaFNBjqB5P/uJzI59zcvC9M0Yfn2GmtfD8ZEBDHnJlRwoGapdHWdi2q0kfedUOHGJWUPH/63e0DYhSIe6Hnyt619FbVLvBnebzknS60rzQERf0L4fxRYQvuBkqI8APogerqng4j0FYpCfsk7j+p9RWngz10ZEkdb63vkcCMbm2IvaRFht9fGX83Tdl6gypM5Bfp7PATEEMdOndndc0fz3uzBHNfYqHdDbWanFkZuFPIily/fqtDmORndrkTLJvqr+iOy9mfA+hy04zecY0heUVA/W+mZoNbtrsZKAznOhWBaLqBN65z9d+wA4cMS6x0EvDXow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJ/GwHwr3j9YDRt/ZFSWkhF5o2FWO2DetRIyQtkrpIA=;
 b=YY2ZiB7kp/RhTjJIy8SI54UbNrrgQf1Sx/e1OXwWCdzbQArUdW1rJhrVDdYcHhqyzBfK22A1lUFLyKx1c7TnxwpPVKQjXNg3wFx8bk5DxKtx3IW5P8qHytnJqrRodAzm0G3aPYCmy2pAXI39cJo0ukZfcGK0Go0OMoVu1RyourmfwwCh/WShH1HaymFqVQdW8zdd7gbJ05aDPcCJoVpPGQa0H8y3ZCbPKo0zGyzeE1E+jiAbQRdMcnVxqrzpklnzTXEaejbaHUsSol+ah+czDZQaUPGMNkPxCZ3GJnnbmMPi7QSj+8PDqYP0/nsrqAlmHcGfQwQuquG85s6wmek/dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJ/GwHwr3j9YDRt/ZFSWkhF5o2FWO2DetRIyQtkrpIA=;
 b=Rlmy52PRntp0vAJP+Tk4LkJ0P4lDHwU2qShDQe8sgqejk7jzAiiWXTHzHFdxpH9lSC7GVS5z3cH0Ah2s+/W8eouOg4UZ0V5uB+WZSZMMS2ZenSW9UGXx4gmJRsAxIRVOqkMrJVZIXJKcIvo3b/sTJbWBbhyxcjMTQPkGdV/QbQ4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5665.namprd10.prod.outlook.com (2603:10b6:303:19a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 17:49:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:49:24 +0000
Message-ID: <92f6024a-7898-e281-099a-c79b67fecafe@oracle.com>
Date:   Mon, 12 Sep 2022 12:49:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] scsi: target: alua: do not report emtpy port group
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20220912125457.22573-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220912125457.22573-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:610:b3::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: b5742bcd-3806-452e-27d8-08da94e72126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m6HViekePwT8FabrZWlsNVHve1CViP4jF4kvu+EjEWhi1gFWyXG+SlLAvFSkPT72lljUdSeDCDMNWvvHDocaRGg4KdJKSnS+Sn53/l7LUwTp+4CY2RHHQcy7Acxdjg4lY9MK2dtc+H3u2tepnxXnDmxqAyyP0odMZV5by3DpofAOM97+dKHON4Rm8B5bgu6Rh6gMNEZU9nWqhMVr30oxXE5W8TbFL1yyB1QnxwWHH0e4tdF8gcRNhDR5/AUX9fuRf59Xlv8Np9XIj36FX9vjKcJEA+xF++dsAZXY/CYLq4VLPKaQW9tVOXOvo84PYTPTu8tyoIEWrExhOCR+TaMebP/2acOqI1wpDclKjFDGqARfIssZo/OGMmvuhC1SHMUE/x2LGL8e4jQ1T3Mzzt/ZqUAdLHTh+zf+iMd6k8YVX32TVXtuib/+tZbYjCQ08R/oTytPfoTwCTUsQt8v/XxJ/PiSj903ippbxCul7kXjDB/itAh1hg8+4HiGcqbCZnavxgFmaHqL6q7bIJ4X4tuCSPV95sHnpk07lMvnSJj2T7rUy5XDFLLvWEDJfpHdGQqdug5xfnYgp9PF1Ln8TdoJoZQO5bOAxtT5gGI6wzViu9eO1uIe2/2o8wMbiSqfvK1DZNlI63wpVdYfzqczfIGlf8wKiL0JU9bhr/ccJVOSY6qnv6xXO2oDxIvZ6rrBskQEMIBielQ58SDw13ynio6UEC7+8/CXFTyvtSIKFdiGBUJVu1nIoo5sVc8ctkxyK5chDdHKr+gM4NVt4Z4+2bJPlbTsSJcna9+yoPayvQ6V5j8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199015)(26005)(66946007)(83380400001)(8676002)(53546011)(6506007)(478600001)(2906002)(6486002)(31696002)(31686004)(86362001)(66556008)(6512007)(2616005)(41300700001)(316002)(110136005)(66476007)(4326008)(36756003)(5660300002)(186003)(38100700002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXRDaThKVlVLTTQ3eVJTT0xlWTYwcWpPTWNHVkFrSFdmNm5CdGg3RjJpMTVn?=
 =?utf-8?B?WnVDMlAzM0VTMjk3UDRSWTZ6dTRHZHFrSnViVERrRE9ZUE9VbE04Q2lCY2dD?=
 =?utf-8?B?bTNGVm83N3UvUkxCakpiZXRuN3ovU3B2bTl4enI3Rnk2SVVJcUE2d2Y3VXlK?=
 =?utf-8?B?Q3hyamgxZzE0WVRFQWkvNDhmTHpuN0cvdWZxbkdkTWdzTHExSVdrWDV1L1FO?=
 =?utf-8?B?ODhSaEMrV0dxOENkTlRrRXczdmR2WG5PUWM0dEJWQzZEYUNZellyTFd2NXU5?=
 =?utf-8?B?OGJwVTdEd3hpdlE0QllFUzlxcTNWc2k0aGFYbXhGeVRKQVFUNUwrVkpHdlRl?=
 =?utf-8?B?cTFEeFJ4QldKN01PV2tnSWg0U1kvWTNSUm5aK3E4cVZLY3RqTDhiV09aeDVB?=
 =?utf-8?B?UTBwUzdDZWFOMWgxcVZmOVZoQTVqQzRSVGViV2UyN3JQMlIrQXJzN1NEZzFR?=
 =?utf-8?B?N0hKeUh4WFBMVVlUNWsrblhNSHFvcnNHRU8rRnZlbkRxTFhna1dXMm1oeEFF?=
 =?utf-8?B?YUI5ajFZYzJkK1poajVKTG43UWF1aklWR1hMTVRWSEQxTVdWWVZqaDhlUnZV?=
 =?utf-8?B?SzF1MEtRNGFZcjNaeVFQMTBXekFHWHpESGgwMFRtb3pVRzlKREpzYThlWlg4?=
 =?utf-8?B?cnBaT2duRnVtcU5OckRkZ3kreG9mZUlhUVhtYnRkL2FCRWpDU1E4UFIyRTBu?=
 =?utf-8?B?TXo1aE04TkZHM2xzb1B0QmpQd2dBQ254VjFvZFhOQkJHaDdxUGVtdEI2MGZQ?=
 =?utf-8?B?RklNSlBkWkNrZWlTcWoydG54QWdrL2pvcFNWQkxEZ2YrdHprdnJaUWppbHgy?=
 =?utf-8?B?QWtSaHVMZ2J6bFUwMnU1cjA2QlBTc3JzWHRlNnNibjBSY2xQOUJTUlZiTTF0?=
 =?utf-8?B?L0JTckJxTzZsVzFNYjBqVmFwaUlMdkFYRFR1WHh6Yyt5Z2N4S0FhMThJK1hQ?=
 =?utf-8?B?ck91UTJ3bXBpYnlUUWtVdmUwaUhmcks1bVVrV2o2dCtETGhKN2J4ZkV6ckNo?=
 =?utf-8?B?M3RINkdIdVlHWktNOU5DSDNRQlc1OWVEOW93RzlndU0wdFZRZmVsaHZ2L2Fm?=
 =?utf-8?B?RXBRZHk2U1oyQis0M21oUXZDTWgzbWFRYTNzM3BNb0tNTDZmSTRvNFRZaVJV?=
 =?utf-8?B?QTh2eWdCa2FmcjNHQngwdkdOOUxBVzNYU0sxTnJaSTJXbTJDNmZwcnhKL01Y?=
 =?utf-8?B?Z082SDZwMXYrK0NCTCtGOWE2dm9FMFBJa2g0ZCs2T2VubndrcFY1N1pHc2s0?=
 =?utf-8?B?UURtZHNGck4wZ0padzRWV0JqLzYyTnhrbDU4cXZZYXhtcFBmQi9xZEYwK0w2?=
 =?utf-8?B?Q09kaFFvTTNydUY5RzZNNHNBRC9yaGJkS0xmQ1RFQ3NlT0kxZW81dzBtSGlT?=
 =?utf-8?B?akVYYUFaaFJ4dG9UQVVIaFkrUXBiYWdzcUJRV3NYWUJSQW9lR1hmdnRVb1JN?=
 =?utf-8?B?SlpsZFYxVHE2eEVrRmF1aHU2Y0hNYVRseVRsTkoycEdQMkVqTVdFeUhtOG5P?=
 =?utf-8?B?Q0NGT1pEL0pjQ0llVHgyVkxtTnJDMEFlRVN5WFlrSHVCekUxb2NtWThMNVpJ?=
 =?utf-8?B?RTdDZk5pOTBJeW10Y2JtYUxFbjVxRTFqSFVXdjQwcCtxcmFXSUcrd0lIR090?=
 =?utf-8?B?MUNhQ1c3Y1dwTVZubE44cEgyckFPMWE0YnA2bGE0TFJ1cmFnNTFtR2tQK2Zn?=
 =?utf-8?B?dk11T3gyN0lwdzR4c014TC9EYUNDckdlbXdqY2N6bTkvY28zRW1mQ1NwenhN?=
 =?utf-8?B?OERXWFFjcDZzL243aUh0OHFUZTRRWWVObkMvUzhPQm9XMzZkTG9CeEZvM2ph?=
 =?utf-8?B?OHN0NStuVEJkNW94RDgvYWJ0RGxjZ01RK0NhZnFaa1g4TUtrR09wdEx6OEcr?=
 =?utf-8?B?Umw4dG1VVE5OZjh5NEdqZjcvcE1mSlYrT1ltM3l1bU1IQzVvbnRIUThYSTZU?=
 =?utf-8?B?YllhWFVFa0t6VFNvT2NTNEovdmhnWFhRR25MOUdhRHQyUEhoUnJXcTJSOS9a?=
 =?utf-8?B?Nld0WHA1RmRXdGJsbkpHbGhGSy9Za3dmYW1jbzBraHQ3ajVKZno2R1BSUFY0?=
 =?utf-8?B?c2M2YTIzYnpJdy9nRS8xWW1JVk1UK3dTS1VrWWtvTjZ1cnJqNy9ya1dTOTFq?=
 =?utf-8?B?S0N0NDZ0VEZwNmU1Z0syYTF2SGlDYjNNUE44cXBRRlR1bDF1c1QzeENZczFp?=
 =?utf-8?B?YlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5742bcd-3806-452e-27d8-08da94e72126
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 17:49:24.3038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+QZgdEO5CGTmopbaCw7R0d/kg1Ji2AOeM1RDG8jX9h8zclHjLYkdGaiigW2nz/kGHWCyWcKewQpQKtcPtHon5vcsjVOv3CeaYV/B479uIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5665
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_12,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120061
X-Proofpoint-ORIG-GUID: CBvPbWQolm4bdEsRoDSanMu15MW-TgUi
X-Proofpoint-GUID: CBvPbWQolm4bdEsRoDSanMu15MW-TgUi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/22 7:54 AM, Dmitry Bogdanov wrote:
> Default target port group is always returned in the list of port
> groups, even if the behaviour is unwanted, i.e. it has no members and
> non-default port groups are primary port groups.
> 
> SPC-4 ("5.15.2.7 Target port asymmetric access state reporting")
> states that a target MAY not provide info about port groups that do not
> contain the current port through that the RTPG is received.
> 

Where is that? I see where it says the state value for a group might not
be up to date when the RTPG is sent through a different port. Are you
taking that to mean we don't have to report entire groups?

Note that I also don't see where it says we have to return every group.

Remember how ESX used to send a RTPG to one port and expect that it got
every group and that the state info was all in sync (basically opposite
if what's in the spec now)?

The spec and ESX were updated, but I don't know if other OSs did this and
if/when everyone was updated. Do you know this info? Are the old ESX versions
that worked like that end of life?


> This patch hides port groups with no ports in REPORT TARGET PORT GROUPS
> response.
> 
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
> v2:
>   new solution - just skip all empty groups
> ---
>  drivers/target/target_core_alua.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index fb91423a4e2e..c8470e7c0e10 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -164,6 +164,9 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
>  	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>  	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
>  			tg_pt_gp_list) {
> +		/* Skip empty port groups */
> +		if (!tg_pt_gp->tg_pt_gp_members)
> +			continue;
>  		/*
>  		 * Check if the Target port group and Target port descriptor list
>  		 * based on tg_pt_gp_members count will fit into the response payload.

