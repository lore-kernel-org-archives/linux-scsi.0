Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4B5C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 16:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F9B2611C9
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 16:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244825AbhDLQ5i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:57:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343883AbhDLQzS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2021 12:55:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CGnfXn065200;
        Mon, 12 Apr 2021 16:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oyXPny42UprASYL3njDf+6l0OincNFvmkU1QKbsvWCk=;
 b=jFHKrLNl5bFv3ZWcwivXmvTKbumLEHjyAu1isr+ABtj4XP7fYHxy+UoUiU+muC4fgNEO
 AK2ioLBUe6DIZqI6vu68SWor7NV2XKq/zgC+iM0pYQmg8nLj1VydNRRcqlLOxtjQf0Wo
 ynUomYLhVh2pjJYyBB6weCT4bwY35EmTi6n6EVuLqwFZlOm30XZ9/waDI6rd47PlAy98
 IVqpAP14Rj2kvJwE5cjvZwzp71toSpWij7G9W7DWcRn1FRJxrpEJ5oWbBlPDwhuUCMJP
 ycN07gkVmgGjHB2q5mrjMsgE4Li+MtxDO32fgku+5VjPZ44uud1Q2zZBCBo39zZlYscl uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnccnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:54:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CGnc14014878;
        Mon, 12 Apr 2021 16:54:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 37unwxkr82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:54:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2kZ1Nu6OuWbMguBEJXfj3kRf+x09wPLlQnrqN3KG9sInE9mfK6vXHIj7LTImZZbt38aKlQTygCA/tG6F9Jm6zlTLd2twkWaDUJ/J5UWHX4VMFpY3eKls4xicjnWACLkojYp1hFw3pLHV1PwSvkuYe6VYKE+gOIp3q3AOYnIjQMrOSBz7fiaBQ6sLlIJKCuuPwxxAYgQThvbxzg33SK/69kDphtDSzF5WkTrS9j+8vmxEa5yJ9devU/+SHFlbjcNWnlx1dX9b+HDqzrx1MODyl1p+uUhF9veuHoKt8vw/8fl0uk2jlKA3LX/nsp/98wpuNLo2HWdA7mZA/MLhnIcAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyXPny42UprASYL3njDf+6l0OincNFvmkU1QKbsvWCk=;
 b=Rzu+9kmToYu+LSZcvArMeiXAA2sM+/eREx+oFXLDDLffjv9fIpJ75lTK517hofLz2KGGR53aM7ZuX7R1zk/SZomhhhJRjytNYxyA+qzI1TJnnEhJ67MwbmcRCEoYDLI9UatvJZRYQGW4H9baMCKJSXErgTQnRaNIXzRS7vzmy4goptceNPx0ZapDTlsDUHQyyJCVa4YvIN5HcaxXiBSpUbz83v5fBeEHh+Gs9HoVfyXyEHOeGaiqUUsfJb4bY/Qw5d/nq1N0RP3i1dU0ENhrRhUIscKBLWbXSvL1d2imlUGpnujj5zIKTkrGUqBaFXs6uNIxYOdxSf41s1TUaZakBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyXPny42UprASYL3njDf+6l0OincNFvmkU1QKbsvWCk=;
 b=U9QzEkSAdG2pw67SxFw3W3ywIA1ScCUc01RoWiBMonqHpY/pbTe4FHfb8g+5Y9TPv15jFPNw30yfRCvIZgaLF8hLEPh8vb6ouwunTHO6gZvnFOhUTZa3a4OvCxrcCr2WUxTef895kF/2ouB1QdN+L+pKyT3T/nU2VZDNqKQmSd4=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4622.namprd10.prod.outlook.com (2603:10b6:a03:2d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 16:54:49 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 16:54:49 +0000
Subject: Re: [RFC v2 5/7] scsi: iscsi: fix some of the bugs with Perform
 connection failure entirely in kernel space
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210412005043.5121-1-michael.christie@oracle.com>
 <20210412005043.5121-6-michael.christie@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <95261a78-3ffa-ad8b-d76f-f9e609e11bf0@oracle.com>
Date:   Mon, 12 Apr 2021 11:54:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210412005043.5121-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0167.namprd03.prod.outlook.com (2603:10b6:5:3b2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 16:54:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2ae3beb-091c-4c0d-4396-08d8fdd3aee6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4622:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46220BFEA4B32D2415450F54F1709@SJ0PR10MB4622.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p6k9f3B67mZsnPWmwRsVYm59KgTVqcX/pfHguppzZk3bH55PMvCqxEmbQBeWkFYZi2PB/DEEGoqdUegk433eBLdDbHp+qB7eAkVarRtGMfEqdAu7xTvdiirTxhflhjwoP2Iqld4QH47+5PeAIhR4Y3oYxp4FzOnFsET4sGKIcpaYTMsIhawBPz8D3tjQWu2G41SmagDTwbA1DyvE9gRDY55NhUElN5ME7FCH1hiOVHKpnzAX2V08d7zxJ0d2bH+OZ48RwbPGhZByJuuC5tYBa4dwW5QVwAfNlo7NUDdPqsKU4nFWCpoQZk+GnNGRu6pIfOa8Mu8JUQbHlwKl2LL1lAISVrvQAqqtU4YSIx84RopLUCAX+egPO1Tvz8c/rvHY4ykWktx6CZR43+7sIitdGR+D4e9eqtLvrGWkoy8GrqtbhgIkDalJALEMsfOxIdf5KJ8vi/iF0R8eetnw6iEvTXl+pjZ5Zd2XRL1t0+8mAEE+iFQpyGmCGGIO4bMO/GE+DJlUb4oxXhtSNL645lU3J5VqbcApHTIMKem9c8RALIdr2XerBN5BYcRkhxRvaz2F0Qit3fLngG2n1d0Ee6zz9jNye45qUnBG9hPGc9xkKKtvXrU6oiuNDZqlJm6IXbQ5K/G6r5Xozl+FJa3+3bYqNH4TjaaxVxOD5T1P9BTeC6DNZxKCtGupUEUly5ZvldxsOAFcAlQ0AWi9IcbLfAlq+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(4744005)(66556008)(66476007)(31686004)(83380400001)(6486002)(8936002)(86362001)(316002)(8676002)(36756003)(5660300002)(16576012)(6706004)(53546011)(186003)(16526019)(66946007)(2616005)(31696002)(2906002)(956004)(478600001)(38100700002)(26005)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VDVCSnNpSU9LNjFYbi8yL0x1REkvTUxNaEJCdU9XcTBtZ1lVcE9XQk9yeStH?=
 =?utf-8?B?QVVjRHIwQ2h3WW11TEFtajJBRFczUU0xM25iSWkxWHhBREtmMWNhazZMODZn?=
 =?utf-8?B?bHpwMjZXelRPZ0VWaTVJUmM0ZXBOaWxObEZ0UUxEdHJnQXI1YnNLTXUyRXNt?=
 =?utf-8?B?UlN1U2YxTEdlZmpEUHRZUVJXTXR4NG5Ja3kxc2VRNDJTS2wxaDE2SlFXS2x4?=
 =?utf-8?B?dXZqci9mUkJVVVRRdm5rd2xadGZ3eHJQWG9MTmtnVi96azVXdnZERlFMSDBE?=
 =?utf-8?B?UExVS3FaYjZEMGtrVjVaUWtlWlJmYkpGMTcvN2xKcStRQUlvYXVnOGRTRnVl?=
 =?utf-8?B?UEVzYnhRUnFpODFRYUp6NWNqNlRiNHpTczRsL0hmSzJPWFhnRE5XRFlVUUQ5?=
 =?utf-8?B?WmhXQXJPd0lxUlZDTDdLSGdSRG9HRktjSnhlT1BkeHpCZ3JYLzdIV1NuQ3U0?=
 =?utf-8?B?RUJmd0RMRHd3QTd1OFJvdTlUNHFPanQzVTFIYThRU0EzTDZPbU5WbUtMVFlT?=
 =?utf-8?B?WEZVanJCRklLZ25udDVJVU9vZDZ5enJmUmYvbnZlSStDUlp5MzdMYTV0U2pn?=
 =?utf-8?B?ZzQzcllaY3BoV0x0Yk9XYjFxNk9BT2g3NzVONjlWaTFLbkFtSUxUVC9YZjRN?=
 =?utf-8?B?dk1uc21yWXN6S2RpOFhLL0FKS2lTeVdJQVZES2ZhWHljS3lTQ05OU2UwNjk4?=
 =?utf-8?B?NzhHdlpQTStEZnI3YkRrb3ljSDFuNWZjSmRwVC9JTmRIN1c5NlJMaUFVS1gw?=
 =?utf-8?B?ODE2ZEpmZ2hqdzZ1d3AybTlHWHk2RVYxNmtqZTg0cmxVaGplNStJbU9IV0FL?=
 =?utf-8?B?alVINHI3VWtvVHVSYUIrQXJyaUpNYmJ0TjluaWhPVFpYQ21QQ3RVNytjUCtJ?=
 =?utf-8?B?MFJtbmY4c1AyK1dpenlQcUFsaGxsYWZ3S1NmamFTN1JqeTg4d1RmWFNwdUhU?=
 =?utf-8?B?SUVsSzBGWFNqOThnMlA4N3o1RXJVVHYzZ2RSM2xFTmJpeXVRM2JVdWF6M2ZQ?=
 =?utf-8?B?SzJSRk0wQm4xb2lxQmJmS2ZVZWVmeGR2WjRqVG9KZ2hSSWdMajhUckFXWWdZ?=
 =?utf-8?B?RjZIeG11UnFaczB3RVdsU3Y5SGxadVgxMkR1SVc3M2ZaWDhsNzB1WkNwL2Fa?=
 =?utf-8?B?QTFtUElEaHdqTHB2YjEyenlHWHN3enV6bWRWbFhzMnlkMjdCWjlzSVRISjE5?=
 =?utf-8?B?WUQ0RmV4NEdxRVdqWnlHRzRHcWpxZnh4TTJGY1liR1ovSkk1TmVyOWlRbjJ0?=
 =?utf-8?B?OStyajRRYXYvYjROUHkxWWQ5WkNmZEpEUTdXR3o3dW9hY0Zyam9NeTdCaEdI?=
 =?utf-8?B?TUVYOVRBV0dGa0lIZHVEbnFjVytsNDVmaVFML0w1VXNPS29pLzZzL01uZ0pR?=
 =?utf-8?B?NFM2Z3RyTEdiSVBmbmFwa2dBbWIyNVhSY3ZLSFZHUDgrR0I4a0d5bjRPQU9r?=
 =?utf-8?B?bEI0RWlEWUY4d0N1L0NKQThPRmU5b0lVM3NreUZuUjRzSzZoWit3ekl2YnhE?=
 =?utf-8?B?ODl4KzBZMXJTK00xQTBxdCtIR3lmaUJJQW1qKzg3S1kzbVRFQksySmI4Q3BI?=
 =?utf-8?B?SzZqOTNqYTQ3Z3BSN2IrSDZiYTlGbUx0UjhUa2JZSnBVdDZFeFVIbHcvQllW?=
 =?utf-8?B?WXE1WElMTVRVSjk1TFl6aGNVc25NL24reWl4ZmtJQ2FXZ0Eydk50bDBneWR1?=
 =?utf-8?B?cllFR0EwQ0cxeFFGbDdORXJ5c2xGS1NvVTQ1R3dpRDBGYmxNTzlOWklwTmU3?=
 =?utf-8?Q?viH/ZBFPb5Uwq/QNwWhf0PJKHWq4sE8dVWDdGd6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ae3beb-091c-4c0d-4396-08d8fdd3aee6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 16:54:48.9656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EprmKxY1GkA3i/2IvcU+3nUHywjldi/U/bppslETCgtWVh6/Lv2Zn6PZKtkwdqyUd+3hKtOic4RmvG+fky/bHPsPDVX2X5TY/w19V7pzg/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4622
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120108
X-Proofpoint-ORIG-GUID: 3zBExb2MtlO9Es2Xn6Qe9qvKhV2unElG
X-Proofpoint-GUID: 3zBExb2MtlO9Es2Xn6Qe9qvKhV2unElG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/21 7:50 PM, Mike Christie wrote:
> +			/*
> +			 * For offload boot support where iscsid is restarted
> +			 * during the pivot root stage, the ep will be instact
> +			 * here when the new iscsid instance starts up and
> +			 * reconnects.
> +			 */
> +			mutex_unlock(&conn->ep_mutex);
> +			iscsi_if_ep_disconnect(transport, ep_handle);
> +			mutex_lock(&conn->ep_mutex);
Hey Khazhy,

The above chunk should have just been a call to iscsi_ep_disconnect. If
we drop the mutex then we could hit the issue where we race with a unbind
again.

If you guys use offload boot let me know and I'll send a new patch to test.
If not assume that in the final version this chunk will be fixed. Also
"instact" above will be fixed.
