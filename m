Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A27C54FC9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C7EA20661
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="UUy4YUKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDUPtU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:49:20 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.3]:36438 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725613AbgDUPtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 11:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1587484155; i=@ts.fujitsu.com;
        bh=Wa8U1yDFGo6vbxGxWauMIO8XtCPHynwfDCaeGBWhM5A=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=UUy4YUKuuFtIA1Qc+JHwtuuWA420JAD0advv5BWR1zZ1jDorlBsS59i37MHgpaOXY
         Sqd/ie6QA3LDxAgc+DHLLW2jiA7MAKpoqtoLM8xYctTdDu4QDXiZUJ/YdNsB0O4LR0
         fAXJHyvzrl0zqGKDfR5twW0LqD8KTZ8mQmugXTaJsG6Whw0LZDDMgKzqKdmM6GEti0
         llvWFXQ5UGsoJ9HH1/WkzpJiYYv3cmV129tJqoAElN/i8adV9v1IEb+MdU3L8/JJY4
         ACZwhDPaaQIPEPP2qCl5KxjmtZNz6dgszn+PW5wpU7wRaUnBC+PUWXYcmix50y9aa7
         dgpE+H9owDABw==
Received: from [100.112.195.143] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-west-1.aws.symcld.net id AA/E3-36773-BF51F9E5; Tue, 21 Apr 2020 15:49:15 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRWlGSWpSXmKPExsViZ8MxVfeX6Pw
  4gz+XbSymffjJbLFiwXtGi+7rO9gslh//x2Sx/sgGRovWpW+ZHNg8Ll/x9tg56y67x8ent1g8
  3u+7yubxeZNcAGsUa2ZeUn5FAmvG9409TAXzhCpW7ZrK1MDYwNfFyMUhJDCLUaLj8m+WLkYOD
  mEBC4kJDWYgcRGB7YwSfxfvY+1i5AQqSpM49GUJI4jNJmAgsWLSfRYQm1fAUWLHr+tgvSwCqh
  IPFwWAhEUFwiVebPnDClEiKHFy5hOwck4BS4mJM3exgdjMAmYS8zY/ZIawxSVuPZnPBGHLS2x
  /O4d5AiPvLCTts5C0zELSMgtJywJGllWMFklFmekZJbmJmTm6hgYGuoaGRrqGlia6hhaGeolV
  uol6qaW65anFJbpAbnmxXnFlbnJOil5easkmRmCIpxQc2rqDccv893qHGCU5mJREeavOz4sT4
  kvKT6nMSCzOiC8qzUktPsQow8GhJMEbIzw/TkiwKDU9tSItMwcYbzBpCQ4eJRHeFyJAad7igs
  Tc4sx0iNQpRkUpcd65IAkBkERGaR5cGyzGLzHKSgnzMjIwMAjxFKQW5WaWoMq/YhTnYFQS5s0
  HmcKTmVcCN/0V0GImoMX5prNBFpckIqSkGpgY/nU+/7c78uGhF9Nm1980zLSy0ErY83zTNJ8d
  6v9nOOqvWPOk6vpmz2UnmzPuPpOINnZ/uvFIuVT3nanB+Xkvizgcb1gkKUiIpqztSZc1d5wod
  qjrFucCmZN79FdXXznsXtmRb1h1psrs54vdixbOVVCXkZ2733tSSOP9uLXmh78lPn09k0MzaG
  IN+46Yt5JeNx7Y1vLMcdcK+nPx4cHQn7v/LjsxiWfl+033j1TK58zwbSwLC5TalLPMLS+g4Xq
  ZjxHr/eCchc0GCvOYX0841Z7bW1DdNmXnkohd4XFyKseuJWuzqP6WuMXKZblmsfPfJOcHy7w2
  bFUs/FAx9/RvqaoVvyK4kzznGZ5vu2CixFKckWioxVxUnAgAzoVRuGwDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-31.tower-265.messagelabs.com!1587484154!437504!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 1052 invoked from network); 21 Apr 2020 15:49:14 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-31.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 21 Apr 2020 15:49:14 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 03LFmO5u013516;
        Tue, 21 Apr 2020 16:48:33 +0100
Subject: Re: [RFC PATCH 07/12] target: add sysfs support
To:     Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200420191426.17055-1-mchristi@redhat.com>
 <20200420191426.17055-8-mchristi@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <c34ed5c7-a5a3-666c-c52a-352c19ddaf98@ts.fujitsu.com>
Date:   Tue, 21 Apr 2020 17:48:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20200420191426.17055-8-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/20/20 21:14, Mike Christie wrote:
> configfs does not work well when the kernel is initiating the creation
> of an object we want to export info for and the objects above/below it
> are created by the user. There are races/bugs like seen with this patch
> and the issue the original bug was trying to fix:
> 
> commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu Aug 29 23:13:30 2019 -0400
> 
>      configfs_register_group() shouldn't be (and isn't) called in
> rmdirable parts
> 
> The problem is that for many drivers like qla2xxx, iscsi, etc, session
> creation is done by the kernel when there is a login initiated by an
> initiator, but we need a common way to export the systems sessions so
> tools like targetcli can report basic info like what initaitors are
> logged in and daemons like tcmu-runner can track sessions for load
> balancing and PGRs.
> 
> This patch begins to add a sysfs interface that will initially be used
> to export LIO's sessions. The general layout will mirror the lio
> configfs tree:
> 
> scsi_target /
> `-- $fabric_driver
>      `-- target_name
>          |-- tpgt_1
>          |   `-- sessions
>          `-- tpgt_2
>              `-- sessions
> 
> iscsi example:
> scsi_target /
> `-- iscsi
>      `-- iqn.1999-09.com.lio:tgt1
>          |-- tpgt_1
>          |   `-- sessions
>          `-- tpgt_2
>              `-- sessions
> 

Depending on future implementation of session info passthrough in tcmu,
it might be helpful to have an additional folder "sessions" directly
in scsi_target. This folder should contain one link for each session in
the lower "sessions" folders. The name of the link should be the same as
used for the session and the link should point to the session.

Example:

scsi_target
|- sessions
|  |- session-1 -> ../iscsi/iqn.1999-09.com.lio:tgt1/tpgt_2/session-1
|  `- session-2 -> ../iscsi/iqn.1999-09.com.lio:tgt1/tpgt_1/session-2
`- iscsi
    `- iqn.1999-09.com.lio:tgt1
       |- tpgt_1
       |  `- sessions
       |     `- session-2
       `- tpgt_2
          `- sessions
             `- session-1

The link can help to easily find the session for a given session_id and
also provides the wwn/tpg info for a session which together with the
info exposed by the session attributes completes the nexus info.


