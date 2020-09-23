Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369B8C2D0A8
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 09:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C672137B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 09:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dupond.be header.i=@dupond.be header.b="SFl8Kep0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgIWJZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 05:25:43 -0400
Received: from apollo.dupie.be ([51.159.20.238]:54186 "EHLO apollo.dupie.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgIWJZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 05:25:43 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 05:25:42 EDT
Received: from [IPv6:2a02:a03f:fa89:ff01:be0d:d770:d9ac:6ca4] (unknown [IPv6:2a02:a03f:fa89:ff01:be0d:d770:d9ac:6ca4])
        by apollo.dupie.be (Postfix) with ESMTPSA id 0D9F41520EAE
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2020 11:17:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dupond.be; s=dkim;
        t=1600852649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ODTW5Xfe3y+UK/0lB7GRPsY1MowcEQMi6K9U2J5weHY=;
        b=SFl8Kep0U3cCLeuPYMj0BJVw/+VWXTRdNo/ELkR4dbyuhQk0ICNHhdUJ8W6FshcJMdeHPv
        1qdhwNBrCxCZM4ojR0xm5WFNbd/B3qIpVQZw7mc1Pd4YHKjv48g58zX+xGCx7VsO42VSDO
        4GLymNvDNXpiCoOvwjcSAXWrqCe3w6mNQSmyAZs0hKvVgX0ycR5TDqouWta3QV5YTqwZUn
        z48NXz4F3MeYolkO8hLxFMekAp5AZdvN3HuumOCJswMZd0Iv/7CzVVel3OqUkRLjui9CyK
        rkAlLcARvTqLJQnYvWw22SR5Jtix4k34fNz/ipgjXcd8Yo/SOBmdsB27SPTpkg==
To:     linux-scsi@vger.kernel.org
From:   Jean-Louis Dupond <jean-louis@dupond.be>
Subject: "Power-on or device reset occurred" after a LUN resize
Message-ID: <a87b6e6e-d35e-2336-4593-c28872760c75@dupond.be>
Date:   Wed, 23 Sep 2020 11:17:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Last week some action that we do regularly caused some issues.

00:50:31 CEST -> We resized a iSCSI LUN on a SAN from 3TB -> 4TB.

The clients did detect the change fine, and resized it devices:

> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: Capacity data has changed
> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: Inquiry data has changed
> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: alua: supports implicit 
> TPGS
> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: alua: device 
> t10.NETAPP   LUN 80Vcx]PVRq4F        port group 3e9 rel port 8
> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: Capacity data has changed
> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: [sdf] 8589934592 
> 512-byte logical blocks: (4.40 TB/4.00 TiB)
> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: [sdf] 4096-byte 
> physical blocks
> Sep 22 00:51:07 server001 kernel: sdf: detected capacity change from 
> 3298534883328 to 4398046511104
> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: alua: port group 3e9 
> state A non-preferred supports TolUsNA
> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: Inquiry data has changed
> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: alua: supports implicit 
> TPGS
> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: alua: device 
> t10.NETAPP   LUN 80Vcx]PVRq4F        port group 3e9 rel port 7
> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: [sdi] 8589934592 
> 512-byte logical blocks: (4.40 TB/4.00 TiB)
> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: [sdi] 4096-byte 
> physical blocks
> Sep 22 00:51:07 server001 kernel: sdi: detected capacity change from 
> 3298534883328 to 4398046511104
> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: alua: port group 3e9 
> state A non-preferred supports TolUsNA
> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: Capacity data has changed
> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: Inquiry data has changed
> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: alua: supports implicit 
> TPGS
> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: alua: device 
> t10.NETAPP   LUN 80Vcx]PVRq4F        port group 3e8 rel port 6
> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: [sdl] 8589934592 
> 512-byte logical blocks: (4.40 TB/4.00 TiB)
> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: [sdl] 4096-byte 
> physical blocks
> Sep 22 00:51:12 server001 kernel: sdl: detected capacity change from 
> 3298534883328 to 4398046511104
> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: alua: port group 3e8 
> state N non-preferred supports TolUsNA
> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: Capacity data has changed
> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: Inquiry data has changed
> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: alua: supports implicit 
> TPGS
> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: alua: device 
> t10.NETAPP   LUN 80Vcx]PVRq4F        port group 3e8 rel port 5
> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: [sdc] 8589934592 
> 512-byte logical blocks: (4.40 TB/4.00 TiB)
> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: [sdc] 4096-byte 
> physical blocks
> Sep 22 00:51:18 server001 kernel: sdc: detected capacity change from 
> 3298534883328 to 4398046511104
> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: alua: port group 3e8 
> state N non-preferred supports TolUsNA
> Sep 22 00:52:09 server001 kernel: sd 16:0:0:1: Power-on or device 
> reset occurred
> Sep 22 00:52:09 server001 kernel: sd 16:0:0:1: alua: port group 3e9 
> state A non-preferred supports TolUsNA
> Sep 22 00:52:09 server001 kernel: sd 17:0:0:1: Power-on or device 
> reset occurred

But then it kept doing resets:
> Sep 22 00:54:39 server001 kernel: sd 16:0:0:1: Power-on or device 
> reset occurred
> Sep 22 00:54:39 server001 kernel: sd 16:0:0:1: alua: port group 3e9 
> state A non-preferred supports TolUsNA
> Sep 22 00:54:39 server001 kernel: sd 17:0:0:1: Power-on or device 
> reset occurred
> Sep 22 00:54:39 server001 kernel: sd 17:0:0:1: alua: port group 3e9 
> state A non-preferred supports TolUsNA
> Sep 22 00:54:42 server001 kernel: sd 15:0:0:1: Power-on or device 
> reset occurred
> Sep 22 00:54:42 server001 kernel: sd 15:0:0:1: alua: port group 3e8 
> state N non-preferred supports TolUsNA

This caused some multipath failovers until it stopped after ~10 minutes.

We do use ALUA multipath:
3600a098038305663785d505652713446 dm-15 NETAPP,LUN C-Mode
size=4.0T features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 
alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| |- 16:0:0:1 sdf 8:80  active ready running
| `- 17:0:0:1 sdi 8:128 active ready running
`-+- policy='service-time 0' prio=10 status=enabled
   |- 15:0:0:1 sdc 8:32  active ready running
   `- 18:0:0:1 sdl 8:176 active ready running


Who is sending the Power-on or device reset?
Is that the SAN?
Or does the client trigger a reset (for which reason then?)?
The LUN is attachted to multiple servers (all CentOS 8), and all showed 
the same resets.

It would be nice to find out what caused this!

Thanks for having a look :)
Jean-Louis


