Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C59C55199
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2E9206BF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="rT0996qB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgD0PIj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:08:39 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.114]:44634 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728151AbgD0PIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 11:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1588000115; i=@ts.fujitsu.com;
        bh=mot6rwa2pu6rYR87VBC76TS1KVdEXCdzKIm7GxDPoGA=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=rT0996qBBkR5YKqGQtjItC45dBikCsFp1rVna6+Ax0RgWIO5586uWEZrOxYIUEgFE
         TLngLaNYzaj18wNIHntGoSxfySEJdM0xCxltod2QFuc9RmvbLr1Q2CuMPuaKnBnJH3
         856T+NrEsHAfBIwYCwdxd/KnjqgZiBL21YDm3Xsfc5AmlQywR033CXNyCdiQFhLpMh
         BKJJmYBjjU1gJjdGkWvUu8Kr5Q50tqx8FKk389oH+JBNrxYCrK8Z7oP2O7R2OC7Yw9
         1UDFtT1oi0qfpIDFHbAJLNKHmZxPWG4xLTkmS4qdqaru2S0X1uBC7NOhSgcxac53tV
         JK9EbN0SNmgyw==
Received: from [100.113.6.103] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-central-1.aws.symcld.net id 01/80-40390-375F6AE5; Mon, 27 Apr 2020 15:08:35 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MRqlv8dVm
  cwZc2JYuv/6ezWKxcfZTJovv6DjaL5cf/MVmsP7KB0aJ16VsmBzaP3Tcb2Dw+Pr3F4vF+31U2
  j82nqz0+b5ILYI1izcxLyq9IYM3YefoUe8ENpoqFZw+wNTDOZupi5OIQEpjMKNG/6iIjhDOdU
  WLusyfMXYycHGwCBhIrJt1nAbFFBGwk+g4vZQKxmQX8JNZ9OQZWIyzgJvFswQowm0VAVaLn/B
  w2EJtXwE7i1cmVjCC2hIC8RMeBySwTGDkXMDKsYrRIKspMzyjJTczM0TU0MNA1NDTWNdG1MNd
  LrNJN0kst1U1OzSspSgRK6iWWF+sVV+Ym56To5aWWbGIEhklKIUv4Dsady9/rHWKU5GBSEuU9
  uXpZnBBfUn5KZUZicUZ8UWlOavEhRhkODiUJ3qmfgXKCRanpqRVpmTnAkIVJS3DwKInwJnwBS
  vMWFyTmFmemQ6ROMSpKifPagSQEQBIZpXlwbbA4ucQoKyXMy8jAwCDEU5BalJtZgir/ilGcg1
  FJmHcWyHaezLwSuOmvgBYzAS2ukl8MsrgkESEl1cB0alfWgiN2CyafS/jQ++3HBAOTvhOdZxP
  YzNOuTAw8vujlNG7jHRfVqhXyvN1u+HFv3tH+ImDxsetO8zrDao+q14ba2W50Prwyr7lgNlub
  zqVyHsa/fo/nyC30Z2XJEJ3d/S337/yqmNgNOxVnWj8OceU8nORy7aFM3vbEPf+qcrvj7L4p6
  /rNmNMlt79WymL/+++sMw5Gb/hw0JhHKLrIUYTBMCpI6OyWQ0JS/Ay/591Jyl+9nnVGq/6L9x
  yGb7Ycr/08Y0pcquCufL8fjfIrli6/wP5Bcvq1ZR7rU3XbypRYc9/r3/7nsUb51ZqZuy6//9F
  fKfDm16ZLXLovlh2f2Gx86tT6NXuYWu60cbqtUWIpzkg01GIuKk4EAMhXGcgOAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-28.tower-238.messagelabs.com!1588000115!62995!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5286 invoked from network); 27 Apr 2020 15:08:35 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-28.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 27 Apr 2020 15:08:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 03RF8XVF025008;
        Mon, 27 Apr 2020 16:08:33 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id DAB6120665;
        Mon, 27 Apr 2020 17:08:25 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, ddiss@suse.de, hch@lst.de,
        martin.petersen@oracle.com
Subject: [PATCH 0/4] target: tcmu: allow flexible pr and alua handling
Date:   Mon, 27 Apr 2020 17:08:19 +0200
Message-Id: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches already were sent to target-devel only. So I'm resending
them now, slightly modified according to review comments from
target-devel.

The goal of the patches is to add more flexibility to tcmu regarding
PGR handling.

Since the attribute emulate_pr is missing for pscsi in the same way as
for tcmu, I'm adding it to pscsi also. 

