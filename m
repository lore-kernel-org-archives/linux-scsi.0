Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BACEC32793
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 17:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjARR05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 12:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjARR04 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 12:26:56 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2063.outbound.protection.outlook.com [40.107.22.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAD914E88
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 09:26:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R86jsW7xehqJPrPPbP/Gib6YtHIt//2qvcpvJfYNIIDoh5U2xGf+VIFMfWtVFEoOAjejAKkf62GDGrm+E8nUo00O+81hp555aqQuGefGNQLMKb9f3NR2pRCmUFHiR15wtdgPCPbYT+kTcouzWZkFNKYZpbDkvtMLO4NehSWyje7heMgYLccn466C4KKTUuHTOyK8k2fBwUvpD/xbJzqYsNt512fjnAP58MdNfJMR3JoRvD4uGdKX9xkLlpaX8BjTlI12hjcsqCussIFkj36kXAvs25ur4o7EpZr46oFRXH+Cz7TrvYKCNv7KBbmhqVcuNZPXqtvsg1fO/gaSvhy4Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8jZhk/bjwcaDhfC2MmUQLLr9R8D5LeDuPNJglt2vgU=;
 b=iEYGV60PI6xfh1qy4J1rWwatqryAjAoWn1RGkBPhjoFKj4PFc/w+ElOoVgQPuOn3j/qXyCq5KmCTB5XRsQvJxY55tSuqd9SXROpMKZU93W4y917usggfBuKZifptotHqy9waenSdcjWcE8/loKGbNCXaSJm+wI1/Nvd1AqU9NRlS2h78Cu2GChHk5MvxtPligyVlxKEs3uQCjVsGRKKX8FwGJkWvnvxR07EM3qij4T81X8BRvzSMKt18n+tTl2hKFBgQpczPrJVLIhlqWVEtik/RC1I6VKs51LNobBH//iMqyKyeZ5f7ubGxdd/sXKuBv3rYv2Iyxu0D9+WqU4nFtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8jZhk/bjwcaDhfC2MmUQLLr9R8D5LeDuPNJglt2vgU=;
 b=zX1RrpfSqA5HcepCXUztqY1GuS4XnZAFAlUT0epUe5KmP9KIBhFZlbGbMl1kCG1E3Wu+NivQ1SJ/rP1Hkw1oooAg/QJOWs5aUdbvdErMUBrmbzVisbzrjcWt4TmVNlrLTllSwm2a5kMp2WB0qyJA1oEs7fpQOdALcP+giw//iQvogFI7xW6kxW9ZH7AHqHwpgYMjn0ctrAzJICfxP1lxrNwUdPYSnBJfRTalj0qfL9f7+2PQ1A0ctQppvONoGRK1sOiRxi6vEQWQGpy92AvDlMy7jAdXsybWbez8a/7IIu3cXck5QRc7tPr9LkRcQoY66kHbsI4TM15t3LCR7y5CSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM8PR04MB7444.eurprd04.prod.outlook.com (2603:10a6:20b:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 17:26:53 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::913b:8afd:f0d4:9a3f]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::913b:8afd:f0d4:9a3f%7]) with mapi id 15.20.6002.012; Wed, 18 Jan 2023
 17:26:52 +0000
Message-ID: <024dc770-981d-e6c1-a133-07d064506683@suse.com>
Date:   Wed, 18 Jan 2023 09:26:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 0/2] scsi: iscsi: host ipaddress UAF fixes
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        dinghui@sangfor.com.cn, haowenchao22@gmail.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20230117193937.21244-1-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20230117193937.21244-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::10) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:EE_|AM8PR04MB7444:EE_
X-MS-Office365-Filtering-Correlation-Id: fe1d5a0e-6640-4f59-5144-08daf979305a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4mHd8Rm/JNHuEw6Q2t8Kt1oPzwiUvlCmOgyJD7YX15MDm6wQwf+1khQjYE3t5F4qjhLXIA4NKsPXWnzJ+Ln42TTdAAj78COn8zvdLNkJFq7BpGHyJOsfxSCq5qYc0xPUx1zYbf1dosSJtm4YB7xtGYwcVxRRyjX6xclw9GsEEi7YnwLSb9raW6XDrCgiX30Tc1kVBcCpHBPozRjyeSTA692rUUyff9SOE9uSG5mEUz1OJDwSl5vXdyWFGvnvyrYJE3ltq074NTFEdSp24dt0cpKl1LLT85GwULri1QfoqpagM9FH3Q8SGCdB9dUJ9vKBqvFPaSF/+BJgpRZfqEofp0iQ7aiQX8ms9K16eO71yTnSOJQkRYwW9p8co4yIaGn7TMeXse6RN6Cu2ZwxxinFsa1KGVjdp34nyfAHDHs0IL/IbAAuO8l4OrnudY4i+AVJHz/wemmovJNcoueUqEBK1ecpXy53tEpx2lHzgm8mFMtK01A+NlpDWAU1CjoY4NV1DzQ5OQXb2OFiz0kZT3ARKBQz6ig0iITZEVpRsbSkLkUGjhHY8po+2sRJOKv5iqKX6XvPIrRuu/YtDMYy/K5/Vi+83NVmWl57zrhBy0fOfLjvdIo+P+wu580PtbxtgMHJx4hkf/xAfJi8meocWDYodVU/CdAUzXle5QSTPBGzx25v/Mx9ivbPZkzpTzXCfc605Rnydekn9Sc1sYh81TBfqC39D+JkQPz1WqOvQHd/r8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199015)(6506007)(83380400001)(31686004)(36756003)(38100700002)(6666004)(53546011)(6486002)(478600001)(31696002)(26005)(186003)(316002)(6512007)(5660300002)(41300700001)(66476007)(8676002)(66556008)(8936002)(66946007)(2906002)(4744005)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEp0Yi9hMWxDUTZDWDQzYzNBNkpxLy8zOVhULzhmL2hISUt3d2dqUmxmcFI1?=
 =?utf-8?B?OGswUTQ1c0RLenJud2tHbmdTT1lucEtGVFpyWllNcFkvYTlmZHd0WlFyN2wy?=
 =?utf-8?B?U05iOVYwek96Vml3eWVaZ0xUUUN0OGRXZllxa0lDYW92S0FtT0FHSDZ5Nm5p?=
 =?utf-8?B?VHFXOVpabHl1cGR0UGVHTWEwYk53YktvOW0vaVEvU01reitFeHdjOUxIVG5p?=
 =?utf-8?B?RGtQVW1EUU9yU2J2bXVFUStUbWd4Qk1yM3JhMFd0ekNmYzk1K0hJOVNZWi9k?=
 =?utf-8?B?ck9hbXNKb0wwcWpBMXc2QlZNWjNyNCthTHhtRVJ3M1RIRE5NZDJOaTY2QWYr?=
 =?utf-8?B?a3QrVytTRHFnZ0hoR21pOStMb3BEeW45NmU1Yi9MRi9RU0pjZjVXQnFwSUxu?=
 =?utf-8?B?cFhuUW53WnZOMmxFM3h6bGR2MVUyVE9qdHRMZE1yWEdXb0JJZk1mYkM5Mi95?=
 =?utf-8?B?SXo4L1p1eThqVEpJUksvV3R4UUxsaldEdFA2QmNZRk1GbVpVVXZ2R2VSSnBU?=
 =?utf-8?B?Ujc3bUtZTUhQYkIwUW1jdmZGQi9jZVJxSEhiR1BUMjltTS9wOEIxYVpVWGlp?=
 =?utf-8?B?Y3I0K1hLbVdFWGJjL2RvSGFnYU1IUlFpeFhYMmJvUmFFSUN6czBRcVIya2Iw?=
 =?utf-8?B?WTJJZ1huWUZSOXA0VVJCT0diaE54TDFESS9MS0pIZWtpV2FsUEpISWtTZGtp?=
 =?utf-8?B?MG9JRjRFbEVVTHlUTXNEam1iU29yVWE5akFwWDJIWk9wVExPSldqMFdRQjRS?=
 =?utf-8?B?OGU2V0ZxSnQxdlA2MjJ6Wi9iZUdLbDdrQlNGK0FqbnNtVC9kbzNSZURNVDhN?=
 =?utf-8?B?VzB4b2xmOHRNSno1eUhOUW9EZFJhVUtHdGtzUFViR0hRZlNqRzRiQXd3dEhC?=
 =?utf-8?B?V2pBWWh3aE5CejBOUWhGWkVFUTAxTkd4TGFnSjlSYjNmNUJ0cE9yR0l4NDZZ?=
 =?utf-8?B?K0U5dk1NSjI2bEdKMHArVzdHeW1GL2F5UEthQ0kvbDhXbkZ3dWUwaDRpQlpu?=
 =?utf-8?B?VnQ3VUVrdmJlNDYvRFVwUDQwZlpyajU3c1dHdGlxdnRzeGRwK3pUL3N5a2s1?=
 =?utf-8?B?VEs2S0pxUTFpdFc5aENrWkpocmtNam51NCsvbEtKa1NDL0RLTDEwd1I1VnlK?=
 =?utf-8?B?SEVITCtQN2k2MG9ZVktxdUJVV1BWNm9JTlVJdnFwV1E0dFNZS2I2cnhMWWZj?=
 =?utf-8?B?S0xsQTRtY2kvcnN6ckhNM2EzZ2VoYzhSczJjb21BUTJIYWY2SkdmNG53VWpr?=
 =?utf-8?B?QkpiTG0zbHQxZGhCYUFrbitWYkRDaHBWLzhmMFhoYUxkR05QenUydmFPcDBp?=
 =?utf-8?B?bjFwWFdaZEU1ekRKc0RwNFduaXlCTzdWSlZISjcyRUU0M3NSUnNLQlpzd0Yw?=
 =?utf-8?B?WXp3dDlwQjFCQWNENG9EajlKTEhQOE9VZGk2Z3FnaFRwTlM1Rnc2RVFQdVdk?=
 =?utf-8?B?VXFGV0F0RURRc3Noc3ZHZ1E1VER0NGlFSGY1QThzRmxQMGxZSFRaWnJDWWlh?=
 =?utf-8?B?U0JCeHBSTXJjNTk5MHBaNmxRN3E4Z3F2aFFvaVhtVml0VTZmckpIRDZmOXRG?=
 =?utf-8?B?NGNnUUx6RVo3eDU2eXVYMlRpU3QxeXkyclJaZkx1UHRlbW1UaTF3b2YwT2cr?=
 =?utf-8?B?NjlMaUEwbXVseThQZWtIcm4ySGM0TmRYOE9UQlRUemlIRFo0bTJEVHlJaGcw?=
 =?utf-8?B?UThRb2dmQWdpeTZUMFY0R3B2OWNNU0JjeStFWmpwNTZIdHRldzBvV2RlaHVI?=
 =?utf-8?B?ZnNNT2VDQW5FUCtXeFMvbXhTU3hEWUNrUDB2Ync5QmpGVUdDWE5VSmpCb25h?=
 =?utf-8?B?bFYwMndmZmlHMWdrN0U5MDJ3YUJhZkNGZll1YnFuaUZUQUVXYWNtUXNnYmdE?=
 =?utf-8?B?YVN0Z255dS9FUzY4anNlWDdtVzJWNlR4dXowRDQwZG8yK0dhMkw2S2FNYjM0?=
 =?utf-8?B?YUI3R3NEVGJGOGk5ZEVqQVYwY3lsSkhMem1mOUNwcHJ1RmwvSkRUai9rQk4y?=
 =?utf-8?B?Z1RyK2sxWTN6NjdoeVhCSnVlQXRySzhoV1VKWk04bFJuMWdLc3J6Snc1b2dn?=
 =?utf-8?B?aHk5SmZJVjJnSXI1S3pwY2QrdDU2NmJlZzhOMGJvK0I2NTh5RDNtMmQrSmEz?=
 =?utf-8?Q?f5TKBFVz3ZTUgvk7rA90gFy0Z?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1d5a0e-6640-4f59-5144-08daf979305a
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 17:26:52.7680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pL4Y4nLNjBwK9UgtZMW+ybMrr4Yz5JE6YobP8xAGjuHfSd3fEuAih+4qNG6LnqRT4Y7e50bMBGm3hJKoboW7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7444
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 11:39, Mike Christie wrote:
> The following patches made apply over Martin's or Linus's trees. They
> fix 2 use after free bugs caused by iscsi_tcp using the session's socket
> to export the local IP address on the iscsi host to emulate the host's
> local IP address.
> 
> Note that the naming is not great because the libiscsi session removal
> and freeing functions are close to the iSCSI class's names. That will be
> fixed in a separate patch for the 6.3 or 6.4 kernel (depending on when
> this is merged) because it was a pretty big change fix up all the naming.
> 
> v2:
> - Fix bug reproducer example in git commit message.
> 
> 
> 

Both patches look good to me.

Reviewed-by: Lee Duncan <lduncan@suse.com>

