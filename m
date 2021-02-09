Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FF2C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 18:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E043364EB1
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 18:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhBIS6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 13:58:30 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49734 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhBISvY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 13:51:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119Ii0AA071366;
        Tue, 9 Feb 2021 18:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JCYGehYki7l4xI7iS9AeQ2HL2C2urue4zgilrWjB/K0=;
 b=paCQaVFULiU0Rd8XcPJcxrn+FNxvAvciYczN13TBLruco+47lefXYPYrObf1pUoUEAcR
 rEN2yZaFkPm15h8HQbYiOPNHIz0sqpopre0a52uFhjq4jQJAL1oVjneBBsAkmiYdgicV
 N038QX2uXyzPV3s6wlSWw6nj+wiVB6H7DZedwb9M1Kk0s8ns+0+QJi9MzwdvYHx+eVnN
 T/bKR+L8Zoegpo1douKajRTSWJ59Xl8Cc6rpTbjLU5HKIANuYBtystmsw4f3JUBUdRPl
 Edp2knOeXYUfPmzOO3Eof8bTg/jgsOaypngkTITs4j0y0M0bxzPIdsoM3N3kURt1g5IF Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36hgmagrfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:50:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119IjRtp171076;
        Tue, 9 Feb 2021 18:50:26 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3020.oracle.com with ESMTP id 36j511m769-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:50:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEYd4BdX/sd8o1ZdCwfsyxLuKC1mOdicAAjsenCcjurb8lLNjkevZE8kGCbL8Jaf1u1xhcR5SePi47INYR6OdPedAkeinpT0fRG/mjTgjI7NgrGeBOQdtOmCtDJ6lkuzBG+Ci5TS4X9YKpS1XcB4aGBBRK2FbKnPnn3yGYZLF3QiM2pUk9kK5efyv0waRhuzG8ja1F9RqjI6VUVDUw1Hd8nrGlWIusac+RvX+DLo9wpSUxtF0woFo2FvqhPMAV0y16FcKIoPHZ9PgOBBv0iiEzL+stIRbGa/5Btwfcdw1gf1HD9cENO6jp7T8nMun6gKM2+XNUe1xon3VGCrXG3r5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCYGehYki7l4xI7iS9AeQ2HL2C2urue4zgilrWjB/K0=;
 b=nNqXKO3pwCheezKFcle/V8E87XCeDVdcIrF5iaNKfpw8J0oVHTCNKkozuNGuuhYw4gTiaMmcL8Ezf4hS35N3gzN4zMHnF5S+zCDF1Tt5xt2OCMkCGSIaYViAXHklvsZA8DHZOKSMVvfBk9LiiKeEYPv7I9zGRgZGP3LnV9Au2dvcDT4uf2letqDz9V8XEs6u6Nceg/ko2fLIRP/C3V7rKfowIBktiWfr7rOdjn40TqeYKYJw4pMEi4vfQCle8GAYes9LzqS/MlqG3nX8RqZiox/ywki/noTbfQXvZWivonMlUx9oKu7tyVLyXJSZKYBuZz0pwr+M5OHCXyIaHfaQlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCYGehYki7l4xI7iS9AeQ2HL2C2urue4zgilrWjB/K0=;
 b=QI+cBbssU06AqozxwIMpfdLRlzndeSIQIp8aLRmP721n/LeDKTvYcY89GDzqdGaveQkOMtpubYK+YJGEGdBYEFN4uy89PhKebUSjbnBsuAUkApchKzS9MQ2QEDHRgau47I1G6uRadntaYHn4uVxSO0zplqBCdVrTsr2W/y0dHjI=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4719.namprd10.prod.outlook.com (2603:10b6:a03:2d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.20; Tue, 9 Feb
 2021 18:50:23 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 18:50:23 +0000
Subject: Re: [PATCH 11/13] target: replace work per cmd in completion path
To:     Bodo Stroesser <bostroesser@gmail.com>, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-12-michael.christie@oracle.com>
 <3eda9fb4-1a9f-81b9-82e2-1c5bda1d7de4@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <a8c3fcc4-8db7-7739-75e3-940ef00db950@oracle.com>
Date:   Tue, 9 Feb 2021 12:50:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <3eda9fb4-1a9f-81b9-82e2-1c5bda1d7de4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:610:38::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR05CA0058.namprd05.prod.outlook.com (2603:10b6:610:38::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Tue, 9 Feb 2021 18:50:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3aa960d5-6e79-4ea6-e678-08d8cd2b8edb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB471907AD7CC3BA30F2C7DABDF18E9@SJ0PR10MB4719.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+b6yavSOP8IzpICQBdIQmM/nGnXKfvur/3rpDBangu8OqYLO6eZlj2PX8kKhImmzzy+nLQumQL7T6GZiSknRRhhqRSM+Ziu98Y2BYVH5mNGiINH+CUvb3Uxq4v9m/IrDoDrmMPOPiGlVPbV350bLcdjrP02hNKej1OOK45+D0kcKZPAvjefkimEvKQmWM44Mwj1WSJ8HsvJZwIzen4lso5Q8C+BrClk5YPm2mAwk9gZbwzEdgBFJT1XXxVu7OIJGWcTLd6JvvtpYsaPS/IyiWU4CRhUa/i9XgMtVgG/gCWG8RwUhiTIkL7e19yr4klZxq43ZTdmhYXvf1qSIyaZpdjXbJpXdr5iGBKS7q+Dqy4TTPOwfAXOamoEkQ9Ssl+P7nip56WVKV4DlUhK2rufC6OtDb8tYnnn8WNI+txxJBhYyBOdpP/kr3t24H6sFAhSwuoJ1hZzHcPv3FMkRPP8LxKE3kyUdb+3Ee3lD3JBOhWEdmTgty7Q2gUHepLbf7mJmZhr9qLaGyOxq3cc9KR/E4tjjt3e67LQ0LUpGQxdWhcQeItLewKvtk08irvF4KBiY7qVU5eSKLlBec0WfhtqkL8oIInWAzDLheCqDLVGP7GTiliiW3U9xQO2MxqvnesJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(36756003)(66556008)(8676002)(31686004)(16576012)(53546011)(6706004)(4744005)(66946007)(66476007)(956004)(6486002)(5660300002)(186003)(316002)(86362001)(31696002)(26005)(2906002)(8936002)(2616005)(83380400001)(478600001)(16526019)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZHJKM2lhSFpCeU1NdERMREhnVzJyUE9STlozcUpvSVJ1TDRGYmkwdlhEckdi?=
 =?utf-8?B?UDhjZkJYdjhkMHI2U3J3WC9jcktjK1ZTbXhWejhYdkM4VDloM2swclhzN08v?=
 =?utf-8?B?K1MrUFVSSzdjSFBQUWRhVjl4M0tSRThGQ3p5a21vMWVlZDM5dmtTbkhOaFMx?=
 =?utf-8?B?cG1LdGRzQ0k1RUxQSkR6cE0wL2lJUGwzS1laZkdDcTlqUHUwcm1RTG11THlV?=
 =?utf-8?B?NVlPNGd2Nk1xSEp3UDYweUpSZExHTk1WV0UxS2RMaU9laGdHeXdtNjdCL3pM?=
 =?utf-8?B?eGZXSHdyRVhUMjltalpNNlU0bmNGcy9OMWxWdkYzVWduRTlSdkV4b1lja3lw?=
 =?utf-8?B?VkpUelJwQVMzNjk5ZVRIVk45K0dwT1JVa0IyN09xWmowWmo2RFNEdC9KNXBB?=
 =?utf-8?B?WVRSbW10cXRPUHYzU1JhS2VyR01pUnRpMFV3c0NqRDlPdmljN3hna0MySWtn?=
 =?utf-8?B?VnVodGdZcE8xWUloZ1pmQTJtSjUzNnp1S25ybW1qYTdBSzh3RmdJUXU2ZHpo?=
 =?utf-8?B?ZU4rdzFGNzBER3I0RjBVWUV4Zmw1bS9uRWIySlh5WDNsL2tSUlVNOGdZZjkx?=
 =?utf-8?B?WnVVV1F1d1pROStDOWU4RVVZanJDeHVSbXhmVGVZbi9SYm5JOVUvRGhBcWZG?=
 =?utf-8?B?dVpyWitObFNFMzk5aDBpK0kxRkVCWW9MOG9uNm5oZ09SMkF0T2hCV2ZQMUI1?=
 =?utf-8?B?eFRsZmkwUFpZc0Mvc1RxZlBDV2hBSTR0ajdvOVN0MVYzakhDSzJ4UnRldlJz?=
 =?utf-8?B?Q3E3cFVaa0dUbFlBRUpjYTJDNVhERVlTZFlkbGRvWnUvNDBGdWpQckV5dHNx?=
 =?utf-8?B?WGUrZ0VrS1hYblFLRUcwZHZXT3M1clZGOHFsT1lkNEtlM29BdWlCb0s5SXow?=
 =?utf-8?B?K3JtOElxT1RGZ1Jsa0N0NVFGeHljOG1TK1czNTlXR2tlV2lBMTVNU1hxbFlJ?=
 =?utf-8?B?SEVWaDZ2SnVobFVFMkw2bGs5LzBIcjB2NllhaWJ6VFhLNlBwWmdUU0lreFBa?=
 =?utf-8?B?cXA4d0tkM1dzemRFODIvdUMya1FHQ05VdlJpUitBa0JFVGdaNkdZNHFxdmlG?=
 =?utf-8?B?dnJuUVlVRVRobXJjRzgyM0FzMWVhOUtoWUs2RStTZkJuTFJmdmduMU8xZUR5?=
 =?utf-8?B?R0RqQ2tMeG1kVHRERy9xZk1MdElHa0NHVEliVXJuNUVZK1BqRVNUZm5hVVpM?=
 =?utf-8?B?Umx0RXJUcCtBSDJ4NjJRN2ZCMW5zMHpHd1FienpBL3RhWElQM2dnaCtTaC9W?=
 =?utf-8?B?MGNlZzVKUXQvaWNnbFIxTUI2Q1hjcWRWZ0N4UExxZi8yRnpScDFRTW5MSURY?=
 =?utf-8?B?bFZSRTdqcVZ0U05EYitGUmk5Q1ZodzdEM1F5d0wzaC9lbmFJUmI0UVhwUVNt?=
 =?utf-8?B?WXMxQnhEck4vT0ZLcEJFa2JxTWNOY09tWUVycm1FTlJMUDNxYVBCZUllV1R5?=
 =?utf-8?B?bHFBMHVPUnNrYng1em91emJiUFREb3gwNmNCeHVhbXpvM0FHTnV4UHdmMmJM?=
 =?utf-8?B?QXRXOWI4QmFFTnRmUlE5RzVhOWVaWHJPTGlqeHhJb25mYmR5R0Ivd2VCRkFl?=
 =?utf-8?B?NmVnVkhZMkxmV2hoM0ZCSlYxeGNmSkZlRWoyZUxxazlOaHdpRE53TmlwaHVi?=
 =?utf-8?B?STFqL21ta2NQaElKQzYvN1p2TWR1QkpVSXM5NERjV1hOaU8zUStMell0QjhF?=
 =?utf-8?B?THMrSE9GN3FMeGh1ZTJnZFpuWCtZUVhKMzRtUEJXZCtOOG1QQkJqano4WFZw?=
 =?utf-8?Q?vm2px/l2plfMwHmCUaf1NMq0R2BGrD0X5bkqkOz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa960d5-6e79-4ea6-e678-08d8cd2b8edb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 18:50:23.8188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4upnfmMWJEUzwjKKoKNkjmGupy6DP3DK4Jheh9fQdPscdDt/Ztpj2nLd1hNDy6xGRB5+FWoDMCk3D3rFfhWPZTuDKvFTuJvTwdnuwK6fV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4719
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090089
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/21 11:01 AM, Bodo Stroesser wrote:
> On 09.02.21 13:38, Mike Christie wrote:
>>   
>> +void target_queued_compl_work(struct work_struct *work)
>> +{
>> +	struct se_cmd_queue *cq = container_of(work, struct se_cmd_queue,
>> +					       work);
>> +	struct se_cmd *se_cmd, *next_cmd;
>> +	struct llist_node *cmd_list;
>> +
>> +	cmd_list = llist_del_all(&cq->cmd_list);
> 
> Probably nit-picking: I'd like to reverse the list before processing like you did during submission.
> 

Yeah, I flip flopped a lot on both. I'll just do it. I didn't notice
any perf differences.
