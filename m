Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB0EC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 17:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJTRXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 13:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJTRXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 13:23:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836F11BA1C4
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 10:23:31 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KH0hGr000762;
        Thu, 20 Oct 2022 17:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=NKtyIZMmZ/Tg6LMn3XoVN3DXwtEQxrYoF3q0YlNX1Oc=;
 b=xhFiqpS8XnBOzFYNWXSsMwWsabjoYzDn9ViApJUc7EcHD3H6GfpwvuKE9+oLp44gh20t
 c0uqWPwMOf4oVRNgHQqQgIkYx11l/1sXg6rqtWGxlrxDKeFNBeB5phKaIU7X7yfvcZub
 FNSsk1QipWkwKYb2M5qO86//KXP0c6B3OnCe2+tLCFXm4QfiDe5aOOIaJ52kht5ovqid
 HzEHqLYIt7jmWe817J6yzB9mJZEz8m932c7Q98u/DrJOxSUdwFYK6PNJ71gkNx8f2pLS
 Dj5gw3zeDw66lOyVjv5DYE68BOcvuQy2+BDajNYzdu1Gp1yZv8uNL34g1VibCLa4YGlQ 2g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9aww9dvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 17:22:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29KFU5nS038760;
        Thu, 20 Oct 2022 17:22:55 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr2f45x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 17:22:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLw1vURx4/HPXB2Z0vXgUMtwNIDLqzMbewRRIM9L/DSLxYtu9jlBuEKqz/cI7ruhwiVRWawbWnQPJqb5aOkXuguevaRoO3JHlmSpgnrqZWjgarsZW5h951DSdX/Z4FMcSb9C3dnMapER4ozzaaQZrvqNuGs5SHzL7nZDWk9NJAPzpopZjR9SmCKTffyjpsCtF88CBtHsU4DwjWsZ9UWWtpWp/u9VbVkc1sN7G7zfWtEplt4E0d0B4t9RNqecx3vG7trxWMPHTGj0qPuwfDDdHykvZmvWWd0d8KHFxhXAurzgTo4IHbDbWd2bh1JsWv/dJP9htWl9Mc1/uS52VJm/1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKtyIZMmZ/Tg6LMn3XoVN3DXwtEQxrYoF3q0YlNX1Oc=;
 b=MxzJqRpKO64JatSrHgHUNbSEijFACqwtBLzyZ5SJk4r1baqRAnGH7p1/D8C2uW3xBVJV3XVAXy+YNaU3jeEgoEXN6ZM9tMlEiDU8bpwDi2tgZUMccpwELCmNz9CnQKMUn9JFpMiPipjtmv0G/4kxDqSVUwvGlUODiqjnn9J0FZfK7jktqP4dG9SxnH4Ysa20BL3yj4/VP7POR84BmwdiVqzf1Wm5hkSQWKkNCOYWxqqgdUIgkNf1QWpUnmepGIhgFccrYyZXslo9bfCKarMB0AjnpUJ4QxvkskU+49dx4k3D1CLHnTnp+0f9LwCsLq7pCErh2aJ5kOcWwDh7jDrwgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKtyIZMmZ/Tg6LMn3XoVN3DXwtEQxrYoF3q0YlNX1Oc=;
 b=vJpNuNwaXDdNXm+TpRgZvfkljbHI36LC8T4DgHDINLr6Br8BHg8xnS8mpKQmfE9bERJKXfsdpZVHw7rK8L5luLyaSZz0qAS5laehsGXPAm+4XvHMkiIElA2YBo4Bycr2iD350mIj/ea7zfcFsoBc3fs3jEgd0vUMIaAXjrnh77Y=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Thu, 20 Oct 2022 17:22:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 17:22:52 +0000
