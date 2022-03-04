Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F277C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 03:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiCDDnD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiCDDnC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 22:43:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6CD17B0E8
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 19:42:16 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240pEjF013353;
        Fri, 4 Mar 2022 03:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qPZeJso97MlctlyT1i87qcepIRRypwz+rCYlt/xI3kg=;
 b=zdD3d/BIdW3jmbkEF87yvduQd9E1i/YMmcCLtPM/jmHwwkm6zkthLx2noHw8XMxsXEtn
 HB6/7UYLgadTMHbANu2ZWEQ/YaAQmYLZog/45iy41bRL8eoKqgT3MQgAp2jOdXifosQe
 IHOOf499rQi0B8GodVkGj6RuDaouS33+Ok2HQKxYjzfO0N+qbHsuYaq2GFuOH6qfNxoU
 +u/bXsC0j4cLG6C81u32fNtNmMT9cgx3ZY+PaQYGxOfLcLiaSDzVl7VBcO4NMIhsE6J6
 G9v0nB0zYEEoMmx5NOGU8K5NZayGP8FqL/4pOx9ypONt1+0J9Cm24ISaiOZ3MdXYNbme vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv0nk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:42:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2243ZRQ0083371;
        Fri, 4 Mar 2022 03:42:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3ek4jg1tee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:42:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJp00DAFWTJEAQT7OasliFZLoj+f9KPM2FtxSjaSPrYzNyzb1cDpxW5nCwR4djT9Mp1YUWR9y7ldYvsnO3Kg+nZcOVMAX1yczbk4WsavcwtBE/U5EQ6LJzqQzF+hjrbkoU3fHVwjBTkovCgYrnLtjMfkp3A8WRXI5THiEeMd/vivGmZCeIRn4i+PX4/HJICGlmA11bfZBcEzZrI+ZM/+E6mxXMIKRSu5AWyY8q3pYL5C6q/aftO4epFC/2K/BKlB0EZSBf9ROd7KO7moCjGJ6ppEZW+fnHUUcMt1RJGnhvrQSIVQG6Z1R89CCowxblcjlGYJWI0+Z08H6g1OEOs63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPZeJso97MlctlyT1i87qcepIRRypwz+rCYlt/xI3kg=;
 b=dyjgZq/Fk+ZZwC+FqjRNt/HWcZd+84AjiE4SHEBLbl7qtLWQmRHcFpDco4U3GxZmvkKDylSNY/CtddAA9HrGd8s+m8uAJmQezu2tvvqozWAo8eEWrXIk/qewHR7HrHqxYfcIwXVgWBbEEJtq3OKjtqCBuxgXP0NUva5+5omSooNoHMSGR37DV3wazM468Yw9abHL5nRWOsKPibNncDM2ywLyx7AFcKoVfhMJceXDRQOU1XYmjpKZJe0SWmwtvt8AhBYn6y44oIF+gby5DZIoboljGgNpS3SPtLxXp79zmlvyITCjw5lHJcHEnBgASMuCFfA9jwDpg6aO8UgHVxnijw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPZeJso97MlctlyT1i87qcepIRRypwz+rCYlt/xI3kg=;
 b=zeyPZlVim8e2fIRJIx9dy+W9t5QIkOYe/ZymitX897tRG003qzklV8kVcrxoKBqoRqexrdBLrk3Oa7LcLb5UTTWCAuU6EsazPxO+A8FHjsxx/7vLSpIn7qAguNfuIKfmSyFtNvuIup0RwC5JL5MrQOTZC/khxWV7awSMlvaRuoQ=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by DM5PR10MB1497.namprd10.prod.outlook.com (2603:10b6:3:13::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Fri, 4 Mar
 2022 03:42:10 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 03:42:10 +0000
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Maciej W . Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH 02/14] scsi: core: Query VPD size before getting full page
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h78etmel.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-3-martin.petersen@oracle.com>
        <PH0PR04MB7416D285ADC638FB1A704C239B039@PH0PR04MB7416.namprd04.prod.outlook.com>
