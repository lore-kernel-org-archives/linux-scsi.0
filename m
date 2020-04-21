Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6BFC54FC9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 14:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23966206D9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 14:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="r4SZPjnS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgDUO7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 10:59:39 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.112]:42376 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728676AbgDUO7i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 10:59:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1587481176; i=@ts.fujitsu.com;
        bh=s1QordmBGN62hiqd69tB3FP9yhyhlyPezd/i2GKz6ks=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=r4SZPjnS+DLTC6vXVJtnmdlLLPcAKnUVwm/kHOR6JpAkRj6Wo2JzgYe8Z7UejHrLK
         rejLZmL8PYHcMVrXgNX7SNBsIilbOotCVR0EDAkwb0u4U2oZ7lgYIU8uW3GmLAVeiR
         PQHIQrDtNp78pWccrD7OYaKR5egvcDMhBDHl5f8+UUgjo3HGCniC1TFgpT0UzlJVcK
         h0FnXNiI5nRNZO6n42ebeW+KlvWjGGDjLjrOz197EYOQxwr1nO3p2tddnpdU5MFWvg
         SrJrLowBegQWk9ARd0lG6zn12sAGB5f0qmt6ni1ZHUGD6bH6b0HPBWAqE5hzoGTY1x
         PDNPqM4xOcHOA==
Received: from [100.113.6.250] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-central-1.aws.symcld.net id 23/52-32019-75A0F9E5; Tue, 21 Apr 2020 14:59:35 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRWlGSWpSXmKPExsViZ8MxVTeca36
  cwZJ2JYtpH34yW6xY8J7Rovv6DjaL5cf/MVmsP7KB0aJ16VsmBzaPy1e8PXbOusvu8fHpLRaP
  9/uusnl83iQXwBrFmpmXlF+RwJox7fdMtoKJ3BXPbp5nb2DczNnFyMUhJDCLUWLqnVksXYycH
  MICoRJ9v28ygiREBLYzSvxdvI8VJCEkkCbxcV4TO4jNJmAgsWLSfbAGXgFHiZlXvjGC2CwCqh
  ITz7aB1YsKhEu82PKHFaJGUOLkzCdg9ZwClhLLl35mBrGZBcwk5m1+CGWLS9x6Mp8JwpaX2P5
  2DvMERt5ZSNpnIWmZhaRlFpKWBYwsqxgtk4oy0zNKchMzc3QNDQx0DQ2NdU11DY0t9RKrdJP0
  Ukt1k1PzSooSgbJ6ieXFesWVuck5KXp5qSWbGIGBnlLI2r2D8dPa93qHGCU5mJREeavOz4sT4
  kvKT6nMSCzOiC8qzUktPsQow8GhJMH7k3V+nJBgUWp6akVaZg4w6mDSEhw8SiK8LJxAad7igs
  Tc4sx0iNQpRkUpcd5HHEAJAZBERmkeXBss0i8xykoJ8zIyMDAI8RSkFuVmlqDKv2IU52BUEuY
  NApnCk5lXAjf9FdBiJqDF+aazQRaXJCKkpBqYHIK+OX+P2fr+n5HphcuWmm2vNjDbr3soMIWd
  pzUjqq79Wti+TuMNF/d/275ALjJ9o/a2o+U6T1a8TnHPmfphx86u76Yf/mwTZy1cPU/+8PYlL
  CHXi35MtZho0sZ99TanucScOXKm17xfRfatb1314+K2dTw86peuN/uU5k+aL5X6XMb5SN4GRT
  2FHbejJRP/xNWeKQmeJC54/87POwpitkKiWdcCOS7M3ei+8PbtU3Hmas+lBRWVW7+tnTvz44a
  bUxUkv34/+WL2GUeNL4VsKeozvVKzVvzk/XmiTmju268abK9q7p7Z8iBi2iGjKlvd01zRiYGR
  10K6WI1meh9f8lglfnqRwKFlQq9mGdycWq7EUpyRaKjFXFScCAASs/HGbwMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-2.tower-238.messagelabs.com!1587481175!799734!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 28977 invoked from network); 21 Apr 2020 14:59:35 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-2.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 21 Apr 2020 14:59:35 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 03LEwhbl019952;
        Tue, 21 Apr 2020 15:58:55 +0100
Subject: Re: [RFC PATCH 04/12] target: use tpid in
 target_stat_iport_port_ident_show
To:     Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200420191426.17055-1-mchristi@redhat.com>
 <20200420191426.17055-5-mchristi@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <be44ad27-76fe-156f-6f48-11d522212db1@ts.fujitsu.com>
Date:   Tue, 21 Apr 2020 16:58:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20200420191426.17055-5-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/20/20 21:14, Mike Christie wrote:
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index 237309d..cc9c966 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -1309,8 +1309,8 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
>   	struct se_node_acl *nacl = lacl->se_lun_nacl;
>   	struct se_session *se_sess;
>   	struct se_portal_group *tpg;
> +	char *session_id = NULL;
>   	ssize_t ret;
> -	unsigned char buf[64];
>   
>   	spin_lock_irq(&nacl->nacl_sess_lock);
>   	se_sess = nacl->nacl_sess;
> @@ -1319,13 +1319,13 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
>   		return -ENODEV;
>   	}
>   
> +	session_id = transport_id_get_sid(se_sess->tpid);
> +	if (!session_id)
> +		session_id = "";
>   	tpg = nacl->se_tpg;
>   	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
> -	memset(buf, 0, 64);
> -	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL)
> -		tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, buf, 64);
> -
> -	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf);
> +	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname,
> +		       session_id);
>   	spin_unlock_irq(&nacl->nacl_sess_lock);
>   	return ret;
>   }
> 
AFAICS, after the change "struct se_portal_group tpg" is no longer
necessary and can be removed completely.
