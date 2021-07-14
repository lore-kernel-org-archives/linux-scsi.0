Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33136C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16F6C61380
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbhGNBSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:18:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3496 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237198AbhGNBSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:18:43 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E0uDvp005671;
        Wed, 14 Jul 2021 01:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AhuylRBVws3JNhZUaFjxIjB/ZFQUOIwDT8RNTWLQ8rI=;
 b=LdksaK6JwzoFeJRGs4InbW9VrvJksGaZBh5wIrWbgs8gtrJiCwiRrpUg2bShpUe3GcoZ
 uE0i8m+LQOwGkqbU2SoCpBs4l+NgX0s0UUyZ43q9zjmbj9GjyXlHgWs29sk+BXmRxsCL
 kbnl6WRfKLoiWw8TVIpwBIcdoFfLgMFkOBpa2RsSTDVuQ6r4RgvJHQZdUQzpmlyzgoko
 87qTHi8xANAIBen6nlN7lwh8+XeITVuJ7vCnRz4ZHey/Ljm2DRxYs37uscU55E6c3fE+
 35k3Ivlx9NPqRWOcHOTubvMV32dHUiy3J5jPZzW70MCmAxd8NnhePOxj/0VJrYwAZUXx 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqm0up05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:15:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1FD4O092637;
        Wed, 14 Jul 2021 01:15:39 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3020.oracle.com with ESMTP id 39qnb1d0df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:15:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBa15EDxApL7CxIF4rPEBsX9usfkRfQgsi15sr70hQNfIZQvz640Igo/8IwqP2Ys79kreuosTIwgMyku5z78CC/BRG/SylkYGUS1io2PzgGeROZdNtKuxM63XmC+9gq1XHZ4b/YNsR1AJTStek7n/SfmTNkHS0D7xnMHITNjFkUfFhwQlYtcwifu4ljdUqLuFkKzUNFP5mWLE09Z0ejdDK966E9Azwp2sbbe3G2KzRa2FEdfiB5TCDXzt2gf++X4gwfB66B3dHQHfPi93o2ZCvBPajXc8VhbUNsFoqOUgSkP40tweDE6NOO9opKkKO2ffZTuBpaK6WuFdzFUvOqTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhuylRBVws3JNhZUaFjxIjB/ZFQUOIwDT8RNTWLQ8rI=;
 b=FyY+y3VjVtVjvoFtTu/3+HMCh1Pegvu4hy//k9tTS4dxgtdiVU643wF+g3qDbe+xTOlCe1BAfEEJfl8kV5+V4irBRbkBF4vaZTEKhTEX8dwuSpr4J+fpsVfif44LKZSdA5rE4odB0YE/j/EDasQMvr4AwMKxmn3hMb8hJB2mxJuxtpdtzu1i0IZXWefzoxBSW/H8OfMJDnVrXEeB9kZRLvBKqrpEAax6G/0ddcLJzWv5HYCJ8ZvuLRufjePh8fqVf5aIB30ktFLsdG2v2RDmMm0bqT4JzGLi5/Xrj3xLeT2wkEruy8CfP5dPxdxJoDPHQzKe3Ph/lAl4yMmtOJG+jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhuylRBVws3JNhZUaFjxIjB/ZFQUOIwDT8RNTWLQ8rI=;
 b=HMIL2K/Rkh665Arv/Wn30EcDD/zHGfZN8ik3i5pKcOUbXSlMFAF/+Q5pGlqFfhcuHpA48WtyL4IPdtbyk8KZNTIidqghYTPWd7aQabkIklxSxpUubo5/gIcXIfahTo5Wf96eZFj4x1V9HaX4vLO57d39JoBB+qj39FekG9096Ys=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4451.namprd10.prod.outlook.com (2603:10b6:303:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 01:15:35 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:15:35 +0000
Subject: Re: [smartpqi updates V2 PATCH 7/9] smartpqi: add PCI IDs for new ZTE
 controllers
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-8-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <b95a2133-aeb8-533a-645a-473f376fc078@oracle.com>
Date:   Tue, 13 Jul 2021 20:15:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-8-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:3:5d::22) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DM5PR06CA0036.namprd06.prod.outlook.com (2603:10b6:3:5d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 01:15:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f70c1c5e-0535-40fd-5083-08d94664e1bf
X-MS-TrafficTypeDiagnostic: CO1PR10MB4451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB44519BCE78A9236C2A42AD60C7139@CO1PR10MB4451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FCBus+R/BENvYXnuIHfRlEzJS0FG1ih0jPmRPXXZpfYaBF4iQaQuya+tDEaALTrjeZXhhgDBMQs3W0remda8uTZrKlsTytHAZIIniZmVLFD1wsFHovVZUe/rLEwlrkmaOyh80txO2qd2I6RPYMAOvOwsqNh1OTogC/tni0F0pxv9OHFs4hrsdtZPueAriDoaplt9dP8FcLXxl4x/G0pm+ynxXF+2tgZe2hIcNTr29KMygTtq52REbC+4lL90dYs02cHx0nxQQ0dsUonKS1advraGChrf+/UOcn8ocfsfi7mDjLlhj5tsy3Gp9IgQFV9nBbfTo1fGcQRmTJDRtm6XTZ+cjWPSv4KfzFST4jIUiAnuPq4olUQrN/kpPO4p2HNCreN3X4XxwST7xoqjA34GIIsrf1jmb6hg9uMmin6S7IG1H/iBoml7T/Qbfn0WuAguUNYAyBnVwoW/sYsZTWHdFr6P5mUZKSF3c0WNu3Xgx9r1oAn5PW00hiKnZ0o2HBuuLGKW6tZ5zsptxS7ngYH3niqrmkjHcQQhDGrhpo4TKLDNmiLUe3qWOPH3LY2SF1yurMDyM3cHJBth+qn4cpWsD0+DlyW99uro/ratu9dluzeFhDkv4uHzgSwNefDIqEIQ1+Sux8sO81zzG4DIdn4wdZy2DSYVH12AHQP8ttF9IS0PubCH0IloCBrB9vKJ9LeQR1TGq5ZWXv1jVlq+E0iQzBk/TeLzkFBklTpWKhgM+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(7416002)(66476007)(16576012)(66946007)(956004)(2616005)(478600001)(316002)(36756003)(66556008)(6486002)(8936002)(5660300002)(31686004)(186003)(4326008)(86362001)(26005)(2906002)(38100700002)(8676002)(31696002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDQ0SVBKTDRTMkp0ZDNJWEJoaG9FZkVkS3ZwUXgxaWl4M2I2dHlQNmUxMjYv?=
 =?utf-8?B?cUc1Rlh0RzduN01uOXNpT0IzM2hNSjNQcE5XOTNEZnMrQ0xpbE9rVk8wM0Ni?=
 =?utf-8?B?cXV0OG8rYStmWUd1ZURlQ0VxS0xhcTJNRzlseFl6TkxvRVRjejhVZVdqVWdm?=
 =?utf-8?B?Sm55bW1CQTN4cjRuUHd4dnFJTWpUekVUVUpyUTJiNVFKZlpqdTdyeXg2bjA4?=
 =?utf-8?B?MFVlRC9PeDNoUXN5elNMMDFGV2V2cHFBLzNSeFJ2YnI2eVk2eGJDZW9zZmM2?=
 =?utf-8?B?M0NkQUxWYllkVTNNR0RwUUMxNWxGNndzNnA2MlB4SVUvVTFuME1kZ1lib3Bt?=
 =?utf-8?B?eTFzeTU4MlQ4RE1tY2VjR3MzQndaQUlXUE9OMy9scFE0VlFpTmx1VmU0TWQ0?=
 =?utf-8?B?UG4rS2NhaFlsWWVQMVhpWnMzNTB6cmNVV3I0Lzh5amRmMmk4aXEwTUdodTNB?=
 =?utf-8?B?UnVwZHlPVStiYko0SHV6Nk5uZWs3V2k1Mi9kRFZ6UzhneFN5MDdhdDBYZW1z?=
 =?utf-8?B?M0NqWW1CbDF2Qno2QzFhc1dnemRCYWVXTUMrclZMZUx3aXNub3RCM3NoTU9t?=
 =?utf-8?B?V2tTRHdITVpBQ0JEVFdLNUtHaHJ6VHNiNkJ4WUREOENObGQ0WS9jZmhtVzdO?=
 =?utf-8?B?QXl3VnlaZmx2WlphbzMzRzZJOHlicCthSHhncmt0dGpPRnRlR2FBeGdDM3cx?=
 =?utf-8?B?U29McGVQeEdtVHE4MVgvSEIzb2Q0YkNEN25jL1BvK1dCa0ZnVldYMlp0TUNm?=
 =?utf-8?B?SDJmN1B6cUExN1JzMlVnUVdtME5LYU04eHk5a25KNkNDNUdqVVpidmVhb1V3?=
 =?utf-8?B?OG9SMGVFYVo4RkJYaUZOMjI4MFY5OThhY0dnT00zNDlPRmpzYUZRNlFOWVd2?=
 =?utf-8?B?M2I1WC83YU53Y3JoUmVXQ1lGWm96T0RjaE1HVUJlaU1KRW9aeVJ6MVcyOWFt?=
 =?utf-8?B?SlQzUjJXVHY3SW00OHZJUG5uTlh1UWRzanBhNzBRYjVwMlFoSWwzZStXUXJi?=
 =?utf-8?B?MjdxamhHbkJqUkxVUnBwZHIvazlDQXJwS2NmU24wQnNRb2dHWDRHbkhwcFlM?=
 =?utf-8?B?amRzMEtNTVhXQ1h5cVpUb0hOYjEzQk1tM2tHelpVV3RYOTNucHhoYzRjZzcv?=
 =?utf-8?B?Ui9yRlpnYlFJS0g4YTVwVjVhZTZQeEdCK0RLTXNoaEZFejl6THZqRFhsd3pV?=
 =?utf-8?B?SFRKYmQ2SXh5akR5RHFiVXI1bFhIdjBIM2RRcm9xTi9nc3dpZ05BNWRzWnRV?=
 =?utf-8?B?ZERXaml1RHFyWXdYN0dxUkljMkJTc2JYK09IenFEbFlJVUZaRnMvNG8rTE5y?=
 =?utf-8?B?Q3hDOWJnYVVPNUd0OUhHam01Tjl0REhGZU0wNEhsTGRvVHE2aWNFYWJpYW5l?=
 =?utf-8?B?OHdERC9jbHBTeVNLcnVhZXFoNHplL2FVTnFwclFDV01zc1FyQUpoZURQdlBk?=
 =?utf-8?B?dFBFODhQZmRob2pQbDAwWktBMzgxQURHVVNKa1pONGtJMXhvVm9xUjJGZUo4?=
 =?utf-8?B?WVAzNG0xU0xrdUhLVnAzczVCMVNXR0VSb2hWcTVhTmRrNTZ4WWpBYStYZTZ4?=
 =?utf-8?B?eUZNTVRRVWkwM1NvMXc4SEN6blI5MCszQ2ZyWE12R1MvM1lFUTZEUHMyVkZq?=
 =?utf-8?B?bDAxNGN4c3VUZHZNaUorYnpjTmlScnl3M3ZYdE5KT0RZUlMreWp2di90RE9R?=
 =?utf-8?B?MVJVQU1pNVdEVUNTOFg2NUFjQ1RGN29rRkxMMFd5V25uYkthUW9MdWY3ZzYv?=
 =?utf-8?Q?IijKS5A9t/VyCXCp4TemS85IijlmE83KMquuo3i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f70c1c5e-0535-40fd-5083-08d94664e1bf
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:15:34.9533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSaj8IxUVYEpvvaXmiRtZnVabnevQSz2/xNfkKTjSJLZRC6cXSh9iai//2fPBHh7iN+OlzeCCCYi3dkAA8eP4kXGcltdIZ8vYVKG+FPPo8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140004
X-Proofpoint-GUID: B-yLeL0Ox0rWJqEM9MhDRSgouQvVnTMq
X-Proofpoint-ORIG-GUID: B-yLeL0Ox0rWJqEM9MhDRSgouQvVnTMq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Balsundar P <balsundar.p@microchip.com>
> 
> Added support for ZTE RM241-18i 2G device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_5445
> 
> Added support for ZTE RM242-18i 4G device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_5446
> 
> Added support for ZTE RM243-18i device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_5447
> 
> Added support for ZTE SDPSA/B-18i 4G device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_0B27
> 
> Added support for ZTE SDPSA/B_I-18i device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_0B29
> 
> Added support for ZTE SDPSA/B_L-18i 2G device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_0B45
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Balsundar P <balsundar.p@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

  John Donnelly <john.p.donnelly@oracle.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index c0b181ba795c..f0e84354f782 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -9185,6 +9185,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       0x1dfc, 0x3161)
>   	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x5445)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x5446)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x5447)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x0b27)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x0b29)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x0b45)
> +	},
>   	{
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_ANY_ID, PCI_ANY_ID)
> 