Date:   Thu, 03 Mar 2022 22:42:07 -0500
In-Reply-To: <PH0PR04MB7416D285ADC638FB1A704C239B039@PH0PR04MB7416.namprd04.prod.outlook.com>
        (Johannes Thumshirn's message of "Wed, 2 Mar 2022 14:25:08 +0000")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR1401CA0002.namprd14.prod.outlook.com
 (2603:10b6:4:4a::12) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d5c868e-688c-4488-7e94-08d9fd90f697
X-MS-TrafficTypeDiagnostic: DM5PR10MB1497:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB14970BC9EADB4C2DD90756278E059@DM5PR10MB1497.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghRcVoV+pjqMN8Go/PuIuG9utQQYGUB/+Hxx4n38rZOuJ77k7PCNZ0V3DpC1D9NZkvGSaRS2LdGGu7GxOt6T8MQuM2eo4RtqfxPwoZ5ytFFk0NnV4lL4HSPDMsaSvH8wjFb/vRImTaojCJZG/L0E9oErMcn1aLDvT9eKcyXTuVJ7QLS1HynkwZvtCFSX9eNTxZdAvrdFF1d9WbWfd558R91EM3Pnr7UrG5Nx36KrBBnMapGebCioF+alU9uNKwEDRjBQoClSGbfOQWqvsjKfHbJkpFetBWeIfaPvZOnA9zndBVNJHJzlI3w9FAklVxTZb41zxp49xIY55jIz4aRUZ4ShYx+5mex1N8SxQVxRwCGuNJxuPeXJdzTtIREq6EzR0lxkqzZJ/TzXXlRA2AHni+EICiC3YXFmLfcDCXYBtLVLSBumzweiisoGIu0m49Dp0AneskbXoZwkzema1YFSPYHpnemviKvVESJRdQNRg59VEVZGKFCX4mmeJOWnHA0iSYTg4WF79Boe4XrigGc9MNnhW8aKM8O1am0xMAzxZXIB8kobknv7IxkQpuBaz9iSFRuZlka8j4NjsxDQWMH01mgJL7+m/mzpuU97DZfQfSlytji8xAZAJBhYV/91wDFHWuCvYRh68vIMrRQSuK+6LifBTOFj2BSlzbRbes4AqKkBdl9pOIMwbuLlB5qEH4qLZ17jd+WqdyIz22L+0gwwGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(186003)(26005)(38350700002)(5660300002)(38100700002)(6486002)(2906002)(83380400001)(4744005)(508600001)(54906003)(8936002)(86362001)(6666004)(316002)(6916009)(66556008)(66946007)(6506007)(66476007)(4326008)(8676002)(52116002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r7Vn0RfYGuVmA57nC5BUgCcJAlIXTdSz6PHmnQHONLyqqSx1+bMixoec7iQG?=
 =?us-ascii?Q?JfJapgJUe+5o2DlwwvXpR+IltVBEXIaA0RDp1mG1Ht1P9Z2zgk9HqKVfoA7w?=
 =?us-ascii?Q?OIqfyabWqYFHLzMwV2AfAwZD+frIamy0Av9e2r25GnOPRhdWsNUMZf5ZjYNr?=
 =?us-ascii?Q?P7HEBGSVuzraHHJAlEODu74rTt7BPBsuMY+lS7XjQNJIqxesV0EjyKMu8sxk?=
 =?us-ascii?Q?ckQq1SKSTYLF/6Ayu0YCtmKpAE7iK880vqtLfRe/Q8PIuyCjvidw10UwTVtP?=
 =?us-ascii?Q?uiLHQCllL1OcnAeb+IYRvnDhm8MGq5zeqejpa6vZvVwkjCp5Nqvjd1ijRSum?=
 =?us-ascii?Q?CWRIC4qMI8E2paAs25IgHe6THDMRaUkW7JsiKriX0po2oB4dsPYXQfsC/RIh?=
 =?us-ascii?Q?yUn16WV13Hyt1NgxejD+uTaYbwSMniR8aJhRzzrLYwocBxNzC321DFNdhNba?=
 =?us-ascii?Q?4LQtcENFansoubmYL4R5HF/mLgt9W6p8o3mal05+51k48iiRV5LChU4CuJwe?=
 =?us-ascii?Q?WS+TPkN2/LqKOSmg8dQVxclsFukzvZdNEvVtMOU8CNFlsPCqXT+c2ZKOKxY7?=
 =?us-ascii?Q?ojKesRB/bmq6ud9pkkUxwkXd6KC/rBign0YIdRRP2fu/47bMCKA+ct9b2Q7A?=
 =?us-ascii?Q?eEkLg2Dtl9Rf2fjgtryJQu1VhvKj+Do8r+bjKUOhhwh2onpTMBqCYCJTA9wm?=
 =?us-ascii?Q?QFANisnPEtvYFqqL0l3mEafhBGK32ez7Y0F4spWXY0oJExxMeLnuMHI3Rejb?=
 =?us-ascii?Q?4z2oENUMl+QeVFBbJ39ZPtqZbnP8kvRtgJFYZ7AdDCN/Asam+IHSjG2ODgJ1?=
 =?us-ascii?Q?tkbeq7+aHxeguSXFGk/CK66Ig/N5dD5FGc5ylerZBRo7v+u0zgmCaNnWVq6t?=
 =?us-ascii?Q?Pat58Y9eKEiBwZcfocWpmsRGAz1CX2Vwf0YDedE9KqxoShS3NaiHvqx5vmwE?=
 =?us-ascii?Q?QmNselxVc7DdJ1VDlmZ9PbmYeT9Ql1q5zMVw2Xe4gdTEogp+hs6Qfx4bJmjU?=
 =?us-ascii?Q?LNeSbhC4nrF9tub5EYHHaqL+BV/aaNL5LPsJJQDj89WKNoQYv+kgM08yy1Gl?=
 =?us-ascii?Q?jyiPrlUwJZRMS2sITLSbFcQVpjreth+wmCkpTkJLrBNfYwgoWOaowfLE7VbA?=
 =?us-ascii?Q?d1T+EzCjzx7lqQxWLaVnahU8hOTP0YpFHI8qTkYvDAE0cy9Bp2F1W6qEs3u3?=
 =?us-ascii?Q?cJyL3zrfU9L6fRwpHIMiJU5EOeTuSAamiLzm5qMBMnX6qpOKdU581FYQ9cIy?=
 =?us-ascii?Q?TS6tJITGGlpXPyS0JPPf7/NFJF9gIPj1Tq3uWFpkqk6Mh0/5G0aXVX8GM4IP?=
 =?us-ascii?Q?EVyNiXUfJzpntLDRsDl1hG20uYITzMsnX8uMVmMOSoGflx9nT7Arp5JRKmtg?=
 =?us-ascii?Q?+14eXGAzvCtlJZnTxTmTIXGFYqEENj9cSfj5MhEe0Bj6zo0lKtja+baIhPui?=
 =?us-ascii?Q?v9sUIVZ5kTaoI29Ud0Y0wxx3fNPjAv8AvHJqxZuqWmfhVM/W082DME5nyFmY?=
 =?us-ascii?Q?1oSB5DL6js1eHBfIovWUxs9cocKzv+C9y+3WG5VeBighmzaxocJmrdxpUYap?=
 =?us-ascii?Q?M/g/Ef+LarNGRvPP+FXJkMQUpS/MlK4gKXr2MxUaTJ8+6K2meE5w628fG8Pj?=
 =?us-ascii?Q?V49knCVGT3L3eprhESBHfwxcaPxs9tW7Q/QU2UmImhv3zCFnS66LKvGa/F70?=
 =?us-ascii?Q?spmN3cYdirGzVx+roy3d6Cw2c1E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5c868e-688c-4488-7e94-08d9fd90f697
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 03:42:10.4815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5ZrZ7KBGm9vT4fRFxIMW1ckl357j+9mUSbf08LLxx6q8K6RBfFoiWWak0MiqEAK/hwT8WN985Ch17BgegFdJDuGoxvsRz5mu0uYn3S4mig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1497
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=976
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040014
X-Proofpoint-GUID: dzKpZkXrxTBht8oSXEin98SC89UIAuVz
X-Proofpoint-ORIG-GUID: dzKpZkXrxTBht8oSXEin98SC89UIAuVz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

> Two minior nits below:
>
>> +	result = scsi_vpd_inquiry(sdev, vpd_header, page, sizeof(vpd_header));
>> +
>> +	if (result < 0)
>> +		return 0;
>
> can we remove the empty line?

Sure!

>> +	memset(buf, 0, buf_len);
>> +	result = scsi_vpd_inquiry(sdev, buf, page, vpd_len);
>>  	if (result < 0)
>> -		goto fail;
>> +		return -EINVAL;
>> +	else if (result > vpd_len) {
>> +		dev_warn_once(&sdev->sdev_gendev,
>> +			      "%s: VPD page 0x%02x result %d > %d bytes\n",
>> +			      __func__, page, result, vpd_len);
>> +		vpd_len = min(result, buf_len);
>> +		goto retry_pg;
>> +	}
>>  
>
> Adding {} to the if block as well makes it look nicer IMHO

Roger.

-- 
Martin K. Petersen	Oracle Linux Engineering
