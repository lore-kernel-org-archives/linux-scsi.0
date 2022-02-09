Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D15C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 20:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiBIUCd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 15:02:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiBIUCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 15:02:30 -0500
X-Greylist: delayed 315 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 12:02:25 PST
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234F9E04C3F3
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 12:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644436932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxK7i2rLqVBpkTEGgT7pNu9tEqKNscYLWZaKk+xXzWw=;
        b=LVQZrEIn9YT+i/iPufST1jFk99oexQQyP6/fhNvaMAdlfMhET8SiFEn04eEc+fsiCmhVYh
        ZM2i9ICuh4pbab/9eyI3SeqcBIpEvn1pXrtsls3QwAF/kkvmdima9gODeJxvSpY8bTmJzh
        a+PEUmnG6JFZa6KKyj4zlXUoDX2y11c=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2054.outbound.protection.outlook.com [104.47.9.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-2-Dar2Ja3iN9iROJdP8wRHlQ-1; Wed, 09 Feb 2022 20:55:39 +0100
X-MC-Unique: Dar2Ja3iN9iROJdP8wRHlQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lmow5yGgnEknI1zQSQ3jwxTX9ruuFHriUvwkRZ6I/pel9+FfZDQmkt+Eykc9N4NPD42YywUmTtrjr1tucISe6GrcbqkR2QBaSZOArxqRtpbKHRXA6moh//mmQIvvPCny7aqqUa+0kfJuDpn8vRFj6ktIz7dHnb3nyvBeD3S3zl/ucrYziX6ZFPFMtRFgnEy672ZdeTG0169/6bfeyw8LcXZqBUO0GIr/N1gW0mokXjRPq3Adr83CczJ95iUOtpQSjcA1EqLC1UxZhU1StjEdjx6eZBM6mX/1ea4c9ynoUiSc+AziiIa3Lww6e37Ayh9z2fLTlZwp31Cqp0qBbcwojg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxK7i2rLqVBpkTEGgT7pNu9tEqKNscYLWZaKk+xXzWw=;
 b=SUDaq4VdZnPi4B5UgorTfmMRuioFhNUhixIhjru3koBdJATNf31SsWuBbb4+HiqFklApg3SbBQTFFBASvNxdIaBPhPEyVmuozFkLPv+dHq1H7MlhIbhSC2f34hbe0L1pmOqajjjEN6ovoapC1IvdpG0PXBIJRowTy2VdlpXxqmSLc9/OyoWh/o7QOS1qudgqcPOtNsl+aL3f0Xd0Q3Kow9EzJQa6MC/sVFc5AYXFxAX+agUZ9f9aKlvJXlNrq6ebBvxTcsZGf0bzJQ/wL6DoAP/QFzjwt5DEMEdrfmmeIQMS+e/4PB7RjoxKOGAqCrwDCdZHDok+A4P9n17jNDuzeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB6596.eurprd04.prod.outlook.com (2603:10a6:208:173::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 19:55:37 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%5]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 19:55:37 +0000
Message-ID: <875c15e1-bf12-6b90-ea51-f828dbe79598@suse.com>
Date:   Wed, 9 Feb 2022 11:55:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 22/44] iscsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>,
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
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220208172514.3481-23-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR05CA0003.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::8) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 620f7702-68f4-4ca5-b55e-08d9ec062432
X-MS-TrafficTypeDiagnostic: AM0PR04MB6596:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB65969411ED78DA648603E26BDA2E9@AM0PR04MB6596.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2JSyfK8NhC4K2fEg8XicNu8K8WngtFbbAaBgkvsnCoWBio6HpePb69Puvwackw5B3WgYhJUsp/XBJ52Sow6fbIheVAGPojfK08ZLwaKipw3U7WwvLpeS94rPeRO4LjkcUpS76EVoArHv/YAK1dJ3iwC7u+aIAcfDAPcII6XClqDoew280alVxvmYmCEvOMCO25FAJ35FVcsdRypDUyHWRhbvuylPMyTK6ItJk003wWGLvgLt422ozuEIFyOOLL5euSfZxoj9myYm+HYnhv8Yp/V4yhMAKtuDHhM09D7ghK2rzVGTjvCVVTnpXOMtvBBpH1seEUGxO6MulNmG9rADvFHubRG9B37FrjRnkNGfQ0JqfdI9pGlw4LZWkRHXsvUAcfQ9HSxSlZ2/skuLLyTkl4+hHie2TCgzDf7HYdO+kIfUoR6hHa93FMLAGQQhEAycX90Airvr1UGAOJorhbvQH1QNkx/C01wzMcedPTuJz0Cldvq3T3uWMgm1yYCc2Iy3G2wM5F0RCVSYKzXLfwVcBablnBN0J3MIQgjN1eZpfuEfDTYAhPOOkwvR2oNtJVz4jcTgYNdIcQcqJFTXN+r5uAxTnKCG+vgDLbDnjD2t/zzesC+QK5ng0WO2hWRfHLd8YzQIYtmI/I4LRmMkJx3g4j3fmKHTxd30LrKsL1/598rGkVVjgssHBpvE0DAKqH1ln/74sllrBiBoIM3DXjjJhzdNaJen+lybF98aBXNdD6U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(53546011)(2616005)(83380400001)(86362001)(6512007)(110136005)(26005)(38100700002)(31696002)(186003)(36756003)(7416002)(8936002)(4326008)(5660300002)(8676002)(66556008)(66946007)(66476007)(31686004)(508600001)(2906002)(6486002)(6666004)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEpMeVlCN3o5a3VTN1hZM0RkemdYQVkyNTY5SnRwK1NTWk1IREltL2ZnNmZu?=
 =?utf-8?B?bDdKZlg1V2JpMVBETGNHVXdpdHpPV3paQkRrSWJpbktJRG53SEhlMGZaWmRj?=
 =?utf-8?B?SWtMOFIxQ3ZWM01zTWhSREFjcFJDcG5hbUFwS25Oa1ZwR1lwcTJlQnFEUlRp?=
 =?utf-8?B?cEVyNUl3WG5sUXdMcFAza3ZjdksybkJ0cW0wQkl3Njl3RmdocS9zVklVU1Ux?=
 =?utf-8?B?ekdtbXh2WVNWL1JSbFUxTTJjRVBkMnprbnJTWEJtWGdiZXZuQ0YwdTRHMjZU?=
 =?utf-8?B?RkJ1QTA5YUdaeFZVNGIvcmRkVzZXQTgrc2J3ekQyeWNELzFzaG9ZcmpsUndQ?=
 =?utf-8?B?WHR1VTgrZmc5SGJEbkdqY3YxYS9ZTktTcVNDbTBiQW1HRldtZVA2WEh0d0Zs?=
 =?utf-8?B?bEJLdi93MVNuVDNlTnpSY2FrU0F6T1VPaC9kdDVFdnY3S0lXeTczWnBhSnNj?=
 =?utf-8?B?NzJWVkhjaG5oamtKNTFWSkpCMUZPaHlTK3dJb1hkcFJHdXlCbUpOMHpCYk14?=
 =?utf-8?B?OVJ5a05QOFY5VXJoTHRPNHJOYnY0a2dvMHZKd3ZGN1FpR3pFVVc2MkNucmg5?=
 =?utf-8?B?TFNwc2JGSzB5Q3dhMEFEUzFvcFVucG1Uak5pTFJ2dXVYcjNsMFliRW10QWtr?=
 =?utf-8?B?ei9ENGRWZXZPN2dlRWpYT0FSOVZYVnp0a0hab1p0UVF5ZmZSdVVDRThlRmlP?=
 =?utf-8?B?eFpJUW1oRGhQODVzZThLNEJVaWYrcjN2OEF3aSt0S0cydEtjWGN4d2o5ZmxB?=
 =?utf-8?B?WlJHREhpTHNwZFZFMmw3ZzlLWHJ4eGs2UFpScGdQUEhiemlhcEJJYUNrY2dJ?=
 =?utf-8?B?eHdDbjIxalFVOUY1cUw3WFgvQkxrRVhkdlVjb211T1hzL0FlVXZOVmpCT3R0?=
 =?utf-8?B?bUlBcWw1QTVHZUhpQUxDYmdSQUsvRHEwNUxxbFY2YzJ5dFFiVUpYUHJLbWJn?=
 =?utf-8?B?Uk5kSzN3bVFBa3BBUWZrMklWMS9zSkJYdjAxWkkzam5RSjh3SVlZYktNZHZO?=
 =?utf-8?B?MElmLzdEa2pBYmt5REoyb2RnM2psanFWbStpdFVXbldISVFhWTIzZkVVSnZN?=
 =?utf-8?B?cUo4TUs4ekxnNkM5MWpYdWdLOUhiWHRrZExBbU9aeXVSTHpKUS9kdHVkTjhO?=
 =?utf-8?B?TTIwOTVFMnkxNFBvWEFuUDM4N1RRdkVsYzBmTlViVmxFVGptdHRyaTdKZ1RD?=
 =?utf-8?B?T3JZNEZsRjRYQ1VmZkN1S25ReFk3WW1hWXhzdHNCS3IzWE5jMkU5a28vUHJs?=
 =?utf-8?B?UVZXR1Z1eThVdGJEZ3BPUHVKTU5Nc0hDcjNOSVZYRHFrcm5XRXcyU1ZaVEo1?=
 =?utf-8?B?U1VoNGpnL3FaRFFOeHB1U0t2M2d3MUJIeEZ5NlAveDJjTS8vWkg3a0dzVHc1?=
 =?utf-8?B?TXRrUTdoS3ltcHMxdXpqN1pDYUVsMWNSZk5SQ29uY05BbStIZ1F3RC9DNmdS?=
 =?utf-8?B?aDdtME1vZ3lZOTg0VTdqdS9TMDl4QlBsVGtCOUs1NG1sZnY1QVYxZVd0TVk0?=
 =?utf-8?B?ZnRxTjdZTTQvNmlqOUhkb0dLUjFBU2p4a0VsdUt3T0lsMCtLWVBraEdPSTJR?=
 =?utf-8?B?Y0ZaQ25zV2dycGkrejFTdGk2dUpLV2xYU1JCU1JFLzROdnE3R1dRZ0lxZlVq?=
 =?utf-8?B?ZmYvbWVwSkM1TGhQaEd6UlFIMVUrREdUcG1ySFBvckwvd1dQdEYxbi94RXRq?=
 =?utf-8?B?Y2VHK0dLdWo3a3Q3cSttQThSbGJUeStiOVRUZkN6bktMTkllY3BleVBrdFUz?=
 =?utf-8?B?c1BvUEs2eGhMdXlRcndLbUF4OTBhY2I0c0NWZUxhNWtuaVFuc1RzWVhaSFkz?=
 =?utf-8?B?QnMvbFJpUHVKcmN2NU5DM1lVV1lrSjdqUXV4YkVpZVNJY1BWTEwyV3JPd0FR?=
 =?utf-8?B?R25ocFM0eWN0Vmpnei9DVWNleXl6U2IzYS8wbGFVTVVmc2s4Y2RHcXkvc0tq?=
 =?utf-8?B?QVJHY3RhOXJYelJxT2ZjeDVXVmtUUXA3OWdSaXZ6VWVTS0lSKzRqTU1oWHZY?=
 =?utf-8?B?THRHMnRFTElOMkpvcTRRZmx1QnhYYXBQM2hnT3I4K05rWk5uRFc1bU9TbnJl?=
 =?utf-8?B?ekEvSXJ1cUpLckJFVVBCVUhNRjVBeHBQYllGZzVicnJBMTdXMzlqZ28yNElK?=
 =?utf-8?B?THFHa0lKSHU3ekpBVFJkMWJyWjY2d1NDVXh3d3lKOXlJclBOQWw4UmxQQk9h?=
 =?utf-8?Q?GM7Dit4IUSO3TQhTbpHczbI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 620f7702-68f4-4ca5-b55e-08d9ec062432
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 19:55:37.2928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: muYxUO6y7O8K6r/U35Wgt8A4RwrqeZfTF7yMd2ToZxH11QmabENMa/tBIZRwvxIFIN1tXU8j1OmhZz9Gl3YGIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6596
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 09:24, Bart Van Assche wrote:
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
> - The qla4xxx driver uses this member to store a struct srb pointer.
> - libiscsi uses this member to store a struct iscsi_task pointer.
> 
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Chris Leech <cleech@redhat.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Manish Rangankar <mrangankar@marvell.com>
> Cc: Karen Xie <kxie@chelsio.com>
> Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
>   drivers/scsi/be2iscsi/be_main.c          |  3 ++-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
>   drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
>   drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
>   drivers/scsi/iscsi_tcp.c                 |  1 +
>   drivers/scsi/libiscsi.c                  | 22 ++++++++++++----------
>   drivers/scsi/qedi/qedi_fw.c              |  2 +-
>   drivers/scsi/qedi/qedi_iscsi.c           |  1 +
>   drivers/scsi/qla4xxx/ql4_def.h           | 13 ++++++++++---
>   drivers/scsi/qla4xxx/ql4_os.c            | 13 +++++++------
>   include/scsi/libiscsi.h                  | 12 ++++++++++++
>   12 files changed, 50 insertions(+), 21 deletions(-)
> 
> ...

Reviewed-by: Lee Duncan <lduncan@suse.com>