Message-ID: <f3b930bf-4d7b-6806-0323-b6b2a275a4e9@oracle.com>
Date:   Thu, 20 Oct 2022 12:22:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v4 02/10] scsi: core: Change the return type of
 .eh_timed_out()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Lee Duncan <lduncan@suse.com>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Khazhismel Kumykov <khazhy@google.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <20221018202958.1902564-3-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221018202958.1902564-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:610:51::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 4998ba20-0a0e-4749-272e-08dab2bfb85f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L0U/fincYyZR2qbnTjLfpW+cP35KNS6M7XyrZypWrEypdtTnYX3+YyONvQpEwj+td110cLf26xemqfkO9fMCg1r75P9z8D++3yANsOpVgFw3AiXZl8x6N5Eso9dSodI+QqEp8h3ItkwtJEwzKG/kByJrRizZU8z/+/lqoUaT+nTieMEwNZh91M7kiXw6PdWGVfVI34FiRhDZR+svrbQ6lpdQvFSqZEmoWt+YPcrYeoA7z7vv3OOJMaR/hCvGl/nnTIqhJfGhWGLs0YZeBouZxcK9fU/0/NpKhlS79H3PCj+IzUuzjcxS5NcB3p4z3A/DF4TRisjjPh42K5pdTMk6yLdEw4jfg0jExgAOwVg3+Su5Fdvvs4I4X9jenG8+kuBdv98ZXQB5chUfTH5XFQ/GJowsisu+nIPfVo6BiFanyzZj0OLF8NhMsFMJIvfarr8S5NgQQ0Su5NAeajorRWKKJ9aJU3BQspu4tBjl74TJIewGMOT20xLD5ZjeFos1WfQAT29V74W42HSBTGEX0eR3eF6O/HIXDLsLtTM8zKlq9EjO6aicCgUwAwbVIkWFt/I7z0vmYj/llCJpKZY1IOcgLXx2/gNOZ/grB4cVyJvyzsk96rxiTaqH3OKPqLcF4Spc27Lq6wgKgvahBaBey3luCc2y6Zs7+0FOANqe7NYLJb6cunCTGBPLsIQSnap8a5BvnnJUhr2mP467WxLokCcDnTZBQgEL5mSqbexKoIpLCRQX+Na4J8toVQKzsaknE2TLWdzga9EU0VGoR+XoyLLGa0OCBSIiXubF7rj+tHAuGbLrdFmyBbgpMknKWa1wYLrm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199015)(31696002)(36756003)(31686004)(38100700002)(86362001)(4744005)(2906002)(2616005)(186003)(5660300002)(53546011)(7416002)(7406005)(6512007)(6506007)(26005)(478600001)(83380400001)(110136005)(316002)(54906003)(66946007)(6486002)(6636002)(41300700001)(8676002)(4326008)(66556008)(8936002)(66476007)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0pCbHVoSGtkSmJZSDFZczBFZC9YR0xsRG80MEFuaUFzRk5IODdLcXRSR2cv?=
 =?utf-8?B?V0JIZlIxWmVrVkJnM0kvTHZZYlJlTDhWdUVSb2tlQkJiTHFMQVU0Yk9lNVRG?=
 =?utf-8?B?VlMycUM3ZnBYb2x1ZkFXY3lYc2lPc2U4ck1BbjZXK1ErRjJCMmgzak5Yekhk?=
 =?utf-8?B?ZVlnUUZWZTVDSlNNcGRkNlFzK2FwcXpJS2NnUHlaUFVnZU5qdktpUUdaSWdt?=
 =?utf-8?B?UzVqS1JuQ09HZ1BaeE9GYm9OV0lxWCt5WFJWeWU3OE1IRDA3ems0TGk5OFly?=
 =?utf-8?B?OGJiV2FuQWZCRklIMDQ3eFd4Vm8xQ1BST0dRS29USllHa3BDOWw1WUhWOHdJ?=
 =?utf-8?B?NkVzNThMY2xSWlYvcmxVYnRvazcxOEt4b2pUOU56ak0vQ25tT3BTNkdKQk9l?=
 =?utf-8?B?Q1dlYi9tSDcwNllaSk8ydU9GL2l5WVByTzJzdGZGamtnT1QxT2UwVXNqbm5s?=
 =?utf-8?B?UVJHME9SVm5QV2NsbDlldTBSY2QxeEdFM0RpWG9ramtBZW1HK2FEek4rZ1JI?=
 =?utf-8?B?QXVwUFF1MW5HM2lyQkRCWVFYVVptQXhweUQrcTlOdXMvQmFxeTR4M3F4ek9U?=
 =?utf-8?B?ZkNLTi95amExNDE1UWgrRDZBQXFwTEIwZTdLamNVM2szYTkxdzgyMy9MV2ZI?=
 =?utf-8?B?TmdUVk50MlRDZEh1VklzSGxVa2Qrc2tGcWV5d21wbE9aTWVPZkdDVWhLQStn?=
 =?utf-8?B?eDNtaldhZ3JnZVdISHExU3BMdTlaNVZzeUZaUTFHUGJtQkhIcE42a2k5aW5l?=
 =?utf-8?B?N0VjbmtFUHBQaktFdEJQR3JVeXVPZlo3MVZVSFlPc3RoYmVYa3EzYU0vcFF0?=
 =?utf-8?B?NG1QRmtpdncwWCs5STgzV0VPN3NOeWtZZHFGaDc4Nlo2c0lxNSs5cHFWMkZZ?=
 =?utf-8?B?MlV4MC9TSFBuNkwrdnlUaXpsRUFCaCtyVnFNMzY5cytZVkFwSS9wQ1dBeWFO?=
 =?utf-8?B?YUdPckIvVU96dlNaTE00a3RNbDErVTRlS1VzZFpJRC9hcHFGMkhZeUI5N0JE?=
 =?utf-8?B?VzlqejcrTHlhTklxc2svd2xKbmdRajlVVFRxNjVIZUFYSjI0QXZXQlZYRkFq?=
 =?utf-8?B?RDROMWp2cTlqNlVKeGlFck5oOWpDQ2cwdEVnMTBJUnV1eTN1dEYwNkNLb0k2?=
 =?utf-8?B?dUMzbmVYTE1TNjNvU3ZjSDVjbE9XanJFcWNrRXQ1WWx0MEhoSlFDR2pRc1pT?=
 =?utf-8?B?YVd0RHpjWEdSY1hRU3VzejhDVTdVUmcwaTNCODNvQUFJb25sNXpZU3M2UHFY?=
 =?utf-8?B?OEFwS0R1Sk1NUVRxaCtib0NQbHVudUkvckJvdUp2REFTeitiQy8rVWI2OVhQ?=
 =?utf-8?B?Q3Q0UXdZRTJqcndidU1EZ1I3NVdsZll5blJ2NXhGd0c0dUxQL1BhNmJNd2lI?=
 =?utf-8?B?NnpWK3V3SVo2bk5oSWRnWE81d1hocVkzd1RkbFlteWJ6enRMRFdzbzVxMytt?=
 =?utf-8?B?eWNLQWN4cjhhUGNhdEZoWmRrN1l1aVZCS2doL3ZzTkV1a1JOWVJnc0dXWGhi?=
 =?utf-8?B?SmhTell6NVZ0WFNqWmczUDNUWnVRTW9rd3lSRGJNTlNvZzRxRnBhdFJQYkRN?=
 =?utf-8?B?Tjg5OEtmcVNaaEI4OEI1VXh3MVhiWGpMRUMwSDlGNFpXVDFvTUpldStZVjNL?=
 =?utf-8?B?YkdTR1JRYURMTlE4MmZQcERkRmhteTlCa29mVXFva0g5dXZZVnl3RjFLUUlp?=
 =?utf-8?B?bWxaVGJDbDUrRHVhd3JFcGNtZUJiN2t1UyttVXY1dnJyT016S29vK0M4dE1N?=
 =?utf-8?B?OGdoK3hHc3praDVSZjUzZ00vNXMxeTNNYzlBa1dCemt6bEJJTU00R3FjTkts?=
 =?utf-8?B?eW9yZ3EzYVlXZlZseFlQNFNoKzdaTExTMlE4c0RCTWtPWlUvclE3aVFZTjZy?=
 =?utf-8?B?bThCWTBXQyswMS85ME53Zm9kYVN0bEtMZEN5SDUxUzg4SDZNS0NPcXB2RDFM?=
 =?utf-8?B?Q0hUVlJGMjRHZkpyaGZqVi9UN01RcGpKWUd0WGRvK2JERU1uQnRRRVN5UlY0?=
 =?utf-8?B?enZJYTZaVmViYVppN1dwbUczeWtacTBDazBRWjV3aUNtalF4aEc0cXR3RmNJ?=
 =?utf-8?B?RHA3SkwyczJ3Tm1yZlNkc25LQVlpSXp4alJsYVRRZm5LeUJueFh6TlNXdEpX?=
 =?utf-8?B?eUpqWGluUTlkanhZSEppcUhGVUJzYlFkZStDZnNCMlR6aGIyWkNKVThDRHJo?=
 =?utf-8?B?Umc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4998ba20-0a0e-4749-272e-08dab2bfb85f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:22:52.9650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Lqx9c3FJgjCaaD3SxOazhfSXuWjCZ8CkJ6S9WZPlNjxpaT0phEgxrHx12UumCGfZfdFiJW7AX58tfnAGazzexOUMZxSNSLc0GgtHdJt6MU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_09,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200103
X-Proofpoint-GUID: XAxm0h9JomjKRIe1vpC2xS89hP20gV3e
X-Proofpoint-ORIG-GUID: XAxm0h9JomjKRIe1vpC2xS89hP20gV3e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/22 3:29 PM, Bart Van Assche wrote:
> Commit 6600593cbd93 ("block: rename BLK_EH_NOT_HANDLED to BLK_EH_DONE")
> made it impossible for .eh_timed_out() implementations to call
> scsi_done() without causing a crash. Restore support for SCSI timeout
> handlers to call scsi_done() as follows:
> * Change all .eh_timed_out() handlers as follows:
>   - Change the return type into enum scsi_timeout_action.
>   - Change BLK_EH_RESET_TIMER into SCSI_EH_RESET_TIMER.
>   - Change BLK_EH_DONE into SCSI_EH_NOT_HANDLED.
> * In scsi_timeout(), convert the SCSI_EH_* values into BLK_EH_* values.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
