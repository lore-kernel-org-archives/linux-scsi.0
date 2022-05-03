Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C36AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbiECUgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiECUgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:36:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444172E0AE
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:33:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243KDCJO019152;
        Tue, 3 May 2022 20:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=h3+CdebaG8lNLH/F9Ucy7VsheQht2t11wnYf427TZU8=;
 b=dbUTF0x7zvJQ4uVxS/NnPTkKAkzzN/VYkjqVxiO0DO84H8K4JTAI7aJsLW2AlHMntOlT
 l60snsAPTKz5g3yAME4xg/PvcfuB/EFwkSVtrxkID7QRzNxbMcTwCAC8xYt9a8rbS3mf
 7jScN99YOCAWwba7LdIrR3ZzupXm8vtP5ubDjf6CV0JdXUVikd677vKN16ADnrKxUKLp
 jHbe9Uh9jvTzbmpJXixjmu9OaTmw1CL3yUdVZ3uuuDWec33tZ3hZ9u9u61j99k9SPtlD
 Z6uuwYw2wuHpyLoH/Ttd6OY5inVDMhoymSiACek/H5+p5gXMmp9ThFhasW0DJYExqlMv rQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0apjtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 20:32:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243KEnkp016685;
        Tue, 3 May 2022 20:32:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fruj2qtv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 20:32:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fylcX+dhGrLsb57BKzFokuRTtPRBbM2qFhfDJYkSIxmJVEdKx0OCu7DDpXqhv54JgsYowdsd/bXcgGUysvPvH8Ql1mz5Eejxz6BApSXGel/n6+4G5amFXvLNHixPnGTxWdpG9+B4cUM6HN6RucdtCOJB4QWf/q11tnmXvtXj9OGOnGgDBFjLQsbTQ+sj8zrSEK4QPbfi+FXWsf+TwbZ9tzjsSH28FioqD8xapm0BK0+QBD47x9bGi7rLeHVmXfRChN+QfEhxmJYJIvWf759pmF08zty0LxKKEkOW/07cwyH5w3EtJP+aAG0syCrSP4d7lfj+LycxGKCrP7MGfiU68Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3+CdebaG8lNLH/F9Ucy7VsheQht2t11wnYf427TZU8=;
 b=fOqxKVf6cvinvfp5V7REKvgLkiHYxWfz6Qtykr0fA0TAozBpXux0ch77ZeA64L3Az/R6eadv/kon1WORlmYX+uuZnIE2NCb1u5ZX7enJ80dVmxrFnJR+VrzMRVRQyIN2kq9erM+C8Nc9uoPlDLZzz03JzbiXK0dyEbTy8WWExx8dnYkiP1FMdRv4Fd5zwFMkhGMquGG/Skk4sQoK7IhPwnoEB+uP92nzBy5XPl9q7mUAmUqkb4lJdABbkJsgBI3v4kN8GY9YI3hGnTLhamK2XatziqasJ1m06ZJRx3WVl5YB/LYFCAwlfv2LDiooZ2UDn5TrDAXsjuipn4QZ4lQ00w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3+CdebaG8lNLH/F9Ucy7VsheQht2t11wnYf427TZU8=;
 b=pVdqE32fbCybqZmRYZDb5z5x7kj1MHBaK5FiFOizuqT1qw62LT8VfVUVWlmsGcflri6ogl7CUN+euOj+KhIzlQOxCjSNzz3Rg+K6i1tyPgkF66M7m2Et35eviO/eLQZfygrhQSUEGDm12ADX+/iVTJ/j7zIufII6QXvaY870ePw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Tue, 3 May 2022 20:32:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5186.028; Tue, 3 May 2022
 20:32:56 +0000
Message-ID: <d3fbdddc-69e2-bb78-8e91-b2d4da3d9798@oracle.com>
Date:   Tue, 3 May 2022 13:32:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 04/11] scsi_transport_iscsi: use session as argument for
 iscsi_block_scsi_eh()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502215953.5463-1-hare@suse.de>
 <20220502215953.5463-8-hare@suse.de>
