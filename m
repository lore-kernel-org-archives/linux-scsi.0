Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235D2C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 22:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C9961175
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 22:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhEDWOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 18:14:20 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:57467 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232221AbhEDWOT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2021 18:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620166403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DDAz6XNXCKBk6WBaNuuUzEhpIsq7Bsm4ZRK3Tk8q+Rc=;
        b=Q29fm2qekBMbiEBz4NAEkznnbvQz7JMfdZsU+uQINKDUtBnB73s/50KarmgmIm5Hd8gDxi
        LN5Jb0qYRUBHCHsNXCElrYPDdgAAZt0xoBayWWBGv/GgT5sjI8JeSeJzCNoNvY5ZZwyAtE
        D8OzNuV9rTDbRWi5mVVMMAe2Lc+ULNI=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2059.outbound.protection.outlook.com [104.47.10.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-axggGPrMOuGPaInfxDL3sQ-1; Wed, 05 May 2021 00:13:20 +0200
X-MC-Unique: axggGPrMOuGPaInfxDL3sQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BV9FxWsAAPNUP5Hz4nko14be7tfL9Zye92M8MP9eBxUtqhqO6PHRaQfyqddLPIA1bPbRF59WZdRywamBI2UpQuzirF2AH6T9pvwcd5uYtWJXTgV/4Wx+HJShmzIzATcD3EXvoEXbePaJiFAoXWRf9QgxcbF4td8mBe1EzrszWqGWet6kZ5dDYzsmbuH7AQcoGqZgFY4ZXbWGJlcXJpc1UvkmNfLTqeTraHAFGkGr2o6IbB0BscIcQk1yKnjHiIIe4a71WKg0YAZxpeB4rvfKt3D5sSLAToR82j8ZM2WSQZ+LAyir5/wXh8/P4w/t9rQHbMH6jxdCzlU3elvobI693Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDAz6XNXCKBk6WBaNuuUzEhpIsq7Bsm4ZRK3Tk8q+Rc=;
 b=JH2gKmjPH7FOfTdAgO3+J2M4JwnNJQ7c934f6ikY+/FVIidpdlGunHJ/Q9FzXNaqsdj3lTgjYhXbdbg3Ubad+ENJPz1z/wrbMSjtVq6UQJgyE0mtxRayvKWlQCcBeQcgkHiYmawDZP53dgifYREB+xot4qNWooC7DiuKy1DsomqHfoP/vaHEtkPVNhRgl4CzeKAeT95KmyDyCG5FsKWepaebyLFDmZDnbrReB9JVi5t4ZqLxiYCmVtDDiGBikuPNjS2ZdDjE2IgmgBAWaeAE2Bw5BXbo0m9sgnU7CAAc+HkBABy34WbffDYCp8GlH1rWI29YH7h0rno85LiQ3HQnCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (10.173.254.156) by
 AM5PR0401MB2659.eurprd04.prod.outlook.com (10.169.244.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.42; Tue, 4 May 2021 22:13:18 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.038; Tue, 4 May 2021
 22:13:18 +0000
Subject: Re: [PATCH v3 3/6] scsi: iscsi: have callers do the put on
 iscsi_lookup_endpoint
To:     Mike Christie <michael.christie@oracle.com>, khazhy@google.com,
        martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424221755.124438-1-michael.christie@oracle.com>
 <20210424221755.124438-4-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <eabe5853-3f74-94c5-e955-bcbeb7146baa@suse.com>
Date:   Tue, 4 May 2021 15:13:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210424221755.124438-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR0P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::16) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0061.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.10 via Frontend Transport; Tue, 4 May 2021 22:13:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53364428-2897-481a-4c20-08d90f49d217
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2659:
X-Microsoft-Antispam-PRVS: <AM5PR0401MB2659A622122AB270FC154B29DA5A9@AM5PR0401MB2659.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IsRSVaznEPdtQOPsU+eGKBe5+RlSrN8//RW+PJ5gIuK0enKlpAmUecBT7/Y8YcaqR1je9ew+7cLX83Qqx2q+okR3L4Ml+GSCPSBU7qIOBBE+CwKNe/dDDrnvjQ12d8QxX6bgdPnkw6POMJMRidvxxmIwwa/jbaOoGTOL2Wez23cPPOg71stTzsbgz/xx5JyNslQY2P+hjTC/ebOY4kXZon9W8FVQ7bOH/fd2uWXNqS19o6pEfPPKrLvLQypwQF6dLFdtZjDHu5CBbZOCoPKC8BftFdp0bXquTWH6a1Qmxa9LmordmqnRIVF7J18RrJloosQWCurb5rl+JvOz+S91H9k9120l310huO/Zt0wJG+MeGqgbcszCKYbylQgQf+Lwt16zWZ3+MxnyvXScnznZuPG5L8I7b/en867M9oW3ExG0Zk/U0j9SXfyBRgY7Eb1L5GM1EXxEdqOFIjsw7PgMrdbbOXajIzdyEUGI5pl6d+LFT4ULBjreS9t5H7pXaCyvkKmmCdhDfUb3tJw5nsqgKQk69UFU7wCZ3LqYriWvkUPpGe/6lO6HW9SbUcFxweRILcaS39Mb2vHeD4iPTeQmPBtYLqEV+/HySBtL5zBx93MeTXzwEnqShXq2ggbkH/QRWiOJONfYcJZA3syNZUoWrTsV5SB87gf//8LKaBgvWLB1g7eoqbLJ2KFGIeyv0g0TwdtxmsFZW+IW2xVysSOrRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(39850400004)(396003)(66556008)(66476007)(2906002)(38350700002)(38100700002)(52116002)(66946007)(31696002)(6666004)(53546011)(6486002)(5660300002)(16576012)(478600001)(30864003)(956004)(2616005)(8676002)(316002)(31686004)(36756003)(8936002)(86362001)(186003)(16526019)(83380400001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGZFSlpiZlh4QTZ2MnlveFI0MURtVG15WmVrWGV6MmNrcEMyRGVoN015Rkwx?=
 =?utf-8?B?UXZnNjlwMzhJWWFVOGxjcm8vWkdiR3RzelpGT210UHJ3Y0R4dG85T21YMlUr?=
 =?utf-8?B?NjdpeVR3YkNJRjZ1bHZNUFlYQTRoTC9FdDVaWnlodHZlVzlMUWswbDhHL0wv?=
 =?utf-8?B?WC9hNDdWZmxsVVI2S0I1NXhLeUZTSmlVbDI1YnlSQU43TzFvK1ROaytCV0t3?=
 =?utf-8?B?WHZMTnFkZGpxcmtXY05pdzNQZlRtc2ppTnJzUXBVYlpUUjFELzVCQmtzV3ly?=
 =?utf-8?B?UlpmVUZlTUJaVng2MHdjODl5RHd6b3FzeUdOcmtSeExhMFdMcW1NMkR0cFh0?=
 =?utf-8?B?UkZwZG9UMG9oR055K2Y0OUdkdUd3WG1udHd5Vk5MZ0tCWmRsbnNBdTlkT2hy?=
 =?utf-8?B?U0tIZm4vS1BuL3ZVSjdvbnZ4RFBmTnlBUklXR0NNOEI0KzZpeG1Ta1BYbzhH?=
 =?utf-8?B?OGI4VGpqQVd6K2FtaUZBdzlBcGlCYTZWMmdyN2NpRXo1UlFYNUdMNjhScVd1?=
 =?utf-8?B?RFlWS2RHUFV4SU55Ti9mTDVQRGNMelE4YkJKM1hTMStqTnZpNWxUMWxBeE1C?=
 =?utf-8?B?eU9ycXhVUnFSSHJqNkVlczRWTDBBUjF0VVFoSGNDV21nZGMyNGdiMGVrSity?=
 =?utf-8?B?cGFjdGFkeHU5TkVTaFRjL0I2WXRYd2VDR2I5UURSQUZ0SlFMLzU3a2RsZzl1?=
 =?utf-8?B?Zy9wdG1QRitmK0xua0YyMW42N0RpYzYvQXkza0pjT2VvT3EzMC95MjIxZUR2?=
 =?utf-8?B?Z3NwTi9UZ3VrVTkvTllsSWNTUS9QcXBuVWxHWDA1bHc2MXI3U05KbFVPUHE4?=
 =?utf-8?B?R2FMRmZPbnN1anYyRTZDSWw3WHVyNDNRUlAxSFI4QzB0T2svczNkT01nbFlj?=
 =?utf-8?B?N0k2NlZuZllrTWYrSmlrenhodUZKT0NFUmlRUVZBaWxjRmo3UmFjZGNMQ01u?=
 =?utf-8?B?cS9VWVo4TUFSd2NiVHlsa25OaXRmUFpLanczNm1iOVhzTHdXdkFrQjVBNkd3?=
 =?utf-8?B?UElvSUsyWjBTcDhBdUp0d3FNQmVxNExxMXZBTHZKRVF0aW5qd0ZtTGlySHB2?=
 =?utf-8?B?U0loUXZ3TGR1SDdmNi8rM1h6Nm91QndjNHN6SmZlV3RndFlwQ2ZJcDV1c09N?=
 =?utf-8?B?SzNJK2Vkc0NUbktZUXArcWtkZHFmdjJvYlE4MzE3akVUb1E0Tm5Id3B1QU8v?=
 =?utf-8?B?TVR2NlRsRlI5eTFNeXNUeFIyZlN2a1dpWDVoZDA3VjRDeUJ2NEJsMTUwQ1ky?=
 =?utf-8?B?OEMvckRkSGVjSHhma24rR3IvS1NQbnJiTzVFaGFHY0tqcW50VUltOUYvZm1q?=
 =?utf-8?B?ODFIdkRJbGhhbW43TVNiaEt2STVXUGtJRW4xaHQ2UEJnaDZWalVOZzM5ZHB3?=
 =?utf-8?B?QzRqRFg3QmhuZmtoam5ZaGlUSzRGM3NHWUtlcStUbmkyZVM4djhFakFwcFNT?=
 =?utf-8?B?YTBCMzl6Rkk5OHB6RUczS3gyL3FvdG9Lc01VYWZ0MDNZMFYzbXYyblNOOE5a?=
 =?utf-8?B?VXFxWlNIc2YzNDJGSzRwaEgrN3d1MzdEZGtNTVAxcGFMTzBSRTRWYjZkTDVN?=
 =?utf-8?B?T1AwdlRrSkJBaVI5L1hzTWcydUhDeVNkRU9DWFdDelh1YklybEh3djlNd1N4?=
 =?utf-8?B?Nlp3TjNDM3pkTlFwcVhiYzNSaWZlY0VZQkl4OTRlQ2J0T1B4WkZmZmQ4LzNt?=
 =?utf-8?B?b2tYcjdraFlkbFBOM05SRkFJemRsT0t2U1lKOWhXVTN1bldEMjlKTlRpSkJB?=
 =?utf-8?Q?sOIIEHs26OrSe85yClchQLPtqHiGnpo3X34tzJs?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53364428-2897-481a-4c20-08d90f49d217
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 22:13:18.4705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zaJ1fZ2Y8Vsmy4pPgEYjf3zj7dQX0xP6T/B0zoEhoJEZugFhdxI2Syzq7SgrP8EySWQaiXltkWx+DTgkQqdJiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2659
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:17 PM, Mike Christie wrote:
> The next patches allow the kernel to do ep_disconnect. In that case we
> will have to get a proper refcount on the ep so one thread does not
> delete it from under another.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
>  drivers/scsi/be2iscsi/be_iscsi.c         | 19 ++++++++++++------
>  drivers/scsi/bnx2i/bnx2i_iscsi.c         | 23 +++++++++++++++-------
>  drivers/scsi/cxgbi/libcxgbi.c            | 12 ++++++++----
>  drivers/scsi/qedi/qedi_iscsi.c           | 25 +++++++++++++++++-------
>  drivers/scsi/qla4xxx/ql4_os.c            |  1 +
>  drivers/scsi/scsi_transport_iscsi.c      | 25 ++++++++++++++++--------
>  include/scsi/scsi_transport_iscsi.h      |  1 +
>  8 files changed, 75 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 6baebcb6d14d..776e46ee95da 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -506,6 +506,7 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
>  	iser_conn->iscsi_conn = conn;
>  
>  out:
> +	iscsi_put_endpoint(ep);
>  	mutex_unlock(&iser_conn->state_mutex);
>  	return error;
>  }
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index a03d0ebc2312..0990b132d62b 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -182,6 +182,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
>  	struct beiscsi_endpoint *beiscsi_ep;
>  	struct iscsi_endpoint *ep;
>  	uint16_t cri_index;
> +	int rc = 0;
>  
>  	ep = iscsi_lookup_endpoint(transport_fd);
>  	if (!ep)
> @@ -189,15 +190,17 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
>  
>  	beiscsi_ep = ep->dd_data;
>  
> -	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
> -		return -EINVAL;
> +	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
> +		rc = -EINVAL;
> +		goto put_ep;
> +	}
>  
>  	if (beiscsi_ep->phba != phba) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
>  			    "BS_%d : beiscsi_ep->hba=%p not equal to phba=%p\n",
>  			    beiscsi_ep->phba, phba);
> -
> -		return -EEXIST;
> +		rc = -EEXIST;
> +		goto put_ep;
>  	}
>  	cri_index = BE_GET_CRI_FROM_CID(beiscsi_ep->ep_cid);
>  	if (phba->conn_table[cri_index]) {
> @@ -209,7 +212,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
>  				      beiscsi_ep->ep_cid,
>  				      beiscsi_conn,
>  				      phba->conn_table[cri_index]);
> -			return -EINVAL;
> +			rc = -EINVAL;
> +			goto put_ep;
>  		}
>  	}
>  
> @@ -226,7 +230,10 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
>  		    "BS_%d : cid %d phba->conn_table[%u]=%p\n",
>  		    beiscsi_ep->ep_cid, cri_index, beiscsi_conn);
>  	phba->conn_table[cri_index] = beiscsi_conn;
> -	return 0;
> +
> +put_ep:
> +	iscsi_put_endpoint(ep);
> +	return rc;
>  }
>  
>  static int beiscsi_iface_create_ipv4(struct beiscsi_hba *phba)
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 9a4f4776a78a..26cb1c6536ce 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1420,17 +1420,23 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
>  	 * Forcefully terminate all in progress connection recovery at the
>  	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
>  	 */
> -	if (bnx2i_adapter_ready(hba))
> -		return -EIO;
> +	if (bnx2i_adapter_ready(hba)) {
> +		ret_code = -EIO;
> +		goto put_ep;
> +	}
>  
>  	bnx2i_ep = ep->dd_data;
>  	if ((bnx2i_ep->state == EP_STATE_TCP_FIN_RCVD) ||
> -	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD))
> +	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD)) {
>  		/* Peer disconnect via' FIN or RST */
> -		return -EINVAL;
> +		ret_code = -EINVAL;
> +		goto put_ep;
> +	}
>  
> -	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
> -		return -EINVAL;
> +	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
> +		ret_code = -EINVAL;
> +		goto put_ep;
> +	}
>  
>  	if (bnx2i_ep->hba != hba) {
>  		/* Error - TCP connection does not belong to this device
> @@ -1441,7 +1447,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
>  		iscsi_conn_printk(KERN_ALERT, cls_conn->dd_data,
>  				  "belong to hba (%s)\n",
>  				  hba->netdev->name);
> -		return -EEXIST;
> +		ret_code = -EEXIST;
> +		goto put_ep;
>  	}
>  	bnx2i_ep->conn = bnx2i_conn;
>  	bnx2i_conn->ep = bnx2i_ep;
> @@ -1458,6 +1465,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
>  		bnx2i_put_rq_buf(bnx2i_conn, 0);
>  
>  	bnx2i_arm_cq_event_coalescing(bnx2i_conn->ep, CNIC_ARM_CQE);
> +put_ep:
> +	iscsi_put_endpoint(ep);
>  	return ret_code;
>  }
>  
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index 215dd0eb3f48..dbe22a7136f3 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -2690,11 +2690,13 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
>  	err = csk->cdev->csk_ddp_setup_pgidx(csk, csk->tid,
>  					     ppm->tformat.pgsz_idx_dflt);
>  	if (err < 0)
> -		return err;
> +		goto put_ep;
>  
>  	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
> -	if (err)
> -		return -EINVAL;
> +	if (err) {
> +		err = -EINVAL;
> +		goto put_ep;
> +	}
>  
>  	/*  calculate the tag idx bits needed for this conn based on cmds_max */
>  	cconn->task_idx_bits = (__ilog2_u32(conn->session->cmds_max - 1)) + 1;
> @@ -2715,7 +2717,9 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
>  	/*  init recv engine */
>  	iscsi_tcp_hdr_recv_prep(tcp_conn);
>  
> -	return 0;
> +put_ep:
> +	iscsi_put_endpoint(ep);
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(cxgbi_bind_conn);
>  
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 25ff2bda077b..bf581ecea897 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -387,6 +387,7 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
>  	struct qedi_ctx *qedi = iscsi_host_priv(shost);
>  	struct qedi_endpoint *qedi_ep;
>  	struct iscsi_endpoint *ep;
> +	int rc = 0;
>  
>  	ep = iscsi_lookup_endpoint(transport_fd);
>  	if (!ep)
> @@ -394,11 +395,16 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
>  
>  	qedi_ep = ep->dd_data;
>  	if ((qedi_ep->state == EP_STATE_TCP_FIN_RCVD) ||
> -	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD))
> -		return -EINVAL;
> +	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD)) {
> +		rc = -EINVAL;
> +		goto put_ep;
> +	}
> +
> +	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
> +		rc = -EINVAL;
> +		goto put_ep;
> +	}
>  
> -	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
> -		return -EINVAL;
>  
>  	qedi_ep->conn = qedi_conn;
>  	qedi_conn->ep = qedi_ep;
> @@ -408,13 +414,18 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
>  	qedi_conn->cmd_cleanup_req = 0;
>  	qedi_conn->cmd_cleanup_cmpl = 0;
>  
> -	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn))
> -		return -EINVAL;
> +	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn)) {
> +		rc = -EINVAL;
> +		goto put_ep;
> +	}
> +
>  
>  	spin_lock_init(&qedi_conn->tmf_work_lock);
>  	INIT_LIST_HEAD(&qedi_conn->tmf_work_list);
>  	init_waitqueue_head(&qedi_conn->wait_queue);
> -	return 0;
> +put_ep:
> +	iscsi_put_endpoint(ep);
> +	return rc;
>  }
>  
>  static int qedi_iscsi_update_conn(struct qedi_ctx *qedi,
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index ff663cb330c2..ea128da08537 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -3235,6 +3235,7 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
>  	conn = cls_conn->dd_data;
>  	qla_conn = conn->dd_data;
>  	qla_conn->qla_ep = ep->dd_data;
> +	iscsi_put_endpoint(ep);
>  	return 0;
>  }
>  
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index a23fcf871ffd..a61a4f0fa83a 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -266,9 +266,20 @@ void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
>  
> +void iscsi_put_endpoint(struct iscsi_endpoint *ep)
> +{
> +	put_device(&ep->dev);
> +}
> +EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
> +
> +/**
> + * iscsi_lookup_endpoint - get ep from handle
> + * @handle: endpoint handle
> + *
> + * Caller must do a iscsi_put_endpoint.
> + */
>  struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
>  {
> -	struct iscsi_endpoint *ep;
>  	struct device *dev;
>  
>  	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
> @@ -276,13 +287,7 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
>  	if (!dev)
>  		return NULL;
>  
> -	ep = iscsi_dev_to_endpoint(dev);
> -	/*
> -	 * we can drop this now because the interface will prevent
> -	 * removals and lookups from racing.
> -	 */
> -	put_device(dev);
> -	return ep;
> +	return iscsi_dev_to_endpoint(dev);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
>  
> @@ -2984,6 +2989,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>  	}
>  
>  	transport->ep_disconnect(ep);
> +	iscsi_put_endpoint(ep);
>  	return 0;
>  }
>  
> @@ -3009,6 +3015,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
>  
>  		ev->r.retcode = transport->ep_poll(ep,
>  						   ev->u.ep_poll.timeout_ms);
> +		iscsi_put_endpoint(ep);
>  		break;
>  	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
>  		rc = iscsi_if_ep_disconnect(transport,
> @@ -3692,6 +3699,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  					ev->u.c_bound_session.initial_cmdsn,
>  					ev->u.c_bound_session.cmds_max,
>  					ev->u.c_bound_session.queue_depth);
> +		iscsi_put_endpoint(ep);
>  		break;
>  	case ISCSI_UEVENT_DESTROY_SESSION:
>  		session = iscsi_session_lookup(ev->u.d_session.sid);
> @@ -3763,6 +3771,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  			mutex_lock(&conn->ep_mutex);
>  			conn->ep = ep;
>  			mutex_unlock(&conn->ep_mutex);
> +			iscsi_put_endpoint(ep);
>  		} else
>  			iscsi_cls_conn_printk(KERN_ERR, conn,
>  					      "Could not set ep conn "
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 8874016b3c9a..d36a72cf049f 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -442,6 +442,7 @@ extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
>  extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
>  extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
>  extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
> +extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
>  extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
>  extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
>  					      struct iscsi_transport *t,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

