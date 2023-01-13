Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1040EC61DB3
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 09:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241047AbjAMJxz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 04:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbjAMJx1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 04:53:27 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C557CBDF
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 01:49:31 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230113094928epoutp04fcc8c4386147e09fb18da659c0fb9a71~51WVymwia1559715597epoutp04j
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 09:49:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230113094928epoutp04fcc8c4386147e09fb18da659c0fb9a71~51WVymwia1559715597epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673603368;
        bh=awrM2bJZO7LtG9l3RQfLlqNumwVGuuLUIwgvVOTQqe0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=c0/I+UPyftoeixxsDeYJNnsF/2sewo+8EzDLyuYXbEZTeLVSrDGaynvWWWKyNUnEn
         aiNsQkp5HvnkbT85dJmJjmSlGlJDKV3QRVCjan3HCUUuP18WXhiUssdsxE+nMu5sxb
         bq9gLhdzcRISdvlgucSvVXDaNtu6kZXcZkwISTi8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230113094927epcas5p2af36691c10b82688985b5750d2406323~51WVfDydW2142921429epcas5p26;
        Fri, 13 Jan 2023 09:49:27 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Ntc8614NLz4x9Pp; Fri, 13 Jan
        2023 09:49:26 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.92.62806.62921C36; Fri, 13 Jan 2023 18:49:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230113094723epcas5p2f6f81ca1ad85f4b26829b87f8ec301ce~51UiBNn0Z2258722587epcas5p2C;
        Fri, 13 Jan 2023 09:47:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230113094723epsmtrp2239a6b739f5245442ead204f5cc16bb9~51UiAkxrx2321423214epsmtrp2x;
        Fri, 13 Jan 2023 09:47:23 +0000 (GMT)
X-AuditID: b6c32a4a-ea5fa7000000f556-8e-63c129264f92
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.70.02211.BA821C36; Fri, 13 Jan 2023 18:47:23 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230113094722epsmtip16de26d811f7db4ecfce875daac59ca63~51UhIJVql0374603746epsmtip1i;
        Fri, 13 Jan 2023 09:47:22 +0000 (GMT)
From:   Nitesh Shetty <nj.shetty@samsung.com>
To:     lsf-pc@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Nitesh Shetty <nj.shetty@samsung.com>
Subject: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Date:   Fri, 13 Jan 2023 15:16:48 +0530
Message-Id: <20230113094648.15614-1-nj.shetty@samsung.com>
X-Mailer: git-send-email 2.35.1.500.gb896f729e2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsWy7bCmuq6a5sFkg8nrWS323tK2mL/sKbtF
        9/UdbBb7Xu9lttj2ez6zA6vH5iX1HpNvLGf06NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMZ7s/MhccFa9YP+8RUwPj
        N6EuRk4OCQETiZcP9jN1MXJxCAnsZpT4sL6LBcL5xCjx9N1RVgjnG6PElc097DAtJ588h6ra
        yyix99UqKKeZSWJq91OgKg4ONgFtidP/OUAaRARUJf6uPwJWwyzQwijx7+h3FpAaYQFXiXt3
        eEBqWIBqFiw7zQhi8wpYSaw+1sIKUiIhoC/Rf18QIiwocXLmExYQm1lAXqJ562xmkJESAtvY
        JU4uWcgEcZyLxMFTj1ggbGGJV8e3QB0tJfH53V42CLtcYuWUFWwQzUD3zLo+ixEiYS/Reqqf
        GWQxs4CmxPpd+hBhWYmpp9YxQSzmk+j9/QRqF6/EjnkwtrLEmvULoOZLSlz73ghle0gsn3UM
        7AYhgViJA29Osk5glJ+F5J9ZSP6ZhbB5ASPzKkbJ1ILi3PTUYtMCo7zUcnjEJufnbmIEJz4t
        rx2MDx980DvEyMTBeIhRgoNZSYR3z9H9yUK8KYmVValF+fFFpTmpxYcYTYFhPJFZSjQ5H5h6
        80riDU0sDUzMzMxMLI3NDJXEeVO3zk8WEkhPLEnNTk0tSC2C6WPi4JRqYHLdeUZQY69K/A+Z
        nUkm9SmfV5lujd2iFlA7JW6/uq7n0vS8g0x2mxjeu3/YtvXPMpULMx++Wp98wW3e8z5DFbOC
        pf0NCVFFfBIXJ2926um6v+fX0+0tP7mqbfN2GBg96djp67q8Yc2s+yWvGK2SXFfcLQ94cy7Q
        qv7dFo9FtV9FKtOq9//9EB7Ear9i4/T3BbkXP7HuZd3qV7b/wKH2fn+O+M0Plib135k97azB
        p4cPLivscNzSIj1pmZleuHNd1l2x9Yl7uLj5Oe+ait463lfhcTO4rFCTe9HDF+l1z9ZbWDz5
        9E/04YufF1VPn5oQmShxTHb2zekKCkX2xVsZK940V879ZKo+8cWzTHHmt3eUWIozEg21mIuK
        EwHC7/IOBQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsWy7bCSnO5qjYPJBod6DSz23tK2mL/sKbtF
        9/UdbBb7Xu9lttj2ez6zA6vH5iX1HpNvLGf06NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxn
        uz8yFxwVr1g/7xFTA+M3oS5GTg4JAROJk0+es3QxcnEICexmlLjaNI8VIiEpsezvEWYIW1hi
        5b/n7BBFjUwSr5bvBiri4GAT0JY4/Z8DpEZEQFXi7/ojYIOYBToYJVYvOcAMUiMs4Cpx7w4P
        SA0LUM2CZacZQWxeASuJ1cdawMZICOhL9N8XhAgLSpyc+YQFxGYWkJdo3jqbeQIj3ywkqVlI
        UgsYmVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgQHoJbmDsbtqz7oHWJk4mA8xCjB
        wawkwrvn6P5kId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODil
        Gpj2+f80q76dU3NC3yA/4+bNGzpVrw+s3pzGWGpaJ6ug8P+t0HvzOY+11PZYLVqunqR1+mrJ
        OpuXjTsYK+vTlhi+N3xxsWhZiXxcA2ck17VOq4q1auePNYlGrKlv1dqQUzeh6tAbCflVsqW3
        9xyJLRGUNY0JFRD0nKTybtGmkO7dDId+rWUxP+PXf+FRTgDLSYOcXYa1vStLshZ/eOV6oemk
        cVdhqXhNWOekrUc3izEf5jENb9BxXmx1w61x8cZEXym/zVP+7V6yUTc2+f5UwbO9EfV/ZI6G
        qj5s/2icGunxOszQnolTMqivuc2z7PijDAUJ4b63yVY8GSK3zxyY8kGducZ/+h+zvKV/xJlX
        KbEUZyQaajEXFScCACufZYqvAgAA
