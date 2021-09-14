Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD34C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6DCB60F44
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239319AbhINDpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58260 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238424AbhINDph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:37 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXw3U005121;
        Tue, 14 Sep 2021 03:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BEKdVxUWqow1bqpjmiP9D0A42anUYGbdFmMsBm9M0Ww=;
 b=vBjv7BQmLZbk6HutoztXMfpO+QbPkwLXIj6vsQgAdO68GvQms8ntK9cCas8nZJJ5pWth
 AgV8jg+Sbb1bsq5f6/AArNWPyTOsL6lT8ZPKFVWvYPG7R5xTLZAsqbXtGD5K9RB6z1g/
 uTl5TcbEY4NMkdJXcQ8x/BukcoVuOu3STxrA4fGhLXcm2Q7McaCvbKUVjhVfDGwpXeVL
 a6vPaJXn5zuhvRCToK+jboeArEmIFBUrLnp9qr+PQjt1dLQsPHlWxB5whLJlx1DXN8WA
 HdMrrKzooLIcYYT14qRCpIcCybB7O2lUM3H7cu3Q7kHsdvHP5TvMFx5Vx6tSyIgOBF2R 0A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BEKdVxUWqow1bqpjmiP9D0A42anUYGbdFmMsBm9M0Ww=;
 b=kP08zGM3bquwSnNjDJ6yRWG4GYtBsUQ11pn61AUagv7mJkcf0zxnvA3w78RRWqe9S3Bi
 dfLYG8NW/WrHcfl+a1WxW46V/nsmfHwINpviAruPTXuBJ66T1wXsdZaEbo74ph6r6tEN
 Mrrtjvgiv8AtpiJHQ1t0qv3YY10Q1418G8Roo1Fv+wQBEWbsr5jG+I76iqXjilA/FGhz
 CJOb3l1p6n1GMRkSR33i53Cx5v3vgK3KlX6fvdCsDixeQlf6QigWzg9wGMujceMabzqa
 uQEkNxvBVAZmNAdEbmIITGsuNEMqdhZTniWp6qN0Qwr/kEPXUKVRqUDNTgMO3liN83+g cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka94wup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f7aq097745;
        Tue, 14 Sep 2021 03:44:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3b0hjuespt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1ktK8nli9HnLwIyfc0QQJegijrbQz1opjaWi1/pw+7iJv1+ICZyBzyYN8/OZBMRXkvzkNL7r0quTPh5fA33nueGLEVGQ9op2EUFizD1mcaWF+8Sf27UCqutabRRVdlEZNPOet+Rspfgw51Kt9tSowlTF7rGl8Yzxc0qh4QKbdvgaAczw2fM6oKmHHIESsGilX7g6E9SZewn5ZYWYjl8AtOeg971d1kPNlqv/AxoyhEEhQlfa5zSJ9z+yvlOSOipM3k7gBajMDlwEO9OWruKH7LznVPLBqbJOjJiK8Yp/Bh2XyHyklYPrzWTHgPng0z5N5B5gnZbvl8pIHFZhbCxnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BEKdVxUWqow1bqpjmiP9D0A42anUYGbdFmMsBm9M0Ww=;
 b=QgNoEUp1T3LH8WBEqQ4Ig8rNOZ/YAGqWAGZfXnl48wMgrBD3V4ENmVAyzJOBkPutCSUf2+AQTa7PuunlDE13A30QR+fgpk1hfTKL5MplgW9JFDGfrW7BqURVCe94whqI4LjnEFbXOlHwCh6Ku71nTeFG4HGbvs+5qyIrmw3I37XA3z6r14oOGJ3/FAmzuXBHXja14o0Q67YlA3Oq5/EvkWWEXRfTYiQCcw/pAb0qhobcAFeIEwBaPUS5RmPhn/kFyEdTDZ3djiLPa7I/ZtK3LD4mglwfVVada8PePLX9zTxzH1O3BtFcdUjWchHBC+eHOJDlbaTZlg6Xy9p/ITaiXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEKdVxUWqow1bqpjmiP9D0A42anUYGbdFmMsBm9M0Ww=;
 b=Fh3xsd+wbOP9i7BWdcj8FgNMPuCZI+fvXVouHMg6jjintTfy/sJIgtdyzAj7oCtqVkeeRHlT0dB9MnxOD6sC/tbXxycAtkz/aW9XZZuDTubH5akYH7dxyPND3uOfkx8QqjVvRywWsICW/kwJm6BVmrmetJ4qttaqO3FXfwfJcQM=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: remove SCSI CDROM MAINTAINERS entry
