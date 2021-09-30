Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0A4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A205961166
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345060AbhI3SsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:48:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40330 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344925AbhI3SsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:48:18 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UINlhD019365;
        Thu, 30 Sep 2021 18:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9F6PTgop2I6dYDzDa7sv+Mj/IR87trgKqxmg3fuODqQ=;
 b=eyVA8dnRrfLi7AmmpTAiQQGfFKTTdFGvII/M0v/lHngLtPDyKaV4UVBRVvF3Or8fHKJY
 VyTU7ZbSWOGCMkP7t/3UNUKlx7WZ503gBImLqHLLWfxjqaMez8n5EZaYDWVvzbic4WEQ
 vMOeMQI6J+0sHg7vAW8VBJ/46nnkVcvRnTUJFJ29XOvKMuvA5+WwiEO9vEIqoXoib5Xy
 n6Wf52ugIDu04E07gTTNpsqMUk4aIBi6DBtbq1z/3BDXuPRNW+VuXED9sKC/c6RIhfGb
 pOKdeM2XWiBJlBm3cvR0TN7nCSsB2nW8P8GYOW/a/V4xDM+L8cD+aWHyZUliJL1NxLmw bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bde3can2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:46:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIeHrn059012;
        Thu, 30 Sep 2021 18:46:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3020.oracle.com with ESMTP id 3bc3cgc4vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:46:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/yKYHjfRmNpFCKE3rPtIAT4lzeF/g5JwqfZTc3CotPPBw9aM0FGDLeMXBYLtoSDLl0WWmkV0As1AqLUNLYAMCOZLHW21OBRERZhtuSB+yyvYS84EE64mk/dsUtwQAm6yIdS4yFSPiB8JB9xYIA+VdryXZirq5MHIS5/wFQh5R7x5jLDsp7kJslz8LzUYrDFONA6sek+PTZbbTpFkLRVAgc7EI+sxQHjtn9OCgh6zmT2eeYNthTa1LwAAC7SNDcp0e08Ex5LS9PVS9FtLGasw90vDCLNKFmFiBiJcnRKsWpZcX0WZ4iVbu2my+ZDpC/JlYBOelMYVeLVw5axE9jX7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9F6PTgop2I6dYDzDa7sv+Mj/IR87trgKqxmg3fuODqQ=;
 b=gkmcFClp7DdnXytJ3fpRgV+7EneRS0Rln1WNg2xlYwWlh+YGAN/J9ncgWX+tboMnKCW6un5jmkfpfFS9+h4ltj/8Llw54nsRkv66mg0b8ENBFBnP0yWiF1pGT8+mbc/Dnzq0BC12+EKGGLnISQt2Kzbhsrd8mpfdqKa/wXSUEOSBz4nUSqWyGBpPjI5IGaD6GvHof0scj0iijiYxp5usKQdSC8nf+JSvN8JHzw65ZOeJkPEjdBA756tKFQYOsabWoFXO5QNEwMzLN6912yIM4TX/CqiKcKfquOrG5wBLuw/jvOcppNiWmRHXHzHcPoy1wB6YSW5dQaSxsQHF0SeAqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9F6PTgop2I6dYDzDa7sv+Mj/IR87trgKqxmg3fuODqQ=;
 b=UqM5mI7LJzW/Rip3DdxPmNOVokM7mWp/Zh2+jlTJsqqDV+jw6b0d/ttX0NTqmnw6l2l6KvGzCCvMih0RYQl06QtYiXUwVeOhuwOm+Lnx0xiEE8yp3xmlo7JjWKnoV6Q+cBh2WDYXqvsNSSb0MW51OQdAkVK9tEXxQp48SNKmbog=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1387.namprd10.prod.outlook.com (2603:10b6:3:13::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.15; Thu, 30 Sep 2021 18:46:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 18:46:31 +0000
Subject: Re: [PATCH 2/3] scsi: target: iscsi: extract auth functions
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20210914100314.492-1-d.bogdanov@yadro.com>
 <20210914100314.492-3-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <c55719fa-9150-b64e-306f-b8b31a405be4@oracle.com>
Date:   Thu, 30 Sep 2021 13:46:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210914100314.492-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR14CA0129.namprd14.prod.outlook.com
 (2603:10b6:0:53::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM3PR14CA0129.namprd14.prod.outlook.com (2603:10b6:0:53::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 18:46:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38fffdf4-20f7-4caf-ee89-08d984429ea8
X-MS-TrafficTypeDiagnostic: DM5PR10MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR10MB1387219E425A6613345EE332F1AA9@DM5PR10MB1387.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LH8tmhSnC6536i4qixQ0sU822Kl05Vmlut3pNxI6YcvIUH6fQW0424daJAUNNyevbPlNmr1lUCZLTtuiBH6juvUzOPSlMJPfUvQXpLQ6anO8mOEVMr9FXfozMZfdSN4CFuGzmqu6LNMttI0tkClST6BbO13kJvdiIbpaS2cTDf0BVPmB1j21B+m/WiH79DFpiwq40gZZj0PPSY0oz5xq25g+u5MW6N2tcUuGrHDMOfbYx38Fq2V8HeykGeeCpKtiSRh7X1AYJN9ZaX2ucuEp0vvSq8DuMkLB6n8iFCiEEgEQvWFwvXYGXKdy6D7yFzxBIqSvec/wytDkdaNZTU3Hlahotzo7ehbOmXK912X44X4YUZtTXJwC9xKzA/coTDGYdMT6Rg+gulmSg0CFqi+2I33RId5zOzGlrl/ASV/IujdqjMj55Z+lFBxPs8ClB86reHOOYm3auuiIdtpxQ3QO5KthXXdVLwggYMhIMSPaOAjXtqJrE4bdd32buFs5oWVl/xkcmI1xvkVSLRVzwRxft1TkzmAi11BpH9In/qMNuE8WtA724of9YL++z0JMfXaDSSr58u8WlVf/27o3KAahUZmbGUEV/BIwRGqm4NWH+ne1wrPMhx2iUOQaQV7Tz3vkEbHyO1e6ag2jlR6wVW752rEhAIenq9SfuiFcsugAAJovf7VzpepAypjLi7fv46nbgr4n39dzte5YGV9nrZFPVblz8CXAtfqDLJoCWFcA3lrKBjWiZAWdTx6BM5njT+664VrPLUdNGpZt4STvAYJvsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6706004)(66946007)(83380400001)(2906002)(38100700002)(6486002)(5660300002)(66476007)(16576012)(110136005)(54906003)(31696002)(66556008)(316002)(86362001)(26005)(8936002)(4326008)(186003)(2616005)(956004)(36756003)(31686004)(53546011)(508600001)(8676002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmZ2Uzc0ZTRyU2NjVTByRHNXVlAyK21kWFBvYmVGa3FZdTJhZUhrblNJdnhu?=
 =?utf-8?B?RUZpdXNKOURzcTJ2VDg4eEJZVkNYek9aZFlRV0dZU2syRXBOWi9hVlNERGlu?=
 =?utf-8?B?VHRWTjhIemVKNXlZOGczVy9DTnh3S211ZUphQ2UvYkRoNlNHTW5kZ1E1N2x0?=
 =?utf-8?B?MElEb0puWlVqamxaSWViTlI4VEZlVENJVEh5SjBPQUNKeTF5U2pTODhrcjRq?=
 =?utf-8?B?dUgrOEhTdUFzTUlZdjNkODVxanpkUkVERXpqYjJhblFLdEY2SGpLSGlBOU4v?=
 =?utf-8?B?d3FSM0haN2QwejhmYmhuVFlwNW9aMW1WN3oyUENxUXJ5Mi9KWVJNakNqME9k?=
 =?utf-8?B?UzhhMEY2cGtHekh4b2pURndkWkpoTk8xNXdUV1lTQ0N0NmgwaUVrZnJ5S0p1?=
 =?utf-8?B?NG91djI2dTBIbGR3K2NwN0NndEs3L0pSc0Q2Q01HZ1UyYXptd1RmSEZtTlZh?=
 =?utf-8?B?aGw0WEhxa1VpazBKRExjcTBxNFBueUt0VlVxSlVUVk9VZVUwUTFrNGpGMlpO?=
 =?utf-8?B?aUVsUHYrQVREWkFxYTlsWWFzTFFXcjllL21DaWxLbVNkM0o5WVJTcy9jVXJl?=
 =?utf-8?B?cmdzV0Z3elFFeUh3QW4ybERHSXp6UXBJQk9uVWpaY1RDVWorb2VObTE3MG45?=
 =?utf-8?B?L1BIeUI0UDBVNVptKzRaYnJNcEJCS0NqZG5uUjBCaTJIOERMa2Q5RGtVMGNx?=
 =?utf-8?B?ZjQ1MzFPemczNm4xWmZkVDFmYW1WSHlWWWFVeFRpdjF6Z1ZJcmtGY1RhSmUv?=
 =?utf-8?B?bW9PL3YwdS9FTE1NNm93M29jeC9iVVNyRDVmMkpFc0lhRUJxa2ZuL2lNYlJy?=
 =?utf-8?B?eU42QnpKZjNYRTRzN29VSTJMMXlmdjdJM1NKTjY4T01YbmhnUXU2dVp4WEFI?=
 =?utf-8?B?YzJ0U3Faeks2TkhEWC9lZVpqRk1CTzZCNDZxaDhocGdBR3JydWQxVWRQMFUy?=
 =?utf-8?B?RS95cUs1WlUySHVRV1F0QURDRVFCd1dCbGo5L20xeWVtdit1QTdYb1JSWlhC?=
 =?utf-8?B?b2NudFFuRXRldStMSTJ2RHBmd0FXM3RHT2F3cksyMDJEaUFZRFZ2LzZ5MWVu?=
 =?utf-8?B?TEFBQTQyZis3NDdPbTdHYVRDS3FOYXFoZUtuaExOWExYK0lVbEFRTlpqNU9R?=
 =?utf-8?B?aW0xbXVHTDl5M1l2ZWxXWVg1RkVVTU5KOHA1SXRrZmhuNjRlOTRhdXhuN3Ax?=
 =?utf-8?B?RG4yVDdud0hGejAwWWZZVlZ1d2UrL1RUL3NOZmREUENUUnJQRlNOby91aWNN?=
 =?utf-8?B?OFpIRVhuYmpidU5Ka2dwQXdPQnhwWnZra0sxM2E4U0lpUHlTT3VKTTdHaGF0?=
 =?utf-8?B?TytsVTRtSFg4Y2Z1RGRBSE9TcW52dUtIOEdPK2tQOU5hMnhWbDd3S0Z4emM5?=
 =?utf-8?B?MGp3QjhpbTgxZW9YRWRYMVZUZXdKTnRHbTR6Nzh2MXZtWmpJNUhjWWtCZlJK?=
 =?utf-8?B?MGVSMVRWSU1VS1ErNnRoSEpKSGorL0UyZ0FDcmZoMDRVV2NCL0h1eFF1ZnYx?=
 =?utf-8?B?NjVlK25aR0M2VXlwTlVJVVFCR3hJTWVYUHJZSCtLWkpqek1DQ3RmYVJBMnFI?=
 =?utf-8?B?TVVEdGx1dmR1L285UlREQ3hSTlpXbUdyQWF1S2c4bzRuWVc1QmlMTmtpS2JC?=
 =?utf-8?B?TUZJdVZqTFY0TGlSMFE1QjJ2ZWh3ZXE2TGM3dElNTGpIOTRnSlVQL3BUbTNP?=
 =?utf-8?B?eks1WEFPNm5rWTJEZDZCdDlpM295RjZrTnY4MFhjNVJmUXBybkNDOGtyR0tx?=
 =?utf-8?Q?sfYx+SEHK9aCuNfuia9eTdi3gfXdQGlNOMrGeMP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38fffdf4-20f7-4caf-ee89-08d984429ea8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:46:31.6144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jf0PsHj7r6NXKqeRIJjFNgHzVudjqhhDs0y2xkNEGjY75cuEqT7AwcbSgMLAG4d+oMIje/phI+Cl1+qMtdgnmylRuEv3hbLLecpBuMQ69k8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1387
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300114
X-Proofpoint-GUID: 04grLa8DRfp34dXOiOHOxqCa5FH5fQe6
X-Proofpoint-ORIG-GUID: 04grLa8DRfp34dXOiOHOxqCa5FH5fQe6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/21 5:03 AM, Dmitry Bogdanov wrote:
> +bool iscsi_conn_auth_required(struct iscsi_conn *conn)
> +{
> +	struct se_node_acl *se_nacl;
> +
> +	if (conn->sess->sess_ops->SessionType) {
> +		/*
> +		 * For SessionType=Discovery
> +		 */
> +		return conn->tpg->tpg_attrib.authentication;
> +	}
> +	/*
> +	 * For SessionType=Normal
> +	 */
> +	se_nacl = conn->sess->se_sess->se_node_acl;
> +	if (!se_nacl) {
> +		pr_debug("Unknown ACL %s is trying to connect\n",
> +			 se_nacl->initiatorname);
> +		return true;

Before the patch, if we didn't have an ACL we would go by
conn->tpg->tpg_attrib.authentication. But with the patch, if
we don't have an ACL, then it looks like we always require authentication
which I don't think is right.

Is the code above supposed to return the value of 
conn->tpg->tpg_attrib.authentication?


> +	}
> +
> +	if (se_nacl->dynamic_node_acl) {
> +		pr_debug("Dynamic ACL %s is trying to connect\n",
> +			 se_nacl->initiatorname);
> +		return conn->tpg->tpg_attrib.authentication;
> +	}
> +
> +	pr_debug("Known ACL %s is trying to connect\n",
> +		 se_nacl->initiatorname);
> +	return conn->tpg->tpg_attrib.authentication;
> +}
> +
>  static int iscsi_target_handle_csg_zero(
>  	struct iscsi_conn *conn,
>  	struct iscsi_login *login)
> @@ -874,22 +903,26 @@ static int iscsi_target_handle_csg_zero(
>  		return -1;
>  
>  	if (!iscsi_check_negotiated_keys(conn->param_list)) {
> -		if (conn->tpg->tpg_attrib.authentication &&
> -		    !strncmp(param->value, NONE, 4)) {
> -			pr_err("Initiator sent AuthMethod=None but"
> -				" Target is enforcing iSCSI Authentication,"
> -					" login failed.\n");
> -			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
> -					ISCSI_LOGIN_STATUS_AUTH_FAILED);
> -			return -1;
> -		}
> +		bool auth_required = iscsi_conn_auth_required(conn);
> +

In __iscsi_target_login_thread we have:

        if (conn->sess)
                conn->sess->se_sess->sup_prot_ops =
                        conn->conn_transport->iscsit_get_sup_prot_ops(conn);

before we call:

iscsi_target_start_negotiation -> iscsi_target_do_login- > iscsi_target_handle_csg_zero
and hit the code above.

If conn->sess can be NULL then iscsi_conn_auth_required will crash.

However, I can't tell how conn->sess can be NULL in that code path. Is the conn->sess
check in __iscsi_target_login_thread not needed?
