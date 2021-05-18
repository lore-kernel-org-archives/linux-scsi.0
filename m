Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9E4C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 15:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE616117A
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 15:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350522AbhERQAl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 12:00:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35984 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345990AbhERQAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 12:00:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14IFUiBB039250;
        Tue, 18 May 2021 15:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+GPYWJI7UcgmOUWVpjTHwFpFT/ya0FACz50KkiOcMmQ=;
 b=JrNjqJ6HQrvwfBBxHxIjJvc9uDmlOILfNwntMmFa3THSu3N7mn9uH2VxU+ZfXzMPECd1
 CcoaqvmkFHjqURFi7o4RRpUZZ9kres0EOOl0rAnOZy7B9/oqH3b+929wJX3WkSa7PphL
 meZgIj5rwQBe5Rac0I8OTiax7iUxdkatcw9TfZ9zyewHCukbz1kaxjiBefyJFYEjfD00
 Om92y613kJaHeyGB/DALrNyb9lw/dmMDiAt2mwcG1EBZJScLfF1pHmvH7ibcLwmmxONh
 +y0HCi65l2KHN+1SZNA/818ohB0xv+lFH/tH8iGLuG6T0vVo3m4tVXJZruZ+8t3+5Yns dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38j3tbf05j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 15:59:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14IFVI41148714;
        Tue, 18 May 2021 15:59:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 38mecfecrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 15:59:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaMAuGefATSywJCq5q/RvpGp0pqNi7vCxr+0f+gs212ovxRkCxaAs1gzHcSRLkVs86qKIF7UoVO0Rd5f8WIc5Yna4ydPvGi2WzghQdeB8qSja6RMUjJ0M0kLgtKF9ULx9iHHXHp28afIKPPwv0jbHc0a7p6VQT96KsF2XVWcqKTwG+vL/ABggxgDO21C/2pV2D3x3BKDMz3EVHrbPqG/Fs1BAIBJTc5C/ZK+xn12EknJ4W7kBWqiH/f/oklnjkYtEWhH1m1lH+ywy/HFoex9vddNF8bYFW0sOw6VVB4ADbps8LfqXNwn4ZVkoagLt9quCZBIGcpUc49wYwoN1FT1Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GPYWJI7UcgmOUWVpjTHwFpFT/ya0FACz50KkiOcMmQ=;
 b=BxA3lXjqYmizjY5/XqptzPfAPinuwSbSWu3Omh0cIRpOvsFvL5WSpALk45s+nlkmULZIyQD4ENQKoOJNzNwEfWoNo2Ib7aytnh1CmOwFqdgUsakFNmjabcyadSW6NwMz5wTRp0CCgz7wJNVe1cZmrhGifJTIX+jllV32+SGxRUVkGUw8qkrQNIWtK7Qhk6WBml9Nd5925VkzUmLz5tZCrqgaK/ixCTg/NaKmAPoHJpWYaSwgojuXO4x0JVfu3HGbcJFXFTWs/As20CiacmwUbHg6LgU4Z012YBNJ0A6oE7/yhCkuB0qYi91mpe0VkVsbOIUNFcMM1GzP0ayquuLNaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GPYWJI7UcgmOUWVpjTHwFpFT/ya0FACz50KkiOcMmQ=;
 b=ZDz4LGboj43u6+WWIYpodVOJ+2zVyfyhirEIEleMlxasjgL4Qsc4bUvP2fsg3cGmIDzjShdOrGwHnXGC31QhNtnmnyHgLuoo3xs68nw7rbjQDjGXCYCbAZOOmhvgx4iQ9L7Ps+E8h/ssyrQm7Lj9GucOx83/EQeaS0kP261aX2w=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4553.namprd10.prod.outlook.com (2603:10b6:806:11a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 15:59:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 15:59:15 +0000
Subject: Re: [PATCH] bnx2fc: Return failure from bnx2fc_eh_abort() since
 io_req is already in abts processing
To:     Javed Hasan <jhasan@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210518111926.1331-1-jhasan@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <f275a202-1fe0-f33e-c889-b4ece8fe4f67@oracle.com>
Date:   Tue, 18 May 2021 10:59:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210518111926.1331-1-jhasan@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0501CA0132.namprd05.prod.outlook.com
 (2603:10b6:803:42::49) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0501CA0132.namprd05.prod.outlook.com (2603:10b6:803:42::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Tue, 18 May 2021 15:59:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b081454-e0c9-4330-95c2-08d91a15e310
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB45530D32EF0A7D643F35C0E3E62C9@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0NYPvkIplJ5eWAX1duQTkbxh08dzmRv9ZXQQrKmGF1t7YFkMMPEmveSh7KUxlng5z8A9haPcXNBkQBoqdzmAq0uRhty+0KvPyLqGtNWVYNdqv1Tef68GaoMaMA8qCYk6yYvowamTN4LrIkb7/7KvXmL0uETzQJrx9j6AO5hSsCIgY9SBdkuDKQlV7iF4XsN0a8zH27USLf1JwDXAYYbBqeBm0HH8H0U9HW37a3fC7z6lWneRZZhzxfOH2Y0g52qxi/Z7dXZkhtY1gOAmol+KQlwTXPJ0T57/yRd2OIV0NWnZZIeEQzz7wPRVcZ62fuwHOuQomz/cb2IDOjTSI9/RPOetNnGo8vNGwLntV3mfRrtgJlwXtHPDh47IWrJcmbCXXj/imgV8J+Ltw8tOldJgpQneeP9rhN1UbJHsWsKQHQMgrXV3KHxvwNnl3F04oOgDH8JBjrw6mQF4kkJkKYxGZjFUMRd3QdBxGJ6hOkBqjy582G8+uJydKky4wwmnL4ZLTnDvvKb9fWuuBhJGBTfnLM/Mh38PwATIo1WguS8IX6z9J5Jrt8uzRKjsRL43bstsCbMSuR/Kj5jaDGk/nfoNTCJ+w1PE2MQk74766YOVH2qEas0cFo4i9olAuo06wO0ZVs57KfkWT+FDTWieizoSU/daxhpLzw3fTtyACZ7gctT0dzKgEqjkaGX/Js7RPfE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(53546011)(478600001)(2906002)(5660300002)(26005)(31696002)(6636002)(66556008)(4744005)(83380400001)(36756003)(66476007)(66946007)(36916002)(2616005)(86362001)(6486002)(31686004)(8676002)(38100700002)(8936002)(956004)(16576012)(4326008)(316002)(186003)(16526019)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWt5U2ZTaUtNbUFPQXR6WXZZQVh5NHJndDhHVFVzUmtMelExdWxuWW81SnRp?=
 =?utf-8?B?V2dVNXdMUkFRMzlGTG5ScG1kQjBBTXZXK1o5QVU2eGZSeUFMNjMrbWZHSUxV?=
 =?utf-8?B?VWxDcGlEUEp0QTdidGF3UEE4SkUxbnBERWFJaEUwL2pkRjRqZzk1SWExN3hQ?=
 =?utf-8?B?MkhjZGZmdEh5cFE2Y01KVTZkS3dNSmFhRG1kN21YY1NuNnd3UEdtRms1ZjFN?=
 =?utf-8?B?cmtsZ0ZmK1AzanpMWnFsWjV3eXg3OGNyRXVzSVZGYzVZUWVJTlFzT0xnOWZB?=
 =?utf-8?B?cHpKK0pSak40dC9RZWFLbmF2YXpobHV1eXkzbldXUit3NzZsSERTeFBuRjdp?=
 =?utf-8?B?Y09RYkVNWldrTXlib1luMWowdXd4OWFOdXlGTGppQnkwOGxkRmg4dGV6ZzdD?=
 =?utf-8?B?VlpiejVteE1rYmJvNEw5YnI1c2pYdjFJdDZBMkdXSXlnRWxUUForTGcyZkhh?=
 =?utf-8?B?S2Y2eFBGMHkvMkFZYnJ1S3IxWkx5MEExSlV2a3FjTjIrQVpZQWxyNWdhYzhZ?=
 =?utf-8?B?aGZYNHhtZjFsQURiKzlUa1RrL0dyTmRGdzlCV0lOdmpyMXdKYUFxYjRMOXRv?=
 =?utf-8?B?ZWwxK2Z6YjdoQXpEalVFdjh1SGhWT3hNenpoQ0NHSW1jTFZPUlc5RGlGb0JJ?=
 =?utf-8?B?ZlAzZEJ4VDd4RnE5SmxqZWtscU5DQ2NxT0FiV0VmUVNzalExbTRQWVNob1ky?=
 =?utf-8?B?NUUvbjdFbTBGbExVblIrRGtiRG41c1BHSlVibWdFYU9yWmRENU9oeU1hb3NN?=
 =?utf-8?B?RC9xT2tMOGsrRVJVeWVEZ3E4V29LMU9nUlh6Z2RneWljbzlXREh1cUk4ZXVY?=
 =?utf-8?B?azUrQnd6VmRaS0hBMHBtb3E1ODJtd2t4Q0JvRC9MWkN1NlN6OUJockd5UHJN?=
 =?utf-8?B?eVZsbU9jV1RQeUZUdE4vMVRGcUhZV0t2NjBwUUxDQWgrNTVMTE92aEdSRk0x?=
 =?utf-8?B?WUZQU1ViM3hCTWFqSU1reCs1dVNyamJyZFk5c29DVHZYMGN5ZmM4VVFRYitz?=
 =?utf-8?B?TlFNc2prUXA4dTZYNjlKRUQreVBWZnZjaU1OVU5lSWx2NHBTZWszUzB3SmNu?=
 =?utf-8?B?SXlnSXlrOTl3TzhhTmxwUEFBS0hVVjFtUEt0Zk5jYU1YMmJEejAzYUd1SVo0?=
 =?utf-8?B?OUh0YzgyZkxmdC9tTXQ4MEEzVnpESXYrWVlQQnVMTTdXUEYySnU0ZStUU0VU?=
 =?utf-8?B?d0p2dksrMVRiUmxDL0ErUlp4bmFWb244aG80cVoyQlZDODZTL3NwL0Evb1Yz?=
 =?utf-8?B?L0FzQzkzOTdoN3htb0VWYkF2NXEvNGpqZWdsSHpLN0dlVTJZNlR3SUFiQlE1?=
 =?utf-8?B?SHFVL2dtT2tmUlN1OWRaSGhhVFZacG9maEgvdkxFdVA3YjYvdXFjeS9QWkpw?=
 =?utf-8?B?S28xTWszeWNQNkNTaWlVeWdQOHBiZGk0anNNc2pUVW5yYUNrRVI5OFNrZUtr?=
 =?utf-8?B?cFkxY2FzVHhzNWp4TDUwVnJzSEYrRmJVOHBQNStrNVc3RFFkc2RBcXl6U01o?=
 =?utf-8?B?KzF4M2ZRWXVQRHovMjNyYzhsMU9TcFVxbGpNakVSbE1XckMzVzY2T1VnSHN4?=
 =?utf-8?B?Q2FoLzRoN2tXRFhYSlJZU1B1TFRXa1JiL1BZNVRvcE1oanJuYytoMDBqWUtN?=
 =?utf-8?B?eGRERjVhS2JuV2pGNmg5ZmtaTWVCSncxVzY3Z3V2TzJWTnVGTTF5VU9xOS9R?=
 =?utf-8?B?eUl1ZnEzOGcyL3B6UlExdXBMcjBVb1o3eXNRNWlsek5hZXJGYWUrTnRuSVNX?=
 =?utf-8?Q?9qsnRPbz4triPiS+biA9kCpJqOfMyem60QhYYkZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b081454-e0c9-4330-95c2-08d91a15e310
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 15:59:15.8104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRcdbCwwlzcc5vCsVcepxvhgxGyxu1DadwSJTCRz1gMNTvB6FH3zK9wF6SnE8uf3bV7cPPREI7Y5DFwuAhVC9wM3z+9DKsx3IVdsvdm008c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105180111
X-Proofpoint-ORIG-GUID: iUVPHjixiOUySBUjwr6aNjCRXF2b2zb2
X-Proofpoint-GUID: iUVPHjixiOUySBUjwr6aNjCRXF2b2zb2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105180111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/18/21 6:19 AM, Javed Hasan wrote:
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 1a0dc18d6915..ed300a279a38 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1220,6 +1220,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>   		   was a result from the ABTS request rather than the CLEANUP
>   		   request */
>   		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
> +		rc = FAILED;
>   		goto done;
>   	}
>   
> 

Please resend as a git-formatted patch.

-- 
Himanshu Madhani                                Oracle Linux Engineering