Date:   Mon, 13 Sep 2021 23:43:41 -0400
Message-Id: <163159094721.20733.12791416406728236807.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <c5e12bd1-10de-634c-d6b3-dac79ed01af5@kernel.dk>
References: <c5e12bd1-10de-634c-d6b3-dac79ed01af5@kernel.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7712c0b-64ed-478a-8a18-08d97731e4f4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450275ABDDB41D2B9D8DBA3A8EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bbCKjCBpA51abjxUJER5k+1Vs8hU/bMcNBFG8Z5O6R1J6NfFHAV/RrmYL+bIdyyEzJnTmamlwoJbWVtvoDeoeOr8jFObHYgtgsAcium89FKJ05HiiyWq/Xn5I5WGYYTjrem0BvVVxQAxN+8P3+gn7L581UNcvH3fiQif1qxDu6T9sC7ZFzLLmlRkWMbw82v0lJKGBo9ECOqynbDXbEVU8+Dc/drR4soQcMn7UeGDikfRoUl084E7vK4v45lNAuh+2XBgOZXZtZiW86gYLee1M36owV9bR3WNCiSbgXd1n63HU4evFhOp4AjAcRdRMCuvG/Hi0IQ8/hCJPTkfrklagdxGReaAKdo6px/pbGsYB9pPD6apc31M/ERkBBJYMtWfXARzmNVZOzAM7uBAZzy4Ii6KzEB+Q2zM3hxXo4AJdO0aI9vJ2MS5M4wl1F29YQTXA3bFQ4XKiJHqsNsSqn2phIn56P4tlJD7BWmIja443vdJUwig2L5xzy4dknrObg8ny+KF5Ldg11DF5P+nXlqjLVXHHfqr0JuSVR8I86c+YsBtFnP6EWe+izyh5iddAXZa31N0jPYDKiOKlWMmj0HhYn/SNwnuGqIJreRJO/N9sU8gu2i5BJ4Wg1yaB1Vh6AqYeyG8O8PQMOQWkD1dTYj/ta6u9XrIUl9m8R6KF7VbHmjtKa9QUd9FBRjXdBSNU0eMr9lEKuNNNPnsrqJ2G+ysloXLGlclGbXVgohVYtW0uopF8cHbtZsUvhRKBSdTTnqqPaa1q9NG1TKxf0e7LSKNzikgzIP84BuPESeg7hC/5Io=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(110136005)(38100700002)(2906002)(956004)(8676002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0Fzc1FxMGhuOGdPbW1TK2EwUTQySStMZlpPbWdpeVk1QTliaUo1VmR1ZUVu?=
 =?utf-8?B?M29TaFFJbFRGS1U3bG5wM2ZWREZIaGxRUjEvd0cxbWdPL0lJVVpFREF6eUtT?=
 =?utf-8?B?OC8zSjlsS1cxMWNLdS9rcGJQNDY3VDZ3ejFuN0lCZG40NlRuaDZXZGJ3d2lx?=
 =?utf-8?B?STM0ZHJmb2RKUGpqRDJlT3lpVnFuVzVVYWNoSktMN09OVENkRTIwYWpiQzB1?=
 =?utf-8?B?QUVWbElVbzd6Y3dxbDJEOEk3WGxyVkVXVWltTTd3MkNOd0tDZjJXUDdiNG5M?=
 =?utf-8?B?T25LdFcvbjBZankzQ1lxWklobTYxZldWbG1iV0dhaGFpR012eFJZQnJZN1dV?=
 =?utf-8?B?dDExcUhNekQrdUFyeVRQeUp4c2wxNmNqYVM3aFU4VXp6QU96RERCMC9kNERK?=
 =?utf-8?B?cVgzNGNSUmUvbnpWKzRMcElTSExvU3VBUURxcjE1ekwvTVYrOENUTkNNNHpt?=
 =?utf-8?B?ZFFwaWZSR0FmQmVNdHdXeWpSL3o2bFdZWlRma1hlL0l1ODQ5RmR0amZWdkwr?=
 =?utf-8?B?YThldkJpdUIyU0lWeUFiZnpXMGZHUVpnM1NxQWhJaUNtMjBpY0ZUc2JsNlIr?=
 =?utf-8?B?eW0yd1JrQkpIYXczaHcyMlBaYnVkQ0IrVmpjc2pXdXV4RG1aMmtZZWk3c2Jw?=
 =?utf-8?B?WHljV2FHZG01d2V6elVVTXZUMVZhMkExdFZaK21rQTg1NEpWUGc0TGtUNkVl?=
 =?utf-8?B?Tld2VHY5YXhkMnFIVlAzcmNHSXUxWWxmWnlOWi9zSUZoOGFOc0pzQmtDYmZj?=
 =?utf-8?B?R1hoeXhnaldvNy9SeDJQa0NUS0FDbUdTRndxUWQ3NXVRS3B2enc5T0dWOHZX?=
 =?utf-8?B?MUhpUjF0UTFjYnl2S1FndmlWY040UlZsU3ZhOTBteS8yUXQrS1pkK3hsQnlm?=
 =?utf-8?B?RzlwY282eUUrUE5kY0JYOWtkQ1ZVZ3BYNFFsWWtlVGFmNHphaUhxZjVSdTdM?=
 =?utf-8?B?YS9MVEZvcGU4NEMyUithdEIweXd3QkJxV0dlV21LNmt6dFIzaFBDRkVBeGJQ?=
 =?utf-8?B?T3JWRmRTbVFYMTV1cjJGR2FKRjRwaWVZTEhVQWhqa0lUS0tzR0JWZkViY01E?=
 =?utf-8?B?ZDAwTGttaGxjWWRtcERtMHlSU2J6Rk4wcmRCWG13Y3l0STRiTW94RHdlR3hX?=
 =?utf-8?B?RnoycWIzbWtTOUFzNUl0SVJXTGxWY3BkL1NTUHlWYTRNK09GSEczR0R5N29B?=
 =?utf-8?B?a0dwdXBDbVZROXlQME5RbEY0dHZ0R1ZCSnd6cVFSVG9PdWdNZGdENmVMcGc1?=
 =?utf-8?B?K3YvWVhrOEVKeVpzVGNjalh5T1RBUjZvR2Jrc0dlOWlKM1BJZWt5Q05ib2hR?=
 =?utf-8?B?cmIzMDcyZVNEWW9yNGc3MkdHUTVhNXRDVTROYTFRcFVVWTNxQTgvRnpBcXRz?=
 =?utf-8?B?NXNGbkkxUFZCUGwwTDFpMVhqZXBhTmF5VzQ3MEtXaEdvdWZ2NWRYZzI2TkhS?=
 =?utf-8?B?dFFDMXJNVGJxM2M3aS80aURib3A3aUhZV0cyVFF3dW45ZE0wdCtKQ0lOUTNa?=
 =?utf-8?B?WVRXdDAydEl4VEZtWVh3a2xaODZWbTAzeFg1cktLZ2hwd3cvdG1QK1NVQmlw?=
 =?utf-8?B?OEdmRzducldtTnQ0bklPd0JSeW1xRmR0aEZBcS9uTm1uQnEvMnF2dDVGWlZG?=
 =?utf-8?B?bTZQUWZ5dzNvak80cXM3Y2I2U2dOSGVIMSt2OTIvYTJBSTdzTkF3bWhGUWhD?=
 =?utf-8?B?azdzU0tna2R1MXo4OG1CNW9HekVycVVhMnBsTm4rS2hTVzVNRmdvdGVIL2RF?=
 =?utf-8?Q?OqXGBH2GH98JcN0ajg2W/yV5cOM0N0m/3OPDvcv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7712c0b-64ed-478a-8a18-08d97731e4f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:02.9951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XP4EM7X1A1cAmlu6+5kV8XAWhaYGisKucWoF7n+ZxztGj+Fh94R9d/ilbG+X1BubwhxuzOMUVuvotW4Ix6lhyclSk7ufc1O0CNYW90R9BLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=994 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-GUID: 7goHlkcaxM6dCydRhnc5_LitvYwTsgvI
X-Proofpoint-ORIG-GUID: 7goHlkcaxM6dCydRhnc5_LitvYwTsgvI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 3 Sep 2021 08:11:39 -0600, Jens Axboe wrote:

> There's little point in keeping this one separately maintained these
> days, so just remove the entry and it'll fall under the SCSI subsystem
> where it belongs.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: remove SCSI CDROM MAINTAINERS entry
      https://git.kernel.org/mkp/scsi/c/fc13fc074909

-- 
Martin K. Petersen	Oracle Linux Engineering
