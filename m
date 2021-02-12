Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20F0C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3F2764DAE
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhBLTI7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:08:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhBLTIw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 14:08:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ3rqL026531;
        Fri, 12 Feb 2021 19:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Swdn9c58v8tewESKK7IZu+ZjEGnBA+nx8/SZ8AJ1HpI=;
 b=WgmHXuRMnK650j6nzHZ0vohh5ueMd1cwPWdgz9tPM1cdC22ND7ZHDyS6NRknswPsawyg
 IWUD+VOYC6YVVmyGUAMKU2L4A6oOIJa9HSYZgYrzPHo+0WV4+OO4OEgOJp6TAZ7r9+bc
 gNNBpdX3Agr4pD+7UT3eTJj3XYW7sgXzLo0HF/+w6p8idtPKG7uHnTIBm2N4H8bzp66n
 +sK5efPh1NNwFkYv1xFSiaaqF+2TqcxHBVkNwOzCrspm9ismGi/PT3IgumGlQHpNJOrY
 vYj51rys4RVZkWThJHB8q1oOASRsY6sKoiR3IP6UPsRJ7PdnElHRPFmrQwtqCjzGFAGL ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36hkrnc915-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:07:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ4pQF108759;
        Fri, 12 Feb 2021 19:07:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 36j4vw3e98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:07:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvwtFUhjks4w8kjvTOut79wG5lcgPL0UKe345SyZWJ4G4kRH/0RfwfiOxLSCSFnl/r6YSDmgbPeH6UWOxp5ff+ons+sUsqY/E9LwbnZWC8687Jy27FrfWWaxfeEHZBoP+4TmbRcM0rTqszDn+Y6tsKUySgsHI6Bmp5sykbJ6tE3qI2Bx8SZsDW+GHGW+LJPr+U2JMf9UFXOC/HpqZWu/AnHHobtK8feRygNev38/8WR1ljTmaKc8Ygsod6tZzjBT+6QKJdJWXu0isVlX3djk7LDRjzqu+eYaMy9HLYW2bcDB1moibildiXKR7KnuLhf65HvxmMUdHP52rCniwODZWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Swdn9c58v8tewESKK7IZu+ZjEGnBA+nx8/SZ8AJ1HpI=;
 b=AgFg5yNunUsfNjvcDYcDsmphQevm38q11T/jiLJhVRZvCHfuXiH47mE7Axa2IulonxlReZhC8RITQ0i96hmnqJC05S3ihj8/84hMge4BtJJzpcuvBuYArHOgWo48RKMIDJBhyjLxaACkmnG13umfTY+ItvAYZ44I8oyW+Sb40xLlZCY090hmUuu3L3EeYsE7khFt0vU/jvMHJHunsFszshLQJq5ZPSaPwhNKisTinvBtL7/UKnNPkSRCvFtXW3Xa1wTrEMruJBwK0TqfmkP3r1Q/WDyQRGv9rmPq06L70jO9EEwv10Pnc/fpBx47AVKmGGEnU+5e4Wg1h9x4cETeig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Swdn9c58v8tewESKK7IZu+ZjEGnBA+nx8/SZ8AJ1HpI=;
 b=ZDhUJ9DtKP1Ex4nSMsy8DaZEjYumvMQI4uxNQkNoBZoXLHKiuNxqmE8NPj0fw1/UfFr77VtYG9wqbZS283T8ZiaKTlUQ/tu6cxmMZgMCw6FlEpJ/Tx3WeKUo0GMymicYP8AkRqjQ1oUd8JPjwyI8Ig0aWnKe2T6voJnGpM0/GTg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3087.namprd10.prod.outlook.com (2603:10b6:805:db::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 19:07:57 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 19:07:57 +0000
Subject: Re: [PATCH 01/25] target: move t_task_cdb initialization
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-2-michael.christie@oracle.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <81707642-68cc-74e3-e459-30afe27dfa37@oracle.com>
Date:   Fri, 12 Feb 2021 13:07:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210212072642.17520-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0601CA0012.namprd06.prod.outlook.com
 (2603:10b6:803:2f::22) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.20] (70.114.128.235) by SN4PR0601CA0012.namprd06.prod.outlook.com (2603:10b6:803:2f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 19:07:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3aabc26-8d5a-415b-152f-08d8cf8981f9
X-MS-TrafficTypeDiagnostic: SN6PR10MB3087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB3087BC1A72A5655BA3AD3075E68B9@SN6PR10MB3087.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26MaD/0IIK0v7AGQnGdHFRhm0suPlsfQbMLttE+5mL0mvtfbqHJZToy2d1Gt1YxYUDAcgSN5j5UsoDLofnHmhP3Iuvtn3AkUFei6DSpM5SZ+dlnbT8+1ZZKgacttCSq7bDgXRDDVhGWqnd19q91lrOoDKUy1JmgtaOAHMCRuk11UEFFEP9CqZEiO5cvFVo2ascEyC7tIU8N9oKpPJLHbcqdkdS+EeY7NRigiAV7Kuro0vSeRg91oHoH0feSh+tmoMFCn78IfSmY/fGOhqH2tju+IHV5hXkDVcY0fE6ihEOyph+zk4vxgjJ+e4qkJrP9wRlj6cKuWV2qrnEKLD0HdRcFJElq/eLt089whkT0GYIiZXSjT5MN7Avpey2OszWhwloQ+rf02XWZU1awpP/ARgGzhUc35Wv2dpS78ggeMOCT+xHEgintRReqWkrnHDdnyoKEIz0TNhS3pATuz8T2JYBdRFH0vEN61rx4rtHe9/e1M/WOeJ5zrIfy3looHh8QswQ/VTSSU53WjYjEa4SvCs6IhpQYR62g83PrXEDxlTT+BTaCUB9ZX0S/jNDrdCkF//E/gDfEXqq99W11aseziiaXGhX9NSODWc6lQH+JGcNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(136003)(366004)(346002)(83380400001)(66946007)(2906002)(31696002)(5660300002)(478600001)(8676002)(36756003)(186003)(2616005)(36916002)(6486002)(66476007)(66556008)(956004)(86362001)(8936002)(26005)(16526019)(316002)(44832011)(31686004)(16576012)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dE1oTlcvUzZyRjVQUEw5R0tLeHVNY29FM25ISkgyR1NEYmt4WWREVktBK2pT?=
 =?utf-8?B?V0pVVWozVnBaSnRyMDFTQmVhMXk4elByU3VRRnQ4YVUvV0lMSWU4c3VVY3Bw?=
 =?utf-8?B?VCtGdnJndGVtcUlGRUkzM1hrSVI4OFBiL3Q4MzYwL2Y5RU50eTFKcjRySTg0?=
 =?utf-8?B?bi83eUpyVi80c0hQQ1FWSk9SS2lReUJsR3RvMjJSTUJoYTJMUlRvYkI1VHhW?=
 =?utf-8?B?elIySFVnUUZnb1I3dlYzZWFVZmdTOVV1UkJad0F2UTh4Z0o5YTRLbjhuMlJr?=
 =?utf-8?B?SElsUE1ScXdVRmV1Ym9hdmZQOXZRSkg0akxzbkV1SVRnWU5kclRCSW5PekZx?=
 =?utf-8?B?U3g5cmFuZmVPVnJNZUp4TVhRbjlCeUF5YUpXbDVoMHFyRHh6U01QKzFVSDRY?=
 =?utf-8?B?dEJzQ1M4NXhtMWJ4Ymx0MU5QSGlacXl3Y09jYUdHTUJueDlWWDFQdEd5TzJL?=
 =?utf-8?B?bzNvZUxVajVQUlhtRTA5OG9yTWx5L0hnZGhaUHNpR0hHQkMxdVdGTXUxOEt5?=
 =?utf-8?B?bUYzaFI0OVJBWUNsWlZEMytBWUhzU0FYRDdjNFlqS2ZmQlFBMll4RDZaQkww?=
 =?utf-8?B?UndaQ0I4ZlVCa21wR0dnMG5OZVkrNnBrc2hkbDJkQ2sxRGQ4Sk4zbXY0ajJR?=
 =?utf-8?B?S2MyOHRzWGZwUmJKWnZ3T2NudkVkZFFRRDl6U3UxczNRMElNODF6cEYvRDc3?=
 =?utf-8?B?ZFZRYTBlMHF2clNGeGtQWDA2N2ppbStjbHdFYWk1OTZDVE5zNWo2cFpIdEUz?=
 =?utf-8?B?OXZVZkVhdk9JOUN5ZHA2VkVEUXhkWTNTZ1ZpYXlFVDgwcVk3US9EV0tZT3hk?=
 =?utf-8?B?dmlzOXJ4bjU4eTUvVHJPek5RVSsyZDRFU3JValFRRStkV3Q1cXZXdXNpdG0r?=
 =?utf-8?B?NThBZERyUzlveHFmcnV5WHZaSUlYUnY0VUZ4RHRmaVprcFpKcUh3bTBXMjBT?=
 =?utf-8?B?TjRxUmQ5TENxcGE3UGhvRndnVVNvWGRHZENJNzJ2RmxvRlliSUd5YUU1MDZV?=
 =?utf-8?B?YUxFUjl1Rjlkd1BSeXVkQlcyZEVPc1I1ZGFyQTFHTktXNDZ5WDlqVDROY0dH?=
 =?utf-8?B?UUFoOUozZjZ0VzBpWVhXLzQrV0o4YVdkakxnZEZTbldVenRCakpvWmZydHJ3?=
 =?utf-8?B?dThPa1Qza2xSOFRaOS9hc2lXVG9UWnREd3pqMEhZTStNYUh4Z01KTEw5WVh2?=
 =?utf-8?B?OWhCbE1VZVlvY3dFaThwZ2xGQk9uM01XeHBQRmFhblUvOXhyUVZrTXB6cCtQ?=
 =?utf-8?B?YW9EcTFubW1PN1MxSllNenZLQll2RFJLWHVPa0xlVGp6VC8zL09nZllvTnM4?=
 =?utf-8?B?V2tWak03d0Q1VjlJTmRyTkJGeFVURHdzV052b25adGlXSmlQVlZ3R0IxU2lU?=
 =?utf-8?B?VGoxS0pPZ1IxeGZyN2VIQXkzaUJzakxtaFlydVlhVkxNZllMcFhkWFJqRHdL?=
 =?utf-8?B?OXUwcTZHMDRQUlpCRG1KYW93SGlGYTJKMHRiWFg1TzhRRVV5S2I1YzN3NGda?=
 =?utf-8?B?UlFaYVZMc2JZQ2pqVHhkb25yMi9LdTJxOE1MNnFnUVM3QVVSVTI2WDY0RnBK?=
 =?utf-8?B?MkIrVE1xQmU2UWt5cndEa0REK3ZPeTEzWVk3UFFLdGVSY1JBMy9pUDJHRUxU?=
 =?utf-8?B?SldwS1MzV2RMaHllUXc2am51NkJGOVJPZXBWT0ZvWldweEpWU2NSRUxrTzNW?=
 =?utf-8?B?TUFiN00xdVo4VVFxbGwxTVJUcEc1MnVXZmhRTkZ6MCszQ2pEdUR5ak5XT09w?=
 =?utf-8?Q?82XWNRtutFJ0aMSLQxf+M7wWIVqpz+eZ9bph9VF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3aabc26-8d5a-415b-152f-08d8cf8981f9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:07:57.2418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gV0zqBBKD8sTEQl9ahKyF6XNrCG5/KdWhhb1RAmZmOQW81u+OUle6mI2V3JEtmSechA7xv/yqgMrCbO9mAh5hM9RSpqKgT4eB162DBi7/9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3087
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120140
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/12/21 1:26 AM, Mike Christie wrote:
> The next patch splits target_submit_cmd_map_sgls so the initialization
> and submission part can be called at different times. If the init part
> fails we can reference the t_task_cdb early in some of the logging
> and tracing code. This moves it to transport_init_se_cmd so we don't
> hit NULL pointer crashes.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/target/target_core_transport.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index d47bfd8b0f87..5c4adde96d5e 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1389,6 +1389,7 @@ void transport_init_se_cmd(
>   	INIT_WORK(&cmd->work, NULL);
>   	kref_init(&cmd->cmd_kref);
>   
> +	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
>   	cmd->se_tfo = tfo;
>   	cmd->se_sess = se_sess;
>   	cmd->data_length = data_length;
> @@ -1430,7 +1431,6 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
>   {
>   	sense_reason_t ret;
>   
> -	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
>   	/*
>   	 * Ensure that the received CDB is less than the max (252 + 8) bytes
>   	 * for VARIABLE_LENGTH_CMD
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