From:   michael.christie@oracle.com
In-Reply-To: <20220502215953.5463-8-hare@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0026.prod.exchangelabs.com (2603:10b6:805:b6::39)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f72fc85f-d63a-43ad-004d-08da2d441b17
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB29571658898E7E9FFADDBE3CF1C09@SN6PR10MB2957.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AH8QRQltOBGSGHBuDZGZ4RYL7CjJ6wqWUYx0im5tvlB7MvZZu3ILIOmA0WuvuseCFAiplTpg2u/e9sbOohnPUxmx5nGHZmLIgK4+pJIbnOmVYZBq/6N+VS0Kl134uM9YScW0rUt1XTSVhvNqzqB7/vav4d/cqpTDV4QSNgN2BWf2plIL2d4+G/N/YgtvKAcG/Gz0jt6NanHNAadHbzh7aOUQetVOKfrHRyECYn1uGuErCOFGlBGt6VNPHP558jr9h1h9W/eVdKodk5Irp9lq/O5FAgoRgg9HRMhJOLZmtnIOEUMwGZIk2NA1rvFHavotX51OoWrY0/FuXKzQxJUmKEwyHeYh/wFqA41rHMjeC/mAeBQ9yKlBC2Rnh1l8ctrX3zf6ZxR9hZmf69dJdnLjT21NvyHYFOvJm+kZcOsx8rO1AQyyu3MAJEFfCbJkU5bdcuEtL3kU/zUho8bUeyT2ALjqg1qUijpZMNnJNsEmnOP7jF99NsNXRldlueBpoJ/F7a6Cxd465UvUjynJEFlie2cOhFn6qSBbHQB6y78Rfhuto29k/XUzzIMRUpKJz0jxvo5Cj9aJCTBK6XwHRrYapsTh5ZrJ8v+ZNzTEWzMiN+yfj9QTZZC4uFZGr5xiCbNnHu+oo4bVOq2yO9WzkmYgNFx9GWoHTlFVGWo+z1FBzm6Nz8BkdA926si6cO3X3ggjLOSOYST5RxNXHGLKkT8VWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(186003)(54906003)(31696002)(110136005)(2616005)(6506007)(6512007)(9686003)(26005)(508600001)(83380400001)(4744005)(316002)(66476007)(4326008)(66946007)(66556008)(5660300002)(8936002)(6486002)(86362001)(36756003)(2906002)(31686004)(38100700002)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUgrS2tYSFFvNWhJdEVKRGxYSjBCTnR2a3JxZENURy8zWVhvd3RPMnRZKzE5?=
 =?utf-8?B?N2xzOUFtMUxRcFVJZzNWeHZxUzhoUU9GUmtoQVRld1hxVFlLOWtBWWNnbDcy?=
 =?utf-8?B?Nk44dGVTaUhpcTRQRFFSM3hjckl1S2cyUnowVXYzbkR2T05hbTUwUUlmV05F?=
 =?utf-8?B?bzF0VUdadFBnalFXc3RpMEpORmFodzlWN2p6WkR5a3lBVkJkc3FPR2hIbU1r?=
 =?utf-8?B?TDhYclphY0VTa3NHeEluVjBrZ25Ydzd1QWFLa3UrMDMxZ2F2Y00vMkNpODF0?=
 =?utf-8?B?Q05DTEp1VVRicFpEVkFJUjZXQnA3NTZEMjBQK0xhZDJuUTIweExiY0hPeTBj?=
 =?utf-8?B?cktRVDB2RWVaS0orTW1qaFJNYnpkR0tWclgxY0JpQjVnQ3NkSEk2eE1oZi9F?=
 =?utf-8?B?TGN0cmhvQlNpQTA2cGlFZEFtajZhMWNOZWErNng3cTF3YlVtblV3dUxqTlZQ?=
 =?utf-8?B?bTRnOHpZZDJwTTRLcmUyTERWZUc4YUtGWG5ndncwVHJrSEJaLzE1OGhaeFdk?=
 =?utf-8?B?dGp1MTRoZG5oczdXYzN6YzlmeEEvbkEwN2Zacjc3azc2Z1ZQd0FVellPajFq?=
 =?utf-8?B?UG9FanlOVHlxSnNLeW5xdkNRSU15WWNyb3NoVGRFQStBRm0rUldSYWFXWmJ5?=
 =?utf-8?B?ZmVXamFidWhrMk1OdURRZ2NHZXhkTE1EVlhNWXV2NkZrOGFBdVgyZmxWcGtU?=
 =?utf-8?B?YW9ZK2pmZEZwYlhnS1VjOVhSTHl4VnU5Q0lvaENuNmQwT29SWEF5dllTSkN5?=
 =?utf-8?B?Rmhma1k1dUJNRWg1ajVkZk5zNnhxeGJoQU5QbnNoZ1FGVytqd3dlMjlPdHBN?=
 =?utf-8?B?c0NhZVRUMlB4NTJjSnE4dEgycEcvam9VbnpsZXMzZWRORjV4SU1FcmZNRkh2?=
 =?utf-8?B?bTV3dzEwbzdkOXlieFREODlDTmd5TlRsZ05uR0RTb3VUaHBQMldDSml2aWRx?=
 =?utf-8?B?eE9BL2ZobGVtL1RNNkdoMTZGZXpMdGZ4ZUw5Z09lMDcxclVaNW15TTRrNlV2?=
 =?utf-8?B?M3RCOXlXVVpxOHhXSklFMzhMN0U1ZEZIQUh0SFpnSy80dDNqQzRIK3J6U0ZH?=
 =?utf-8?B?S0JHeDQ4T3hBUzQvSGtvMFkxWDZmeUhqbzFvL09reU41dEx0VFkzRFF0NE5T?=
 =?utf-8?B?REdETGxpTGFBU044cjU4V05VTU9aTTNNOUdGTXQ4RWZ2bFlaLzVZV3RrRWQ5?=
 =?utf-8?B?blF1T210UFg2dC9KK1UvQXVPcnVuK3hza2hzbVZrVzB0YVBDU1k3U1dDUkY2?=
 =?utf-8?B?Rld3RjJXbUZxWFgzQUowakJ3TTB3bFVyMmVQa1lnU2lLZXNTTVFmNDNaMFRK?=
 =?utf-8?B?d2I4ZWpoRjgva3ZtQzFPV2l0Y2c0cjlPUW4wUnJTL0Q2S2R3d2VMcng3YnYw?=
 =?utf-8?B?MmdIdFV1L0s5QkEwYStJMFRpNDVuNzhSR1pXclZMUUVrVVVRaFp4ZFBuMmNM?=
 =?utf-8?B?cWxCaXl6NmRBdDNUd0ZDdEs2MFhBR2RNYzMrS3VCa255TWZqMUFraDhlRE1P?=
 =?utf-8?B?WXhKM3c2cGQxcTJLbkpkUytwZkdIdE5MTFllTm9CUHIrdTlLL0daL0FGZ0Np?=
 =?utf-8?B?S1VHYmpXRDRIcnYwMm9CNWpCT1NjMitlQjdsK2kzSDc0LzVMUUFBR09ONDIy?=
 =?utf-8?B?ZEpKNkFSQktWaWh2YWVxTmszeGlacU45cm1rQ0drdlVXaC9YMmZwRHVnVkFr?=
 =?utf-8?B?UVBXSE1ONjJjUWZqdlY2VS95SE5JVEtLeGZDYWQwV3VGN0J2ZHM3QlNERy9k?=
 =?utf-8?B?S0pReEthbzdZNGZUelRSWlRWUDBBd3pnc201eUFGVWRXdVdrRGR0OXFPcnlQ?=
 =?utf-8?B?bkNLVmJjN1ZrYURxb2pPL0EvU3FhQjkxSEIvRTFRVmVFMGNTaGx4TmxCTFJM?=
 =?utf-8?B?ckE5OHh0OGFkb1h3ZFhEcStDbTNqSDN3UjJIMEZ0a0MvNG9HdVdXb0c1VUxD?=
 =?utf-8?B?VE1QUjRnTzJ6cVZPTkNUaEtocEZqMTRQZ3J3ZTJMbjN4d1dpVVBwN0gvenlB?=
 =?utf-8?B?TGNBUkRYc1lWeEg5VVErc1RWRE02aTk3cEJwOTBTNzZ3ekVwcFFQMm8wQmIx?=
 =?utf-8?B?LzFuMm5DQUtvbWN6WFlzZWdFTk5rV3JhSUJheFZISm9MVjZuTXl3dlRHWGow?=
 =?utf-8?B?a3VzTjBEZlhnTHhQQ1I5MFBhRzVtS1J5Zit4KzNwVERiVS9ET2M2L09NcHlO?=
 =?utf-8?B?UUxqVVF3N1hwMmI1VUxNbGQzN2V6Mk9BWkRSOElFODdRMFZ4b1pma2FQTHJ5?=
 =?utf-8?B?YmdnMWVIVnpqRnNQdkFONGNJWWFielhkRGdzS1lwOXZCcGRxMkZLMStNbUtX?=
 =?utf-8?B?U3U1bWZTUUdraWRJRmIrUGpDWTFKNEQ4YUlBZWxUV29WUmhKWFVXdHRUNDhH?=
 =?utf-8?Q?ukzmn35YybdXt6rU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72fc85f-d63a-43ad-004d-08da2d441b17
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 20:32:56.3427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I47SmKVnJJ/AwAYpJkl1ikzsf+3wSm+y+vkxehDr2dBfT8piEnDCm2G0KInAKRFo3pQrYOMjo6A0hHtUMosmrU20vA0nTpsORveKdiXkuSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2957
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_08:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205030126
X-Proofpoint-GUID: iwjD2DHKrdoV9wvUxw6nP7zxsQ7pVk7c
X-Proofpoint-ORIG-GUID: iwjD2DHKrdoV9wvUxw6nP7zxsQ7pVk7c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 2:59 PM, Hannes Reinecke wrote:
> We should be passing in the session directly instead of deriving it
> from the scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c       | 34 ++++++++++++++++++-----------
>  drivers/scsi/scsi_transport_iscsi.c |  6 ++---
>  include/scsi/scsi_transport_iscsi.h |  2 +-
>  3 files changed, 24 insertions(+), 18 deletions(-)

Reviewed-by: Mike Christie <michael.christie@oracle.com>
