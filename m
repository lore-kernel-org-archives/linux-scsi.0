Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B6CC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 22:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A89B664E92
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 22:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhBLWSf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 17:18:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBLWSb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 17:18:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CMAFbV098762;
        Fri, 12 Feb 2021 22:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uRCJJ/edjgJSvmEs3xaLExicaWz+pm4a1kFXhfN8wO4=;
 b=cnjqFxYQP5azuo8NRW8Zhk30NqSSFDtrBAcZTj/t5puSRHZ0MomrUG9xz9q3E/xid7yb
 cF54Ajh/4jAAX/zP67lb79BQEb1RZD7LraQcsB5wIo4DPHpQkIQYvANvBL2/Ow+OMJdt
 xotUWrHBBn8okGNhFRCtnU4HxhgH7YU4Rar66NAwWp+xRaI05vt+oVuCm5FsHPyERzWI
 lFzPuUMbITjMWQkZRSKNcjmIs0/1G8d/HX1+wyLorKARlOujGWXMC0B9ESt+Icx0ohIX
 253+b6IJnK7qiQmogSA9GJrepWetuHdJzVl+2FGPowFyp+WQ5zzYXe8DYTnDG0ipUApF 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36mv9dy07n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 22:17:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CMEr6v003954;
        Fri, 12 Feb 2021 22:17:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3020.oracle.com with ESMTP id 36j4vw8v5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 22:17:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igVj+OEB3j3Xv4WhvE/Dv6Cu8v8avuKd/LSW2OqzngO2N0Gw9MuUs+COFRxOknxI884vDXOOXVXCGmkiSQ4p0si2tukDLMt7KeinYAimqhBaudk04CZByRgfg2Da/V2gCMt2FgI7D8UpWSnOOft/SGCBpBbI1PLOqUY1lOX8MdcSwnDWJhbI4w0tpdMm1LkSw+baHEqLIbcDoGv3ik1oqLnrc9V+QLxGhkapKj/GgyqPvG9XEVc/tlesrYaJcx1Ng0fqFsH/+41TV2QzbDPkzOP9gnGkJVv3qq6uuSsFxMzi3GyntpkfeKAXr7r90e03GbRXQ6xr+KQeiTJksBn1mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRCJJ/edjgJSvmEs3xaLExicaWz+pm4a1kFXhfN8wO4=;
 b=T30KM4lfcKbdlVHqk0s4NnhyxAo9G4SHGhzA+RaRzcN2Akbb69luP4gtwNmmWx9v9KbhU9jLAEBXnbm8XGeX2N3Te+T49kzpKO33n8EVX7mcu/DLz/faS10u2i2erDCRNaS91Qt0C6glPVleVG6yzAHcmKLLf2uBPyXZ8oZSz+hzW+Ydez4n2mrNGCzQl1gbOpCFgUzVzwu4A2RyEu/Bs8QFA77fFolPcGAuVJTVG4kqtaA5wJSsZkYrXUXW74QGnO6dR90z48cNFhSuZdS4QSR4qZXEgs4sg0x2ZaIhHmDJgUjLYQurcYt8nbzvEYNCLvmfJGwJdi/8Gn8l+m0a6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRCJJ/edjgJSvmEs3xaLExicaWz+pm4a1kFXhfN8wO4=;
 b=zEYVRp0FfB33PVXMtNlogauSlfS9xPtmKtcyttbtaDHBplVYlslilBGgwboYWumkUlKocHhGOvA6rOLgACyy76qz8KLIJm95va+yEb6q0kaK9S9ltdqluiZNvQRzURCMWUA38FLBMB02vNcKLXE1YV4vzP9BXeZWH9cjesDzkpQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3365.namprd10.prod.outlook.com (2603:10b6:a03:15a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 22:17:38 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.034; Fri, 12 Feb 2021
 22:17:38 +0000
Subject: Re: [PATCH 14/25] target: remove target_submit_cmd_map_sgls
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-15-michael.christie@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <6cf91481-5c5d-0577-85f8-a454135581cc@oracle.com>
Date:   Fri, 12 Feb 2021 16:17:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210212072642.17520-15-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:610:5a::21) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR08CA0011.namprd08.prod.outlook.com (2603:10b6:610:5a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 22:17:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d73eac8-0113-40ba-4510-08d8cfa4013e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB336502A07DDB5300317ADCC6F18B9@BYAPR10MB3365.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KDadCuHx1e7NDzFCkaxVwEVAOkf9JygLZwhb+UVm4s19jbqlgmkZgaGNOda51ykYCqyX9oWECtwQCcA7exS/+2zZAfHr9Ypq5IIaQW/mMyQhKXYsRZAM5DQHGe2z79PV/vSHGqeahMQGhvEpp9lB7mEZGAwElRFGe5ALwehD1SpvpILKN2dpiw+ymKU6+Hx1RbUg6CTqqBqTWoy77IxiA1PLWNdLnVax8eBBeMNR8o+bVNrP27M6bolBhflrsFvVDY1ipfo08vE/u0iCOT0nz6JG6wTu5apDRFWXWydMwSuPDu4+u2/ocET1neCdFoFzQ73z2eP5czkmLGTXsBjAorksW4g7NduZ6fk1VHpV6jud6pHhOiWiJKowk4XzyNRUaQzEM+cdI9R1in4P4xwaFJV+eRHWmvGN/+QzDqvxUdAl8iud3Uo07H/I7gPEPjHZ0YBpCxJjs3bnosxrBElEs5sGc26TLXDHGtHjO3TaM1gIjEhhuoTZOIdoCSz+5YKSfpPJtyPTgqvYLevsr3TS5poNSNiLQyKxVw7x9RQof6/YkeztQpVFeSiUhVfiKKp6/P7GjPRAeFO71+fM5D4ecYkv7gKH/EBuROe0Ao/413DaPEavkYVhfvY2qu7qbCuN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(366004)(396003)(8676002)(5660300002)(2906002)(2616005)(16576012)(31696002)(66476007)(316002)(478600001)(66556008)(16526019)(53546011)(956004)(26005)(66946007)(86362001)(6706004)(31686004)(83380400001)(6486002)(8936002)(186003)(36756003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eXlHNnhZaDZkSzlzNEhrUXQzTmtjdmQ4dHV3WlAvcXZIUmp6MGtFYzJUcFFG?=
 =?utf-8?B?RHZiMHFTeGI3SFRoY3grcWUvWTh3bGVTcURoRWdjL2dFNGZiZ3NWaHBzYUZK?=
 =?utf-8?B?TkVObWZWYllBekYwWklYZnVZZ2Y4MVdlaFFvaDhtVXNWL2oveWZkNFdBSGlZ?=
 =?utf-8?B?QmJWWExZL2REeWUvZjlXWmNRd1hWMXF1djdsQVpiMzU3ZzV0SEFFK3pOQlhP?=
 =?utf-8?B?RWczNElLNXhXTWY5QlRkYS9TQjFmS0oxTmhSMmppSExqWk15VHQ4UHlTMVNV?=
 =?utf-8?B?T1JYMDEwSEJMMWlhaEkySEQ4TG43d0oxSTJhVzBOVElVT2JpUTNsWUJTOU9N?=
 =?utf-8?B?MU9tUTlzdU1JWXBZUGNYby9jMHJPMVlFMm1wVitSSGxMV0JiWEtlb0hMa3d2?=
 =?utf-8?B?LzFLV3pnNEcycnRaSlhLeGxhd3RMWDV0bkxkd2tTK0tSQTZQc0JLdFRoTFBX?=
 =?utf-8?B?Z3MvQ3BIUXRPR1M4SjQyQ2F3djFadkdyanZ4Z3NuSS83UGZKT3F3QnI4bTdD?=
 =?utf-8?B?RE02dkVlWTFVdm0xaXNnY2lWU0pheUdtektKZW9Lb05PQ0IvM0JlWVVmV0Vl?=
 =?utf-8?B?TUpiQWZXdlE5ajFCZjJxL3NUNHlvc1Fia0hSSFViaG5ORjBwdHlqeE9taFJ4?=
 =?utf-8?B?NTFPUjhoN0poTDZsQUpYS3FCZEF6b01oQ3MxMEQ5SGpJeVI0UWFVN3NoeDdW?=
 =?utf-8?B?UHIzNlhtTlJUN1AvY2cyVmFmU045aWUxY2VvSWhUaFM2eWNjWU0xQlR1M2tp?=
 =?utf-8?B?bExBaVRtbW5odHdsZm8zK04wZnhLZnZUd0ZhcjVzd0V2QUxJUG1IbXZ3ejVk?=
 =?utf-8?B?WnlXQlB2RkFSVTdjM3RtWHpZenJNZFozZnEzMHZKdEJCclpNdkRnQmxkdU94?=
 =?utf-8?B?c2pkM1BOSnR2dGsyd3Z4TU4yTE9DN1VlV3hSYUNsdHdWMFo5QzZOamplRlFO?=
 =?utf-8?B?eGFPekVkOTRhdkhxL1NDWUQ5Qy9zSDFnOWN4RG8rY1NLZE5VYnBsdHB3cHdO?=
 =?utf-8?B?TjE0em5pdTdQOVVmNDFnb2trVWY1cVhUMW4zcGZtYlpCUjdKdWJMU0RrWDda?=
 =?utf-8?B?QllLZHFhdGt2R1Z1Mnh3U3V4ZGdMY05PQkowZEs1RjUrQlhpUTJXeG53WmtB?=
 =?utf-8?B?cnFKekNSNHNuSTZkaGwwcWcyV0hPc0NZZi94ZmxqOGY3WFpqaC9sUjdXQlpu?=
 =?utf-8?B?TTExYVM4dEJ4KzJGRk9nNENTamtJbEE2YWNOU201bXNpbHBYTGkyS0l3Zy94?=
 =?utf-8?B?b25FdDZ0R2dncEx5NFVFWmYxcTJOejhZMEo0cXM4a2RKbTdQTFlJM3BZYjdI?=
 =?utf-8?B?bCswbVpFSXI1NXVVdlU2YnlRNmI1NHV4aWx3aVBxZHZDZTcyM2xWYWhRVVhH?=
 =?utf-8?B?RGFGaVIwNFJ0dWJqUkUxeW1VK3BtWDlFVGtJSUZmcEo0Vkg5WTJZTE04OUVP?=
 =?utf-8?B?UkRta1RsQitGdHlZcDJ4Z1JnRXZYSGZEWWI0WWQxNFdzU2FQRzhIUHpVT3lS?=
 =?utf-8?B?YjZGUGVqb28rVW1yNERyQ1pkQzFWQi8wMllzVFRZcG43bE5ubkwxR2UzWHRL?=
 =?utf-8?B?d0VNNFdkaGhVV3BRRWJUajVZeE1rTGFBWTdxbnJIYUVROWNvLzdUSnh6L1Vz?=
 =?utf-8?B?Mnh6YjFnb3VzbnY1TXkvNU1ickhkTUFKWitJL2c5aytLNFhDTUd5UTNMTzJQ?=
 =?utf-8?B?OCsrbGR4OXhUS0c5YVh4WHM5T2FUSFFxQU9PWS9ONDJYaUJPY1pJODJPb0J0?=
 =?utf-8?Q?B08Iy5ctcbh/FOATZX5OW7ARAehW/uHYDl7oCB1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d73eac8-0113-40ba-4510-08d8cfa4013e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 22:17:38.0176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eMfGlvVIAOA1BMKJiaLEKGyUkXgtJsCLstPIQMdLyO0+BuOppvx/jgiQU/fgFFCh2a3+1mQhCdurPZ2jZNrEdTddfBlzSrtue8l206YXU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3365
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120163
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120162
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/12/21 1:26 AM, Mike Christie wrote:
> + * This function must only be used by drivers that do their own
> + * sync during shutdown and does not use target_stop_session. If there
> + * is a failure this function will call into the fabric driver's
> + * queue_status with a CHECK_CONDITION.
>   */
> -int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
> +void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>  		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
>  		u32 data_length, int task_attr, int data_dir, int flags)
>  {
> -	return target_submit_cmd_map_sgls(se_cmd, se_sess, cdb, sense,
> -			unpacked_lun, data_length, task_attr, data_dir,
> -			flags, NULL, 0, NULL, 0, NULL, 0);
> +	target_init_cmd(se_cmd, se_sess, sense, unpacked_lun, data_length,
> +			task_attr, data_dir, flags);

Hey Christoph, I think I misinterpreted your review comment about adding a
warning here. I thought you wanted it so we could detect there was a problem
early on. We can't do that, but I can do:

+	rc = target_init_cmd(se_cmd, se_sess, sense, unpacked_lun, data_length,
+			     task_attr, data_dir, flags);
+	WARN(rc, "Invalid target_submit_cmd use. Driver must not use target_stop_session or call target_init_cmd directly.\n");

and we can at least warn someone at some point.
