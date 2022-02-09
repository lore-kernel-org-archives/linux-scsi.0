Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2ACEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 21:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiBIVYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 16:24:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiBIVYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 16:24:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8056FC001F75
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 13:24:42 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219K5l8t008856;
        Wed, 9 Feb 2022 21:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Tp01Gg8+Xa9XKThtmW1zrmktcrm5dGMkjCnswg5Joas=;
 b=lroA1LKkyMxiFf7iFJ6uNjqt+ZgM4n1Tsn8TER0IK5WEFN4Q3XNu/iO0j8S/FWgz+9r2
 iMnsVYlQRC4sDRZv+9GdBefNEKGd11wPEemWti/lo4Z4SNrNkNCfre28I5YuBGYKMGVp
 sme4zVyaTnVvz00vOoNZNgq2uPNGRVzD/E651U/L699ix4DhXqG8alkvx3mFY3bfAVdR
 fr7/NLsPvmiLWwQUCNnV3I/HXhSAbsSLFQRkmTJXACPlPggNaMalm3XptcVp9EHGQ/x3
 pitjJqwpvxv7OCnFxN+cUrmXlmvS/Dx0HqP0IIYuJibr/FOy2QUKVxpPKXdsTMGqi9cT vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgp1ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 21:24:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219LG9qd186020;
        Wed, 9 Feb 2022 21:24:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3e1f9j322m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 21:24:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGPd7NueTjoSnVd8GNXRsdhbfU7x7f46wezx9o7kwdsip2Y7Y2UvtPCCu3MKTk0X3osgkgMGM9bcYfsA+2lMnErC+4o7PBZMuQZZq0PrBPrrAenFOb8uOv5wR/L2FfbhzKJmWNTDljrIY/t7cdOJNG+2NMJ7okycWJnTPerGv6XRsXE++Kfu5YK3Xdx+i4RB7XWQ9VlfdRlDpblHzj9YlIkqYP+dep4/K4nM9dcn83ivkl9wmFjIU1VzPne/qUfBgjVNBZ/cKqjiYNMU/9l6+fJD45dauHNXdhtUr10ztipU0EV8pXa5o1nUPIDlY/4wVXMl417ygNBPXUGkwlp4eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp01Gg8+Xa9XKThtmW1zrmktcrm5dGMkjCnswg5Joas=;
 b=RY7MFStFPBuzfbvuEydKJXV9D8MZUifWHLXGx86PRUazVmzxlE3yVBYU4VxDRxHd3MorYz27IcR7Kr2RrjRLGp8RAisuhnnMPoKV+jzCVeORYvBJJ73JqW4ysMeepOihL7TELwc80lq7oo9OCVeX7FwT+5c3mrXpxp1PjmSl4h6IzThvkeWYHVlFFBhXtd4/YgWqEdrbVZBJSf8M4Y/vf1VlPmHYzGLWhvHxCxQicpT3BRJrstnVFNIbJjccgsvyRSC/IOY/FxXJms7jNAstIJ6PlFCmksGsM8npvpiQKeis7VM/EalgvITux2ExT31Bww3hTZyf56qTqX4puT8Cdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tp01Gg8+Xa9XKThtmW1zrmktcrm5dGMkjCnswg5Joas=;
 b=iNf+n84AzUN+l/pBu9eUesA1ysfq7U5QBia8qcq1hSaHmDLL50vNkYUTZ22Qo56s1/XX9/JC9hzw7SWQww37Pakne4I9jIZ+koHBH7DnXbyjaNy3MDOMnB3jpGNeEjB3pM1cKOXtSr6yidqVXH9L6XD6f3mgkVZ67sIOhXeG/G0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4960.namprd10.prod.outlook.com (2603:10b6:5:38c::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 9 Feb 2022 21:24:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5%5]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:24:22 +0000
