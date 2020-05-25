Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6385EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 09:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404E9207FB
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 09:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="sSNYdPqg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388831AbgEYJMF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 05:12:05 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.2]:28796 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgEYJME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 May 2020 05:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1590397921; i=@ts.fujitsu.com;
        bh=2N0ta0xkTHO1ASuSy/Hz5DBj4Fs/cClPX1DUdDg6Jm0=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=sSNYdPqgbEpkF5OqBVrKLjTt0ITIgf0gdL9s1RkcknCwqoKTVe/FGjxIEqSc84AUM
         4TTl9nkRHmp+7jH8ek3ELF5p1L9wHe3kjZfpKUEw/hOldxXpEcBj5wMD9czw6Lch8/
         d5CufJse9qQGriK7HkQOpZez63vk7r7W+rZsEiGBOjF88iXwBxNzi3jLuBPEPfyCc3
         yFJMWBJ9ktwE5SSXM3IJ+JWan2Bmr4mNjpBViMazKemJFJCq72/JvcF/5F07C2VzSG
         6ePvImUO5ARvVZmhEBQKHBNQJ52ewrJTc3D6ajEZw8F/Ht4HdmwJJvR/AKxlDa388S
         gp2ZHjG+WSC1Q==
Received: from [100.113.3.197] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-central-1.aws.symcld.net id C2/00-40520-1EB8BCE5; Mon, 25 May 2020 09:12:01 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRWlGSWpSXmKPExsViZ8MxRfdh9+k
  4g92fuCxe/5vOYrH1lrRF9/UdbBbLj/9jslh/ZAOjRevSt0wObB4fn95i8Xi/7yqbx+dNcgHM
  UayZeUn5FQmsGavWzWMv+Mxc8eZaI1MD4wLmLkYuDiGByYwSUxe2sEA4/YwS5yaAZDg5hAUSJ
  JZu+cYCYosIpEvcOfuGEaSIWaCLUeLUuaWMIAkhAW2JdROes4PYbAIGEism3Qdr4BVwlNj28w
  KYzSKgKrF0+yk2EFtUIFzixZY/rBA1ghInZz4Bq+EU0JE4+n85WJxZwExi3uaHzBC2uMStJ/O
  ZIGx5ie1v5zBPYOSfhaR9FpKWWUhaZiFpWcDIsorRIqkoMz2jJDcxM0fX0MBA19DQWNdQ19RC
  L7FKN1EvtVQ3OTWvpCgRKKmXWF6sV1yZm5yTopeXWrKJERgFKYWMVjsYt659r3eIUZKDSUmUl
  6v8dJwQX1J+SmVGYnFGfFFpTmrxIUYZDg4lCV65TqCcYFFqempFWmYOMCJh0hIcPEoivFldQG
  ne4oLE3OLMdIjUKUZFKXFeOWAcCwmAJDJK8+DaYEngEqOslDAvIwMDgxBPQWpRbmYJqvwrRnE
  ORiVh3j0g43ky80rgpr8CWswEtPjy+lMgi0sSEVJSDUwb9+RfcmHeuY3v6/EHGWH+UR8WlRw5
  WXKLZZbbBv3UFy9LBK8WFHDfejKlZMet34xJN9g2Vx9UXv5x20euC+9Ni8++udN37fenoicuh
  /UPrjnnfvVy1crb557xZm3OL64xZ+GJKdl64lZiedwq27LlayceqZvdf/WshpjVOsUzv8QD5u
  hXJ763lPt9qlRPoG4hw6qZFSs3lYWnHuQMmrdmXQbrQ/1pslvDWhWMWL9k7Vzpz1rzQ9d8dvm
  li1vtZCqmP2PU/2mfdXj5lubKXTaOHz7/StDI+7Uof2W3UHvXpYeb1qyznvG+fHW41vVvKTtT
  Ko44Nh7123Rx5R9+54bGl98m1GtuOsJ8adW8ielsukosxRmJhlrMRcWJAMfaget9AwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-36.tower-232.messagelabs.com!1590397920!627678!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 30111 invoked from network); 25 May 2020 09:12:01 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-36.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 25 May 2020 09:12:01 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 04P9BprI027707;
        Mon, 25 May 2020 10:11:51 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 5E9C920619;
        Mon, 25 May 2020 11:11:40 +0200 (CEST)
Subject: Re: [PATCH] scsi: target: tcmu: Fix a use after free in
 tcmu_check_expired_queue_cmd()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200523101129.GB98132@mwanda>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <68d6b1e9-65fa-e91c-e55e-f520839b5efe@ts.fujitsu.com>
Date:   Mon, 25 May 2020 11:11:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20200523101129.GB98132@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/23/20 12:11, Dan Carpenter wrote:
> The pr_debug() dereferences "cmd" after we already freed it by calling
> tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.
> 
> Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/target/target_core_user.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Thank you.

I'm very sorry for this stupid bug.

BR, Bodo
