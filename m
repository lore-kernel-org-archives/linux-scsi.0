Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6035CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F83F613B1
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhDMRku (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:40:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43326 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhDMRkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:40:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DHZCf6146826;
        Tue, 13 Apr 2021 17:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SMNoCS5lty1pgEm4/M0v4YhKqMyAI6erEiTsphjAzLs=;
 b=eBu7WZXM3OH1ljDpuvFDGyKgRkz3tyAm7yiarkNKStWtaO4Iyf/QYrjgAOJc+aUISzuq
 j/fSE8bzOx9JbuIX6cc/hNLlzGePgcrkxAV+aXXOs+bEwAYf2vrvZaRF/dY0zoX2Q22s
 Zctj4+504DaAQqJCwRQakyZexO9w8I1mwwrBlS/ftDr4+WKOc9zIYtFtx+b4PtC2B24a
 gO7B6wgrVg46YWj8AIWmGwdO/8YN2wrbmolzthNvf5PKbBtyfpu+1sybtWf+YiO3FCgV
 0Lrf1J6CAsckPAOuJaEcgGVGHZwtu9smbtOuCncm0mCFHeqI0A1ha9FhX0rRGswPMs62 Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erfxqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 17:40:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DHZfNA086499;
        Tue, 13 Apr 2021 17:40:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 37unx03dgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 17:40:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9j7bxI9ADWe+/ayq19+Ctso6xkwjX4l5hnW/htCmJ6HU7CWRF5WcdycaCdHCdP2DcSKHPWE0vYfhKsNzWNID5Woj91KNjsx+Dr2RMzfJpIhV5ezvGCvGoYzTnKCrg5ePoweF3u+Qp1dR+3vgooqvQD0MNPmD0lvPXn2YoBVXIxZqz0pf4kqCvTV32i8yWl8d0ADpaOBO+JLJkM4jMHhL7EkwNDsD2lIOILY2NgBCiBOOAez7+jn8BkSKsSldrgDzs6MlHp22Cr04S6Ji4fVScyEB1s6T2PBXMWhi2x0rYoLkbGAbSCQq42a0etL2aqYhZHlXyUpceoY+pLCJpV9jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMNoCS5lty1pgEm4/M0v4YhKqMyAI6erEiTsphjAzLs=;
 b=ca8Pw5ZBdMUBMy+bVabJ2PNVac0nXubDHw+nW7UfDE8mQPczwwNpni2TJtDzgJYDpOgXGrGeQ6TlnARC2i4AoG84UDSBfaAduSfukEzJ0qIPrWBdb7M2rTj7EmXuLPOwQuIHjAtlfrC9ULMao1jhAuBdPVsXSUZ6MzBlxLSlexeWfcKwGyvPICJSCd3bHvrUbzwBnbiUTxuki+hLq9EvS8XBDbKIgah0JJtcxYPoNQtZl0gBanvp9NSz/gD6WAoARlOU3BkzjKO4Oe85bFFr9cY9v2HkENicgP13qpBj4MnefKEaj/36F3r2FpJrkehz4Pr1JgW3uhSMMM0G0TMhKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMNoCS5lty1pgEm4/M0v4YhKqMyAI6erEiTsphjAzLs=;
 b=Z/YkponX85ZAH6eFAdUUBJIw+45UZ9ZXgWxj8mahwtOecozIfMXAn78xlL8l4hXUS0MK+zxUN1nQsiFeVRSGhOjb7v+UaZaS/9SA4mrj6/1SEqPoSID4pg/1+zBuGxWKrPPbmRzSf2ZW2fh5OuDjs7fgnAuX8/fA00Y3bbHHAfg=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4717.namprd10.prod.outlook.com (2603:10b6:a03:2ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 17:40:14 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 17:40:14 +0000
Subject: Re: [PATCH 18/20] target: Compare explicitly with SAM_STAT_GOOD
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210413170714.2119-1-bvanassche@acm.org>
 <20210413170714.2119-19-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <4c24d239-793e-a433-772d-a4cee429c3d9@oracle.com>
Date:   Tue, 13 Apr 2021 12:40:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210413170714.2119-19-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0066.namprd13.prod.outlook.com
 (2603:10b6:5:134::43) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR13CA0066.namprd13.prod.outlook.com (2603:10b6:5:134::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Tue, 13 Apr 2021 17:40:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f57b70dd-0ad2-4119-960f-08d8fea331ff
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4717668CDD9CF85DFD7A6CDAF14F9@SJ0PR10MB4717.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0lDFBO2ThEpSQZWX2XNQerIhIDQdnXMcXhukvk0MtS9Q/IVlXbn6dJX6iZjpq2LHiVDRAxkGXvjMYdZZ+y490lldrBUgltR56PBNhPp22zo2kPHFfJ1hH0ehoFQrestigdqDbfKDDwx6WjOv+G2ezubXyr2xByercD3JeNbT6RI9iTdQ+m+Yn+TOzWGtLVlxQxob/wi/35qxJIRkcbLArpg1Im3mo18NDPZ2ndi1oBMWQZAb3bJroFJ7Eq+GuZPZKkhXwauaiukIdtTkTNGHSBvTFLqWKpJ6KSbg1O85v04jX6whttst6hxoj02gfnWNK0KTvV/iSMrXbZ/0Yqmhnn35dt9hHmyI1d5p1LmqJwQeEpwU3A9s3XEn7S5Nz7z1LdfrcqxUIVI42DfskJxpiBGxjAxHp9xI70cic0LRumElAOsxB5+YKcCa7NvFCUrNxJLVNdYjNyrHEZDgb+90IwbBozCQV85UZjZ7eDJhWlX7l2XtixI7rWKCRoZdLveFCjE9WTO2XOw6cYFf6eRUA8NcnhtPlH5pyohRjSacdKXHBkgHLQRATirSWyhPzDozK7nvEDGMUHBljrKNqPZv31/12XwmkDahobv0k+r8jgRWBXgAH2vNcJKeBFm14rcKMVEd3te4tBSd9XYA2mxe4GMiIw41v2Du3tjNr/+hfqR9eMCNB/5zSQQNC9RpiLx2Rr7zrx0f1RS74SzySceWrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(478600001)(36756003)(31686004)(16576012)(110136005)(26005)(4326008)(2906002)(5660300002)(4744005)(31696002)(38100700002)(8936002)(316002)(2616005)(956004)(186003)(66556008)(6706004)(66946007)(66476007)(16526019)(53546011)(83380400001)(86362001)(8676002)(6486002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eEtPQUZXTCtOZ1IxNFJ5Q0MxbU90VHc1M3F0c3VGZ3pOOXM1aVdpQjhLdU5r?=
 =?utf-8?B?NjRKd3RRZ3FOSDVwS3NxR090Qy9hK25FVTFhYlRrRmR5dzNhcEpOMnlhdldQ?=
 =?utf-8?B?NEJPdmtWb2kyRWlKSi92MTRMdkcxZlFGa2ZkZVRGeTBMUVRCUUQvUzhmbmdK?=
 =?utf-8?B?bU5nL2lmalZUNlUyWWZPQ2VLRnFtV0dtWHdVanA5Y0xvN0dITzluam43a3Ja?=
 =?utf-8?B?RkdMNGNEWERoVUdzVUNrUnNkUEVZRE9yKzJKYk0vUnBIZDZ3cHUxbE1JNnYz?=
 =?utf-8?B?b05OTTFSUWk5bHoyWDAzVG9NTEw0QTd2U1BVcDNLR2F4YUpmYjhHZzBmcW02?=
 =?utf-8?B?LzZaUENPQjBuRVdQVWJSOEZ4SDF5VFh3MmcyTHNSVkN1dHlvLzRVV1lMV0ow?=
 =?utf-8?B?TUpxT0FXZFFCWDVCakdEQitzOXFtelBhZUUxcHc0anJGcGpYQ2E0c0srWmV1?=
 =?utf-8?B?RUgzZm5lYVA2d09ocitnMElMZ3VUK25LbWVNVXpVay9DQnhxcG1YVDE5djRC?=
 =?utf-8?B?THhmSjRJQW1TZnhjSWoydnQzT2FuV2o5RUJTWlRkSnR5YXhMeUFPampaNlpv?=
 =?utf-8?B?TG0vdVJ3VVdBK2x3ektPMnlraUluYUw3dXhZMFFRdEVicXBxY3c4T2VTUC9t?=
 =?utf-8?B?djlDWmxEWDgzV1Q2TmZaUmFRYjF3dzJBNGVITHcxQXF0bGhYbUNRRE5KT3V2?=
 =?utf-8?B?WFNPcVhIRkdVZ1gyYXdpZmRXT3ZTYUVRZlc5dkV5MGpHS2xvV2hiNExZZWd1?=
 =?utf-8?B?cXBNVHVzbXdiaS9hNm9aYTQ4ZkIvRmluUzVRTWhqazM5KzV6dngxS2xBV2Ix?=
 =?utf-8?B?Rkk1T2tPQ0JDUDYrRDZEUjlpUWFvSi9POENBT1ZDN2JCS3ErSUJ5NC9ZRURj?=
 =?utf-8?B?YzNZYUs0TU9yTC9Jb2tXZGpTMEdxeGNYaUEydTEzaHRES2hndVRBa2xhZFM0?=
 =?utf-8?B?M2tWci9SaGc3d0lGcElMK25LcFVqVFlucVFIYXJkeDRKV0ZWY3g5SUZYMThr?=
 =?utf-8?B?blN5VzlXUUkrRWFwL1Rna09GSk9nd2JUTStHRG9mZm5hV3Y4RDdTelE0ZFNC?=
 =?utf-8?B?ckdPWUZFWEZ6TjJDR1JHRUxxdDR1TzVBYVRrdjdNeTR0OHNVSGsrQXErWjV4?=
 =?utf-8?B?WUd5VUNLUnBZbktmTmxZTlpkVS83Y0R4dU5raE5TcVk2TnV6czltN3dwY2pE?=
 =?utf-8?B?Q3dldUs5ajdkMEVMa1ViSmNNWXMrdU13OVBrT0ppeEs4bFV5NE9BcS9CVFYx?=
 =?utf-8?B?MFl1NUlpT25jZ0orK21BM29SVFFVRFBXdXdwWlJ2SURJTGszaDZScDdrSkJt?=
 =?utf-8?B?R0FtaVN0UndYUzVSVlpXTFdPejhxZ2I4ZTNtc0NQZ2ZoVTNCTlcvSlY5RFJZ?=
 =?utf-8?B?bDhnTU11aDhXVnBlMGlJRTZHUmh0a3hxWVJDUUFKeGllWmFkRDlYZWRuQ0tp?=
 =?utf-8?B?bTk2WlZSZUxsdEtVd2JmYWs1RjZQelJzdTdrMGk5TmsrRjRmNUFGK1hubWtk?=
 =?utf-8?B?c050Y00yZXQwS04rNDZGcmJORCtGQ1BzMnBGNm90MjJCajBGVHM1MkhQVFBx?=
 =?utf-8?B?NkJnM3Q2UXVuQndCYXhST0JoQkprNzViUHRvRkNBd2lVKzRRRHdSSm9qbDRF?=
 =?utf-8?B?UldFOW5QNStIYzNZSE5oWUY2aGlQL2MwQ1gyYkU0cTdEZmxPRit3VzI0NGMr?=
 =?utf-8?B?TnJBUU1jRTFBS1hRQk5yakxBdG9CS01UU1J5YkxTbVVyaFdOYkpGT2dEZGtI?=
 =?utf-8?Q?PpisJcjsL6aiUCigYSLgOCBTBkKh0V3ZNMws33A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f57b70dd-0ad2-4119-960f-08d8fea331ff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 17:40:14.6822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9W+FJf0XparIU+AOHeXXrc2c1hPYGCJ6XvaF50n00q0Wa4J0iRlhf+/HtO3SM9kZWzm40b1g1iqOBToHhZIqxw/oMdIjy4qTTCz7WqpFPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4717
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130120
X-Proofpoint-ORIG-GUID: ej-SbcQDO2qoxipwEzvMDdDEd6YJPiUq
X-Proofpoint-GUID: ej-SbcQDO2qoxipwEzvMDdDEd6YJPiUq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/13/21 12:07 PM, Bart Van Assche wrote:
> Instead of leaving it implicit that SAM_STAT_GOOD == 0, compare explicitly
> with SAM_STAT_GOOD.
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/target/target_core_pscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 1c9aeab93477..dac44caf77a3 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -1046,7 +1046,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
>  	int result = scsi_req(req)->result;
>  	u8 scsi_status = status_byte(result) << 1;
>  
> -	if (scsi_status) {
> +	if (scsi_status != SAM_STAT_GOOD) {
>  		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
>  			" 0x%02x Result: 0x%08x\n", cmd, pt->pscsi_cdb[0],
>  			result);
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
