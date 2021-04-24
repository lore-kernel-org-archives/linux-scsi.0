Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D6AC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 20:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF5A613B6
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 20:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhDXUft (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 16:35:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49038 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232546AbhDXUfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Apr 2021 16:35:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13OKZ3aw020169;
        Sat, 24 Apr 2021 20:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qsnRqvDcRBqX0RMef5VPVL28ZRnAaL/YLhF0mZ+8Ymc=;
 b=mrHlT64JR3LkVFPlHYh3O0ASuNzI7kNJH31joFGAZbUvYCf2iW5CarHL76VF7y995TM1
 NeZckKWuiXtFs7A2UPRw7CGBFKpvO4qjhA2S/nV+4YTPxJXgs0FzhcuzWhBJgcCPlNKx
 FbvjRS5R13yiNL/I3r2Ni9NUdSD5W9XEHgAZGDsV80W+lAYIhEoZZ+tXTLsAGSnwA6hZ
 YpjydQ/KdMdsrpQ9G1A1Qr3oxaqOi3HdN+0XExUBTWIFFjqtytIQAJMFujkiPVsnlBAf
 IVaprCn6S8UJDUpOKXN7nDJ79/c11u7q7dWbHTQFVjcFgnzPknpoANKRtgQg2LeqCOPN 5Q== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 384axrg6q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 20:35:03 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13OKZ226015149;
        Sat, 24 Apr 2021 20:35:02 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2055.outbound.protection.outlook.com [104.47.36.55])
        by userp3030.oracle.com with ESMTP id 3848et12gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 20:35:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIZDpGhFOzQBg0dPHxOQg1uPB9PMq76WlA0/UMw9/nSE3ZgyFwV6GsanHNPUeoBmOmghpU7X+TFKtTCFD10QiLIa4S5Oq6HnJgkbudlhGMmyAQ4cwKoWVzcmnhoxy0+0PQMnUu1YjHe8IHQX8EdYTgZ/fBesEbcKvqqoCWMkhsjtY3v01nkdnCa0dy0AwrAC+PbuXtQ9nyEMgVw9QgzuukhpN5CCnyNVntn0nKSnPzEkU6e5f+oOefvV87Prkzeguu1Q1a/FRbfuFspssex4k4SzTjZ0fVVZr7Fml7mg94P2n+b6SXmeG5QYAMbDrRky5J/wV7+0hjEqhjmtcVB8BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsnRqvDcRBqX0RMef5VPVL28ZRnAaL/YLhF0mZ+8Ymc=;
 b=iGjwJopxVNF1o0u7ZwVCf0fw9yZlzWyj3G5s48NrceFZnAmecQdXy1XDdms481dSMMAAxCdVxxSS+QwUiXCCbh8wVoAGRoXvzJThohGMtaU8v4z8CLKBusqCyfeXS9uEopzQucFnlRnkP5eDANaoS5tvJ1yh1usvvokiWZaCrJ2O6F0moffejeCws6eTjLNLqvQUcosOFw7FrEYKJCl6I5cRTX57TfMXqV1Y4KJdnHst5PXO6BKRAkvaUvKvAeuixdaFR3QExgLN101399c3uizvLLfmod5u3KObrsOdpFK4LiqxFMsNb025BcBIgu+Gjbf5kI8HgMl2nanOIILeTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsnRqvDcRBqX0RMef5VPVL28ZRnAaL/YLhF0mZ+8Ymc=;
 b=tWZy8h5qSJU4pHXzLoOSu9qh+pbINgmov59xa5mY0syO3v4zaQE6DMEsO58NMk8CT+GVZ+nj7/ysboThHb3MoeTo1zzJUweSTr64+AYH91FjStPfV3Lmsu77BygLFXqCSZ0beIShQBEoZNZ/yIzaP7dRM9XVet9yXpdd+AesTBk=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 20:34:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 20:34:59 +0000
Subject: Re: [PATCH v8 25/31] elx: efct: LIO backend interface routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
References: <20210423233455.27243-1-jsmart2021@gmail.com>
 <20210423233455.27243-26-jsmart2021@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <3d7836bd-04e6-e3b9-66c8-05c66a82d105@oracle.com>