X-CMS-MailID: 20230113094723epcas5p2f6f81ca1ad85f4b26829b87f8ec301ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230113094723epcas5p2f6f81ca1ad85f4b26829b87f8ec301ce
References: <CGME20230113094723epcas5p2f6f81ca1ad85f4b26829b87f8ec301ce@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

Background:
===========
Copy offload is a feature that allows file-systems or storage devices
to be instructed to copy files/logical blocks without requiring
involvement of the local CPU.
We are working on copy offload[1], mainly focused on NVMe Copy command
(single NS, TP 4065) and NVMe over fabrics.
Previously Chaitanya Kulkarni presented talk on copy offload[2].

Current state of work:
======================
	Our latest patch series[1] covers
	1. Driver
		- NVMe Copy command (single NS, TP 4065), including support
		in nvme-target (for block and file back-end).

	2. Block layer
		- Block-generic copy (REQ_COPY flag), with interface
		accommodating two block-devs, and multi-source/destination
		interface
		- Emulation, when offload is natively absent
		- dm-linear support (for cases not requiring split)

	3. User-interface
		- new ioctl

	4. In-kernel user
		- dm-kcopyd
		
	5. Tools:
		- fio
		- blktests

	Performance:
	With the async design of copy-emulation/offload using fio[3],
	we were  able to see the following improvements as
	compared to userspace read and write on a NVMeOF TCP setup:
	Setup1: Network Speed: 1000Mb/s
		Host PC: Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz
		Target PC: AMD Ryzen 9 5900X 12-Core Processor
		block size 8k, range 1:
			635% improvement in IO BW (107 MiB/s to 787 MiB/s).
			Network utilisation drops from  97% to 14%.
		block-size 2M, range 16:
			2555% improvement in IO BW (100 MiB/s to 2655 MiB/s).
			Network utilisation drops from 89% to 0.62%.
	Setup2: Network Speed: 100Gb/s
		Server: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz, 72 cores
			(host and target have the same configuration)
		block-size 8k, range 1:
			6.5% improvement in IO BW (791 MiB/s to 843 MiB/s).
			Network utilisation drops from  6.75% to 0.14%.
		block-size 2M, range 16:
			15% improvement in IO BW (1027 MiB/s to 1183 MiB/s).
			Network utilisation drops from 8.42% to ~0%.
	Overall, in these tests, kernel copy emulation reduces network utilisation
	drastically and improves IO bandwidth.

What we will discuss in the proposed session ?
==============================================
Through this session I would like to discuss and get opinion of community
on minimum set of requirement for copy offload for this phase. Also share
some of the blockers we are facing and would get opinion on how we can
proceed further.

Required attendees:
===================
	Martin K. Petersen
	Jens Axboe
	Christoph Hellwig
	Mike Snitzer
	Hannes Reinecke
	Chaitanya Kulkarni
	Bart Van Assche
	Damien Le Moal
	Mikulas Patocka
	Keith Busch
	Sagi Grimberg
	Javier Gonzalez
	Kanchan Joshi

Links:
======
[1] https://lore.kernel.org/lkml/20230112115908.23662-1-nj.shetty@samsung.com/T/#m91a2f506eaa214035a8596fa9aa8d2b9f46654cc
[2] https://lore.kernel.org/all/BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com/
[3] https://github.com/vincentkfu/fio/tree/copyoffload

