Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1253C2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 13:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7094E2072A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 13:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="joDEKDoq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgDHN0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 09:26:25 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.3]:39008 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727815AbgDHN0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 09:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1586352382; i=@ts.fujitsu.com;
        bh=ktILkN3JZOb0YkaEZN9Dwe5xP9pntvBMFkkQ/z4V0Tc=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=joDEKDoqE1g3SKEY8XSs9tz0I5LCKDDRw6XeslvZImb0LPY0STDBw5ihsYgcM7cgr
         o6bLXo7vTRP+4lE9F2/hwGy55wytYyg49UCo2XFNZP4WhRmdyfUHIbDl+X4RMLuJPM
         QxchgPvUE0oaVrSQ+UD6VEupUPjd1Uwx0Qd5SCCPw4cR7MqfwDVSYNSM+qXhCWuezF
         nvI5Tz5bWNr0zfX4d7CnWJjK0FmMdUFjVCCkc1thLi/unhoBUJj7QhnLp1Kd/uGLOq
         Ez7ZwALq2N3gIDKUEOgSt4pgnfAfdUHOEofU+vHLZvpRJuR7+5wbJfQa3DtAgZPcOi
         cFvqkbCqOK+7g==
Received: from [100.112.195.73] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-west-1.aws.symcld.net id 35/C9-36773-EF0DD8E5; Wed, 08 Apr 2020 13:26:22 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRWlGSWpSXmKPExsViZ8MRovvvQm+
  cweNz3Bbd13ewWSw//o/JYv2RDYwWrUvfMjmweHx8eovF4/2+q2wenzfJBTBHsWbmJeVXJLBm
  HJrPX9DPWPGml6+BsaSLkZNDSGASo8SNeyJdjFxA9nRGiT3fGtlAEmwCBhIrJt1nAbFFBGwk+
  g4vZQKxmQWMJZbe2AVWIyygJ7HvwQ4gm4ODRUBVYstVK5Awr4CdxIk5T1hBbAkBeYmOA5NZJj
  ByLmBkWMVonlSUmZ5RkpuYmaNraGCga2hopGtoaQyk9RKrdBP1Ukt1y1OLS3SB3PJiveLK3OS
  cFL281JJNjECvpxQc5N7B+GLte71DjJIcTEqivH9P9sYJ8SXlp1RmJBZnxBeV5qQWH2KU4eBQ
  kuDdfQ4oJ1iUmp5akZaZAwxAmLQEB4+SCK84SCtvcUFibnFmOkTqFKMxx90ncxcxc9wDkUIse
  fl5qVLivKnngUoFQEozSvPgBsEi4xKjrJQwLyMDA4MQT0FqUW5mCar8K0ZxDkYlYd4TZ4Gm8G
  TmlcDtewV0ChPQKdeSukFOKUlESEk1MOn1bq11yS5e6eZTYPe2PH7qzvgr3O84NpysqfkXcqD
  zjLNR6GWZMs5jT+++ff3izt9T11RPPI8Pvy/1SeJG6ruFOyYv5xbeprAwIeGQya4IhrAHB19b
  5NQ/sdC7ZKayaorZ5qVnzogffcjFcH96UeCUv7MPcFVar91+4pfcq2MBa34ERS1fwaESdVfy4
  zZ5+X+OoWddNrkmlPuZhRp39+2/1r1UmrP3zrG/6/q7NH1O8KwyYb3bsVjdOU3wpt9B7crNBb
  HJVe7rGS8GP5msx7b9lVJZ2dcZ+uYX2N6GdJyxt1uS1fcvqnWpv8OBafJzO+Pnr90mZs4RMdc
  iTygtXC3z1/TaXevlvTcorq11P6HEUpyRaKjFXFScCADsN9YjBwMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-18.tower-265.messagelabs.com!1586352381!715157!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 3172 invoked from network); 8 Apr 2020 13:26:22 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-18.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 8 Apr 2020 13:26:22 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 038DQFf5025492;
        Wed, 8 Apr 2020 14:26:15 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 904C0203DF;
        Wed,  8 Apr 2020 15:26:12 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, martin.petersen@oracle.com
Subject: [PATCH 0/2] target: small fixes in pr
Date:   Wed,  8 Apr 2020 15:26:08 +0200
Message-Id: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This small series is a resend of patches that already were
sent to target-devel only.

The patches fix two issues in target core pr handling.

