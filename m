Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A12C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 16:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiB1QGt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 11:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiB1QGs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 11:06:48 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C1F7522E
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 08:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646064367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rpQyhE7mQqkZvu4BeB59GwErdGKmKQ4g95pz3H83UGU=;
        b=NwU5sd0CSbeX4rlqLxPewQAP+i1G3jBOhxNvcHizX4C207fQn5/Z0cqub1+7zivFIerafQ
        YAojd110kJY16/sn35Rtnne8MXSi6/tGJJckDQm02sghAQQaSFTF+YvT3tIwRs2Ytfzwhw
        NwQl1FHK9gAFXZaOuszMUmXEsauEX/w=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2057.outbound.protection.outlook.com [104.47.9.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-18-Ncyxe3owMIKXJ2aG70ngkA-1; Mon, 28 Feb 2022 17:06:06 +0100
X-MC-Unique: Ncyxe3owMIKXJ2aG70ngkA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNsXftVqhVNtakxumvJ39i9Ksc7lxh54VDVPKZZV/Qea8egG7PHeK4fwt+DKazpjLWeXXvZkp9WhNu6nCezbgjzSRrp7biBR9xK+IAaHqcnwVbNSBKX7Pesjsyg/2txMy3Ak2IIE+TyDCGb7AYp/jFpzk9/lIrVV7hAtfuQh5IYwYMJdxOEXeLLBwwZA3EvUglanS88gqXFyucrwIfRbp7c969+Ulvxs2Tvg0Rpw5jmocpBrIGeaqP/t4ysOfHT4CDNcSI2Cbu70EH3lTEt2c0PTU7yiTqVEEt8gRBElpnt+TihEURE3IzJ7e+1gpipzR1p0b6S3dGnWUNcOGu1h0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpQyhE7mQqkZvu4BeB59GwErdGKmKQ4g95pz3H83UGU=;
 b=flKWFwrj9UeX+83i/59+DD8++LMtCUMCXnt58b4WETMLOYHQDUoTT/2j5weMakN7aVh2qRkHHkERG52+EFdGQlUsr+FS2JrC6lo1gXJ0A18QgQiguK87hh5IvzS4XVbM5I1d5DZI2c716xnG0no+hpQjYw2bynXIqs7yNBv9uiLlqO2cAThv+ETTma4mvGmPDsC0su3pfZ/8DsbF236uMam6kukMVNpj+ICUo2fce6pfsnz7cBHkwG/gG2ad+pxaBoNC/Cv9YMpClRIcjlTqNtrHgo4LEMxquGpUqqy6PXeFWi+/2dj1JFP4EROkP8NWlcbvp038XtXzZK/5Kk7TQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR0402MB3907.eurprd04.prod.outlook.com (2603:10a6:208:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 16:06:04 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 16:06:04 +0000
Message-ID: <d7a2c1d3-ea5c-5da3-e656-017390af015f@suse.com>
Date:   Mon, 28 Feb 2022 08:05:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/6] scsi: iscsi: Speed up session unblocking and removal.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, cleech@redhat.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220226230435.38733-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0128.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::13) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d0bfb1f-b367-4b10-ccf8-08d9fad4390b
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3907:EE_
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3907DF6DA2C91ED99611C75BDA019@AM0PR0402MB3907.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elAyk+iEa+o083fzkHtObIT1sseNw79PL+gxCVeCCqkO4ZF1qzM+THOLvdQDm2QANODZdImjmdJ4sNMHSxmUgEqGMpsuD2EfVW/LgO8TjubPNpI6OdrEjhZwE2qCS1I3CfTRqTQeolymmCAHDvp1lf9arSjGJ0Axdph5DiuZTSXL4N3SHvWOJUStwUNJzeY1p1fTrJebJedPVB5csYaZHtcB791g9bk9oEj6FbMERvVpnZymE7q3Yf/pJ/vY6dkdZU7LpcInmo1hqch0hAsng+dGvM5m8YNZ0N+lCS+ZVzHbtnQrnWAwZiiTGXuCO5AP7wV/tMuMuSZFpqtdLDCmM+QFlF+jtbGUD2t4Hbln2c3JznsUyFrVSooBdZDF3HvdZ6OJ+ClBiGfs47TVv63cKkBTAtmCskaGvNYF/U94mN9Sr13C/0Rm2TC/OiVpxoW4VkMLzBhKLj6cH6CTCi7LJ6S2K30rhm2bEeBDBOneVoLN3+62/03DSJkjmeh2XfChEEcHNd3uMP0jzLBmY3Yiu/sRobTcattCQjEz7Q6R8gaKekYzDbTTGKmwfIRhClp/XqKB6u7tUFvGQpLDttbRwc7G50MaLPBqUEsRzuIdbCx2CNXeyfI3qDOEG4FzPkAiItjuVFNWFQWfwoqQlER0VSNc9bfBKoU1Bw8QGz5N0EtsWeuTmfpZyj+NWLiQN9i7K4WgT02cBCDhWC/Lcrmw1bhRTCu752KA5ky11LxB4Ls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6666004)(508600001)(2616005)(53546011)(6486002)(66556008)(8676002)(86362001)(66946007)(66476007)(186003)(8936002)(5660300002)(2906002)(26005)(83380400001)(38100700002)(6512007)(316002)(31686004)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clRvM3ErczcvSjBDcWZRK2l2OEl0R3YxVW56emtZWkRnY3JYRExpVCtrM1FE?=
 =?utf-8?B?blBUaTJsOWZGRU10YU1GSVdlS0xibDZCdnlEamtTZDQ5UFhmYUNncnB3MDBK?=
 =?utf-8?B?cWs5bFNWdlc5UWtJOTc5K0FaWEpmRy84N0MwejNLRE5qKzlITGlhRGhZQzdv?=
 =?utf-8?B?VXl1dTZURzFib2R6SHhwajVaaHFpWHhZZnFpSzc1NWRraUpES0wxanFSckRY?=
 =?utf-8?B?Y2hDNFJZakY0T1djbWNDdHgvMkpyYWZVRTdBM2hGY1NrWUgyTjJCWWRLSFZv?=
 =?utf-8?B?bE9RbkFBMUJKQ0NrSVovZ292RTZuMGpPM0srVUozb2tKQWQyVTRsNzhVTHBz?=
 =?utf-8?B?U3p0WnJwUng3aEVhQys0aEU0dCtCYUlybXg1ODBxdUhoeE1UOHkyZjlYdTUv?=
 =?utf-8?B?ZlBSU1N2eW9hOVRHRytja2UvUml5Ry9PMms1cHYybW0wTExPdTRwNE9oNEtL?=
 =?utf-8?B?cGtCTmg5cEJaWTc3SWE1OUZHSmpITHlUOE1GeldDWG9zNWVhZHVDb0J6a3ZI?=
 =?utf-8?B?eWtUd1lYQWk3TmhKOXpPSDgxRFMvSUtRaFFRRXR1bFdRVGxEWlpaVGZwWDFp?=
 =?utf-8?B?TGxQcnlDd1lwenRnUzJ5ZXhVdHFiMytzT204WmttUVFmSmVuRUp5cDBjSE5r?=
 =?utf-8?B?RElLbEJ3QVY4Wi80Y2FIMDZjSE0vMnN5alczY25UU2E0K2hSSWlaRUtSTno4?=
 =?utf-8?B?eEhQanlwYmlmMkI4aUZ1M0Z0S0NMSDJUazg3cml0Z1Q3VXJqeWt3c2c3WjZl?=
 =?utf-8?B?UFBOQ1p4NHljVXp1ZFNlOFA1Y2Q0WmY4UHoyUVE4ZSs5V0Nta1gySkpGcG1Y?=
 =?utf-8?B?R3BLRlNCYUhaRlNqdXNvVllYRFZjbm5VdG1oNVF4YVNUSGM0aCt3MDdtNE5D?=
 =?utf-8?B?NDNPblV5d0tFeHRkUVFPTUdPamEvUUowNFFBT2YvNTAvbXVRbitBMWpKUHNm?=
 =?utf-8?B?U0hHb1dLVnRhWmljeVN6OWpRcmx2Z3pHcXNUeXZseC8wWEZGNWUvZ3BnVFJ2?=
 =?utf-8?B?Qzh2L3hjWkEvVkE2UGwxclhhamptR3BhN0VHSzF0SHRST0ZBVE5lck9FWEcz?=
 =?utf-8?B?dlJEQWZIZ3NwV1VZYktYOElCU1VnMnpLV0VhUWFCSlE0SUZWeG56WkNNMy9m?=
 =?utf-8?B?NVdFNGJPZnlvUTQrd1R2QkpiQmpwQzVaMzRyMEptOFhISXY2eUVqQjZIeW9z?=
 =?utf-8?B?L25ObUpxdmFMQ0dQeXF6SVRtdFluaCtqRmZPcUJBZi8xTy9FYVZmQkZ0QVRt?=
 =?utf-8?B?dkFXdWJWRHZKZHowS21KQTE5aTZFbWV6RVNZUE9kdk5KYjRvRGpjUm9LZHdl?=
 =?utf-8?B?YW5EbVl3T3BhVkhncWFBN1ZVaHNQa3BGc2lPOEh0TC9sNjEvYzFYQVdFYXZa?=
 =?utf-8?B?M1N2c0dMMEhGemc4K240K1RTU0kvampKTDB6akg3VjladjdveU1yd1AxSXlW?=
 =?utf-8?B?QkY2Q0hTT1FpQ241U3p6OHNNblp3NFVocW03cXdxakFzb2hXVzg4bU84R05i?=
 =?utf-8?B?ckI1V2l1M0cwUXpoR0xvenF4YzRTYXJMNksvMkpVWGhjUHM5cHpheVJzVHg2?=
 =?utf-8?B?b2wwZ1hsSHp6TVJUdG5pd0FrSnZWT2R4M3FVTEFRTEdnSW8zK0I5bUNvQ1kr?=
 =?utf-8?B?aExpNVVEeXpNbDNpblNBbzEzcyt5OHJlM1Q1MFVQeW1rTzZOQllHOFdYQks4?=
 =?utf-8?B?Q2NJV1Z1cS9vbmN1UUtYbmtlYTFmUlFoelEyQzBrcGlPTEVhQmJjSHVwcCtS?=
 =?utf-8?B?eTk2eVd6WUtYdWVmVlBaLy9SNjR3Ni9Bd3ZvWGN3SW9WZmsrMGFmdkV2aVgz?=
 =?utf-8?B?S3ZCeG9GS0h4QTU1dEw4Y1hGWXpRazkzY2ZSU0czb1pUYWJlM1JuSmg2UlZK?=
 =?utf-8?B?SmttMWhPeWE1a0Q4RHQzcUZidGNSYVo4Vm1FaVVTKzlzOWVkc2xhK2REakla?=
 =?utf-8?B?NlRVaHVvOGVmQUNNQmI3a2h1VGM0cUdxb05ad2Z3L0dFamFXdGdudDY2NUxV?=
 =?utf-8?B?eXpOWU9BeFFmdk44MllQSjIrV0Z1a0pRRzFWTGZnS2hsNUVRSWF3QlZUenNo?=
 =?utf-8?B?VzBGUEllQjVHcHAxdElaRnN6YkRpbEVROVAzKzZ0ZGJINGdJcVNIcDVROGkx?=
 =?utf-8?B?WlVHUkdocE9zczRZU0NWL0c3aXZVekFoMUZzc0pwdCt1Y3Z1aDlGUFZZUDZC?=
 =?utf-8?Q?ruUFq25qxZm3iEyS0DH2Okw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0bfb1f-b367-4b10-ccf8-08d9fad4390b
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 16:06:04.7971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGeM19PJqwgLlaNo1NpaIi0rZdcLjLCkJRJE2W4gQwwCEaMTeH+0ahJSJbWUGpLBy9Q3wtuSRyFoIupYa4noXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3907
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 15:04, Mike Christie wrote:
> When the iscsi class was added upstream blocking a queue was fast because
> it just set some flag bits and didn't handle IO that was in the process
> of being sent to the driver. That's no longer the case so blocking a queue
> is expensive and we can end up with a backlog of blocks by the time we
> have relogged in and are trying to start the queues.
> 
> For the session unblock case, this has try to cancel the block and
> recovery work in case they are still queued so we can avoid unneeded queue
> manipulations. For removal we also now try to cancel all the recovery
> related works since a couple lines down we will set the session and device
> state so running those functions are not necessary.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index c58126e8cd88..732938f5436b 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1944,7 +1944,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
>    */
>   void iscsi_unblock_session(struct iscsi_cls_session *session)
>   {
> -	flush_work(&session->block_work);
> +	if (!cancel_work_sync(&session->block_work))
> +		cancel_delayed_work_sync(&session->recovery_work);
>   
>   	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
>   	/*
> @@ -2177,9 +2178,9 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>   		list_del(&session->sess_list);
>   	spin_unlock_irqrestore(&sesslock, flags);
>   
> -	flush_work(&session->block_work);
> -	flush_work(&session->unblock_work);
> -	cancel_delayed_work_sync(&session->recovery_work);
> +	if (!cancel_work_sync(&session->block_work))
> +		cancel_delayed_work_sync(&session->recovery_work);
> +	cancel_work_sync(&session->unblock_work);
>   	/*
>   	 * If we are blocked let commands flow again. The lld or iscsi
>   	 * layer should set up the queuecommand to fail commands.

Reviewed-by: Lee Duncan <lduncan@suse.com>

