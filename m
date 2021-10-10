Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B74C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 16:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 444196109E
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 16:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhJJQHe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 12:07:34 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40160 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230271AbhJJQHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Oct 2021 12:07:32 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19AB0woE015956;
        Sun, 10 Oct 2021 16:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0Agf2nT4tFg1h+MDAAuTe8M943LMb7e69XEsjVwZpUI=;
 b=yC/yBoFsLufW9twQxddbSZfJ4Lcd1/u9tpplsxkzHED5xXEagj2O7DPWqeL/U24gH0Nr
 zTrFFUBJiefTaNRq+cCg1Plef3uy6cyj54JG9voaS41qCVhORzbQQA+H4h4eBost53W7
 kXCoGdvu1ZBG65sPUiZ45siC857Y6UiXqe2qIO1fa6gI1OJdwjrqtkBWIICWqkWzzRaJ
 /AutuA39sqjqlx8e5dXwUWQ1qbX3Djt2ZoEbY38tawld9KVRXQ/mnpuZtGxE5ITbGA8S
 gSu2y78+xlD7FwL573tFzSIUlvKHy2RUd3TxMrbojKtOabYK3t7sRUVUC4qVFWi98Aa8 kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bkxxa8dj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Oct 2021 16:05:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19AG4wXn048399;
        Sun, 10 Oct 2021 16:05:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 3bkyv74ymr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Oct 2021 16:05:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aac72IXZ1Z+Pnaf6hf5wH6hkEYRwy6ACd25Oe5aIMDF6MG046xQ55Ivse+pQ743dfZAswuZppPaA8L8QfkbZWmmhjFunK2o662Xx5Y6AdWNuBmfjziEpwh64w/HE4UH9HYd8x9PhprgSJfIcOBMrv5wJm355/CnhF5aOAmL4AXgKC21BHJWlxB13z9yKr6IXFVlmV8Kfmu1n4t34TZwI9EbNnyhwUlDX/EFX0b4EsFAR1r5wu7UBV7QrH+dz1GnKsPzYke4yxIWRMxEO1Oy90O+D69QuqteGEfbvxqY+0QdKUbR5vD326G3DV9utl8U5AXT8p5rTBgp/MFaAjO1d5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Agf2nT4tFg1h+MDAAuTe8M943LMb7e69XEsjVwZpUI=;
 b=af/POlDApHMv0ksulux35BxXCbLZmgb68HFx9c/GF997xk36dhyiIeGu8hAUp09lkFsIzFY+9EVxJpr9cU44YpqmPFDxP83bXoTmjPdxnBfBIBv9V2a9L3XrzQNVpXopFGyZPYUAR1siMztayyS6Pq/AWhJPwWervat15f0fEps5dSor7JauDzGMTDwMZwUn1VlXy8zOAtP2acIxxqL6MWpUy7Z31qFa9jWLdq0svEKBVYPU8FyLwAkVGu1BdPWm36UNNnY2Kg5GiOslHgvCRbXj8yKNnmZVGepTdv5RJaxBrxItTkgk+Unt6nrWddDrk9oxPiSs7yf+pZNFZyxRGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Agf2nT4tFg1h+MDAAuTe8M943LMb7e69XEsjVwZpUI=;
 b=l2h7Vm4MTAVQqEsip6mKLb3DU4KK0C8WY139khyOet3MsF+z+jIdz2wyLZqH2ClFZGD4v8Qws4/xyoW7Kg3aA9MNyPwPIJLZDsczQLemp2ZBJBUEVDkYIPdHOl7ZwHNKdrgeUn3L4Y00pCjiPcCss0/nr0OA9wKU8rKJ6FVISIU=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3625.namprd10.prod.outlook.com (2603:10b6:5:152::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Sun, 10 Oct 2021 16:05:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 16:05:09 +0000
Subject: Re: [PATCH] iscsi_tcp: fix the NULL pointer dereference
To:     Li Feng <fengli@smartx.com>, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:ISCSI" <open-iscsi@googlegroups.com>,
        "open list:ISCSI" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Gulam Mohamed <gulam.mohamed@oracle.com>
References: <20211010071947.2002025-1-fengli@smartx.com>
From:   michael.christie@oracle.com
Message-ID: <95db5f3d-99dd-ddbb-ea44-8cd37d92ce0f@oracle.com>
Date:   Sun, 10 Oct 2021 11:05:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20211010071947.2002025-1-fengli@smartx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR16CA0027.namprd16.prod.outlook.com
 (2603:10b6:4:15::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.19] (73.88.28.6) by DM5PR16CA0027.namprd16.prod.outlook.com (2603:10b6:4:15::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Sun, 10 Oct 2021 16:05:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3396e30-f132-451e-64d7-08d98c07bb9d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3625:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB36255F7B25DA4E689698E049F1B49@DM6PR10MB3625.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:240;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HOkGM8T5jhjTL0gF8OCd4v9pvYYauzngpR/uqyoIZk/boQNuSBYI+HJBxy57wRUBnoF+KOWNSMUfv5PGCsYMh+TnYfMrLOLhWzjq9rUa0ip5Y1IJIeSt//TQngdn+EqNTRtaL2SCk/M1tlTegak/iKFa6i+yPn8Gbt0MPJ5OW954bV4/FkZaFHDMQtUTLaxJPpt+GLllCcjt+vCTdgPR5QGyzodberNHWMILI2EPMSecRwFzvmcGmDsmYbPtN/cRPy+widCF768WkVq2Q5dPzALWZum1D0gH997tddwx6wT/yP2yFquIjyd0cRuWaYHZje9uuwBga1QTjGjPwE3REnzPtzvhsPfXoxX20VUU+zI84MRQRKgYu2TKxHl0qbv0zPxrfWkkj83ysn0qyJh+jtvH+Zl7tkMRB/7QkYcn4H2ImC5BMu7UtEirwXdwjXAzSDNY2ClpZJT1wMWi22iJBTp6m6TC8PNNByf/SFFw9z4eRLfk/NBUAly1kMIEfSEG4xe6g5RuIPV5O9HAoenKm4tAZWrE4oYQRAUOA/0QIhHs+UhiRzrjZNp1BBr/mgvqhkg1ciRk6DZFF1kX6OrKOBgsoFkdasvUDzmV/0ks38dJYHNr1leuIddydymY+FFkZFK4iyAPmoxseP0uQOmXR9tjMsb1qD32z/UKq8+tHZOENm0ysrGQT7pgdq7m5525VqAf0kZdwMPifXYh39lmyIZKwyxSLt04RaWKcAGxhwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(66476007)(31686004)(8676002)(186003)(86362001)(5660300002)(316002)(26005)(53546011)(110136005)(8936002)(36756003)(31696002)(66556008)(2616005)(6706004)(38100700002)(9686003)(508600001)(16576012)(83380400001)(6486002)(2906002)(956004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0JSWjJHWTUrU21XcG9mbWNtNjNITVBnMmI4ODJxQ1lOVlVXT1FoeWlaTlJ3?=
 =?utf-8?B?d3dyNFBzSERsZ2pHZlVTSkRLYmVUbDhleXY5S2p3NmMvMmNNR2dzOTJaeDVX?=
 =?utf-8?B?bFZ0NVQwUUxQdDNON2tYWFErRFoxSnYxQWx3S0IzbTFUcjYzbzNsUnJXd3dv?=
 =?utf-8?B?dldIMzFIWUplbGduR28rdFJoR1NRK0NJQk9RTmxZNUdXOEZSQ0MxTWtSUXFl?=
 =?utf-8?B?NitESkEwODFITVUwZitBM1djRGR1VVBKVGVkS0pIbGhjcXFwdWRTZzZ4bnVs?=
 =?utf-8?B?Vi91R0pnSWQ5SXl3dDE3TUxTVUpuRFZVeSs4SytlUmVLenlkMGNwSHJHK0Qx?=
 =?utf-8?B?aW44NWRXem9wT1hDWUtCVjNQZDhlcEZxeEdsOHhxbFArcm1VekJLNy95ZmtF?=
 =?utf-8?B?akJqbTQ1aUQ1NnlZWHVQRm1vV0RxL3hoS0dwdnpZVStSSjFKZTBuM083RERk?=
 =?utf-8?B?YjV6OGd3OTJDa3h6YjdseEprcWFZQ1pqZlc5c0RaTk9VU0F6enRTZkZWSnEv?=
 =?utf-8?B?ZHR5KzVTUjA0TllSYktISGhBNUhKQ0MrL0RpT0NSWHV3bWxPZHorbU9sK1ZK?=
 =?utf-8?B?TzByRWREajh0OG1QTUdaU3VDbXhDSjZUdmFCVTZYOFhwR1BobkdHUy9oNFYw?=
 =?utf-8?B?dHRUSnZFbm9YOGxhelVWMm53d3RoK0UxcElMM2Zwa1RlckUwUlV3bFdTcit0?=
 =?utf-8?B?cXFJbjZtVFZic3VlVGdSUHdWNnZBZ290RDd4cno3eXFjYi9PNmpmcVVsN05S?=
 =?utf-8?B?NjZ5SitCa2dJY3gxOWt3bzNsZldabDczS3N6bFJabGFHRDQ3OWJCdjdYUVFu?=
 =?utf-8?B?SXB1VlVhSldibXFhdXV3cGFrOG1ucGRsa1lJR2R0WW54b3MyZ1g5UWErQys5?=
 =?utf-8?B?Z1QvdndGT2dSL0hIK2xRUzZtZ21vU3hQNzhjWlNKb0JDb3hZa09hWHhDYzRE?=
 =?utf-8?B?UUhYRHd1dFV2ZTlsUVp4OHEvN09nQTMvd1VnbEI5UHQ4REhxaENGekRNUUpm?=
 =?utf-8?B?RzlweGhxVlpYNlpDS1JGalNqVnNDNktpQlBXanNZaXpMOWpLS3dqQlJVK0tH?=
 =?utf-8?B?UG1lR1E4U21ORVJvczMvRG1KUDcrMmxoeEJENTdBNUR6bERVMURvKzJ1eVky?=
 =?utf-8?B?YURXeUtzRS9RZ0lqakJrRkZ4QU1mVEJWZ3p0YTJzS0o0ZHlYUVd5WnlxanRE?=
 =?utf-8?B?c0RYNGhJeDRNSGNXcmpJemM0eXVxNVJTMkc4eVlsZFJMdUhiRFYwV0Q0TkVz?=
 =?utf-8?B?K1RBVTNsc2dkbjk5TmZTMGwybzg5UUlpR0p2a1JPY0VlTlhFNHZRN2Naa0Rk?=
 =?utf-8?B?bHlWWGdqODk2QnViWUhMS0ZMbFRRN3haU21rdzMzY2NBN09jb1BhdGIzbWFo?=
 =?utf-8?B?OUc5M1F0ZStRcWJmMW5OOUpOTFNuMmk4TWNiMThhTE9uVDZ4cEtUY29hS3B5?=
 =?utf-8?B?eEJLSW1mcmVRUUU5aHBHV3dabUQxaHEzdkc3L0R2WExKNVYyTGNHL3R0Nnhz?=
 =?utf-8?B?QmdhcmpoQ2xDclJ4WmtlTk1EWU9qemRVK29RTGVCN2FtZ3JaMzA3OFZiNEpr?=
 =?utf-8?B?Q1o0TkJadW1ETzZtU3pnZWxmaWZRenV1ZHdxaXFpeUphNVlTc2tOa2dTSkpw?=
 =?utf-8?B?cjF3cC9PYTV2SDAvaC9CazhEUElJM09Saldoc21tQnpWRXFQaUs1VWdzaEhM?=
 =?utf-8?B?M1JBTmw4NHhIOG96endnWmh4YVZLNnpSRVFaOWk5ZXplTGRhN2JjMUhmbTNy?=
 =?utf-8?Q?5yJvkYdlFhpM6X3EmZxLqa8LnuQzpGYlfNnrPwB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3396e30-f132-451e-64d7-08d98c07bb9d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2021 16:05:09.1699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5Gh0DxwVcV5/+oOjGF5oYvf1Vr7G3Xe9VxeriRerKYZexvnDOxdw2wV+BNLSf/VgW36qA3UgS+M3Anf1C1i12OW6HOnXVRUSAi794kYs7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3625
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10133 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110100112
X-Proofpoint-GUID: UV7U-eW63MNWxMlcdrnO3gFOvr2AadYL
X-Proofpoint-ORIG-GUID: UV7U-eW63MNWxMlcdrnO3gFOvr2AadYL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/21 2:19 AM, Li Feng wrote:
>  drivers/scsi/iscsi_tcp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 1bc37593c88f..2ec1405d272d 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -724,6 +724,8 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
>  		break;
>  	case ISCSI_PARAM_DATADGST_EN:
>  		iscsi_set_param(cls_conn, param, buf, buflen);
> +		if (!tcp_sw_conn || !tcp_sw_conn->sock)
> +			return -ENOTCONN;
>  		tcp_sw_conn->sendpage = conn->datadgst_en ?
>  			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
>  		break;
> 

Hi,

Thanks for the patch. This was supposed to be fixed in:

commit 9e67600ed6b8565da4b85698ec659b5879a6c1c6
Author: Gulam Mohamed <gulam.mohamed@oracle.com>
Date:   Thu Mar 25 09:32:48 2021 +0000

    scsi: iscsi: Fix race condition between login and sync thread

because it was not supposed to allow set_param to be called on
an unbound connection. However, it looks like there was a mistake in
the patch:

                err = transport->set_param(conn, ev->u.set_param.param,
                                           data, ev->u.set_param.len);
+               if ((conn->state == ISCSI_CONN_BOUND) ||
+                       (conn->state == ISCSI_CONN_UP)) {
+                       err = transport->set_param(conn, ev->u.set_param.param,
+                                       data, ev->u.set_param.len);
+               } else {
+                       return -ENOTCONN;
+               }


and that first set_param call was supposed to be deleted and
replaced with the one that was added in the conn->state check.

We should just need a patch to remove that first set_param call.