Message-ID: <51f46665-694e-27c4-3fdc-59339d51d54e@oracle.com>
Date:   Wed, 9 Feb 2022 15:24:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 22/44] iscsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-23-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220208172514.3481-23-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR14CA0137.namprd14.prod.outlook.com
 (2603:10b6:0:53::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d17acbd-7e7c-4a2c-9de9-08d9ec1289f0
X-MS-TrafficTypeDiagnostic: DS7PR10MB4960:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB4960EE9B92DAD5E7AE207141F12E9@DS7PR10MB4960.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m0i8AaiODuUVQnr0STdjvL8DodJFDSPo6Uk85CPVw4c5gItcUQwvQONF41i4x8MbxnhdELZTtuwcJsnDYbsSLpP10q780/TsA708/LH/tVGNbVJ1lCptu6kZ2C/wUG2oZ/3KGJ1v5QQba4M565gs5NmoQCHgMwIDrd5cVVOsni2AjaeTyQQL6qO/cjXkSN97KxYtbPZdft9Y6S42Vxkr5Sjxm4elnnNUGmo0V/TyJBCKK5uBRxxminZnBcYQTFZvJIc5T/G94lGIYIrOmfkJFw8ZWL5JLjk7fxN/cHAWX4S7NBVDGgTgy+MdL6lB9afhW3+XahG/CUADI5oUs2pg8wAiJaqox1ZmQLV6SpuHRQL3rywMKo065fBUvfLbRIiZN2S2rvIv7KY8kC5UGFzeKhCWvuflDYHnLnm/qqVO/cxupgr87tUztHGTM4twwx4g9Lf9QMS1AwWeg0NWE9+a3XW/SSOHK1gr+pAZAnvik1ztQOlnLvtA4ukf0sK+HgTkUq350W/lhb9/YW1HLFNNA9rMNb3aq3c/qXdTfU1a9RIhx3hqUZuaMZNVAvVmDB1iApL29HoXLvsT/nH96twB7Cu7Di7R0/JWCe+FY5vYC7I375baXYOXpMWS2r1oQT13kuFRMx0M3hqAeCqsZ1eMmnm93P7pZwhonr9ikOcnYA8quSzrFVq31wKMqiVSpnbIbBLfPZGufAsC2/tuC6fUQv0pq166S1hA1E0GsPYiWnSxCIRjdKIiNgZyK5qyxVIJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(2616005)(7416002)(83380400001)(316002)(6636002)(54906003)(110136005)(31686004)(6512007)(4326008)(8676002)(8936002)(36756003)(2906002)(66476007)(66556008)(66946007)(508600001)(86362001)(53546011)(6666004)(38100700002)(186003)(6486002)(5660300002)(31696002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nnh4QjZrVzV4RHRZam8vakY3cWlNYk5iM1gyZ21ncTNSeTdjTjVBaWdQOTFB?=
 =?utf-8?B?d0l1M3cySm81b0hrMEZOcnFLRGU1NVo5L3cxbEtxRnhqVWlzRXcxZHh5RUFG?=
 =?utf-8?B?YjQ5R2JETVJFUnlzUEhPQUErQ00rbzR2S1JpbmM1OHlqT0JPOXdLV3h2QU5y?=
 =?utf-8?B?RkpUVktmZGRnL1A0OHMvbXVhem1KWG0xOTZLQjNUQnhSYjRuUFcxK1diUERl?=
 =?utf-8?B?UisrdjlQdG9rRVNpcm1uUFIrN0EzSFpPY1RqTm42aFBPUThsRVVMODJUZW1w?=
 =?utf-8?B?S010alhNYUdJblZha2kvKzhCMENrNzBHUEFnVWgzUE5WRm9UK1hZRlUxck5E?=
 =?utf-8?B?VDVmTWxLV01KUU5CT1NjV3V1anVLVDlibXVnOE1KbUhmcVpUWUZHQ3B1SzFN?=
 =?utf-8?B?VndVZXVlUU4weUpIZ2lqQlRSSmM3Y2Yzc1FPb3ZVSElLN2JjNHE3SnQ3V0Uv?=
 =?utf-8?B?Z1NZZ3JCNWc4ZjBkVTMyNjJrYm1sbHFUaVFKUUcvZWo5S0RWcWZ6NkFoZzh4?=
 =?utf-8?B?Qit1ODJkTTdaeFFiZkFaOExaYTlpdmpqaTNCWCt1OEVjb05lbVFTcythWUJu?=
 =?utf-8?B?WXVJbi9FUDRrTG85bnJ4WFgyVXRLYUZnd2xaWGluQXhRN3ozOVJ2V3pEbVRx?=
 =?utf-8?B?TklMM3IyYjU3MHJpSUkwTEZ1RTdjM1hTQys2Q3VxN25vQ040d1ZzSU0rU2hW?=
 =?utf-8?B?UGlYQ1F4Z0Z1dkZxckxPNkdNYS9EKzFHbTJ5V1o5dnNhSXp5eFVkd09pcTRr?=
 =?utf-8?B?MGVlUGZycm4zTzFhVGpMZ3hVVVI3R1daaVI4NURQZ0RQOVppZklUd0l4SFFL?=
 =?utf-8?B?bkFuT0FNcFlUUVhQOVkvRmRsTS9HL1lJcTlveXpJQU9iTkQwQ2pMUW9xUytk?=
 =?utf-8?B?R0dpK3QvZzFTaXFhVlRqd1Fzb0FnclhTaEhhNG82eFNpUzhBa0x6VmVSUmRD?=
 =?utf-8?B?UDl1K0JOeG85SkJEc2l3OWllQnZNUkdMM3A3b09EN21xdVdKajR3UGFiMDFB?=
 =?utf-8?B?YmQ4NVJ1V2hHVmx5ZFAzL0tiL1FkZTVHN1NnTllIRGRnNlZrRGNTbEFPZ1Rj?=
 =?utf-8?B?cm54VzN1clVqQkhmbGxaTHJ4VEh5R1NoaC9jdW5sVlFodEtpQ2o0Q1hudUd6?=
 =?utf-8?B?UVRuTXYycU1qelQ3bXppTkhaSWFjYlRvRkx4cUdSQmR3OHV4b2IyOXBPZmFN?=
 =?utf-8?B?bldOQVltemlndCt5dmZqQitGcTVCVkpYLzZLM3Rsc2xhbXdEbDFZNzc0c1M1?=
 =?utf-8?B?d0ZPTXRaY05MenRZQ0J0Y1M1L3dWUDlDTEc4MEt5bXQ1MDVoWG8vdEpPYXJi?=
 =?utf-8?B?YmlmQS9ZazVmb3M4ZXZ1RnE5SXZzU2swcU9SS0c3T0hHdWdsR0lqeE9BazNZ?=
 =?utf-8?B?bHdhbVVOMm5jUzk5L0VieXBLRnVISnlNTjEyL2NlS1ROeGRMNGJxZ1dVbTNq?=
 =?utf-8?B?ZlZod0FqWGFtcmVSdHpkVnRSSndWcFNweFZTdUxscGtvYm5yeWR0cTNpVDVn?=
 =?utf-8?B?Z29QclVSK3RzVUVtaUNNdFdlNVUvOWkzQm94QThMUG1PS0lrdTV5R2NyZ0FV?=
 =?utf-8?B?SXVkSVk3UitNaXFEZE8zSnBZUm55bzdXRk1QeCsrbG9WekQzdXA5VjcrTU90?=
 =?utf-8?B?eG9Eb0N2ZVpUWGFEYVRUeFZRd0daaVhGTzVTOG1COG1BcGplUW92Q2hCMXJi?=
 =?utf-8?B?L0JEV0c4bmJqdHJnZVNkQkYxMzF0YTNMWWhGMlQ5amN5UVJtWTd6Nnp6OEJ5?=
 =?utf-8?B?emZxVk55UVFkNGNweFRpQTdRVmJvU0hCZU1SaFdNa3lPMkZhUVgzOGs4SWhC?=
 =?utf-8?B?dEJkQVRkUC92QnVQd1hrM1NVTitUR2gzMDJBMEhDdFJOUGpWU1Q4eCtTdjFZ?=
 =?utf-8?B?Mm51MFRQRnQrbm5LZjhuVW9iVzhHTkl0SkJER1VkL1FvbWZwWHI4cDh0cnpU?=
 =?utf-8?B?LzdPc1VhSmNrY2tnUThacmZkQUp0cG9SRUs0WlpXd1lVMnVVUGV5VE1QVUsy?=
 =?utf-8?B?eHQ0cTU5cWxuRnU2elZLRlNkVXZQK0VnbithL3ZZY21KT2VNZEJkNHpCaCtw?=
 =?utf-8?B?TE0wdVQ5RmtpUERxRXpwcS9YVUl5YUxrbzFZVDhaQ2xjam9oamJqR3AzU2Mx?=
 =?utf-8?B?VjRwSlZkUTdZYmQ5U3g0VHpxTkRLZ1hmM3pLa0VNK05GUTRMd3IxcjVRaUU3?=
 =?utf-8?B?V0ZGT3NaanY2Q0xWZHhXc1RPR3NlUTdYczBFMk1BL0FhVGFxQ04wY3dkVG9r?=
 =?utf-8?B?aEZaTDlWclg2QUUxVGFWYVFzT3ZRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d17acbd-7e7c-4a2c-9de9-08d9ec1289f0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 21:24:21.9949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANZyJ1+N/4TQMZ44wSxAErvNiZZ6epMjZmGnyp5xitP25zSHR4ousx8/20PVQzPdxRbfK3AvABjbp5C3PolVleKDCd1Zgr+WCQXVJLoLRVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4960
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090112
X-Proofpoint-GUID: r0fzlybBso_pOsNfJS-komERPFg-e-b-
X-Proofpoint-ORIG-GUID: r0fzlybBso_pOsNfJS-komERPFg-e-b-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 11:24 AM, Bart Van Assche wrote:
> Instead of storing the iSCSI task pointer and the session age in the SCSI
> pointer, use command-private variables. This patch prepares for removal of
> the SCSI pointer from struct scsi_cmnd.
> 
> The list of iSCSI drivers has been obtained as follows:
> $ git grep -lw iscsi_host_alloc
> drivers/infiniband/ulp/iser/iscsi_iser.c
> drivers/scsi/be2iscsi/be_main.c
> drivers/scsi/bnx2i/bnx2i_iscsi.c
> drivers/scsi/cxgbi/libcxgbi.c
> drivers/scsi/iscsi_tcp.c
> drivers/scsi/libiscsi.c
> drivers/scsi/qedi/qedi_main.c
> drivers/scsi/qla4xxx/ql4_os.c
> include/scsi/libiscsi.h
> 
> Note: it is not clear to me how the qla4xxx driver can work without this
> patch since it uses the scsi_cmnd::SCp.ptr member for two different
> purposes:

qla4xxx doesn't use libiscsi for scsi_cmd based IO. It has it's own
queuecommand, completion path and error handlers, because it offloads
the entire scsi cmd operation.

It only uses libiscsi for iscsi passthrough IO which doesn't use the
scsi_cmnd.


>  
>  static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
> index 69a590546bf9..a122909169ee 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -216,11 +216,18 @@
>  #define IDC_COMP_TOV			5
>  #define LINK_UP_COMP_TOV		30
>  
> -#define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
> +struct qla4xxx_cmd_priv {
> +	struct iscsi_cmd iscsi_data; /* must be the first member */
> +	struct srb *srb;
> +};


So you don't need the iscsi_cmd above.