Date:   Sat, 24 Apr 2021 15:34:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210423233455.27243-26-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0170.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::25) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0170.namprd03.prod.outlook.com (2603:10b6:5:3b2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 20:34:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ab2aaf8-af02-40fa-001a-08d907606daf
X-MS-TrafficTypeDiagnostic: BYAPR10MB3287:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3287438BD3A5B89A2118AAB3F1449@BYAPR10MB3287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:422;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5nukmMwFTRvuvFboVR5h1x60KCB1YBsPYQRRuKM/yg1A7Y0KJpQT+ZlRpJhPtF8iZdi6ke2Oov85+bIMbmQ49y+9Exf9s7sR1CULzPXJ2wx8HVLeAnOhok0aYrgwRvMgUSm6+V7g0TN8s90tOvVdqfqsfz3ycMhWhFcQLQuRMiSgws7noSdWZ5l/0v+DPiv+XJ5+MrxU06BpgrnMh/gUqD76a9Ht8imKLywXNhohhiPNDbZYIByDt3X77G2+VrIp4NdlsloBdbMEdQSJ+hCHNcfCNwFCDi4DTjf0WkogGoDn7AsTB1i2iJB5UkmRwb/t+VL5xzjTxfNPSZRWKGAcgwS/AlUZd49bTgjqS1Pi46vpc8v1MskLcW3IhH/rQIqlAPxg8f2ribR6qj5irbFh51vx6c88D+IbS1JSCtpVlomHwqqDGslwryBDp6uYFuXLFCck3UPZ5oa/ghvtYLGEie/3PYRu89NwilOd3l/tP0JJkJPwNWmafPaFhPV/sNOggTHh5mgULD0nvZls1LXlczmRjDIm3rBY1eAcEe1pP20BpvJ4bw8a3QAbd25wjwxqzCACBJPx3JcaFGk5qkr0OHGpCOjwdghTTReBWlW2B+0toA63SZVt8qw7W4dUYmB3XOjQ/hQqDVgcMCTQ3WKxtjK/i1TB556zy68iuR7vREHvXJhYdqoGR5Ah5AJKOov8BdmnDgM3onoci1w2Q9Yf1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(39860400002)(346002)(4326008)(66476007)(8936002)(66556008)(16576012)(2906002)(66946007)(186003)(83380400001)(8676002)(478600001)(6486002)(30864003)(26005)(2616005)(316002)(53546011)(54906003)(6706004)(956004)(5660300002)(31696002)(36756003)(38100700002)(16526019)(86362001)(31686004)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZXZlTHNaSURMWXBvREF4akovczNwQlRzMFVyL0xPbDFld0pHbmZCOE4wcTJH?=
 =?utf-8?B?ZDhMemFBSGF2Wnhvc0wvR0lHaWQzVU9aVUJSNDRIUXc2SjcreEdkN3RUSlFR?=
 =?utf-8?B?S3VodmZ5d3IrUWt6WG5zalJDS2pDUlhoeGZ0Z1hyN081bUE0cWhEb1FmZ3hB?=
 =?utf-8?B?akVjZFl1Q1hDM2xEeVg2QXBMTXAzV2RPaVl0QUhUWlRCRnh4U3dhMEk1ZlBO?=
 =?utf-8?B?VVhxaHY0bDdlSC9BVjRUd3dFcjlHZFcxMHJyWmFTclF2SjJNdUdUcnBMNXEz?=
 =?utf-8?B?dmZaK1JwaldtQjd1WDB5aVdLY0ZacXdERG9UZVJNeEJsNjRwSkVBdUZXQTF3?=
 =?utf-8?B?ZWI0eWw2ZXpEaFhacmJ2dTBYa084TUk0cjFtUDg3TE5ubHpNZEpYeE44WElw?=
 =?utf-8?B?eEFpZmlOczVobmZmNEtTTkx3ZWp5NDNxRDgxVitJL3p1cXZCWkZaRlRJdjIz?=
 =?utf-8?B?YktzYlA3S0R4TEk4aVRvSFgrb21wVytDYzk4ZmFFYnJQaHBPbW03azdQMUlj?=
 =?utf-8?B?NWxDM01aT1J1aVRwT1VSdlluTWtheDJFeUZOMTExdmVzNFYxWWxCckhvTU5v?=
 =?utf-8?B?TndMbm1RVTRwdFVwMzk4a3VTanFIb0hXNVoyVUlRYjB4dG5oZ3Z4UzM0b2lY?=
 =?utf-8?B?UFdqQlJobjZsSFRRb1N5ZzB5cGttZ3Erc3d3UVlyTjViQ1haWVRWQkNjeXpq?=
 =?utf-8?B?WW1SZTduWVpjRkpWYjZQaE9sTkxkS0VLWVRpVFViTUpKcFpnbkNxajAxY1dj?=
 =?utf-8?B?WldGcmEwNGlKSDhlTGJNcEE2cEVBN2N5THk5RWgzajZxUVpWakcwaEJ2VkVG?=
 =?utf-8?B?WHNXamtmUXFBeVVCcDNDeFA1d1lFSTJ6YVFZQXFNcUJCRFBnM0JVUGgwNlZ2?=
 =?utf-8?B?cUpVR0R6SVd6bUVROUZNV2R4NmEyVTV1a3lVN21JR2FyWVBrNGNmRVdtRTJ0?=
 =?utf-8?B?Vmk5QUV6aU9vWU50YVdnaWIrWlorQzlqMVZJNk94Q3lpRXBWOTBzWE1vRE9K?=
 =?utf-8?B?NDBub3ZPWGFINThzMjBydTE4VmJYQjYvWE1HU2NSeVorZUR3UUk5WnNVZm1Q?=
 =?utf-8?B?R2dya3lNZXJDSmpkY20rQjBZbmRHS2h4TzFPZFk2U1YzRUE3ZXA4UjRrbTVU?=
 =?utf-8?B?emh4YXA0dTZSSnJtL3N2dVRzcTZWck9ORkRHYjdNOGVYRmJtM2VoK3VRcWdI?=
 =?utf-8?B?bFJJMUE3MjdYcTVGWlNhaUI5dnNGYkN3Z3pRV0dsNWlCbW5uMkwyOHdTYnRY?=
 =?utf-8?B?K1o2aHA1YktjNjlxRHptdDRVbnA4V2xZZnh3ZEFPMkZURlRSZ2kwVVhER0g5?=
 =?utf-8?B?RlRFQ2o4YU4xZ2dYbkVmU3Fyc2VJT0luSlo2WjV2blgxRHFkNWhNaDE2MW5N?=
 =?utf-8?B?L2Z5MnBHd292Uk45VWZ2MVBKSm9aVE84MURuVVJKck9CMXFrckNseE9uVlBE?=
 =?utf-8?B?SlZENFY4di92Z2JROHdzMGJDbVZNcThDNGNQRzVHYU16ZFBLa3FyYjUzQVhJ?=
 =?utf-8?B?ek1RdGtvUVhkVEhUclAzL0N0S0F5bmpIeUN0T3pkZ1Q4TDlqSnB3VnhNNFFp?=
 =?utf-8?B?VDFORlAvWjcvK21lZm82VUllbUN0dWZMa2dWeFdkRGZXZjVhM2VmR2k2N2Jh?=
 =?utf-8?B?SVZQQWlnSjM0WitQMWEyZFBSN01Idmt4OVl2emE1NjFJTkt1U3NNNjV2VXox?=
 =?utf-8?B?S0pTb3kyZU50c2wxcGZCeDJBQ2lzaUNOQlM2eHRJU05GQzNoZ2JCbWRueWl2?=
 =?utf-8?Q?EcC7qnIzB5VxnUDtuGAGIlmjZ/tuDP19eQcWXsT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab2aaf8-af02-40fa-001a-08d907606daf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 20:34:59.1504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZs/znnxB9dICtEqxJD1MfMdy7PlUISfIeg8qV1G5oeC2KI2sRHB48C3aNFLxcBaJp2DT36zHlhH2qYWFpKs+WUVeUdVMxTfr2QiZTyY5ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3287
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240157
X-Proofpoint-ORIG-GUID: zo2ONC6n9DJNCKo1JhLd6XF9QdmD4BAE
X-Proofpoint-GUID: zo2ONC6n9DJNCKo1JhLd6XF9QdmD4BAE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 6:34 PM, James Smart wrote:
> +static ssize_t
> +efct_lio_tpg_enable_show(struct config_item *item, char *page)
> +{
> +	struct se_portal_group *se_tpg = to_tpg(item);
> +	struct efct_lio_tpg *tpg =
> +		container_of(se_tpg, struct efct_lio_tpg, tpg);
> +
> +	return snprintf(page, PAGE_SIZE, "%d\n", atomic_read(&tpg->enabled));


Did you use to use enabled differently or is there a bug? I couldn't figure
out why it was an atomic.


> +}
> +
> +static int
> +efct_lio_npiv_check_prod_write_protect(struct se_portal_group *se_tpg)
> +{
> +	struct efct_lio_tpg *tpg =
> +		container_of(se_tpg, struct efct_lio_tpg, tpg);
> +
> +	return tpg->tpg_attrib.prod_mode_write_protect;
> +}
> +
> +static u32 efct_lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
> +{
> +	return EFC_SUCCESS;

I'm not sure if you meant to return 0 here.

Most drivers have it hard coded as 1. iscsi uses it as a global target index.
qla returns the tpgt value the user passed in.


> +}
> +
> +static int efct_lio_check_stop_free(struct se_cmd *se_cmd)
> +{
> +	struct efct_scsi_tgt_io *ocp =
> +		container_of(se_cmd, struct efct_scsi_tgt_io, cmd);
> +	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
> +
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_CHK_STOP_FREE);
> +	return target_put_sess_cmd(se_cmd);
> +}
> +
> +static int
> +efct_lio_abort_tgt_cb(struct efct_io *io,
> +		      enum efct_scsi_io_status scsi_status,
> +		      u32 flags, void *arg)
> +{
> +	efct_lio_io_printf(io, "Abort done, status:%d\n", scsi_status);
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efct_lio_aborted_task(struct se_cmd *se_cmd)
> +{
> +	struct efct_scsi_tgt_io *ocp =
> +		container_of(se_cmd, struct efct_scsi_tgt_io, cmd);
> +	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
> +
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_ABORTED_TASK);
> +
> +	if (!(se_cmd->transport_state & CMD_T_ABORTED) || ocp->rsp_sent)


Are you getting cmds here where CMD_T_ABORTED is not set?


> +		return;
> +
> +	/* command has been aborted, cleanup here */
> +	ocp->aborting = true;
> +	ocp->err = EFCT_SCSI_STATUS_ABORTED;
> +	/* terminate the exchange */
> +	efct_scsi_tgt_abort_io(io, efct_lio_abort_tgt_cb, NULL);
> +}
> +
> +static void efct_lio_release_cmd(struct se_cmd *se_cmd)
> +{
> +	struct efct_scsi_tgt_io *ocp =
> +		container_of(se_cmd, struct efct_scsi_tgt_io, cmd);
> +	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
> +	struct efct *efct = io->efct;
> +
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_RELEASE_CMD);
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_CMPL_CMD);
> +	efct_scsi_io_complete(io);
> +	atomic_sub_return(1, &efct->tgt_efct.ios_in_use);
> +}
> +
> +static void efct_lio_close_session(struct se_session *se_sess)
> +{
> +	struct efc_node *node = se_sess->fabric_sess_ptr;
> +	struct efct *efct = NULL;
> +	int rc;
> +
> +	pr_debug("se_sess=%p node=%p", se_sess, node);
> +
> +	if (!node) {
> +		pr_debug("node is NULL");
> +		return;
> +	}
> +
> +	efct = node->efc->base;
> +	rc = efct_xport_control(efct->xport, EFCT_XPORT_POST_NODE_EVENT, node,
> +				EFCT_XPORT_SHUTDOWN);


Sorry for the lazy review comment. I'm just checking the lio entry points.
Does this wait for efct_lio_remove_session to complete?



> +	if (rc != 0) {
> +		efc_log_debug(efct,
> +			      "Failed to shutdown session %p node %p\n",
> +			     se_sess, node);
> +		return;
> +	}
> +}
> +
> +static u32 efct_lio_sess_get_index(struct se_session *se_sess)
> +{
> +	return EFC_SUCCESS;

Could you hard code this to 0 for me? Every driver but iscsi has it
hard coded to 0, and I'm going to kill it. I've sent patches mixed in
other sets and just have to break it out.

It just makes it easier, because we do not have to worry what EFC_SUCCESS
is and if we actually meant to return 0 here as an actual index or were
trying to indicate the function was successful.



> +}
> +
> +static void efct_lio_set_default_node_attrs(struct se_node_acl *nacl)
> +{
> +}
> +
> +static int efct_lio_get_cmd_state(struct se_cmd *se_cmd)
> +{
> +	return EFC_SUCCESS;


Did you want to print the tgt_io state?


> +}
> +
> +static int
> +efct_lio_sg_map(struct efct_io *io)
> +{
> +	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
> +	struct se_cmd *cmd = &ocp->cmd;
> +
> +	ocp->seg_map_cnt = pci_map_sg(io->efct->pci, cmd->t_data_sg,
> +				      cmd->t_data_nents, cmd->data_direction);
> +	if (ocp->seg_map_cnt == 0)
> +		return -EFAULT;
> +	return EFC_SUCCESS;

Did you mean to mix in the EFC return codes with the -Exyz ones?

Here it's fine, but I think in some places you might be returning EFC_FAIL
which is 1, and then in lio core we might be checking for less than 0 for
failure.


> +}
> +
> +static void
> +efct_lio_sg_unmap(struct efct_io *io)
> +{
> +	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
> +	struct se_cmd *cmd = &ocp->cmd;
> +
> +	if (WARN_ON(!ocp->seg_map_cnt || !cmd->t_data_sg))
> +		return;
> +
> +	pci_unmap_sg(io->efct->pci, cmd->t_data_sg,
> +		     ocp->seg_map_cnt, cmd->data_direction);
> +	ocp->seg_map_cnt = 0;
> +}
> +
> +static int
> +efct_lio_status_done(struct efct_io *io,
> +		     enum efct_scsi_io_status scsi_status,
> +		     u32 flags, void *arg)
> +{
> +	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
> +
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_RSP_DONE);
> +	if (scsi_status != EFCT_SCSI_STATUS_GOOD) {
> +		efct_lio_io_printf(io, "callback completed with error=%d\n",
> +				   scsi_status);
> +		ocp->err = scsi_status;
> +	}
> +	if (ocp->seg_map_cnt)
> +		efct_lio_sg_unmap(io);
> +
> +	efct_lio_io_printf(io, "status=%d, err=%d flags=0x%x, dir=%d\n",
> +				scsi_status, ocp->err, flags, ocp->ddir);
> +
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_TGT_GENERIC_FREE);
> +	transport_generic_free_cmd(&io->tgt_io.cmd, 0);
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +efct_lio_datamove_done(struct efct_io *io, enum efct_scsi_io_status scsi_status,
> +		       u32 flags, void *arg);
> +
> +static int
> +efct_lio_write_pending(struct se_cmd *cmd)
> +{
> +	struct efct_scsi_tgt_io *ocp =
> +		container_of(cmd, struct efct_scsi_tgt_io, cmd);
> +	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
> +	struct efct_scsi_sgl *sgl = io->sgl;
> +	struct scatterlist *sg;
> +	u32 flags = 0, cnt, curcnt;
> +	u64 length = 0;
> +	int rc = 0;
> +
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_WRITE_PENDING);
> +	efct_lio_io_printf(io, "trans_state=0x%x se_cmd_flags=0x%x\n",
> +			  cmd->transport_state, cmd->se_cmd_flags);
> +
> +	if (ocp->seg_cnt == 0) {
> +		ocp->seg_cnt = cmd->t_data_nents;
> +		ocp->cur_seg = 0;
> +		if (efct_lio_sg_map(io)) {
> +			efct_lio_io_printf(io, "efct_lio_sg_map failed\n");
> +			return -EFAULT;
> +		}
> +	}
> +	curcnt = (ocp->seg_map_cnt - ocp->cur_seg);
> +	curcnt = (curcnt < io->sgl_allocated) ? curcnt : io->sgl_allocated;
> +	/* find current sg */
> +	for (cnt = 0, sg = cmd->t_data_sg; cnt < ocp->cur_seg; cnt++,
> +	     sg = sg_next(sg))
> +		;/* do nothing */
> +
> +	for (cnt = 0; cnt < curcnt; cnt++, sg = sg_next(sg)) {
> +		sgl[cnt].addr = sg_dma_address(sg);
> +		sgl[cnt].dif_addr = 0;
> +		sgl[cnt].len = sg_dma_len(sg);
> +		length += sgl[cnt].len;
> +		ocp->cur_seg++;
> +	}
> +	if (ocp->cur_seg == ocp->seg_cnt)
> +		flags = EFCT_SCSI_LAST_DATAPHASE;
> +	rc = efct_scsi_recv_wr_data(io, flags, sgl, curcnt, length,
> +				    efct_lio_datamove_done, NULL);
> +	return rc;

