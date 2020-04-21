Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B9FC54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 16:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F106E206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 16:27:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="ddD9APM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgDUQ1U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 12:27:20 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.2]:48179 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgDUQ1T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 12:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1587486437; i=@ts.fujitsu.com;
        bh=PI1EOqmaiWAq6lCfsDlUzLiZ9gLom5MULSDB7BDBbP8=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=ddD9APM/V2Ntbe0WzIGfBxrGDIfcGOj3w/7bifiiKgAml6nUbWvO8suYazGJHti3L
         6x0fae59HqsaZCS54jk/hhi5jwdLC7RvHemPWqR6VXYpgcIDIRLRCwHRLsOFF33hJd
         +p1k4VW9IU46tL6ORq/ROtOgd2Xp1Mmx/wN2Ttoo/YngrV33gbfQaItWTUWW+elmMl
         RJD4bJLlGUqubThrFoU6U2A699m/f+Y/m7n9pqZZ8uj8u5kYSBvSEqawR3zHYzijzf
         3/PG7NVSyCkWo+lQLeFK4q7TO8ksva/AvZgERAqrZ12tkpPA4kky30gf3FcChncBMV
         LEI/OdrKoV5yg==
Received: from [100.113.1.102] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-central-1.aws.symcld.net id FD/38-36549-4EE1F9E5; Tue, 21 Apr 2020 16:27:16 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRWlGSWpSXmKPExsViZ8MxRfeJ3Pw
  4gwsXFCymffjJbLFiwXtGi+7rO9gslh//x2Sx/sgGRovWpW+ZHNg8Ll/x9tg56y67x8ent1g8
  3u+7yubxeZNcAGsUa2ZeUn5FAmtGw8UNrAVn2Sq2ztjO1MB4iLWLkYtDSGAWo8Trh+uYuhg5O
  YQF3CQOL/vBApIQEdjOKPF38T5WkISQQLrEzFWH2UBsNgEDiRWT7rOA2LwCjhJHu++DxVkEVC
  W6piwAGyQqEC7xYssfVogaQYmTM5+A1XMKWEkc7LwEVs8sYCYxb/NDZghbXOLWk/lMELa8xPa
  3c5gnMPLOQtI+C0nLLCQts5C0LGBkWcVomVSUmZ5RkpuYmaNraGCga2horGusa2hkpJdYpZuo
  l1qqm5yaV1KUCJTVSywv1iuuzE3OSdHLSy3ZxAgM9JRC5qodjBeXv9c7xCjJwaQkymskOT9Oi
  C8pP6UyI7E4I76oNCe1+BCjDAeHkgQvoyxQTrAoNT21Ii0zBxh1MGkJDh4lEV5HYOQJ8RYXJO
  YWZ6ZDpE4xKkqJ874D6RMASWSU5sG1wSL9EqOslDAvIwMDgxBPQWpRbmYJqvwrRnEORiVh3qs
  gU3gy80rgpr8CWswEtDjfdDbI4pJEhJRUAxPP84m/wo0SHhv7dD678bHo4UOlFz5xF3f13GoJ
  XaNosvUlO68F96mVZ4tVFyqfY84U8cj0kvQ4cs58vuGNvNxa1Z3Pd1l//OMq9D7wsNCCsqgSh
  6qVziwP7vx+9m2x+tbctffUz+z64Z96oO9cx8Zay/tH9z3Kf3b+ku/6RV89r3MfmHMqYief0u
  lJvzvagm+u3VY/ec6jz9tz2Ys+rJts15nIbB8f93X21MaY+qbItCP1nE9CF214JT7rx+XE2QU
  rysXqgxs0w64pzGOqktM9HX/+i+/+DfO2nrtq9PhMfPIni5LHnHu1nlRre3Qs41otp7ehYM0W
  85i+gjdpCT/XvWCrbLg3x3zT4uVMe+fOVGIpzkg01GIuKk4EANtfk5JvAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-2.tower-232.messagelabs.com!1587486436!70814!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 8847 invoked from network); 21 Apr 2020 16:27:16 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-2.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 21 Apr 2020 16:27:16 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 03LGQZYr014585;
        Tue, 21 Apr 2020 17:26:40 +0100
Subject: Re: [RFC PATCH 11/12] iscsi target: use session sysfs helpers
To:     Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200420191426.17055-1-mchristi@redhat.com>
 <20200420191426.17055-12-mchristi@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <52b52bbb-ec57-eb13-c3ed-a4cf3a4b69ee@ts.fujitsu.com>
Date:   Tue, 21 Apr 2020 18:26:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20200420191426.17055-12-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/20/20 21:14, Mike Christie wrote:

...

> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index f533308..a0ea60f 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c

...

> @@ -313,7 +303,7 @@ static int iscsi_login_zero_tsih_s1(
>   				ISCSI_LOGIN_STATUS_NO_RESOURCES);
>   		pr_err("Unable to allocate memory for"
>   				" struct iscsi_sess_ops.\n");
> -		goto free_id;
> +		goto free_ops;

Shouldn' this be "goto free_sess;"?

>   	}
>   
>   	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
> @@ -327,8 +317,6 @@ static int iscsi_login_zero_tsih_s1(
>   
>   free_ops:
>   	kfree(sess->sess_ops);
> -free_id:
> -	ida_free(&sess_ida, sess->session_index);
>   free_sess:
>   	kfree(sess);
>   	conn->sess = NULL;
