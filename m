Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CA5C43215
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 18:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFDB220718
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 18:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=blockbridge-com.20150623.gappssmtp.com header.i=@blockbridge-com.20150623.gappssmtp.com header.b="sWeec0pq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfLBSm2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 13:42:28 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37294 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfLBSm1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 13:42:27 -0500
Received: by mail-oi1-f196.google.com with SMTP id x195so642362oix.4
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2019 10:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blockbridge-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4hnWxYJS6UwvHgZfL5C7ZAjZ6VkkzMMU7kmsT3ouMqc=;
        b=sWeec0pqiWKAQx6GsxOcoExatEOX6Ri6zErHouUpuNZpUk/3VfbcqEwSFH7asbdMSf
         d4f2fjQLHSCzDMPSVv4Cn/X9DfYRH+7UAPZPnqRzxcPG46x+TDGPpFyXwer35ezQhlJC
         cnsd6L+RkdSCVCJtC7novckEhsoBhoIBfGAkkLXORzSyiK36mGhxkTIyLbbuOI6iZPNM
         g/qHMLGvVlTGuNrea+fojo24uRyvurwCb4yjtIiMp71WlWOqRbVb349azrXNKpjzRmHK
         Cs9K6yF5HNIaOX3UyeOY/WPL1fGhP+Rl8wUvORPSkfMgAMmfnOzO4ApZlbRiDzwCDf4Y
         4XJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4hnWxYJS6UwvHgZfL5C7ZAjZ6VkkzMMU7kmsT3ouMqc=;
        b=pGxRm3MkMYVmnuwCXb6dNOjv+3epFmZ0GwyuHbEgCGU4brYBy19o9zGS5TQ2S8Pyts
         1a4E20cX3hZCSXppektfmCI3fD9VvRYB/IAVWMnV4OkPsJf7SpYQKCOy4PESQDg72tdg
         kadyrKURW92D+FHrDKe017Vty1dvwIj6uEJKYyX1rXVRZ7NTWTqhlXMQbkjwAs4pdkSd
         2AgtyjQ4PC6yBPKJAEgsPJYzTCnAK2oUq6oKRABSeGdghKy8gZhpKY+MDqpPtE88PA1m
         J8b69ucNzvAvrwAz7d0+2cSXxlmTY9X6mIodm0feAnnWlTXRSrALLv2SzbAlF3A+f7Nv
         LEWQ==
X-Gm-Message-State: APjAAAWZsx40CHIIvceqAGzc9FaRl1fetdKF5GLBtuH1E0f3eEts1NJU
        SfvG+A6ql8KvaycM3q3XA9aAFMV8YbPxmq8MQi+HQQ==
X-Google-Smtp-Source: APXvYqxtoqDm0j7pzYiqmwJ79qHV4hqM09C5CPP7ue5y+F2n1QpcowgAf6qc+AUIL/MdTjBqctZ4jZ5qS8oYDDkHW6c=
X-Received: by 2002:aca:4e90:: with SMTP id c138mr359970oib.147.1575312146080;
 Mon, 02 Dec 2019 10:42:26 -0800 (PST)
MIME-Version: 1.0
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p> <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p> <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p>
In-Reply-To: <20191128091210.GC15549@ming.t460p>
From:   Stephen Rust <srust@blockbridge.com>
Date:   Mon, 2 Dec 2019 13:42:15 -0500
Message-ID: <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Rob Townley <rob.townley@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

> I may get one machine with Mellanox NIC, is it easy to setup & reproduce
> just in the local machine(both host and target are setup on same machine)?

Yes, I have reproduced locally on one machine (using the IP address of
the Mellanox NIC as the target IP), with iser enabled on the target,
and iscsiadm connected via iser.

e.g.:
target:
/iscsi/iqn.20.../0.0.0.0:3260> enable_iser true
iSER enable now: True

  | |   o- portals
....................................................................................................
[Portals: 1]
  | |     o- 0.0.0.0:3260
...................................................................................................
[iser]

client:
# iscsiadm -m node -o update --targetname <target> -n
iface.transport_name -v iser
# iscsiadm -m node --targetname <target> --login
# iscsiadm -m session
iser: [3] 172.16.XX.XX:3260,1
iqn.2003-01.org.linux-iscsi.x8664:sn.c46c084919b0 (non-flash)

> Please try to trace bio_add_page() a bit via 'bpftrace ./ilo.bt'.

Here is the output of this trace from a failed run:

# bpftrace lio.bt
modprobe: FATAL: Module kheaders not found.
Attaching 3 probes...
512 76
4096 0
4096 0
4096 0
4096 76
512 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
4096 0
^C

@start[14475]: 0
@start[14384]: 0
@start[6764]: 0
@start[14477]: 0
@start[7771]: 0
@start[13788]: 0
@start[6879]: 0
@start[11842]: 0
@start[7765]: 0
@start[7782]: 0
@start[14476]: 0
@start[14385]: 0
@start[14474]: 0
@start[11564]: 0
@start[7753]: 0
@start[7786]: 0
@start[7791]: 0
@start[6878]: 0
@start[7411]: 0
@start[14473]: 0
@start[11563]: 0
@start[7681]: 0
@start[7756]: 0


Thanks,
Steve