You can just remove rc and do a return. Maybe you meant to have a debug
function print out the value.

> +}
> +
> +static int
> +efct_lio_queue_data_in(struct se_cmd *cmd)
> +{
> +	struct efct_scsi_tgt_io *ocp =
> +		container_of(cmd, struct efct_scsi_tgt_io, cmd);
> +	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
> +	struct efct_scsi_sgl *sgl = io->sgl;
> +	struct scatterlist *sg = NULL;
> +	uint flags = 0, cnt = 0, curcnt = 0;
> +	u64 length = 0;
> +	int rc = 0;
> +
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_QUEUE_DATA_IN);
> +
> +	if (ocp->seg_cnt == 0) {
> +		if (cmd->data_length) {
> +			ocp->seg_cnt = cmd->t_data_nents;
> +			ocp->cur_seg = 0;
> +			if (efct_lio_sg_map(io)) {
> +				efct_lio_io_printf(io,
> +						   "efct_lio_sg_map failed\n");
> +				return -EAGAIN;
> +			}
> +		} else {
> +			/* If command length is 0, send the response status */
> +			struct efct_scsi_cmd_resp rsp;
> +
> +			memset(&rsp, 0, sizeof(rsp));
> +			efct_lio_io_printf(io,
> +					   "cmd : %p length 0, send status\n",
> +					   cmd);
> +			return efct_scsi_send_resp(io, 0, &rsp,
> +						  efct_lio_status_done, NULL);


Here I think we can mix and match -Exyz with EFC_FAIL. If we got EFC_FAIL
in transport_complete_qf we would complete the cmd with success but I think
you wanted to fail it or maybe even retry it in some cases.

I didn't check the other IO paths, so you should check them out.


> +
> +static int efct_session_cb(struct se_portal_group *se_tpg,
> +			   struct se_session *se_sess, void *private)
> +{
> +	struct efc_node *node = private;
> +	struct efct_node *tgt_node = NULL;
> +	struct efct *efct = node->efc->base;
> +
> +	tgt_node = kzalloc(sizeof(*tgt_node), GFP_KERNEL);
> +	if (!tgt_node)
> +		return EFC_FAIL;


The caller of the callback uses the ERR macros which assume -Exyz values
so this won't work.



> +
> +	/* initialize refcount */

You can drop the comment since the function name says the same thing.

> +	kref_init(&tgt_node->ref);
> +	tgt_node->release = _efct_tgt_node_free;
> +
> +	tgt_node->session = se_sess;
> +	node->tgt_node = tgt_node;
> +	tgt_node->efct = efct;
> +
> +	tgt_node->node = node;
> +
> +	tgt_node->node_fc_id = node->rnode.fc_id;
> +	tgt_node->port_fc_id = node->nport->fc_id;
> +	tgt_node->vpi = node->nport->indicator;
> +	tgt_node->rpi = node->rnode.indicator;
> +
> +	spin_lock_init(&tgt_node->active_ios_lock);
> +	INIT_LIST_HEAD(&tgt_node->active_ios);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int efct_scsi_tgt_new_device(struct efct *efct)
> +{
> +	int rc = 0;
> +	u32 total_ios;
> +
> +	/* Get the max settings */
> +	efct->tgt_efct.max_sge = sli_get_max_sge(&efct->hw.sli);
> +	efct->tgt_efct.max_sgl = sli_get_max_sgl(&efct->hw.sli);
> +
> +	/* initialize IO watermark fields */
> +	atomic_set(&efct->tgt_efct.ios_in_use, 0);
> +	total_ios = efct->hw.config.n_io;
> +	efc_log_debug(efct, "total_ios=%d\n", total_ios);
> +	efct->tgt_efct.watermark_min =
> +			(total_ios * EFCT_WATERMARK_LOW_PCT) / 100;
> +	efct->tgt_efct.watermark_max =
> +			(total_ios * EFCT_WATERMARK_HIGH_PCT) / 100;
> +	atomic_set(&efct->tgt_efct.io_high_watermark,
> +		   efct->tgt_efct.watermark_max);
> +	atomic_set(&efct->tgt_efct.watermark_hit, 0);
> +	atomic_set(&efct->tgt_efct.initiator_count, 0);
> +
> +	lio_wq = create_singlethread_workqueue("efct_lio_worker");
> +	if (!lio_wq) {
> +		efc_log_err(efct, "workqueue create failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&efct->tgt_efct.efct_lio_lock);
> +	INIT_LIST_HEAD(&efct->tgt_efct.vport_list);
> +
> +	return rc;


You don't need rc. You also probably wanted to use the EFC_FAL/SUCCESS
values here because I think the caller does.



> +}
> +
> +int efct_scsi_tgt_del_device(struct efct *efct)
> +{
> +	flush_workqueue(lio_wq);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +efct_scsi_tgt_new_nport(struct efc *efc, struct efc_nport *nport)
> +{
> +	struct efct *efct = nport->efc->base;
> +
> +	efc_log_debug(efct, "New SPORT: %s bound to %s\n", nport->display_name,
> +		       efct->tgt_efct.lio_nport->wwpn_str);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +void
> +efct_scsi_tgt_del_nport(struct efc *efc, struct efc_nport *nport)
> +{
> +	efc_log_debug(efc, "Del SPORT: %s\n", nport->display_name);
> +}
> +
> +static void efct_lio_setup_session(struct work_struct *work)
> +{
> +	struct efct_lio_wq_data *wq_data =
> +		container_of(work, struct efct_lio_wq_data, work);
> +	struct efct *efct = wq_data->efct;
> +	struct efc_node *node = wq_data->ptr;
> +	char wwpn[WWN_NAME_LEN];
> +	struct efct_lio_tpg *tpg = NULL;
> +	struct efct_node *tgt_node;
> +	struct se_portal_group *se_tpg;
> +	struct se_session *se_sess;
> +	int watermark;
> +	int ini_count;
> +	u64 id;
> +
> +	/* Check to see if it's belongs to vport,
> +	 * if not get physical port
> +	 */
> +	tpg = efct_get_vport_tpg(node);
> +	if (tpg) {
> +		se_tpg = &tpg->tpg;
> +	} else if (efct->tgt_efct.tpg) {
> +		tpg = efct->tgt_efct.tpg;
> +		se_tpg = &tpg->tpg;
> +	} else {
> +		efc_log_err(efct, "failed to init session\n");
> +		return;
> +	}
> +
> +	/*
> +	 * Format the FCP Initiator port_name into colon
> +	 * separated values to match the format by our explicit
> +	 * ConfigFS NodeACLs.
> +	 */
> +	efct_format_wwn(wwpn, sizeof(wwpn), "",	efc_node_get_wwpn(node));
> +
> +	se_sess = target_setup_session(se_tpg, 0, 0, TARGET_PROT_NORMAL, wwpn,
> +				       node, efct_session_cb);
> +	if (IS_ERR(se_sess)) {
> +		efc_log_err(efct, "failed to setup session\n");
> +		kfree(wq_data);
> +		efc_scsi_sess_reg_complete(node, EFC_FAIL);
> +		return;
> +	}
> +
> +	efc_log_debug(efct, "new initiator sess=%p node=%p id: %llx\n",
> +		      se_sess, node, id);
> +
> +	tgt_node = node->tgt_node;
> +	id = (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
> +
> +	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL)))
> +		efc_log_err(efct, "Node lookup store failed\n");
> +
> +	efc_scsi_sess_reg_complete(node, EFC_SUCCESS);
> +
> +	/* update IO watermark: increment initiator count */
> +	ini_count = atomic_add_return(1, &efct->tgt_efct.initiator_count);
> +	watermark = efct->tgt_efct.watermark_max -
> +		    ini_count * EFCT_IO_WATERMARK_PER_INITIATOR;
> +	watermark = (efct->tgt_efct.watermark_min > watermark) ?
> +			efct->tgt_efct.watermark_min : watermark;
> +	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
> +
> +	kfree(wq_data);
> +}
> +
> +int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
> +{
> +	struct efct *efct = node->efc->base;
> +	struct efct_lio_wq_data *wq_data;
> +
> +	/*
> +	 * Since LIO only supports initiator validation at thread level,
> +	 * we are open minded and accept all callers.
> +	 */
> +	wq_data = kzalloc(sizeof(*wq_data), GFP_ATOMIC);
> +	if (!wq_dlibefc_function_templateata)
> +		return -ENOMEM;

I think in other libefc_function_template callouts you return
EFCT_SCSI_CALL_COMPLETE on failure. Probably should stuck to one
type of return value.



> +
> +	wq_data->ptr = node;
> +	wq_data->efct = efct;
> +	INIT_WORK(&wq_data->work, efct_lio_setup_session);
> +	queue_work(lio_wq, &wq_data->work);
> +	return EFCT_SCSI_CALL_ASYNC;
> +}
> +
> +static void efct_lio_remove_session(struct work_struct *work)
> +{
> +	struct efct_lio_wq_data *wq_data =
> +		container_of(work, struct efct_lio_wq_data, work);
> +	struct efct *efct = wq_data->efct;
> +	struct efc_node *node = wq_data->ptr;
> +	struct efct_node *tgt_node = NULL;


No need to set to NULL since we set it a couple lines later. This happens
a lot in the driver, so do a quick scan.




> +	struct se_session *se_sess;
> +
> +	tgt_node = node->tgt_node;
> +	se_sess = tgt_node->session;
> +
> +	if (!se_sess) {
> +		/* base driver has sent back-to-back requests
> +		 * to unreg session with no intervening
> +		 * register
> +		 */

I didn't get this part. Should this be

if (!node->tgt_node)

Also does there need to be some code that sets node->tgt_node to
NULL after the removal?

It looks like tgt_node->session will always be set. We set it in
efct_session_cb when we allocate the tgt_node and I didn't see any place
it's set to null.

I think if we did call efct_lio_remove_session on a node back to back
without a registered session on the second call, then we would end up
with refcount warnings or errors from accessing a freed tgt_node. So
you probably wanted a node->tgt_node check before queueing the work.




> +		efc_log_err(efct, "unreg session for NULL session\n");
> +		efc_scsi_del_initiator_complete(node->efc, node);
> +		return;
> +	}
> +
> +	efc_log_debug(efct, "unreg session se_sess=%p node=%p\n",
> +		       se_sess, node);
> +
> +	/* first flag all session commands to complete */
> +	target_stop_session(se_sess);
> +
> +	/* now wait for session commands to complete */
> +	target_wait_for_sess_cmds(se_sess);
> +	target_remove_session(se_sess);
> +
> +	kref_put(&tgt_node->ref, tgt_node->release);

How the refcount and session removal work was not clear but I was lazy. I
see:

- target_remove_session is going to free the session.
- We are using refcounts for the efct_node.
- We check for if efct_node->session is NULL in some places
which I don't think can happen.

Is the above put going to be the last put? If so, are refcounts
needed? I mean does the code work by stopping the internal driver
threads/irqs from sending new IO to lio then we run this function?

Or could you have something like:

efct_dispatch_frame -> efct_dispatch_fcp_cmd -> efct_scsi_recv_cmd

running when this happening? Was there some place like here where
efct_node->session was set to NULL and that's what we try to detect
in efct_scsi_recv_cmd?


I might have misread the code because sometimes efct_node is node
(like in efct_dispatch_frame) and sometimes its tgt_node like above.


> +
> +	kfree(wq_data);
> +}
> +
> +int efct_scsi_del_initiator(struct efc *efc, struct efc_node *node, int reason)
> +{
> +	struct efct *efct = node->efc->base;
> +	struct efct_node *tgt_node = node->tgt_node;
> +	struct efct_lio_wq_data *wq_data;
> +	int watermark;
> +	int ini_count;
> +	u64 id;
> +
> +	if (reason == EFCT_SCSI_INITIATOR_MISSING)
> +		return EFCT_SCSI_CALL_COMPLETE;
> +
> +	wq_data = kzalloc(sizeof(*wq_data), GFP_ATOMIC);
> +	if (!wq_data)
> +		return EFCT_SCSI_CALL_COMPLETE;
> +
> +	id = (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
> +	xa_erase(&efct->lookup, id);
> +
> +	wq_data->ptr = node;
> +	wq_data->efct = efct;
> +	INIT_WORK(&wq_data->work, efct_lio_remove_session);
> +	queue_work(lio_wq, &wq_data->work);

I think you can stick the work inside the efct_node struct.

> +
> +	/*
> +	 * update IO watermark: decrement initiator count
> +	 */
> +	ini_count = atomic_sub_return(1, &efct->tgt_efct.initiator_count);
> +
> +	watermark = efct->tgt_efct.watermark_max -
> +		    ini_count * EFCT_IO_WATERMARK_PER_INITIATOR;
> +	watermark = (efct->tgt_efct.watermark_min > watermark) ?
> +			efct->tgt_efct.watermark_min : watermark;
> +	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
> +
> +	return EFCT_SCSI_CALL_ASYNC;
> +}
> +
> +void efct_scsi_recv_cmd(struct efct_io *io, uint64_t lun, u8 *cdb,
> +		       u32 cdb_len, u32 flags)
> +{
> +	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
> +	struct se_cmd *se_cmd = &io->tgt_io.cmd;
> +	struct efct *efct = io->efct;
> +	char *ddir;
> +	struct efct_node *tgt_node = NULL;
> +	struct se_session *se_sess;
> +	int rc = 0;
> +
> +	memset(ocp, 0, sizeof(struct efct_scsi_tgt_io));
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_RECV_CMD);
> +	atomic_add_return(1, &efct->tgt_efct.ios_in_use);
> +
> +	/* set target timeout */
> +	io->timeout = efct->target_io_timer_sec;
> +
> +	if (flags & EFCT_SCSI_CMD_SIMPLE)
> +		ocp->task_attr = TCM_SIMPLE_TAG;
> +	else if (flags & EFCT_SCSI_CMD_HEAD_OF_QUEUE)
> +		ocp->task_attr = TCM_HEAD_TAG;
> +	else if (flags & EFCT_SCSI_CMD_ORDERED)
> +		ocp->task_attr = TCM_ORDERED_TAG;
> +	else if (flags & EFCT_SCSI_CMD_ACA)
> +		ocp->task_attr = TCM_ACA_TAG;
> +
> +	switch (flags & (EFCT_SCSI_CMD_DIR_IN | EFCT_SCSI_CMD_DIR_OUT)) {
> +	case EFCT_SCSI_CMD_DIR_IN:
> +		ddir = "FROM_INITIATOR";
> +		ocp->ddir = DMA_TO_DEVICE;
> +		break;
> +	case EFCT_SCSI_CMD_DIR_OUT:
> +		ddir = "TO_INITIATOR";
> +		ocp->ddir = DMA_FROM_DEVICE;
> +		break;
> +	case EFCT_SCSI_CMD_DIR_IN | EFCT_SCSI_CMD_DIR_OUT:
> +		ddir = "BIDIR";
> +		ocp->ddir = DMA_BIDIRECTIONAL;
> +		break;
> +	default:
> +		ddir = "NONE";
> +		ocp->ddir = DMA_NONE;
> +		break;
> +	}
> +
> +	ocp->lun = lun;
> +	efct_lio_io_printf(io, "new cmd=0x%x ddir=%s dl=%u\n",
> +			  cdb[0], ddir, io->exp_xfer_len);
> +
> +	tgt_node = io->node;
> +	se_sess = tgt_node->session;
> +	if (!se_sess) {



Can this happen? I think when tgt_node is allocated in efct_session_cb and at
that time we set the session pointer, so these 2 structs are bound for life.



> +		efc_log_err(efct, "No session found to submit IO se_cmd: %p\n",
> +			    &ocp->cmd);
> +		efct_scsi_io_free(io);
> +		return;
> +	}
> +
> +	efct_set_lio_io_state(io, EFCT_LIO_STATE_TGT_SUBMIT_CMD);
> +	rc = target_init_cmd(se_cmd, se_sess, &io->tgt_io.sense_buffer[0],
> +			     ocp->lun, io->exp_xfer_len, ocp->task_attr,
> +			     ocp->ddir, TARGET_SCF_ACK_KREF);
> +	if (rc) {
> +		efc_log_err(efct, "failed to init cmd se_cmd: %p\n", se_cmd);
> +		efct_scsi_io_free(io);
> +		return;
> +	}
> +
> +	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0,
> +				NULL, 0, GFP_ATOMIC))
> +		return;
> +
> +	target_submit(se_cmd);
> +}
> +
> +int
> +efct_scsi_recv_tmf(struct efct_io *tmfio, u32 lun, enum efct_scsi_tmf_cmd cmd,
> +		   struct efct_io *io_to_abort, u32 flags)
> +{
> +	unsigned char tmr_func;
> +	struct efct *efct = tmfio->efct;
> +	struct efct_scsi_tgt_io *ocp = &tmfio->tgt_io;
> +	struct efct_node *tgt_node = NULL;
> +	struct se_session *se_sess;
> +	int rc;
> +
> +	memset(ocp, 0, sizeof(struct efct_scsi_tgt_io));
> +	efct_set_lio_io_state(tmfio, EFCT_LIO_STATE_SCSI_RECV_TMF);
> +	atomic_add_return(1, &efct->tgt_efct.ios_in_use);
> +	efct_lio_tmfio_printf(tmfio, "%s: new tmf %x lun=%u\n",
> +			      tmfio->display_name, cmd, lun);
> +
> +	switch (cmd) {
> +	case EFCT_SCSI_TMF_ABORT_TASK:
> +		tmr_func = TMR_ABORT_TASK;
> +		break;
> +	case EFCT_SCSI_TMF_ABORT_TASK_SET:
> +		tmr_func = TMR_ABORT_TASK_SET;
> +		break;
> +	case EFCT_SCSI_TMF_CLEAR_TASK_SET:
> +		tmr_func = TMR_CLEAR_TASK_SET;
> +		break;
> +	case EFCT_SCSI_TMF_LOGICAL_UNIT_RESET:
> +		tmr_func = TMR_LUN_RESET;
> +		break;
> +	case EFCT_SCSI_TMF_CLEAR_ACA:
> +		tmr_func = TMR_CLEAR_ACA;
> +		break;
> +	case EFCT_SCSI_TMF_TARGET_RESET:
> +		tmr_func = TMR_TARGET_WARM_RESET;
> +		break;
> +	case EFCT_SCSI_TMF_QUERY_ASYNCHRONOUS_EVENT:
> +	case EFCT_SCSI_TMF_QUERY_TASK_SET:
> +	default:
> +		goto tmf_fail;
> +	}
> +
> +	tmfio->tgt_io.tmf = tmr_func;
> +	tmfio->tgt_io.lun = lun;
> +	tmfio->tgt_io.io_to_abort = io_to_abort;
> +
> +	tgt_node = tmfio->node;
> +
> +	se_sess = tgt_node->session;
> +	if (!se_sess)
> +		return EFC_SUCCESS;
> +
> +	rc = target_submit_tmr(&ocp->cmd, se_sess, NULL, lun, ocp, tmr_func,
> +			GFP_ATOMIC, tmfio->init_task_tag, TARGET_SCF_ACK_KREF);
> +
> +	efct_set_lio_io_state(tmfio, EFCT_LIO_STATE_TGT_SUBMIT_TMR);


Is it possible that the ocp->cmd could complete from another CPU and be freed
by the time this returns? It seems unlikely but did you want a get() on the cmd
just in case?
